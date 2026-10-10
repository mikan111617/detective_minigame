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
 * [doubt_stock pair=0]     倒した二人の能力を一つだけ持ち帰る → f.doubt_stock
 * [doubt_bonus]            残機ボーナスを通算に足す
 * [doubt_settings]         設定画面（難易度・ラウンド数・出札上限・カード枚数）
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

  // A loaded save owns a new execution generation. Old async tags must never
  // advance its scenario or write their battle results into its variables.
  var lifecycle = window.__doubtLifecycle || (window.__doubtLifecycle = { generation: 0 });
  var cancelled = { doubtCancelled: true };
  function invalidateSession() {
    lifecycle.generation++;
    if (lifecycle.battle) {
      var old = lifecycle.battle;
      lifecycle.battle = null;
      old.game.resign();
      old.finishInput(old.mode === "window" ? { type: "pass" } : []);
      old.close();
    }
    stopAllVoice();
    document.querySelectorAll(".dbt-root, .dbt-skipbtn").forEach(closeRoot);
    window.__doubtGame = null;
  }
  lifecycle.invalidate = invalidateSession;
  if (!lifecycle.loadHookInstalled) {
    var originalLoad = TYRANO.kag.menu.loadGameData;
    TYRANO.kag.menu.loadGameData = function () {
      lifecycle.invalidate();
      return originalLoad.apply(this, arguments);
    };
    lifecycle.loadHookInstalled = true;
  }

  // ---------------------------------------------------------------- 共通

  function sleep(ms) {
    var generation = lifecycle.generation;
    return new Promise(function (r) { setTimeout(r, ms); }).then(function () {
      if (generation !== lifecycle.generation) throw cancelled;
    });
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
    if (window.I18N && window.I18N.isEN()) root.classList.add("dbt-en");
    base.appendChild(root);
    // 次の画面を先に置いてから前画面を外す。先に消すと下のTyranoレイヤーが
    // 一瞬露出し、ゲームオーバー後などに直前の対戦前画面がフラッシュする。
    document.querySelectorAll(".dbt-root.dbt-handoff").forEach(function (old) {
      if (old !== root) closeRoot(old);
    });
    return root;
  }

  function closeRoot(root) {
    if (root && root.parentNode) root.parentNode.removeChild(root);
  }

  function handoffRoot(root) {
    if (!root) return;
    root.classList.add("dbt-handoff");
    root.style.pointerEvents = "none";
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

  // ---- D案の見た目のための小さな部品 ----
  // 新しく足した文言は、行ごとの翻訳表ではなくここで日本語／英語を出し分ける
  function tr(ja, en) { return window.I18N && window.I18N.isEN() ? en : ja; }

  // 見出しの左右に、細い金線と菱形を付ける
  function decoWrap(el) {
    var w = h("div", "dbt-deco");
    w.appendChild(h("i", ""));
    w.appendChild(h("em", ""));
    w.appendChild(el);
    w.appendChild(h("em", ""));
    w.appendChild(h("i", ""));
    return w;
  }

  // 画面左下の共通「もどる」ボタン。文言はそのまま、左に矢印を付ける
  function asBack(b) {
    b.classList.add("dbt-backbtn");
    b.insertBefore(h("span", "bk-arrow", "‹"), b.firstChild);
    return b;
  }

  var ICON_INFO = '<svg class="ic" viewBox="0 0 24 24" width="34" height="34" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9.5"></circle><line x1="12" y1="10.5" x2="12" y2="17"></line><circle cx="12" cy="7.3" r="1.1" fill="currentColor" stroke="none"></circle></svg>';
  var ICON_PAUSE = '<svg class="ic" viewBox="0 0 24 24" width="34" height="34" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="6.5" y="5" width="3.6" height="14" rx="1"></rect><rect x="13.9" y="5" width="3.6" height="14" rx="1"></rect></svg>';

  // 切符の形のボタン（タイトル）。もとの文言を本体に入れ、左に半券を付ける
  function asTicket(b, mark) {
    var body = h("span", "ticket-body");
    while (b.firstChild) body.appendChild(b.firstChild);
    b.appendChild(h("span", "ticket-stub", mark));
    b.appendChild(body);
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
    if (voiceNG[url]) return null;
    var vol = seVolume() * (V.volume != null ? V.volume : 1);
    if (!(vol > 0)) return null;

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
    return a;
  }

  /*
   * 鳴らした声が終わるまで待つ（掛け合いで声を重ねないため）。
   * ファイルが無い・鳴らせない時は、吹き出しを読める程度に待つ。長すぎる声は上限で打ち切る。
   */
  function waitVoice(a, minMs, maxMs) {
    return new Promise(function (resolve) {
      var t0 = Date.now();
      var done = false;
      function finish() {
        if (done) return;
        done = true;
        setTimeout(resolve, Math.max(0, minMs - (Date.now() - t0)));
      }
      if (!a) { finish(); return; }
      a.addEventListener("ended", finish);
      a.addEventListener("error", finish);
      setTimeout(finish, maxMs);
    });
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

  // 基本デッキの枚数。52枚＝通常、26枚＝短時間向け。
  function getDeckSize() {
    var v = 0;
    try { v = parseInt(sysVar().doubt_deck_size, 10); } catch (e) {}
    var opts = D.rules.deckSizeOptions || [52, 26];
    if (opts.indexOf(v) < 0) v = D.rules.deckSizeDefault || 52;
    return v;
  }

  function setDeckSize(v) {
    try {
      TYRANO.kag.variable.sf.doubt_deck_size = v;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] カード枚数の保存に失敗しました", e); }
  }

  // 今のラウンド状況の一行（1ラウンド制の時は何も出さない）
  function roundText() {
    var fv = f();
    var need = parseInt(fv.doubt_rounds, 10) || 1;
    if (need <= 1) return "";
    return "第" + (fv.doubt_round || 1) + "ラウンド　" + need + "先取　" +
      "あなた " + (fv.doubt_win_count || 0) + " － " + (fv.doubt_lose_count || 0) + " 相手";
  }

  // 能力名（doubt_data.js の skillName）。無ければ空
  var SUB_IDS = { hand_swap: 1, taunt: 1, mary_deal: 1, jushika_sight: 1, eruku_deal: 1, free_doubt: 1, arther_deck: 1 };
  // 二つ目の能力なら、その持ち主のキャラid（立ち絵を出すため）
  function ownerOf(id) {
    if (!SUB_IDS[id]) return id;
    if (id === "hand_swap" || id === "taunt") return "mahoru";
    for (var k in D.chara) { if (D.chara.hasOwnProperty(k) && D.chara[k].sub === id) return k; }
    return "mahoru";
  }
  function abilName(id) {
    var n = D.skillName && D.skillName[id];
    return n || (SUB_IDS[id] && D.chara[id] ? D.chara[id].name : "");
  }
  // スキル表示に能力名を添える。二つ目の能力は人物名の代わりに能力名を出す
  var baseSkillHTML = skillHTML;
  skillHTML = function (id, useText, extraName) {
    var html = baseSkillHTML(id, useText, extraName);
    var nm = D.skillName && D.skillName[id];
    if (!nm) return html;
    if (SUB_IDS[id]) return html.replace(">" + D.chara[id].name, ">" + nm);
    var at = html.indexOf("</span>");
    return html.slice(0, at) + '<small class="sn">' + nm + "</small>" + html.slice(at);
  };

  // 二つ目の能力（sub）を持っているキャラは、続けて並べる
  function skillWithSub(id, extraName) {
    var ch = D.chara[id];
    var html = skillHTML(id, null, extraName);
    if (ch.sub && D.chara[ch.sub]) {
      html += '<div class="subsk">' + skillHTML(ch.sub, "1ゲーム" + ch.subUses + "回", "（二つ目の力）") + "</div>";
    }
    return html;
  }

  // ストック（アーケードで持ち帰った能力）。フリー対戦では使わない
  function stockId() {
    var fv = f();
    var id = fv.doubt_mode === "arcade" ? fv.doubt_stock : (fv.doubt_mode === "simple" ? fv.doubt_borrow : "");
    return id && D.chara[id] ? id : "";
  }
  function stockUses(id) {
    var u = D.stockUses && D.stockUses[id];
    return u != null ? u : D.chara[id].uses;
  }
  function stockOption() {
    var id = stockId();
    return id ? { id: id, uses: stockUses(id) } : null;
  }
  function stockUseText(left) {
    return left < 0 ? "常時" : "残り" + Math.max(0, left) + "回";
  }
  // ストックした時だけ付く効果
  function stockNoteHTML(id) {
    var note = D.stockNote && D.stockNote[id];
    return note ? '<div class="ab stocknote">＋' + note + "</div>" : "";
  }
  // VS画面などで、真歩流の下に並べるストックの説明
  function stockHTML() {
    var id = stockId();
    if (!id) return "";
    var u = stockUses(id);
    return '<div class="subsk">' + skillHTML(id, u < 0 ? "常時" : "1ゲーム" + u + "回", "（ストック）") + stockNoteHTML(id) + "</div>";
  }

  // フリー対戦で借りた能力は「ストック」ではなく「借りた力」と見せる
  function isBorrowMode() { var fv = f(); return fv.doubt_mode === "simple" && !!fv.doubt_borrow; }
  function relabelStock(html) {
    if (!isBorrowMode()) return html;
    return String(html).replace(/（ストック）/g, tr("（借りた力）", " (Borrowed)")).replace(/ ?\(Stock\)/g, tr("（借りた力）", " (Borrowed)"));
  }
  var baseStockHTML = stockHTML;
  stockHTML = function () { return relabelStock(baseStockHTML()); };

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
        var generation = lifecycle.generation;
        var stat = kag.stat;
        function current() { return generation === lifecycle.generation && stat === kag.stat; }
        kag.layer.hideEventLayer();
        Promise.resolve()
          .then(function () { if (current()) return fn(p); })
          .catch(function (e) { if (!current() || e === cancelled) return; console.error("[doubt] " + name, e); window.__doubtError = String(e && e.stack || e); })
          .then(function () { if (current()) kag.ftag.nextOrder(); });
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

  /*
   * タイトルのボタンから title.ks のラベルへ飛ぶ。
   *   title.ks は [doubt_title] → [playbgm] → [s] の順なので、タイトルが出てから
   *   title.mp3 の読み込みが終わるまでの間は、まだ [s] に着いていない。
   *   その間に [jump] すると、[playbgm] の続きと飛び先の二本が同時に進んでしまう。
   *   そこで [s] に着く（is_strong_stop が立つ）のを待ってから飛ぶ。
   *   音声がまだ解禁されていない時の [playbgm] は、本体の画面のクリックを待っている。
   *   ボタンのクリックは本体に渡さないので、その待ちをここで代わりに解いておく。
   */
  function jumpFromTitle(target) {
    var kag = TYRANO.kag;
    if (!kag.stat.is_strong_stop) {
      try { $(".tyrano_base").trigger("click.bgm"); } catch (e) {}
    }
    var generation = lifecycle.generation;
    var waited = 0;
    (function tryJump() {
      if (generation !== lifecycle.generation) return;
      // 万一 [s] に着かなくても、画面が止まったままにならないよう 5 秒で飛ぶ
      if (kag.stat.is_strong_stop || waited >= 5000) {
        kag.ftag.startTag("jump", { storage: "title.ks", target: target });
        return;
      }
      waited += 30;
      setTimeout(tryJump, 30);
    })();
  }

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
      '<div class="sub">「探偵少女はダウトで勝ちの目を見るか」</div>'));
    if (demo) root.appendChild(h("div", "demo-ribbon", "体験版"));
    // D案：四隅の扇・二重の額縁・館の銘・入館証
    root.insertBefore(h("div", "t-fan l"), root.querySelector(".head"));
    root.insertBefore(h("div", "t-fan r"), root.querySelector(".head"));
    root.insertBefore(h("div", "t-frame"), root.querySelector(".head"));
    (function () {
      var kick = root.querySelector(".head .kicker");
      if (kick) kick.textContent = kick.textContent.replace(/^[\s―—\-]+|[\s―—\-]+$/g, "");
      var est = h("div", "estline", "<i></i><em></em><span>MAICRO HOUSE · EST. 1930</span><em></em><i></i>");
      var h1 = root.querySelector(".head h1");
      if (h1) h1.parentNode.insertBefore(est, h1.nextSibling);
      root.appendChild(h("div", "admit", "<b>ADMIT ONE</b><span>" + tr("今宵かぎりの入館証", "Tonight Only") + "</span>"));
    })();
    var modes = h("div", "modes");
    function go(mode, target) {
      f().doubt_mode = mode;
      f().doubt_demo = demo;
      f().doubt_demo_last = D.rules.demoLastStage || 0;
      closeRoot(root);
      jumpFromTitle(target);
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
        jumpFromTitle("*arcade_resume");
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
      modes.appendChild(btn("シンプルプレイ<small>フリー対戦</small>", "teal", function () { go("simple", "*simple_start"); }));
    }
    modes.querySelectorAll(".dbt-btn").forEach(function (b, i) { asTicket(b, i === 0 ? "♥" : "♣"); });
    root.appendChild(modes);
    var extra = h("div", "extra");
    if (!demo) {
      extra.appendChild(btn("ランキング", "navy", function () {
        handoffRoot(root);
        jumpFromTitle("*ranking");
      }));
    }
    extra.appendChild(btn("設定", "navy", function () {
      handoffRoot(root);
      jumpFromTitle("*settings");
    }));
    extra.appendChild(btn("遊び方", "navy", function () {
      handoffRoot(root);
      jumpFromTitle("*help");
    }));
    extra.appendChild(btn("LANGUAGE<small>日本語 / English</small>", "navy", function () {
      var next = (window.I18N && window.I18N.isEN && window.I18N.isEN()) ? "ja" : "en";
      if (window.I18N && window.I18N.setLang) {
        window.I18N.setLang(next, function () { window.location.reload(); });
      } else {
        try { window.localStorage.setItem("maiguro_lang", next); } catch (e) {}
        window.location.reload();
      }
    }));
    var langBtn = extra.lastChild;
    if (langBtn) langBtn.classList.add("lang");
    root.appendChild(extra);

    // 開発用デバッグは、通常メニューと分けて画面最下部に小さく置く
    if (D.rules.debugMenu) {
      root.appendChild(btn("デバッグ", "navy debugbtn", function () {
        closeRoot(root);
        jumpFromTitle("*debug");
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
        handoffRoot(root);
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
          html += '<div class="abilsub"><b>' + abilName(ch.sub) + '</b> <span class="uses">1ゲーム' +
            ch.subUses + "回</span>" + sub.ability + "</div>";
        }
        return html;
      }

      // D案：見出しの飾りと、左下の共通「もどる」
      function dressHelp(page) {
        var hd = body.querySelector(".hd");
        if (hd) {
          var bar = h("div", "hd-wrap");
          hd.parentNode.insertBefore(bar, hd);
          bar.appendChild(decoWrap(hd));
        }
        var back = body.querySelector(".dbt-btn.back");
        if (back) asBack(back);
        if (page === "rules") dressRules();
      }

      // ルールの各手順に、カードの図解を添える。本文は文ごとに段落へ分けて読みやすく
      function miniCard(r, s, cls) {
        var red = s === 1 || s === 2;
        return '<span class="mc' + (red ? " red" : "") + (cls ? " " + cls : "") + '"><i style="background-image:url(\'' + D.img.cardFace(r) + '\')"></i><b>' + RANK[r] + "<em>" + SUIT[s] + "</em></b></span>";
      }
      function backCard(cls) {
        return '<span class="mb' + (cls ? " " + cls : "") + '" style="background-image:url(\'' + D.img.cardBack + '\')"></span>';
      }
      function dressRules() {
        var arts = [
          '<div class="il il1">' + miniCard(7, 2, "a") + miniCard(2, 0, "b") + '<span class="arrow"></span>' + backCard("c") + backCard("d") + '<span class="tg">〈7〉×2</span></div>',
          '<div class="il il2">' + backCard("a") + backCard("b") + backCard("c") + '<span class="say">' + tr("ダウト！", "DOUBT!") + "</span></div>",
          '<div class="il il3"><div class="half lie"><span class="tg">' + tr("嘘だった", "A lie") + "</span>" + miniCard(7, 2) + miniCard(2, 0, "ng") +
            "<p>" + tr("伏せた側が<br>引き取る", "The player who<br>played takes") + '</p></div><div class="half true"><span class="tg">' + tr("本当だった", "The truth") + "</span>" +
            miniCard(7, 0) + miniCard(7, 2) + "<p>" + tr("ダウトした側が<br>引き取る", "The doubter<br>takes") + "</p></div></div>",
          '<div class="il il4"><span class="slot"></span><span class="slot"></span><span class="slot"></span><span class="slot"></span><span class="zero">0<small>' + tr("枚", "") + '</small></span><span class="win">WIN</span></div>'
        ];
        body.querySelectorAll(".rule").forEach(function (box, i) {
          var no = box.querySelector(".no"), rt = box.querySelector(".rt"), rd = box.querySelector(".rd");
          var head = h("div", "rhead");
          box.insertBefore(head, no);
          head.appendChild(no);
          head.appendChild(rt);
          if (arts[i]) box.insertBefore(h("div", "rart", arts[i]), rd);
          // 「。<br>」の切れ目を段落にする
          rd.innerHTML = rd.innerHTML.split(/<br\s*\/?>/i).map(function (t) { return "<p>" + t + "</p>"; }).join("");
        });
        var td = body.querySelector(".tip .td");
        if (td) {
          var sm = td.querySelector("small");
          var html = td.innerHTML.replace(/<small>[\s\S]*<\/small>/i, "");
          var parts = html.split(/(?<=[。.])\s*/).filter(function (t) { return t.trim(); });
          td.innerHTML = parts.map(function (t) { return "<p>" + t + "</p>"; }).join("") + (sm ? '<p class="note">' + sm.innerHTML + "</p>" : "");
        }
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
        dressHelp("menu");
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
          "同じ数字の札は通常52枚モードでは4枚、26枚モードでは2枚です。自分が持っている枚数や、ダウトで公開された札を手掛かりにすると、" +
          "相手の宣言が成立するかを推理できます。<small>※特殊能力によって札の枚数や情報が変化することがあります。</small>"));
        body.appendChild(tip);

        var skill = h("div", "skillnote");
        skill.appendChild(h("div", "sk", "特殊能力"));
        skill.appendChild(h("div", "sd",
          "登場人物はそれぞれ固有の能力を持っています。<b>キャラクター紹介</b>や、対戦中の<b>「スキル」</b>から確認できます。"));
        body.appendChild(skill);

        body.appendChild(btn("もどる", "navy back", renderMenu));
        dressHelp("rules");
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

      /*
       * キャラクター紹介（D案）：上に顔の一覧、左に大きな立ち絵、右に名前と能力。
       * ← → でも切り替えられる。一覧の順番は charIds のまま。
       */
      var charKey = null;
      renderCharacters = function () {
        clearBody();
        body.className = "helpbody charpage2";
        if (charPage < 0 || charPage >= charIds.length) charPage = 0;
        var id = charIds[charPage];
        var ch = D.chara[id];

        var stage = h("div", "cstage");
        stage.appendChild(h("div", "rays"));
        var big = portrait(id, "cbig");
        stage.appendChild(big);
        body.appendChild(stage);
        body.appendChild(h("div", "cfade"));

        var title = h("div", "ctitle");
        title.appendChild(h("em", ""));
        title.appendChild(h("h1", "", tr("キャラクター紹介", "Characters")));
        body.appendChild(title);

        var strip = h("div", "cstrip");
        charIds.forEach(function (cid, i) {
          var t = h("div", "cthumb" + (i === charPage ? " on" : ""));
          var face = portrait(cid, "cface");
          t.appendChild(face);
          if (i === charPage) t.appendChild(h("span", "cnm", D.chara[cid].name));
          t.addEventListener("click", function () { if (i !== charPage) { charPage = i; renderCharacters(); } });
          strip.appendChild(t);
        });
        body.appendChild(strip);

        var panel = h("div", "cpanel");
        panel.appendChild(h("div", "cname",
          '<span class="name">' + ch.name + "</span>" + (ch.reading ? '<span class="reading">' + ch.reading + "</span>" : "")));
        var line = h("div", "cline");
        line.style.background = "linear-gradient(90deg, " + ch.color + ", rgba(0,0,0,0))";
        panel.appendChild(line);
        panel.appendChild(h("div", "csec", "<em></em>" + tr("特殊能力", "Abilities") + "<i></i>"));
        function abil(kind, chip, name, text) {
          return '<div class="cab"><div class="cabh"><span class="chip ' + kind + '">' + chip + "</span>" +
            (name ? '<span class="cabn">' + name + "</span>" : "") + '</div><div class="cabt">' + text + "</div></div>";
        }
        var html = abil(ch.uses > 0 ? "limit" : "always", useText(ch), abilName(id), ch.ability);
        if (ch.sub && D.chara[ch.sub]) {
          var sub = D.chara[ch.sub];
          html += abil("limit", tr("1ゲーム", "Up to ") + ch.subUses + tr("回", " per game"), abilName(ch.sub), sub.ability);
        }
        panel.appendChild(h("div", "cabs", html));
        body.appendChild(panel);

        function go(d) { charPage = (charPage + d + charIds.length) % charIds.length; renderCharacters(); }
        var prev = btn("‹", "navy carrow l", function () { go(-1); });
        var next = btn("›", "navy carrow r", function () { go(1); });
        body.appendChild(prev);
        body.appendChild(next);
        body.appendChild(h("div", "chint", tr("← → で人物を切り替え", "← → to switch") + "　" + (charPage + 1) + " / " + charIds.length));
        body.appendChild(asBack(btn(tr("もどる", "Back"), "navy back", function () {
          document.removeEventListener("keydown", charKey);
          charKey = null;
          renderMenu();
        })));
        if (!charKey) {
          charKey = function (ev) {
            if (!root.parentNode || body.className.indexOf("charpage2") < 0) return;
            if (ev.key === "ArrowLeft") go(-1);
            else if (ev.key === "ArrowRight") go(1);
          };
          document.addEventListener("keydown", charKey);
        }
      };

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

      // ---- D案：見出し・三つの区画・まだ解放されていない卓 ----
      (function () {
        var head = h("div", "sel-head");
        head.appendChild(decoWrap(h("h1", "", tr("対戦相手を選ぶ", "Choose Your Opponents"))));
        head.appendChild(h("div", "sub", tr("シンプルプレイ　―　フリー対戦", "Free Play")));
        root.appendChild(head);
        var meName = root.querySelector(".me .plate b");
        if (meName && D.chara.mahoru.reading) meName.insertAdjacentHTML("afterend", '<i class="rd">' + D.chara.mahoru.reading + "</i>");
        var cap = h("div", "grid-cap", "<em></em>" + tr("相手の組み合わせ", "Opponent Pairs") + "<i></i>");
        grid.parentNode.insertBefore(cap, grid);
        cols.forEach(function (c, i) {
          var pr = D.pairs[i];
          if (pr.tagline) c.querySelector(".lb").insertAdjacentHTML("beforeend", '<i class="tl">' + pr.tagline + "</i>");
          c.appendChild(h("span", "ribbon", tr("選択中", "Selected")));
        });
        for (var k = pairCount; k < D.pairs.length; k++) {
          var lock = h("div", "col locked",
            '<div class="lockface"><svg viewBox="0 0 24 24" width="34" height="34" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="5" y="11" width="14" height="10" rx="1.5"></rect><path d="M8 11V8a4 4 0 0 1 8 0v3"></path></svg>' +
            tr("未解放", "Locked") + '</div><div class="lb">' + D.pairs[k].label + '<i class="tl">？？？</i></div>');
          grid.appendChild(lock);
        }
        var detail = h("div", "detail");
        detail.appendChild(h("div", "dhead"));
        root.appendChild(detail);
        detail.appendChild(preview);
        detail.appendChild(h("div", "vsline"));
        detail.appendChild(plate);
        var go = cmds.querySelector(".red");
        if (go) { go.innerHTML = tr("この相手と対戦", "Battle These Two"); go.classList.add("go"); root.appendChild(go); }
        var bk = cmds.querySelector(".navy");
        if (bk) root.appendChild(asBack(bk));
        var hint = root.querySelector(".hint");
        if (hint) hint.textContent = tr("← → で選ぶ　Enter で決定", "← → to choose　Enter to start");
        var baseShow = show;
        show = function (i) {
          baseShow(i);
          var pr = D.pairs[i];
          detail.querySelector(".dhead").innerHTML = '<b>' + pr.label + "</b>" + (pr.tagline ? "<span>" + pr.tagline + "</span>" : "");
          detail.querySelector(".vsline").innerHTML = "<span>" + D.chara.mahoru.name + '</span><em>VS</em><span>' + D.chara[pr.a].name + " × " + D.chara[pr.b].name + "</span>";
          [[".p1", pr.a], [".p2", pr.b]].forEach(function (q) {
            var p = preview.querySelector(q[0]);
            var c = D.chara[q[1]];
            if (p) p.insertAdjacentHTML("beforeend", '<div class="pn"><b>' + c.name + "</b>" + (c.reading ? "<i>" + c.reading + "</i>" : "") + "</div>");
          });
        };
      })();

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

  // ---------------------------------------------------------------- 能力を借りる（フリー対戦）
  //   アーケードプレイを一度突破すると、フリー対戦で相手を選んだ後に、
  //   各キャラクターの能力を一つだけ借りて戦える（その対戦の間だけ）。
  //   能力を札のように並べ、← → でページをめくって選ぶ。
  //   → f.doubt_borrow = 能力のid（借りない時は ""）／ f.doubt_borrow_back = 相手選びに戻る

  // 借りられる能力。ストックと同じ仕組みで使えるもの（アーケードの第一戦〜第四戦の相手の力）
  function borrowList() {
    var out = [];
    D.pairs.forEach(function (pr) {
      [pr.a, pr.b].forEach(function (cid) {
        (D.stock && D.stock[cid] || []).forEach(function (sid) {
          if (D.chara[sid] && out.every(function (o) { return o.id !== sid; })) out.push({ id: sid, owner: cid });
        });
      });
    });
    return out;
  }
  // 使い方の目安（スキル発動から使う／条件がそろうと聞かれる／いつも効いている）
  var BORROW_HOW = {
    reido: "act", eruku: "act", eruku_deal: "act",
    koderia: "ask", mary_deal: "ask", jushika_sight: "ask"
  };

  defineTag("doubt_borrow", {}, function () {
    var fv = f();
    fv.doubt_borrow = "";
    fv.doubt_borrow_back = false;
    if (fv.doubt_mode !== "simple" || fv.doubt_demo || !isCleared()) return;
    var list = borrowList();
    if (!list.length) return;
    return new Promise(function (resolve) {
      var root = openRoot("dbt-borrow");
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "use-kicker", "BORROW"));
      root.appendChild(decoWrap(h("div", "use-hd", tr("能力を借りる", "Borrow an Ability"))));
      root.appendChild(h("div", "bsub", tr("この対戦の間だけ、選んだ能力を一つ真歩流が使えます", "Mahoru can use one chosen ability for this match only")));
      var stage = h("div", "bstage");
      root.appendChild(stage);
      var dots = h("div", "bdots");
      root.appendChild(dots);

      var last = "";
      try { last = TYRANO.kag.variable.sf.doubt_borrow_last || ""; } catch (e) {}
      var page = 0;
      list.forEach(function (o, i) { if (o.id === last) page = i; });

      function useLabel(id) {
        var u = stockUses(id);
        return u < 0 ? tr("常時", "Always") : tr("1ゲーム", "Up to ") + u + tr("回", " per game");
      }
      function howLabel(id) {
        var k = BORROW_HOW[id];
        if (k === "act") return tr("「スキル発動」から使う", "Use from \"Use Skill\"");
        if (k === "ask") return tr("条件がそろうと、使うか聞かれる", "You are asked when it can be used");
        return tr("自動で効く", "Works automatically");
      }
      function card(o, cls) {
        var ch = D.chara[o.owner];
        var c = h("div", "use-card bcard " + cls);
        var art = h("div", "art");
        art.appendChild(h("div", "rays"));
        art.appendChild(portrait(o.owner));
        art.appendChild(h("span", "tag", ch.name));
        c.appendChild(art);
        var note = D.stockNote && D.stockNote[o.id];
        c.appendChild(h("div", "txt",
          '<div class="sep"><i></i><em></em><i></i></div>' +
          '<div class="nm">' + (abilName(o.id) || D.chara[o.id].name) + "</div>" +
          '<div class="chips"><span class="chip ' + (stockUses(o.id) < 0 ? "always" : "limit") + '">' + useLabel(o.id) + "</span>" +
          '<span class="how">' + howLabel(o.id) + "</span></div>" +
          '<div class="ab">' + D.chara[o.id].ability + (note ? '<span class="note">＋' + note + "</span>" : "") + "</div>"));
        return c;
      }
      function render() {
        stage.innerHTML = "";
        var n = list.length;
        var prev = list[(page + n - 1) % n], next = list[(page + 1) % n];
        var pc = card(prev, "side l"), nc = card(next, "side r");
        pc.addEventListener("click", function () { go(-1); });
        nc.addEventListener("click", function () { go(1); });
        stage.appendChild(pc);
        stage.appendChild(nc);
        stage.appendChild(card(list[page], "main on"));
        stage.appendChild(btn("‹", "navy barrow l", function () { go(-1); }));
        stage.appendChild(btn("›", "navy barrow r", function () { go(1); }));
        dots.innerHTML = list.map(function (o, i) { return "<i" + (i === page ? ' class="on"' : "") + "></i>"; }).join("") +
          "<b>" + (page + 1) + " / " + n + "</b>";
      }
      function go(d) { page = (page + d + list.length) % list.length; render(); }
      function finish(id, back) {
        document.removeEventListener("keydown", onKey);
        fv.doubt_borrow = id || "";
        fv.doubt_borrow_back = !!back;
        if (id) { try { TYRANO.kag.variable.sf.doubt_borrow_last = id; TYRANO.kag.saveSystemVariable(); } catch (e) {} }
        closeRoot(root);
        resolve();
      }
      var cmds = h("div", "use-cmds");
      cmds.appendChild(btn(tr("この能力を借りる", "Borrow This"), "gold go", function () { finish(list[page].id); }));
      cmds.appendChild(btn(tr("借りずに戦う", "Play Without"), "navy", function () { finish(""); }));
      root.appendChild(cmds);
      root.appendChild(asBack(btn(tr("相手選びへ", "Opponents"), "navy back", function () { finish("", true); })));
      root.appendChild(h("div", "bhint", tr("← → でめくる　Enter で借りる", "← → to browse　Enter to borrow")));
      function onKey(ev) {
        if (ev.key === "ArrowLeft") go(-1);
        else if (ev.key === "ArrowRight") go(1);
        else if (ev.key === "Enter") finish(list[page].id);
        else if (ev.key === "Escape") finish("", true);
      }
      document.addEventListener("keydown", onKey);
      render();
    });
  });

  // ---------------------------------------------------------------- 相手表示

  defineTag("doubt_vs", { pair: "0" }, function (pm) {
    var pr = D.pairs[pairIndexOf(pm)];
    return new Promise(function (resolve) {
      // 中断→再開などで古いVS画面が残っていても、必ず1枚だけにする。
      document.querySelectorAll(".dbt-root.dbt-vs").forEach(closeRoot);
      var root = openRoot("dbt-vs");
      // 立ち絵をクリックすると、そのキャラのスキルが出る（真歩流も見られる）
      var ids = ["mahoru", pr.a, pr.b];
      var ports = [];
      var panel = h("div", "skillpanel show");
      function showSkill(k) {
        ports.forEach(function (p, j) { p.classList.toggle("on", j === k); });
        panel.className = "skillpanel show" + (k === 0 ? " l" : "");
        panel.innerHTML = skillWithSub(ids[k], k === 0 ? "（あなた）" : "") + (k === 0 ? stockHTML() : "");
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
        document.querySelectorAll(".dbt-root.dbt-vs").forEach(closeRoot);
        resolve();
      }));
      // ---- D案：斜めの金線で三つに割った立ち絵、控えめなコピー、意味の分かるボタン ----
      root.querySelector(".go").innerHTML = tr("対戦開始", "Start Match");
      root.appendChild(h("div", "slash",
        '<svg viewBox="0 0 1920 1080" width="1920" height="1080"><line x1="980" y1="0" x2="820" y2="1080" stroke="#C7A260" stroke-width="3"></line>' +
        '<line x1="988" y1="0" x2="828" y2="1080" stroke="rgba(227,200,135,.45)" stroke-width="1"></line>' +
        '<line x1="1460" y1="0" x2="1300" y2="1080" stroke="rgba(199,162,96,.7)" stroke-width="1.5"></line></svg>'));
      root.insertBefore(h("div", "vshade"), root.querySelector(".skillpanel"));
      var tb = root.querySelector(".tagbox.r");
      if (tb) tb.insertAdjacentHTML("beforeend", "　" + tr("対戦相手", "Opponents"));
      var nr = root.querySelector(".band .n.r");
      if (nr) nr.innerHTML = D.chara[pr.a].name + '<em>×</em>' + D.chara[pr.b].name;
      // コピーは絵の切り抜きの外に出して、暗幕より手前に置く
      root.querySelectorAll(".copy").forEach(function (c) { root.appendChild(c); });
      var nl = root.querySelector(".band .n.l");
      if (nl && D.chara.mahoru.reading) nl.insertAdjacentHTML("beforeend", "<i>" + D.chara.mahoru.reading + "</i>");
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
    // 白い札の面に数字ごとの絵柄を額に入れて置き、左上と右下に数字と柄を重ねる
    var e = h("div", "dbt-card" + (red ? " red" : ""));
    var idx = RANK[c.r] + "<i>" + SUIT[c.s] + "</i>";
    e.innerHTML =
      '<span class="art" style="background-image:url(\'' + D.img.cardFace(c.r) + '\')"></span>' +
      '<span class="ix tl">' + idx + "</span>" +
      '<span class="ix br">' + idx + "</span>";
    e.dataset.id = c.id;
    return e;
  }

  // 札の絵柄は最初の対戦で先読みしておき、配った瞬間に白いまま出ないようにする
  var facesLoaded = false;
  function preloadFaces() {
    if (facesLoaded) return;
    facesLoaded = true;
    for (var r = 1; r <= 13; r++) new Image().src = D.img.cardFace(r);
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
  // 相手の手札をのぞく時の小さな札（数字と絵柄だけ）
  function chipEl(c) {
    var red = c.s === 1 || c.s === 2;
    return h("span", "chip" + (red ? " red" : ""), c.r === 0 ? "JK" : RANK[c.r] + SUIT[c.s]);
  }

  // 卓にかかっている決まりの説明。残りは「あと何手」で出す
  function ruleTexts(g) {
    var out = [];
    if (!g) return out;
    if (g.sealed > 0) out.push("能力封印：誰も特殊能力を使えない（あと" + g.sealed + "手）");
    if (g.suitRule) {
      var su = g.suitRule.suits.map(function (x) { return '<span class="s' + x + '">' + SUIT[x] + "</span>"; }).join("");
      out.push("柄の縛り：" + su + "以外の柄は嘘になる（あと" + g.suitRule.left + "手）");
    }
    return out;
  }

  function sortedCardsForDisplay(cards) {
    return cards.slice().sort(function (a, b) {
      var ar = a.r === 0 ? 14 : a.r;
      var br = b.r === 0 ? 14 : b.r;
      return ar - br || a.s - b.s;
    });
  }

  function BattleUI(pairIndex) {
    var self = this;
    preloadFaces();
    this.pair = D.pairs[pairIndex];
    this.root = openRoot("dbt-battle");
    bg(this.root, D.img.bgTable);
    this.root.appendChild(h("div", "dbt-shade shade"));

    this.history = [];
    this.historyPlayCount = 0;
    this.historyButton = btn(battleText("対戦履歴", "Battle History"), "navy dbt-history-button", function () { self.openHistory(); });
    this.root.appendChild(this.historyButton);
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
        '<div class="use"></div>' +
        '<div class="peek"></div>');
      box.appendChild(p);
      box.appendChild(info);
      self.root.appendChild(box);
      self.opp[seat] = { box: box, count: info.querySelector(".v"), use: info.querySelector(".use"), peek: info.querySelector(".peek") };
      info.querySelector(".cnt").appendChild(h("span", "unit", tr("枚", "")));
      var bub = h("div", "dbt-bubble s" + seat);
      self.root.appendChild(bub);
      self.bubble[seat] = bub;
      // 名前や立ち絵を押すと、この対戦のスキル一覧が出る
      box.addEventListener("click", function () { self.openInfo("skills"); });
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
    // D案：宣言する数字の札。上に見出し、下に「場札／除外」の枚数を入れる
    this.rankCard = h("div", "dbt-rankcard");
    this.rankCard.appendChild(this.rankLbl);
    this.rankCard.appendChild(this.rankBox);
    this.rankFoot = h("div", "rk-foot",
      '<div class="c"><span class="k">' + tr("場札", "Pile") + '</span><b class="pile">0</b><i>' + tr("枚", "") + "</i></div>" +
      '<div class="c"><span class="k">' + tr("除外", "Out") + '</span><b class="gone">0</b><i>' + tr("枚", "") + "</i></div>");
    this.rankCard.appendChild(this.rankFoot);
    this.rankCard.insertBefore(h("div", "rays"), this.rankCard.firstChild);
    row.appendChild(this.rankCard);
    this.pileEl = h("div", "dbt-pile");
    row.appendChild(this.pileEl);
    this.pileInfo = h("div", "dbt-pileinfo", '<span class="k">場の伏せ札</span><span class="v">0</span><span class="d"></span>');
    row.appendChild(this.pileInfo);
    field.appendChild(row);
    // 和人の力（ストック）で把握している、場から除外された札
    // 舞黒邦夢のもてなしで、いま卓にかかっている決まり（能力封印・柄の縛り）
    this.ruleEl = h("div", "dbt-rule");
    this.ruleEl.style.display = "none";
    field.appendChild(this.ruleEl);
    this.goneEl = h("div", "dbt-gone");
    this.goneEl.style.display = "none";
    field.appendChild(this.goneEl);
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
    // 挑発。押すと次に伏せる札で相手を煽る（もう一度押すと取りやめ）
    this.bTaunt = btn("挑発する", "navy dbt-taunt", function () { self.onTaunt(); });
    this.root.appendChild(this.bTaunt);
    // ストックした能力。持っている時だけ並べる（自分で使う能力だけ押せる）
    var sid = stockId();
    if (sid) this.bStock = btn(D.chara[sid].name, "teal stock", function () { self.onStock(); });
    // 降参はフリー対戦だけ。アーケードは残機とコンティニューで区切りがつく
    this.canResign = f().doubt_mode === "simple";
    cmd.appendChild(this.bMain);
    cmd.appendChild(this.bDoubt);
    cmd.appendChild(this.bAbility);
    if (this.bStock) {
      cmd.appendChild(this.bStock);
      cmd.classList.add("with-stock");
    }
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

    // ---- D案のボタン帯 ----
    //   中央：カードを出す ／ 挑発する（ダウトの場面では ダウト！）／ スキル発動
    //   右端：情報（カードのプレイ履歴・スキル確認）と 中断（降参）のアイコン
    //   能力のボタン（手札の交換・名指し・ストック）は「スキル発動」の中から選ぶ
    cmd.innerHTML = "";
    cmd.classList.remove("with-stock");
    var center = h("div", "cmd-center");
    this.bTaunt.classList.remove("dbt-taunt");
    this.bTaunt.classList.add("taunt");
    this.bDoubt.classList.remove("navy");
    this.bDoubt.classList.add("wine", "doubt");
    this.bDoubt.innerHTML = tr("ダウト！", "DOUBT!");
    this.bUse = btn(tr("スキル発動", "Use Skill"), "gold use", function () { self.openUse(); });
    center.appendChild(this.bMain);
    center.appendChild(this.bTaunt);
    center.appendChild(this.bDoubt);
    center.appendChild(this.bUse);
    cmd.appendChild(center);
    var icons = h("div", "cmd-icons");
    this.bInfo = btn(ICON_INFO + "<small>" + tr("情報", "Info") + "</small>", "navy icon", function () { self.openInfo("history"); });
    icons.appendChild(this.bInfo);
    if (this.bResign) {
      this.bResign.innerHTML = ICON_PAUSE + "<small>" + this.bResign.textContent + "</small>";
      this.bResign.classList.add("icon");
      icons.appendChild(this.bResign);
    }
    cmd.appendChild(icons);
    cmd.appendChild(h("div", "cmd-gem"));
    this.root.appendChild(cmd);

    // スペースキーで「カードを出す」（押せる時だけ）
    this.onKeyDown = function (ev) {
      if (ev.code !== "Space" && ev.key !== " ") return;
      if (!self.root.parentNode || self.root.querySelector(".dbt-overlay")) return;
      if (self.mode === "place" && !self.bMain.classList.contains("off")) {
        ev.preventDefault();
        self.onMain();
      }
    };
    document.addEventListener("keydown", this.onKeyDown);

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
    if (this.onKeyDown) document.removeEventListener("keydown", this.onKeyDown);
    if (lifecycle.battle === this) lifecycle.battle = null;
    stopAllVoice();
    closeRoot(this.root);
  };

  // この対戦に出ている3人のスキルを並べて見せる
  B.openSkills = function (into) {
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
      // 誰でも使える挑発
      if (seat === 0) {
        box.appendChild(h("div", "sk borrow",
          skillHTML("taunt", g.canTaunt() ? "使える" : "あと" + g.tauntWait() + "巡", "（コマンド）")));
      }
      // プレイヤーのストック
      if (seat === 0 && g.stockId) {
        box.appendChild(h("div", "sk borrow",
          skillHTML(g.stockId, stockUseText(g.abilLeft(0, g.stockId)), "（ストック）") + stockNoteHTML(g.stockId)));
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
    // 情報画面の「スキル確認」の中に並べる時は、行だけを移す
    if (into) {
      into.classList.add("dbt-skills");
      Array.prototype.slice.call(box.querySelectorAll(".sk")).forEach(function (el) {
        el.innerHTML = relabelStock(el.innerHTML);
        into.appendChild(el);
      });
      return;
    }
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
    var swaps = g ? g.subUses[0] : 0;
    // 能力封印の間は、名指しも手札の交換も押せない（残り回数はそのまま見せる）
    var abSealed = !!(g && g.sealed > 0);
    this.bMain.innerHTML = m === "window" ? "見送る" : (m === "give" ? "渡す" : "伏せる");
    // D案：自分の番は「カードを出す」（スペースキーでも出せる）。見送る時は控えめな紺に
    if (m !== "window" && m !== "give") this.bMain.innerHTML = tr("カードを出す", "Play Cards") + '<small class="key">SPACE</small>';
    this.bMain.classList.toggle("pass", m === "window");
    this.bMain.classList.toggle("off",
      !((m === "place" && nSel >= 1 && nSel <= g.maxPlay) || m === "window" ||
        (m === "give" && nSel === this.need)));
    var sealedDoubt = !!(g && g.doubtBlocked());
    this.bDoubt.classList.toggle("off", m !== "window" || sealedDoubt);

    // 自分の手番は「手札の交換」、ダウトの場面は「名指し推理」
    if (m === "place") {
      this.bAbility.innerHTML = "手札を交換する<small>残り" + Math.max(0, swaps) + "</small>";
      this.bAbility.classList.toggle("off", !(swaps > 0) || abSealed);
    } else {
      this.bAbility.innerHTML = "数字を名指しする<small>残り" + Math.max(0, uses) + "</small>";
      this.bAbility.classList.toggle("off", !(m === "window" && uses > 0) || sealedDoubt || abSealed);
    }
    this.handEl.classList.toggle("turn", m === "place" || m === "give");
    if (this.bResign) this.bResign.classList.toggle("off", m === "idle");
    // 挑発の構えは、伏せた後にエンジン側で解く（ここで解くと伏せる前に消えてしまう）
    var tauntOk = !!(g && m === "place" && g.canTaunt());
    this.bTaunt.innerHTML = g && g.tauntArmed ? "挑発して伏せる<small>取りやめる</small>"
      : (g && !g.canTaunt() ? "挑発<small>あと" + g.tauntWait() + "巡</small>" : "挑発する<small>三巡に一度</small>");
    this.bTaunt.classList.toggle("armed", !!(g && g.tauntArmed));
    this.bTaunt.classList.toggle("off", !tauntOk);
    if (this.bStock && g && g.stockId) {
      this.bStock.innerHTML = D.chara[g.stockId].name + "<small>" + stockUseText(g.abilLeft(0, g.stockId)) + "</small>";
      this.bStock.classList.toggle("off", !this.stockReady(m) || !!this.stockBusy);
    }
    // 中央の二つ目：自分の番は挑発、ダウトの場面ではダウト！
    if (this.bUse) {
      this.bTaunt.style.display = m === "window" ? "none" : "";
      this.bDoubt.style.display = m === "window" ? "" : "none";
      var ready = this.useOptions().some(function (o) { return o.ok; });
      this.bUse.classList.toggle("off", !ready);
      this.bTaunt.innerHTML = g && g.tauntArmed ? tr("挑発して出す", "Taunt: ON") + "<small>" + tr("取りやめる", "cancel") + "</small>"
        : (g && !g.canTaunt() ? tr("挑発", "Taunt") + "<small>" + tr("あと", "in ") + g.tauntWait() + tr("巡", " turns") + "</small>" : tr("挑発する", "Taunt"));
    }
  };

  B.onTaunt = function () {
    var g = this.game;
    if (!g || this.mode !== "place" || !g.canTaunt()) return;
    g.tauntArmed = !g.tauntArmed;
    this.setButtons();
  };

  // ストックした能力を、今この場面で自分から使えるか
  B.stockReady = function (m) {
    var g = this.game;
    if (!g || !g.stockId || g.abilLeft(0, g.stockId) <= 0) return false;
    switch (g.stockId) {
      case "reido": return m === "window" && g.hands[0].length >= 4 && !g.doubtBlocked();
      case "eruku": return m === "place";
      case "eruku_deal": return m === "place" && g.pile.length >= 2 && g.immune[0] === 0;
      default: return false;   // 常時の力や、条件がそろうと確認が出る力
    }
  };

  B.onStock = async function () {
    var g = this.game;
    var self = this;
    if (!g || this.stockBusy || !this.stockReady(this.mode)) return;
    if (g.stockId === "reido") {
      this.finishInput({ type: "ability" });
      return;
    }
    if (g.stockId === "eruku") {
      var ov = h("div", "dbt-overlay dbt-pad dbt-swap");
      var box = h("div", "box");
      box.appendChild(h("div", "q", "誰と手札を丸ごと入れ替える？"));
      var row = h("div", "targets");
      [1, 2].forEach(function (seat) {
        row.appendChild(btn(g.name(seat) + "<small>手札" + g.shownHand(seat) + "枚</small>", "navy", function () {
          closeRoot(ov);
          self.runStock(function () { return g.playerSwapAll(seat); });
        }));
      });
      box.appendChild(row);
      box.appendChild(btn("やめる", "navy cancel", function () { closeRoot(ov); }));
      ov.appendChild(box);
      this.root.appendChild(ov);
      return;
    }
    if (g.stockId === "eruku_deal") this.runStock(function () { return g.playerRiskyDeal(); });
  };

  // 手番の途中で使う能力。伏せるために選んでいた札はいったん解除してから使う
  B.runStock = async function (fn) {
    this.stockBusy = true;
    this.selected = {};
    this.setButtons();
    try { await fn(); } finally { this.stockBusy = false; }
    if (this.game) {
      if (this.mode === "place") this.guide.textContent = this.placeText(this.game);
      this.render(this.game);
    }
  };

  B.placeText = function (g) {
    var t = "〈" + RANK[g.rank] + "〉として伏せる札を選ぶ（1〜" + g.maxPlay + "枚・嘘でもよい）";
    if (g.immune[0] > 0) t += "　いまはダウトされない（あと" + g.immune[0] + "回）";
    if (g.suitRule) t += "　" + g.suitRule.suits.map(function (x) { return SUIT[x]; }).join("") + "以外の柄は嘘になる";
    return t;
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
      if (sub && sub.uses > 0) parts.push(abilName(g.subId[seat]) + " 残り" + Math.max(0, g.subUses[seat]));
      var useText = parts.join("／");
      if (id === "mahoru_awake") {
        useText = "名指し 残り" + Math.max(0, g.uses[seat]);
        if (g.borrowId) {
          var bc = D.chara[g.borrowId];
          useText += "／" + bc.name + "の力" + (bc.uses > 0 ? " 残り" + Math.max(0, g.borrowUses) : "");
        }
      }
      if (g.sealed > 0) useText = "力を封じられている";
      if (g.immune[seat] > 0) useText = "ダウトされない（あと" + g.immune[seat] + "回）";
      if (g.sight[seat] > 0) useText = "見透かし中：あなたの手札が見えている";
      if (hidden) useText = "枚数が読めない";
      o.use.textContent = useText;

      // メアリーの力（ストック）や見透かしで、相手の手札が見えている時
      var vis = g.visibleOppCards(seat);
      var peekOn = g.sight[0] > 0 || vis.length > 0;
      o.peek.innerHTML = "";
      o.peek.style.display = peekOn ? "" : "none";
      if (peekOn) {
        o.peek.appendChild(h("div", "pk", g.sight[0] > 0 ? "見透かし中" : "見えている札"));
        var chips = h("div", "chips");
        sortedCardsForDisplay(vis).forEach(function (c) { chips.appendChild(chipEl(c)); });
        o.peek.appendChild(chips);
      }
    });

    this.rankBox.innerHTML = "<span>" + RANK[g.rank] + "</span>";
    this.rankLbl.textContent = g.turn === 0 ? "あなたが出す数字" : g.name(g.turn) + "の宣言";

    var n = g.pile.length;
    this.pileInfo.querySelector(".v").textContent = hidden ? "？" : n;
    this.pileInfo.querySelector(".d").textContent = g.discard.length ? "捨て札 " + g.discard.length : "";
    this.rankFoot.querySelector(".pile").textContent = hidden ? "？" : n;
    this.rankFoot.querySelector(".gone").textContent = g.discard.length;
    this.rankCard.classList.toggle("mine", g.turn === 0);
    if (g.turn === 0) this.rankLbl.textContent = tr("宣言する数字", "Your Rank");
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

    var gone = g.goneKnown0 || [];
    var rules = ruleTexts(g);
    this.ruleEl.style.display = rules.length ? "" : "none";
    this.ruleEl.innerHTML = rules.join("<br>");
    this.goneEl.style.display = gone.length ? "" : "none";
    if (gone.length && this.goneEl._n !== gone.length) {
      this.goneEl._n = gone.length;
      this.goneEl.innerHTML = "";
      this.goneEl.appendChild(h("div", "pk", "除外した札"));
      var chips = h("div", "chips");
      sortedCardsForDisplay(gone).forEach(function (c) { chips.appendChild(chipEl(c)); });
      this.goneEl.appendChild(chips);
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
      // 選んだ札が宣言どおりなら金色に光らせ、違う札なら縁を赤く（！の印）
      if (self.selected[c.id] && self.mode === "place" && g.isTrueCard) e.classList.add(g.isTrueCard(c, g.rank) ? "ok" : "ng");
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

  B.recordPlacedFrom = function () {
    var root = this.root;
    var rr = root.getBoundingClientRect();
    var k = rr.width / 1920 || 1;
    var list = [];
    this.handEl.querySelectorAll(".dbt-card.sel").forEach(function (el) {
      var r = el.getBoundingClientRect();
      var m = /rotate\((-?[\d.]+)deg\)/.exec(el.style.transform || "");
      list.push({
        id: el.dataset.id,
        x: (r.left - rr.left) / k, y: (r.top - rr.top) / k, w: el.offsetWidth, h: el.offsetHeight,
        rot: m ? parseFloat(m[1]) : 0,
        html: el.innerHTML,
        red: el.classList.contains("red")
      });
    });
    this.placedFrom = list;
  };

  B.onMain = function () {
    var r = this.resolver;
    if (!r) return;
    if (this.mode === "place" || this.mode === "give") {
      var ids = Object.keys(this.selected);
      // 伏せる札の、いまの位置と表の絵柄を覚えておく（場へ滑らせる演出に使う）
      if (this.mode === "place") this.recordPlacedFrom();
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
    if (this.game && this.game.sealed > 0) return;   // 能力封印中
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
    // これから自分が出す数字（今の手番から3人ごとに1つずつ進む）。交換しながら確かめられるようにする
    var upcoming = [0, 1, 2, 3].map(function (k) { return ((g.rank - 1 + 3 * k) % 13) + 1; });

    function title(t, sub) {
      box.innerHTML = "";
      box.appendChild(h("div", "q", t));
      if (sub) box.appendChild(h("div", "sub", sub));
      var nx = h("div", "nextrow");
      nx.appendChild(h("span", "k", "あなたが出す数字"));
      upcoming.forEach(function (r, k) {
        nx.appendChild(h("span", "rk n" + k, '<b>' + RANK[r] + "</b><small>" + (k === 0 ? "今" : k + "巡後") + "</small>"));
      });
      box.appendChild(nx);
    }
    function grid(label, cards, cls, onPick, selected, demanded) {
      var sec = h("div", "handsec " + (cls || ""));
      sec.appendChild(h("div", "label", label));
      var gr = h("div", "cardgrid");
      sortedCardsForDisplay(cards).forEach(function (c) {
        var e = miniCardEl(c);
        if (selected && selected[c.id]) e.classList.add("sel");
        if (demanded && demanded[c.id]) e.classList.add("demand");
        // これから出す数字の札には、何番目に出す数字かの印を付ける
        var up = upcoming.indexOf(c.r);
        if (up >= 0) {
          e.classList.add("soon", "n" + up);
          e.appendChild(h("em", "", up === 0 ? "今" : up + "巡後"));
        }
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
    // 自分の番の説明は、注意が要る時（ダウトされない・柄の縛り）だけ出す
    var gg = this.game;
    this.guide.classList.toggle("quiet", mode === "place" && !(gg && (gg.immune[0] > 0 || gg.suitRule)));
    if (mode === "place") this.showTurnBanner();
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

  // セリフを言わせて、声が終わるまで待つ（声のファイルが無ければ読める程度に待つ）
  B.sayAndWait = function (g, seat, cat) {
    var id = g.ids[seat];
    var ln = pickLine(id, cat);
    if (!ln) return Promise.resolve();
    var a = playVoice(id, cat, ln.index);
    this.showSay({ seat: seat, cat: cat, text: ln.text });
    return waitVoice(a, 1100, 6000);
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

  /*
   * 札を伏せて、場の山へ滑らせる。
   *   自分の札：伏せるボタンを押した時の手札の位置から、表→裏に返しながら滑らせる
   *   相手の札：立ち絵の位置から裏向きのまま滑らせる
   * 山の上で少し減速して止まり、山がわずかに沈む。
   * 戻り値は飛ばした札の配列。場を描き直してから消すと、ちらつかない。
   */
  B.flyCards = async function (seat, n) {
    var root = this.root;
    var cnt = Math.max(1, Math.min(n, 4));
    var W = 128, H = 180;   // 場の山の札と同じ大きさ
    var rr = root.getBoundingClientRect();
    var k = rr.width / 1920 || 1;
    function rel(r) { return { x: (r.left - rr.left) / k, y: (r.top - rr.top) / k, w: r.width / k, h: r.height / k }; }
    function tf(x, y, r, s, ry) {
      return "perspective(1400px) translate(" + x + "px," + y + "px) rotate(" + r + "deg) rotateY(" + ry + "deg) scale(" + s + ")";
    }

    var pr = rel(this.pileEl.getBoundingClientRect());
    var tx = pr.x + pr.w / 2 - W / 2;
    var ty = pr.y + pr.h / 2 - H / 2;

    // 自分の札は、伏せるボタンを押した瞬間の位置（onMain で記録）
    var from = seat === 0 && this.placedFrom ? this.placedFrom.slice(0, cnt) : [];
    this.placedFrom = null;
    var handEl = this.handEl;
    from.forEach(function (s) {
      var el = s.id && handEl.querySelector('.dbt-card[data-id="' + s.id + '"]');
      if (el) el.style.visibility = "hidden";
    });

    var reduce = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    var flies = [], waits = [];
    for (var i = 0; i < cnt; i++) {
      var s = from[i];
      if (!s) {
        if (seat !== 0 && this.portraits[seat]) {
          var p = rel(this.portraits[seat].getBoundingClientRect());
          s = { x: p.x + p.w / 2 - W / 2 + i * 10, y: p.y + p.h * 0.45 - H / 2, w: W * 0.8, h: H * 0.8, rot: 0 };
        } else {
          s = { x: 860 + i * 14, y: 700, w: 148, h: 212, rot: 0 };
        }
      }
      var e = h("div", "dbt-fly");
      var back = h("div", "b");
      back.style.backgroundImage = "url('" + D.img.cardBack + "')";
      e.appendChild(back);
      var showFront = !!(s.html);
      if (showFront) {
        var front = h("div", "f dbt-card" + (s.red ? " red" : ""));
        front.innerHTML = s.html;
        e.appendChild(front);
      }
      e.style.left = tx + "px";
      e.style.top = ty + "px";
      root.appendChild(e);
      flies.push(e);

      var sx = s.x + s.w / 2 - (tx + W / 2);
      var sy = s.y + s.h / 2 - (ty + H / 2);
      var sc = Math.max(0.6, Math.min(1.6, s.w / W));
      var endRot = (i - (cnt - 1) / 2) * 5 + (Math.random() * 4 - 2);
      var startRot = seat === 1 ? -12 : (seat === 2 ? 12 : (s.rot || 0));
      var lean = seat === 2 ? -4 : 4;   // 滑ってきた向きに少し傾けてから戻す

      if (reduce || !e.animate) {
        e.style.transform = tf(0, 0, endRot, 1, 0);
        continue;
      }
      var frames = showFront ? [
        { transform: tf(sx, sy, startRot, sc, 180), offset: 0 },
        { transform: tf(sx * 0.82, sy * 0.82 - 26, startRot * 0.5 + lean, sc * 1.04, 0), offset: 0.24 },
        { transform: tf(sx * 0.05, sy * 0.05, endRot + lean * 0.6, 1.02, 0), offset: 0.84 },
        { transform: tf(0, 0, endRot, 1, 0), offset: 1 }
      ] : [
        { transform: tf(sx, sy, startRot, sc * 0.85, 0), opacity: 0, offset: 0 },
        { transform: tf(sx * 0.86, sy * 0.86, startRot * 0.6, sc, 0), opacity: 1, offset: 0.14 },
        { transform: tf(sx * 0.05, sy * 0.05, endRot + lean * 0.6, 1.02, 0), opacity: 1, offset: 0.84 },
        { transform: tf(0, 0, endRot, 1, 0), opacity: 1, offset: 1 }
      ];
      var anim = e.animate(frames, { duration: 480, delay: i * 70, easing: "cubic-bezier(.22,.8,.3,1)", fill: "both" });
      waits.push(anim.finished ? anim.finished.catch(function () {}) : sleep(480 + i * 70));
    }
    if (waits.length) await Promise.all(waits);

    // 山がわずかに沈む
    if (!reduce && this.pileEl.animate) {
      this.pileEl.animate(
        [{ transform: "none" }, { transform: "translateY(4px) scale(1.015)" }, { transform: "none" }],
        { duration: 200, easing: "ease-out" });
    }
    return flies;
  };

  // 場を描き直した後に、滑らせた札をそっと消す
  B.clearFlies = function (flies) {
    (flies || []).forEach(function (e) {
      if (e.animate && !(window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches)) {
        var an = e.animate([{ opacity: 1 }, { opacity: 0 }], { duration: 140, easing: "ease-out", fill: "forwards" });
        an.onfinish = function () { closeRoot(e); };
      } else {
        closeRoot(e);
      }
    });
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

  function battleText(ja, en) {
    return window.I18N && window.I18N.isEN() ? en : ja;
  }

  B.pushHistory = function (entry) {
    this.history.push(entry);
    this.historyButton.textContent = battleText("対戦履歴", "Battle History") + " (" + this.history.length + ")";
    if (this.historyOverlay) this.openInfo("history");
  };

  B.openHistory = function (into) {
    if (this.historyOverlay && !into) closeRoot(this.historyOverlay);
    var self = this;
    var ov = h("div", "dbt-overlay dbt-history");
    var box = h("div", "history-box");
    box.appendChild(h("h2", "", battleText("対戦履歴", "Battle History")));
    box.appendChild(h("p", "", battleText(
      "この対戦で公開された情報を最後まで残します。伏せ札など、まだ公開されていない情報は表示しません。",
      "Public information from this battle remains here until the match ends. Hidden cards are never shown."
    )));
    var list = h("div", "history-list");
    if (!this.history.length) list.appendChild(h("p", "", battleText("まだ履歴はありません", "No history yet.")));
    this.history.forEach(function (entry) {
      var row;
      if (entry.type === "play") {
        row = h("div", "history-row play seat-" + entry.seat);
        [String(entry.no), entry.name, "〈" + entry.rank + "〉",
          entry.count + battleText("枚", entry.count === 1 ? " card" : " cards")].forEach(function (text) {
            var cell = h("span", ""); cell.textContent = text; row.appendChild(cell);
          });
      } else if (entry.type === "doubt") {
        row = h("div", "history-row event doubt seat-" + entry.seat);
        [battleText("ダウト", "DOUBT"), entry.name,
          battleText("→ ", "→ ") + entry.targetName].forEach(function (text) {
            var cell = h("span", ""); cell.textContent = text; row.appendChild(cell);
          });
      } else {
        row = h("div", "history-row event result");
        var verdict = entry.cancelled
          ? battleText("ダウト無効", "Doubt Cancelled")
          : (entry.isLie ? battleText("ダウト成功（嘘）", "Doubt Successful (Lie)")
                         : battleText("ダウト失敗（本当）", "Doubt Failed (True)"));
        if (entry.suitPass) verdict = battleText("ダウト失敗（絵柄一致）", "Doubt Failed (Suit Match)");
        var shown = entry.cancelled
          ? battleText("公開なし", "No reveal")
          : battleText("公開：", "Revealed: ") + entry.cards.join(" / ");
        [battleText("結果", "Result"), verdict, shown + "　" + entry.outcome].forEach(function (text) {
          var cell = h("span", ""); cell.textContent = text; row.appendChild(cell);
        });
      }
      list.appendChild(row);
    });
    box.appendChild(list);
    box.appendChild(btn(battleText("閉じる", "Close"), "navy", function () { closeRoot(ov); self.historyOverlay = null; }));
    // 情報画面の「カードのプレイ履歴」の中に並べる時は、説明と一覧だけを移す
    if (into) {
      into.appendChild(box.querySelector("p"));
      into.appendChild(list);
      return list;
    }
    ov.appendChild(box); this.root.appendChild(ov); this.historyOverlay = ov;
    list.scrollTop = list.scrollHeight;
  };

  /*
   * 情報（D案）：カードのプレイ履歴とスキル確認を、タブで切り替えて見る
   */
  B.openInfo = function (tab) {
    var self = this;
    if (!this.game) return;
    if (this.infoOverlay) closeRoot(this.infoOverlay);
    tab = tab === "skills" ? "skills" : "history";
    var ov = h("div", "dbt-overlay dbt-info");
    var box = h("div", "info-box");
    box.appendChild(decoWrap(h("div", "info-hd", tr("情報", "Info"))));
    var tabs = h("div", "info-tabs");
    var tH = btn(tr("カードのプレイ履歴", "Card History"), "navy tab", function () { self.openInfo("history"); });
    var tS = btn(tr("スキル確認", "Skills"), "navy tab", function () { self.openInfo("skills"); });
    (tab === "skills" ? tS : tH).classList.add("on");
    tabs.appendChild(tH);
    tabs.appendChild(tS);
    box.appendChild(tabs);
    var body = h("div", "info-body " + tab);
    box.appendChild(body);
    function close() { closeRoot(ov); self.infoOverlay = null; self.historyOverlay = null; }
    var list = tab === "skills" ? (this.openSkills(body), null) : this.openHistory(body);
    if (tab === "skills") body.insertBefore(h("p", "", tr("この対戦に出ている3人のスキルと、使えるコマンドです。", "Skills of the three players at this table, and your commands.")), body.firstChild);
    box.appendChild(btn(tr("閉じる", "Close"), "navy info-close", close));
    ov.appendChild(box);
    ov.addEventListener("click", function (ev) { if (ev.target === ov) close(); });
    this.root.appendChild(ov);
    this.infoOverlay = ov;
    this.historyOverlay = tab === "history" ? ov : null;
    if (list) {
      var last = list.lastChild;
      if (last && last.classList) last.classList.add("latest");
      list.scrollTop = list.scrollHeight;
    }
  };

  /*
   * スキル発動（D案）：いま使える能力を札のように並べ、選んで「発動する」
   *   自分の番 … 手札の交換　／　ダウトの場面 … 数字の名指し　／　アーケード … ストックした能力
   */
  B.useOptions = function () {
    var g = this.game, m = this.mode, out = [];
    if (!g || !(m === "place" || m === "window")) return out;
    var sealed = g.sealed > 0;
    var mc = D.chara.mahoru;
    if (m === "place") {
      var swaps = g.subUses[0];
      out.push({ key: "swap", id: "mahoru", tag: mc.name, name: abilName("hand_swap"), text: D.chara.hand_swap.ability,
        left: swaps, ok: swaps > 0 && !sealed && !this.stockBusy });
    } else {
      var uses = g.uses[0];
      out.push({ key: "guess", id: "mahoru", tag: mc.name, name: abilName("mahoru"), text: mc.ability,
        left: uses, ok: uses > 0 && !g.doubtBlocked() && !sealed });
    }
    if (g.stockId && D.chara[g.stockId]) {
      out.push({ key: "stock", id: g.stockId, tag: (isBorrowMode() ? tr("借りた力", "Borrowed") : tr("ストック", "Stock")) + "・" + D.chara[g.stockId].name, name: abilName(g.stockId) || D.chara[g.stockId].name, text: D.chara[g.stockId].ability,
        left: g.abilLeft(0, g.stockId), ok: this.stockReady(m) && !this.stockBusy });
    }
    return out;
  };

  B.openUse = function () {
    var self = this;
    var opts = this.useOptions();
    if (!opts.some(function (o) { return o.ok; })) return;
    var ov = h("div", "dbt-overlay dbt-use");
    ov.appendChild(h("div", "use-kicker", "ABILITY"));
    ov.appendChild(decoWrap(h("div", "use-hd", tr("能力発動", "Use an Ability"))));
    var row = h("div", "use-cards");
    var pick = -1;
    var cards = opts.map(function (o, i) {
      var c = h("div", "use-card" + (o.ok ? "" : " off"));
      var art = h("div", "art");
      art.appendChild(h("div", "rays"));
      art.appendChild(portrait(ownerOf(o.id)));
      art.appendChild(h("span", "tag", o.tag));
      c.appendChild(art);
      var gems = "";
      if (o.left < 0) gems = "<b>" + tr("常時", "Always") + "</b>";
      else for (var k = 0; k < o.left; k++) gems += "<i></i>";
      c.appendChild(h("div", "txt",
        '<div class="sep"><i></i><em></em><i></i></div>' +
        '<div class="nm">' + o.name + "</div>" +
        '<div class="ab">' + o.text + "</div>" +
        '<div class="left"><span>' + tr("残り", "Left") + "</span>" + (gems || "<b>0</b>") + "</div>"));
      if (o.ok) c.addEventListener("click", function (ev) { ev.stopPropagation(); choose(i); });
      row.appendChild(c);
      return c;
    });
    ov.appendChild(row);
    var cmds = h("div", "use-cmds");
    var go = btn(tr("発動する", "Activate"), "gold go off", function () {
      if (pick < 0) return;
      var o = opts[pick];
      closeRoot(ov);
      if (o.key === "stock") self.onStock();
      else self.onAbility();
    });
    cmds.appendChild(go);
    cmds.appendChild(btn(tr("もどる", "Back"), "navy", function () { closeRoot(ov); }));
    ov.appendChild(cmds);
    function choose(i) {
      pick = i;
      cards.forEach(function (c, k) { c.classList.toggle("on", k === i); });
      go.classList.toggle("off", false);
    }
    for (var i = 0; i < opts.length; i++) { if (opts[i].ok) { choose(i); break; } }
    this.root.appendChild(ov);
  };

  // 自分の番が来た時に、一度だけ「あなたの番」を出して消す
  B.showTurnBanner = function () {
    var old = this.root.querySelector(".dbt-turnban");
    if (old) closeRoot(old);
    var ban = h("div", "dbt-turnban",
      '<div class="rays"></div><div class="ln top"><i></i><em></em><i></i></div>' +
      '<div class="rib"><small>YOUR TURN</small><b>' + tr("あなたの番", "Your Turn") + "</b></div>" +
      '<div class="ln bot"><i></i><em></em><i></i></div>');
    this.root.appendChild(ban);
    setTimeout(function () { closeRoot(ban); }, 1350);
  };

  B.doubtCutin = async function (g, seat) {
    if (this.historyOverlay) { closeRoot(this.historyOverlay); this.historyOverlay = null; }
    if (this.infoOverlay) { closeRoot(this.infoOverlay); this.infoOverlay = null; }
    var band = h("div", "dbt-doubt-cut");
    band.appendChild(portrait(g.ids[seat], "doubt-face"));
    var label = h("div", "doubt-shout", battleText("ダウト！", "DOUBT!"));
    band.appendChild(label);
    var name = h("div", "doubt-name"); name.textContent = g.name(seat); band.appendChild(name);
    // 帯の色は、ダウトした人ごとに変える（doubt_data.js の doubtBand）
    var col = D.doubtBand && D.doubtBand[g.ids[seat]];
    if (col) {
      band.style.background = "linear-gradient(100deg, #100e1bea, " + col[0] + "f5 48%, #180e1bf0)";
      band.style.setProperty("--band-dark", col[1]);
    }
    this.root.appendChild(band);
    var root = this.root;
    root.classList.add("doubt-cutting");
    await new Promise(function (resolve) {
      var timer = setTimeout(done, 1150);
      function done() { clearTimeout(timer); closeRoot(band); root.classList.remove("doubt-cutting"); resolve(); }
      band.addEventListener("click", done, { once: true });
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
      doubt: function (g, seat) {
        ui.pushHistory({ type: "doubt", seat: seat, name: g.name(seat), targetName: g.name(g.last.seat) });
        return ui.doubtCutin(g, seat);
      },
      placed: async function (g, seat, n) {
        ui.historyPlayCount++;
        ui.pushHistory({ type: "play", no: ui.historyPlayCount, seat: seat, name: g.name(seat), rank: RANK[g.last.rank], count: g.shownPlay(g.last.cards.length, seat) });
        var flies = await ui.flyCards(seat, n);
        ui.render(g);
        ui.clearFlies(flies);
      },
      playerPlace: function (g) {
        ui.game = g;
        return ui.waitInput("place", ui.placeText(g));
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
        // ストックした珠璃の力：伏せ札の中に、一度手にした札があれば分かる
        var rec = g.recognizedCards(g.last.cards);
        if (rec.length) why += "　覚えのある札：" + rec.map(function (c) { return RANK[c.r] + SUIT[c.s]; }).join(" ");
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
      // 真歩流の名指し成功報酬。次の手番はダウトされず、自分の札を n 枚まで捨てられる（0枚でもよい）。
      guessReward: function (g, n) {
        return new Promise(function (resolve) {
          var ov = h("div", "dbt-overlay dbt-exchange dbt-inspect");
          var box = h("div", "box");
          ov.appendChild(box);
          ui.root.appendChild(ov);
          var selected = {};

          function render() {
            box.innerHTML = "";
            box.appendChild(h("div", "q", "名推理成功"));
            box.appendChild(h("div", "sub", "次の手番はダウトされない。手札を" + n + "枚まで捨てられる"));
            var sec = h("div", "handsec");
            sec.appendChild(h("div", "label", "捨てる自分の札"));
            var gr = h("div", "cardgrid");
            sortedCardsForDisplay(g.hands[0]).forEach(function (c) {
              var e = miniCardEl(c);
              if (selected[c.id]) e.classList.add("sel");
              e.classList.add("pickable");
              e.addEventListener("click", function () {
                if (selected[c.id]) delete selected[c.id];
                else {
                  if (Object.keys(selected).length >= n) return;
                  selected[c.id] = true;
                }
                render();
              });
              gr.appendChild(e);
            });
            sec.appendChild(gr);
            box.appendChild(sec);
            var cnt = Object.keys(selected).length;
            box.appendChild(btn(cnt ? "この札を捨てる（" + cnt + "/" + n + "）" : "捨てずに進む", "red confirm", function () {
              closeRoot(ov);
              resolve({ ids: Object.keys(selected) });
            }));
          }
          render();
        });
      },
      // ストックした能力を、条件がそろった場面で使うか確かめる
      askUse: function (g, id, n) {
        return new Promise(function (resolve) {
          var q = {
            koderia: "嘘を見抜かれた！　このダウトを無効にする？",
            mary_deal: "引き取る札のうち" + n + "枚を、相手に押しつける？",
            jushika_sight: "二巡のあいだ、相手全員の手札を見通す？",
          }[id] || D.chara[id].name + "を使う？";
          var ov = h("div", "dbt-overlay dbt-pad dbt-swap dbt-ask");
          var box = h("div", "box");
          box.appendChild(h("div", "q", D.chara[id].name + "<small>" + stockUseText(g.abilLeft(0, id)) + "</small>"));
          box.appendChild(h("div", "sub", q));
          var row = h("div", "targets");
          row.appendChild(btn("使う", "red", function () { closeRoot(ov); resolve(true); }));
          row.appendChild(btn("使わない", "navy", function () { closeRoot(ov); resolve(false); }));
          box.appendChild(row);
          ov.appendChild(box);
          ui.root.appendChild(ov);
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
        // どの能力のカットインか（効果の文から引く）。見出しに能力名を出す
        var skId = id;
        [id, g.subId && g.subId[seat], seat === 0 ? g.stockId : null, g.borrowId, "hand_swap", "free_doubt", "arther_deck", "mary_deal", "eruku_deal", "jushika_sight"]
          .forEach(function (k) { if (k && D.chara[k] && text && text.indexOf(D.chara[k].ability) >= 0 && skId === id) skId = k; });
        if (g.borrowId && text && text.indexOf(D.chara[g.borrowId].name) === 0 && seat === g.awakeSeat) skId = "mahoru_awake_borrow";
        var skName = abilName(skId) || "";
        var skHTML = skName ? '<div class="skn">' + skName + "</div>" : "";
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
          var mtxt = h("div", "txt", skHTML + '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>" + lineHTML);
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

        var txt = h("div", "txt", skHTML + '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>" + lineHTML);
        txt.style.borderColor = ch.color;
        ov.appendChild(txt);
        return ui.overlayWait(ov, 2000);
      },
      resolved: function (g, info) {
        var cards = (info.cards || []).map(function (c) {
          return c.r === 0 ? "JOKER" : RANK[c.r] + SUIT[c.s];
        });
        var outcome;
        if (info.cancelled) {
          outcome = battleText("伏せ札はそのまま場に残る", "The face-down cards remain in the pile");
        } else if (info.noTake || info.loser < 0) {
          outcome = g.name(info.doubter) + battleText("は札を引き取らない", " takes no cards");
        } else if (info.discardCount > 0) {
          outcome = g.name(info.loser) + battleText("が", " takes ") + info.takeCount + battleText("枚回収（", " cards (") +
            info.discardCount + battleText("枚は場から除外）", " removed from play)");
        } else {
          outcome = g.name(info.loser) + battleText("が場の札を", " takes ") + info.takeCount + battleText("枚回収", " cards from the pile");
        }
        ui.pushHistory({
          type: "result", cancelled: !!info.cancelled, isLie: !!info.isLie, suitPass: !!info.suitPass,
          cards: cards, outcome: outcome
        });
      },
      // 挑発の反応。真歩流が煽り、相手2人がそれぞれ乗るか身構える
      // 挑発の掛け合い。真歩流が言い終えてから、相手の二人のうち一人だけが返す（声を重ねない）
      taunt: async function (g, res) {
        await ui.sayAndWait(g, 0, "taunt");
        var who = Math.random() < 0.5 ? 1 : 2;
        await ui.sayAndWait(g, who, "taunt");
      },
      notice: function (g, title, sub) {
        var ov = h("div", "dbt-overlay dbt-notice");
        ov.appendChild(h("div", "box", '<div class="t">' + title + '</div><div class="s">' + (sub || "") + "</div>"));
        return ui.overlayWait(ov, 1400);
      },
      /*
       * ダウト判定の演出（4段階）
       *   1 ダウト宣言：（直前にカットイン）画面を暗くし、伏せ札を中央に並べる …… 約0.3秒
       *   2 カード公開：伏せ札を左から順にめくる …… 1枚0.15秒
       *   3 判定成立  ：判定の根拠（数字・絵柄・違う札）を光らせ、「ダウト成功！／失敗！」 …… 約0.5秒
       *   4 ペナルティ：「〇〇が場の札を引き取る」→ 札がまとまって引き取る側へ飛ぶ
       * 画面を押すと、そこから先は早送りで閉じる。
       */
      reveal: async function (g, info) {
        if (ui.historyOverlay) { closeRoot(ui.historyOverlay); ui.historyOverlay = null; }
        if (ui.infoOverlay) { closeRoot(ui.infoOverlay); ui.infoOverlay = null; }
        var reduce = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
        var skip = false;
        function wait(ms) {
          if (skip || reduce) return Promise.resolve();
          return new Promise(function (r) {
            var t = setTimeout(r, ms);
            waiters.push(function () { clearTimeout(t); r(); });
          });
        }
        var waiters = [];
        function anim(el, frames, opt) {
          if (skip || reduce || !el.animate) {
            var last = frames[frames.length - 1];
            Object.keys(last).forEach(function (k) { if (k !== "offset" && k !== "easing") el.style[k] = last[k]; });
            return Promise.resolve();
          }
          var an = el.animate(frames, Object.assign({ fill: "both" }, opt));
          running.push(an);
          return an.finished ? an.finished.catch(function () {}) : wait(opt.duration || 0);
        }
        var running = [];

        var rr = ui.root.getBoundingClientRect();
        var k = rr.width / 1920 || 1;
        function rel(el) {
          var r = el.getBoundingClientRect();
          return { x: (r.left - rr.left) / k, y: (r.top - rr.top) / k, w: r.width / k, h: r.height / k };
        }

        var ov = h("div", "dbt-overlay dbt-reveal2");
        ov.appendChild(h("div", "who",
          g.name(info.doubter) + "のダウト　―　" + g.name(info.placer) + "の〈" + RANK[info.rank] + "〉"));
        var row = h("div", "cards");
        ov.appendChild(row);
        var basis = h("div", "basis", "");
        ov.appendChild(basis);
        var v = h("div", "verdict", "");
        ov.appendChild(v);
        var res = h("div", "res", "");
        ov.appendChild(res);
        ui.root.appendChild(ov);
        ov.addEventListener("click", function () {
          if (skip) return;
          skip = true;
          running.forEach(function (an) { try { an.finish(); } catch (e) {} });
          waiters.forEach(function (fn) { fn(); });
        });

        // 1 ダウト宣言：伏せ札を場の山から中央へ並べる
        var n = info.cards.length;
        var CW = 148, CH = 212, GAP = 26;
        var rowW = n * CW + (n - 1) * GAP;
        var x0 = (1920 - rowW) / 2, y0 = 400;
        var pile = rel(ui.pileEl);
        var slots = info.cards.map(function (c, i) {
          var slot = h("div", "rv");
          slot.style.left = (x0 + i * (CW + GAP)) + "px";
          slot.style.top = y0 + "px";
          var inner = h("div", "rv-in");
          var back = h("div", "b");
          back.style.backgroundImage = "url('" + D.img.cardBack + "')";
          inner.appendChild(back);
          var face = cardEl(c);
          face.classList.add("f");
          inner.appendChild(face);
          slot.appendChild(inner);
          row.appendChild(slot);
          return { el: slot, inner: inner, face: face, card: c };
        });
        ov.style.background = "rgba(6,10,20,0)";
        anim(ov, [{ backgroundColor: "rgba(6,10,20,0)" }, { backgroundColor: "rgba(6,10,20,.72)" }], { duration: 260, easing: "ease-out" });
        await Promise.all(slots.map(function (s, i) {
          var dx = pile.x + pile.w / 2 - (x0 + i * (CW + GAP) + CW / 2);
          var dy = pile.y + pile.h / 2 - (y0 + CH / 2);
          return anim(s.el, [
            { transform: "translate(" + dx + "px," + dy + "px) scale(.86) rotate(" + (i * 3 - 4) + "deg)", opacity: 0 },
            { transform: "none", opacity: 1 }
          ], { duration: 300, delay: i * 30, easing: "cubic-bezier(.22,.8,.3,1)" });
        }));

        // 2 カード公開：左から順にめくる
        for (var i = 0; i < slots.length; i++) {
          anim(slots[i].inner, [{ transform: "rotateY(0deg)" }, { transform: "rotateY(180deg)" }], { duration: 150, easing: "ease-out" });
          await wait(150);
        }
        await wait(120);

        // 3 判定成立：根拠を光らせる
        var rankHit = info.cards.filter(function (c) { return c.r === info.rank; }).length;
        var red = function (s) { return s === 1 || s === 2; };
        var bad = info.cards.filter(function (c) { return c.r !== info.rank; });
        var bhtml, bcls;
        if (info.isLie) {
          slots.forEach(function (s) {
            if (s.card.r !== info.rank) {
              s.el.classList.add("bad");
              anim(s.el, [{ transform: "translateX(0)" }, { transform: "translateX(-8px)" }, { transform: "translateX(7px)" }, { transform: "translateX(-4px)" }, { transform: "translateX(0)" }], { duration: 300, easing: "ease-out" });
            } else {
              s.el.classList.add("dim");
            }
          });
          bhtml = "〈" + RANK[info.rank] + "〉" + battleText("以外の札", " — other cards") + " <b>×" + bad.length + "</b>";
          bcls = "lie";
        } else if (info.suitPass) {
          var suit = info.cards[0].s;
          slots.forEach(function (s) { s.el.classList.add("hit-suit"); });
          bhtml = '<span class="sym' + (red(suit) ? " red" : "") + '">' + SUIT[suit] + "</span> <b>×" + n + "</b>　" + battleText("絵柄が揃っている", "same suit");
          bcls = "ok";
        } else {
          slots.forEach(function (s) { s.el.classList.add("hit-rank"); });
          bhtml = "〈" + RANK[info.rank] + "〉 <b>×" + rankHit + "</b>　" + battleText("宣言どおり", "as declared");
          bcls = "ok";
        }
        basis.innerHTML = bhtml;
        basis.className = "basis show " + bcls;
        anim(basis, [{ transform: "scale(.7)", opacity: 0 }, { transform: "scale(1.08)", opacity: 1, offset: .6 }, { transform: "scale(1)", opacity: 1 }], { duration: 260, easing: "ease-out" });
        await wait(300);
        v.textContent = info.isLie ? battleText("ダウト成功！", "Doubt Successful!") : battleText("ダウト失敗！", "Doubt Failed!");
        v.className = "verdict show " + (info.isLie ? "lie" : "true");
        anim(v, [{ transform: "scale(1.5)", opacity: 0, letterSpacing: ".4em" }, { transform: "scale(1)", opacity: 1, letterSpacing: ".12em" }], { duration: 260, easing: "cubic-bezier(.2,.9,.3,1.2)" });
        await wait(520);

        // 4 ペナルティ：引き取る側へ札が飛ぶ
        var loser = info.isLie ? info.placer : info.doubter;
        if (info.noTake) {
          res.textContent = g.name(info.doubter) + battleText("は札を引き取らない", " takes no cards");
          res.className = "res show";
          anim(res, [{ opacity: 0, transform: "translateY(10px)" }, { opacity: 1, transform: "none" }], { duration: 200, easing: "ease-out" });
          await wait(700);
          await Promise.all(slots.map(function (s) {
            return anim(s.el, [{ opacity: 1 }, { opacity: 0 }], { duration: 200, easing: "ease-in" });
          }));
        } else {
          res.innerHTML = '<span class="nm">' + g.name(loser) + "</span>" + battleText("が場の札を引き取る", " takes the pile");
          res.className = "res show";
          anim(res, [{ opacity: 0, transform: "translateY(10px)" }, { opacity: 1, transform: "none" }], { duration: 200, easing: "ease-out" });
          await wait(380);

          // 札をまとめる
          var cx = 960 - CW / 2, cy = y0;
          slots.forEach(function (s) { s.el.classList.remove("dim", "bad", "hit-suit", "hit-rank"); });
          await Promise.all(slots.map(function (s, i) {
            var sx = x0 + i * (CW + GAP);
            return anim(s.el, [
              { transform: "none" },
              { transform: "translate(" + (cx - sx + (i - (n - 1) / 2) * 6) + "px," + (-i * 2) + "px) rotate(" + ((i - (n - 1) / 2) * 3) + "deg)" }
            ], { duration: 200, easing: "ease-in-out" });
          }));

          // 引き取る側へ飛ばす（場の山もいっしょに消える）
          var target;
          if (loser === 0) {
            var hr = rel(ui.handEl);
            target = { x: hr.x + hr.w / 2, y: hr.y + hr.h - 120 };
          } else if (ui.portraits[loser]) {
            var pr = rel(ui.portraits[loser]);
            target = { x: pr.x + pr.w / 2, y: pr.y + pr.h / 2 };
          } else {
            target = { x: 960, y: 900 };
          }
          Array.prototype.forEach.call(ui.pileEl.children, function (pc) { pc.style.visibility = "hidden"; });
          anim(row.parentNode.querySelector(".who"), [{ opacity: 1 }, { opacity: 0 }], { duration: 200 });
          anim(basis, [{ opacity: 1 }, { opacity: 0 }], { duration: 200 });
          anim(v, [{ opacity: 1 }, { opacity: 0 }], { duration: 200 });
          var tdx = target.x - 960, tdy = target.y - (cy + CH / 2);
          await Promise.all(slots.map(function (s, i) {
            var sx = x0 + i * (CW + GAP);
            var bx = cx - sx + (i - (n - 1) / 2) * 6, by = -i * 2, br = (i - (n - 1) / 2) * 3;
            return anim(s.el, [
              { transform: "translate(" + bx + "px," + by + "px) rotate(" + br + "deg) scale(1)", opacity: 1 },
              { transform: "translate(" + (bx + tdx * 0.35) + "px," + (by + tdy * 0.35 - 40) + "px) rotate(" + (br + 6) + "deg) scale(.82)", opacity: 1, offset: .4 },
              { transform: "translate(" + (bx + tdx) + "px," + (by + tdy) + "px) rotate(" + (br + 12) + "deg) scale(.45)", opacity: 0 }
            ], { duration: 460, delay: i * 25, easing: "cubic-bezier(.45,.05,.55,.95)" });
          }));

          // 手札が増えた合図
          var gain = g.pile ? g.pile.length : n;
          var halfTake = g.hasAbil && g.hasAbil(loser, "kazuto");
          if (!halfTake && gain > 0) {
            var pop = h("div", "dbt-gain", "＋" + gain);
            pop.style.left = target.x + "px";
            pop.style.top = target.y + "px";
            ui.root.appendChild(pop);
            if (reduce || !pop.animate) setTimeout(function () { closeRoot(pop); }, 600);
            else pop.animate([
              { transform: "translate(-50%,-50%) scale(.6)", opacity: 0 },
              { transform: "translate(-50%,-90%) scale(1.1)", opacity: 1, offset: .3 },
              { transform: "translate(-50%,-130%) scale(1)", opacity: 0 }
            ], { duration: 900, easing: "ease-out", fill: "both" }).onfinish = function () { closeRoot(pop); };
          }
          await anim(ov, [{ backgroundColor: "rgba(6,10,20,.72)" }, { backgroundColor: "rgba(6,10,20,0)" }], { duration: 200, easing: "ease-out" });
        }
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
    var generation = lifecycle.generation;
    var battleStat = TYRANO.kag.stat;
    function checkCurrent() {
      if (generation !== lifecycle.generation || battleStat !== TYRANO.kag.stat) throw cancelled;
    }
    var ui = new BattleUI(idx);
    var io = ui.makeIO();
    Object.keys(io).forEach(function (key) {
      var original = io[key];
      if (typeof original !== "function") return;
      io[key] = function () {
        checkCurrent();
        var value = original.apply(this, arguments);
        if (value && typeof value.then === "function") return value.then(function (result) { checkCurrent(); return result; });
        return value;
      };
    });
    var game = new E.DoubtGame({
      data: D, pairIndex: idx, io: io, level: getLevel(), maxPlay: getMaxPlay(), deckSize: getDeckSize(),
      stock: stockOption()
    });
    ui.game = game;
    lifecycle.battle = ui;
    window.__doubtGame = game; // 調整・確認用
    var result;
    try {
      result = await game.run();
    } finally {
      await sleep(600);
    }
    checkCurrent();
    var fv = f();
    // 中断：試合前の f を残してタイトルへ（doubt_main.ks の *arcade_suspend）。
    // この試合の勝ち負けやスコアは f に書かない
    if (ui.suspended) {
      if (snap) setSuspend({ f: snap, at: Date.now() });
      fv.doubt_suspended = true;
      var sov = h("div", "dbt-overlay dbt-notice");
      sov.appendChild(h("div", "box", '<div class="t">中断</div>'));
      await ui.overlayWait(sov, 1200);
      checkCurrent();
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
    checkCurrent();
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

      // ---- D案：勝ちは事件解決の判、負けは残機を前に出した余韻の構成 ----
      if (win) {
        root.appendChild(h("div", "stamp", '<span class="c">CASE</span><b>' + tr("解決", "SOLVED") + '</b><span class="n">NO.' + ("0" + (pairIndexOf(pm) + 1)).slice(-2) + "</span>"));
      }
      root.appendChild(h("div", "rframe"));
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

    // 物語パートではゲーム用DOMが残っている必要はない。
    // 中断→再開などでVS/結果画面が残留していても、物語開始時に必ず掃除する。
    document.querySelectorAll(".dbt-root").forEach(closeRoot);

    var base = document.querySelector(".tyrano_base") || document.body;
    var b = h("div", "dbt-skipbtn dbt-btn navy", "");
    // ボタンは押した後も残す。スキップ中は「押すと止まる」表示になり、
    // 画面クリックなどでスキップが解除されたら、また「スキップ」に戻る。
    // mousedown を本体まで届けると、押した瞬間に本体側がスキップを解除してしまうので止める。
    b.addEventListener("mousedown", function (ev) { ev.stopPropagation(); });
    b.addEventListener("touchstart", function (ev) { ev.stopPropagation(); });
    b.addEventListener("click", function (ev) {
      ev.stopPropagation();
      var kag = TYRANO.kag;
      try {
        if (kag.stat.is_skip === true) {
          kag.setSkip(false);
        } else {
          // 文字を出している最中は skipstart が弾かれるので、本体と同じ手順で入る
          if (kag.stat.is_adding_text) kag.setSkip(true, {});
          else kag.ftag.startTag("skipstart", {});
        }
      } catch (e) { console.error("[doubt] スキップを切り替えられませんでした", e); }
      syncSkipBtn();
    });
    base.appendChild(b);
    syncSkipBtn();
    bindSkipSync();
  });

  function syncSkipBtn() {
    var b = document.querySelector(".dbt-skipbtn");
    if (!b) return;
    var on = !!(window.TYRANO && TYRANO.kag && TYRANO.kag.stat.is_skip === true);
    if (b.getAttribute("data-on") === (on ? "1" : "0")) return;
    b.setAttribute("data-on", on ? "1" : "0");
    b.classList.toggle("on", on);
    b.innerHTML = "";
    b.appendChild(document.createTextNode(on ? tr("スキップ中", "Skipping") : tr("スキップ", "Skip")));
    b.appendChild(h("span", "ff", on ? "■" : "▶▶"));
    b.appendChild(h("small", "", on ? tr("押すと止まる", "Press to stop") : tr("物語を飛ばす", "Skip story scenes")));
  }

  // スキップの開始・解除を本体のイベントで拾ってボタン表示を合わせる（登録は一度だけ）
  var skipSyncBound = false;
  function bindSkipSync() {
    if (skipSyncBound) return;
    try {
      if (TYRANO.kag && typeof TYRANO.kag.on === "function") {
        TYRANO.kag.on("skip-start skip-stop", function () { setTimeout(syncSkipBtn, 0); });
        skipSyncBound = true;
      }
    } catch (e) { console.error("[doubt] スキップ表示の同期を登録できませんでした", e); }
  }

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

      var pick = { stage: 0, story: 1, total: 0, lives: 1, stock: "" };
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
      var stockItems = [{ t: "なし", v: "" }];
      Object.keys(D.stockUses).forEach(function (id) { stockItems.push({ t: D.chara[id].name, v: id }); });
      row("ストック", "持ち帰った能力", stockItems, "stock");
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
          fv.doubt_stock = pick.stock;
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

  // ---------------------------------------------------------------- 能力の持ち帰り（ストック）
  //   アーケードで卓を突破するたびに、倒した二人の能力から一つだけ持ち帰れる。
  //   持てるのは一つだけ。持ち帰ると、今のストックと入れ替わる。
  //   二つの力を持つキャラは、どちらか一方を選ぶ（D.stock に候補がある）。

  defineTag("doubt_stock", { pair: "0" }, function (pm) {
    var pr = D.pairs[pairIndexOf(pm)];
    var fv = f();
    var options = [];
    [pr.a, pr.b].forEach(function (owner) {
      (D.stock[owner] || []).forEach(function (id) {
        if (D.chara[id]) options.push({ owner: owner, id: id });
      });
    });
    if (!options.length) return;
    return new Promise(function (resolve) {
      var root = openRoot("dbt-stock");
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "hd", "能力を持ち帰る"));
      root.appendChild(h("div", "sub", "倒した相手の力を一つだけ、次の卓から使えます（持てるのは一つだけ）"));
      var cur = fv.doubt_stock && D.chara[fv.doubt_stock] ? fv.doubt_stock : "";
      root.appendChild(h("div", "cur", "いまのストック：" + (cur ? D.chara[cur].name : "なし")));

      var list = h("div", "opts");
      options.forEach(function (o) {
        var card = h("div", "opt");
        card.appendChild(portrait(o.owner));
        var u = stockUses(o.id);
        card.appendChild(h("div", "txt",
          '<div class="own">' + D.chara[o.owner].name + "</div>" +
          skillHTML(o.id, u < 0 ? "常時" : "1ゲーム" + u + "回") + stockNoteHTML(o.id)));
        card.appendChild(btn("持ち帰る", "red take", function () { finish(o.id); }));
        list.appendChild(card);
      });
      root.appendChild(list);
      root.appendChild(btn(cur ? "今のままにする" : "持ち帰らない", "navy keep", function () { finish(cur); }));

      function finish(id) {
        fv.doubt_stock = id || "";
        closeRoot(root);
        resolve();
      }
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

      // ---- カスタムルール：カード枚数 ----
      var deckNow = getDeckSize();
      var deckBox = h("div", "item decksize");
      deckBox.appendChild(h("div", "k", "カード枚数"));
      deckBox.appendChild(h("div", "d", "通常の52枚か、短時間向けの26枚で遊べます。26枚では各数字が2枚ずつです。"));
      var deckOpts = h("div", "opts");
      var deckCells = [];
      function chooseDeckSize(v) {
        deckNow = v;
        setDeckSize(v);
        deckCells.forEach(function (c) { c.classList.toggle("on", c._v === v); });
      }
      (D.rules.deckSizeOptions || [52, 26]).forEach(function (v) {
        var label = v === 26 ? "ショート" : "通常";
        var note = v === 26 ? "26枚・短時間" : "52枚・標準";
        var c = btn(label + "<small>" + note + "</small>", "navy cell wide", function () { chooseDeckSize(v); });
        c._v = v;
        deckCells.push(c);
        deckOpts.appendChild(c);
      });
      deckBox.appendChild(deckOpts);
      root.appendChild(deckBox);
      chooseDeckSize(deckNow);

      // ---- 対戦中のBGM（パターン1：card / boss_battle、パターン2：card_ver2 / boss_battle_ver2）----
      //   sf.doubt_bgm に 1 か 2 を残す。doubt_main.ks の [playbgm] がこの値で曲を選ぶ
      var bgmNow = 1;
      try { bgmNow = parseInt(sysVar().doubt_bgm, 10) === 2 ? 2 : 1; } catch (e) {}
      var bgmBox = h("div", "item bgm");
      bgmBox.appendChild(h("div", "k", tr("対戦中のBGM", "Battle Music")));
      bgmBox.appendChild(h("div", "d", tr("ダウト中に流れる曲を選べます。パターン2は別アレンジの曲になります。",
        "Choose the music played during matches. Pattern 2 uses alternate arrangements.")));
      var bgmOpts = h("div", "opts");
      var bgmCells = [];
      function chooseBgm(v) {
        bgmNow = v;
        try { TYRANO.kag.variable.sf.doubt_bgm = v; TYRANO.kag.saveSystemVariable(); }
        catch (e) { console.error("[doubt] BGM setting could not be saved", e); }
        bgmCells.forEach(function (c) { c.classList.toggle("on", c._v === v); });
      }
      [[1, tr("パターン1", "Pattern 1"), tr("いつもの曲", "Original")], [2, tr("パターン2", "Pattern 2"), tr("別アレンジ", "Alternate")]].forEach(function (o) {
        var c = btn(o[1] + "<small>" + o[2] + "</small>", "navy cell wide", function () { chooseBgm(o[0]); });
        c._v = o[0];
        bgmCells.push(c);
        bgmOpts.appendChild(c);
      });
      bgmBox.appendChild(bgmOpts);
      root.appendChild(bgmBox);
      chooseBgm(bgmNow);

      root.appendChild(btn("とじる", "navy back", function () {
        handoffRoot(root);
        resolve();
      }));
      // ---- D案：横長の札に「見出し・説明」と選択肢を左右に並べる ----
      asBack(root.lastChild);
      var shd = root.querySelector(".hd");
      var shw = h("div", "hd-wrap");
      root.insertBefore(shw, shd);
      shw.appendChild(decoWrap(shd));
      root.querySelectorAll(".item").forEach(function (it) {
        var lab = h("div", "lab");
        it.insertBefore(lab, it.firstChild);
        lab.appendChild(it.querySelector(".k"));
        lab.appendChild(it.querySelector(".d"));
        it.querySelectorAll(".cell").forEach(function (c) {
          c.appendChild(h("span", "chk", '<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#1B2945" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><polyline points="4 12.5 10 18 20 6"></polyline></svg>'));
          var sm = c.querySelector("small");
          if (sm) sm.innerHTML = sm.innerHTML.replace(/(×\s*[\d.]+)/, '<b class="mult">$1</b>');
        });
      });
      root.querySelectorAll(".item .d").forEach(function (d) {
        d.innerHTML = d.innerHTML.replace(/(得点の倍率|score multiplier)/, "<b>$1</b>");
      });
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
        handoffRoot(root);
        resolve();
      }));
      root.appendChild(h("div", "kick", "CONTINUE"));
      root.appendChild(btn("あきらめる<small>今日の勝負は、ここでお開き</small>", "no", function () {
        fv.doubt_continue = false;
        handoffRoot(root);
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
        handoffRoot(root);
        resolve();
      }));
      // ---- D案：「今日はお開き」を主見出しに、映画の終幕のように一列に並べる ----
      (function () {
        var col = h("div", "endcol");
        var go = root.querySelector(".go"), t = root.querySelector(".t"), q = root.querySelector(".q"), back = root.querySelector(".back");
        var gl = h("div", "goline");
        gl.appendChild(h("i", ""));
        gl.appendChild(go);
        gl.appendChild(h("i", ""));
        col.appendChild(gl);
        col.appendChild(t);
        col.appendChild(h("div", "sep", "<em></em><i></i><em></em>"));
        col.appendChild(q);
        col.appendChild(back);
        back.insertAdjacentHTML("afterbegin", '<span class="de l"><em></em><i></i></span>');
        back.insertAdjacentHTML("beforeend", '<span class="de r"><i></i><em></em></span>');
        root.appendChild(col);
      })();
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

      if (window.I18N && window.I18N.isEN && window.I18N.isEN()) {
        tKana.style.display = "none";
        setTab(1);
      } else {
        setTab(0);
      }
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
        handoffRoot(root);
        resolve();
      }));
      // ---- D案：スコアボード。1〜3位に金銀銅、空きは「未登録」 ----
      asBack(root.lastChild);
      var rsub = root.querySelector(".sub");
      if (rsub) { var rw = decoWrap(h("span", "", rsub.innerHTML)); rsub.innerHTML = ""; rsub.appendChild(rw); }
      var board = h("div", "board");
      root.insertBefore(board, rows);
      board.appendChild(h("div", "bhead", "<span>" + tr("順位", "Rank") + "</span><span>" + tr("名前", "Name") + "</span><span>" + tr("通算スコア", "Total Score") + "</span>"));
      board.appendChild(rows);
      rows.querySelectorAll(".row").forEach(function (row, i) {
        row.classList.add("r" + (i + 1));
        var no = row.querySelector(".no");
        no.innerHTML = "<b>" + no.textContent + "</b>";
        if (row.classList.contains("empty")) {
          row.querySelector(".nm").textContent = tr("未登録", "Empty");
          row.querySelector(".pt").textContent = "———";
        } else {
          row.querySelector(".pt").insertAdjacentHTML("beforeend", "<small>" + tr("点", " pts") + "</small>");
        }
        if (row.classList.contains("new")) row.querySelector(".nm").insertAdjacentHTML("beforeend", '<i class="newtag">NEW</i>');
      });
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
