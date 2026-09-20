/*
 * ダウト ミニゲーム ルールエンジン
 * 席：0 = プレイヤー（真歩流）、1・2 = 相手ペア
 * 画面処理は io オブジェクトに委ねる（doubt_ui.js）
 */
(function (root) {
  var RANK = ["JOKER", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
  var SUIT = ["♠", "♥", "♦", "♣", "★"];

  function makeRng(seed) {
    if (seed == null) return Math.random;
    var s = seed >>> 0;
    return function () {
      s = (s * 1664525 + 1013904223) >>> 0;
      return s / 4294967296;
    };
  }

  function DoubtGame(opt) {
    this.data = opt.data;
    this.pairIndex = opt.pairIndex;
    this.pair = opt.data.pairs[opt.pairIndex];
    this.io = opt.io;
    this.rng = makeRng(opt.seed);
    this.ids = ["mahoru", this.pair.a, this.pair.b];
    this.hands = [[], [], []];
    this.pile = [];
    this.discard = [];
    this.rank = 1;
    this.turn = 0;
    this.turnsTaken = [0, 0, 0];
    this.uses = this.ids.map(function (id) { return opt.data.chara[id].uses; });
    this.last = null;
    this.winner = -1;
    this.steps = 0;
    this.juriKnown = {};
    this.maryMemo = {};   // メアリーが覚えている「配り終えた時点の、他人の手札」
    this.unreadable = 0;
    this.juriShown = false;
    this.sealed = 0;
    this.jokerStock = opt.data.rules.jokers;
  }

  var P = DoubtGame.prototype;

  P.ch = function (seat) { return this.data.chara[this.ids[seat]]; };
  // 画面の文章用の呼び名（プレイヤーは「あなた」）
  P.name = function (seat) {
    if (seat === 0) return "あなた";
    return this.ch(seat).name;
  };
  P.seatOf = function (id) { return this.ids.indexOf(id); };
  P.rankLabel = function (r) { return RANK[r]; };

  P.shuffle = function (arr) {
    for (var i = arr.length - 1; i > 0; i--) {
      var j = Math.floor(this.rng() * (i + 1));
      var t = arr[i]; arr[i] = arr[j]; arr[j] = t;
    }
    return arr;
  };

  P.pickRandom = function (arr, n) {
    var copy = this.shuffle(arr.slice());
    return copy.slice(0, n);
  };

  P.removeFromHand = function (seat, cards) {
    var ids = {};
    cards.forEach(function (c) { ids[c.id] = true; });
    this.hands[seat] = this.hands[seat].filter(function (c) { return !ids[c.id]; });
  };

  P.addToHand = function (seat, cards) {
    Array.prototype.push.apply(this.hands[seat], cards);
    if (this.ids[seat] === "juri") {
      var self = this;
      cards.forEach(function (c) { self.juriKnown[c.id] = true; });
    }
    this.sortHand(0);
  };

  P.sortHand = function (seat) {
    this.hands[seat].sort(function (a, b) { return a.r - b.r || a.s - b.s; });
  };

  P.totalCards = function () {
    return this.hands[0].length + this.hands[1].length + this.hands[2].length + this.pile.length + this.discard.length - this.jokersOut();
  };

  P.jokersOut = function () {
    return this.data.rules.jokers - this.jokerStock;
  };

  // ---------------------------------------------------------------- 進行

  P.deal = function () {
    var deck = [];
    for (var s = 0; s < 4; s++) for (var r = 1; r <= 13; r++) deck.push({ id: "c" + s + "_" + r, r: r, s: s });
    this.shuffle(deck);
    for (var i = 0; i < 51; i++) this.hands[i % 3].push(deck[i]);
    this.pile.push(deck[51]); // 余りの1枚は場に伏せて始める
    for (var k = 0; k < 3; k++) this.sortHand(k);
    var self = this;
    var js = this.seatOf("juri");
    if (js > 0) this.hands[js].forEach(function (c) { self.juriKnown[c.id] = true; });
    // メアリーは配り終えた時点の他人の手札だけを覚える。以後は更新しない
    var ms = this.seatOf("mary");
    if (ms > 0) {
      for (var t = 0; t < 3; t++) {
        if (t === ms) continue;
        this.hands[t].forEach(function (c) { self.maryMemo[c.id] = t; });
      }
    }
  };

  P.run = async function () {
    this.deal();
    this.io.update(this);
    await this.startPassives();
    while (this.winner < 0) {
      await this.step();
      if (this.totalCards() !== 52) throw new Error("card count mismatch: " + this.totalCards());
    }
    var left = this.hands[1].length + this.hands[2].length;
    var win = this.winner === 0;
    return {
      win: win,
      winner: this.winner,
      oppLeft: left,
      gain: win ? left * this.data.rules.scorePerCard : 0,
      steps: this.steps,
    };
  };

  P.startPassives = async function () {
    for (var seat = 1; seat <= 2; seat++) {
      var id = this.ids[seat];
      if (id === "mary" || id === "juri" || id === "mahoru_awake") {
        await this.io.cutin(this, seat, this.ch(seat).ability);
      }
    }
  };

  P.step = async function () {
    var seat = this.turn;
    this.steps++;

    if (seat !== 0) await this.aiTurnStart(seat);
    if (this.checkWinner(-1)) return;

    var cards;
    if (seat === 0) {
      var ids = await this.io.playerPlace(this);
      cards = this.hands[0].filter(function (c) { return ids.indexOf(c.id) >= 0; });
    } else {
      await this.io.wait(this, 380);
      cards = this.aiChoosePlay(seat);
    }

    this.removeFromHand(seat, cards);
    Array.prototype.push.apply(this.pile, cards);
    this.last = { seat: seat, cards: cards, rank: this.rank };
    this.turnsTaken[seat]++;

    if (this.ids[seat] === "jushika" && this.unreadable > 0) this.unreadable--;

    this.io.log(this, this.name(seat) + "：〈" + RANK[this.rank] + "〉が" + cards.length + "枚");
    this.io.update(this);
    await this.io.placed(this, seat, cards.length);

    if (seat !== 0) this.aiReactPlace(seat, cards);

    await this.doubtPhase(seat, cards);
    this.io.update(this);

    if (this.checkWinner(seat)) return;

    if (this.steps >= this.data.rules.safetyLimit) {
      // 念のための打ち切り：手札が最も少ない席の勝ち（同数ならプレイヤー）
      await this.io.notice(this, "時間切れ", "手札が最も少ない者の勝ち");
      var min = Math.min(this.hands[0].length, this.hands[1].length, this.hands[2].length);
      this.winner = this.hands[0].length === min ? 0 : (this.hands[1].length === min ? 1 : 2);
      return;
    }

    if (this.sealed > 0) this.sealed--;
    this.rank = (this.rank % 13) + 1;
    this.turn = (seat + 1) % 3;
    this.io.update(this);
  };

  P.checkWinner = function (placer) {
    if (this.hands[0].length === 0) { this.winner = 0; return true; }
    if (placer > 0 && this.hands[placer].length === 0) { this.winner = placer; return true; }
    for (var s = 1; s <= 2; s++) if (this.hands[s].length === 0) { this.winner = s; return true; }
    return false;
  };

  // ---------------------------------------------------------------- ダウト

  P.doubtPhase = async function (placer, cards) {
    if (placer === 0) {
      var order = this.shuffle([1, 2]);
      for (var i = 0; i < 2; i++) {
        var s = order[i];
        var act = this.aiDoubtDecision(s, cards);
        if (act !== "none") {
          await this.resolve(s, 0, { type: act });
          return;
        }
      }
      await this.io.wait(this, 200);
    } else {
      var pact = await this.io.playerDoubt(this);
      if (pact.type !== "pass") {
        await this.resolve(0, placer, pact);
        return;
      }
      // 相方同士でも疑い合う
      var mate = placer === 1 ? 2 : 1;
      var mact = this.aiDoubtDecision(mate, cards, placer);
      if (mact === "doubt") await this.resolve(mate, placer, { type: "doubt" });
    }
  };

  P.resolve = async function (doubter, placer, act) {
    var cards = this.last.cards;
    var rank = this.last.rank;
    var isLie = cards.some(function (c) { return c.r !== rank; });
    var dId = this.ids[doubter];
    var pId = this.ids[placer];

    // 零度警部：手札3枚を渡して暴く
    var reidoForce = false;
    if (act.type === "ability" && dId === "reido") {
      this.uses[doubter]--;
      await this.io.cutin(this, doubter, this.ch(doubter).ability);
      var give = this.pickRandom(this.hands[doubter], 3);
      this.removeFromHand(doubter, give);
      this.addToHand(0, give);
      this.io.log(this, "零度警部が手札3枚を真歩流に渡した");
      this.io.update(this);
      reidoForce = true;
    }

    // 真歩流：名指し推理
    var guess = 0;
    if (act.type === "ability" && doubter === 0) {
      this.uses[0]--;
      guess = act.guess;
      await this.io.cutin(this, 0, "〈" + RANK[guess] + "〉だと名指しする");
    }

    if (this.pendingCutin) {
      var pc = this.pendingCutin;
      this.pendingCutin = null;
      await this.io.cutin(this, pc.seat, pc.text);
    }
    if (doubter !== 0) this.io.say(this, doubter, "doubt");
    this.io.log(this, this.name(doubter) + "：ダウト！");

    // 小出里亜：ダウト無効
    if (isLie && doubter === 0 && pId === "koderia" && this.uses[placer] > 0) {
      var useIt = this.pile.length >= 3 || this.hands[placer].length === 0 || this.rng() < 0.4;
      if (useIt) {
        this.uses[placer]--;
        await this.io.cutin(this, placer, this.ch(placer).ability);
        this.io.log(this, "小出里亜がダウトを無効にした");
        await this.io.notice(this, "ダウト無効", "伏せ札はそのまま場に残る");
        return;
      }
    }

    await this.io.reveal(this, { cards: cards, rank: rank, isLie: isLie, doubter: doubter, placer: placer, noTake: !isLie && reidoForce });

    var loser = isLie ? placer : doubter;
    if (!isLie && reidoForce) loser = -1;

    if (loser >= 0) {
      var take = this.pile.splice(0);
      var lId = this.ids[loser];
      if (lId === "kazuto" && isLie && loser === placer) {
        this.shuffle(take);
        var half = Math.ceil(take.length / 2);
        this.addToHand(loser, take.slice(0, half));
        Array.prototype.push.apply(this.discard, take.slice(half));
        await this.io.cutin(this, loser, this.ch(loser).ability);
        this.io.log(this, "和人は" + half + "枚だけ回収（" + (take.length - half) + "枚は場から除外）");
      } else {
        this.addToHand(loser, take);
        this.io.log(this, this.name(loser) + "が場の札" + take.length + "枚を回収");
      }
      this.io.update(this);

      if (loser !== 0) {
        this.io.say(this, loser, isLie ? "caught" : "doubt_miss");
        this.io.sayLater(this, loser === 1 ? 2 : 1, "partner", 900);
      } else if (placer !== 0) {
        this.io.say(this, placer, "safe");
      }

      // 小出里亜がダウトを外した（＝疑った側として札を引き取った）ときだけ
      if (lId === "koderia" && loser === doubter && !isLie) {
        var js = this.seatOf("jushika");
        if (js > 0) {
          this.unreadable = 2;
          await this.io.cutin(this, js, this.ch(js).ability);
        }
      }
    } else {
      this.io.log(this, "零度警部の読み違い。札は場に残る");
      await this.io.notice(this, "本当だった", "零度警部は札を引き取らない");
    }

    // 名指し成功
    if (guess && isLie && cards.some(function (c) { return c.r === guess; }) && this.hands[0].length > 0) {
      var n = Math.min(2, this.hands[0].length);
      await this.io.notice(this, "名推理", "好きな札を" + n + "枚、" + this.name(placer) + "に渡す");
      var ids = await this.io.pickGive(this, n, placer);
      var gv = this.hands[0].filter(function (c) { return ids.indexOf(c.id) >= 0; });
      this.removeFromHand(0, gv);
      this.addToHand(placer, gv);
      this.sortHand(placer);
      this.io.log(this, "あなたが" + gv.length + "枚を" + this.name(placer) + "に渡した");
      this.io.update(this);
    } else if (guess) {
      this.io.log(this, "名指しは外れた");
    }
  };

  // ---------------------------------------------------------------- AI

  // この席に数字 x が回ってくるまでの手番数（今の手番を0とする）
  P.turnsUntil = function (x) {
    if (x === 0) return 99; // ジョーカーはどの数字でもないので、嘘の札として最優先で出す
    for (var k = 1; k <= 13; k++) {
      if (((this.rank - 1 + 3 * k) % 13) + 1 === x) return k;
    }
    return 13;
  };

  P.worstCards = function (hand, n, exclude) {
    var self = this;
    var pool = hand.filter(function (c) { return !exclude || exclude.indexOf(c) < 0; });
    pool = this.shuffle(pool);
    pool.sort(function (a, b) { return self.turnsUntil(b.r) - self.turnsUntil(a.r); });
    return pool.slice(0, n);
  };

  P.aiChoosePlay = function (seat) {
    var ch = this.ch(seat);
    var hand = this.hands[seat];
    var r = this.rank;
    var have = hand.filter(function (c) { return c.r === r; });
    var max = this.data.rules.maxPlay;
    if (have.length > 0) {
      var play = have.slice(0, max);
      var rest = hand.length - play.length;
      if (rest >= 3 && play.length < max && this.rng() < ch.bluff) {
        play = play.concat(this.worstCards(hand, 1, play));
      }
      return play;
    }
    var n = 1;
    if (hand.length >= 10 && this.rng() < ch.bluff * 0.6) n = 2;
    return this.worstCards(hand, Math.min(n, hand.length));
  };

  P.aiReactPlace = function (seat, cards) {
    var ch = this.ch(seat);
    var rank = this.last.rank;
    var isLie = cards.some(function (c) { return c.r !== rank; });
    var p = isLie ? ch.tell : ch.tell * 0.3;
    this.io.say(this, seat, this.rng() < p ? "place_shaken" : "place_calm");
  };

  P.locationOf = function (id) {
    for (var s = 0; s < 3; s++) if (this.hands[s].some(function (c) { return c.id === id; })) return "h" + s;
    return "field";
  };

  P.aiDoubtDecision = function (seat, cards, target) {
    target = target || 0;
    var ch = this.ch(seat);
    var id = this.ids[seat];
    var r = this.last.rank;
    var k = cards.length;
    var isLie = cards.some(function (c) { return c.r !== r; });

    if (id === "mahoru_awake" && this.sealed === 0) {
      return isLie && this.rng() < ch.catchRate ? "doubt" : "none";
    }

    var known = this.hands[seat].filter(function (c) { return c.r === r; }).length;
    var certain = false;

    // メアリー：配り終えた時点の他人の手札を覚えている。
    // 「出し手以外が持っていたはず」の同じ数字を数えて、嘘を見抜く材料にする。
    // 記憶は更新されないので、札が動くほど当てにならなくなる
    // （古い記憶のまま踏み込んで、空振りすることもある）。
    var memo = 0;
    if (id === "mary") {
      var mine = {};
      this.hands[seat].forEach(function (c) { mine[c.id] = true; });
      for (var cid in this.maryMemo) {
        if (!this.maryMemo.hasOwnProperty(cid)) continue;
        if (this.maryMemo[cid] === target) continue;   // 出し手の手にあったはずの札は数えない
        if (mine[cid]) continue;                        // 自分の手札は known 側で数えている
        if (parseInt(cid.split("_")[1], 10) === r) memo++;
      }
    }

    if (id === "juri") {
      var self = this;
      var playedIds = {};
      cards.forEach(function (c) { playedIds[c.id] = true; });
      // 覚えている札が今出された中にあり、数字が違えば確実に嘘
      var memoLie = cards.some(function (c) { return self.juriKnown[c.id] && c.r !== r; });
      // 覚えている同じ数字の札が、今出された札以外の場所にある枚数
      var elsewhere = 0;
      for (var s = 0; s < 4; s++) {
        var cid = "c" + s + "_" + r;
        if (self.juriKnown[cid] && !playedIds[cid] && self.locationOf(cid) !== "h" + target) elsewhere++;
      }
      known = Math.max(known, elsewhere);
      if (memoLie) certain = true;
      if (certain || known + k > 4) {
        if (!this.juriShown) {
          this.juriShown = true;
          this.pendingCutin = { seat: seat, text: "覚えている札から、嘘を見抜いた" };
        }
      }
    }

    if (known + k > 4) certain = true;
    // メアリーの記憶ぶんは、確信の判断にだけ使う（当てずっぽうの疑いは増やさない）
    if (memo && known + memo + k > 4) certain = true;

    if (target !== 0) {
      if (this.pendingCutin && this.pendingCutin.seat === seat) this.pendingCutin = null;
      if (certain) return "doubt";
      var md = this.pair.mateDoubt != null ? this.pair.mateDoubt : this.data.rules.mateDoubt;
      var q = (ch.doubt + (k - 1) * 0.1 + known * 0.06) * md;
      if (this.hands[target].length === 0) q = 0.6;
      return this.rng() < q ? "doubt" : "none";
    }

    if (certain) {
      if (id === "reido" && this.uses[seat] > 0 && this.hands[seat].length >= 6 && this.rng() < 0.3) return "ability";
      return "doubt";
    }

    var p = ch.doubt + (k - 1) * 0.12 + known * 0.07;
    if (this.hands[0].length === 0) p = 0.85;
    else if (this.hands[0].length <= 2) p += 0.2;
    p -= Math.min(0.1, this.pile.length * 0.008);

    if (id === "reido" && this.uses[seat] > 0 && this.hands[seat].length >= 7 && this.pile.length >= 5 && this.rng() < 0.3) {
      return "ability";
    }
    return this.rng() < p ? "doubt" : "none";
  };

  P.aiTurnStart = async function (seat) {
    var id = this.ids[seat];
    var self = this;

    if (id === "airi" && this.uses[seat] > 0) {
      var seen = {};
      var extras = [];
      this.hands[seat].forEach(function (c) {
        if (seen[c.r]) extras.push(c); else seen[c.r] = true;
      });
      if (extras.length >= 2 && this.hands[0].length >= extras.length && this.rng() < 0.6) {
        this.uses[seat]--;
        await this.io.cutin(this, seat, this.ch(seat).ability);
        var fromPlayer = this.pickRandom(this.hands[0], extras.length);
        this.removeFromHand(seat, extras);
        this.removeFromHand(0, fromPlayer);
        this.addToHand(seat, fromPlayer);
        this.addToHand(0, extras);
        this.sortHand(seat);
        this.io.log(this, "愛理が" + extras.length + "枚を交換した");
        this.io.update(this);
      }
    }

    if (id === "eruku" && this.uses[seat] > 0) {
      var diff = this.hands[seat].length - this.hands[0].length;
      if (diff >= 6 || (this.hands[0].length <= 3 && this.hands[seat].length >= 7)) {
        this.uses[seat]--;
        await this.io.cutin(this, seat, this.ch(seat).ability);
        var mine = this.hands[seat];
        var theirs = this.hands[0];
        this.hands[seat] = [];
        this.hands[0] = [];
        this.addToHand(seat, theirs);
        this.addToHand(0, mine);
        this.sortHand(seat);
        this.io.log(this, "叡留久が手札を丸ごと入れ替えた");
        this.io.update(this);
      }
    }

    // 誰かの手札が少なくなったら、決着をつけさせるためにもてなしは控える
    var minHand = Math.min(this.hands[0].length, this.hands[1].length, this.hands[2].length);
    if (id === "maicro" && (this.turnsTaken[seat] + 1) % 3 === 0 && minHand > this.data.rules.maicroQuiet) {
      await this.maicroEvent(seat);
    }
  };

  P.maicroEvent = async function (seat) {
    var roll = 1 + Math.floor(this.rng() * 4);
    if (roll === 2 && this.pile.length === 0) roll = 1;
    if (roll === 4 && this.jokerStock <= 0) roll = 1;
    var target = Math.floor(this.rng() * 3);
    var text = [
      "",
      "うっかり、真歩流？の力を一巡だけ封じてしまう",
      "全員が、手札の枚数分だけ場の伏せ札と入れ替え",
      "全員の手札を、丸ごと誰かと入れ替え",
      "山札からジョーカーを出して、" + this.name(target) + "に渡す",
    ][roll];
    await this.io.cutin(this, seat, text);

    if (roll === 1) {
      this.sealed = 3;
      this.io.log(this, "邦夢のもてなし：真歩流？の力が一巡封じられた");
    } else if (roll === 2) {
      for (var s = 0; s < 3; s++) {
        var n = Math.min(this.hands[s].length, this.pile.length);
        if (n === 0) continue;
        this.shuffle(this.pile);
        var fromPile = this.pile.splice(0, n);
        var out = this.pickRandom(this.hands[s], n);
        this.removeFromHand(s, out);
        this.addToHand(s, fromPile);
        Array.prototype.push.apply(this.pile, out);
      }
      this.io.log(this, "邦夢のもてなし：手札と場の札が入れ替わった");
    } else if (roll === 3) {
      // 手札を丸ごと、別の誰かの手札と入れ替える（全員が別の手札になる）
      var perm = this.rng() < 0.5 ? [1, 2, 0] : [2, 0, 1];
      var old = this.hands.slice();
      this.hands = [[], [], []];
      for (var u = 0; u < 3; u++) this.addToHand(perm[u], old[u]);
      this.io.log(this, "邦夢のもてなし：全員の手札が入れ替わった");
    } else {
      this.jokerStock--;
      var joker = { id: "jk" + this.jokerStock, r: 0, s: 4 };
      this.addToHand(target, [joker]);
      this.io.log(this, "邦夢のもてなし：ジョーカーが" + this.name(target) + "の手札に");
      if (target === 0) await this.io.notice(this, "ジョーカー", "どの数字でもない札。出す時は必ず嘘になる");
    }
    for (var v = 0; v < 3; v++) this.sortHand(v);
    this.io.update(this);
  };

  var Engine = { DoubtGame: DoubtGame, RANK: RANK, SUIT: SUIT };
  root.DoubtEngine = Engine;
  if (typeof module !== "undefined") module.exports = Engine;
})(typeof window !== "undefined" ? window : globalThis);
