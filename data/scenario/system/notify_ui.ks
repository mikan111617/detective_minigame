;===============================================================================
; notify_ui.ks — 画面中央に額装カードで出す「報せ」
;
; 旧 notify_show プラグイン（右上に積み上がるトースト）の置き換え。
;
;   [notify_profile ids="chara_01,chara_02,chara_10"]
;       人物ファイルの解放を報せる。
;       ids を複数渡すと 1 枚のカードにまとめて並べ、1 人だけのときは
;       肖像を大きく見せる組みに自動で切り替わる。
;       表示名と肖像は f.master_data から引くので、英語版でも自動で切り替わる。
;
;   [notify_info text="入館記録書を入手しました。"]
;       肖像のない報せ。text をそのまま見出しの下に置く。
;
; 共通の引数：
;   hold … 自動で閉じるまでのミリ秒（既定 4200）。"false" を渡すと自動では閉じない。
;
; どちらもカードを閉じるまで本編を止める（[s]）。クリックか時間経過で閉じ、
; 閉じたところで本編が再開する。
;===============================================================================

[iscript]
window.NOTIFY = {

    TITLE: "'Waosagi',serif",
    BODY:  "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",

    // 画面に出す文言（英語版は i18n の差し替え表で入れ替わる）
    W: {
        profile_title: "人物ファイル 解放",
        profile_one:   "プロフィールを解放しました。",
        profile_many:  "名のプロフィールを解放しました。",
        info_title:    "お知らせ",
        close:         "クリックで閉じる"
    },

    ICON:    "./data/image/siryou.png",
    IMG_DIR: "./data/fgimage/chara/",

    // 開いているカードを閉じたときに本編を再開するかどうか
    waiting: false,

    // tyrano.plugin.kag は雛形なので、実際に動いている TYRANO.kag を使う
    kag: function () {
        return window.TYRANO.kag;
    },

    base: function () {
        return document.getElementById("tyrano_base") || document.body;
    },

    css: function () {
        if (document.getElementById("notify-card-css")) { return; }
        var st = document.createElement("style");
        st.id = "notify-card-css";
        st.textContent =
              "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}"
            + "@keyframes nzScrim{from{opacity:0}to{opacity:1}}"
            + "@keyframes nzCard{from{opacity:0;transform:scale(.94) translateY(14px)}to{opacity:1;transform:none}}"
            + "@keyframes nzRule{from{transform:scaleX(0)}to{transform:scaleX(1)}}"
            + "@keyframes nzRise{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:none}}"
            + "@keyframes nzOut{from{opacity:1}to{opacity:0}}"
            + "#notify-card.out{animation:nzOut .24s ease-in forwards}";
        document.head.appendChild(st);
    },

    // 六角形の額に収めた肖像 1 枚
    portrait: function (person, w, nameSize) {
        var h  = Math.round(w * 272 / 236);
        var iw = w - 10;
        var ih = h - 10;
        var hex = "polygon(50% 0,100% 25%,100% 75%,50% 100%,0 75%,0 25%)";
        var art = person.image
            ? '<img class="nz-face" src="' + this.IMG_DIR + person.image + '" '
                + 'style="width:100%;height:100%;object-fit:cover;object-position:50% 6%">'
            : '<div style="margin:auto;font-family:' + this.TITLE + ';font-size:' + Math.round(w / 3) + 'px;color:#6d5a33">？</div>';
        return ''
            + '<div style="display:flex;flex-direction:column;align-items:center;gap:20px">'
              + '<div style="width:' + w + 'px;height:' + h + 'px;background:linear-gradient(180deg,#d5b06c,#8a6a30);'
                + 'clip-path:' + hex + ';display:flex;align-items:center;justify-content:center">'
                + '<div style="width:' + iw + 'px;height:' + ih + 'px;background:#241708;clip-path:' + hex + ';'
                  + 'overflow:hidden;display:flex">' + art + '</div>'
              + '</div>'
              + '<div class="nz-name" data-max="' + (w + 40) + '" '
                + 'style="max-width:' + (w + 40) + 'px;white-space:nowrap;text-align:center;'
                + 'font-family:' + this.TITLE + ';font-size:' + nameSize + 'px;line-height:1.18;'
                + 'letter-spacing:.14em;color:#F6E4B4">' + person.name + '</div>'
            + '</div>';
    },

    // 名前が額の幅に収まらないときの後始末。
    // 空白があるもの（英語名など）は空白で折り返し、
    // 途中で切ると読みにくい続き文字（「メアリー・キング」など）は級数を落とす。
    fitNames: function (root) {
        var labels = root.querySelectorAll(".nz-name");
        for (var i = 0; i < labels.length; i++) {
            var el = labels[i];
            var max = parseInt(el.getAttribute("data-max"), 10);
            if (!max || el.scrollWidth <= max) { continue; }
            if (/\s/.test(el.textContent)) {
                el.style.whiteSpace = "normal";
                continue;
            }
            var size = parseInt(el.style.fontSize, 10);
            while (size > 20 && el.scrollWidth > max) {
                size -= 1;
                el.style.fontSize = size + "px";
            }
        }
    },

    // カードを開く。
    //   opt.title  … 見出し
    //   opt.people … { name, image } の配列（省略可）
    //   opt.lead   … 肖像の下（1人）／上（複数）に置く一文
    //   opt.hold   … 自動で閉じるまでのミリ秒。"false" なら自動では閉じない
    //   opt.wait   … 閉じたときに本編を再開するか
    open: function (opt) {
        var N = window.NOTIFY;
        N.css();

        var people = opt.people || [];
        var n = people.length;
        var single = (n === 1);
        var cardW = (n === 0) ? 980 : (single ? 820 : 1180);
        var padX  = single ? 60 : 74;

        // 肖像の大きさ。4 人以上になっても枠からはみ出さないように詰める
        var gap = (n <= 3) ? 64 : 40;
        var boxW = 236;
        if (n >= 2) {
            var avail = cardW - padX * 2;
            boxW = Math.min(236, Math.floor((avail - (n - 1) * gap) / n));
        }

        var body = '';
        if (single) {
            var p = people[0];
            body += '<div style="display:flex;justify-content:center;margin-top:42px;animation:nzRise .4s .22s ease-out both">'
                  + N.portrait(p, 300, 44)
                  + '</div>';
            if (opt.lead) {
                body += '<div style="margin:26px ' + padX + 'px 0;text-align:center;font-size:36px;line-height:1.45;'
                      + 'letter-spacing:.04em;color:#F4EAD6;animation:nzRise .34s .3s ease-out both">' + opt.lead + '</div>';
            }
        } else {
            if (opt.lead) {
                body += '<div style="margin:30px ' + padX + 'px 0;text-align:center;font-size:40px;line-height:1.45;'
                      + 'letter-spacing:.04em;color:#F4EAD6;animation:nzRise .34s .16s ease-out both">' + opt.lead + '</div>';
            }
            if (n >= 2) {
                var cells = '';
                for (var i = 0; i < n; i++) {
                    cells += '<div style="animation:nzRise .4s ' + (0.24 + i * 0.08).toFixed(2) + 's ease-out both">'
                           + N.portrait(people[i], boxW, 34)
                           + '</div>';
                }
                body += '<div style="display:flex;justify-content:center;align-items:flex-start;gap:' + gap + 'px;'
                      + 'margin-top:44px">' + cells + '</div>';
            }
        }

        var rule = function (dir) {
            return '<span style="flex:1;height:1px;background:linear-gradient(' + (dir === "l" ? "90deg" : "270deg")
                 + ',rgba(168,130,60,0),#a8823c);transform-origin:' + (dir === "l" ? "right" : "left") + ';'
                 + 'animation:nzRule .5s .12s ease-out both"></span>';
        };
        var iconSize  = single ? 60 : 66;
        var titleSize = single ? 34 : 36;

        var old = document.getElementById("notify-card");
        if (old) { old.remove(); }

        var ov = document.createElement("div");
        ov.id = "notify-card";
        ov.style.cssText =
              "position:absolute;top:0;left:0;width:100%;height:100%;z-index:1000000000;"
            + "display:flex;align-items:center;justify-content:center;cursor:pointer;"
            + "font-family:" + N.BODY + ";"
            + "background:radial-gradient(58% 52% at 50% 47%,rgba(4,3,2,.55),rgba(4,3,2,.86));"
            + "animation:nzScrim .26s ease-out both";

        ov.innerHTML =
              '<div style="position:relative;width:' + cardW + 'px;padding:44px 0 40px;'
                + 'background:linear-gradient(180deg,#1d1409,#0f0a05);border:1px solid #a8823c;'
                + 'box-shadow:0 44px 96px rgba(0,0,0,.78),inset 0 1px 0 rgba(242,216,130,.2);'
                + 'animation:nzCard .4s cubic-bezier(.2,.9,.25,1) both">'
              + '<div style="position:absolute;left:8px;top:8px;right:8px;bottom:8px;border:1px solid #553f31;pointer-events:none"></div>'
              + '<div style="position:absolute;left:20px;top:20px;width:10px;height:10px;background:#c8a060;transform:rotate(45deg)"></div>'
              + '<div style="position:absolute;right:20px;top:20px;width:10px;height:10px;background:#c8a060;transform:rotate(45deg)"></div>'
              + '<div style="position:absolute;left:20px;bottom:20px;width:10px;height:10px;background:#c8a060;transform:rotate(45deg)"></div>'
              + '<div style="position:absolute;right:20px;bottom:20px;width:10px;height:10px;background:#c8a060;transform:rotate(45deg)"></div>'
              + '<div style="display:flex;align-items:center;gap:' + (single ? 24 : 28) + 'px;padding:0 ' + padX + 'px">'
                + rule("l")
                + '<img src="' + N.ICON + '" alt="" style="width:' + iconSize + 'px;height:' + iconSize + 'px;display:block">'
                + '<span style="font-family:' + N.TITLE + ';font-size:' + titleSize + 'px;letter-spacing:.24em;'
                  + 'color:#f2d882;white-space:nowrap;animation:nzRise .34s .1s ease-out both">' + opt.title + '</span>'
                + rule("r")
              + '</div>'
              + body
              + '<div style="display:flex;align-items:center;justify-content:center;gap:18px;'
                + 'margin-top:' + (single ? 40 : 44) + 'px;animation:nzRise .34s .5s ease-out both">'
                + '<span style="width:8px;height:8px;background:#a8823c;transform:rotate(45deg)"></span>'
                + '<span style="font-size:24px;letter-spacing:.3em;color:#9c8253">' + N.W.close + '</span>'
                + '<span style="width:8px;height:8px;background:#a8823c;transform:rotate(45deg)"></span>'
              + '</div>'
            + '</div>';

        N.base().appendChild(ov);
        N.fitNames(ov);

        // 肖像が読めなかった枠は暗いままにしておく（記号に置き換えない）
        var faces = ov.querySelectorAll("img.nz-face");
        for (var k = 0; k < faces.length; k++) {
            faces[k].onerror = function () { this.style.visibility = "hidden"; };
        }

        N.waiting = (opt.wait !== false);
        ov.onclick = N.close;

        var hold = (opt.hold === undefined || opt.hold === "") ? 4200 : opt.hold;
        if (String(hold) !== "false") {
            hold = parseInt(hold, 10);
            if (isNaN(hold)) { hold = 4200; }
            N.timer = setTimeout(N.close, hold);
        }
    },

    // クリックか時間経過で閉じる。閉じ終わってから本編を再開する
    close: function () {
        var N = window.NOTIFY;
        var el = document.getElementById("notify-card");
        if (!el || el.classList.contains("out")) { return; }
        if (N.timer) { clearTimeout(N.timer); N.timer = null; }
        el.onclick = null;
        el.classList.add("out");
        var resume = N.waiting;
        N.waiting = false;
        setTimeout(function () {
            if (el.parentNode) { el.parentNode.removeChild(el); }
            if (resume) {
                var TG = N.kag();
                TG.cancelStrongStop();
                TG.cancelWeakStop();
                TG.ftag.nextOrder();
            }
        }, 240);
    },

    // f.master_data から表示名と肖像を引く
    lookup: function (id) {
        var list = window.NOTIFY.kag().stat.f.master_data || [];
        for (var i = 0; i < list.length; i++) {
            if (list[i].id === id) {
                return { name: list[i].name || "", image: list[i].image || "" };
            }
        }
        return { name: id, image: "" };
    }
};
[endscript]

;-----------------------------------------------------------
; [notify_profile ids="chara_01,chara_02"]
; 人物ファイルの解放を報せる。ids は f.master_data の id をカンマ区切りで。
;-----------------------------------------------------------
[macro name="notify_profile"]
    [iscript]
    (function () {
        var N = window.NOTIFY;
        var ids = String(mp.ids === undefined ? "" : mp.ids).split(",");
        var people = [];
        for (var i = 0; i < ids.length; i++) {
            var id = ids[i].replace(/^\s+|\s+$/g, "");
            if (id !== "") { people.push(N.lookup(id)); }
        }
        var lead = (people.length === 1)
            ? N.W.profile_one
            : people.length + N.W.profile_many;
        N.open({
            title:  N.W.profile_title,
            people: people,
            lead:   lead,
            hold:   mp.hold
        });
    })();
    [endscript]
    [s]
[endmacro]

;-----------------------------------------------------------
; [notify_info text="…"]
; 肖像のない報せ。title を渡すと見出しを差し替えられる。
;-----------------------------------------------------------
[macro name="notify_info"]
    [iscript]
    (function () {
        var N = window.NOTIFY;
        N.open({
            title: (mp.title === undefined || mp.title === "") ? N.W.info_title : mp.title,
            lead:  (mp.text === undefined) ? "" : mp.text,
            hold:  mp.hold
        });
    })();
    [endscript]
    [s]
[endmacro]

[return]
