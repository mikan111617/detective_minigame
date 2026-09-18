/*
 * ダウト ミニゲーム データ定義
 * キャラクター・ペア・画像パス・掛け合いセリフ（セリフはすべて仮）
 */
(function (root) {
  var IMG = "./data/image/doubt/";
  // 立ち絵の場所。本編の立ち絵をそのまま使う場合は "./data/fgimage/standing/"
  var STAND = "./data/fgimage/standing/";

  var DATA = {
    img: {
      bgTitle: IMG + "bg/bg-title.png",
      bgSelect: IMG + "bg/bg-select.png",
      bgTable: IMG + "bg/bg-table.png",
      bgWin: IMG + "bg/win-01.png",
      bgContinue: IMG + "bg/continue.png",
      bgGameover: IMG + "bg/gameover.png",
      cardBack: IMG + "card/card-back.png",
      // 立ち絵：chara/{id}.png　表情差分：chara/{id}_shaken.png（無ければ通常立ち絵）
      chara: function (id, face) {
        var base = DATA.charaFile[id] || id;
        return STAND + base + (face ? "_" + face : "") + ".png";
      },
      // カットイン：cutin/{id}.png（無ければ文字だけのカットイン）
      cutin: function (id) {
        return IMG + "cutin/" + id + ".png";
      },
    },

    // 立ち絵のファイル名が id と違う場合の対応表
    charaFile: { mahoru_awake: "mahoru" },

    rules: {
      scorePerCard: 100,
      lifeEvery: 10000,
      baseContinue: 1,
      maxPlay: 4,
      jokers: 2, // 舞黒邦夢が山札から出すジョーカーの枚数
      kunimuQuiet: 5, // 誰かの手札がこの枚数以下の間は、舞黒邦夢のもてなしが起きない
      safetyLimit: 240, // この手数に達したら時間切れ（手札が最も少ない者の勝ち）
      mateDoubt: 0.4, // 相方同士で疑い合う強さ（通常の疑い確率に掛ける）
    },

    /*
     * doubt : 相手の宣言を疑う基本確率
     * tell  : 嘘をついた時に動揺が顔に出る確率（本当の時は tell×0.3）
     * bluff : 本当の札に余計な1枚を混ぜる確率
     */
    chara: {
      mahoru: { name: "真歩流", color: "#d8352a", doubt: 0, tell: 0, bluff: 0,
        ability: "ダウトの時に相手の出した数字を言い当てると、自分の手札から好きな2枚を相手に渡せる（1ゲーム2回まで）",
        uses: 2 },
      airi: { name: "愛理", color: "#f5a3b8", doubt: 0.3, tell: 0.6, bluff: 0.05,
        ability: "同じ数字が重なった分の札を、真歩流の手札と交換する",
        uses: 2 },
      kazuto: { name: "和人", color: "#4f7fd8", doubt: 0.28, tell: 0.5, bluff: 0.05,
        ability: "ダウトされても、回収する札が半分になる",
        uses: -1 },
      mary: { name: "メアリー", color: "#c77dd8", doubt: 0.16, tell: 0.4, bluff: 0.1,
        ability: "序盤は手札が全部見えている。手番ごとに1枚ずつ見えなくなる",
        uses: -1 },
      reido: { name: "零度警部", color: "#6fa8c9", doubt: 0.16, tell: 0.35, bluff: 0.1,
        ability: "手札を3枚渡す代わりに、伏せ札を強制的に暴く。外れても札を引き取らない",
        uses: 1 },
      juri: { name: "珠璃", color: "#e8b54a", doubt: 0.1, tell: 0.25, bluff: 0.12,
        ability: "一度手にした札は、場に出た後も把握し続ける",
        uses: -1 },
      eruku: { name: "叡留久", color: "#3fae7a", doubt: 0.1, tell: 0.25, bluff: 0.15,
        ability: "相手と自分の手札を丸ごと入れ替える",
        uses: 1 },
      jushika: { name: "朱志香", color: "#b0413e", doubt: 0.08, tell: 0.2, bluff: 0.15,
        ability: "小出里亜が追い詰められ、しばらく朱志香が読めなくなる",
        uses: -1 },
      koderia: { name: "小出里亜", color: "#9fb0d4", doubt: 0.08, tell: 0.18, bluff: 0.15,
        ability: "成立するはずのダウトを無効にする",
        uses: 1 },
      mahoru_awake: { name: "真歩流？", color: "#7a3fd8", doubt: 0.3, tell: 0.3, bluff: 0.1,
        ability: "……ものすごく強い",
        uses: -1, catchRate: 0.55 },
      kunimu: { name: "舞黒邦夢", color: "#c08a1e", doubt: 0.25, tell: 0.15, bluff: 0.15,
        ability: "館主のもてなし。場がかき乱される（ときどき味方の足を引っぱる）",
        uses: -1 },
    },

    pairs: [
      { a: "airi", b: "kazuto", label: "第一戦", tagline: "愛と薬だけが友達" },
      { a: "mary", b: "reido", label: "第二戦", tagline: "" },
      { a: "juri", b: "eruku", label: "第三戦", tagline: "" },
      { a: "jushika", b: "koderia", label: "第四戦", tagline: "" },
      { a: "mahoru_awake", b: "kunimu", label: "最終戦", tagline: "" },
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
     */
    lines: {
      airi: {
        place_calm: ["はい、どうぞ♪", "ちゃんと本当だよ？"],
        place_shaken: ["え、えっと……本当だよ？", "そ、そんなに見ないで……"],
        caught: ["うそぉ、なんで分かったの！？"],
        safe: ["ほらね、本当だったでしょ♪"],
        partner: ["和人くん、しっかりー！"],
        doubt: ["お姉ちゃん、それダウト！"],
        doubt_miss: ["あれぇ……本当だった……"],
      },
      kazuto: {
        place_calm: ["……問題ない。", "次。"],
        place_shaken: ["……ちょっと待て、脈が……いや、なんでもない。"],
        caught: ["想定内の損失だ。"],
        safe: ["診断ミスだな。"],
        partner: ["愛理、顔に出すぎだ。"],
        doubt: ["その札、ダウトだ。"],
        doubt_miss: ["……誤診か。"],
      },
      mary: {
        place_calm: ["ふふ、いい香りでしょう？", "どうぞ、召し上がれ。"],
        place_shaken: ["あら……少し香りが強すぎたかしら。"],
        caught: ["まあ、野暮な人。"],
        safe: ["嘘の香りはしなかったでしょう？"],
        partner: ["警部さん、らしくないわね。"],
        doubt: ["その香り、ダウトよ。"],
        doubt_miss: ["あら、外れ。"],
      },
      reido: {
        place_calm: ["異常なし。", "次だ。"],
        place_shaken: ["……咳払いだ。気にするな。"],
        caught: ["証拠は押さえられたか。"],
        safe: ["冤罪だな。"],
        partner: ["メアリー、事情聴取だ。"],
        doubt: ["ダウト。署まで来てもらおう。"],
        doubt_miss: ["……捜査のやり直しだ。"],
      },
      juri: {
        place_calm: ["全部、把握してるから。", "はい、次。"],
        place_shaken: ["……今の、撮ってないよね？"],
        caught: ["この件、拡散しないでね。"],
        safe: ["ほら、ちゃんと事実でしょ。"],
        partner: ["叡留久さん、それは損切りしなよ。"],
        doubt: ["その札、覚えてる。ダウト。"],
        doubt_miss: ["……記録と違う。"],
      },
      eruku: {
        place_calm: ["いい取引だ。", "投資は分散が基本だよ。"],
        place_shaken: ["……今のは、少々リスキーだったかな。"],
        caught: ["損失は計上しておこう。"],
        safe: ["監査は通ったね。"],
        partner: ["珠璃さん、リカバリーしよう。"],
        doubt: ["その数字、粉飾だね。ダウト。"],
        doubt_miss: ["見込み違いか。"],
      },
      jushika: {
        place_calm: ["……どうぞ。", "……。"],
        place_shaken: ["……っ。なんでもありません。"],
        place_hidden: ["…………。"],
        caught: ["……不覚です。"],
        safe: ["……本当です。"],
        partner: ["小出里亜さん……！"],
        doubt: ["……ダウト、です。"],
        doubt_miss: ["……申し訳ありません。"],
      },
      koderia: {
        place_calm: ["はい、どうぞ。", "ふふ、次はあなたの番ですね。"],
        place_shaken: ["あら……困りましたね。"],
        caught: ["見抜かれてしまいましたね。"],
        safe: ["疑うのは悲しいですよ。"],
        partner: ["朱志香さん、大丈夫ですよ。"],
        doubt: ["それは、ダウトですね。"],
        doubt_miss: ["あら、ごめんなさい。"],
      },
      mahoru_awake: {
        place_calm: ["……。", "見えてるよ、全部。"],
        place_shaken: ["……。"],
        caught: ["……へえ。"],
        safe: ["言ったでしょう。"],
        partner: ["……。"],
        doubt: ["それ、嘘。"],
        doubt_miss: ["……今のはわざと。"],
      },
      kunimu: {
        place_calm: ["さあさあ、遠慮なく。", "今宵のもてなしはまだまだ！"],
        place_shaken: ["おっと、手が滑った。"],
        caught: ["はっはっは、見事！"],
        safe: ["館主は嘘をつかんよ。"],
        partner: ["もう一人の君、楽しんでいるかね？"],
        doubt: ["おや、それはダウトだ！"],
        doubt_miss: ["これは失敬！"],
      },
    },
  };

  root.DOUBT_DATA = DATA;
  if (typeof module !== "undefined") module.exports = DATA;
})(typeof window !== "undefined" ? window : globalThis);
