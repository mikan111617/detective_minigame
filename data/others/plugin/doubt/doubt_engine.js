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
    this.handSwapUsed = false;   // 「全員の手札を入れ替え」は1戦に一度だけ
    this.noDoubtPlayer = 0;      // プレイヤーだけダウトを言えない残り手番（快活な少女）
    this.resigned = false;       // 降参した（フリー対戦だけ）
    // 1対戦ごとのプレイヤー戦績。結果画面と精度ボーナスに使う
    this.stats = { doubtAttempts: 0, doubtSuccess: 0, bluffSuccess: 0, guessSuccess: 0 };
    this.playerLieCaught = false;
    this.addedCards = 0;         // 後から卓に混ぜた札の枚数（英国の青年）
    this.copies = {};            // 数字ごとの札の総数。既定は4枚
    this.fakeOffset = {};        // 手札の枚数をごまかす下駄（朱志香）
    this.immune = [0, 0, 0];     // この席の伏せ札にダウトを言えない残り回数（叡留久）

    // 難易度。卓の全員の読みの強さが変わる
    var levels = opt.data.rules.levels;
    this.level = levels[opt.level != null ? opt.level : opt.data.rules.levelDefault] || levels[0];

    // カスタムルール：一度に出せる札の上限
    var mp = parseInt(opt.maxPlay, 10);
    var mpMin = opt.data.rules.maxPlayMin || 1;
    var mpMax = opt.data.rules.maxPlayMax || opt.data.rules.maxPlay;
    if (!(mp >= mpMin && mp <= mpMax)) mp = opt.data.rules.maxPlay;
    this.maxPlay = mp;

    /*
     * CPUごとの記憶。seen[1] と seen[2] は完全に別。
     * 公開された札は Normal/Hard なら二人とも覚えるが、
     * 能力などで本人だけが知った札は、そのCPUの記憶だけに入る。
     * { 札id: { w: 場所, r: 数字 } }
     *   w … 0〜2 = その席の手札／"pile" = 場の伏せ札／-1 = 場から外れた
     */
    this.seen = [{}, {}, {}];

    // 二つ目の能力（sub / subUses）。真歩流？の借り物とは別枠で数える
    this.subId = this.ids.map(function (id) { return opt.data.chara[id].sub || null; });
    this.subUses = this.ids.map(function (id) { return opt.data.chara[id].subUses || 0; });

    // 真歩流？は、対戦が始まる時に誰かの能力を1つ借りる（awakePool から抽選）
    this.awakeSeat = this.ids.indexOf("mahoru_awake");
    this.borrowId = null;
    this.borrowUses = 0;
    if (this.awakeSeat > 0) {
      var pool = (opt.data.awakePool || []).filter(function (id) { return !!opt.data.chara[id]; });
      if (pool.length) {
        this.borrowId = pool[Math.floor(this.rng() * pool.length)];
        this.borrowUses = opt.data.chara[this.borrowId].uses;
      }
    }
  }

  var P = DoubtGame.prototype;

  P.ch = function (seat) { return this.data.chara[this.ids[seat]]; };
  // 画面の文章用の呼び名（プレイヤーは「あなた」）
  P.name = function (seat) {
    if (seat === 0) return "あなた";
    return this.ch(seat).name;
  };
  P.seatOf = function (id) { return this.ids.indexOf(id); };

  // その席が使える能力のid。真歩流？だけは、借りている能力を返す。
  // 「誰か」を見る処理は ids、「どの能力か」を見る処理は abil を使う。
  P.abil = function (seat) {
    return seat === this.awakeSeat && this.borrowId ? this.borrowId : this.ids[seat];
  };
  // その席が持っている能力かどうか（本来の能力／借り物／二つ目の能力）
  P.hasAbil = function (seat, id) {
    return this.abil(seat) === id || this.subId[seat] === id;
  };
  P.abilSeatOf = function (id) {
    for (var s = 0; s < 3; s++) if (this.hasAbil(s, id)) return s;
    return -1;
  };
  P.abilCh = function (seat) { return this.data.chara[this.abil(seat)]; };
  // 能力ごとの残り回数（-1 は常時）。能力idで引く
  P.abilLeft = function (seat, id) {
    if (this.subId[seat] === id) return this.subUses[seat];
    if (seat === this.awakeSeat && this.borrowId === id) return this.borrowUses;
    if (this.ids[seat] === id) return this.uses[seat];
    return 0;
  };
  P.spendAbilId = function (seat, id) {
    if (this.subId[seat] === id) this.subUses[seat]--;
    else if (seat === this.awakeSeat && this.borrowId === id) this.borrowUses--;
    else if (this.ids[seat] === id) this.uses[seat]--;
  };

  // 数字ごとの札の総数。英国の青年が混ぜた分だけ増える（既定は4枚）
  P.copiesOf = function (r) { return this.copies[r] || 4; };

  // ---------------------------------------------------------------- CPUごとの記憶

  P.memoryOf = function (observer) {
    if (!this.seen[observer]) this.seen[observer] = {};
    return this.seen[observer];
  };

  // 特定のCPUだけが知った札を、そのCPUの記憶へ入れる。
  // これは難易度の「公開札を覚える/覚えない」とは別で、能力で自分が扱った札などに使う。
  P.rememberFor = function (observer, cards, where) {
    if (!(observer > 0 && observer < 3)) return;
    var mem = this.memoryOf(observer);
    cards.forEach(function (c) { mem[c.id] = { w: where, r: c.r }; });
  };

  // ダウトで表になった札など、卓全体に公開された情報。
  // Easy は従来どおり公開札の履歴を使わない。
  P.markSeen = function (cards, where) {
    if (!this.level.memory) return;
    this.rememberFor(1, cards, where);
    this.rememberFor(2, cards, where);
  };

  // 在処が分からなくなった札は忘れる。observer を省略すると両CPUから消す。
  P.forgetSeen = function (cards, observer) {
    var observers = observer != null ? [observer] : [1, 2];
    var self = this;
    observers.forEach(function (obs) {
      var mem = self.memoryOf(obs);
      cards.forEach(function (c) { delete mem[c.id]; });
    });
  };

  P.forgetAllSeen = function (observer) {
    if (observer != null) this.seen[observer] = {};
    else {
      this.seen[1] = {};
      this.seen[2] = {};
    }
  };

  // 場の札が誰かの手に渡った時、各CPUがすでに知っていた札だけ在処を更新する。
  P.moveSeenPile = function (cards, where) {
    var self = this;
    [1, 2].forEach(function (obs) {
      var mem = self.memoryOf(obs);
      cards.forEach(function (c) {
        if (mem[c.id]) mem[c.id].w = where;
      });
    });
  };

  // 「Aの手札がBへ」のように丸ごとの移動先が公開されている時、
  // 各CPUがすでに覚えている札の所在だけ正しく付け替える。
  P.remapSeenLocations = function (map) {
    var self = this;
    [1, 2].forEach(function (obs) {
      var mem = self.memoryOf(obs);
      for (var cid in mem) {
        if (!mem.hasOwnProperty(cid)) continue;
        var w = mem[cid].w;
        if (Object.prototype.hasOwnProperty.call(map, w)) mem[cid].w = map[w];
      }
    });
  };

  // 札の中身を伏せたまま「誰から誰へ渡したか」が分かる処理。
  // 渡したCPUと受け取ったCPUだけが札そのものを把握し、第三者はその札を追跡できない。
  P.rememberHiddenTransfer = function (from, to, cards) {
    for (var obs = 1; obs <= 2; obs++) {
      if (obs === from || obs === to) this.rememberFor(obs, cards, to);
      else this.forgetSeen(cards, obs);
    }
  };

  // 能力で新規カードを配った時。使った本人と受取人だけが中身を覚える。
  P.rememberDealtCards = function (actor, to, cards) {
    if (actor > 0) this.rememberFor(actor, cards, to);
    if (to > 0) this.rememberFor(to, cards, to);
  };

  /*
   * 出し手が数字 r を k 枚持っていそうか。
   * 見えていない札の中に r が何枚残っているかと、出し手の手札の大きさから見込みを出す。
   * 見込みが宣言の枚数に届かないほど、嘘らしいと判断する（0〜1）。
   */
  P.lieOdds = function (seat, target, r, k, known) {
    var rest = this.copiesOf(r) - known;
    if (rest <= 0) return 1;
    /*
     * 母数は「誰かの手札にある札」だけ。場の伏せ札や場から外れた札を混ぜると
     * 見込みが小さく出て、当たらないダウトに踏み込んでしまう。
     * 伏せた直後なので、出された k 枚は出し手の手札に戻して数える。
     */
    var inHands = this.hands[0].length + this.hands[1].length + this.hands[2].length + k;
    var hidden = inHands - this.hands[seat].length;   // 自分の手札は見えている
    var memory = this.memoryOf(seat);
    for (var cid in memory) {
      if (!memory.hasOwnProperty(cid)) continue;
      var w = memory[cid].w;
      if (typeof w !== "number") continue;   // 場にある札は手札の母数ではない
      if (w === seat) continue;              // 自分の手札はもう引いてある
      hidden--;
    }
    if (hidden <= 0) return 0;
    var theirHand = this.hands[target].length + k;   // 伏せる前の手札の大きさ
    var expect = rest * (theirHand / hidden);
    if (expect >= k) return 0;
    return Math.min(1, (k - expect) / k);
  };

  /*
   * 朱志香の力が効いている間は、相手二人の手札の枚数がでたらめになり、
   * 伏せた枚数も分からなくなる。ごまかす下駄は力が働いた時に決める。
   */
  P.blurred = function () { return this.unreadable > 0 && this.abilSeatOf("jushika") > 0; };
  P.shownHand = function (seat) {
    if (seat === 0 || !this.blurred()) return this.hands[seat].length;
    return Math.max(1, this.hands[seat].length + (this.fakeOffset[seat] || 0));
  };
  P.shownPlay = function (n, seat) {
    return seat > 0 && this.blurred() ? "？" : n;
  };
  // 出しかけていたカットインを取り下げる（疑わずに終わった時）
  P.dropCutin = function (seat) {
    if (this.pendingCutin && this.pendingCutin.seat === seat) {
      this.pendingCutin = null;
      this.juriShown = false;
    }
  };
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
    if (this.hasAbil(seat, "juri")) {
      var self = this;
      cards.forEach(function (c) { self.juriKnown[c.id] = true; });
    }
    this.sortHand(0);
  };

  P.sortHand = function (seat) {
    this.hands[seat].sort(function (a, b) { return a.r - b.r || a.s - b.s; });
  };

  P.totalCards = function () {
    return this.hands[0].length + this.hands[1].length + this.hands[2].length + this.pile.length + this.discard.length;
  };

  // 卓にあるべき札の枚数。ジョーカーと、後から混ぜた札のぶん増える
  P.expectedCards = function () {
    return 52 + this.jokersOut() + this.addedCards;
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
    var js = this.abilSeatOf("juri");
    if (js > 0) this.hands[js].forEach(function (c) { self.juriKnown[c.id] = true; });
    // メアリーは配り終えた時点の他人の手札だけを覚える。以後は更新しない
    var ms = this.abilSeatOf("mary");
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
      if (this.totalCards() !== this.expectedCards()) {
        throw new Error("card count mismatch: " + this.totalCards() + " / " + this.expectedCards());
      }
    }
    var left = this.hands[1].length + this.hands[2].length;
    var win = this.winner === 0;
    return {
      win: win,
      resigned: this.resigned,
      winner: this.winner,
      oppLeft: left,
      gain: win ? left * this.data.rules.scorePerCard : 0,
      steps: this.steps,
      stats: {
        doubtAttempts: this.stats.doubtAttempts,
        doubtSuccess: this.stats.doubtSuccess,
        bluffSuccess: this.stats.bluffSuccess,
        guessSuccess: this.stats.guessSuccess,
      },
    };
  };

  P.startPassives = async function () {
    for (var seat = 1; seat <= 2; seat++) {
      var id = this.ids[seat];
      if (id === "mary" || id === "juri" || this.ch(seat).catchRate != null) {
        await this.io.cutin(this, seat, this.ch(seat).ability);
      }
      // 何を借りたのかは隠さない。分からないままだと読みようがないので
      if (seat === this.awakeSeat && this.borrowId) {
        var bc = this.data.chara[this.borrowId];
        await this.io.cutin(this, seat, bc.name + "の力を借りる ―― " + bc.ability);
      }
      // 二つ目の能力も、対戦の始めに見せておく
      if (this.subId[seat]) {
        var sc = this.data.chara[this.subId[seat]];
        if (sc) await this.io.cutin(this, seat, "もう一つの力 ―― " + sc.ability);
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
      if (this.resigned) return;
      cards = this.hands[0].filter(function (c) { return ids.indexOf(c.id) >= 0; });
    } else {
      await this.io.wait(this, 380);
      cards = this.aiChoosePlay(seat);
    }

    this.removeFromHand(seat, cards);
    Array.prototype.push.apply(this.pile, cards);
    this.moveSeenPile(cards, "pile");
    // 一度場に出た札は、配り始めの記憶が当てにならなくなる（メアリー）
    var self0 = this;
    cards.forEach(function (c) { delete self0.maryMemo[c.id]; });
    this.last = { seat: seat, cards: cards, rank: this.rank, suitPass: !!this.pendingSuitPass };
    this.pendingSuitPass = false;
    this.turnsTaken[seat]++;

    if (this.hasAbil(seat, "jushika") && this.unreadable > 0) this.unreadable--;

    this.io.log(this, this.name(seat) + "：〈" + RANK[this.rank] + "〉が" + this.shownPlay(cards.length, seat) + "枚");
    this.io.update(this);
    // 枚数が読めない間は、飛んでいく札の数も当てにならないようにする
    await this.io.placed(this, seat, this.blurred() && seat > 0 ? 1 + Math.floor(this.rng() * 4) : cards.length);

    if (seat !== 0) this.aiReactPlace(seat, cards);

    // プレイヤーが嘘を通せた回数を数える。正しいダウトで捕まった時だけ失敗。
    var playerLie = seat === 0 && cards.some(function (c) { return c.r !== this.rank; }, this);
    if (playerLie) this.playerLieCaught = false;
    await this.doubtPhase(seat, cards);
    if (playerLie && !this.playerLieCaught) this.stats.bluffSuccess++;
    if (this.resigned) return;
    if (this.immune[seat] > 0) this.immune[seat]--;
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
    if (this.noDoubtPlayer > 0) this.noDoubtPlayer--;
    this.rank = (this.rank % 13) + 1;
    this.turn = (seat + 1) % 3;
    this.io.update(this);
  };

  /*
   * 降参。入力を待っている最中に呼ばれるので、待ちを解いた側（画面）が
   * 入力を返し、step がこの印を見て打ち切る。
   * 勝ちは、手札がより少ない相手に渡す（時間切れと同じ決め方）。
   */
  P.resign = function () {
    this.resigned = true;
    this.winner = this.hands[1].length <= this.hands[2].length ? 1 : 2;
  };

  P.checkWinner = function (placer) {
    if (this.hands[0].length === 0) { this.winner = 0; return true; }
    if (placer > 0 && this.hands[placer].length === 0) { this.winner = placer; return true; }
    for (var s = 1; s <= 2; s++) if (this.hands[s].length === 0) { this.winner = s; return true; }
    return false;
  };

  // ---------------------------------------------------------------- ダウト

  /*
   * ダウトを言えない状況か（プレイヤー側の画面で使う）。
   * ただし、上がりの一手だけは何があっても疑える。
   * これが無いと「封じて残り札を投げ捨てて終わり」を誰も止められない。
   */
  P.doubtBlocked = function () {
    if (!this.last) return false;
    if (this.hands[this.last.seat].length === 0) return false;
    if (this.noDoubtPlayer > 0) return true;
    return this.immune[this.last.seat] > 0;
  };

  P.doubtPhase = async function (placer, cards) {
    // 叡留久の取引：この席の伏せ札には、誰もダウトを言えない（上がりの一手は別）
    if (this.immune[placer] > 0 && this.hands[placer].length > 0) {
      this.io.log(this, this.name(placer) + "の伏せ札には、ダウトを言えない（残り" + this.immune[placer] + "回）");
      if (placer !== 0) await this.io.playerDoubt(this);
      else await this.io.wait(this, 200);
      return;
    }

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
      // 封じられている間は、何を返されてもダウトは成立しない（上がりの一手は別）
      if (pact.type !== "pass" && !this.doubtBlocked()) {
        await this.resolve(0, placer, pact);
        return;
      }
      // 相方同士でも疑い合う（名指しや能力も、そのまま通す）
      var mate = placer === 1 ? 2 : 1;
      var mact = this.aiDoubtDecision(mate, cards, placer);
      if (mact !== "none") await this.resolve(mate, placer, { type: mact });
    }
  };

  P.resolve = async function (doubter, placer, act) {
    var cards = this.last.cards;
    var rank = this.last.rank;
    var isLie = cards.some(function (c) { return c.r !== rank; });

    /*
     * 愛理：伏せ札がすべて同じ絵柄なら、宣言した数字として通る。
     * 疑われた時だけ消費するので、回数は「守られる回数」になる。
     */
    var suitPass = false;
    if (isLie && this.last.suitPass && this.hasAbil(placer, "airi") && this.abilLeft(placer, "airi") > 0) {
      var s0 = cards[0].s;
      if (cards.every(function (c) { return c.s === s0 && c.r > 0; })) {
        this.spendAbilId(placer, "airi");
        suitPass = true;
        isLie = false;
      }
    }
    // 零度警部：手札3枚を渡して暴く
    var reidoForce = false;
    if (act.type === "ability" && this.hasAbil(doubter, "reido")) {
      this.spendAbilId(doubter, "reido");
      await this.io.cutin(this, doubter, this.data.chara.reido.ability);
      var give = this.pickRandom(this.hands[doubter], 3);
      this.removeFromHand(doubter, give);
      this.addToHand(placer, give);
      // 渡した本人と受取人だけは、どの札が移動したかを覚えている
      this.rememberHiddenTransfer(doubter, placer, give);
      this.io.log(this, this.name(doubter) + "が手札3枚を" + this.name(placer) + "に渡した");
      this.io.update(this);
      reidoForce = true;
    }

    // 名指し推理（真歩流と真歩流？）。相手側は数字を自分で選ぶ
    var guess = 0;
    if (act.type === "guess") {
      this.uses[doubter]--;
      guess = doubter === 0 ? act.guess : this.aiGuessRank(cards, rank);
      await this.io.cutin(this, doubter, "〈" + RANK[guess] + "〉だと名指しする");
    }

    // プレイヤーのダウト戦績。名指しもダウト1回として数える。
    // 愛理の能力で「本当」として通った場合は成功扱いにしない。
    if (doubter === 0) {
      this.stats.doubtAttempts++;
      if (isLie) this.stats.doubtSuccess++;
      if (act.type === "guess" && isLie && guess &&
          cards.some(function (c) { return c.r === guess; })) {
        this.stats.guessSuccess++;
      }
    }

    if (this.pendingCutin) {
      var pc = this.pendingCutin;
      this.pendingCutin = null;
      await this.io.cutin(this, pc.seat, pc.text);
    }
    this.io.say(this, doubter, "doubt");
    this.io.log(this, this.name(doubter) + "：ダウト！");

    // 小出里亜：ダウト無効
    if (isLie && doubter === 0 && this.hasAbil(placer, "koderia") && this.abilLeft(placer, "koderia") > 0) {
      var useIt = this.pile.length >= 3 || this.hands[placer].length === 0 || this.rng() < 0.4;
      if (useIt) {
        this.spendAbilId(placer, "koderia");
        await this.io.cutin(this, placer, this.data.chara.koderia.ability);
        this.io.log(this, this.name(placer) + "がダウトを無効にした");
        await this.io.notice(this, "ダウト無効", "伏せ札はそのまま場に残る");
        return;
      }
    }

    // プレイヤーの嘘が正しいダウトで捕まった。
    // 小出里亜に無効化された場合はここまで来ないので「嘘成功」として残る。
    if (placer === 0 && isLie) this.playerLieCaught = true;

    /*
     * 空振りを恐れない：ダウトを外した時だけ効く。
     * 当たった時は消費しないので、回数はそのまま「空振りできる回数」になる。
     */
    var freeMiss = false;
    if (act.type === "free" && !isLie && this.abilLeft(doubter, "free_doubt") > 0) {
      this.spendAbilId(doubter, "free_doubt");
      freeMiss = true;
    }
    var noTake = !isLie && (reidoForce || freeMiss);

    await this.io.reveal(this, { cards: cards, rank: rank, isLie: isLie, doubter: doubter, placer: placer, noTake: noTake, suitPass: suitPass });
    if (suitPass) await this.io.cutin(this, placer, this.data.chara.airi.ability);
    if (freeMiss) await this.io.cutin(this, doubter, this.data.chara.free_doubt.ability);

    var loser = isLie ? placer : doubter;
    if (noTake) loser = -1;

    // 表になった札は、卓の全員が見ている
    this.markSeen(cards, "pile");

    if (loser >= 0) {
      var take = this.pile.splice(0);
      if (this.hasAbil(loser, "kazuto") && isLie && loser === placer) {
        this.shuffle(take);
        var half = Math.ceil(take.length / 2);
        this.addToHand(loser, take.slice(0, half));
        Array.prototype.push.apply(this.discard, take.slice(half));
        // どちらに回ったか分からないので、覚えていた分は忘れる
        this.forgetSeen(take);
        await this.io.cutin(this, loser, this.data.chara.kazuto.ability);
        this.io.log(this, this.name(loser) + "は" + half + "枚だけ回収（" + (take.length - half) + "枚は場から除外）");
      } else {
        this.addToHand(loser, take);
        this.moveSeenPile(take, loser);
        this.io.log(this, this.name(loser) + "が場の札" + take.length + "枚を回収");
      }
      this.io.update(this);

      if (loser !== 0) {
        this.io.say(this, loser, isLie ? "caught" : "doubt_miss");
        this.io.sayLater(this, loser === 1 ? 2 : 1, "partner", 900);
      } else if (placer !== 0) {
        this.io.say(this, placer, "safe");
      }

      // 相手側の誰かがダウトを外した（＝疑った側として札を引き取った）ときだけ
      if (loser === doubter && !isLie && loser > 0) {
        var js = this.abilSeatOf("jushika");
        if (js > 0) {
          this.unreadable = 2;
          // ごまかす下駄を引き直す。0 は使わない（本当の枚数になってしまう）
          for (var fs = 1; fs <= 2; fs++) {
            var off = 0;
            while (off === 0) off = Math.floor(this.rng() * 7) - 3;
            this.fakeOffset[fs] = off;
          }
          await this.io.cutin(this, js, this.data.chara.jushika.ability);
          await this.io.notice(this, "けむに巻かれた", "二人の手札の枚数と、伏せた枚数が読めない");
        }
      }
    } else {
      this.io.log(this, this.name(doubter) + "の読み違い。札は場に残る");
      await this.io.notice(this, "本当だった", this.name(doubter) + "は札を引き取らない");
    }

    // 名指し成功
    if (guess && isLie && cards.some(function (c) { return c.r === guess; }) && this.hands[doubter].length > 0) {
      var n = Math.min(2, this.hands[doubter].length);
      if (doubter === 0) {
        // 真歩流：成功報酬は「相手1人の手札を見る＋自分の好きな札を2枚まで捨てる」。
        var reward = await this.io.guessReward(this, n);
        if (this.resigned) return;
        var ids = reward && reward.ids ? reward.ids : [];
        var drop = this.hands[0].filter(function (c) { return ids.indexOf(c.id) >= 0; }).slice(0, n);
        if (drop.length === n) {
          this.removeFromHand(0, drop);
          Array.prototype.push.apply(this.discard, drop);
          // 捨てた札は公開情報。既に覚えていたCPUにも「場から外れた」と分かる。
          this.moveSeenPile(drop, -1);
          this.markSeen(drop, -1);
          this.io.log(this, "名推理成功：" + this.name(reward.target) + "の手札を確認し、手札" + n + "枚を捨てた");
          this.io.update(this);
        }
      } else {
        // 真歩流？（CPU）の名指し成功は従来どおり、不要札を相手へ押しつける。
        var gv = this.worstCards(this.hands[doubter], n);
        this.removeFromHand(doubter, gv);
        this.addToHand(placer, gv);
        this.rememberHiddenTransfer(doubter, placer, gv);
        this.sortHand(placer);
        this.io.log(this, this.name(doubter) + "が" + gv.length + "枚を" + this.name(placer) + "に渡した");
        this.io.update(this);
      }
    } else if (guess) {
      this.io.log(this, "名指しは外れた");
    }
  };

  /*
   * 真歩流：相手1人と手札を互いに全公開し、同じ枚数を指定して強制交換する。
   * 公開された内容を記憶するのは交換当事者のCPUだけ。もう一人には中身が見えない。
   */
  P.beginPlayerExchange = async function (target) {
    if (!(target === 1 || target === 2)) return 0;
    if (this.abilLeft(0, "hand_swap") <= 0) return 0;
    var max = Math.min(this.hands[0].length, this.hands[target].length);
    if (max <= 0) return 0;
    this.spendAbilId(0, "hand_swap");
    await this.io.cutin(this, 0, this.data.chara.hand_swap.ability);
    // 対象CPUだけが、公開時点の両者の全手札を把握する。
    this.rememberFor(target, this.hands[0], 0);
    this.rememberFor(target, this.hands[target], target);
    return max;
  };

  // 交換相手が要求する札。次に使いやすい数字と、すでに持つ同数字を優先する。
  P.playerExchangeDemand = function (target, n) {
    var self = this;
    var counts = {};
    this.hands[target].forEach(function (c) { counts[c.r] = (counts[c.r] || 0) + 1; });
    return this.hands[0].slice().sort(function (a, b) {
      var da = self.turnsUntilForSeat(target, a.r);
      var db = self.turnsUntilForSeat(target, b.r);
      if (da !== db) return da - db;
      var ca = counts[a.r] || 0, cb = counts[b.r] || 0;
      if (ca !== cb) return cb - ca;
      return a.r - b.r || a.s - b.s;
    }).slice(0, n);
  };

  P.finishPlayerExchange = function (target, takeIds, giveIds) {
    if (!(target === 1 || target === 2)) return false;
    var theirs = this.hands[target].filter(function (c) { return takeIds.indexOf(c.id) >= 0; });
    var mine = this.hands[0].filter(function (c) { return giveIds.indexOf(c.id) >= 0; });
    var n = theirs.length;
    if (n <= 0 || mine.length !== n || takeIds.length !== n || giveIds.length !== n) return false;

    this.removeFromHand(0, mine);
    this.removeFromHand(target, theirs);
    this.addToHand(0, theirs);
    this.addToHand(target, mine);
    this.sortHand(target);

    // 第三者にはどの札を交換したか見えないため、両者についての所在記憶をいったん失う。
    var third = target === 1 ? 2 : 1;
    var mem = this.memoryOf(third);
    for (var cid in mem) {
      if (!mem.hasOwnProperty(cid)) continue;
      if (mem[cid].w === 0 || mem[cid].w === target) delete mem[cid];
    }

    // 当事者は全公開＋交換内容を見ているので、交換後の両手札を正確に把握する。
    this.rememberFor(target, this.hands[0], 0);
    this.rememberFor(target, this.hands[target], target);

    this.io.log(this, this.name(target) + "と手札を" + n + "枚ずつ交換した");
    this.io.update(this);
    return true;
  };

  // 相手側の名指し推理：guessRate で当てにくる。外す時は、実際の数字も宣言も避ける
  P.aiGuessRank = function (cards, rank) {
    var real = cards.filter(function (c) { return c.r !== rank && c.r > 0; });
    var ch = this.data.chara.mahoru_awake;
    if (real.length && this.rng() < (ch.guessRate != null ? ch.guessRate : 0.7)) {
      return real[Math.floor(this.rng() * real.length)].r;
    }
    var pool = [];
    for (var r = 1; r <= 13; r++) {
      if (r === rank) continue;
      if (cards.some(function (c) { return c.r === r; })) continue;
      pool.push(r);
    }
    return pool[Math.floor(this.rng() * pool.length)];
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

  // 現在の手番から見て、指定した席に数字 x が回ってくるまでの実手番数。
  P.turnsUntilForSeat = function (seat, x) {
    if (x === 0) return 99;
    for (var d = 1; d <= 39; d++) {
      if ((this.turn + d) % 3 !== seat) continue;
      if (((this.rank - 1 + d) % 13) + 1 === x) return d;
    }
    return 99;
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
    var max = this.maxPlay;

    /*
     * 疑われない間は、出せるだけ投げ捨てる。
     * ダウト封じは仕掛けた本人のための一巡なので、相方は便乗しない
     * （二人とも投げ捨てると、一度の封じで卓が決まってしまう）。
     */
    var safeNow = this.immune[seat] > 0 || (this.noDoubtPlayer > 0 && this.hasAbil(seat, "yuduki"));
    if (safeNow && hand.length > 0) {
      var dump = have.slice(0, max);
      if (dump.length < max) dump = dump.concat(this.worstCards(hand, max - dump.length, dump));
      return dump;
    }

    /*
     * 愛理：同じ絵柄で揃えて伏せると、宣言した数字として通る。
     * 正直に出せる枚数より多く捨てられる時だけ使う（使ったことは伏せたまま）。
     */
    if (this.hasAbil(seat, "airi") && this.abilLeft(seat, "airi") > 0) {
      var bySuit = [[], [], [], []];
      hand.forEach(function (c) { if (c.r > 0) bySuit[c.s].push(c); });
      var pick = null;
      for (var su = 0; su < 4; su++) {
        if (!pick || bySuit[su].length > pick.length) pick = bySuit[su];
      }
      if (pick && pick.length > have.length && pick.length >= 2) {
        this.pendingSuitPass = true;
        return this.worstCards(pick, Math.min(pick.length, max));
      }
    }

    if (have.length > 0) {
      var play = have.slice(0, max);
      var rest = hand.length - play.length;
      if (rest >= 3 && play.length < max && this.rng() < ch.bluff * this.level.bluff) {
        play = play.concat(this.worstCards(hand, 1, play));
      }
      return play;
    }
    var n = 1;
    if (hand.length >= 10 && this.rng() < ch.bluff * 0.6 * this.level.bluff) n = 2;
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

    var known = this.hands[seat].filter(function (c) { return c.r === r; }).length;
    var certain = false;
    var mineIds = {};
    this.hands[seat].forEach(function (c) { mineIds[c.id] = true; });
    var playedNow = {};
    cards.forEach(function (c) { playedNow[c.id] = true; });

    /*
     * このCPU自身が覚えている札だけを使う。
     * Normal/Hard は公開札も覚える。Easy でも、能力で自分が直接渡した札など
     * 「本人だけが知っている情報」はここに残る。
     */
    var memory = this.memoryOf(seat);
    var pub = 0;
    for (var pid in memory) {
      if (!memory.hasOwnProperty(pid)) continue;
      var sc = memory[pid];
      if (sc.r !== r) continue;
      if (sc.w === target) continue;    // 出し手の手にあるなら数えない
      if (mineIds[pid]) continue;
      if (playedNow[pid]) continue;
      pub++;
    }
    known = Math.max(known, this.hands[seat].filter(function (c) { return c.r === r; }).length + pub);

    // メアリー：配り終えた時点の他人の手札を覚えている。
    // memo は「出し手以外が持っていたはず」の同じ数字。
    // memoTarget は「出し手が持っていたはず」の同じ数字。
    // 後から公開情報で所在を把握した札は、古い初期記憶ではなく memory 側を優先する。
    var memo = 0;
    var memoTarget = 0;
    if (this.hasAbil(seat, "mary")) {
      var mine = mineIds;
      for (var cid in this.maryMemo) {
        if (!this.maryMemo.hasOwnProperty(cid)) continue;
        if (memory[cid]) continue;                      // より新しい所在を本人が把握している
        if (mine[cid]) continue;                        // 自分の手札は known 側で数えている
        if (parseInt(cid.split("_")[1], 10) !== r) continue;
        if (this.maryMemo[cid] === target) memoTarget++;
        else memo++;
      }

      // 公開情報などで「今も出し手が持っている」と分かっている同数字も加える。
      for (var mid in memory) {
        if (!memory.hasOwnProperty(mid)) continue;
        var ms = memory[mid];
        if (ms.r === r && ms.w === target && !playedNow[mid]) memoTarget++;
      }
    }

    if (this.hasAbil(seat, "juri")) {
      var self = this;
      var playedIds = playedNow;
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
      if (certain || known + k > this.copiesOf(r)) {
        if (!this.juriShown) {
          this.juriShown = true;
          this.pendingCutin = { seat: seat, text: "覚えている札から、嘘を見抜いた" };
        }
      }
    }

    if (known + k > this.copiesOf(r)) certain = true;
    // メアリーの記憶ぶんは、確信の判断にだけ使う（当てずっぽうの疑いは増やさない）
    if (memo && known + memo + k > this.copiesOf(r)) certain = true;

    /*
     * 勘で疑うキャラ（真歩流？・快活な少女）。手札の中身は見ていない。
     *   catchRate … 嘘を見抜く確率。難易度で上がる
     *   falseRate … 本当なのに踏み込んでしまう確率（粗い勘のキャラだけ）
     * 真歩流？は falseRate を持たないので読み違えない。ただし力を封じられている
     * 間は下の普通の読みに戻る。記憶の力（メアリー・珠璃）が確信を与えた時は必ず疑う。
     */
    var sensor = ch.catchRate != null && !(id === "mahoru_awake" && this.sealed > 0);
    if (sensor) {
      var sense = Math.min(1, ch.catchRate + (this.level.catch || 0));
      // 勘の粗さは、難易度が上がるほど減る
      var slip = (ch.falseRate || 0) * (1 - (this.level.catch || 0));
      var feel = isLie ? (certain || this.rng() < sense) : this.rng() < slip;
      if (!feel) {
        this.dropCutin(seat);
        return "none";
      }
      // 名指し推理は真歩流？だけの能力（uses は他のキャラでは別の能力に使う）
      if (id === "mahoru_awake" && this.uses[seat] > 0 && this.hands[seat].length > 0 &&
          (this.hands[seat].length <= 4 || this.rng() < 0.5)) return "guess";
      // 空振りを恐れないなら、外れた時の保険をかけてから踏み込む
      if (this.hasAbil(seat, "free_doubt") && this.abilLeft(seat, "free_doubt") > 0) return "free";
      if (this.hasAbil(seat, "reido") && this.abilLeft(seat, "reido") > 0 && this.hands[seat].length >= 6) return "ability";
      return "doubt";
    }

    if (target !== 0) {
      this.dropCutin(seat);
      /*
       * 自分たちで作った「プレイヤーが疑えない一巡」の間は、相方を撃たない。
       * ここで撃つと、せっかく投げ捨てた札を味方に抱えさせてしまう。
       */
      if (this.noDoubtPlayer > 0) return "none";
      if (certain) return "doubt";
      var md = this.pair.mateDoubt != null ? this.pair.mateDoubt : this.data.rules.mateDoubt;
      var q = (ch.doubt + (k - 1) * 0.1 + known * 0.06) * md * this.level.blind;
      var mo = this.lieOdds(seat, target, r, k, known);
      if (this.level.odds > 0 && mo > 0.6) {
        q += this.level.odds * 0.67 * (mo - 0.6) / 0.4;
      }

      // 相方へのダウトは全体に弱めだが、性格の方向だけは同じにする。
      if (ch.doubtStyle === "logic" && (mo > 0 || known + k >= this.copiesOf(r))) q += 0.06;
      if (ch.doubtStyle === "enjoy" && mo < 0.25 && known === 0) q = Math.max(q, 0.03 + (k - 1) * 0.04);
      if (ch.doubtStyle === "cautious" && known === 0 && mo < 0.4) q *= 0.2;
      if (ch.doubtStyle === "memory" && memo > 0) q += Math.min(0.1, memo * 0.025);
      if (ch.doubtStyle === "evidence" && known === 0 && mo < 0.45) q *= 0.2;
      if (ch.doubtStyle === "perfect_memory" && known === 0) q *= 0.55;
      if (ch.doubtStyle === "risk") {
        if (this.pile.length <= 4) q += 0.05;
        else if (this.pile.length >= 12) q *= 0.55;
      }
      if (ch.doubtStyle === "aggressive" && this.hands[target].length <= 4) q += 0.05;
      if (ch.doubtStyle === "defensive") q *= 0.45;
      if (ch.doubtStyle === "manipulate") q *= 0.62;

      if (this.hands[target].length === 0) q = 0.6;
      q = Math.max(0, Math.min(0.9, q));
      return this.rng() < q ? "doubt" : "none";
    }

    if (certain) {
      // 零度警部は証拠が揃った時ほど、能力で確実に暴きに行く
      if (this.hasAbil(seat, "reido") && this.abilLeft(seat, "reido") > 0 && this.hands[seat].length >= 6) {
        var forceRate = ch.doubtStyle === "evidence" ? 0.6 : 0.3;
        if (this.rng() < forceRate) return "ability";
      }
      return "doubt";
    }

    /*
     * 当てずっぽうの分（blind）と、見込みの分（odds）を足す。
     * やさしい＝当てずっぽうのまま。むずかしい＝ほとんど見込みで判断する。
     */
    var p = (ch.doubt + (k - 1) * 0.12 + known * 0.07) * this.level.blind;

    // 難易度の見込み計算とは別に、キャラクターの「疑い方の癖」にも使う。
    // ここでは実際の伏せ札の中身は見ず、CPUから見えている情報だけで計算する。
    var personalityOdds = this.lieOdds(seat, target, r, k, known);

    if (this.level.odds > 0) {
      /*
       * 外すと場の札をまるごと抱える。場が大きいほど、踏み込むのに必要な
       * 見込みも上がる。下限に届かない時は、見込みでは疑わない。
       * level.odds は「見込みをどれだけ重く見るか」の重み。
       */
      var odds = personalityOdds;
      var needed = 0.45 + Math.min(0.3, this.pile.length * 0.012);
      if (odds > needed) p += this.level.odds * (odds - needed) / (1 - needed);
    }

    /*
     * 愛理：理論型。
     * 「確定ではないが、論理的には怪しい」と考えられる時に踏み込みやすい。
     *   ・見えない札の分布から少しでも不足が見込まれる
     *   ・自分が知っている札＋宣言枚数で、その数字を使い切る宣言になっている
     * 完全な当てずっぽうは増やさず、薄い根拠を拾う方向の個性。
     */
    if (ch.doubtStyle === "logic") {
      var tightCount = known + k >= this.copiesOf(r);
      if (personalityOdds > 0 || tightCount) {
        p += 0.12 + Math.min(0.18, personalityOdds * 0.2 + (tightCount ? 0.06 : 0));
      }
    }

    /*
     * 舞黒邦夢：エンジョイ型。
     * 根拠が薄い時は「面白そうだから」でランダムに踏み込む。
     * ただし大量に捨てる宣言ほど怪しく見えて、遊びのダウト率も上がる。
     * 1/2/3/4枚なら、おおむね 7% / 15% / 23% / 31% が最低ライン。
     */
    if (ch.doubtStyle === "enjoy" && personalityOdds < 0.25 && known === 0) {
      var funP = 0.07 + Math.max(0, k - 1) * 0.08;
      p = Math.max(p, funP);
    }

    // 和人：慎重型。曖昧な状況ではほぼ踏み込まず、根拠が見える時だけ動く。
    if (ch.doubtStyle === "cautious") {
      if (known === 0 && personalityOdds < 0.4) p *= 0.18;
      else p *= 0.75;
    }

    // メアリー：記憶型。記録している枚数と、相手の宣言枚数を照合する。
    // 記録内の枚数なら「持っている根拠がある」ので疑いを弱め、
    // 記録より多く出したら、その超過枚数ぶん怪しいと判断する。
    if (ch.doubtStyle === "memory") {
      if (memoTarget > 0 && k <= memoTarget) {
        p *= 0.25;
      } else if (k > memoTarget) {
        var excess = k - memoTarget;
        p += Math.min(0.28, 0.1 + excess * 0.06);
      }
      // 出し手以外が同じ数字を持っていた記憶も、従来どおり疑う根拠にする。
      if (memo > 0) p += Math.min(0.2, memo * 0.045 + personalityOdds * 0.08);
      else if (!(memoTarget > 0 && k <= memoTarget)) p *= 0.8;
    }

    // 零度警部：証拠型。怪しさが弱い時は静か、見込みが高い時だけ急に踏み込む。
    if (ch.doubtStyle === "evidence") {
      if (known === 0 && personalityOdds < 0.45) {
        p *= 0.18;
      } else {
        p += 0.06 + personalityOdds * 0.12 + Math.min(0.08, known * 0.025);
      }
    }

    // 珠璃：完全記憶型。覚えている同数字が根拠にあるほど強気。
    // 決定的な記憶は上の certain 判定ですでに100%ダウトになる。
    if (ch.doubtStyle === "perfect_memory") {
      if (known > 0) p += Math.min(0.14, known * 0.045);
      else p *= 0.55;
    }

    // 叡留久：リスク計算型。失敗時に抱える場札が少なければ大胆、多ければ慎重。
    if (ch.doubtStyle === "risk") {
      if (this.pile.length <= 4) p += 0.13;
      else if (this.pile.length <= 8) p += 0.06;
      else if (this.pile.length >= 16) p *= 0.35;
      else if (this.pile.length >= 10) p *= 0.65;
    }

    // 朱志香：攻撃型。プレイヤーの上がりが近いほど、逃がさないために踏み込む。
    if (ch.doubtStyle === "aggressive") {
      if (this.hands[0].length <= 5) p += 0.12;
      if (this.hands[0].length <= 2) p += 0.06;
    }

    // 小出里亜：防御型。確定情報以外では、自分から仕掛ける頻度を抑える。
    if (ch.doubtStyle === "defensive") {
      p *= 0.45;
    }

    // 英国の青年：駆け引き型。盤面操作が主役なので、曖昧なダウトには乗りにくい。
    if (ch.doubtStyle === "manipulate") {
      p *= 0.62;
      if (personalityOdds > 0.6) p += 0.05;
    }

    if (this.hands[0].length === 0) p = 0.85;
    else if (this.hands[0].length <= 2) p += 0.2;
    p -= Math.min(0.1, this.pile.length * 0.008);

    // 外しても痛まないなら、確信が無くても踏み込む
    var free = this.hasAbil(seat, "free_doubt") && this.abilLeft(seat, "free_doubt") > 0;
    if (free) p += 0.25;

    if (this.hasAbil(seat, "reido") && this.abilLeft(seat, "reido") > 0 &&
        this.hands[seat].length >= 7 && this.pile.length >= 5) {
      var enoughEvidence = ch.doubtStyle !== "evidence" || personalityOdds >= 0.6 || known >= 2;
      if (enoughEvidence && this.rng() < (ch.doubtStyle === "evidence" ? 0.45 : 0.3)) return "ability";
    }
    p = Math.max(0, Math.min(0.95, p));
    if (this.rng() >= p) return "none";
    return free ? "free" : "doubt";
  };

  P.aiTurnStart = async function (seat) {
    var id = this.ids[seat];
    var self = this;

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
        // 「叡留久とプレイヤーが丸ごと交換した」こと自体は全員に分かるので、
        // 各CPUが覚えていた札の場所を0⇔seatで付け替える。
        var erukuMap = {};
        erukuMap[0] = seat;
        erukuMap[seat] = 0;
        this.remapSeenLocations(erukuMap);
        // 叡留久本人は、自分が渡した旧手札と、受け取った新手札を正確に覚える。
        this.rememberFor(seat, mine, 0);
        this.rememberFor(seat, theirs, seat);
        this.io.log(this, "叡留久が手札を丸ごと入れ替えた");
        this.io.update(this);
      }
    }

    /*
     * 快活な少女：一巡のあいだ、プレイヤーだけダウトを言えなくする。
     * 手札が出せる枚数まで減っていれば、そのまま投げ捨てて上がれるので必ず切る。
     * そこまででなければ、嘘をつかざるを得ない時に切る。
     * 咎められるのは相方だけなので、投げ捨てが通りやすい。
     */
    if (this.hasAbil(seat, "yuduki") && this.abilLeft(seat, "yuduki") > 0 && this.noDoubtPlayer === 0) {
      var mustLie = !this.hands[seat].some(function (c) { return c.r === self.rank; });
      // 手札が出せる枚数まで減っていれば、そのまま上がれる。それ以外は嘘を通す時に切る
      var finisher = this.hands[seat].length <= this.maxPlay;
      if (finisher || (mustLie && this.hands[seat].length >= 6 && this.rng() < 0.4)) {
        this.spendAbilId(seat, "yuduki");
        await this.io.cutin(this, seat, this.data.chara.yuduki.ability);
        this.noDoubtPlayer = 3;
        this.io.log(this, this.name(seat) + "：この一巡、あなたはダウトを言えない");
        await this.io.notice(this, "ダウト封じ", "一巡のあいだ、あなたは疑えない");
        this.io.update(this);
      }
    }

    // 英国の青年：もう一組の札から、自分以外の二人へ3枚ずつ配る（1戦に一度だけ）
    if (this.hasAbil(seat, "arther_deck") && this.abilLeft(seat, "arther_deck") > 0) {
      var minHand = Math.min(this.hands[0].length, this.hands[1].length, this.hands[2].length);
      if (minHand <= 6 && this.hands[seat].length > minHand) {
        this.spendAbilId(seat, "arther_deck");
        await this.io.cutin(this, seat, this.data.chara.arther_deck.ability);
        await this.mixDeck(seat);
      }
    }

    // 英国の青年：取引を持ちかける（毎手番ではなく、ときどき）
    if (this.hasAbil(seat, "arther") && this.abilLeft(seat, "arther") > 0 &&
        this.hands[0].length >= 2 && this.rng() < 0.4) {
      await this.tradeOffer(seat);
    }

    /*
     * メアリー：新しい札を6枚入れて、自分以外の二人に3枚ずつ配る。
     * 相手の上がりが近くなってきた時に、二人を押し戻す。
     */
    if (this.hasAbil(seat, "mary_deal") && this.abilLeft(seat, "mary_deal") > 0) {
      var others = [0, 1, 2].filter(function (t) { return t !== seat; });
      var least = Math.min(this.hands[others[0]].length, this.hands[others[1]].length);
      if (least <= 9) {
        this.spendAbilId(seat, "mary_deal");
        await this.io.cutin(this, seat, this.data.chara.mary_deal.ability);
        await this.inviteDeck(seat, others);
      }
    }

    /*
     * 叡留久：場の伏せ札の半分を引き取る代わりに、三巡のあいだ疑われない。
     * 引き取る札が少なく、捨てたい札が多い時に切る。
     */
    // 場の札が4枚以上ないと「引き取る代わりに」が成り立たないので、下限を置く
    if (this.hasAbil(seat, "eruku_deal") && this.abilLeft(seat, "eruku_deal") > 0 &&
        this.immune[seat] === 0 && this.pile.length >= 4 && this.pile.length <= 12 &&
        this.hands[seat].length >= 6) {
      this.spendAbilId(seat, "eruku_deal");
      await this.io.cutin(this, seat, this.data.chara.eruku_deal.ability);
      var half = Math.floor(this.pile.length / 2);
      if (half > 0) {
        var got = this.pile.splice(0, half);
        this.addToHand(seat, got);
        this.moveSeenPile(got, seat);
        this.sortHand(seat);
      }
      this.immune[seat] = 3;
      this.io.log(this, this.name(seat) + "が場の札" + half + "枚を引き取り、三巡のあいだ疑われない");
      await this.io.notice(this, "危ない取引", this.name(seat) + "の伏せ札は、三巡のあいだダウトできない");
      this.io.update(this);
    }

    // 誰かの手札が少なくなったら、決着をつけさせるためにもてなしは控える
    var minHand = Math.min(this.hands[0].length, this.hands[1].length, this.hands[2].length);
    if (id === "maicro" && (this.turnsTaken[seat] + 1) % 3 === 0 && minHand > this.data.rules.maicroQuiet) {
      await this.maicroEvent(seat);
    }
  };

  /*
   * 英国の青年の取引。同じ数字の札をまとめて渡し、代わりに好きな札を同じ枚数もらう。
   * 渡す札はプレイヤーが選ぶ（弱い札を押し出せるので、一方的な取り上げにはならない）。
   */
  P.tradeOffer = async function (seat) {
    var self = this;
    // 同じ数字がいちばん重なっているところを探す
    var byRank = {};
    this.hands[seat].forEach(function (c) {
      if (c.r === 0) return;                       // ジョーカーは取引に出さない
      (byRank[c.r] = byRank[c.r] || []).push(c);
    });
    // 重なっている中でも、順番が回ってくるのがいちばん遠い数字を手放す
    var best = null, bestFar = -1;
    for (var r in byRank) {
      if (!byRank.hasOwnProperty(r)) continue;
      if (byRank[r].length < 2) continue;
      var far = this.turnsUntil(byRank[r][0].r) * 10 + byRank[r].length;
      if (far > bestFar) { bestFar = far; best = byRank[r]; }
    }
    if (!best) return;

    var n = Math.min(best.length, this.maxPlay, this.hands[0].length);
    if (n < 2) return;
    var give = best.slice(0, n);

    this.spendAbilId(seat, "arther");
    await this.io.cutin(this, seat, this.data.chara.arther.ability);
    await this.io.notice(this, "取引",
      "〈" + RANK[give[0].r] + "〉を" + n + "枚渡す。代わりに好きな札を" + n + "枚もらいたい");

    // 交換相手が何の数字を差し出すのか、選択が終わるまでUIに表示する
    var ids = await this.io.pickGive(this, n, seat, give[0].r);
    if (this.resigned) return;
    var back = this.hands[0].filter(function (c) { return ids.indexOf(c.id) >= 0; });
    this.removeFromHand(seat, give);
    this.removeFromHand(0, back);
    this.addToHand(0, give);
    this.addToHand(seat, back);
    this.sortHand(seat);
    // 差し出した札は公開。返された札の中身は英国の青年本人だけが把握する。
    this.markSeen(give, 0);
    this.rememberFor(seat, give, 0);
    this.rememberHiddenTransfer(0, seat, back);
    this.io.log(this, this.name(seat) + "との取引：〈" + RANK[give[0].r] + "〉" + n + "枚と" + back.length + "枚を交換");
    this.io.update(this);
  };

  // 追加カードは「1種類につき1枚」だけ。同じ数字を複数枚追加しない。
  // 既に追加済みの数字も候補から外すので、通常4枚→最大5枚まで。
  P.makeUniqueExtraCards = function (prefix, count) {
    var ranks = [];
    for (var r = 1; r <= 13; r++) {
      if (this.copiesOf(r) === 4) ranks.push(r);
    }
    this.shuffle(ranks);
    if (ranks.length < count) throw new Error("not enough unique ranks for extra cards");
    var cards = [];
    for (var i = 0; i < count; i++) {
      var rank = ranks[i];
      var suit = Math.floor(this.rng() * 4);
      cards.push({ id: prefix + suit + "_" + rank, r: rank, s: suit });
    }
    return cards;
  };

  /*
   * 新しい札を、自分以外の二人に3枚ずつ配る（メアリー）。
   * 英国の青年とは別の一組なので、札のidの頭文字を分けてある。
   */
  P.inviteDeck = async function (seat, others) {
    var each = this.data.rules.extraDealEach || 3;
    var take = this.makeUniqueExtraCards("e", each * 2);
    for (var i = 0; i < take.length; i++) {
      var to = others[i < each ? 0 : 1];
      this.copies[take[i].r] = this.copiesOf(take[i].r) + 1;
      this.addToHand(to, [take[i]]);
      this.rememberDealtCards(seat, to, [take[i]]);
    }
    for (var k = 0; k < 3; k++) this.sortHand(k);
    this.addedCards += take.length;
    this.io.log(this, this.name(seat) + "の招待：" + this.name(others[0]) + "と" + this.name(others[1]) + "に" + each + "枚ずつ配られた");
    await this.io.notice(this, "香りの招待",
      "新しい札が" + take.length + "枚入り、自分以外の二人に" + each + "枚ずつ配られた");
    this.io.update(this);
  };

  /*
   * もう一組の札から、自分以外の二人へ3枚ずつ新しい札を配る（英国の青年）。
   * 追加される6枚はすべて別の数字で、1種類につき1枚だけ増える。
   */
  P.mixDeck = async function (seat) {
    var each = this.data.rules.extraDealEach || 3;
    var take = this.makeUniqueExtraCards("d", each * 2);
    var others = [0, 1, 2].filter(function (t) { return t !== seat; });
    for (var i = 0; i < take.length; i++) {
      var to = others[i < each ? 0 : 1];
      this.copies[take[i].r] = this.copiesOf(take[i].r) + 1;
      this.addToHand(to, [take[i]]);
      this.rememberDealtCards(seat, to, [take[i]]);
    }
    for (var k = 0; k < 3; k++) this.sortHand(k);
    this.addedCards += take.length;
    this.io.log(this, this.name(seat) + "のもう一組の札：" +
      this.name(others[0]) + "と" + this.name(others[1]) + "に" + each + "枚ずつ配られた");
    await this.io.notice(this, "もう一組の札",
      "新しい札が" + take.length + "枚入り、自分以外の二人に" + each + "枚ずつ配られた");
    this.io.update(this);
  };

  P.maicroEvent = async function (seat) {
    // 今できる余興だけを並べて、その中から引く。
    // （できない時に決まった余興へ寄せると、真歩流？の封印だけが増えてしまう）
    var able = [1];
    if (this.pile.length > 0) able.push(2);
    if (!this.handSwapUsed) able.push(3);
    if (this.jokerStock > 0) able.push(4);
    var roll = able[Math.floor(this.rng() * able.length)];
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
      // ランダム交換なので他人の札の追跡は崩れる。一度各CPUの記憶をリセットし、
      // そのCPU自身が実際に出した札／受け取った札だけを覚え直す。
      var personalMix = [null, null, null];
      for (var s = 0; s < 3; s++) {
        var n = Math.min(this.hands[s].length, this.pile.length);
        if (n === 0) continue;
        this.shuffle(this.pile);
        var fromPile = this.pile.splice(0, n);
        var out = this.pickRandom(this.hands[s], n);
        this.removeFromHand(s, out);
        this.addToHand(s, fromPile);
        Array.prototype.push.apply(this.pile, out);
        if (s > 0) personalMix[s] = { incoming: fromPile.slice(), outgoing: out.slice() };
      }
      this.forgetAllSeen();
      for (var mixSeat = 1; mixSeat <= 2; mixSeat++) {
        if (!personalMix[mixSeat]) continue;
        this.rememberFor(mixSeat, personalMix[mixSeat].incoming, mixSeat);
        this.rememberFor(mixSeat, personalMix[mixSeat].outgoing, "pile");
      }
      this.io.log(this, "邦夢のもてなし：手札と場の札が入れ替わった");
    } else if (roll === 3) {
      // 手札を丸ごと、別の誰かの手札と入れ替える（全員が別の手札になる）。1戦に一度だけ
      this.handSwapUsed = true;
      // perm[元の席] = 新しい行き先。誰の手札が誰へ行ったかは全員が把握できる。
      var perm = this.rng() < 0.5 ? [1, 2, 0] : [2, 0, 1];
      var old = this.hands.map(function (h) { return h.slice(); });
      this.hands = [[], [], []];
      for (var u = 0; u < 3; u++) this.addToHand(perm[u], old[u]);

      var handMap = { 0: perm[0], 1: perm[1], 2: perm[2] };
      this.remapSeenLocations(handMap);

      // 各CPUは、自分の旧手札が誰へ渡ったかと、自分が新しく受け取った手札を把握する。
      for (var obs = 1; obs <= 2; obs++) {
        this.rememberFor(obs, old[obs], perm[obs]);
        this.rememberFor(obs, this.hands[obs], obs);
      }
      this.io.log(this, "邦夢のもてなし：全員の手札が入れ替わった");
    } else {
      this.jokerStock--;
      var joker = { id: "jk" + this.jokerStock, r: 0, s: 4 };
      this.addToHand(target, [joker]);
      this.rememberDealtCards(seat, target, [joker]);
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
