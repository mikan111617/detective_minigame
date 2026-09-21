/*
 * ダウト ミニゲーム データ定義
 * キャラクター・ペア・画像パス・掛け合いセリフ（セリフはすべて仮）
 */
(function (root) {
  var IMG = "./data/image/doubt/";
  // 立ち絵の場所。本編の立ち絵をそのまま使う場合は "./data/fgimage/standing/"
  var STAND = "./data/fgimage/standing/";
  // スキル発動カットインの一枚絵の場所（1672×941 / 16:9）
  var CUTIN = "./data/image/cutin/";
  // ボイスの場所（キャラidごとのフォルダに分ける）
  var VOICE = "./data/voice/";

  var DATA = {
    img: {
      bgCaution: "./data/bgimage/caution.png",
      bgTitle: IMG + "bg/bg-title.png",
      bgSelect: IMG + "bg/bg-select.png",
      bgTable: IMG + "bg/bg-table.png",
      bgWin: IMG + "bg/win-01.png",
      bgLose: IMG + "bg/lose.png",
      bgContinue: IMG + "bg/continue.png",
      bgGameover: IMG + "bg/gameover.png",
      cardBack: IMG + "card/card-back.png",
      // 立ち絵：chara/{id}.png　表情差分：chara/{id}_shaken.png（無ければ通常立ち絵）
      chara: function (id, face) {
        var base = DATA.charaFile[id] || id;
        return STAND + base + (face ? "_" + face : "") + ".png";
      },
      // カットイン：data/image/cutin/{id}.png（無ければ文字だけのカットイン）
      cutin: function (id) {
        return CUTIN + (DATA.cutinFile[id] || id) + ".png";
      },
    },

    /*
     * ボイス
     *   下の lines に書いたセリフ 1つ 1つに、音声ファイルを対応させる。
     *   置き場所： data/voice/{キャラid}/{セリフの種類}_{番号}.mp3
     *   番号は lines の配列の並び順（0 から数える）。
     *     例）lines.airi.place_calm[0]「はい、どうぞ♪」
     *         → data/voice/airi/place_calm_0.mp3
     *         　 lines.airi.place_calm[1]「ちゃんと本当だよ？」
     *         → data/voice/airi/place_calm_1.mp3
     *   ファイルが置かれていないセリフは、何も鳴らさずそのまま進む。
     *   （収録済みのキャラだけ先に確かめられるようにしてある）
     */
    voice: {
      on: true,       // false にすると、ボイスを一切鳴らさない
      ext: ".wav",
      volume: 1.0,    // 0〜1。ゲーム本体の効果音ボリュームにも掛かる
      // 声はキャラクターごとに分けて鳴らす。
      //   ・同じキャラが次のセリフを言うと、そのキャラの前のセリフは止まる
      //   ・他のキャラのセリフでは止まらない（掛け合いは重なって鳴る）
      //   ・順番待ちはしないので、ゲームの進行からセリフがずれない
      path: function (id, cat, index) {
        return VOICE + (DATA.voiceFile[id] || id) + "/" + cat + "_" + index + DATA.voice.ext;
      },
    },

    // 立ち絵のファイル名が id と違う場合の対応表（今は全員 id と同名）
    charaFile: {},

    // カットイン画像のファイル名が id と違う場合の対応表
    cutinFile: {},

    // ボイスのフォルダ名が id と違う場合の対応表（今は全員 id と同名）
    voiceFile: {},

    rules: {
      scorePerCard: 100,
      lifeEvery: 10000,
      lifeBonus: 5000,  // 遊び終わった時、残機1つにつきこの点を通算に足す
      baseContinue: 1,
      accuracyBonusMinDoubts: 10, // 1対戦でこの回数以上ダウトすると精度ボーナスの判定対象
      accuracyBonusRate: 0.8,     // ダウト成功率80%以上
      accuracyBonusScore: 2000,   // 条件達成時の追加点
      /*
       * 難易度。設定画面で選ぶ。
       *   score  … 得点の倍率
       *   blind  … 当てずっぽうのダウトの強さ（1 が今までの挙動）
       *   bluff  … 相手が自分から嘘を混ぜる癖の強さ（小さいほど隙を見せない）
       *   memory … 公開された札の在処を全員が覚える
       *   odds   … 「その数字を何枚持っていそうか」の見込みをどれだけ重く見るか（0で使わない）
       *   catch  … 真歩流？の嘘センサーの上乗せ（他のキャラだけ賢くならないように）
       */
      levels: [
        { key: "easy",   name: "やさしい", note: "自分の手札を頼りに、慎重に疑う",       score: 0.8, blind: 0.12, bluff: 2,   memory: false, odds: 0,   catch: 0 },
        { key: "normal", name: "ふつう",   note: "公開された札も覚えて読み合う",         score: 1,   blind: 0.18, bluff: 1,   memory: true,  odds: 0.5, catch: 0.12 },
        { key: "hard",   name: "むずかしい", note: "見込みまで計算し、根拠を重く見る",   score: 1.2, blind: 0.05, bluff: 0.3, memory: true,  odds: 0.9, catch: 0.28 },
      ],
      levelDefault: 0,
      // タイトルに「デバッグ」ボタンを出す。配布する時は false にする
      debugMenu: true,
      hiddenScore: 40000, // この点に届いていれば、コンティニューしていても隠し戦に進める
      extraDealEach: 3,  // メアリー／英国の青年が、自分以外の各プレイヤーに配る新規札の枚数
      roundMax: 3,      // 設定画面で選べるラウンド数の上限
      roundDefault: 1,  // 設定していない時のラウンド数
      maxPlay: 4,       // 一度に出せる札の上限の既定値
      maxPlayMin: 1,
      maxPlayMax: 4,
      jokers: 2, // 舞黒邦夢が山札から出すジョーカーの枚数
      maicroQuiet: 5, // 誰かの手札がこの枚数以下の間は、舞黒邦夢のもてなしが起きない
      safetyLimit: 240, // この手数に達したら時間切れ（手札が最も少ない者の勝ち）
      mateDoubt: 0.4, // 相方同士で疑い合う強さ（通常の疑い確率に掛ける）
      // true  … スキル発動のたびに一枚絵のカットインを出す
      // false … 同じキャラの2回目以降は下部の細帯だけにする（和人・朱志香・
      //         舞黒邦夢は1戦で6〜14回発動するため、既定は false）
      cutinEveryTime: false,
      rankingSize: 5, // アーケードプレイのランキングに残す件数
      nameMax: 5,     // ランキングに登録する名前の文字数
    },

    /*
     * doubt     : 相手の宣言を疑う基本確率
     * catchRate : 嘘を嘘だと見抜く確率（持っているキャラだけ、勘で疑う）
     * falseRate : 本当なのに嘘だと思い込む確率（勘の粗さ。無ければ読み違えない）
     * tell  : 嘘をついた時に動揺が顔に出る確率（本当の時は tell×0.3）
     * bluff : 本当の札に余計な1枚を混ぜる確率
     */
    chara: {
      mahoru: { name: "真歩流", color: "#d8352a", doubt: 0, tell: 0, bluff: 0,
        ability: "ダウトの時に相手の出した数字を言い当てると、自分の手札から好きな2枚を相手に渡せる（1ゲーム2回まで）",
        uses: 2, sub: "hand_swap", subUses: 2 },
      airi: { name: "愛理", color: "#f5a3b8", doubt: 0.3, tell: 0.6, bluff: 0.05,
        doubtStyle: "logic", // 理論型：確定でなくても、論理的に怪しさが出た場面は検討して踏み込む
        ability: "伏せた札がすべて同じ絵柄なら、宣言した数字として通る（ダウトされた時だけ消費）",
        uses: 3 },
      kazuto: { name: "和人", color: "#4f7fd8", doubt: 0.28, tell: 0.5, bluff: 0.05,
        ability: "ダウトされても、回収する札が半分になる",
        uses: -1 },
      mary: { name: "メアリー", color: "#c77dd8", doubt: 0.16, tell: 0.4, bluff: 0.1,
        ability: "対戦が始まった時点の、自分以外の手札を覚えている（その後の出入りまでは分からない）",
        uses: -1, sub: "mary_deal", subUses: 1 },
      reido: { name: "零度警部", color: "#6fa8c9", doubt: 0.16, tell: 0.35, bluff: 0.1,
        ability: "手札を3枚渡す代わりに、伏せ札を強制的に暴く。外れても札を引き取らない",
        uses: 1 },
      juri: { name: "珠璃", color: "#e8b54a", doubt: 0.1, tell: 0.25, bluff: 0.12,
        ability: "一度手にした札は、場に出た後も把握し続ける",
        uses: -1 },
      eruku: { name: "叡留久", color: "#3fae7a", doubt: 0.1, tell: 0.25, bluff: 0.15,
        ability: "相手と自分の手札を丸ごと入れ替える",
        uses: 1, sub: "eruku_deal", subUses: 1 },
      jushika: { name: "朱志香", color: "#b0413e", doubt: 0.08, tell: 0.2, bluff: 0.15,
        ability: "自分か小出里亜がダウトを外すと、しばらく二人の手札の枚数がでたらめになり、伏せた枚数も分からなくなる",
        uses: -1 },
      koderia: { name: "小出里亜", color: "#9fb0d4", doubt: 0.08, tell: 0.18, bluff: 0.15,
        ability: "成立するはずのダウトを無効にする",
        uses: 2 },
      mahoru_awake: { name: "真歩流？", color: "#7a3fd8", doubt: 0.3, tell: 0.3, bluff: 0.1,
        ability: "……ものすごく強い。嘘を見抜き、伏せ札の数字を名指ししてくる。そのうえ、誰かの力を借りている",
        uses: 2, catchRate: 0.55, guessRate: 0.7 },
      maicro: { name: "舞黒邦夢", color: "#c08a1e", doubt: 0.25, tell: 0.15, bluff: 0.15,
        doubtStyle: "enjoy", // エンジョイ型：根拠が薄い時ほど遊びで踏み込み、枚数が多いほど疑いやすい
        ability: "館主のもてなし。場がかき乱される（ときどき味方の足を引っぱる）",
        uses: -1 },

      /*
       * 隠しボスの二人。名前は出さず、呼び名だけで通す。
       * sub / subUses は「二つ目の能力」。sub には chara のidを書く。
       */
      yuduki: { name: "快活な少女", color: "#e86a9a", doubt: 0.32, tell: 0.12, bluff: 0.22,
        ability: "勘で嘘を見抜く。さらに一巡のあいだ、あなたにダウトを言わせない",
        uses: 2, sub: "free_doubt", subUses: 3,
        // 真歩流？と違って粗い勘。本当の札にも踏み込むので、空振りの方で釣り合う
        catchRate: 0.4, falseRate: 0.05 },
      arther: { name: "英国の青年", color: "#5f8fd0", doubt: 0.28, tell: 0.08, bluff: 0.2,
        ability: "取引。同じ数字の札をまとめて渡し、代わりに好きな札を同じ枚数もらう",
        uses: 2, sub: "arther_deck", subUses: 1 },
      /*
       * 二つ目の能力そのもの。卓には座らないので、名前と説明だけの見出し用。
       * 回数は sub を持つ側の subUses で数えるので、ここの uses は表示のためだけ。
       */
      hand_swap: { name: "手札の交換", color: "#d8352a", doubt: 0, tell: 0, bluff: 0,
        ability: "自分の手番に、好きな枚数を選んで相手の同じ枚数と交換する（相手にその枚数が必要）",
        uses: 2 },
      mary_deal: { name: "香りの招待", color: "#c77dd8", doubt: 0, tell: 0, bluff: 0,
        ability: "一度だけ、新しい札を6枚入れて、自分以外の二人に3枚ずつ配る",
        uses: 1 },
      eruku_deal: { name: "危ない取引", color: "#3fae7a", doubt: 0, tell: 0, bluff: 0,
        ability: "一度だけ、場の伏せ札の半分を引き取る代わりに、三巡のあいだダウトされない",
        uses: 1 },
      free_doubt: { name: "空振りを恐れない", color: "#e86a9a", doubt: 0, tell: 0, bluff: 0,
        ability: "ダウトを外しても、場の札を引き取らない（外した時だけ消費する）",
        uses: 3 },
      arther_deck: { name: "もう一組の札", color: "#5f8fd0", doubt: 0, tell: 0, bluff: 0,
        ability: "一度だけ、もう一組の札から6枚を引き、自分以外の二人に3枚ずつ配る（同じ数字が最大8枚になる）",
        uses: 1 },
    },

    /*
     * 真歩流？が対戦開始時に1つ借りる能力。
     * 真歩流（プレイヤー自身）・舞黒邦夢（相方）・叡留久は入れない。
     * ここから外すだけで抽選から消えるので、強すぎる・弱すぎる時はこの並びを削る。
     */
    awakePool: ["airi", "kazuto", "mary", "reido", "juri", "jushika", "koderia"],

    pairs: [
      { a: "airi", b: "kazuto", label: "第一戦", tagline: "愛と薬だけが友達" },
      { a: "mary", b: "reido", label: "第二戦", tagline: "狂気の香りと下戸" },
      { a: "juri", b: "eruku", label: "第三戦", tagline: "ハイスペック夫婦" },
      { a: "jushika", b: "koderia", label: "第四戦", tagline: "最強館主と闇のメイド" },
      { a: "mahoru_awake", b: "maicro", label: "最終戦", tagline: "ダーク真歩流と舞黒邦夢" },
      { a: "yuduki", b: "arther", label: "隠し戦", tagline: "招かれざる二人" },
    ],
    playerTagline: "嘘を全て打ち砕く",

    /*
     * 掛け合いセリフ（仮）
     * place_calm    : 札を伏せた時（平静）
     * place_shaken  : 札を伏せた時（動揺）
     * place_hidden  : 札を伏せた時（読めない）
     * caught        : 嘘がばれて札を回収した時
     * safe          : ダウトされたが本当だった時
     * partner       : 相方が札を回収した時
     * doubt         : ダウトを宣言した時
     * doubt_miss    : ダウトが外れて札を回収した時
     * ability       : スキルを発動した時（カットインと一緒に出る）
     */
    lines: {
      // 主人公。ふだんは黙っているが、ダウトとスキルの時だけ声を出す
      //   doubt   : ダウトを宣言した時
      //   ability : スキル（名指し推理）を発動した時
      mahoru: {
        doubt: ["ダウト！", "その嘘、見えてる。", "そこまでだよ。"],
        ability: ["その数字、言い当てる。", "……もう、読めた。", "この手札、交換してもらうわ。"],
      },
      airi: {
        place_calm: ["はい、どうぞ♪", "ちゃんと本当だよ？"],
        place_shaken: ["え、えっと……本当だよ？", "そ、そんなに見ないで……"],
        caught: ["うそぉ、なんで分かったの！？"],
        safe: ["ほらね、本当だったでしょ♪"],
        partner: ["和人さん、しっかりー！"],
        doubt: ["読めたよ、それダウト！"],
        doubt_miss: ["あれぇ……本当だった……"],
        ability: ["同じ絵柄なら、おんなじ数字だよ！", "残念、嘘じゃないもん！"],
      },
      kazuto: {
        place_calm: ["……問題ない。", "次。"],
        place_shaken: ["……ちょっと待て、脈が……いや、なんでもない。"],
        caught: ["想定内の損失だ。"],
        safe: ["診断ミスだな。"],
        partner: ["愛理、顔に出すぎだ。"],
        doubt: ["その札、ダウトだ。"],
        doubt_miss: ["……誤診か。"],
        ability: ["処置は済んでいる。", "半分だけ引き取る。", "出血は止めてある。", "この程度、後遺症も残らん。"],
      },
      mary: {
        place_calm: ["ふふ、いい香りでしょう？", "どうぞ、召し上がれ。"],
        place_shaken: ["あら……少し香りが強すぎたかしら。"],
        caught: ["まあ、野暮な人。"],
        safe: ["嘘の香りはしなかったでしょう？"],
        partner: ["警部さん、らしくないですね。"],
        doubt: ["その香り、ダウトですよ。"],
        doubt_miss: ["あら、外れですか。"],
        ability: ["最初の香り、覚えているのよ。", "ふふ、あなたの手も匂うわ。", "新しいお客様を、お招きするわ。"],
      },
      reido: {
        place_calm: ["異常なし。", "次です。"],
        place_shaken: ["……咳払いです。気にしないでください。"],
        caught: ["証拠は押さえられたか。"],
        safe: ["冤罪案件です。"],
        partner: ["メアリーさん、事情聴取の時間です。"],
        doubt: ["ダウト。署まで来てもらおう。"],
        doubt_miss: ["……捜査のやり直しだ。"],
        ability: ["令状だ。その札、検めさせてもらう。", "強制捜査に切り替える。"],
      },
      juri: {
        place_calm: ["全部、把握してるから。", "はい、次。"],
        place_shaken: ["……今の、撮ってないわよね？"],
        caught: ["この件、拡散しないでね。"],
        safe: ["ほら、ちゃんと事実でしょ。"],
        partner: ["叡留久、それは損切りしたほうがいいわよ。"],
        doubt: ["その札、覚えてる。ダウト。"],
        doubt_miss: ["あら、……記録と違う。"],
        ability: ["その札、記録済みだから。", "一度見たものは、忘れないの。"],
      },
      eruku: {
        place_calm: ["いい取引だ。", "投資は分散が基本だよ。"],
        place_shaken: ["……今のは、少々リスキーだったかな。"],
        caught: ["損失は計上しておこう。"],
        safe: ["監査は通ったね。"],
        partner: ["珠璃、ここからリカバリーしよう。"],
        doubt: ["その数字、粉飾だね。ダウト。"],
        doubt_miss: ["見込み違いか。"],
        ability: ["資産を、丸ごと入れ替えよう。", "これも分散投資のうちだよ。", "少々の負債は、安全料さ。"],
      },
      jushika: {
        place_calm: ["……どうぞ。", "さあ、ここからですよ。"],
        place_shaken: ["……っ。なんでもありません。"],
        place_hidden: ["手の内は隠させていただきます。"],
        caught: ["……不覚ですね。"],
        safe: ["……残念ながら、真実です。"],
        partner: ["小出里亜さん……まだ、いけますよね！"],
        doubt: ["……ダウト、です。"],
        doubt_miss: ["……申し訳ありません。"],
        ability: ["……数えるのは、おやめください。", "……もう、見えません。"],
      },
      koderia: {
        place_calm: ["はい、どうぞ。", "ふふ、次は真歩流様の番ですね。"],
        place_shaken: ["あら……困りましたね。"],
        caught: ["見抜かれてしまいましたね。"],
        safe: ["疑うのは悲しいですよ。"],
        partner: ["朱志香さま、大丈夫ですよ。"],
        doubt: ["それは、ダウトですね。"],
        doubt_miss: ["あら、ごめんなさい。"],
        ability: ["そのダウトは、なかったことに。", "ふふ、通しませんよ。"],
      },
      mahoru_awake: {
        place_calm: ["……。", "見えてるよ、全部。"],
        place_shaken: ["……。"],
        caught: ["……へえ。"],
        safe: ["言ったでしょう。"],
        partner: ["……。"],
        doubt: ["それ、嘘。"],
        doubt_miss: ["……今のはわざと。"],
        ability: ["……遊びは、ここまで。", "その手は、通らないよ。"],
      },
      yuduki: {
        place_calm: ["はい、どうぞ！", "さあ、どんどん行くわよ。"],
        place_shaken: ["……ん、まあいいか。"],
        caught: ["あー、やられた！"],
        safe: ["残念、本当だもん。"],
        partner: ["ほら、しっかりしてよ。"],
        doubt: ["それ、嘘でしょ！"],
        doubt_miss: ["えっ、本当だったの！？"],
        ability: ["はい、ちょっと黙っててね！", "この一巡、あなたは何も言えないよ！", "外しても痛くないもん！"],
      },
      arther: {
        place_calm: ["どうぞ、ご確認を。", "紳士は嘘をつかないものさ。……たまには。"],
        place_shaken: ["ふむ、これは失礼。"],
        caught: ["これは参ったな。"],
        safe: ["申し上げたとおりだよ。"],
        partner: ["ははは、彼女は元気が良すぎる。"],
        doubt: ["それは通らないな。"],
        doubt_miss: ["……見立てを誤ったか。"],
        ability: ["さて、取引をしよう。", "悪い話ではないだろう？", "これがきっかけになるといいが。"],
      },
      maicro: {
        place_calm: ["さあさあ、遠慮なく。", "今宵のもてなしはまだまだ！"],
        place_shaken: ["おっと、手が滑った。"],
        caught: ["はっはっは、見事！"],
        safe: ["館主は嘘をつかんよ。"],
        partner: ["もう一人の君、楽しんでいるかね？"],
        doubt: ["おや、それはダウトだ！"],
        doubt_miss: ["これは失敬！"],
        ability: ["さあ、館主のもてなしだ！", "余興の時間といこうか！", "はっはっは、席を乱させてもらう！", "退屈しのぎに、一手加えよう！"],
      },
    },
  };

  root.DOUBT_DATA = DATA;
  if (typeof module !== "undefined") module.exports = DATA;
})(typeof window !== "undefined" ? window : globalThis);
