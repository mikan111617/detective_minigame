/*
 * i18n.js ―― ダウトミニゲームを日本語／英語で遊べるようにする実行時レイヤ。
 *
 * 仕組みはひとつだけ。「ソースの1行を、訳文の1行にまるごと差し替える」。
 * 差し替え表は data/others/lang/<lang>/ 以下に、data/ からの相対パスで置く。
 *
 *   data/scenario/scene1.ks  ->  data/others/lang/en/scenario/scene1.ks.json
 *   data/others/hint_room.js ->  data/others/lang/en/others/hint_room.js.json
 *
 * 表の形（tools/i18n_extract.py が生成する）:
 *   { "src": "data/scenario/scene1.ks",
 *     "lines": [ [27, "原文の行", "translated line"], ... ] }
 *
 * 行番号は目安で、必ず原文と突き合わせてから差し替える。原文が動いていれば
 * ファイル内をもう一度探すので、シナリオを直しても崩れない。
 *
 * index.html から、tyrano 一式のあとに読み込むこと。
 * $.loadText（シナリオ／HTML）と [loadjs]（JS）の両方に入る。
 */
(function () {
    "use strict";

    var LANG_KEY = "maiguro_lang";
    var DEFAULT_LANG = "ja";
    var SUPPORTED = ["ja", "en"];

    var state = {
        lang: DEFAULT_LANG,
        index: null,        // { "scenario/scene1.ks": true, ... }
        dicts: {},          // relpath -> { byLine: {}, byText: {} }
        pending: {},        // relpath -> [callback, ...]
        ui: {},             // 実行時に組み立てる文言（lang/<lang>/ui.json）
    };

    // ---------------------------------------------------------------- 言語

    function readStoredLang() {
        try {
            var v = window.localStorage.getItem(LANG_KEY);
            if (v && SUPPORTED.indexOf(v) >= 0) return v;
        } catch (e) {}
        return DEFAULT_LANG;
    }

    function writeStoredLang(lang) {
        try {
            window.localStorage.setItem(LANG_KEY, lang);
        } catch (e) {}
    }

    state.lang = readStoredLang();

    function isEN() {
        return state.lang === "en";
    }

    // ------------------------------------------------------------ 辞書の取得

    // data/... の絶対／相対パスを lang ディレクトリ内の相対キーに直す。
    // 例: "./data/scenario/scene1.ks?4213" -> "scenario/scene1.ks"
    function toKey(filePath) {
        var path = String(filePath || "").split("?")[0].split("#")[0];
        path = path.replace(/\\/g, "/");
        var at = path.indexOf("/data/");
        if (at >= 0) {
            path = path.substring(at + 6);
        } else if (path.indexOf("data/") === 0) {
            path = path.substring(5);
        } else if (path.indexOf("./data/") === 0) {
            path = path.substring(7);
        } else {
            return "";
        }
        // "../../../data/others/foo.js" のような上り階層も上で吸収できている
        while (path.indexOf("./") === 0) path = path.substring(2);
        return path;
    }

    function langDir() {
        return "./data/others/lang/" + state.lang + "/";
    }

    // ティラノ本体が出す文言（「保存されているデータがありません」など）は
    // data/others/lang/<lang>.json の systems に入っている。本体の慣習どおりの
    // 置き場所なので、そこから読んで window.tyrano_lang.word へ被せる。
    var systemWordsLoaded = false;

    function loadSystemWords() {
        if (systemWordsLoaded || !isEN()) return;
        systemWordsLoaded = true;
        $.ajax({
            url: "./data/others/lang/" + state.lang + ".json?" + Date.now(),
            dataType: "json",
            cache: false,
        })
            .done(function (data) {
                if (data && data.systems && window.tyrano_lang && window.tyrano_lang.word) {
                    for (var key in data.systems) {
                        window.tyrano_lang.word[key] = data.systems[key];
                    }
                }
            })
            .fail(function () {
                console.warn("[i18n] システム文言を読めませんでした:", state.lang);
            });
    }

    function loadIndex(done) {
        if (state.index) {
            done();
            return;
        }
        if (!isEN()) {
            state.index = {};
            done();
            return;
        }
        $.ajax({
            url: langDir() + "index.json?" + Date.now(),
            dataType: "json",
            cache: false,
        })
            .done(function (data) {
                var map = {};
                var files = (data && data.files) || [];
                for (var i = 0; i < files.length; i++) map[files[i]] = true;
                state.index = map;
                state.ui = (data && data.ui) || {};
            })
            .fail(function () {
                console.warn("[i18n] index.json を読めませんでした:", langDir());
                state.index = {};
            })
            .always(done);
    }

    function buildDict(data) {
        var byLine = {};
        var byText = {};
        var dup = {};
        var lines = (data && data.lines) || [];
        for (var i = 0; i < lines.length; i++) {
            var row = lines[i];
            if (!row || row.length < 3) continue;
            var no = row[0], ja = row[1], en = row[2];
            if (!en || en === ja) continue;   // 未訳・変更不要はそのまま流す
            byLine[no] = [ja, en];
            if (Object.prototype.hasOwnProperty.call(byText, ja)) {
                if (byText[ja] !== en) dup[ja] = true;   // 同じ原文で訳が割れている
            } else {
                byText[ja] = en;
            }
        }
        for (var k in dup) delete byText[k];
        return { byLine: byLine, byText: byText };
    }

    function loadDict(key, done) {
        if (state.dicts[key] !== undefined) {
            done(state.dicts[key]);
            return;
        }
        if (state.pending[key]) {
            state.pending[key].push(done);
            return;
        }
        state.pending[key] = [done];

        var finish = function (dict) {
            state.dicts[key] = dict;
            var waiting = state.pending[key] || [];
            delete state.pending[key];
            for (var i = 0; i < waiting.length; i++) waiting[i](dict);
        };

        $.ajax({
            url: langDir() + key + ".json?" + Date.now(),
            dataType: "json",
            cache: false,
        })
            .done(function (data) {
                finish(buildDict(data));
            })
            .fail(function () {
                console.warn("[i18n] 辞書を読めませんでした:", key);
                finish(null);
            });
    }

    // ---------------------------------------------------------- 本体の差し替え

    function applyDict(dict, text) {
        if (!dict) return text;
        var crlf = text.indexOf("\r\n") >= 0;
        var lines = text.split(/\r?\n/);
        var used = {};
        var missed = [];

        // まず行番号で当てる。原文が一致した行だけ差し替える。
        for (var no in dict.byLine) {
            var idx = parseInt(no, 10) - 1;
            var pair = dict.byLine[no];
            if (idx >= 0 && idx < lines.length && lines[idx] === pair[0]) {
                lines[idx] = pair[1];
                used[no] = true;
            } else {
                missed.push(pair);
            }
        }

        // 行がずれていた分は、同じ本文を探して当て直す。
        for (var i = 0; i < missed.length; i++) {
            var ja = missed[i][0];
            var en = missed[i][1];
            if (dict.byText[ja] !== en) continue;   // 訳が割れている原文は触らない
            var hit = false;
            for (var j = 0; j < lines.length; j++) {
                if (lines[j] === ja) {
                    lines[j] = en;
                    hit = true;
                }
            }
            if (!hit) {
                console.warn("[i18n] 原文が見つかりません:", ja);
            }
        }

        return lines.join(crlf ? "\r\n" : "\n");
    }

    // path のファイル内容 text を翻訳して callback に渡す。
    function translate(filePath, text, callback) {
        if (!isEN() || typeof text !== "string" || !text) {
            callback(text);
            return;
        }
        var key = toKey(filePath);
        if (!key) {
            callback(text);
            return;
        }
        loadIndex(function () {
            if (!state.index[key]) {
                callback(text);
                return;
            }
            loadDict(key, function (dict) {
                callback(applyDict(dict, text));
            });
        });
    }

    // ---------------------------------------------------------- フックの取り付け

    // 1) シナリオ(.ks)とシステムHTMLは $.loadText を通る
    var origLoadText = $.loadText;
    $.loadText = function (filePath, callback) {
        origLoadText(filePath, function (text) {
            translate(filePath, text, callback);
        });
    };

    // 2) [loadjs] で読む JS も、同じ差し替え表を通す
    function hookLoadJs() {
        var tag = window.tyrano && window.tyrano.plugin && window.tyrano.plugin.kag
            && window.tyrano.plugin.kag.tag && window.tyrano.plugin.kag.tag.loadjs;
        if (!tag || tag.__i18n_hooked) return;
        tag.__i18n_hooked = true;
        var origStart = tag.start;
        tag.start = function (pm) {
            var that = this;
            if (!isEN() || pm.type === "module" || $.isHTTP(pm.storage)) {
                origStart.call(that, pm);
                return;
            }
            var relative = "others/" + pm.storage;
            loadIndex(function () {
                if (!state.index[relative]) {
                    origStart.call(that, pm);
                    return;
                }
                $.ajax({
                    url: "./data/" + relative + "?" + Date.now(),
                    dataType: "text",
                    cache: false,
                })
                    .done(function (code) {
                        loadDict(relative, function (dict) {
                            try {
                                $.globalEval(applyDict(dict, code));
                            } catch (e) {
                                console.error("[i18n] " + relative + " の実行に失敗しました", e);
                            }
                            that.kag.ftag.nextOrder();
                        });
                    })
                    .fail(function () {
                        console.warn("[i18n] " + relative + " を読めませんでした。原文で読み込みます。");
                        origStart.call(that, pm);
                    });
            });
        };
    }

    // 3) 英語では、1文字ずつの span が単語の途中で折り返さないようにまとめる
    function hookWordWrap() {
        var textTag = window.tyrano && window.tyrano.plugin && window.tyrano.plugin.kag
            && window.tyrano.plugin.kag.tag && window.tyrano.plugin.kag.tag.text;
        if (!textTag || textTag.__i18n_hooked) return;
        textTag.__i18n_hooked = true;
        var origBuild = textTag.buildMessageHTML;
        textTag.buildMessageHTML = function (messageStr, shouldUseInlineBlock) {
            var html = origBuild.call(this, messageStr, shouldUseInlineBlock);
            if (!isEN()) return html;
            return groupLatinWords(html);
        };
    }

    // 1文字 = 1つの span。英字が続く範囲を inline-block でくるむと、
    // 折り返しが単語の切れ目でだけ起きるようになる。
    // .char は find(".char") で拾われるので、入れ子にしても本文送りは壊れない。
    var WORD_CHAR = /[0-9A-Za-zÀ-ɏ'’\u2010-\u2015\-]/;
    // 語のうしろに付いて離れない字（句読点・閉じ括弧・ダッシュ）
    var TRAIL_CHAR = /[.,!?;:)\]}”’"'…\u2013\u2014\u2015%]/;
    // 語のまえに付く字（開き括弧・開き引用符）
    var LEAD_CHAR = /[(\[{“‘"'¿¡$£€#]/;

    function groupLatinWords(html) {
        if (!/[A-Za-z]/.test(html)) return html;
        var box = document.createElement("span");
        box.innerHTML = html;
        var nodes = Array.prototype.slice.call(box.childNodes);
        var run = [];

        var flush = function () {
            if (run.length < 2) {
                run = [];
                return;
            }
            var wrap = document.createElement("span");
            wrap.style.display = "inline-block";
            run[0].parentNode.insertBefore(wrap, run[0]);
            for (var i = 0; i < run.length; i++) wrap.appendChild(run[i]);
            run = [];
        };

        for (var i = 0; i < nodes.length; i++) {
            var node = nodes[i];
            var text = node.textContent || "";
            var single =
                node.nodeType === 1 &&
                text.length === 1 &&
                node.querySelector("ruby") === null;
            if (single && WORD_CHAR.test(text)) {
                run.push(node);
            } else if (single && run.length && TRAIL_CHAR.test(text)) {
                run.push(node);
            } else if (single && LEAD_CHAR.test(text)) {
                flush();
                run.push(node);
            } else {
                flush();
            }
        }
        flush();
        return box.innerHTML;
    }

    // 4) 英語では日本語向けの字詰め設定を外す
    function applyLangStyle() {
        var id = "i18n-lang-style";
        var el = document.getElementById(id);
        if (!isEN()) {
            if (el && el.parentNode) el.parentNode.removeChild(el);
            document.documentElement.setAttribute("data-lang", state.lang);
            return;
        }
        document.documentElement.setAttribute("data-lang", "en");
        if (el) return;
        el = document.createElement("style");
        el.id = id;
        el.textContent =
            ".message_inner,.message_inner p,.vchat-text,.backlog_text{" +
            "word-break:normal;line-break:auto;overflow-wrap:break-word;}" +
            ".chara_name_area,.chara_name_text{white-space:nowrap;}";
        document.head.appendChild(el);
    }

    // 5) セーブから戻ってきた文字列を、いまの言語に貼り直す
    //
    // セーブデータには、そのとき画面に出していた文字列がそのまま入っている。
    //   f.master_data       … 手帳の品名・説明
    //   f.INV_DATA          … 章データの部屋名・調査ポイント名
    //   f.hud_place         … HUD の場所名
    //   stat.charas[].jname … 名前プレート
    // ロードは stat をまるごと差し替えるので、言語を変えて再開すると
    // ここだけ保存時の言語のまま残り、画面の中で日本語と英語が混ざる。
    // 原文↔訳文の対応表（lang/en/strings.json）で貼り直して揃える。

    var strings = null;
    var stringsPending = [];
    var stringsAsked = false;

    function loadStrings(done) {
        if (strings) {
            if (done) done();
            return;
        }
        if (done) stringsPending.push(done);
        if (stringsAsked) return;
        stringsAsked = true;
        $.ajax({
            url: "./data/others/lang/en/strings.json?" + Date.now(),
            dataType: "json",
            cache: false,
        })
            .done(function (data) {
                strings = data || {};
            })
            .fail(function () {
                console.warn("[i18n] 文字列対応表を読めませんでした");
                strings = {};
            })
            .always(function () {
                var queue = stringsPending;
                stringsPending = [];
                for (var i = 0; i < queue.length; i++) queue[i]();
            });
    }

    // 中身がコードやファイル名の項目は、見た目が同じでも触らない
    var KEEP_KEYS = {
        id: 1, roomId: 1, image: 1, storage: 1, dir: 1, bg: 1, mapBg: 1, face: 1,
        target: 1, hubTarget: 1, dispatchTarget: 1, destVar: 1, floorVar: 1,
        cond: 1, reveal: 1, exp: 1, se: 1, sefile: 1, icon: 1, src: 1, file: 1,
    };

    // 引き当ての順番は
    //   1. 定義ファイルごとの表（同じ語の訳し分けは、まずここで決まる）
    //   2. 項目名つきの表（name:"メアリー" は Mary、occupant:"メアリー" は Mary King）
    //   3. 全体の表
    function lookup(scope, key, value) {
        var dir = isEN() ? "ja2en" : "en2ja";
        var sc = strings.scoped && strings.scoped[scope];
        if (sc && sc[dir] && sc[dir][value] !== undefined) return sc[dir][value];
        var byKey = strings[isEN() ? "byKeyJa2en" : "byKeyEn2ja"];
        if (key && byKey && byKey[key + "::" + value] !== undefined) {
            return byKey[key + "::" + value];
        }
        var all = strings[dir];
        if (all && all[value] !== undefined) return all[value];
        return undefined;
    }

    function relocalize(scope, obj, seen, depth) {
        if (!obj || typeof obj !== "object" || depth > 12) return;
        if (seen.indexOf(obj) >= 0) return;
        seen.push(obj);
        for (var key in obj) {
            var v;
            try {
                v = obj[key];
            } catch (e) {
                continue;
            }
            if (typeof v === "string") {
                if (KEEP_KEYS[key]) continue;
                var hit = lookup(scope, key, v);
                if (hit !== undefined) {
                    try {
                        obj[key] = hit;
                    } catch (e) {}
                }
            } else if (v && typeof v === "object") {
                relocalize(scope, v, seen, depth + 1);
            }
        }
    }

    // セーブがどちらの言語で保存されたか。目印が無い古いセーブは中身から判る。
    function savedLang(stat) {
        var f = stat.f || {};
        if (f._lang === "ja" || f._lang === "en") return f._lang;
        var sample = "";
        try {
            sample = (stat.charas && stat.charas.mahoru && stat.charas.mahoru.jname) || "";
            if (!sample && f.master_data && f.master_data[0]) sample = f.master_data[0].name || "";
        } catch (e) {}
        return /[\u3040-\u30ff\u3400-\u9fff]/.test(sample) ? "ja" : "en";
    }

    function relocalizeStat() {
        var kag = window.TYRANO && window.TYRANO.kag;
        if (!kag || !kag.stat || !strings) return;
        var stat = kag.stat;
        var f = stat.f;
        if (!f) return;
        if (savedLang(stat) === state.lang) {
            f._lang = state.lang;
            return;
        }
        var seen = [];
        relocalize("chara", stat.charas, seen, 0);
        relocalize("items", f.master_data, seen, 0);
        if (f.INV_DATA) {
            relocalize("s4", f.INV_DATA.s4, seen, 0);
            relocalize("s7", f.INV_DATA.s7, seen, 0);
        }
        relocalize("", f, seen, 0);
        f._lang = state.lang;
        // HUD は f.hud_place を見て組み立てているので、貼り直したら描き直す
        try {
            if (window.MSGUI && window.MSGUI.render) window.MSGUI.render();
        } catch (e) {}
    }

    function hookLoad() {
        var kag = window.TYRANO && window.TYRANO.kag;
        if (!kag || !kag.menu || kag.menu.__i18n_hooked) return;
        kag.menu.__i18n_hooked = true;
        var origLoad = kag.menu.loadGameData;
        kag.menu.loadGameData = function () {
            var ret = origLoad.apply(this, arguments);
            loadStrings(function () {
                relocalizeStat();
                // レイヤの復元は少し遅れて終わるので、そのあともう一度合わせる
                setTimeout(relocalizeStat, 300);
            });
            return ret;
        };
    }

    // ------------------------------------------------------------- 公開API

    function clearCaches() {
        var kag = window.TYRANO && window.TYRANO.kag;
        if (!kag) return;
        kag.cache_scenario = {};
        kag.cache_html = {};
    }

    var I18N = {
        get lang() {
            return state.lang;
        },
        isEN: isEN,
        isJA: function () {
            return state.lang === "ja";
        },
        supported: SUPPORTED.slice(),

        // 実行時に組み立てる短い文言（ui.json）。未登録なら日本語のまま返す。
        t: function (ja) {
            if (!isEN()) return ja;
            var hit = state.ui && state.ui[ja];
            return hit ? hit : ja;
        },

        // 言語を切り替える。読み込み済みのシナリオは全部捨てて読み直させる。
        setLang: function (lang, done) {
            if (SUPPORTED.indexOf(lang) < 0) lang = DEFAULT_LANG;
            if (lang === state.lang) {
                if (done) done();
                return;
            }
            state.lang = lang;
            state.index = null;
            state.dicts = {};
            state.ui = {};
            writeStoredLang(lang);
            clearCaches();
            applyLangStyle();
            syncGameVariables();
            loadIndex(function () {
                if (done) done();
            });
        },

        // 言語切替時にゲーム側の言語フラグを同期する。
        syncGameVariables: function () {
            syncGameVariables();
        },

        translate: translate,
        _state: state,
    };

    function syncGameVariables() {
        var kag = window.TYRANO && window.TYRANO.kag;
        if (!kag || !kag.variable) return;
        var sf = kag.variable.sf;
        if (!sf) return;
        sf._lang = state.lang;
        // セーブ側にも印を残す。ロードのとき、保存時の言語と違えば貼り直す。
        if (kag.stat && kag.stat.f) kag.stat.f._lang = state.lang;
        // このミニゲームでは英語音声にも対応するため、言語で音声を無効化しない。
        try {
            kag.saveSystemVariable();
        } catch (e) {}
    }

    window.I18N = I18N;

    // KAG の初期化が済んでからでないと触れないものは、ここでまとめて入れる。
    function install() {
        loadSystemWords();
        hookLoadJs();
        hookWordWrap();
        hookLoad();
        applyLangStyle();
        syncGameVariables();
    }

    if (window.tyrano && window.tyrano.plugin && window.tyrano.plugin.kag) {
        hookLoadJs();
        hookWordWrap();
    }
    $(function () {
        install();
        // 変数の復元は初期化の中ほどで走るので、少し遅らせてもう一度合わせる。
        setTimeout(install, 300);
    });

    // 起動時に索引とシステム文言を先読みしておく
    loadSystemWords();
    loadIndex(function () {});
})();
