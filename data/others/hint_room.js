/* 舞黒相談所：固定メニューから選んだ後だけ、会話演出が低確率で変化する。 */
(function(){
  "use strict";

  var kag=(window.TYRANO&&window.TYRANO.kag)?window.TYRANO.kag:tyrano.plugin.kag;

  function esc(v){
    return String(v==null?"":v)
      .replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")
      .replace(/"/g,"&quot;").replace(/'/g,"&#39;");
  }
  function line(who,text,kana,face){
    return {who:who,text:text,kana:kana||text,face:who==="真歩流"?(face||"normal"):"normal"};
  }

  var topics={
    ending:{
      label:"まだ見ぬ結末について", tag:"ANOTHER END",
      lines:[
        line("真歩流","犯人を見つけたのに、まだ見ていない結末があるみたいなんです。","はんにんを みつけたのに、まだ みていない けつまつが あるみたいなんです。","light_thinking"),
        line("舞黒","人の事件が片づいても、館まで素直に口を開くとは限らないよ。","ひとの じけんが かたづいても、やかたまで すなおに くちを ひらくとは かぎらないよ。"),
        line("真歩流","館にも事情聴取が必要なんですか？","やかたにも じじょうちょうしゅが ひつようなんですか？","surprised"),
        line("舞黒","しかも黙秘が得意でね。事件の外に置かれたものを見直してごらん。","しかも もくひが とくいでね。じけんの そとに おかれたものを みなおしてごらん。"),
        line("舞黒","別の結末を望むなら、最後の推理より、事件が起きる前の歩き方を疑うべきだ。","べつの けつまつを のぞむなら、さいごの すいりより、じけんが おきる まえの あるきかたを うたがうべきだ。"),
        line("真歩流","事件の前？　結末を分けるのは、最後の推理じゃないんですか。","じけんの まえ？ けつまつを わけるのは、さいごの すいりじゃ ないんですか。","surprised"),
        line("舞黒","夜に必要な問いは、明るいうちでなければ育たないものさ。","よるに ひつような といは、あかるいうちでなければ そだたないものさ。"),
        line("真歩流","夜になってから帳尻を合わせようとしても遅い？","よるに なってから ちょうじりを あわせようとしても おそい？","light_thinking"),
        line("舞黒","館の時計は案外せっかちでね。日が落ちるころには、開かなくなる扉もある。","やかたの とけいは あんがい せっかちでね。ひが おちる ころには、ひらかなくなる とびらも ある。"),
        line("真歩流","『日暮れまでに全部集めろ』ではないんですね。","『ひぐれまでに ぜんぶ あつめろ』では ないんですね。","normal"),
        line("舞黒","集めるのではなく、誰がなぜ来たのかを気にしておく。","あつめるのではなく、だれが なぜ きたのかを きにしておく。"),
        line("舞黒","そして、この館が見せる形と、隠したがる形の違いを覚えておく。","そして、この やかたが みせる かたちと、かくしたがる かたちの ちがいを おぼえておく。"),
        line("真歩流","人と建物、両方の事情を考える。","ひとと たてもの、りょうほうの じじょうを かんがえる。","light_thinking"),
        line("舞黒","そう。事件の証拠だけを追うと、事件の外にある扉を見失う。","そう。じけんの しょうこだけを おうと、じけんの そとに ある とびらを みうしなう。"),
        line("真歩流","苦い結末を見た後でも、やり直せますか？","にがい けつまつを みた あとでも、やりなおせますか？","light_thinking"),
        line("舞黒","もちろん。結末は行き止まりではなく、次に見る場所を照らす街灯だよ。","もちろん。けつまつは いきどまりではなく、つぎに みる ばしょを てらす がいとうだよ。"),
        line("真歩流","街灯にしては、だいぶ暗かったですけど。","がいとうにしては、だいぶ くらかったですけど。","aho"),
        line("舞黒","だから相談所を建てた。照明費は出ないがね。","だから そうだんじょを たてた。しょうめいひは でないがね。")
      ]
    },
    true_end:{
      label:"真エンディングへのぶっちゃけ話", tag:"TRUE END",
      lines:[
        line("真歩流","舞黒さん。今日は真エンディングへの行き方を、もう少しぶっちゃけてください。","まいくろさん。きょうは しんえんでぃんぐへの いきかたを、もうすこし ぶっちゃけてください。","light_thinking"),
        line("舞黒","名前からして、ずいぶん答えに近い相談だね。","なまえからして、ずいぶん こたえに ちかい そうだんだね。"),
        line("真歩流","答えそのものではなく、昼と夜に何を残せばいいかだけ。","こたえ そのものではなく、ひると よるに なにを のこせば いいかだけ。","normal"),
        line("舞黒","なら、昼は事件を追う時間ではない。館が隠している道具と入口を探す時間だ。","なら、ひるは じけんを おう じかんでは ない。やかたが かくしている どうぐと いりぐちを さがす じかんだ。"),
        line("真歩流","道具と入口？","どうぐと いりぐち？","surprised"),
        line("舞黒","談話室の古い声を聞き流さないこと。四つの数字は、もっと高い場所の陽だまりで役に立つ。","だんわしつの ふるい こえを ききながさないこと。よっつの すうじは、もっと たかい ばしょの ひだまりで やくに たつ。"),
        line("真歩流","数字で開くものの中に、館の形を知る手掛かりがある。","すうじで ひらくものの なかに、やかたの かたちを しる てがかりが ある。","light_thinking"),
        line("舞黒","もう一つ。館に散った三つの色は、重ねて初めて命令になる。読めたら、机は正面から眺めるものだという常識を捨てる。","もう ひとつ。やかたに ちった みっつの いろは、かさねて はじめて めいれいに なる。よめたら、つくえは しょうめんから ながめるものだという じょうしきを すてる。"),
        line("真歩流","上、横、それでもなければ……裏側。","うえ、よこ、それでも なければ……うらがわ。","light_thinking"),
        line("舞黒","その二つを手にしたら、古い模型と今の部屋の奥行きを比べる。合わない場所には理由がある。","その ふたつを てに したら、ふるい もけいと いまの へやの おくゆきを くらべる。あわない ばしょには りゆうが ある。"),
        line("真歩流","見つけるだけじゃなく、夕食前に中まで入っておく。","みつけるだけじゃなく、ゆうしょくまえに なかまで はいっておく。","light_thinking"),
        line("舞黒","そう。それが昼の宿題だ。ついでに、遠くから来た客が何を探しているのか聞ければ申し分ない。","そう。それが ひるの しゅくだいだ。ついでに、とおくから きた きゃくが なにを さがしているのか きければ もうしぶんない。"),
        line("真歩流","夜は？","よるは？","normal"),
        line("舞黒","夜は毒だけを追わないこと。昼に転んだ執務室の椅子を、ただの思い出で終わらせない。","よるは どくだけを おわないこと。ひるに ころんだ しつむしつの いすを、ただの おもいでで おわらせない。"),
        line("真歩流","椅子の周りに、昔の人たちを結ぶ記録が残っている。","いすの まわりに、むかしの ひとたちを むすぶ きろくが のこっている。","light_thinking"),
        line("舞黒","そして一階の陽だまりへ戻る。Aなら床の痕跡、Bなら植物の足元を調べた、その先だ。","そして いっかいの ひだまりへ もどる。えーなら ゆかの こんせき、びーなら しょくぶつの あしもとを しらべた、その さきだ。"),
        line("真歩流","毒の手掛かりを見つけて満足せず、床そのものをもう一度見る。","どくの てがかりを みつけて まんぞくせず、ゆか そのものを もういちど みる。","light_thinking"),
        line("舞黒","昼に地下書斎へ入っていれば、今度は別の入口が君に見つけられる。","ひるに ちかしょさいへ はいっていれば、こんどは べつの いりぐちが きみに みつけられる。"),
        line("真歩流","昼に館の道具と隠し部屋。夜に古い記録ともう一つの地下。客の目的も忘れない。","ひるに やかたの どうぐと かくしべや。よるに ふるい きろくと もう ひとつの ちか。きゃくの もくてきも わすれない。","normal"),
        line("舞黒","そこまで揃えて事件を解けば、館のほうから続きを話し始めるよ。これ以上は本当に答えだ。","そこまで そろえて じけんを とけば、やかたの ほうから つづきを はなしはじめるよ。これ いじょうは ほんとうに こたえだ。")
      ]
    },
    route:{
      label:"話の分かれ道について", tag:"ROUTE",
      lines:[
        line("真歩流","前と違うルートへ行きたいんです。","まえと ちがう るーとへ いきたいんです。","light_thinking"),
        line("舞黒","道に迷ったのかい？","みちに まよったのかい？"),
        line("真歩流","システム上の話です。","しすてむじょうの はなしです。","anger"),
        line("舞黒","庭では、どこへ行ったかより、いつ遠回りしたかが後まで響く。","にわでは、どこへ いったかより、いつ とおまわりしたかが あとまで ひびく。"),
        line("舞黒","分かれ道は、目の前に標識が出るとは限らない。","わかれみちは、めのまえに ひょうしきが でるとは かぎらない。"),
        line("真歩流","気づかないうちに選んでいる？","きづかないうちに えらんでいる？","surprised"),
        line("舞黒","午後の庭で、何を見てから散策へ向かったか。そこから考えるといい。","ごごの にわで、なにを みてから さんさくへ むかったか。そこから かんがえると いい。"),
        line("真歩流","場所より、順番を見る。","ばしょより、じゅんばんを みる。","light_thinking"),
        line("舞黒","そう。君が動く時刻が変われば、他の人が館を出入りする時刻も変わる。","そう。きみが うごく じこくが かわれば、ほかの ひとが やかたを でいりする じこくも かわる。"),
        line("真歩流","人の予定がずれると、事件の準備もずれる。","ひとの よていが ずれると、じけんの じゅんびも ずれる。","light_thinking"),
        line("舞黒","使える部屋、手に取れる道具、残る痕跡。どれも少しずつ変わる。","つかえる へや、てに とれる どうぐ、のこる こんせき。どれも すこしずつ かわる。"),
        line("真歩流","犯人が変わるわけではないんですよね。","はんにんが かわるわけでは ないんですよね。","normal"),
        line("舞黒","役者は同じでも、舞台装置が違えば芝居は変わる。","やくしゃは おなじでも、ぶたいそうちが ちがえば しばいは かわる。"),
        line("真歩流","まず庭での自分の行動順を比べてみる。","まず にわでの じぶんの こうどうじゅんを くらべてみる。","light_thinking"),
        line("舞黒","同じ選択を繰り返すより、散策へ向かうまでの寄り道を変えてごらん。","おなじ せんたくを くりかえすより、さんさくへ むかうまでの よりみちを かえてごらん。"),
        line("真歩流","一個ずつ試すしかないんですか？","いっこずつ ためすしか ないんですか？","aho"),
        line("舞黒","探偵は比較が仕事だよ。総当たりと言うと急に格好が悪くなるがね。","たんていは ひかくが しごとだよ。そうあたりと いうと きゅうに かっこうが わるくなるがね。"),
        line("真歩流","言い換えても総当たりは総当たりです。","いいかえても そうあたりは そうあたりです。","anger")
      ]
    },
    stop:{
      label:"最後の犯行を止めるには", tag:"LAST CHOICE",
      lines:[
        line("真歩流","あの場面、すぐ動いたら間に合わなかったんです。","あの ばめん、すぐ うごいたら まにあわなかったんです。","light_thinking"),
        line("舞黒","人を救おうとして、誰より早く動きたい時はある。","ひとを すくおうとして、だれより はやく うごきたい ときは ある。"),
        line("舞黒","けれど、勇気と早撃ちは別物だよ。","けれど、ゆうきと はやうちは べつものだよ。"),
        line("真歩流","早く選べばいいわけじゃない……？","はやく えらべば いいわけじゃない……？","surprised"),
        line("舞黒","あの場面では、君の手より先に、全員の視線がどこへ向いているかを見る。","あの ばめんでは、きみの てより さきに、ぜんいんの しせんが どこへ むいているかを みる。"),
        line("真歩流","助けたい人ではなく、見ている人？","たすけたい ひとではなく、みている ひと？","surprised"),
        line("舞黒","動けば止められるのか。動くことで、誰かの判断を早めてしまわないか。","うごけば とめられるのか。うごくことで、だれかの はんだんを はやめてしまわないか。"),
        line("真歩流","行動の速さではなく、きっかけの順番を考える。","こうどうの はやさではなく、きっかけの じゅんばんを かんがえる。","light_thinking"),
        line("舞黒","そう。何もしない時間にも、場面を変える働きがある。","そう。なにもしない じかんにも、ばめんを かえる はたらきが ある。"),
        line("真歩流","待っているだけで状況が良くなるとは思えません。","まっているだけで じょうきょうが よくなるとは おもえません。","normal"),
        line("舞黒","待つ目的は安全になることではない。視線と立ち位置が変わる瞬間を見つけることだ。","まつ もくてきは あんぜんに なることではない。しせんと たちいちが かわる しゅんかんを みつけることだ。"),
        line("真歩流","その瞬間が来たら、手元を見直す。","その しゅんかんが きたら、てもとを みなおす。","light_thinking"),
        line("舞黒","道具の名前に用途を決めさせないこと。探偵の持ち物は、説明書より融通が利く。","どうぐの なまえに ようとを きめさせないこと。たんていの もちものは、せつめいしょより ゆうずうが きく。"),
        line("真歩流","また行儀の悪い案を勧めていますね。","また ぎょうぎの わるい あんを すすめていますね。","anger"),
        line("舞黒","行儀よく失敗するよりはいい。","ぎょうぎよく しっぱいするよりは いい。"),
        line("真歩流","まず、誰が誰を見ているか。次に、待つと何が変わるか。","まず、だれが だれを みているか。つぎに、まつと なにが かわるか。","light_thinking"),
        line("舞黒","そこまで考えれば、君自身の案が出るはずだ。","そこまで かんがえれば、きみ じしんの あんが でるはずだ。"),
        line("真歩流","出なかったら、また相談に来ます。","でなかったら、また そうだんに きます。","smile")
      ]
    },
    scene7:{
      label:"夜の探索を有利に進めたい", tag:"SCENE 7",
      lines:[
        line("真歩流","零度警部の信頼を得ると、捜査が有利になるんですか？","れいどけいぶの しんらいを えると、そうさが ゆうりに なるんですか？","light_thinking"),
        line("舞黒","信頼は時間をくれるものではない。迷わない時間と交換するものだよ。","しんらいは じかんを くれるものではない。まよわない じかんと こうかんするものだよ。"),
        line("真歩流","得したのか損したのか、もう怪しいんですけど。","とくしたのか そんしたのか、もう あやしいんですけど。","aho"),
        line("舞黒","信を得た探偵は少し遅れて歩き出す代わりに、警部の見立てをひとつ持っている。","しんを えた たんていは すこし おくれて あるきだす かわりに、けいぶの みたてを ひとつ もっている。"),
        line("舞黒","道に迷えば、次に見るべき部屋も何度でも相談できる。","みちに まよえば、つぎに みるべき へやも なんどでも そうだんできる。"),
        line("真歩流","信頼されなかった場合は？","しんらいされなかった ばあいは？","surprised"),
        line("舞黒","早く放り出される。ただし居間は、しばらく警察のものだ。","はやく ほうりだされる。ただし いまは、しばらく けいさつの ものだ。"),
        line("真歩流","純粋な上位互換ではないんですね。","じゅんすいな じょういごかんでは ないんですね。","light_thinking"),
        line("舞黒","早さを取るか、道しるべを取るか。普通に話せたなら、その中間だよ。","はやさを とるか、みちしるべを とるか。ふつうに はなせたなら、その ちゅうかんだよ。"),
        line("真歩流","信頼は単純なボーナスではなく、探索の形を変える。","しんらいは たんじゅんな ぼーなすではなく、たんさくの かたちを かえる。","light_thinking"),
        line("舞黒","その通り。まず、開始時に何を知っているか、どの部屋が開いているかを比べる。","そのとおり。まず、かいしじに なにを しっているか、どの へやが あいているかを くらべる。"),
        line("真歩流","時計だけを見て、得した損したと決めない。","とけいだけを みて、とくした そんしたと きめない。","light_thinking"),
        line("舞黒","情報があれば無駄足を減らせる。自由があれば、先に別の場所へ行ける。","じょうほうが あれば むだあしを へらせる。じゆうが あれば、さきに べつの ばしょへ いける。"),
        line("真歩流","自分が迷いやすいなら、信頼が助けになる。","じぶんが まよいやすいなら、しんらいが たすけに なる。","normal"),
        line("舞黒","地図を覚えているなら、早く動けることが助けになるかもしれない。","ちずを おぼえているなら、はやく うごけることが たすけに なるかもしれない。"),
        line("真歩流","零度警部に嫌われる攻略を勧めてません？","れいどけいぶに きらわれる こうりゃくを すすめてません？","anger"),
        line("舞黒","勧めてはいないよ。人間関係まで最短化すると、食事会で席がなくなる。","すすめては いないよ。にんげんかんけいまで さいたんかすると、しょくじかいで せきが なくなる。"),
        line("真歩流","それは普通に困ります。","それは ふつうに こまります。","aho")
      ]
    },
    chat:{
      label:"舞黒邦夢と雑談する", tag:"SMALL TALK",
      lines:[
        line("真歩流","ヒントではなく、舞黒さん自身の話を聞いてもいいですか？","ひんとではなく、まいくろさん じしんの はなしを きいても いいですか？","smile"),
        line("舞黒","私の話かい。困ったな、嬉しいな。では茶を淹れよう。","わたしの はなしかい。こまったな、うれしいな。では ちゃを いれよう。"),
        line("真歩流","さっきから一杯も出てきていませんけど。","さっきから いっぱいも でてきていませんけど。","anger"),
        line("舞黒","死んでから一番不便なのは、茶を飲めないことではない。淹れられないことだよ。","しんでから いちばん ふべんなのは、ちゃを のめないことではない。いれられないことだよ。"),
        line("真歩流","この館で一番好きな場所は？","この やかたで いちばん すきな ばしょは？","light_thinking"),
        line("舞黒","客のいる部屋だね。館は人を迎えて、ようやく館になる。","きゃくの いる へやだね。やかたは ひとを むかえて、ようやく やかたに なる。"),
        line("真歩流","資料室ではないんですか？","しりょうしつでは ないんですか？","surprised"),
        line("舞黒","資料室は好きだが、模型をあれほど大きくした覚えはないよ。","しりょうしつは すきだが、もけいを あれほど おおきくした おぼえは ないよ。"),
        line("真歩流","館主公認ではなかった。","やかたぬし こうにんでは なかった。","aho"),
        line("舞黒","次に建てる時は、もう少し小さくするよう言っておこう。","つぎに たてる ときは、もうすこし ちいさくするよう いっておこう。"),
        line("真歩流","次がある言い方をしないでください。","つぎが ある いいかたを しないでください。","shout"),
        line("真歩流","舞黒さんは、客が帰った後は何をしていたんですか？","まいくろさんは、きゃくが かえった あとは なにを していたんですか？","normal"),
        line("舞黒","昔なら片づけだね。今は片づけられないので、散らかったまま眺める。","むかしなら かたづけだね。いまは かたづけられないので、ちらかったまま ながめる。"),
        line("真歩流","幽霊って、意外と手持ち無沙汰なんですね。","ゆうれいって、いがいと てもちぶさたなんですね。","aho"),
        line("舞黒","だから相談所はありがたい。君が来ると、館の時計が少し賑やかになる。","だから そうだんじょは ありがたい。きみが くると、やかたの とけいが すこし にぎやかに なる。"),
        line("真歩流","画面まで賑やかになりすぎる時がありますけど。","がめんまで にぎやかに なりすぎる ときが ありますけど。","anger"),
        line("舞黒","それは別の相談項目にしておいた。","それは べつの そうだんこうもくに しておいた。"),
        line("真歩流","館主が不具合を仕様にしました。","やかたぬしが ふぐあいを しように しました。","aho")
      ]
    },
    dev:{
      label:"舞台袖の記録を読む", tag:"DEVELOPMENT",
      lines:[
        line("舞黒","これは館の設計図ではないね。『仕様書』と書いてある。","これは やかたの せっけいずでは ないね。『しようしょ』と かいてある。"),
        line("真歩流","館主が読んではいけない種類の資料です。","やかたぬしが よんでは いけない しゅるいの しりょうです。","surprised"),
        line("舞黒","同じ一日を歩き直しても、違う発見になるよう順番を組んだらしい。","おなじ いちにちを あるきなおしても、ちがう はっけんに なるよう じゅんばんを くんだらしい。"),
        line("真歩流","いきなり核心に近い開発裏話を読むの、やめてもらえます？","いきなり かくしんに ちかい かいはつうらばなしを よむの、やめてもらえます？","anger"),
        line("舞黒","零度警部の信頼も、単純なご褒美にはしなかったそうだ。","れいどけいぶの しんらいも、たんじゅんな ごほうびには しなかったそうだ。"),
        line("舞黒","信じられれば情報が増える。信じられなければ、先に動ける。","しんじられれば じょうほうが ふえる。しんじられなければ、さきに うごける。"),
        line("真歩流","人間関係をタイムアタックに使わないでください。","にんげんかんけいを たいむあたっくに つかわないでください。","anger"),
        line("舞黒","失敗も後の会話へ持ち越す。探偵の見落としも、物語には立派な発見なのさ。","しっぱいも あとの かいわへ もちこす。たんていの みおとしも、ものがたりには りっぱな はっけんなのさ。"),
        line("真歩流","少し綺麗にまとめて、誤魔化しましたね？","すこし きれいに まとめて、ごまかしましたね？","light_thinking"),
        line("真歩流","この仕様書、選択に正解と不正解を付けないと書いてあります。","この しようしょ、せんたくに せいかいと ふせいかいを つけないと かいてあります。","normal"),
        line("舞黒","その瞬間に気づいたことを、後の会話へ持ち越すためだそうだ。","その しゅんかんに きづいたことを、あとの かいわへ もちこすためだそうだ。"),
        line("真歩流","失敗も分岐の材料になる？","しっぱいも ぶんきの ざいりょうに なる？","surprised"),
        line("舞黒","正解するまで戻すと、探偵が迷った時間まで物語から消えてしまう。","せいかいするまで もどすと、たんていが まよった じかんまで ものがたりから きえてしまう。"),
        line("真歩流","私の立ち尽くした時間まで保存されているんですね。","わたしの たちつくした じかんまで ほぞんされているんですね。","aho"),
        line("舞黒","作者は探偵より執念深いらしい。","さくしゃは たんていより しゅうねんぶかいらしい。"),
        line("真歩流","聞き捨てならない情報が出ました。","ききずてならない じょうほうが でました。","anger"),
        line("舞黒","安心して。館主も勝手に黒塗りやドットにされる。","あんしんして。やかたぬしも かってに くろぬりや どっとに される。"),
        line("真歩流","開発資料への苦情窓口はどこです？","かいはつしりょうへの くじょうまどぐちは どこです？","normal"),
        line("舞黒","今、君が座っているところだよ。","いま、きみが すわっている ところだよ。"),
        line("真歩流","受付担当が当事者なんですけど。","うけつけたんとうが とうじしゃなんですけど。","anger")
      ]
    },
    unstable:{
      label:"画面が時々安定しないことについて", tag:"DISPLAY ERROR",
      lines:[
        line("真歩流","相談所の画面が時々、まったく違う姿になるんですけど。","そうだんじょの がめんが ときどき、まったく ちがう すがたに なるんですけど。","surprised"),
        line("舞黒","館も長く生きると、たまには模様替えをしたくなる。","やかたも ながく いきると、たまには もようがえを したくなる。"),
        line("真歩流","黒塗りやドット絵や配信になる模様替えがあります？","くろぬりや どっとえや はいしんに なる もようがえが あります？","aho"),
        line("舞黒","流行に敏感な館だろう。","りゅうこうに びんかんな やかただろう。"),
        line("真歩流","幽霊がVTuberを始める流行は知りません。","ゆうれいが ぶいちゅーばーを はじめる りゅうこうは しりません。","normal"),
        line("舞黒","肉体がないという点では、適性が高いと思わないかい？","にくたいが ないという てんでは、てきせいが たかいと おもわないかい？"),
        line("真歩流","そこだけ妙に説得力を出さないでください。","そこだけ みょうに せっとくりょくを ださないでください。","anger"),
        line("舞黒","心配しなくても、話題を選ぶ画面は動かないよ。","しんぱいしなくても、わだいを えらぶ がめんは うごかないよ。"),
        line("真歩流","会話を始めた後だけ不安定になる？","かいわを はじめた あとだけ ふあんていに なる？","light_thinking"),
        line("舞黒","そう。話を始める瞬間に、館がたまにくしゃみをする。","そう。はなしを はじめる しゅんかんに、やかたが たまに くしゃみを する。"),
        line("真歩流","くしゃみで解像度が落ちる館、初めて見ました。","くしゃみで かいぞうどが おちる やかた、はじめて みました。","aho"),
        line("舞黒","どの姿になっても、相談の中身までは変わらない。","どの すがたに なっても、そうだんの なかみまでは かわらない。"),
        line("真歩流","黒塗りになると怖さは三割増しです。","くろぬりに なると こわさは さんわりましです。","normal"),
        line("舞黒","顔が見えないぶん、想像力で補えるだろう？","かおが みえないぶん、そうぞうりょくで おぎなえるだろう？"),
        line("真歩流","配信ではコメント欄まで勝手に増えています。","はいしんでは こめんとらんまで かってに ふえています。","surprised"),
        line("舞黒","館の壁まで視聴者として数えているからね。","やかたの かべまで しちょうしゃとして かぞえているからね。"),
        line("真歩流","修理する予定は？","しゅうりする よていは？","normal"),
        line("舞黒","不具合ではなく、低確率の余興として保存することにした。","ふぐあいではなく、ていかくりつの よきょうとして ほぞんすることに した。"),
        line("真歩流","言い方だけで修理を終えましたね。","いいかただけで しゅうりを おえましたね。","anger"),
        line("舞黒","館主の権限は便利だろう？","やかたぬしの けんげんは べんりだろう？")
      ]
    }
  };

  var specialIntro={
    silhouette:[
      line("真歩流","……舞黒さん。今日、輪郭しか見えないんですけど。",null,"surprised"),
      line("舞黒","秘密を守る相談所らしいだろう？"),
      line("真歩流","相談員まで秘密にしないでください。",null,"anger")
    ],
    pixel:[
      line("真歩流","なんか今日は、全体的にかくかくしていません？","なんか きょうは、ぜんたいてきに かくかくしていません？","aho"),
      line("舞黒","ヒントはぼかすものだからね。解像度もぼかしてみた。","ひんとは ぼかすものだからね。かいぞうども ぼかしてみた。"),
      line("真歩流","別のものまでぼかさないでください。","べつの ものまで ぼかさないでください。","anger")
    ],
    vtuber:[
      line("真歩流","……どうして私が『ツッコミ担当』と表示されてるんですか？",null,"anger"),
      line("舞黒","配信者がボケる以上、必要な役職だよ。"),
      line("真歩流","まず配信者になった経緯を説明してください。",null,"anger"),
      line("舞黒","偶然だ。カメラも偶然、投げ銭ボタンも偶然だよ。")
    ]
  };

  var badEndPreface=[
    line("真歩流","ここへ来られたということは、一度は結末を見届けたんですよね。","ここへ こられたということは、いちどは けつまつを みとどけたんですよね。","normal"),
    line("舞黒","たとえ苦い結末でも、ここでは失敗とは呼ばないよ。","たとえ にがい けつまつでも、ここでは しっぱいとは よばないよ。"),
    line("真歩流","では、何と呼ぶんです？","では、なんと よぶんです？","surprised"),
    line("舞黒","次へ持っていく質問票さ。反省文より、ずっと役に立つ。","つぎへ もっていく しつもんひょうさ。はんせいぶんより、ずっと やくに たつ。")
  ];

  function voiceIdFor(groupName,index){
    return "hr_"+groupName+"_"+("000"+(index+1)).slice(-3);
  }

  function bindVoiceIds(lines,groupName){
    // voice_pipeline_v21.py と同じ決定的ID規則。
    // 別manifestを同期しなくても、JS側とTTS側で常に同じIDになる。
    for(var i=0;i<lines.length;i++){
      lines[i].voiceId=voiceIdFor(groupName,i);
    }
  }
  Object.keys(topics).forEach(function(topicId){
    bindVoiceIds(topics[topicId].lines,"topic_"+topicId);
  });
  Object.keys(specialIntro).forEach(function(mode){
    bindVoiceIds(specialIntro[mode],"intro_"+mode);
  });
  bindVoiceIds(badEndPreface,"bad_end");

  function rollMode(){
    var r=Math.random();
    if(r<.82){ return "normal"; }
    if(r<.88){ return "silhouette"; }
    if(r<.94){ return "pixel"; }
    return "vtuber";
  }
  function ensureCss(){
    var old=document.getElementById("hr-css-link");
    if(old&&old.parentNode){ old.parentNode.removeChild(old); }
    var link=document.createElement("link");
    link.id="hr-css-link"; link.rel="stylesheet";
    link.href="./data/others/hint_room.css?"+Date.now();
    document.head.appendChild(link);
  }
  function imgFor(who,mode,face){
    if(mode==="pixel"){
      return who==="舞黒"?"./data/fgimage/chara/maicro/dot.png":"./data/fgimage/chara/mahoru/dot.png";
    }
    return who==="舞黒"?"./data/fgimage/chara/maicro/normal.png":"./data/fgimage/chara/mahoru/"+(face||"normal")+".png";
  }
  function mahoruFaceAt(st){
    for(var i=st.index;i>=0;i--){
      if(st.lines[i].who==="真歩流"){ return st.lines[i].face||"normal"; }
    }
    return "normal";
  }
  function preloadFaces(lines,mode){
    if(mode==="pixel"){ return; }
    var seen={};
    for(var i=0;i<lines.length;i++){
      if(lines[i].who!=="真歩流"){ continue; }
      var face=lines[i].face||"normal";
      if(seen[face]){ continue; }
      seen[face]=1;
      var img=new Image();
      img.src=imgFor("真歩流",mode,face);
    }
  }
  function whoClass(who){ return who==="舞黒"?"maicro":"mahoru"; }
  function stopVoice(){
    try {
      var map=kag.tmp&&kag.tmp.map_se,audio=map&&map["2"];
      if(audio){
        audio.stop();
        audio.unload();
        delete map["2"];
      }
      if(kag.stat&&kag.stat.current_se){ delete kag.stat.current_se["2"]; }
      if(kag.tmp){ kag.tmp.is_vo_play=false; }
    } catch(e){
      console.warn("[hint voice] stop failed",e);
    }
  }
  function playVoice(lineNow){
    stopVoice();
    var sf=(kag.variable&&kag.variable.sf)?kag.variable.sf:{};
    if(sf.voice_enabled==0||!lineNow||!lineNow.voiceId){ return; }

    // 通常voice_pipelineと同じ保存規則:
    // voice/<speaker>/hint_room_voice/<voice_id>.mp3
    // これにより hint_room_voice_manifest.js は不要。
    var speaker=whoClass(lineNow.who);
    var storage="voice/"+speaker+"/hint_room_voice/"+lineNow.voiceId+".mp3";
    try {
      kag.stat.map_vo=kag.stat.map_vo||{};
      kag.stat.map_vo.vobuf=kag.stat.map_vo.vobuf||{};
      kag.stat.map_vo.vobuf["2"]=1;
      kag.ftag.startTag("playse",{storage:storage,buf:"2",stop:"true"});
    } catch(e){
      console.warn("[hint voice] play failed: "+lineNow.voiceId,e);
    }
  }
  function endButton(st,label){
    if(st.index!==st.lines.length-1){ return '<div class="hr-next-mark">クリックで送る　◆</div>'; }
    return '<button class="hr-finish" data-hr-action="finish">'+esc(label||"話題選択へ戻る")+'</button>';
  }

  function renderNormal(st,t,lineNow){
    var mc=whoClass(lineNow.who),mahoruFace=mahoruFaceAt(st);
    return '<img class="hr-novel-bg" src="./data/bgimage/reference_room.png" alt="">'
      +'<div class="hr-normal-shade"></div><div class="hr-topline"><span>舞黒相談所</span><span>'+esc(t.tag)+'</span></div>'
      +'<img class="hr-normal-chara mahoru '+(mc==="mahoru"?"speaking":"")+'" src="'+imgFor("真歩流","normal",mahoruFace)+'" alt="真歩流">'
      +'<img class="hr-normal-chara maicro '+(mc==="maicro"?"speaking":"")+'" src="'+imgFor("舞黒","normal")+'" alt="舞黒邦夢">'
      +'<div class="hr-novel-box"><div class="hr-name '+mc+'">'+esc(lineNow.who)+'</div>'
      +'<div class="hr-novel-text">'+esc(lineNow.text)+'</div>'+endButton(st)+'</div>';
  }

  function renderSilhouette(st,t){
    var rows="",start=Math.max(0,st.index-4);
    for(var i=start;i<=st.index;i++){
      var l=st.lines[i],last=i===st.index;
      rows+='<div class="hr-sil-line '+(last?"current":"past")+'"><div class="hr-sil-who '+whoClass(l.who)+'">'+esc(l.who)+'</div>'
        +'<div class="hr-sil-text">「'+esc(l.text)+'」</div></div>';
    }
    return '<img class="hr-novel-bg hr-sil-bg" src="./data/bgimage/reference_room.png" alt="">'
      +'<img class="hr-sil-person left" src="'+imgFor("舞黒","normal")+'" alt="">'
      +'<img class="hr-sil-person right" src="'+imgFor("真歩流","normal",mahoruFaceAt(st))+'" alt="">'
      +'<div class="hr-sil-shade"></div><div class="hr-sil-wrap"><div class="hr-sil-head"><span>CONSULTATION ／ '+esc(t.tag)+'</span></div>'
      +'<div class="hr-sil-log">'+rows+'</div><div class="hr-sil-foot">'+endButton(st,"……選択肢に戻る")+'</div></div>';
  }

  function renderPixel(st,t,lineNow){
    var mc=whoClass(lineNow.who),display=lineNow.kana||lineNow.text;
    return '<img class="hr-pixel-bg" src="./data/bgimage/dot_hint_room.png" alt="">'
      +'<div class="hr-pixel-scan"></div><div class="hr-pixel-head"><b>MAIKURO ROOM</b><span>なんでも そうだんまどぐち</span><em>えがら：どっと</em></div>'
      +'<div class="hr-pixel-tag">▼ '+esc(t.tag)+'</div>'
      +'<img class="hr-pixel-person mahoru '+(mc==="mahoru"?"speaking":"")+'" src="'+imgFor("真歩流","pixel")+'" alt="まほる">'
      +'<img class="hr-pixel-person maicro '+(mc==="maicro"?"speaking":"")+'" src="'+imgFor("舞黒","pixel")+'" alt="まいくろ">'
      +'<div class="hr-pixel-box"><div class="hr-pixel-name">'+(mc==="maicro"?"まいくろ":"まほる")+'</div><div class="hr-pixel-text">'+esc(display)+'</div>'
      +endButton(st,"せんたくしへ もどる")+'</div>';
  }

  function renderVtuber(st,t,lineNow){
    var chat='<div class="hr-chat-seed"><b>名探偵ワナビ</b><span>今日は画面が普通じゃない</span></div>';
    var start=Math.max(0,st.index-6);
    for(var i=start;i<=st.index;i++){
      var l=st.lines[i],c=whoClass(l.who);
      chat+='<div class="hr-chat-line '+c+'"><b>'+(c==="maicro"?"舞黒邦夢（配信者）":"真歩流（ツッコミ担当）")+'</b><span>'+esc(l.text)+'</span></div>';
    }
    var portrait=imgFor(lineNow.who,"normal",lineNow.face),name=lineNow.who==="舞黒"?"舞黒邦夢 ／ 故人":"真歩流 ／ ツッコミ担当";
    return '<div class="hr-live-bg"></div><div class="hr-live-head"><b>● LIVE</b><span>【ネタバレ注意】舞黒館の惨劇 ヒント放送 #7 —— '+esc(t.label)+'</span><em>◉ '+(2170+st.index*31)+'</em></div>'
      +'<div class="hr-chat"><h3>CHAT</h3><div class="hr-chat-scroll" id="hr-chat-scroll">'+chat+'</div><div class="hr-donation">￥1,000　もう答えを言ってくれ</div></div>'
      +'<div class="hr-live-stage"><img src="'+portrait+'" alt="'+esc(lineNow.who)+'"><div>'+esc(name)+'</div></div>'
      +'<div class="hr-live-caption"><small>'+esc(lineNow.who)+'</small><p>'+esc(lineNow.text)+'</p></div>'
      +'<div class="hr-live-foot"><span>#'+esc(t.label)+'</span>'+endButton(st,"■ この話題はおわり")+'</div>';
  }

  function render(){
    var st=window.HR.state;
    if(!st){ return; }
    var t=topics[st.topic],lineNow=st.lines[st.index],html="";
    if(st.mode==="silhouette"){ html=renderSilhouette(st,t); }
    else if(st.mode==="pixel"){ html=renderPixel(st,t,lineNow); }
    else if(st.mode==="vtuber"){ html=renderVtuber(st,t,lineNow); }
    else { html=renderNormal(st,t,lineNow); }
    var root=document.getElementById("hr-root");
    if(!root){ root=document.createElement("div"); root.id="hr-root"; (document.getElementById("tyrano_base")||document.body).appendChild(root); }
    root.className="mode-"+st.mode;
    root.setAttribute("data-voice-id",lineNow.voiceId||"");
    root.innerHTML=html;
    root.onclick=function(e){
      var btn=e.target.closest?e.target.closest("[data-hr-action]"):null;
      if(btn){ e.preventDefault(); e.stopPropagation(); window.HR.finish(); return; }
      window.HR.next();
    };
    var chat=document.getElementById("hr-chat-scroll");
    if(chat){ chat.scrollTop=chat.scrollHeight; }
    playVoice(lineNow);
  }

  function shieldJump(target){
    window.HR.clear();
    var base=document.getElementById("tyrano_base")||document.body;
    var shield=document.createElement("div");
    shield.style.cssText="position:absolute;inset:0;z-index:999999999;background:transparent";
    shield.addEventListener("click",function(e){ e.preventDefault(); e.stopPropagation(); },true);
    shield.addEventListener("pointerdown",function(e){ e.preventDefault(); e.stopPropagation(); },true);
    base.appendChild(shield);
    setTimeout(function(){ if(shield.parentNode){ shield.parentNode.removeChild(shield); } },260);
    setTimeout(function(){ kag.ftag.startTag("jump",{storage:"system/hint_room.ks",target:target}); },0);
  }

  window.HR={
    state:null,
    roomPrefaceShown:false,
    begin:function(topicId,forcedMode){
      if(!topics[topicId]){ return; }
      ensureCss();
      if(window.MSGUI){ window.MSGUI.clear(); }
      var mode=forcedMode||rollMode(),intro=specialIntro[mode]||[],preface=[];
      var sf=(kag.variable&&kag.variable.sf)?kag.variable.sf:{};
      if(!this.roomPrefaceShown&&sf.achievements&&sf.achievements.end_bad==1){
        preface=badEndPreface;
        this.roomPrefaceShown=true;
      }
      this.state={topic:topicId,mode:mode,index:0,lines:intro.concat(preface,topics[topicId].lines)};
      preloadFaces(this.state.lines,mode);
      render();
      this.keyHandler=function(e){
        if(e.key==="Enter"||e.key===" "||e.key==="Spacebar"){
          e.preventDefault(); e.stopPropagation(); window.HR.next();
        }
      };
      window.addEventListener("keydown",this.keyHandler,true);
    },
    next:function(){
      var st=this.state;
      if(!st||st.index>=st.lines.length-1){ return; }
      st.index++;
      try { kag.ftag.startTag("playse",{storage:"switch_on.mp3",buf:"3",stop:"true"}); } catch(e){}
      render();
    },
    finish:function(){ shieldJump("*hint_menu"); },
    clear:function(){
      stopVoice();
      var root=document.getElementById("hr-root");
      if(root&&root.parentNode){ root.parentNode.removeChild(root); }
      if(this.keyHandler){ window.removeEventListener("keydown",this.keyHandler,true); this.keyHandler=null; }
      this.state=null;
    },
    debugStart:function(mode,topicId){ this.clear(); this.begin(topicId||"ending",mode||"normal"); }
  };
})();

