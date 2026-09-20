/*
 * ダウト ミニゲーム 画面処理とティラノスクリプト用タグ
 *
 * [doubt_title]            モード選択        → f.doubt_mode = "arcade" / "simple"
 *                                            （title.ks の *arcade_start / *simple_start へ jump）
 * [doubt_select]           相手選択          → f.doubt_pair = 0〜3（もどる = -1）
 * [doubt_vs pair=0]        相手表示
 * [doubt_battle pair=0]    対戦              → f.doubt_win / f.doubt_gain / f.doubt_opp_left
 * [doubt_result pair=0]    結果（スコア・残機を加算）
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

  function pick(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
  }

  // スキル1件分の表示（名前・発動回数・効果）
  function skillHTML(id, useText, extraName) {
    var ch = D.chara[id];
    return '<div class="skhd">' +
      '<span class="who" style="color:' + ch.color + '">' + ch.name + (extraName || "") + "</span>" +
      '<span class="use">' + (useText != null ? useText : (ch.uses > 0 ? "1ゲーム" + ch.uses + "回" : "常時")) + "</span></div>" +
      '<div class="ab">' + ch.ability + "</div>";
  }

  // アーケードプレイを突破すると、シンプルプレイで最終戦も選べるようになる
  function isCleared() {
    try { return TYRANO.kag.variable.sf.doubt_cleared == 1; } catch (e) { return false; }
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

  // ---------------------------------------------------------------- タイトル

  // title.ks から呼ぶ。画面を出したらすぐ制御を返し、title.ks 側の [s] で待つ。
  // ボタンを押すと title.ks のラベルへ [jump] する（system/title_ui.ks と同じ作り）。
  defineTag("doubt_title", {}, function () {
    var root = openRoot("dbt-title");
    bg(root, D.img.bgTitle);
    root.appendChild(h("div", "dbt-shade shade"));
    root.appendChild(h("div", "head",
      '<div class="kicker">―― 八人の容疑者・一晩の嘘くらべ ――</div>' +
      "<h1>舞黒館の惨劇</h1>" +
      '<div class="sub">「探偵少女はダウトで勝ちの目を見るか」</div>'));
    var modes = h("div", "modes");
    function go(mode, target) {
      f().doubt_mode = mode;
      closeRoot(root);
      TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: target });
    }
    modes.appendChild(btn("アーケードプレイ<small>五戦通し・館主まで</small>", "purple", function () { go("arcade", "*arcade_start"); }));
    modes.appendChild(btn("シンプルプレイ<small>一戦だけ・相手を選ぶ</small>", "navy", function () { go("simple", "*simple_start"); }));
    root.appendChild(modes);
    var extra = h("div", "extra");
    extra.appendChild(btn("ランキング", "navy", function () {
      closeRoot(root);
      TYRANO.kag.ftag.startTag("jump", { storage: "title.ks", target: "*ranking" });
    }));
    root.appendChild(extra);
  });

  // ---------------------------------------------------------------- 相手選択

  defineTag("doubt_select", {}, function () {
    return new Promise(function (resolve) {
      // アーケードプレイを突破していれば、最終戦のペアも選べる
      var pairCount = isCleared() ? D.pairs.length : 4;
      var root = openRoot("dbt-select" + (pairCount > 4 ? " five" : ""));
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));

      var me = h("div", "me");
      me.appendChild(portrait("mahoru"));
      me.appendChild(h("div", "plate", "<small>あなた</small><b>真歩流</b>"));
      me.appendChild(h("div", "myskill", '<div class="sklbl">あなたのスキル</div><div class="sk">' + skillHTML("mahoru") + "</div>"));
      root.appendChild(me);

      var grid = h("div", "grid");
      var cols = [];
      var current = 0;
      var preview = h("div", "preview");
      var plate = h("div", "pairplate");

      // 選んだ相手のスキル（能力）を、名前・発動回数つきで並べる
      function skillRow(id) {
        return '<div class="sk">' + skillHTML(id) + "</div>";
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
        panel.innerHTML = skillHTML(ids[k], null, k === 0 ? "（あなた）" : "");
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

    this.logEl = h("div", "dbt-log", "");
    this.root.appendChild(this.logEl);

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
    cmd.appendChild(this.bMain);
    cmd.appendChild(this.bDoubt);
    cmd.appendChild(this.bAbility);
    cmd.appendChild(this.bSkill);
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

  B.close = function () { closeRoot(this.root); };

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
    });
    box.appendChild(btn("とじる", "navy cancel", function () { closeRoot(ov); }));
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  B.setButtons = function () {
    var g = this.game;
    var nSel = Object.keys(this.selected).length;
    var m = this.mode;
    var uses = g ? g.uses[0] : 0;
    this.bMain.innerHTML = m === "window" ? "見送る" : (m === "give" ? "渡す" : "伏せる");
    this.bMain.classList.toggle("off",
      !((m === "place" && nSel >= 1 && nSel <= D.rules.maxPlay) || m === "window" || (m === "give" && nSel === this.need)));
    this.bDoubt.classList.toggle("off", m !== "window");
    this.bAbility.innerHTML = "能力を発動する<small>残り" + Math.max(0, uses) + "</small>";
    this.bAbility.classList.toggle("off", !(m === "window" && uses > 0));
    this.handEl.classList.toggle("turn", m === "place" || m === "give");
  };

  B.render = function (g) {
    this.game = g;
    var self = this;

    [1, 2].forEach(function (seat) {
      var o = self.opp[seat];
      var id = g.ids[seat];
      var hidden = (id === "jushika" || id === "koderia") && g.unreadable > 0;
      o.count.textContent = hidden ? "？" : g.hands[seat].length;
      o.box.classList.toggle("turn", g.turn === seat && g.winner < 0);
      var ch = D.chara[id];
      o.use.textContent = ch.uses > 0 ? "能力 残り" + Math.max(0, g.uses[seat]) : "";
      if (id === "mahoru_awake" && g.sealed > 0) o.use.textContent = "力を封じられている";
    });

    this.rankBox.innerHTML = "<span>" + RANK[g.rank] + "</span>";
    this.rankLbl.textContent = g.turn === 0 ? "あなたが出す数字" : g.name(g.turn) + "の宣言";

    var n = g.pile.length;
    this.pileInfo.querySelector(".v").textContent = n;
    this.pileInfo.querySelector(".d").textContent = g.discard.length ? "捨て札 " + g.discard.length : "";
    var shown = Math.min(n, 6);
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
    var step = n > 1 ? Math.min(92, (W - cw) / (n - 1)) : 0;
    var total = cw + step * (n - 1);
    var x0 = (W - total) / 2;
    var mid = (n - 1) / 2;
    var spread = Math.min(2.4, 30 / Math.max(1, n));
    this.handEl.innerHTML = "";
    hand.forEach(function (c, i) {
      var e = cardEl(c);
      e.style.left = x0 + i * step + "px";
      var d = i - mid;
      e.style.transform = "rotate(" + d * spread + "deg)";
      e.style.bottom = -Math.abs(d) * Math.min(7, 90 / Math.max(1, n)) + "px";
      e.style.zIndex = i + 1;
      if (self.selected[c.id]) e.classList.add("sel");
      if (self.mode === "place" || self.mode === "give") {
        e.classList.add("pickable");
        e.addEventListener("click", function () { self.toggleCard(c.id); });
      }
      self.handEl.appendChild(e);
    });
  };

  B.toggleCard = function (id) {
    var limit = this.mode === "give" ? this.need : D.rules.maxPlay;
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
          self.finishInput({ type: "ability", guess: r });
        });
        keys.appendChild(k);
      })(r);
    }
    box.appendChild(keys);
    box.appendChild(btn("やめる", "navy cancel", function () { closeRoot(ov); }));
    ov.appendChild(box);
    this.root.appendChild(ov);
  };

  B.finishInput = function (v) {
    var r = this.resolver;
    this.resolver = null;
    this.mode = "idle";
    this.guide.textContent = "";
    this.setButtons();
    this.renderHand(this.game);
    if (r) r(v);
  };

  B.waitInput = function (mode, guide) {
    var self = this;
    this.mode = mode;
    this.selected = {};
    this.guide.textContent = guide;
    this.renderHand(this.game);
    this.setButtons();
    return new Promise(function (resolve) { self.resolver = resolve; });
  };

  B.say = function (g, seat, cat) {
    var id = g.ids[seat];
    var lines = D.lines[id] && D.lines[id][cat];
    if (!lines || !lines.length) return;
    var bub = this.bubble[seat];
    bub.textContent = pick(lines);
    var shaken = cat === "place_shaken" || cat === "caught" || cat === "doubt_miss";
    bub.classList.toggle("shaken", shaken);
    bub.classList.add("show");
    setFace(this.portraits[seat], shaken ? "shaken" : null);
    clearTimeout(bub._t);
    var self = this;
    bub._t = setTimeout(function () {
      bub.classList.remove("show");
      setFace(self.portraits[seat], null);
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
        return ui.waitInput("place", "〈" + RANK[g.rank] + "〉として伏せる札を選ぶ（1〜" + D.rules.maxPlay + "枚・嘘でもよい）");
      },
      playerDoubt: function (g) {
        ui.game = g;
        return ui.waitInput("window", g.name(g.last.seat) + "の〈" + RANK[g.last.rank] + "〉×" + g.last.cards.length + "枚　嘘だと思ったらダウト");
      },
      pickGive: function (g, n, placer) {
        ui.game = g;
        ui.need = n;
        return ui.waitInput("give", g.name(placer) + "に渡す札を" + n + "枚選ぶ");
      },
      // スキル発動カットイン
      //   data/image/cutin/{キャラid}.png があれば一枚絵を全面に出す
      //   無い場合は、これまで通り色帯＋文字だけのカットインになる
      //   rules.cutinEveryTime が false のときは、同じキャラの2回目以降は
      //   下部の細帯（短縮版）にして進行が止まらないようにする
      cutin: function (g, seat, text) {
        var id = g.ids[seat];
        var ch = D.chara[id];
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
          var mtxt = h("div", "txt", '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>");
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

        var txt = h("div", "txt", '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>");
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
        v.textContent = info.isLie ? "嘘！" : "本当";
        v.className = "verdict " + (info.isLie ? "lie" : "true");
        var loser = info.isLie ? info.placer : info.doubter;
        res.textContent = info.noTake ? "零度警部は札を引き取らない" :
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
    var ui = new BattleUI(idx);
    var game = new E.DoubtGame({ data: D, pairIndex: idx, io: ui.makeIO() });
    ui.game = game;
    window.__doubtGame = game; // 調整・確認用
    var result;
    try {
      result = await game.run();
    } finally {
      await sleep(600);
    }
    var fv = f();
    fv.doubt_win = result.win;
    fv.doubt_gain = result.gain;
    fv.doubt_opp_left = result.oppLeft;
    var ov = h("div", "dbt-overlay dbt-notice");
    ov.appendChild(h("div", "box",
      '<div class="t">' + (result.win ? "上がり！" : game.name(result.winner) + "の上がり") + "</div>"));
    await ui.overlayWait(ov, 1800);
    ui.close();
  });

  // ---------------------------------------------------------------- 結果

  defineTag("doubt_result", { pair: "0" }, function (pm) {
    var pr = D.pairs[pairIndexOf(pm)];
    var fv = f();
    var win = !!fv.doubt_win;
    var gain = fv.doubt_gain || 0;
    var before = fv.doubt_total || 0;
    var after = before + gain;
    var added = Math.floor(after / D.rules.lifeEvery) - Math.floor(before / D.rules.lifeEvery);
    fv.doubt_total = after;
    if (fv.doubt_lives == null) fv.doubt_lives = D.rules.baseContinue;
    fv.doubt_lives += added;
    var toNext = D.rules.lifeEvery - (after % D.rules.lifeEvery);

    return new Promise(function (resolve) {
      var root = openRoot("dbt-result" + (win ? "" : " lose"));
      if (win) {
        bg(root, D.img.bgWin);
        root.appendChild(h("div", "dbt-shade shade win"));
      }
      root.appendChild(h("div", "stage", "―― " + pr.label + "・決着 ――"));
      root.appendChild(h("div", "big", win ? "勝利" : "敗北"));
      root.appendChild(h("div", "catch", win ? "嘘を、ぜんぶ剥がした" : "嘘に、呑まれた"));
      root.appendChild(h("div", "panel p1",
        '<div class="k">この対戦</div><div class="v">' + gain.toLocaleString() + "<small>点</small></div>" +
        '<div class="d">' + (win ? "相手の残り札 " + fv.doubt_opp_left + "枚 × " + D.rules.scorePerCard : "勝利時のみ加算") + "</div>"));
      root.appendChild(h("div", "panel p2",
        '<div class="k">通算</div><div class="v">' + after.toLocaleString() + "<small>点</small></div>" +
        '<div class="d">次の残機まで あと' + toNext.toLocaleString() + "点</div>"));
      var lives = "";
      for (var i = 0; i < fv.doubt_lives; i++) lives += "<i" + (i >= fv.doubt_lives - added ? ' class="new"' : "") + "></i>";
      root.appendChild(h("div", "panel p3",
        '<div class="k">残機</div><div class="lives">' + lives + "</div>" +
        '<div class="d">' + (added > 0 ? "残機が" + added + "つ増えた（＋" + added + "）" : "コンティニューできる回数") + "</div>"));
      root.appendChild(btn(win ? "次へ" : "次へ", "next", function () {
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
        closeRoot(root);
        resolve();
      }));
      root.appendChild(btn("あきらめる<small>今夜の勝負は、ここでお開き</small>", "no", function () {
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
      root.appendChild(h("div", "t", "今夜はお開き"));
      root.appendChild(h("div", "q", "「今夜はここまで。<br>また今度おいで、お客人」"));
      root.appendChild(btn("タイトルへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });

  // ---------------------------------------------------------------- ランキング
  //   sf（システム変数）に保存するので、ゲームを閉じても残る
  //   1件 = { n: 名前（最大5文字）, s: 通算スコア }

  function sysVar() { return TYRANO.kag.variable.sf; }

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

  // ---------------------------------------------------------------- 全戦突破

  defineTag("doubt_clear", {}, function () {
    var fv = f();
    // シンプルプレイで最終戦を選べるようにする
    try {
      TYRANO.kag.variable.sf.doubt_cleared = 1;
      TYRANO.kag.saveSystemVariable();
    } catch (e) { console.error("[doubt] 突破フラグの保存に失敗しました", e); }
    return new Promise(function (resolve) {
      var root = openRoot("dbt-clear");
      root.appendChild(h("div", "t", "全戦突破"));
      root.appendChild(h("div", "s", "通算スコア"));
      root.appendChild(h("div", "v", (fv.doubt_total || 0).toLocaleString()));
      root.appendChild(btn("つぎへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });
})();
