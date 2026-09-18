/*
 * ダウト ミニゲーム 画面処理とティラノスクリプト用タグ
 *
 * [doubt_title]            モード選択        → f.doubt_mode = "arcade" / "simple"
 * [doubt_select]           相手選択          → f.doubt_pair = 0〜3（もどる = -1）
 * [doubt_vs pair=0]        相手表示
 * [doubt_battle pair=0]    対戦              → f.doubt_win / f.doubt_gain / f.doubt_opp_left
 * [doubt_result pair=0]    結果（スコア・残機を加算）
 * [doubt_continue]         コンティニュー    → f.doubt_continue = true / false
 * [doubt_gameover]         ゲームオーバー
 * [doubt_clear]            全戦突破
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

  defineTag("doubt_title", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-title");
      bg(root, D.img.bgTitle);
      root.appendChild(h("div", "dbt-shade shade"));
      root.appendChild(h("div", "head",
        '<div class="kicker">―― 八人の容疑者・一晩の嘘くらべ ――</div>' +
        "<h1>舞黒館の惨劇</h1>" +
        '<div class="sub">「探偵少女はダウトで勝ちの目を見るか」</div>'));
      var modes = h("div", "modes");
      function go(mode) {
        f().doubt_mode = mode;
        closeRoot(root);
        resolve();
      }
      modes.appendChild(btn("アーケードプレイ<small>五戦通し・館主まで</small>", "purple", function () { go("arcade"); }));
      modes.appendChild(btn("シンプルプレイ<small>一戦だけ・相手を選ぶ</small>", "navy", function () { go("simple"); }));
      root.appendChild(modes);
      root.appendChild(h("div", "hint", "席に着く相手を選べ"));
    });
  });

  // ---------------------------------------------------------------- 相手選択

  defineTag("doubt_select", {}, function () {
    return new Promise(function (resolve) {
      var root = openRoot("dbt-select");
      bg(root, D.img.bgSelect);
      root.appendChild(h("div", "dbt-shade shade"));

      var me = h("div", "me");
      me.appendChild(portrait("mahoru"));
      me.appendChild(h("div", "plate", "<small>あなた</small><b>真歩流</b>"));
      root.appendChild(me);

      var grid = h("div", "grid");
      var cols = [];
      var current = 0;
      var preview = h("div", "preview");
      var plate = h("div", "pairplate");

      function show(i) {
        current = i;
        cols.forEach(function (c, k) { c.classList.toggle("on", k === i); });
        var pr = D.pairs[i];
        preview.innerHTML = "";
        preview.appendChild(portrait(pr.a, "p1"));
        preview.appendChild(portrait(pr.b, "p2"));
        plate.innerHTML = "<small>" + pr.label + "</small><b>" + D.chara[pr.a].name + " × " + D.chara[pr.b].name + "</b>";
      }

      for (var i = 0; i < 4; i++) {
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
      root.appendChild(h("div", "hint", "← → で相手を選ぶ"));

      function onKey(ev) {
        if (ev.key === "ArrowLeft") show((current + 3) % 4);
        else if (ev.key === "ArrowRight") show((current + 1) % 4);
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
      var left = h("div", "left");
      left.appendChild(portrait("mahoru"));
      left.appendChild(h("div", "copy l", D.playerTagline));
      var right = h("div", "right");
      right.appendChild(portrait(pr.a));
      right.appendChild(portrait(pr.b));
      if (pr.tagline) right.appendChild(h("div", "copy r", pr.tagline));
      root.appendChild(left);
      root.appendChild(right);
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
    this.mary = {};
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
      var bub = h("div", "dbt-bubble s" + seat + (id === "mary" ? " low" : ""));
      self.root.appendChild(bub);
      self.bubble[seat] = bub;
      var mh = h("div", "dbt-maryhand s" + seat);
      self.root.appendChild(mh);
      self.mary[seat] = mh;
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
    cmd.appendChild(this.bMain);
    cmd.appendChild(this.bDoubt);
    cmd.appendChild(this.bAbility);
    this.root.appendChild(cmd);

    this.mode = "idle";
    this.selected = {};
    this.need = 0;
    this.resolver = null;
    this.game = null;
    this.setButtons();
  }

  var B = BattleUI.prototype;

  B.close = function () { closeRoot(this.root); };

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
      var hidden = id === "jushika" && g.unreadable > 0;
      o.count.textContent = hidden ? "？" : g.hands[seat].length;
      o.box.classList.toggle("turn", g.turn === seat && g.winner < 0);
      var ch = D.chara[id];
      o.use.textContent = ch.uses > 0 ? "能力 残り" + Math.max(0, g.uses[seat]) : "";
      if (id === "mahoru_awake" && g.sealed > 0) o.use.textContent = "力を封じられている";
      if (id === "mary") {
        var mh = self.mary[seat];
        mh.innerHTML = "";
        g.hands[seat].slice().sort(function (a, b) { return a.r - b.r; }).forEach(function (c) {
          var vis = g.maryVisible[c.id];
          var red = c.s === 1 || c.s === 2;
          mh.appendChild(h("div", "mini" + (vis ? (red ? " red" : "") : " back"), vis ? (c.r === 0 ? "★" : RANK[c.r]) : ""));
        });
      }
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
      cutin: function (g, seat, text) {
        var id = g.ids[seat];
        var ch = D.chara[id];
        var ov = h("div", "dbt-overlay dbt-cutin");
        var band = h("div", "band");
        band.style.background = "linear-gradient(90deg, " + ch.color + ", #0b1122 90%)";
        band.appendChild(h("div", "lines"));
        var csrc = D.img.cutin(id);
        if (!missing[absUrl(csrc)]) {
          var img = new Image();
          img.onerror = function () { missing[absUrl(csrc)] = true; img.style.display = "none"; };
          img.src = csrc;
          band.appendChild(img);
        }
        ov.appendChild(band);
        ov.appendChild(h("div", "txt", '<div class="nm">' + ch.name + '</div><div class="ef">' + text + "</div>"));
        return ui.overlayWait(ov, 1900);
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

  // ---------------------------------------------------------------- 全戦突破

  defineTag("doubt_clear", {}, function () {
    var fv = f();
    return new Promise(function (resolve) {
      var root = openRoot("dbt-clear");
      root.appendChild(h("div", "t", "全戦突破"));
      root.appendChild(h("div", "s", "通算スコア"));
      root.appendChild(h("div", "v", (fv.doubt_total || 0).toLocaleString()));
      root.appendChild(btn("タイトルへ", "navy back", function () {
        closeRoot(root);
        resolve();
      }));
    });
  });
})();
