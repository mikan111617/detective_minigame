# ボイス素材の置き場所

doubt_data.js の lines に書いたセリフと、1対1で対応している。
置き場所は data/voice/{キャラid}/{セリフの種類}_{番号}.wav。
番号は lines の配列の並び順（0 から数える）。1つしか無いセリフでも _0 を付ける。

ability はスキル発動時のセリフ。カットインと一緒に出る。

ファイルが無いセリフは何も鳴らさずそのまま進むので、
録れたものから順に置いていけば、その分だけ喋るようになる。

拡張子を変える時は doubt_data.js の voice.ext を直すこと。
セリフを増やしたり並べ替えたりすると番号がずれるので、
doubt_data.js を触った時はこの表を作り直すこと。

収録済み 135 / 162 ファイル

| 済 | ファイル | キャラ | セリフ |
| --- | --- | --- | --- |
| ○ | `mahoru/doubt_0.wav` | 真歩流 | ダウト！ |
| ○ | `mahoru/doubt_1.wav` | 真歩流 | その嘘、見えてる。 |
| ○ | `mahoru/doubt_2.wav` | 真歩流 | そこまでだよ。 |
| ○ | `mahoru/ability_0.wav` | 真歩流 | その数字、言い当てる。 |
| ○ | `mahoru/ability_1.wav` | 真歩流 | ……もう、読めた。 |
| ○ | `mahoru/ability_2.wav` | 真歩流 | この手札、交換してもらうわ。 |
|   | `mahoru/taunt_0.wav` | 真歩流 | さあ、正々堂々と勝負しましょう！ |
|   | `mahoru/taunt_1.wav` | 真歩流 | ふふ、見破れるかな？私の手を！ |
| ○ | `airi/place_calm_0.wav` | 愛理 | はい、どうぞ♪ |
| ○ | `airi/place_calm_1.wav` | 愛理 | ちゃんと本当だよ？ |
| ○ | `airi/place_shaken_0.wav` | 愛理 | え、えっと……本当だよ？ |
| ○ | `airi/place_shaken_1.wav` | 愛理 | そ、そんなに見ないで…… |
| ○ | `airi/caught_0.wav` | 愛理 | うそぉ、なんで分かったの！？ |
| ○ | `airi/safe_0.wav` | 愛理 | ほらね、本当だったでしょ♪ |
| ○ | `airi/partner_0.wav` | 愛理 | 和人さん、しっかりー！ |
| ○ | `airi/doubt_0.wav` | 愛理 | 読めたよ、それダウト！ |
| ○ | `airi/doubt_miss_0.wav` | 愛理 | あれぇ……本当だった…… |
| ○ | `airi/ability_0.wav` | 愛理 | 同じ絵柄なら、おんなじ数字だよ！ |
| ○ | `airi/ability_1.wav` | 愛理 | 残念、嘘じゃないもん！ |
|   | `airi/taunt_0.wav` | 愛理 | お姉ちゃんの挑発になんて乗らないよー。 |
|   | `airi/taunt_1.wav` | 愛理 | うう、あからさまだけど、気になる……。 |
| ○ | `kazuto/place_calm_0.wav` | 和人 | ……問題ない。 |
| ○ | `kazuto/place_calm_1.wav` | 和人 | 次。 |
| ○ | `kazuto/place_shaken_0.wav` | 和人 | ……ちょっと待て、脈が……いや、なんでもない。 |
| ○ | `kazuto/caught_0.wav` | 和人 | 想定内の損失だ。 |
| ○ | `kazuto/safe_0.wav` | 和人 | 診断ミスだな。 |
| ○ | `kazuto/partner_0.wav` | 和人 | 愛理、顔に出すぎだ。 |
| ○ | `kazuto/doubt_0.wav` | 和人 | その札、ダウトだ。 |
| ○ | `kazuto/doubt_miss_0.wav` | 和人 | ……誤診か。 |
| ○ | `kazuto/ability_0.wav` | 和人 | 処置は済んでいる。 |
| ○ | `kazuto/ability_1.wav` | 和人 | 半分だけ引き取る。 |
| ○ | `kazuto/ability_2.wav` | 和人 | 出血は止めてある。 |
| ○ | `kazuto/ability_3.wav` | 和人 | この程度、後遺症も残らん。 |
|   | `kazuto/taunt_0.wav` | 和人 | 相変わらず馬鹿丸出しだな。 |
|   | `kazuto/taunt_1.wav` | 和人 | 挑発なのか、本心なのか、相変わらず読めん。 |
| ○ | `mary/place_calm_0.wav` | メアリー | ふふ、いい香りでしょう？ |
| ○ | `mary/place_calm_1.wav` | メアリー | どうぞ、召し上がれ。 |
| ○ | `mary/place_shaken_0.wav` | メアリー | あら……少し香りが強すぎたかしら。 |
| ○ | `mary/caught_0.wav` | メアリー | まあ、野暮な人。 |
| ○ | `mary/safe_0.wav` | メアリー | 嘘の香りはしなかったでしょう？ |
| ○ | `mary/partner_0.wav` | メアリー | 警部さん、らしくないですね。 |
| ○ | `mary/doubt_0.wav` | メアリー | その香り、ダウトですよ。 |
| ○ | `mary/doubt_miss_0.wav` | メアリー | あら、外れですか。 |
| ○ | `mary/ability_0.wav` | メアリー | 最初の香り、覚えているのよ。 |
| ○ | `mary/ability_1.wav` | メアリー | ふふ、あなたの手も匂うわ。 |
| ○ | `mary/ability_2.wav` | メアリー | 新しいお客様を、お招きするわ。 |
|   | `mary/taunt_0.wav` | メアリー | あら、真歩流さん、勢いがありますね。 |
|   | `mary/taunt_1.wav` | メアリー | 人をだますなんて、悪いことなんですよ～。 |
| ○ | `reido/place_calm_0.wav` | 零度警部 | 異常なし。 |
| ○ | `reido/place_calm_1.wav` | 零度警部 | 次です。 |
| ○ | `reido/place_shaken_0.wav` | 零度警部 | ……咳払いです。気にしないでください。 |
| ○ | `reido/caught_0.wav` | 零度警部 | 証拠は押さえられたか。 |
| ○ | `reido/safe_0.wav` | 零度警部 | 冤罪案件です。 |
| ○ | `reido/partner_0.wav` | 零度警部 | メアリーさん、事情聴取の時間です。 |
| ○ | `reido/doubt_0.wav` | 零度警部 | ダウト。署まで来てもらおう。 |
| ○ | `reido/doubt_miss_0.wav` | 零度警部 | ……捜査のやり直しだ。 |
| ○ | `reido/ability_0.wav` | 零度警部 | 令状だ。その札、検めさせてもらう。 |
| ○ | `reido/ability_1.wav` | 零度警部 | 強制捜査に切り替える。 |
|   | `reido/taunt_0.wav` | 零度警部 | 安い挑発に私は騙されません |
|   | `reido/taunt_1.wav` | 零度警部 | 警察の基本は物事を疑うものだが……。 |
| ○ | `juri/place_calm_0.wav` | 珠璃 | 全部、把握してるから。 |
| ○ | `juri/place_calm_1.wav` | 珠璃 | はい、次。 |
| ○ | `juri/place_shaken_0.wav` | 珠璃 | ……今の、撮ってないわよね？ |
| ○ | `juri/caught_0.wav` | 珠璃 | この件、拡散しないでね。 |
| ○ | `juri/safe_0.wav` | 珠璃 | ほら、ちゃんと事実でしょ。 |
| ○ | `juri/partner_0.wav` | 珠璃 | 叡留久、それは損切りしたほうがいいわよ。 |
| ○ | `juri/doubt_0.wav` | 珠璃 | その札、覚えてる。ダウト。 |
| ○ | `juri/doubt_miss_0.wav` | 珠璃 | あら、……記録と違う。 |
| ○ | `juri/ability_0.wav` | 珠璃 | その札、記録済みだから。 |
| ○ | `juri/ability_1.wav` | 珠璃 | 一度見たものは、忘れないの。 |
|   | `juri/taunt_0.wav` | 珠璃 | 私と心理戦をするなんて面白いわ |
|   | `juri/taunt_1.wav` | 珠璃 | ふふふ、全部読めているわよ真歩流さん |
| ○ | `eruku/place_calm_0.wav` | 叡留久 | いい取引だ。 |
| ○ | `eruku/place_calm_1.wav` | 叡留久 | 投資は分散が基本だよ。 |
| ○ | `eruku/place_shaken_0.wav` | 叡留久 | ……今のは、少々リスキーだったかな。 |
| ○ | `eruku/caught_0.wav` | 叡留久 | 損失は計上しておこう。 |
| ○ | `eruku/safe_0.wav` | 叡留久 | 監査は通ったね。 |
| ○ | `eruku/partner_0.wav` | 叡留久 | 珠璃、ここからリカバリーしよう。 |
| ○ | `eruku/doubt_0.wav` | 叡留久 | その数字、粉飾だね。ダウト。 |
| ○ | `eruku/doubt_miss_0.wav` | 叡留久 | 見込み違いか。 |
| ○ | `eruku/ability_0.wav` | 叡留久 | 資産を、丸ごと入れ替えよう。 |
| ○ | `eruku/ability_1.wav` | 叡留久 | これも分散投資のうちだよ。 |
| ○ | `eruku/ability_2.wav` | 叡留久 | 少々の負債は、安全料さ。 |
|   | `eruku/taunt_0.wav` | 叡留久 | 探偵らしく揺さぶりにきたねえ。 |
|   | `eruku/taunt_1.wav` | 叡留久 | さて、この挑発は乗るべきか、それとも……。 |
| ○ | `jushika/place_calm_0.wav` | 朱志香 | ……どうぞ。 |
| ○ | `jushika/place_calm_1.wav` | 朱志香 | さあ、ここからですよ。 |
| ○ | `jushika/place_shaken_0.wav` | 朱志香 | ……っ。なんでもありません。 |
| ○ | `jushika/place_hidden_0.wav` | 朱志香 | 手の内は隠させていただきます。 |
| ○ | `jushika/caught_0.wav` | 朱志香 | ……不覚ですね。 |
| ○ | `jushika/safe_0.wav` | 朱志香 | ……残念ながら、真実です。 |
| ○ | `jushika/partner_0.wav` | 朱志香 | 小出里亜さん……まだ、いけますよね！ |
| ○ | `jushika/doubt_0.wav` | 朱志香 | ……ダウト、です。 |
| ○ | `jushika/doubt_miss_0.wav` | 朱志香 | ……申し訳ありません。 |
| ○ | `jushika/ability_0.wav` | 朱志香 | ……数えるのは、おやめください。 |
| ○ | `jushika/ability_1.wav` | 朱志香 | ……もう、見えません。 |
|   | `jushika/taunt_0.wav` | 朱志香 | 真歩流さんは顔を見ればわかりますから |
|   | `jushika/taunt_1.wav` | 朱志香 | 余程良い手があるんですね、さてどうしましょう。 |
| ○ | `koderia/place_calm_0.wav` | 小出里亜 | はい、どうぞ。 |
| ○ | `koderia/place_calm_1.wav` | 小出里亜 | ふふ、次は真歩流様の番ですね。 |
| ○ | `koderia/place_shaken_0.wav` | 小出里亜 | あら……困りましたね。 |
| ○ | `koderia/caught_0.wav` | 小出里亜 | 見抜かれてしまいましたね。 |
| ○ | `koderia/safe_0.wav` | 小出里亜 | 疑うのは悲しいですよ。 |
| ○ | `koderia/partner_0.wav` | 小出里亜 | 朱志香さま、大丈夫ですよ。 |
| ○ | `koderia/doubt_0.wav` | 小出里亜 | それは、ダウトですね。 |
| ○ | `koderia/doubt_miss_0.wav` | 小出里亜 | あら、ごめんなさい。 |
| ○ | `koderia/ability_0.wav` | 小出里亜 | そのダウトは、なかったことに。 |
| ○ | `koderia/ability_1.wav` | 小出里亜 | ふふ、通しませんよ。 |
|   | `koderia/taunt_0.wav` | 小出里亜 | あら～、真歩流様、私を誘ってどうするんですか～？ |
|   | `koderia/taunt_1.wav` | 小出里亜 | 私の視線をくぎ付けにしたいんですね、もう、愛らしいです。 |
| ○ | `mahoru_awake/place_calm_0.wav` | 真歩流？ | ……。 |
| ○ | `mahoru_awake/place_calm_1.wav` | 真歩流？ | 見えてるよ、全部。 |
| ○ | `mahoru_awake/place_shaken_0.wav` | 真歩流？ | ……。 |
| ○ | `mahoru_awake/caught_0.wav` | 真歩流？ | ……へえ。 |
| ○ | `mahoru_awake/safe_0.wav` | 真歩流？ | 言ったでしょう。 |
|   | `mahoru_awake/partner_0.wav` | 真歩流？ | ……。 |
| ○ | `mahoru_awake/doubt_0.wav` | 真歩流？ | それ、嘘。 |
| ○ | `mahoru_awake/doubt_miss_0.wav` | 真歩流？ | ……今のはわざと。 |
| ○ | `mahoru_awake/ability_0.wav` | 真歩流？ | ……遊びは、ここまで。 |
| ○ | `mahoru_awake/ability_1.wav` | 真歩流？ | その手は、通らないよ。 |
|   | `mahoru_awake/taunt_0.wav` | 真歩流？ | そんな挑発には乗らないよ |
|   | `mahoru_awake/taunt_1.wav` | 真歩流？ | 考えなしで言われると、読めなくなるわ |
| ○ | `yuduki/place_calm_0.wav` | 快活な少女 | はい、どうぞ！ |
| ○ | `yuduki/place_calm_1.wav` | 快活な少女 | さあ、どんどん行くわよ。 |
| ○ | `yuduki/place_shaken_0.wav` | 快活な少女 | ……ん、まあいいか。 |
| ○ | `yuduki/caught_0.wav` | 快活な少女 | あー、やられた！ |
| ○ | `yuduki/safe_0.wav` | 快活な少女 | 残念、本当だもん。 |
| ○ | `yuduki/partner_0.wav` | 快活な少女 | ほら、しっかりしてよ。 |
| ○ | `yuduki/doubt_0.wav` | 快活な少女 | それ、嘘でしょ！ |
| ○ | `yuduki/doubt_miss_0.wav` | 快活な少女 | えっ、本当だったの！？ |
| ○ | `yuduki/ability_0.wav` | 快活な少女 | はい、ちょっと黙っててね！ |
| ○ | `yuduki/ability_1.wav` | 快活な少女 | この一巡、あなたは何も言えないよ！ |
| ○ | `yuduki/ability_2.wav` | 快活な少女 | 外しても痛くないもん！ |
|   | `yuduki/taunt_0.wav` | 快活な少女 | いいわね！私も真っすぐ勝負が大好きよ！ |
|   | `yuduki/taunt_1.wav` | 快活な少女 | 売られた喧嘩は買うしかないわね！ |
| ○ | `arther/place_calm_0.wav` | 英国の青年 | どうぞ、ご確認を。 |
| ○ | `arther/place_calm_1.wav` | 英国の青年 | 紳士は嘘をつかないものさ。……たまには。 |
| ○ | `arther/place_shaken_0.wav` | 英国の青年 | ふむ、これは失礼。 |
| ○ | `arther/caught_0.wav` | 英国の青年 | これは参ったな。 |
| ○ | `arther/safe_0.wav` | 英国の青年 | 申し上げたとおりだよ。 |
| ○ | `arther/partner_0.wav` | 英国の青年 | ははは、彼女は元気が良すぎる。 |
| ○ | `arther/doubt_0.wav` | 英国の青年 | それは通らないな。 |
| ○ | `arther/doubt_miss_0.wav` | 英国の青年 | ……見立てを誤ったか。 |
| ○ | `arther/ability_0.wav` | 英国の青年 | さて、取引をしよう。 |
| ○ | `arther/ability_1.wav` | 英国の青年 | 悪い話ではないだろう？ |
| ○ | `arther/ability_2.wav` | 英国の青年 | これがきっかけになるといいが。 |
|   | `arther/taunt_0.wav` | 英国の青年 | 誘いをかけてくるとは、彼女に負けない度胸の持ち主だ |
|   | `arther/taunt_1.wav` | 英国の青年 | 参ったな交渉事は得意な方なんだけど。 |
| ○ | `maicro/place_calm_0.wav` | 舞黒邦夢 | さあさあ、遠慮なく。 |
| ○ | `maicro/place_calm_1.wav` | 舞黒邦夢 | 今宵のもてなしはまだまだ！ |
| ○ | `maicro/place_shaken_0.wav` | 舞黒邦夢 | おっと、手が滑った。 |
| ○ | `maicro/caught_0.wav` | 舞黒邦夢 | はっはっは、見事！ |
| ○ | `maicro/safe_0.wav` | 舞黒邦夢 | 館主は嘘をつかんよ。 |
| ○ | `maicro/partner_0.wav` | 舞黒邦夢 | もう一人の君、楽しんでいるかね？ |
| ○ | `maicro/doubt_0.wav` | 舞黒邦夢 | おや、それはダウトだ！ |
| ○ | `maicro/doubt_miss_0.wav` | 舞黒邦夢 | これは失敬！ |
| ○ | `maicro/ability_0.wav` | 舞黒邦夢 | さあ、館主のもてなしだ！ |
| ○ | `maicro/ability_1.wav` | 舞黒邦夢 | 余興の時間といこうか！ |
| ○ | `maicro/ability_2.wav` | 舞黒邦夢 | はっはっは、席を乱させてもらう！ |
| ○ | `maicro/ability_3.wav` | 舞黒邦夢 | 退屈しのぎに、一手加えよう！ |
|   | `maicro/taunt_0.wav` | 舞黒邦夢 | ははは、勝負に出たな！ |
|   | `maicro/taunt_1.wav` | 舞黒邦夢 | 面白いなあ、なら私はこうしよう。 |
