/*
 * ダウト ミニゲーム 画面処理とティラノスクリプト用タグ
 *
 * [doubt_title]            モード選択        → f.doubt_mode = "arcade" / "simple"
 *                                            （title.ks の *arcade_start / *simple_start へ jump）
 * [doubt_select]           相手選択          → f.doubt_pair = 0〜3（もどる = -1）
 * [doubt_vs pair=0]        相手表示
 * [doubt_battle pair=0]    対戦              → f.doubt_win / f.doubt_gain / f.doubt_opp_left
 * [doubt_result pair=0]    結果（スコア・残機を加算）
 * [doubt_round_init]       ラウンドの勝ち負けを数え直す
 * [doubt_unlock_hidden]    隠しの二人をフリー対戦に加える（sf.doubt_hidden_cleared）
 * [doubt_highlow]          余興のハイアンドロー（挑むかどうかは任意）
 * [doubt_bonus]            残機ボーナスを通算に足す
 * [doubt_settings]         設定画面（難易度・ラウンド数・出札上限）
 * [doubt_help]             遊び方（ルール／キャラクター紹介）
 * [doubt_debug]            デバッグ：好きな卓から始める → f.doubt_debug_go ほか
 * [doubt_skip show="true"]  物語を飛ばすボタンの出し入れ（doubt_story.ks の *setup / *finish）
 * [doubt_continue]         コンティニュー    → f.doubt_continue = true / false
 * [doubt_gameover]         ゲームオーバー
 * [doubt_clear]            全戦突破
 * [doubt_ranking]          ランキング表示（register="true" で今回のスコアを登録）
 */
(function () {
  var D = window.DOUBT_DATA;
  var E = window.DoubtEngine;
  var RANK = E.RANK;
  var SUIT = E.SUIT;

  // ---------------------------------------------------------------- 共通

  function sleep(ms) {
    return new Promise(function (r) { setTimeout(r, ms); });
  }

  function h(tag, cls, html) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html != null) e.innerHTML = html;
    return e;
  }

  function f() {
    return TYRANO.kag.stat.f;
  }

  function sysVar() { return TYRANO.kag.variable.sf; }

  function openRoot(cls) {
    var base = document.querySelector(".tyrano_base") || document.body;
    var root = h("div", "dbt-root dbt-fadein " + (cls || ""));
    base.appendChild(root);
    return root;
  }

  function closeRoot(root) {
    if (root && root.parentNode) root.parentNode.removeChild(root);
  }

  function bg(root, src) {
    var b = h("div", "dbt-bg");
    b.style.backgroundImage = "url('" + src + "')";
    root.appendChild(b);
    return b;
  }

  // 読み込めなかった画像を覚えておき、同じ画像を何度も取りに行かない
  var missing = {};

  function absUrl(src) {
    var a = document.createElement("a");
    a.href = src;
    return a.href;
  }

  function portrait(id, cls) {
    var p = h("div", "dbt-portrait dbt-p-" + id + " " + (cls || ""));
    var ph = h("div", "ph", D.chara[id] ? D.chara[id].name : "");
    var img = new Image();
    var src = D.img.chara(id);
    img.onload = function () { ph.style.display = "none"; };
    img.onerror = function () {
      missing[absUrl(src)] = true;
      img.style.display = "none";
    };
    if (missing[absUrl(src)]) img.style.display = "none";
    else img.src = src;
    p.appendChild(img);
    p.appendChild(ph);
    p._img = img;
    p._id = id;
    return p;
  }

  // 表情差分：{id}_{face}.png が無ければ通常の立ち絵のまま
  function setFace(p, face) {
    if (!p || !p._img || p._img.style.display === "none") return;
    var img = p._img;
    var want = face ? D.img.chara(p._id, face) : D.img.chara(p._id);
    if (img.src === absUrl(want) || missing[absUrl(want)]) return;
    var probe = new Image();
    probe.onload = function () { img.src = want; };
    probe.onerror = function () { missing[absUrl(want)] = true; };
    probe.src = want;
  }

  function btn(text, cls, onClick) {
    var b = h("div", "dbt-btn " + cls, text);
    b.addEventListener("click", function (ev) {
      ev.stopPropagation();
      if (!b.classList.contains("off")) onClick();
    });
    return b;
  }

  // ---------------------------------------------------------------- ボイス
  //   data/voice/{キャラid}/{セリフの種類}_{番号}.mp3 を鳴らす。
  //   再生はキャラクターごとに分けてある。
  //     ・同じキャラが次のセリフを言うと、そのキャラの前のセリフは止まる
  //     ・他のキャラのセリフでは止まらない（掛け合いはそのまま重なって鳴る）
  //   順番待ちはしない。ゲームの進行にそのまま乗せるので、
  //   言うべき場面でセリフが飛ばされることがない。
  //   まだ録っていないセリフは voiceNG に覚えておき、二度と取りに行かない。
  //   （収録済みのキャラだけが喋り、それ以外は今まで通り無音で進む）

  var voiceNG = {};    // 鳴らせなかった音声のURL
  var voiceNow = {};   // キャラid -> そのキャラがいま鳴らしている音声（1人1本）

  // 本体の「効果音」ボリューム設定（0〜100）に合わせる
  function seVolume() {
    try {
      var v = TYRANO.kag.variable.sf._system_config_se_volume;
      if (v == null) v = TYRANO.kag.config.defaultSeVolume;
      v = parseFloat(v);
      return isNaN(v) ? 1 : Math.max(0, Math.min(1, v / 100));
    } catch (e) {
      return 1;
    }
  }

  // そのキャラが鳴らしている声だけを止める
  function stopVoiceOf(id) {
    var a = voiceNow[id];
    if (!a) return;
    delete voiceNow[id];
    try { a.pause(); } catch (e) {}
  }

  // 全員ぶん止める（対戦を閉じる時など）
  function stopAllVoice() {
    Object.keys(voiceNow).forEach(stopVoiceOf);
  }

  // lines[cat] の index 番目のセリフに対応する音声を鳴らす
  function playVoice(id, cat, index) {
    var V = D.voice;
    if (!V || !V.on || !id || index == null) return;
    var src = V.path(id, cat, index);
    var url = absUrl(src);
    if (voiceNG[url]) return;
    var vol = seVolume() * (V.volume != null ? V.volume : 1);
    if (!(vol > 0)) return;

    var a = new Audio();
    a.volume = Math.max(0, Math.min(1, vol));
    a.addEventListener("error", function () {
      voiceNG[url] = true;                        // 置いていないファイル。次からは触らない
      if (voiceNow[id] === a) delete voiceNow[id];
    });
    a.addEventListener("ended", function () {
      if (voiceNow[id] === a) delete voiceNow[id];
    });

    a.src = src;
    stopVoiceOf(id);        // 止めるのは、このキャラの前のセリフだけ
    voiceNow[id] = a;
    // 鳴らせなくても、対戦の進行は止めない
    try {
      var pr = a.play();
      if (pr && pr.catch) pr.catch(function () {
        if (voiceNow[id] === a) delete voiceNow[id];
      });
    } catch (e) {
      if (voiceNow[id] === a) delete voiceNow[id];
    }
  }

  // セリフをランダムに1つ選ぶ（文章と、ボイスを引くための番号を返す）
  function pickLine(id, cat) {
    var lines = D.lines[id] && D.lines[id][cat];
    if (!lines || !lines.length) return null;
    var i = Math.floor(Math.random() * lines.length);
    return { text: lines[i], index: i };
  }

  // スキル1件分の表示（名前・発動回数・効果）
  function skillHTML(id, useText, extraName) {
    var ch = D.chara[id];
    return '<div class="skhd">' +
      '<span class="who" style="color:' + ch.color + '">' + ch.name + (extraName || "") + "</span>" +
      '<span class="use">' + (useText != null ? useText : (ch.uses > 0 ? "1ゲーム" + ch.uses + "回" : "常時")) + "</span></div>" +
      '<div class="ab">' + ch.ability + "</div>";
  }

  /*
   * 通算スコアを増減する。増えた時だけ、規定点ごとに残機が1つ増える。
   * （ハイアンドローで減った時に、残機まで取り上げることはしない）
   */
  function addScore(fv, delta) {
    var before = fv.doubt_total || 0;
    var after = Math.max(0, before + delta);
    if (fv.doubt_lives == null) fv.doubt_lives = D.rules.baseContinue;
    var added = Math.max(0, Math.floor(after / D.rules.lifeEvery) - Math.floor(before / D.rules.lifeEvery));
    fv.doubt_total = after;
    fv.doubt_lives += added;
    return { before: before, after: after, added: added };
  }

  // 設定画面で決めた難易度（システム変数なので、ゲームを閉じても残る）
  function getLevel() {
    var v = NaN;
    try { v = parseInt(sysVar().doubt_level, 10); } catch (e) {}
    if (!(v >= 0 && v < D.rules.levels.length)) v = D.rules.levelDefault;
    return v;
  }

  function setLevel(v) {
    try {
      TYRANO.kag.variable.sf.doubt_level = v;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 設定の保存に失敗しました", e); }
  }

  function levelInfo() { return D.rules.levels[getLevel()]; }

  // 設定画面で決めたラウンド数（システム変数なので、ゲームを閉じても残る）
  function getRounds() {
    var v = 0;
    try { v = parseInt(sysVar().doubt_rounds, 10); } catch (e) {}
    if (!(v >= 1 && v <= D.rules.roundMax)) v = D.rules.roundDefault;
    return v;
  }

  function setRounds(v) {
    try {
      TYRANO.kag.variable.sf.doubt_rounds = v;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 設定の保存に失敗しました", e); }
  }

  // 一度に出せる札の上限。システム変数に保存する。
  function getMaxPlay() {
    var v = 0;
    try { v = parseInt(sysVar().doubt_max_play, 10); } catch (e) {}
    var min = D.rules.maxPlayMin || 1;
    var max = D.rules.maxPlayMax || D.rules.maxPlay;
    if (!(v >= min && v <= max)) v = D.rules.maxPlay;
    return v;
  }

  function setMaxPlay(v) {
    try {
      TYRANO.kag.variable.sf.doubt_max_play = v;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 出札上限の保存に失敗しました", e); }
  }

  // 今のラウンド状況の一行（1ラウンド制の時は何も出さない）
  function roundText() {
    var fv = f();
    var need = parseInt(fv.doubt_rounds, 10) || 1;
    if (need <= 1) return "";
    return "第" + (fv.doubt_round || 1) + "ラウンド　" + need + "先取　" +
      "あなた " + (fv.doubt_win_count || 0) + " － " + (fv.doubt_lose_count || 0) + " 相手";
  }

  // 二つ目の能力（sub）を持っているキャラは、続けて並べる
  function skillWithSub(id, extraName) {
    var ch = D.chara[id];
    var html = skillHTML(id, null, extraName);
    if (ch.sub && D.chara[ch.sub]) {
      html += '<div class="subsk">' + skillHTML(ch.sub, "1ゲーム" + ch.subUses + "回", "（二つ目の力）") + "</div>";
    }
    return html;
  }

  // アーケードプレイを突破すると、シンプルプレイで最終戦も選べるようになる
  function isCleared() {
    try { return TYRANO.kag.variable.sf.doubt_cleared == 1; } catch (e) { return false; }
  }

  // 隠しの二人を倒すと、シンプルプレイで隠し戦も選べるようになる
  function isHiddenCleared() {
    try { return TYRANO.kag.variable.sf.doubt_hidden_cleared == 1; } catch (e) { return false; }
  }

  // ---------------------------------------------------------------- 中断データ
  //   アーケードの対戦中に「中断」すると、その試合が始まる直前の f を
  //   sf.doubt_suspend に残す（システム変数なので、ゲームを閉じても残る）。
  //   { f: 試合直前の f の写し, at: 中断した時刻 }
  //   再開しても、しなくても、タイトルで答えた時点で消す。

  function getSuspend() {
    try {
      var s = sysVar().doubt_suspend;
      return s && s.f ? s : null;
    } catch (e) { return null; }
  }

  function setSuspend(data) {
    try {
      sysVar().doubt_suspend = data || null;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 中断データの保存に失敗しました", e); }
  }

  // f を写しの中身に置き換える。f そのものは差し替えず、中身だけ入れ替える
  function restoreF(snap) {
    var fv = f();
    Object.keys(fv).forEach(function (k) { delete fv[k]; });
    Object.keys(snap).forEach(function (k) { fv[k] = snap[k]; });
  }

  function pairIndexOf(pm) {
    var n = parseInt(pm.pair, 10);
    return isNaN(n) ? 0 : n;
  }

  // ---------------------------------------------------------------- タグ登録

  function defineTag(name, pm, fn) {
    var tag = {
      vital: [],
      pm: pm || {},
      start: function (p) {
        var kag = this.kag;
        kag.layer.hideEventLayer();
        Promise.resolve()
          .then(function () { return fn(p); })
          .catch(function (e) { console.error("[doubt] " + name, e); window.__doubtError = String(e && e.stack || e); })
          .then(function () { kag.ftag.nextOrder(); });
      },
    };
    tyrano.plugin.kag.tag[name] = tag;
    TYRANO.kag.ftag.master_tag[name] = tag;
    tag.kag = TYRANO.kag;
  }

  // ---------------------------------------------------------------- 注意書き
  //   タイトルより前に、一度だけ出す（title.ks から呼ぶ）。
  //   「今回の起動で出したか」の判定は title.ks 側の tf でしている。
  //   クリックかキーで閉じられる。触らなければ time ミリ秒で先へ進む。
  //
  //   閉じる時に readyAudio() を呼ぶのが大事。
  //   ブラウザは「利用者が何か操作するまで音を鳴らさない」ので、それまで
  //   [playbgm] は waitClick() でシナリオを止めて待ってしまう。この画面の
  //   クリックが最初の操作なので、ここで音声を解禁しておけば、後ろの
  //   [playbgm] が止まらずに済む。

  defineTag("doubt_caution", { time: "5000" }, function (pm) {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-caution");
      bg(root, D.img.bgCaution);
      root.appendChild(h("div", "hint", "クリックで進む"));

      var done = false;
      var timer = setTimeout(end, parseInt(pm.time, 10) || 5000);

      function end() {
        if (done) return;
        done = true;
        clearTimeout(timer);
        document.removeEventListener("keydown", onKey, true);
        // 利用者の操作のうちに音声を解禁しておく（この後の [playbgm] を止めないため）
        try { TYRANO.kag.readyAudio(); } catch (e) {}
        root.classList.add("out");
        setTimeout(function () { closeRoot(root); resolve(); }, 420);
      }

      // この画面のクリックとキーは、本体側に渡さない。
      // 渡すと本体が「次へ進む」と解釈して、シナリオが余計に進んでしまう。
      root.addEventListener("click", function (ev) {
        ev.stopPropagation();
        end();
      });
      function onKey(ev) {
        ev.stopPropagation();
        if (ev.preventDefault) ev.preventDefault();
        end();
      }
      document.addEventListener("keydown", onKey, true);
    });
  });

  // ---------------------------------------------------------------- タイトル

  // title.ks から呼ぶ。画面を出したらすぐ制御を返し、title.ks 側の [s] で待つ。
  // ボタンを押すと title.ks のラベルへ [jump] する（system/title_ui.ks と同じ作り）。
  defineTag("doubt_title", {}, function () {
    var demo = !!D.rules.demoMode;
    var root = openRoot("dbt-title" + (demo ? " demo" : ""));
    bg(root, D.img.bgTitle);
    root.appendChild(h("div", "dbt-shade shade"));
    root.appendChild(h("div", "head",
      '<div class="kicker">―― 相手の目を誤魔化す嘘つきの祭典 ――</div>' +
      "<h1>舞黒館の<em>惨劇</em></h1>" +
      '<div class="sub">「探偵少女はダウトで勝ちの目を見るか」</div>' +
      (demo ? '<div class="demo-label">体験版</div>' : "")));
    var modes = h("div", "modes");
    function go(mode, target) {
      f().doubt_mode = mode;
      f().doubt_demo = demo;
      f().doubt_demo_last = D.rules.demoLastStage || 0;
      closeRoot(root);
      TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: target });
    }

    // アーケードプレイ：中断データがあれば、再開するか聞く。
    // どちらを選んでも中断データはここで消す（再開しない時は、そのまま最初から）。
    // 体験版と製品版で作った中断データは取り違えないよう、同じ版のものだけ扱う。
    function goArcade() {
      var sus = getSuspend();
      if (!sus || !!sus.f.doubt_demo !== demo) { go("arcade", "*arcade_start"); return; }
      var pr = D.pairs[sus.f.doubt_stage] || {};
      var ov = h("div", "dbt-overlay dbt-pad dbt-resign");
      var box = h("div", "box");
      box.appendChild(h("div", "q", "中断データがあります"));
      box.appendChild(h("div", "d",
        (pr.label ? pr.label + "　" : "") + "通算 " + (sus.f.doubt_total || 0).toLocaleString() + "点" +
        "<br>再開すると、中断した試合の最初から始まります" +
        "<br><small>再開しない場合、中断データは消えます</small>"));
      var row = h("div", "targets");
      row.appendChild(btn("再開する", "red", function () {
        setSuspend(null);
        restoreF(sus.f);
        closeRoot(root);
        TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: "*arcade_resume" });
      }));
      row.appendChild(btn("最初から", "navy", function () {
        setSuspend(null);
        go("arcade", "*arcade_start");
      }));
      box.appendChild(row);
      ov.appendChild(box);
      root.appendChild(ov);
    }

    modes.appendChild(btn(
      demo ? "アーケードプレイ<small>体験版・第一戦まで</small>" : "アーケードプレイ<small>全5戦</small>",
      "purple", goArcade
    ));
    if (!demo) {
      modes.appendChild(btn("シンプルプレイ<small>フリー対戦</small>", "navy", function () { go("simple", "*simple_start"); }));
    }
    root.appendChild(modes);
    var extra = h("div", "extra");
    if (!demo) {
      extra.appendChild(btn("ランキング", "navy", function () {
        closeRoot(root);
        TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: "*ranking" });
      }));
    }
    extra.appendChild(btn("設定", "navy", function () {
      closeRoot(root);
      TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: "*settings" });
    }));
    extra.appendChild(btn("遊び方", "navy", function () {
      closeRoot(root);
      TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: "*help" });
    }));
    root.appendChild(extra);

    // 開発用デバッグは、通常メニューと分けて画面最下部に小さく置く
    if (D.rules.debugMenu) {
      root.appendChild(btn("デバッグ", "navy debugbtn", function () {
        closeRoot(root);
        TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: "*debug" });
      }));
    }
  });

  // ---------------------------------------------------------------- 遊び方

  defineTag("doubt_help", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-help");
      bg(root, D.img.bgTitle);
      root.appendChild(h("div", "dbt-shade shade"));
      var body = h("div", "helpbody");
      root.appendChild(body);

      // 紹介画面に並べる「実際に卓へ出るキャラクター」だけ。
      // sub能力用のダミーデータはここには出さない。
      var charIds = D.rules.demoMode
        ? ["mahoru", "airi", "kazuto"]
        : ["mahoru", "airi", "kazuto", "mary", "reido", "juri", "eruku", "jushika", "koderia"];

      // 体験版では先の対戦相手を伏せる。製品版だけ解放済みキャラを追加する。
      if (!D.rules.demoMode && isCleared()) {
        charIds.push("mahoru_awake", "maicro");
      }
      if (!D.rules.demoMode && isHiddenCleared()) {
        charIds.push("yuduki", "arther");
      }

      var charPage = 0;
      var perPage = 6;

      function clearBody() { body.innerHTML = ""; }

      function finish() {
        closeRoot(root);
        resolve();
      }

      function readingHTML(ch) {
        return ch.reading ? '<span class="reading">（' + ch.reading + '）</span>' : "";
      }

      function useText(ch) {
        return ch.uses > 0 ? "1ゲーム" + ch.uses + "回" : "常時";
      }

      function abilityHTML(id) {
        var ch = D.chara[id];
        var html = '<div class="abilmain"><span class="uses">' + useText(ch) + '</span>' + ch.ability + "</div>";
        if (ch.sub && D.chara[ch.sub]) {
          var sub = D.chara[ch.sub];
          html += '<div class="abilsub"><b>' + sub.name + '</b> <span class="uses">1ゲーム' +
            ch.subUses + "回</span>" + sub.ability + "</div>";
        }
        return html;
      }

      function renderMenu() {
        clearBody();
        body.className = "helpbody menu";
        body.appendChild(h("div", "hd", "遊び方"));
        body.appendChild(h("div", "lead", "見たい項目を選んでください。"));

        var choices = h("div", "helpchoices");
        choices.appendChild(btn("ルール<small>ダウトの基本的な遊び方</small>", "purple", renderRules));
        choices.appendChild(btn("キャラクター紹介<small>名前の読み・特殊能力</small>", "navy", function () {
          charPage = 0;
          renderCharacters();
        }));
        body.appendChild(choices);

        body.appendChild(btn("タイトルへ戻る", "navy back", finish));
      }

      function renderRules() {
        clearBody();
        body.className = "helpbody rulespage";
        body.appendChild(h("div", "hd", "ルール"));
        body.appendChild(h("div", "lead",
          "嘘を混ぜて札を減らし、相手の嘘を見抜くカードゲームです。"));

        var rules = h("div", "rules");

        function rule(no, title, desc) {
          var box = h("div", "rule");
          box.appendChild(h("div", "no", no));
          box.appendChild(h("div", "rt", title));
          box.appendChild(h("div", "rd", desc));
          rules.appendChild(box);
        }

        rule("1", "札を伏せる",
          "中央に表示された数字として、手札から札を伏せます。<br>" +
          "違う数字の札を混ぜて、<b>嘘をついても構いません。</b><br>" +
          "一度に出せる枚数は設定で1〜4枚に変更できます。");

        rule("2", "嘘だと思ったらダウト",
          "相手の宣言が怪しいと思ったら、<b>「ダウトを宣言する」</b>。<br>" +
          "自信がなければ見送ることもできます。");

        rule("3", "ダウトの結果",
          "<b>嘘だった場合：</b>札を伏せた側が、場の札をすべて引き取ります。<br>" +
          "<b>本当だった場合：</b>ダウトした側が、場の札をすべて引き取ります。");

        rule("4", "先に手札をなくせば勝ち",
          "最初に自分の手札を0枚にした人が勝利です。<br>" +
          "嘘を通すか、相手の嘘を見抜くか。読み合いが勝負を分けます。");

        body.appendChild(rules);

        var tip = h("div", "tip");
        tip.appendChild(h("div", "tk", "読み合いのヒント"));
        tip.appendChild(h("div", "td",
          "同じ数字の札は通常4枚です。自分が持っている枚数や、ダウトで公開された札を手掛かりにすると、" +
          "相手の宣言が成立するかを推理できます。<small>※特殊能力によって札の枚数や情報が変化することがあります。</small>"));
        body.appendChild(tip);

        var skill = h("div", "skillnote");
        skill.appendChild(h("div", "sk", "特殊能力"));
        skill.appendChild(h("div", "sd",
          "登場人物はそれぞれ固有の能力を持っています。<b>キャラクター紹介</b>や、対戦中の<b>「スキル」</b>から確認できます。"));
        body.appendChild(skill);

        body.appendChild(btn("もどる", "navy back", renderMenu));
      }

      function renderCharacters() {
        clearBody();
        body.className = "helpbody charpage";
        body.appendChild(h("div", "hd", "キャラクター紹介"));

        var maxPage = Math.ceil(charIds.length / perPage);
        var start = charPage * perPage;
        var ids = charIds.slice(start, start + perPage);
        body.appendChild(h("div", "pagecount", (charPage + 1) + " / " + maxPage));

        var grid = h("div", "chargrid");
        ids.forEach(function (id) {
          var ch = D.chara[id];
          var card = h("div", "charcard");
          card.appendChild(portrait(id, "charmini"));

          var info = h("div", "charinfo");
          info.appendChild(h("div", "charname",
            '<span class="name" style="color:' + ch.color + '">' + ch.name + "</span>" + readingHTML(ch)));
          info.appendChild(h("div", "abiltitle", "特殊能力"));
          info.appendChild(h("div", "charabil", abilityHTML(id)));
          card.appendChild(info);
          grid.appendChild(card);
        });
        body.appendChild(grid);

        var nav = h("div", "charnav");
        var prev = btn("前へ", "navy", function () {
          if (charPage > 0) { charPage--; renderCharacters(); }
        });
        if (charPage <= 0) prev.classList.add("off");
        nav.appendChild(prev);

        nav.appendChild(btn("もどる", "purple", renderMenu));

        var next = btn("次へ", "navy", function () {
          if (charPage < maxPage - 1) { charPage++; renderCharacters(); }
        });
        if (charPage >= maxPage - 1) next.classList.add("off");
        nav.appendChild(next);
        body.appendChild(nav);
      }

      renderMenu();
    });
  });

  // ---------------------------------------------------------------- 相手選択

  defineTag("doubt_select", {}, function () {
    return new Promise(function (resolve) {
      // アーケードプレイを突破していれば、最終戦のペアも選べる
      var pairCount = 4 + (isCleared() ? 1 : 0) + (isHiddenCleared() ? 1 : 0);
      if (pairCount > D.pairs.length) pairCount = D.pairs.length;
      var root = openRoot("dbt-select" + (pairCount >= 5 ? " five" : "") + (pairCount >= 6 ? " six" : ""));
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));

      var me = h("div", "me");
      me.appendChild(portrait("mahoru"));
      me.appendChild(h("div", "plate", "<small>あなた</small><b>真歩流</b>"));
      me.appendChild(h("div", "myskill", '<div class="sklbl">あなたのスキル</div><div class="sk">' + skillWithSub("mahoru") + "</div>"));
      root.appendChild(me);

      var grid = h("div", "grid");
      var cols = [];
      var current = 0;
      var preview = h("div", "preview");
      var plate = h("div", "pairplate");

      // 選んだ相手のスキル（能力）を、名前・発動回数つきで並べる
      function skillRow(id) {
        return '<div class="sk">' + skillWithSub(id) + "</div>";
      }

      function show(i) {
        current = i;
        cols.forEach(function (c, k) { c.classList.toggle("on", k === i); });
        var pr = D.pairs[i];
        preview.innerHTML = "";
        preview.appendChild(portrait(pr.a, "p1"));
        preview.appendChild(portrait(pr.b, "p2"));
        plate.innerHTML = "<small>" + pr.label + "</small><b>" + D.chara[pr.a].name + " × " + D.chara[pr.b].name + "</b>" +
          '<div class="skills"><div class="sklbl">スキル</div>' + skillRow(pr.a) + skillRow(pr.b) + "</div>";
      }

      for (var i = 0; i < pairCount; i++) {
        (function (i) {
          var pr = D.pairs[i];
          var col = h("div", "col");
          var pa = portrait(pr.a);
          pa.appendChild(h("div", "nm", D.chara[pr.a].name));
          var pb = portrait(pr.b);
          pb.appendChild(h("div", "nm", D.chara[pr.b].name));
          col.appendChild(pa);
          col.appendChild(pb);
          col.appendChild(h("div", "lb", pr.label));
          col.addEventListener("click", function () {
            if (current === i) decide(); else show(i);
          });
          cols.push(col);
          grid.appendChild(col);
        })(i);
      }
      root.appendChild(grid);
      root.appendChild(preview);
      root.appendChild(plate);

      function finish(v) {
        document.removeEventListener("keydown", onKey);
        f().doubt_pair = v;
        closeRoot(root);
        resolve();
      }
      function decide() { finish(current); }

      var cmds = h("div", "cmds");
      cmds.appendChild(btn("この相手で", "red", decide));
      cmds.appendChild(btn("もどる", "navy", function () { finish(-1); }));
      root.appendChild(cmds);
      root.appendChild(h("div", "hint", "← → で相手を選ぶ／選ぶとスキルの内容が出ます"));

      function onKey(ev) {
        if (ev.key === "ArrowLeft") show((current + pairCount - 1) % pairCount);
        else if (ev.key === "ArrowRight") show((current + 1) % pairCount);
        else if (ev.key === "Enter") decide();
        else if (ev.key === "Escape") finish(-1);
      }
      document.addEventListener("keydown", onKey);
      show(0);
    });
  });

  // ---------------------------------------------------------------- 相手表示

  defineTag("doubt_vs", { pair: "0" }, function (pm) {
    var pr = D.pairs[pairIndexOf(pm)];
    return new Promise(function (resolve) {
      var root = openRoot("dbt-vs");
      // 立ち絵をクリックすると、そのキャラのスキルが出る（真歩流も見られる）
      var ids = ["mahoru", pr.a, pr.b];
      var ports = [];
      var panel = h("div", "skillpanel show");
      function showSkill(k) {
        ports.forEach(function (p, j) { p.classList.toggle("on", j === k); });
        panel.className = "skillpanel show" + (k === 0 ? " l" : "");
        panel.innerHTML = skillWithSub(ids[k], k === 0 ? "（あなた）" : "");
      }

      var left = h("div", "left");
      var pMe = portrait("mahoru");
      pMe.addEventListener("click", function (ev) { ev.stopPropagation(); showSkill(0); });
      ports.push(pMe);
      left.appendChild(pMe);
      left.appendChild(h("div", "copy l", D.playerTagline));

      var right = h("div", "right");
      [pr.a, pr.b].forEach(function (id, k) {
        var p = portrait(id);
        p.addEventListener("click", function (ev) { ev.stopPropagation(); showSkill(k + 1); });
        ports.push(p);
        right.appendChild(p);
      });
      if (pr.tagline) right.appendChild(h("div", "copy r", pr.tagline));
      root.appendChild(left);
      root.appendChild(right);
      root.appendChild(panel);
      root.appendChild(h("div", "skhint", "立ち絵をクリックすると、そのキャラのスキルが出ます"));
      showSkill(1);
      root.appendChild(h("div", "band",
        '<span class="tagbox l">あなた</span><span class="n l">真歩流</span>' +
        '<span class="n r">' + D.chara[pr.a].name + " × " + D.chara[pr.b].name + "</span>" +
        '<span class="tagbox r">' + pr.label + "</span>"));
      root.appendChild(h("div", "mark", "<span>VS</span>"));
      root.appendChild(btn("勝負", "red go", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- 対戦

  function cardEl(c) {
    var red = c.s === 1 || c.s === 2;
    if (c.r === 0) {
      var j = h("div", "dbt-card joker", '<span class="jk">JOKER</span><span class="mid">★</span>');
      j.dataset.id = c.id;
      return j;
    }
    var e = h("div", "dbt-card" + (red ? " red" : ""));
    e.innerHTML =
      '<span class="tl">' + RANK[c.r] + "</span>" +
      '<span class="st">' + SUIT[c.s] + "</span>" +
      '<span class="mid' + (c.r >= 11 ? " face" : "") + '">' + (c.r >= 11 ? RANK[c.r] : SUIT[c.s]) + "</span>";
    e.dataset.id = c.id;
    return e;
  }

  function miniCardEl(c) {
    var red = c.s === 1 || c.s === 2;
    var label = c.r === 0 ? "JOKER" : RANK[c.r] + '<span>' + SUIT[c.s] + "</span>";
    var e = h("div", "dbt-mini-card" + (red ? " red" : ""), label);
    e.dataset.id = c.id;
    return e;
  }

  // 公開手札は、ゲーム内部の配列順ではなく数字の昇順で見せる。
  // 元配列は変更しないので、CPUの判断や手札管理には影響しない。
  function sortedCardsForDisplay(cards) {
    return cards.slice().sort(function (a, b) {
      var ar = a.r === 0 ? 14 : a.r;
      var br = b.r === 0 ? 14 : b.r;
      return ar - br || a.s - b.s;
    });
  }

  function BattleUI(pairIndex) {
    var self = this;
    this.pair = D.pairs[pairIndex];
    this.root = openRoot("dbt-battle");
    bg(this.root, D.img.bgTable);
    this.root.appendChild(h("div", "dbt-shade shade"));

    this.opp = {};
    this.bubble = {};
    this.portraits = {};
    [1, 2].forEach(function (seat) {
      var id = seat === 1 ? self.pair.a : self.pair.b;
      var box = h("div", "dbt-opp s" + seat);
      var p = portrait(id);
      self.portraits[seat] = p;
      var info = h("div", "info",
        '<div class="nm">' + D.chara[id].name + "</div>" +
        '<div class="cnt"><span class="k">手札</span><span class="v">0</span></div>' +
        '<div class="use"></div>');
      box.appendChild(p);
      box.appendChild(info);
      self.root.appendChild(box);
      self.opp[seat] = { box: box, count: info.querySelector(".v"), use: info.querySelector(".use") };
      var bub = h("div", "dbt-bubble s" + seat);
      self.root.appendChild(bub);
      self.bubble[seat] = bub;
      // 名前や立ち絵を押すと、この対戦のスキル一覧が出る
      box.addEventListener("click", function () { self.openSkills(); });
    });

    // 主人公（真歩流）の吹き出し。立ち絵は出さないので、手札の上に出す
    var myBub = h("div", "dbt-bubble s0");
    this.root.appendChild(myBub);
    this.bubble[0] = myBub;

    this.logEl = h("div", "dbt-log", "");
    this.root.appendChild(this.logEl);

    // 何ラウンド目か（1ラウンド制の時は空のまま）
    this.roundEl = h("div", "dbt-round", roundText());
    if (!this.roundEl.textContent) this.roundEl.style.display = "none";
    this.root.appendChild(this.roundEl);

    var field = h("div", "dbt-field");
    this.rankLbl = h("div", "lbl", "いまの宣言");
    field.appendChild(this.rankLbl);
    var row = h("div", "row");
    this.rankBox = h("div", "dbt-rank", "<span>A</span>");
    row.appendChild(this.rankBox);
    this.pileEl = h("div", "dbt-pile");
    row.appendChild(this.pileEl);
    this.pileInfo = h("div", "dbt-pileinfo", '<span class="k">場の伏せ札</span><span class="v">0</span><span class="d"></span>');
    row.appendChild(this.pileInfo);
    field.appendChild(row);
    this.root.appendChild(field);

    this.handEl = h("div", "dbt-hand");
    this.root.appendChild(this.handEl);
    this.guide = h("div", "dbt-guide", "");
    this.root.appendChild(this.guide);

    var cmd = h("div", "dbt-cmd");
    this.bMain = btn("伏せる", "red", function () { self.onMain(); });
    this.bDoubt = btn("ダウトを宣言する", "navy", function () { self.onDoubt(); });
    this.bAbility = btn("能力を発動する", "pink", function () { self.onAbility(); });
    this.bSkill = btn("スキル", "navy info", function () { self.openSkills(); });
    // 降参はフリー対戦だけ。アーケードは残機とコンティニューで区切りがつく
    this.canResign = f().doubt_mode === "simple";
    cmd.appendChild(this.bMain);
    cmd.appendChild(this.bDoubt);
    cmd.appendChild(this.bAbility);
    cmd.appendChild(this.bSkill);
    // 降参はフリー対戦の時だけ、スキルの隣に並べる
    if (this.canResign) {
      this.bResign = btn("降参", "navy resign", function () { self.askResign(); });
      cmd.appendChild(this.bResign);
    } else if (f().doubt_mode === "arcade") {
      // アーケードでは、同じ場所に「中断」を出す（押せる時の決まりも降参と同じ）
      this.bResign = btn("中断", "navy resign", function () { self.askSuspend(); });
      cmd.appendChild(this.bResign);
    }
    this.suspended = false;
    this.root.appendChild(cmd);

    this.cutinShown = {};   // この対戦でカットインを出し切ったキャラ
    this.mode = "idle";
    this.selected = {};
    this.need = 0;
    this.resolver = null;
    this.game = null;
    this.setButtons();
  }

  var B = BattleUI.prototype;

  B.close = function () {
    stopAllVoice();
    closeRoot(this.root);
  };

  // この対戦に出ている3人のスキルを並べて見せる
  B.openSkills = function () {
    var g = this.game;
    if (!g) return;
    var ov = h("div", "dbt-overlay dbt-pad dbt-skills");
    var box = h("div", "box");
    box.appendChild(h("div", "q", "スキル"));
    [0, 1, 2].forEach(function (seat) {
      var ch = D.chara[g.ids[seat]];
      var left = ch.uses > 0 ? "残り" + Math.max(0, g.uses[seat]) + "回" : "常時";
      box.appendChild(h("div", "sk" + (seat === 0 ? " me" : ""),
        skillHTML(g.ids[seat], left, seat === 0 ? "（あなた）" : "")));
      // 二つ目の能力（快活な少女・英国の青年）
      if (g.subId[seat] && D.chara[g.subId[seat]]) {
        var sc = D.chara[g.subId[seat]];
        box.appendChild(h("div", "sk borrow",
          skillHTML(g.subId[seat], sc.uses > 0 ? "残り" + Math.max(0, g.subUses[seat]) + "回" : "常時",
            "（二つ目の力）")));
      }
      // 真歩流？が借りている能力も、同じように並べる
      if (seat === g.awakeSeat && g.borrowId) {
        var bc = D.chara[g.borrowId];
        box.appendChild(h("div", "sk borrow",
          skillHTML(g.borrowId, bc.uses > 0 ? "残り" + Math.max(0, g.borrowUses) + "回" : "常時",
            "の力（" + D.chara.mahoru_awake.name + "が使う）")));
      }
    });
    box.appendChild(btn("とじる", "navy cancel", function () { closeRoot(ov); }));
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  // 降参するか確かめる。入力待ちの最中だけ押せる
  B.askResign = function () {
    var self = this;
    if (this.mode === "idle" || !this.resolver) return;
    var ov = h("div", "dbt-overlay dbt-pad dbt-resign");
    var box = h("div", "box");
    box.appendChild(h("div", "q", "降参しますか"));
    box.appendChild(h("div", "d", "この対戦は負けになり、相手選びに戻ります"));
    var row = h("div", "targets");
    row.appendChild(btn("降参する", "red", function () {
      closeRoot(ov);
      self.game.resign();
      // 待っている入力を解いて、エンジンに打ち切らせる
      self.finishInput(self.mode === "window" ? { type: "pass" } : []);
    }));
    row.appendChild(btn("やめる", "navy", function () { closeRoot(ov); }));
    box.appendChild(row);
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  // 中断するか確かめる（アーケードだけ）。入力待ちの最中だけ押せる。
  // 中断すると対戦を打ち切り、[doubt_battle] が中断データを残してタイトルへ戻す。
  B.askSuspend = function () {
    var self = this;
    if (this.mode === "idle" || !this.resolver) return;
    var ov = h("div", "dbt-overlay dbt-pad dbt-resign");
    var box = h("div", "box");
    box.appendChild(h("div", "q", "中断しますか"));
    box.appendChild(h("div", "d", "タイトルに戻ります。<br>アーケードプレイを選ぶと、この試合の最初から再開できます"));
    var row = h("div", "targets");
    row.appendChild(btn("中断する", "red", function () {
      closeRoot(ov);
      self.suspended = true;
      // 打ち切り方は降参と同じ。勝敗は数えず、結果画面も出さない
      self.game.resign();
      self.finishInput(self.mode === "window" ? { type: "pass" } : []);
    }));
    row.appendChild(btn("やめる", "navy", function () { closeRoot(ov); }));
    box.appendChild(row);
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  B.setButtons = function () {
    var g = this.game;
    var nSel = Object.keys(this.selected).length;
    var m = this.mode;
    var uses = g ? g.uses[0] : 0;
    var swaps = g ? g.abilLeft(0, "hand_swap") : 0;
    this.bMain.innerHTML = m === "window" ? "見送る" : (m === "give" ? "渡す" : "伏せる");
    this.bMain.classList.toggle("off",
      !((m === "place" && nSel >= 1 && nSel <= g.maxPlay) || m === "window" ||
        (m === "give" && nSel === this.need)));
    var sealedDoubt = !!(g && g.doubtBlocked());
    this.bDoubt.classList.toggle("off", m !== "window" || sealedDoubt);

    // 自分の手番は「手札の交換」、ダウトの場面は「名指し推理」
    if (m === "place") {
      this.bAbility.innerHTML = "手札を交換する<small>残り" + Math.max(0, swaps) + "</small>";
      this.bAbility.classList.toggle("off", !(swaps > 0));
    } else {
      this.bAbility.innerHTML = "数字を名指しする<small>残り" + Math.max(0, uses) + "</small>";
      this.bAbility.classList.toggle("off", !(m === "window" && uses > 0) || sealedDoubt);
    }
    this.handEl.classList.toggle("turn", m === "place" || m === "give");
    if (this.bResign) this.bResign.classList.toggle("off", m === "idle");
  };

  B.render = function (g) {
    this.game = g;
    var self = this;
    // 朱志香の力が効いている間は、手札の枚数も場の伏せ札の枚数も当てにならない
    var hidden = g.blurred();

    [1, 2].forEach(function (seat) {
      var o = self.opp[seat];
      var id = g.ids[seat];
      // 本当の枚数ではなく、ありそうな数字を出す
      o.count.textContent = g.shownHand(seat);
      o.box.classList.toggle("turn", g.turn === seat && g.winner < 0);
      var ch = D.chara[id];
      var parts = [];
      if (ch.uses > 0) parts.push("能力 残り" + Math.max(0, g.uses[seat]));
      var sub = g.subId[seat] && D.chara[g.subId[seat]];
      if (sub && sub.uses > 0) parts.push(sub.name + " 残り" + Math.max(0, g.subUses[seat]));
      var useText = parts.join("／");
      if (id === "mahoru_awake") {
        useText = "名指し 残り" + Math.max(0, g.uses[seat]);
        if (g.borrowId) {
          var bc = D.chara[g.borrowId];
          useText += "／" + bc.name + "の力" + (bc.uses > 0 ? " 残り" + Math.max(0, g.borrowUses) : "");
        }
        if (g.sealed > 0) useText = "力を封じられている";
      }
      if (g.immune[seat] > 0) useText = "ダウトされない（あと" + g.immune[seat] + "回）";
      if (hidden) useText = "枚数が読めない";
      o.use.textContent = useText;
    });

    this.rankBox.innerHTML = "<span>" + RANK[g.rank] + "</span>";
    this.rankLbl.textContent = g.turn === 0 ? "あなたが出す数字" : g.name(g.turn) + "の宣言";

    var n = g.pile.length;
    this.pileInfo.querySelector(".v").textContent = hidden ? "？" : n;
    this.pileInfo.querySelector(".d").textContent = g.discard.length ? "捨て札 " + g.discard.length : "";
    var shown = hidden && n > 0 ? 6 : Math.min(n, 6);
    if (this.pileEl.childNodes.length !== shown) {
      this.pileEl.innerHTML = "";
      for (var i = 0; i < shown; i++) {
        var pc = h("div", "pc");
        pc.style.backgroundImage = "url('" + D.img.cardBack + "')";
        pc.style.left = (i * 7) + "px";
        pc.style.top = (10 - i * 3) + "px";
        pc.style.transform = "rotate(" + ((i % 3) - 1) * 4 + "deg)";
        this.pileEl.appendChild(pc);
      }
    }

    this.renderHand(g);
    this.setButtons();
  };

  B.renderHand = function (g) {
    var self = this;
    var hand = g.hands[0];
    var W = 1700;
    var cw = 148;
    var n = hand.length;
    // 増えすぎた手札は二段に分ける（一段だと札がほとんど重なって見えなくなる）
    var rows = n > 26 ? 2 : 1;
    var per = Math.ceil(n / rows);
    this.handEl.classList.toggle("two", rows === 2);
    this.handEl.innerHTML = "";
    var pickable = self.mode === "place" || self.mode === "give";

    hand.forEach(function (c, i) {
      var row = Math.floor(i / per);
      var idx = i - row * per;
      var cnt = Math.min(per, n - row * per);
      var step = cnt > 1 ? Math.min(92, (W - cw) / (cnt - 1)) : 0;
      var x0 = (W - (cw + step * (cnt - 1))) / 2;
      var mid = (cnt - 1) / 2;
      var spread = Math.min(2.4, 30 / Math.max(1, cnt));
      var d = idx - mid;

      var e = cardEl(c);
      e.style.left = x0 + idx * step + "px";
      e.style.transform = "rotate(" + d * spread + "deg)";
      // 上の段ほど奥に置く
      e.style.bottom = (rows - 1 - row) * 138 - Math.abs(d) * Math.min(7, 90 / Math.max(1, cnt)) + "px";
      e.style.zIndex = row * 100 + idx + 1;
      if (self.selected[c.id]) e.classList.add("sel");
      if (pickable) {
        e.classList.add("pickable");
        e.addEventListener("click", function () { self.toggleCard(c.id); });
      }
      self.handEl.appendChild(e);
    });
  };

  B.toggleCard = function (id) {
    var limit = this.mode === "give" ? this.need : this.game.maxPlay;
    if (this.selected[id]) delete this.selected[id];
    else {
      if (limit === 1) this.selected = {};
      if (Object.keys(this.selected).length >= limit) return;
      this.selected[id] = true;
    }
    this.renderHand(this.game);
    this.setButtons();
  };

  B.onMain = function () {
    var r = this.resolver;
    if (!r) return;
    if (this.mode === "place" || this.mode === "give") {
      var ids = Object.keys(this.selected);
      this.selected = {};
      this.finishInput(ids);
    } else if (this.mode === "window") {
      this.finishInput({ type: "pass" });
    }
  };

  B.onDoubt = function () {
    if (this.mode === "window") this.finishInput({ type: "doubt" });
  };

  B.onAbility = function () {
    var self = this;
    // 自分の手番なら「手札の交換」、ダウトの場面なら「名指し推理」
    if (this.mode === "place") { this.askSwapTarget(); return; }
    if (this.mode !== "window") return;
    var g = this.game;
    var declared = g.last.rank;
    var ov = h("div", "dbt-overlay dbt-pad");
    var box = h("div", "box");
    box.appendChild(h("div", "q", "伏せ札の本当の数字を名指しする"));
    var keys = h("div", "keys");
    for (var r = 1; r <= 13; r++) {
      (function (r) {
        var k = btn(RANK[r], "navy key" + (r === declared ? " off" : ""), function () {
          closeRoot(ov);
          self.finishInput({ type: "guess", guess: r });
        });
        keys.appendChild(k);
      })(r);
    }
    box.appendChild(keys);
    box.appendChild(btn("やめる", "navy cancel", function () { closeRoot(ov); }));
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  // 交換相手を選ぶ。この段階ではまだ手札を公開せず、キャンセルできる。
  B.askSwapTarget = function () {
    var self = this;
    var g = this.game;
    if (g.abilLeft(0, "hand_swap") <= 0) return;
    var ov = h("div", "dbt-overlay dbt-pad dbt-swap");
    var box = h("div", "box");
    box.appendChild(h("div", "q", "誰と手札を公開して交換する？"));
    var row = h("div", "targets");
    [1, 2].forEach(function (seat) {
      var b = btn(g.name(seat) + "<small>手札を互いに全公開</small>", "navy", async function () {
        closeRoot(ov);
        // 交換で手札が動くので、伏せるために選んでいた札はいったん解除する。
        self.selected = {};
        self.renderHand(g);
        self.setButtons();
        var max = await g.beginPlayerExchange(seat);
        if (max > 0) self.openExchange(seat, max);
      });
      row.appendChild(b);
    });
    box.appendChild(row);
    box.appendChild(btn("やめる", "navy cancel", function () { closeRoot(ov); }));
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  // 全公開後は能力を消費済み。交換枚数と、欲しい相手の札を選んで必ず交換する。
  B.openExchange = function (seat, max) {
    var self = this;
    var g = this.game;
    var ov = h("div", "dbt-overlay dbt-exchange");
    var box = h("div", "box");
    ov.appendChild(box);
    this.root.appendChild(ov);
    var count = 1;

    function title(t, sub) {
      box.innerHTML = "";
      box.appendChild(h("div", "q", t));
      if (sub) box.appendChild(h("div", "sub", sub));
    }
    function grid(label, cards, cls, onPick, selected, demanded) {
      var sec = h("div", "handsec " + (cls || ""));
      sec.appendChild(h("div", "label", label));
      var gr = h("div", "cardgrid");
      sortedCardsForDisplay(cards).forEach(function (c) {
        var e = miniCardEl(c);
        if (selected && selected[c.id]) e.classList.add("sel");
        if (demanded && demanded[c.id]) e.classList.add("demand");
        if (onPick) {
          e.classList.add("pickable");
          e.addEventListener("click", function () { onPick(c.id); });
        }
        gr.appendChild(e);
      });
      sec.appendChild(gr);
      box.appendChild(sec);
    }

    function chooseCount() {
      title(g.name(seat) + "と手札を全公開", "交換する枚数を決める（最大" + max + "枚）");
      grid("あなたの手札", g.hands[0], "mine");
      grid(g.name(seat) + "の手札", g.hands[seat], "theirs");
      var ctr = h("div", "countrow");
      var num = h("div", "num", String(count));
      ctr.appendChild(btn("−", "navy small", function () { if (count > 1) { count--; num.textContent = count; } }));
      ctr.appendChild(num);
      ctr.appendChild(btn("＋", "navy small", function () { if (count < max) { count++; num.textContent = count; } }));
      box.appendChild(ctr);
      box.appendChild(btn("この枚数で交換する", "red confirm", chooseCards));
    }

    function chooseCards() {
      var demand = g.playerExchangeDemand(seat, count);
      var demandMap = {};
      demand.forEach(function (c) { demandMap[c.id] = true; });
      var selected = {};
      function render() {
        title(g.name(seat) + "と" + count + "枚ずつ交換", "赤枠＝相手が要求するあなたの札。欲しい相手の札を" + count + "枚選ぶ");
        grid("相手が要求するあなたの札", g.hands[0], "mine", null, null, demandMap);
        grid(g.name(seat) + "から欲しい札", g.hands[seat], "theirs", function (id) {
          if (selected[id]) delete selected[id];
          else {
            if (Object.keys(selected).length >= count) return;
            selected[id] = true;
          }
          render();
        }, selected);
        var n = Object.keys(selected).length;
        var ok = btn("交換を確定する（" + n + "/" + count + "）", "red confirm" + (n === count ? "" : " off"), function () {
          if (Object.keys(selected).length !== count) return;
          var takeIds = Object.keys(selected);
          var giveIds = demand.map(function (c) { return c.id; });
          if (g.finishPlayerExchange(seat, takeIds, giveIds)) {
            closeRoot(ov);
            self.selected = {};
            self.render(g);
            self.guide.textContent = self.placeGuide || "";
          }
        });
        box.appendChild(ok);
        box.appendChild(btn("枚数を選び直す", "navy back", chooseCount));
      }
      render();
    }

    chooseCount();
  };

  B.finishInput = function (v) {
    var r = this.resolver;
    this.resolver = null;
    this.mode = "idle";
    this.guide.textContent = "";
    this.guide.classList.remove("trade-fixed");
    this.setButtons();
    this.renderHand(this.game);
    if (r) r(v);
  };

  B.waitInput = function (mode, guide) {
    var self = this;
    this.mode = mode;
    this.selected = {};
    if (mode === "place") this.placeGuide = guide;
    this.guide.textContent = guide;
    this.guide.classList.toggle("trade-fixed", mode === "give");
    this.renderHand(this.game);
    this.setButtons();
    return new Promise(function (resolve) {
      self.resolver = resolve;
      // 降参した後にまた入力を求められたら、待たせずにそのまま返す
      if (self.game && self.game.resigned) {
        setTimeout(function () { self.finishInput(mode === "window" ? { type: "pass" } : []); }, 0);
      }
    });
  };

  /*
   * セリフを1つ言わせる（吹き出し＋ボイス）。
   * 待たせないので、ゲームの進行とずれない。ボイスはキャラごとに分かれていて、
   * 同じキャラが次を言った時だけ前のセリフが止まる。
   */
  B.say = function (g, seat, cat) {
    var id = g.ids[seat];
    var ln = pickLine(id, cat);
    if (!ln) return;
    playVoice(id, cat, ln.index);
    this.showSay({ seat: seat, cat: cat, text: ln.text });
  };

  // 吹き出しは出さず、声だけ鳴らす（カットインの最中など）。
  // 鳴らしたセリフの文章を返すので、呼んだ側が画面にも出せる。
  B.sayVoice = function (g, seat, cat) {
    var id = g.ids[seat];
    var ln = pickLine(id, cat);
    if (!ln) return null;
    playVoice(id, cat, ln.index);
    return ln.text;
  };

  // 吹き出しを出す（text が null のセリフは声だけ）
  B.showSay = function (item) {
    if (item.text == null) return;
    var bub = this.bubble[item.seat];
    if (!bub) return;
    bub.textContent = item.text;
    var shaken = item.cat === "place_shaken" || item.cat === "caught" || item.cat === "doubt_miss";
    bub.classList.toggle("shaken", shaken);
    bub.classList.add("show");
    setFace(this.portraits[item.seat], shaken ? "shaken" : null);
    clearTimeout(bub._t);
    var self = this;
    bub._t = setTimeout(function () {
      bub.classList.remove("show");
      setFace(self.portraits[item.seat], null);
    }, 2200);
  };

  B.flyCards = async function (seat, n) {
    var from = seat === 0 ? { x: 900, y: 760 } : (seat === 1 ? { x: 150, y: 120 } : { x: 1680, y: 120 });
    var to = this.pileEl.getBoundingClientRect ? { x: 930, y: 190 } : { x: 930, y: 190 };
    var flies = [];
    for (var i = 0; i < Math.min(n, 4); i++) {
      var e = h("div", "dbt-fly");
      e.style.backgroundImage = "url('" + D.img.cardBack + "')";
      e.style.left = from.x + i * 12 + "px";
      e.style.top = from.y + "px";
      this.root.appendChild(e);
      flies.push(e);
    }
    await sleep(20);
    flies.forEach(function (e, i) {
      e.style.left = to.x + i * 6 + "px";
      e.style.top = to.y + "px";
      e.style.transform = "rotate(" + (i * 5 - 5) + "deg)";
    });
    await sleep(300);
    flies.forEach(function (e) { closeRoot(e); });
  };

  B.overlayWait = function (ov, ms) {
    this.root.appendChild(ov);
    return new Promise(function (resolve) {
      var done = false;
      function end() {
        if (done) return;
        done = true;
        closeRoot(ov);
        resolve();
      }
      ov.addEventListener("click", end);
      setTimeout(end, ms);
    });
  };

  B.makeIO = function () {
    var ui = this;
    return {
      update: function (g) { ui.render(g); },
      log: function (g, text) { ui.logEl.textContent = text; },
      say: function (g, seat, cat) { ui.say(g, seat, cat); },
      sayLater: function (g, seat, cat, ms) { setTimeout(function () { ui.say(g, seat, cat); }, ms); },
      wait: function (g, ms) { return sleep(ms); },
      placed: async function (g, seat, n) {
        await ui.flyCards(seat, n);
        ui.render(g);
      },
      playerPlace: function (g) {
        ui.game = g;
        return ui.waitInput("place", "〈" + RANK[g.rank] + "〉として伏せる札を選ぶ（1〜" + g.maxPlay + "枚・嘘でもよい）");
      },
      playerDoubt: function (g) {
        ui.game = g;
        var head = g.name(g.last.seat) + "の〈" + RANK[g.last.rank] + "〉×" +
          g.shownPlay(g.last.cards.length, g.last.seat) + "枚　";
        // ダウトが封じられていても、上がりの一手だけは疑える。気づけるように書いておく
        var blocked = g.doubtBlocked();
        var sealed = g.noDoubtPlayer > 0 || g.immune[g.last.seat] > 0;
        var why;
        if (blocked) {
          why = g.noDoubtPlayer > 0 ? "この一巡、あなたはダウトを言えない" : "この伏せ札には、ダウトを言えない";
        } else if (sealed) {
          why = "封じられていても、上がりの一手だけは疑える！";
        } else {
          why = "嘘だと思ったらダウト";
        }
        return ui.waitInput("window", head + why);
      },
      pickGive: function (g, n, placer, offerRank) {
        ui.game = g;
        ui.need = n;
        var offered = offerRank != null
          ? "〈" + RANK[offerRank] + "〉" + n + "枚との交換\n"
          : "";
        return ui.waitInput("give",
          offered + g.name(placer) + "に渡す札を" + n + "枚選ぶ");
      },
      // 真歩流の名指し成功報酬。相手1人の手札を確認してから、自分の札を捨てる。
      guessReward: function (g, n) {
        return new Promise(function (resolve) {
          var ov = h("div", "dbt-overlay dbt-exchange dbt-inspect");
          var box = h("div", "box");
          ov.appendChild(box);
          ui.root.appendChild(ov);

          function miniGrid(label, cards, onPick, selected) {
            var sec = h("div", "handsec");
            sec.appendChild(h("div", "label", label));
            var gr = h("div", "cardgrid");
            sortedCardsForDisplay(cards).forEach(function (c) {
              var e = miniCardEl(c);
              if (selected && selected[c.id]) e.classList.add("sel");
              if (onPick) {
                e.classList.add("pickable");
                e.addEventListener("click", function () { onPick(c.id); });
              }
              gr.appendChild(e);
            });
            sec.appendChild(gr);
            box.appendChild(sec);
          }

          function chooseTarget() {
            box.innerHTML = "";
            box.appendChild(h("div", "q", "名推理成功"));
            box.appendChild(h("div", "sub", "手札を確認する相手を1人選ぶ"));
            var row = h("div", "targets");
            [1, 2].forEach(function (seat) {
              row.appendChild(btn(g.name(seat) + "<small>手札を確認</small>", "navy", function () { inspect(seat); }));
            });
            box.appendChild(row);
          }

          function inspect(target) {
            var selected = {};
            function render() {
              box.innerHTML = "";
              box.appendChild(h("div", "q", g.name(target) + "の手札"));
              box.appendChild(h("div", "sub", "確認したうえで、自分の手札から" + n + "枚を捨てる"));
              miniGrid(g.name(target) + "の手札", g.hands[target]);
              miniGrid("捨てる自分の札", g.hands[0], function (id) {
                if (selected[id]) delete selected[id];
                else {
                  if (Object.keys(selected).length >= n) return;
                  selected[id] = true;
                }
                render();
              }, selected);
              var cnt = Object.keys(selected).length;
              box.appendChild(btn("この札を捨てる（" + cnt + "/" + n + "）", "red confirm" + (cnt === n ? "" : " off"), function () {
                if (Object.keys(selected).length !== n) return;
                closeRoot(ov);
                resolve({ target: target, ids: Object.keys(selected) });
              }));
            }
            render();
          }

          chooseTarget();
        });
      },
      // スキル発動カットイン
      //   data/image/cutin/{キャラid}.png があれば一枚絵を全面に出す
      //   無い場合は、これまで通り色帯＋文字だけのカットインになる
      //   rules.cutinEveryTime が false のときは、同じキャラの2回目以降は
      //   下部の細帯（短縮版）にして進行が止まらないようにする
      cutin: function (g, seat, text) {
        var id = g.ids[seat];
        var ch = D.chara[id];
        // スキル発動のセリフ。声を鳴らしつつ、文章はカットインにも出す
        var line = ui.sayVoice(g, seat, "ability");
        var lineHTML = line ? '<div class="ln">「' + line + '」</div>' : "";
        var repeat = !!ui.cutinShown[id];
        ui.cutinShown[id] = true;

        if (repeat && !D.rules.cutinEveryTime) {
          var mini = h("div", "dbt-overlay dbt-cutin mini");
          var msrc = D.img.cutin(id);
          if (!missing[absUrl(msrc)]) {
            var mart = h("div", "art");
            var mimg = new Image();
            mimg.onerror = function () { missing[absUrl(msrc)] = true; mini.classList.remove("has-art"); };
            mimg.src = msrc;
            mart.appendChild(mimg);
            mini.appendChild(mart);
            mini.classList.add("has-art");
          }
          var mtxt = h("div", "txt", '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>" + lineHTML);
          mtxt.style.borderColor = ch.color;
          mini.appendChild(mtxt);
          return ui.overlayWait(mini, 1100);
        }

        var ov = h("div", "dbt-overlay dbt-cutin");

        var csrc = D.img.cutin(id);
        if (!missing[absUrl(csrc)]) {
          var art = h("div", "art");
          var img = new Image();
          img.onerror = function () {
            missing[absUrl(csrc)] = true;
            ov.classList.remove("has-art");
            if (art.parentNode) art.parentNode.removeChild(art);
          };
          img.src = csrc;
          art.appendChild(img);
          ov.appendChild(art);
          ov.appendChild(h("div", "flash"));
          ov.classList.add("has-art");
        }

        var band = h("div", "band");
        band.style.background = "linear-gradient(90deg, " + ch.color + ", #0b1122 90%)";
        band.appendChild(h("div", "lines"));
        ov.appendChild(band);

        var txt = h("div", "txt", '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>" + lineHTML);
        txt.style.borderColor = ch.color;
        ov.appendChild(txt);
        return ui.overlayWait(ov, 2000);
      },
      notice: function (g, title, sub) {
        var ov = h("div", "dbt-overlay dbt-notice");
        ov.appendChild(h("div", "box", '<div class="t">' + title + '</div><div class="s">' + (sub || "") + "</div>"));
        return ui.overlayWait(ov, 1400);
      },
      reveal: async function (g, info) {
        var ov = h("div", "dbt-overlay dbt-reveal");
        ov.appendChild(h("div", "who",
          g.name(info.doubter) + "のダウト　―　" + g.name(info.placer) + "の〈" + RANK[info.rank] + "〉"));
        var row = h("div", "cards");
        info.cards.forEach(function (c, i) {
          var e = cardEl(c);
          e.style.animationDelay = i * 0.12 + "s";
          if (c.r !== info.rank) e.classList.add("bad");
          row.appendChild(e);
        });
        ov.appendChild(row);
        var v = h("div", "verdict", "");
        ov.appendChild(v);
        var res = h("div", "res", "");
        ov.appendChild(res);
        ui.root.appendChild(ov);
        await sleep(450 + info.cards.length * 120);
        v.textContent = info.isLie ? "嘘！" : (info.suitPass ? "同じ絵柄！" : "本当");
        v.className = "verdict " + (info.isLie ? "lie" : "true");
        var loser = info.isLie ? info.placer : info.doubter;
        res.textContent = info.noTake ? g.name(info.doubter) + "は札を引き取らない" :
          (info.suitPass ? "絵柄が揃っているので〈" + RANK[info.rank] + "〉として通る。" : "") +
          g.name(loser) + "が場の札を引き取る";
        await new Promise(function (resolve) {
          var done = false;
          function end() { if (!done) { done = true; resolve(); } }
          ov.addEventListener("click", end);
          setTimeout(end, 1200);
        });
        closeRoot(ov);
      },
    };
  };

  defineTag("doubt_battle", { pair: "0" }, async function (pm) {
    var idx = pairIndexOf(pm);
    // 中断した時に戻す、この試合が始まる直前の f（アーケードだけ）
    f().doubt_suspended = false;
    var snap = null;
    if (f().doubt_mode === "arcade") {
      try { snap = JSON.parse(JSON.stringify(f())); } catch (e) { console.error("[doubt] 中断用の写しを取れませんでした", e); }
    }
    var ui = new BattleUI(idx);
    var game = new E.DoubtGame({
      data: D, pairIndex: idx, io: ui.makeIO(), level: getLevel(), maxPlay: getMaxPlay()
    });
    ui.game = game;
    window.__doubtGame = game; // 調整・確認用
    var result;
    try {
      result = await game.run();
    } finally {
      await sleep(600);
    }
    var fv = f();
    // 中断：試合前の f を残してタイトルへ（doubt_main.ks の *arcade_suspend）。
    // この試合の勝ち負けやスコアは f に書かない
    if (ui.suspended) {
      if (snap) setSuspend({ f: snap, at: Date.now() });
      fv.doubt_suspended = true;
      var sov = h("div", "dbt-overlay dbt-notice");
      sov.appendChild(h("div", "box", '<div class="t">中断</div>'));
      await ui.overlayWait(sov, 1200);
      ui.close();
      return;
    }
    fv.doubt_win = result.win;
    fv.doubt_gain = result.gain;
    fv.doubt_opp_left = result.oppLeft;
    fv.doubt_stat_attempts = result.stats ? result.stats.doubtAttempts : 0;
    fv.doubt_stat_success = result.stats ? result.stats.doubtSuccess : 0;
    fv.doubt_stat_bluff = result.stats ? result.stats.bluffSuccess : 0;
    fv.doubt_stat_guess = result.stats ? result.stats.guessSuccess : 0;
    var ov = h("div", "dbt-overlay dbt-notice");
    ov.appendChild(h("div", "box",
      '<div class="t">' + (result.resigned ? "降参" : (result.win ? "上がり！" : game.name(result.winner) + "の上がり")) + "</div>"));
    await ui.overlayWait(ov, 1800);
    ui.close();
  });

  // ---------------------------------------------------------------- 結果

  defineTag("doubt_result", { pair: "0" }, function (pm) {
    var pr = D.pairs[pairIndexOf(pm)];
    var fv = f();
    var win = !!fv.doubt_win;
    var lv = levelInfo();
    var base = fv.doubt_gain || 0;
    var winGain = Math.round(base * lv.score);

    var attempts = fv.doubt_stat_attempts || 0;
    var success = fv.doubt_stat_success || 0;
    var bluffSuccess = fv.doubt_stat_bluff || 0;
    var guessSuccess = fv.doubt_stat_guess || 0;
    var accuracy = attempts > 0 ? success / attempts : 0;
    var accuracyBonus = attempts >= D.rules.accuracyBonusMinDoubts &&
      accuracy >= D.rules.accuracyBonusRate ? D.rules.accuracyBonusScore : 0;

    var gain = winGain + accuracyBonus;
    var sc = addScore(fv, gain);
    var after = sc.after;
    var added = sc.added;
    // このステージのラウンドで稼いだ分（ハイアンドローの賭け金になる）
    fv.doubt_round_gain = (fv.doubt_round_gain || 0) + gain;
    var toNext = D.rules.lifeEvery - (after % D.rules.lifeEvery);
    var rt = roundText();
    var accuracyText = attempts > 0 ? Math.round(accuracy * 100) + "%" : "—";

    return new Promise(function (resolve) {
      var root = openRoot("dbt-result" + (win ? "" : " lose"));
      bg(root, win ? D.img.bgWin : D.img.bgLose);
      root.appendChild(h("div", "dbt-shade shade " + (win ? "win" : "lose")));
      root.appendChild(h("div", "stage", "―― " + pr.label + "・決着 ――" + (rt ? "　" + rt : "")));
      root.appendChild(h("div", "big", win ? "勝利" : "敗北"));
      root.appendChild(h("div", "catch", win ? "嘘を、ぜんぶ剥がした" : "嘘に、呑まれた"));

      var scoreDetail = win
        ? "相手の残り札 " + fv.doubt_opp_left + "枚 × " + D.rules.scorePerCard +
          (lv.score !== 1 ? "　" + lv.name + " ×" + lv.score : "")
        : "勝利時のみ加算";
      if (accuracyBonus > 0) {
        scoreDetail += '<br><b class="bonus">読み切りボーナス ＋' + accuracyBonus.toLocaleString() + "点</b>";
      }
      root.appendChild(h("div", "panel p1",
        '<div class="k">この対戦</div><div class="v">' + gain.toLocaleString() + "<small>点</small></div>" +
        '<div class="d">' + scoreDetail + "</div>"));

      root.appendChild(h("div", "panel p2",
        '<div class="k">通算</div><div class="v">' + after.toLocaleString() + "<small>点</small></div>" +
        '<div class="d">次の残機まで あと' + toNext.toLocaleString() + "点</div>"));

      var lives = "";
      for (var i = 0; i < fv.doubt_lives; i++) lives += "<i" + (i >= fv.doubt_lives - added ? ' class="new"' : "") + "></i>";
      root.appendChild(h("div", "panel p3",
        '<div class="k">残機</div><div class="lives">' + lives + "</div>" +
        '<div class="d">' + (added > 0 ? "残機が" + added + "つ増えた（＋" + added + "）" : "コンティニューできる回数") + "</div>"));

      root.appendChild(h("div", "panel pstats",
        '<div class="k">戦績</div><div class="stats">' +
          '<div class="stat"><span>ダウト成功率</span><b>' + accuracyText + '</b><small>' + success + " / " + attempts + "</small></div>" +
          '<div class="stat"><span>嘘の成功</span><b>' + bluffSuccess + '</b><small>回</small></div>' +
          '<div class="stat"><span>名指し成功</span><b>' + guessSuccess + '</b><small>回</small></div>' +
        "</div>"));

      root.appendChild(btn("次へ", "next", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- ラウンド
  //   設定画面で決めた数を先に勝った方が、その卓の勝ち。
  //   卓に着く前と、コンティニューでやり直す前に呼んで数え直す。

  defineTag("doubt_round_init", {}, function () {
    var fv = f();
    fv.doubt_rounds = getRounds();
    fv.doubt_round = 1;
    fv.doubt_win_count = 0;
    fv.doubt_lose_count = 0;
    fv.doubt_round_gain = 0;
  });

  // ---------------------------------------------------------------- 物語のスキップ
  //   doubt_story.ks の *setup で出し、*finish で消す。
  //   押すとティラノ本体のスキップに入り、*finish の [skipstop] で自然に止まる。
  //   画面全面は覆わないので、本文のクリック送りはそのまま使える。

  defineTag("doubt_skip", { show: "true" }, function (pm) {
    var old = document.querySelector(".dbt-skipbtn");
    if (old && old.parentNode) old.parentNode.removeChild(old);
    if (pm.show === "false") return;

    var base = document.querySelector(".tyrano_base") || document.body;
    var b = h("div", "dbt-skipbtn dbt-btn navy", "スキップ<small>物語を飛ばす</small>");
    b.addEventListener("click", function (ev) {
      ev.stopPropagation();
      if (b.parentNode) b.parentNode.removeChild(b);
      try {
        // 文字を出している最中は skipstart が弾かれるので、本体と同じ手順で入る
        if (TYRANO.kag.stat.is_adding_text) TYRANO.kag.setSkip(true, {});
        else TYRANO.kag.ftag.startTag("skipstart", {});
      } catch (e) { console.error("[doubt] スキップに入れませんでした", e); }
    });
    base.appendChild(b);
  });

  // ---------------------------------------------------------------- デバッグ
  //   アーケードの好きな卓から始める。通算スコアと残機も決められるので、
  //   隠し戦の出現条件やコンティニューまわりの確認にも使える。
  //   タイトルのボタンは rules.debugMenu で消せる。

  defineTag("doubt_debug", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-debug");
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "hd", "デバッグ"));
      root.appendChild(h("div", "sub", "アーケードプレイを、好きなところから始めます"));

      var pick = { stage: 0, story: 1, total: 0, lives: 1 };
      var rows = [];

      function row(label, note, items, key) {
        var box = h("div", "row");
        box.appendChild(h("div", "k", label + (note ? '<small>' + note + "</small>" : "")));
        var opts = h("div", "opts");
        var cells = [];
        items.forEach(function (it) {
          var b = btn(it.t, "navy cell", function () { pick[key] = it.v; sync(); });
          b._v = it.v;
          cells.push(b);
          opts.appendChild(b);
        });
        box.appendChild(opts);
        box._sync = function () {
          cells.forEach(function (c) { c.classList.toggle("on", c._v === pick[key]); });
        };
        rows.push(box);
        root.appendChild(box);
      }

      function sync() { rows.forEach(function (r) { r._sync(); }); }

      row("卓", "ここから始める", D.pairs.map(function (pr, i) {
        return { t: pr.label + "<small>" + D.chara[pr.a].name + "×" + D.chara[pr.b].name + "</small>", v: i };
      }), "stage");
      row("入り方", "", [
        { t: "物語から", v: 1 },
        { t: "対戦から<small>会話を飛ばす</small>", v: 0 },
      ], "story");
      row("通算スコア", "隠し戦の条件は " + D.rules.hiddenScore.toLocaleString() + "点", [
        { t: "0", v: 0 },
        { t: "20,000", v: 20000 },
        { t: (D.rules.hiddenScore).toLocaleString(), v: D.rules.hiddenScore },
      ], "total");
      row("残機", "", [{ t: "1", v: 1 }, { t: "3", v: 3 }, { t: "5", v: 5 }], "lives");
      sync();

      function finish(go) {
        var fv = f();
        fv.doubt_debug_go = go;
        if (go) {
          fv.doubt_mode = "arcade";
          fv.doubt_stage = pick.stage;
          fv.doubt_total = pick.total;
          fv.doubt_lives = pick.lives;
          fv.doubt_debug_story = !!pick.story;
        }
        closeRoot(root);
        resolve();
      }

      var cmds = h("div", "cmds");
      cmds.appendChild(btn("ここから始める", "red", function () { finish(true); }));
      cmds.appendChild(btn("もどる", "navy", function () { finish(false); }));
      root.appendChild(cmds);
    });
  });

  // ---------------------------------------------------------------- フリーゲームへのキャラクター解放

  function showFreeUnlock(ids) {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-unlock");
      root.appendChild(h("div", "hd", "解放"));

      var ports = h("div", "ports");
      ids.forEach(function (id) { ports.appendChild(portrait(id)); });
      root.appendChild(ports);

      var names = ids.map(function (id) { return D.chara[id].name; });
      root.appendChild(h("div", "t", names.join(" と ")));
      root.appendChild(h("div", "s",
        names.join(" と ") + " がフリーゲームに解放されました"));

      root.appendChild(btn("つぎへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  }

  // 隠しの二人を倒した時だけ、一度だけ解放通知を出す
  defineTag("doubt_unlock_hidden", {}, function () {
    var already = isHiddenCleared();
    try {
      TYRANO.kag.variable.sf.doubt_hidden_cleared = 1;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 解放フラグの保存に失敗しました", e); }
    if (already) return;

    var pr = D.pairs[D.pairs.length - 1];
    return showFreeUnlock([pr.a, pr.b]);
  });

  // ---------------------------------------------------------------- 余興（ハイアンドロー）
  //   ラウンドを一度も落とさずに勝ち抜いた時だけ挟む。挑むかどうかは任意。
  //   当てれば、そのステージで稼いだ点が2倍。外せば半分。
  //   （通算スコアのうち、増減するのは賭けた分だけ）

  function drawRank() { return 1 + Math.floor(Math.random() * 13); }

  function hiloCard(r, faceDown) {
    if (faceDown) {
      var b = h("div", "dbt-card back");
      b.style.backgroundImage = "url('" + D.img.cardBack + "')";
      return b;
    }
    return cardEl({ id: "hl" + r + "_" + Math.random(), r: r, s: Math.floor(Math.random() * 4) });
  }

  defineTag("doubt_highlow", {}, function () {
    var fv = f();
    var bet = fv.doubt_round_gain || 0;
    if (bet <= 0) return;   // 賭けるものが無ければ、そのまま次へ

    return new Promise(function (resolve) {
      var root = openRoot("dbt-highlow");
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "hd", "館主の余興"));
      root.appendChild(h("div", "sub", "ハイアンドロー"));
      var info = h("div", "bet",
        '<span class="k">賭ける点</span><span class="v">' + bet.toLocaleString() + "</span>" +
        '<span class="d">当たれば2倍（＋' + bet.toLocaleString() + "）／外せば半分（－" + (bet - Math.floor(bet / 2)).toLocaleString() + "）</span>");
      root.appendChild(info);

      var table = h("div", "table");
      root.appendChild(table);
      var msg = h("div", "msg", "この札より、次の札は大きいか小さいか。");
      root.appendChild(msg);
      var cmds = h("div", "cmds");
      root.appendChild(cmds);

      function clear(el) { el.innerHTML = ""; }

      function finish() {
        closeRoot(root);
        resolve();
      }

      // ---- 挑むかどうか ----
      function ask() {
        clear(table);
        clear(cmds);
        msg.textContent = "一度も落とさずに勝ち抜いた褒美だ。ひと勝負、どうかね。";
        cmds.appendChild(btn("挑戦する<small>当たれば2倍、外せば半分</small>", "red", play));
        cmds.appendChild(btn("やめておく<small>点はそのまま</small>", "navy", finish));
      }

      // ---- 1枚目を出して、ハイ／ローを選ばせる ----
      function play() {
        var first = drawRank();
        clear(table);
        clear(cmds);
        table.appendChild(hiloCard(first));
        table.appendChild(h("div", "vs", "→"));
        var slot = h("div", "slot");
        slot.appendChild(hiloCard(0, true));
        table.appendChild(slot);
        msg.textContent = "次の札は、この札より大きいか小さいか。";
        cmds.appendChild(btn("ハイ<small>大きい</small>", "red", function () { reveal(first, "hi", slot); }));
        cmds.appendChild(btn("ロー<small>小さい</small>", "navy", function () { reveal(first, "lo", slot); }));
      }

      // ---- 2枚目をめくる。同じ数字なら引き直し ----
      function reveal(first, pick, slot) {
        clear(cmds);
        var second = drawRank();
        while (second === first) second = drawRank();   // 引き分けは作らない
        clear(slot);
        slot.appendChild(hiloCard(second));
        var hit = pick === "hi" ? second > first : second < first;
        var delta = hit ? bet : -(bet - Math.floor(bet / 2));
        var sc = addScore(fv, delta);
        fv.doubt_round_gain = hit ? bet * 2 : Math.floor(bet / 2);
        root.classList.add(hit ? "hit" : "miss");
        msg.innerHTML = '<b class="' + (hit ? "hit" : "miss") + '">' + (hit ? "的中！" : "外れ") + "</b>" +
          "　この戦いの点は " + bet.toLocaleString() + " → " + fv.doubt_round_gain.toLocaleString() + " 点" +
          (sc.added > 0 ? "　（残機が" + sc.added + "つ増えた）" : "");
        cmds.appendChild(h("div", "total", '<span class="k">通算</span><span class="v">' + sc.after.toLocaleString() + "</span>"));
        cmds.appendChild(btn("つぎへ", "navy", finish));
      }

      ask();
    });
  });

  // ---------------------------------------------------------------- 残機ボーナス
  //   遊び終わった時、残った残機1つにつき rules.lifeBonus 点を通算に足す

  defineTag("doubt_bonus", {}, function () {
    var fv = f();
    var lives = fv.doubt_lives || 0;
    var bonus = lives * D.rules.lifeBonus;
    if (bonus <= 0) return;
    var sc = addScore(fv, bonus);

    return new Promise(function (resolve) {
      var root = openRoot("dbt-bonus");
      root.appendChild(h("div", "hd", "残機ボーナス"));
      var marks = "";
      for (var i = 0; i < lives; i++) marks += "<i></i>";
      root.appendChild(h("div", "lives", marks));
      root.appendChild(h("div", "calc",
        "残り" + lives + "機 × " + D.rules.lifeBonus.toLocaleString() + "点"));
      root.appendChild(h("div", "plus", "＋" + bonus.toLocaleString()));
      root.appendChild(h("div", "total",
        '<span class="k">通算スコア</span><span class="v">' + sc.after.toLocaleString() + "</span>"));
      root.appendChild(btn("つぎへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- 設定
  //   ラウンド数はシステム変数に持たせるので、ゲームを閉じても残る

  defineTag("doubt_settings", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-settings");
      bg(root, D.img.bgTitle);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "hd", "設定"));

      // ---- 難易度 ----
      var lvNow = getLevel();
      var lvBox = h("div", "item level");
      lvBox.appendChild(h("div", "k", "難易度"));
      lvBox.appendChild(h("div", "d",
        "相手の読みの鋭さと、得点の倍率が変わります。<br>" +
        "やさしいほど慎重に、むずかしいほど公開情報と見込みを重く見て判断します。"));
      var lvOpts = h("div", "opts");
      var lvCells = [];
      function chooseLevel(v) {
        lvNow = v;
        setLevel(v);
        lvCells.forEach(function (c, i) { c.classList.toggle("on", i === v); });
      }
      D.rules.levels.forEach(function (lv, i) {
        var c = btn(lv.name + "<small>得点 ×" + lv.score + "<br>" + lv.note + "</small>", "navy cell wide",
          function () { chooseLevel(i); });
        lvCells.push(c);
        lvOpts.appendChild(c);
      });
      lvBox.appendChild(lvOpts);
      root.appendChild(lvBox);
      chooseLevel(lvNow);

      // ---- ラウンド数 ----
      var cur = getRounds();
      var box = h("div", "item rounds");
      box.appendChild(h("div", "k", "アーケードプレイのラウンド数"));
      box.appendChild(h("div", "d",
        "一つの卓で先に決めた数だけ勝てば、次の卓へ進めます。" +
        "相手が先にその数だけ勝つと敗北です。"));
      var opts = h("div", "opts");
      var cells = [];
      function choose(v) {
        cur = v;
        setRounds(v);
        cells.forEach(function (c, i) { c.classList.toggle("on", i + 1 === v); });
      }
      for (var i = 1; i <= D.rules.roundMax; i++) {
        (function (v) {
          var c = btn(v + "<small>" + (v === 1 ? "1勝で突破" : v + "先取") + "</small>", "navy cell",
            function () { choose(v); });
          cells.push(c);
          opts.appendChild(c);
        })(i);
      }
      box.appendChild(opts);
      root.appendChild(box);
      choose(cur);

      // ---- カスタムルール：一度に出せる札 ----
      var maxNow = getMaxPlay();
      var mpBox = h("div", "item maxplay");
      mpBox.appendChild(h("div", "k", "一度に出せる札の上限"));
      mpBox.appendChild(h("div", "d",
        "1回の手番で伏せられる札の最大枚数を変更します。既定は4枚です。"));
      var mpOpts = h("div", "opts");
      var mpCells = [];
      function chooseMaxPlay(v) {
        maxNow = v;
        setMaxPlay(v);
        mpCells.forEach(function (c) { c.classList.toggle("on", c._v === v); });
      }
      var mpMin = D.rules.maxPlayMin || 1;
      var mpMax = D.rules.maxPlayMax || D.rules.maxPlay;
      for (var n = mpMin; n <= mpMax; n++) {
        (function (v) {
          var c = btn(v + "<small>最大" + v + "枚</small>", "navy cell compact",
            function () { chooseMaxPlay(v); });
          c._v = v;
          mpCells.push(c);
          mpOpts.appendChild(c);
        })(n);
      }
      mpBox.appendChild(mpOpts);
      root.appendChild(mpBox);
      chooseMaxPlay(maxNow);

      root.appendChild(btn("とじる", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- コンティニュー

  defineTag("doubt_continue", {}, function () {
    var fv = f();
    if (!(fv.doubt_lives > 0)) {
      fv.doubt_continue = false;
      return;
    }
    return new Promise(function (resolve) {
      var root = openRoot("dbt-continue");
      bg(root, D.img.bgContinue);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "q", "まだ遊ぶかい"));
      var marks = "";
      for (var i = 0; i < fv.doubt_lives; i++) marks += "<i></i>";
      root.appendChild(h("div", "rest", marks + "<span>残り</span><b>" + fv.doubt_lives + "</b><span>回</span>"));
      root.appendChild(btn("つづける<small>同じ相手に、もう一度</small>", "red yes", function () {
        fv.doubt_lives--;
        fv.doubt_continue = true;
        fv.doubt_used_continue = true;   // 隠しの二人の出現条件に使う
        closeRoot(root);
        resolve();
      }));
      root.appendChild(btn("あきらめる<small>今日の勝負は、ここでお開き</small>", "no", function () {
        fv.doubt_continue = false;
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- ゲームオーバー

  defineTag("doubt_gameover", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-gameover");
      bg(root, D.img.bgGameover);
      root.appendChild(h("div", "flood"));
      root.appendChild(h("div", "go", "GAME OVER"));
      root.appendChild(h("div", "t", "今日はお開き"));
      root.appendChild(h("div", "q", "「今日はここまで。<br>また今度おいで、お客人」"));
      root.appendChild(btn("タイトルへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- ランキング
  //   sf（システム変数）に保存するので、ゲームを閉じても残る
  //   1件 = { n: 名前（最大5文字）, s: 通算スコア }

  function rankingList() {
    var v = sysVar().doubt_ranking;
    if (typeof v === "string") { try { v = JSON.parse(v); } catch (e) { v = null; } }
    if (!(v instanceof Array)) return [];
    return v.filter(function (r) { return r && typeof r.s === "number"; })
      .sort(function (a, b) { return b.s - a.s; })
      .slice(0, D.rules.rankingSize);
  }

  function rankingSave(list) {
    var kag = TYRANO.kag;
    kag.variable.sf.doubt_ranking = list;
    try { kag.saveSystemVariable(); }
    catch (e) { console.error("[doubt] ランキングの保存に失敗しました", e); }
  }

  function rankingIn(score) {
    var l = rankingList();
    return score > 0 && (l.length < D.rules.rankingSize || score > l[l.length - 1].s);
  }

  // 「゛」「゜」は直前の一文字に付ける（か→が、は→ぱ）
  var DAKU = "かきくけこさしすせそたちつてとはひふへほう";
  var HANDAKU = "はひふへほ";
  var KEYS_KANA = [
    "あいうえおかきくけこ", "さしすせそたちつてと", "なにぬねのはひふへほ",
    "まみむめもやゆよらり", "るれろわをんーぁぃぅ", "ぇぉっゃゅょ゛゜　",
  ];
  var KEYS_ABC = [
    "ABCDEFGHIJ", "KLMNOPQRST", "UVWXYZ0123", "456789-.!?", "&+*/　",
  ];

  function nameEntry(score) {
    return new Promise(function (resolve) {
      var max = D.rules.nameMax;
      var root = openRoot("dbt-nameentry");
      bg(root, D.img.bgTitle);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "hd", "RANKING IN"));
      root.appendChild(h("div", "sub", "名前を入れてください（" + max + "文字まで）"));
      root.appendChild(h("div", "sc", '<span class="k">通算スコア</span><span class="v">' + score.toLocaleString() + "</span>"));

      var name = "";
      var slots = h("div", "slots");
      root.appendChild(slots);

      function drawSlots() {
        slots.innerHTML = "";
        for (var i = 0; i < max; i++) {
          var cell = h("div", "cell" + (i === name.length ? " cur" : ""), name.charAt(i) || "");
          slots.appendChild(cell);
        }
        bOk.classList.toggle("off", name.length === 0);
      }

      function put(c) {
        if (c === "゛" || c === "゜") {
          if (!name.length) return;
          var last = name.charAt(name.length - 1);
          var add = c === "゛" ? (DAKU.indexOf(last) >= 0 ? 1 : 0) : (HANDAKU.indexOf(last) >= 0 ? 2 : 0);
          if (!add) return;
          name = name.slice(0, -1) + String.fromCharCode(last.charCodeAt(0) + add);
          drawSlots();
          return;
        }
        if (name.length >= max) return;
        name += c;
        drawSlots();
      }

      var keys = h("div", "keys");
      root.appendChild(keys);

      function drawKeys(rows) {
        keys.innerHTML = "";
        rows.forEach(function (line) {
          var row = h("div", "krow");
          for (var i = 0; i < line.length; i++) {
            (function (c) {
              var label = c, cls = "navy key";
              if (c === "\u3000" || c === " ") { label = "\u2423"; }
              else if (c === "\u309b") { label = "だく"; cls += " mark"; }
              else if (c === "\u309c") { label = "はんだく"; cls += " mark"; }
              row.appendChild(btn(label, cls, function () { put(c === " " ? "\u3000" : c); }));
            })(line.charAt(i));
          }
          keys.appendChild(row);
        });
      }

      var tabs = h("div", "tabs");
      var tKana = btn("かな", "navy tab on", function () { setTab(0); });
      var tAbc = btn("ABC", "navy tab", function () { setTab(1); });
      tabs.appendChild(tKana);
      tabs.appendChild(tAbc);
      root.appendChild(tabs);

      function setTab(k) {
        tKana.classList.toggle("on", k === 0);
        tAbc.classList.toggle("on", k === 1);
        drawKeys(k === 0 ? KEYS_KANA : KEYS_ABC);
      }

      function finish() {
        document.removeEventListener("keydown", onKey);
        closeRoot(root);
        resolve(name.replace(/\u3000+$/, "") || "ななし");
      }

      var cmds = h("div", "cmds");
      var bDel = btn("けす", "navy", function () {
        if (!name.length) return;
        name = name.slice(0, -1);
        drawSlots();
      });
      var bOk = btn("きめる", "red", function () { if (name.length) finish(); });
      cmds.appendChild(bDel);
      cmds.appendChild(bOk);
      root.appendChild(cmds);
      root.appendChild(h("div", "hint", "キーボードでも入力できます（Backspace＝けす／Enter＝きめる）"));

      function onKey(ev) {
        if (ev.key === "Backspace") {
          ev.preventDefault();
          if (name.length) { name = name.slice(0, -1); drawSlots(); }
        } else if (ev.key === "Enter") {
          if (name.length) finish();
        } else if (ev.key.length === 1) {
          var c = ev.key;
          if (/[a-z]/.test(c)) c = c.toUpperCase();
          if (/[A-Z0-9 .!?\-&+*/]/.test(c)) put(c === " " ? "\u3000" : c);
          else if (/[\u3040-\u309f\u30fc]/.test(c)) put(c);
        }
      }
      document.addEventListener("keydown", onKey);

      setTab(0);
      drawSlots();
    });
  }

  function rankingScreen(newIndex) {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-ranking");
      bg(root, D.img.bgTitle);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "hd", "RANKING"));
      root.appendChild(h("div", "sub", "アーケードプレイ　通算スコア"));
      var list = rankingList();
      var rows = h("div", "rows");
      for (var i = 0; i < D.rules.rankingSize; i++) {
        var r = list[i];
        var row = h("div", "row" + (i === newIndex ? " new" : "") + (r ? "" : " empty"));
        row.innerHTML =
          '<span class="no">' + (i + 1) + "</span>" +
          '<span class="nm">' + (r ? r.n : "ーーーーー") + "</span>" +
          '<span class="pt">' + (r ? r.s.toLocaleString() : "0") + "</span>";
        rows.appendChild(row);
      }
      root.appendChild(rows);
      root.appendChild(btn("タイトルへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  }

  // [doubt_ranking]                … ランキングを見るだけ
  // [doubt_ranking register="true"] … 今回のスコアが5位以内なら名前を入れて登録
  defineTag("doubt_ranking", { register: "false" }, async function (pm) {
    var score = f().doubt_total || 0;
    var newIndex = -1;
    if (String(pm.register) === "true" && rankingIn(score)) {
      var name = await nameEntry(score);
      var list = rankingList();
      var entry = { n: name, s: score };
      list.push(entry);
      list.sort(function (a, b) { return b.s - a.s; });
      newIndex = list.indexOf(entry);
      rankingSave(list.slice(0, D.rules.rankingSize));
    }
    await rankingScreen(newIndex);
  });

  // ---------------------------------------------------------------- 体験版終了

  defineTag("doubt_demo_end", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-demoend");
      bg(root, D.img.bgTitle);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "t", "体験版はここまで"));
      root.appendChild(h("div", "msg",
        "愛理と和人との第一戦を遊んでいただき、ありがとうございます。<br>" +
        "舞黒館では、まだ別の参加者たちが待っています。"));
      root.appendChild(btn("タイトルへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- 全戦突破

  defineTag("doubt_clear", {}, async function () {
    var fv = f();
    var already = isCleared();

    // フリーゲームで最終戦の二人を選べるようにする
    try {
      TYRANO.kag.variable.sf.doubt_cleared = 1;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 突破フラグの保存に失敗しました", e); }

    await new Promise(function (resolve) {
      var root = openRoot("dbt-clear");
      root.appendChild(h("div", "t", "全戦突破"));
      root.appendChild(h("div", "s", "通算スコア"));
      root.appendChild(h("div", "v", (fv.doubt_total || 0).toLocaleString()));
      root.appendChild(btn("つぎへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });

    // 既に解放済みなら、同じ通知を繰り返さない
    if (!already && D.pairs[4]) {
      await showFreeUnlock([D.pairs[4].a, D.pairs[4].b]);
    }
  });
})();
