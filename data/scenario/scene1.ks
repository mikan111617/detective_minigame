@clearstack

; プロローグから庭園へまで
;========================================
; プロローグ - 舞黒館へ
;========================================
*prologue

[clearfix]
@clearstack
[cm]
[freeimage layer="0"]
[bg storage="house_front.png"]
[initilize_hp]
[show_menu]
; ゲーム内時刻を 12:55 にセット（このシナリオの開始時刻）
[set_time hour=12 min=55]
[gage_draw place="舞黒館前"]

@mask_off

; ---- airi は charapos で表示 → message_chara 不使用 ----
[charapos name="airi" face="smile" num="0"]

#airi
[voice id="v00191"]
お姉ちゃん、ここがそうなの？[p]
#airi
[voice id="v00192"]
お洒落で素敵な所ね。[p]

#
妹の[ruby text="あい" ]愛[ruby text="り" ]理が、目を輝かせて西洋館を見上げる。[p]

; ---- mahoru は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00193"]
そのはずよ……。[p]
#mahoru
[voice id="v00194"]
お父さんのメモ通りならね。[p]

[reset_message_chara]

#
私、真白[ruby text="ま" ]真[ruby text="ほ" ]歩[ruby text="る" ]流と妹の愛理は横浜にある舞黒館に来ていた。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00195"]
お父さんが来たくなるのも納得だわ。[p]
#mahoru
[voice id="v00196"]
……待っててね、お父さん。[p]

[reset_message_chara]

#
父、真白[ruby text="しゃ" ]奢[ruby text="ろく" ]禄が行方不明になってから、すでに半年。[p]
#
コンサルティング会社を経営する父は、ある日突然、姿を消した。[p]

; ---- 回想シーン開始 ----

[mask]

[chara_hide_all]
[chara_hide layer="message0" name="mahoru"]
[filter sepia="100"]
[bg storage="event/reading_newspaper.png"]
; 回想シーンは時刻を非表示にする（hide_time="true"）
[gage_draw place="真白家:リビング" hide_time="true"]
[mask_off]

#
半年前の朝。コーヒーの香りが漂うリビング。[p]
#
新聞を読む父の表情がどこか真剣みを帯びていた。[p]

; ---- mahoru は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="shihuku"]

#mahoru
[voice id="v00197"]
お父さん、今日はどこか遠くに行くの？[p]

[reset_message_chara]

#
何気ない私の問いに、父は新聞を机の上に置いた。[p]

#sharoku
[voice id="v00198"]
ああ、顧客の依頼で……ちょっと調べたいことがあってね。[p]

#sharoku
[voice id="v00199"]
私が留守の間、お母さんと愛理を頼むよ、真歩流。[p]

#
それが、私が見た父の最後の姿だった。[p]

[mask]
[filter sepia="0"]
[charapos name="airi" face="" num="0"]
[bg storage="house_front.png"]
; 回想から戻る。f.game_time はそのまま 12:55 を維持しているので再セット不要
[gage_draw place="舞黒館前"]
[mask_off]

#
私は父の行方を追うため、ここに来たのだ。[p]
#
手がかりは父のメールに残された「舞黒館」という言葉のみ。[p]
この場所で開催される特別宿泊イベント。[r]
#
これこそが、千載一遇のチャンス！[p]

; ---- mahoru は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00200"]
（絶対にお父さんを見つけてみせるんだから！）[p]

[reset_message_chara]

#
私は帽子のつばを、くいっと上げた。[p]

; ---- airi は charapos で表示 → message_chara 不使用 ----
[chara_mod name="airi" face="normal"]

#airi
[voice id="v00201"]
ねえ、お姉ちゃん……[p]
#airi
[voice id="v00202"]
本当にその格好で入るの？[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00203"]
似合ってるでしょう。[p]

[reset_message_chara]

[chara_mod name="airi" face="stunned"]

#airi
[voice id="v00204"]
変装っていうか、コスプレよそれ。[p]
#airi
[voice id="v00205"]
恥ずかしいから他人のふりしてもいい？[p]

#
愛理は深く、深く溜息をついた。[r]
#
お洒落が大好きな彼女にとって、私のこの「正装」は許容範囲外らしい。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00206"]
あら、愛理。何事も形から入るのが大切なのよ。[p]
#mahoru
[voice id="v00207"]
さあ、張り切って調査開始よ！[p]

[reset_message_chara]

[chara_mod name="airi" face="normal"]

#airi
[voice id="v00208"]
はぁ……お姉ちゃんの暴走を止めるのが私の仕事か……。[p]
#airi
[voice id="v00209"]
お父さん、私頑張るからね。[p]

[chara_mod name="airi" face="surprised"]

#airi
[voice id="v00210"]
あっ、ちょっと、お姉ちゃん！ 置いていかないでよ！[p]

#
こうして、真白姉妹の壮絶な一日が幕を開けたのである。[p]

[chara_hide_all]
@layopt layer="0" visible="false"
@layopt layer="1" visible="true"
@layopt layer="message" visible="false"
[cm]
[clearfix]
[freeimage layer="1"]
; タイトル表記の演出（title_ui.ks／タイトル画面と同じロゴ組み）
[tl_cutin]
[freeimage layer="1"]
[bg storage="dark.png"]

[playse storage="door_open.mp3"]

;========================================
;登場人物の紹介
;========================================
[bg storage="entrance.png"]
[playbgm storage="Eternal_Peace.mp3"]
@layopt layer="0" visible="true"
[show_menu]
; 12:55 → 12:57（館への入場で約2分経過）
[advance_time min=2]
[gage_draw place="舞黒館:玄関"]

[iscript]
// 真歩流のプロフィールと愛理のプロフィール
f.status["chara_01"].owned = true;
f.status["chara_02"].owned = true;
f.status["chara_10"].owned = true;
[endscript]

[notify_profile ids="chara_01,chara_02,chara_10"]

#
重厚な扉が開くと、そこには凛とした空気の女性が立っていた。[r][l]
#
背筋を伸ばし、しかし柔和な笑みを浮かべたその姿は、この館そのもののように落ち着いていた。[p]

; ---- jushika は charapos で表示 → message_chara 不使用 ----
[charapos name="jushika" face="normal" num="0"]

#jushika
[voice id="v00211"]
お待ちしておりました、真白真歩流様、愛理様。[p]

#jushika
[voice id="v00212"]
私がこの舞黒館を預かっております、[ruby text="ふ" ]富[ruby text="れ" ]礼[ruby text="ち" ]知[ruby text="じゅ" ]朱[ruby text="し" ]志[ruby text="か" ]香です。[p]

; ---- mahoru・airi は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00213"]
あ、どうも！ 真白真歩流です！[p]
#mahoru
[voice id="v00214"]
こっちが妹の愛理です。[p]

[reset_message_chara]

[message_chara name="airi" face="normal"]

#airi
[voice id="v00215"]
よろしくお願いします。[p]

[reset_message_chara]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00216"]
すごく素敵な建物ですね！ 西洋の雰囲気に包まれて、何だか海外に来たみたいです！[p]

[reset_message_chara]

; ---- jushika は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="jushika" face="smile"]

#jushika
[voice id="v00217"]
ふふ、お褒めいただき光栄です。[p]
#jushika
[voice id="v00218"]
どうぞ、中へ。[p]

#
[bg storage="living.png" time="2000" cross="true"]
; リビングへ移動（時刻は 12:57 のまま変化なし）
[gage_draw place="舞黒館:リビング"]

[chara_mod name="jushika" face="normal"]

#jushika
[voice id="v00219"]
改めまして、ようこそ。[p]
#jushika
[voice id="v00220"]
本日の宿泊イベントには、お二人を含めて六名様が参加されます。[p]
#jushika
[voice id="v00221"]
残るお二方も、まもなく到着されるでしょう。[p]

#jushika
[voice id="v00222"]
それから……皆様のお世話をするメイドを紹介しますね。[p]
#jushika
[voice id="v00223"]
小出里亜さん？[p]

[iscript]
f.status["chara_03"].owned = true;
[endscript]

[notify_profile ids="chara_03"]

[chara_move name="jushika" left="430" time=1000]

; ---- koderia は charapos で表示 → message_chara 不使用 ----
[charapos name="koderia" face="normal" num="2"]

#koderia
[voice id="v00224"]
はい、すぐに行きます。[p]

#
鈴が転がるような声と共に、一人の女性が現れた。[p]
#
完璧な角度のお辞儀。そして顔を上げた瞬間の、花が咲くような笑顔。[p]

#koderia
[voice id="v00225"]
いらっしゃいませ。[r][l]
#koderia
[voice id="v00226"]
[ruby text="はい" ]灰[ruby text="ね" ]音[ruby text="こ" ]小[ruby text="で" ]出[ruby text="り" ]里[ruby text="あ" ]亜と申します。[p]
#koderia
[voice id="v00227"]
滞在中は、私が皆様の身の回りの世話をお手伝いいたします。[p]

; ---- mahoru は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v00228"]
（か、可愛い……！）[p]
#mahoru
[voice id="v00229"]
（初めてメイドさんを見たよ！）[p]

[reset_message_chara]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v00230"]
よ、よろしくお願いします！[p]

[reset_message_chara]

; ---- koderia は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="koderia" face="smile"]

#koderia
[voice id="v00231"]
ふふっ、元気なお客様で嬉しいです。[p]
#koderia
[voice id="v00232"]
お荷物、お部屋までお運びしますか？[p]

[message_chara name="airi" face="normal"]

#airi
[voice id="v00233"]
ありがとうございます。[p]

[reset_message_chara]

#koderia
[voice id="v00234"]
それでは、お預かりしますね。[p]

;【伏線2: 朱志香の夫の話】

; ---- jushika は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="jushika" face="smile"]

#jushika
[voice id="v00235"]
それにしても……真白様。[p]
#jushika
[voice id="v00236"]
とても可愛らしい格好ですね。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00237"]
似合ってますか！？[p]
#mahoru
[voice id="v00238"]
大学の友人が仕立ててくれたんです。[p]

[reset_message_chara]

#jushika
[voice id="v00239"]
ええ、とても。[p]

[message_chara name="airi" face="normal"]

#airi
[voice id="v00240"]
あの、他の参加者の方は……？[p]

[reset_message_chara]

; ---- koderia は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="koderia" face="smile"]

#koderia
[voice id="v00241"]
奥のリビングルームでおくつろぎです。[p]

#koderia
[voice id="v00243"]
私は荷物をお運びするので、これにて。[p]

[chara_hide name="koderia"]

#
小出里亜は一礼すると、音もなく奥へと下がっていった。[p]
#
去り際、リビングの方に一瞬だけ視線を向けた。[p]

[iscript]
f.status["chara_04"].owned = true;
[endscript]

[notify_profile ids="chara_04"]

; ---- jushika は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="jushika" face="smile"]

#jushika
[voice id="v00244"]
では、ごゆっくり。[p]
[chara_hide name="jushika"]

#
参加者は全部で6人。[p]
#
私たち姉妹を含めて、あと4人。[p]

; ---- mahoru は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00245"]
屋敷を調べるときは怪しまれないように注意しないとね。[p]

[reset_message_chara]

; ---- airi は charapos で表示 → message_chara 不使用 ----
[charapos name="airi" face="normal" num="0"]

#airi
[voice id="v00246"]
言うまでもないけれど、あまりこそこそ調べたりしないでよ。[p]
#airi
[voice id="v00247"]
まあ、一応お姉ちゃんの格好なら、逆に調べやすいかもしれないけど。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00248"]
怪しまれるから、そんなことはしないわよ。[p]
#mahoru
[voice id="v00249"]
それにしても、どうして調べやすいのよ……？[p]

[reset_message_chara]

; ---- airi は charapos 表示中 → chara_mod で表情変更 ----
[chara_mod name="airi" face="smile"]

#airi
[voice id="v00250"]
探偵になりきっている痛い女子大生だと思ってもらえるからね。[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v00251"]
……なるほどね。[p]
#mahoru
[voice id="v00252"]
って、それじゃあ、ただの変な人じゃない！[p]

[reset_message_chara]

[chara_mod name="airi" face="normal"]

#airi
[voice id="v00253"]
だって、その通りでしょ。[p]

#
愛理と話していると、ソファの方から声がかかった。[p]

[chara_hide name="airi"]

; ---- eruku・juri は charapos で表示 → message_chara 不使用 ----
[charapos name="eruku" face="smile" num="2"]
[charapos name="juri" face="smile" num="1"]

#eruku
[voice id="v00254"]
おや？ 随分と可愛らしい格好の参加者だね。[p]
#eruku
[voice id="v00255"]
事件の匂いでもかぎつけてきたのかい？[p]

#
ニヤリと笑う優男。[r]
#
整った顔立ちでこちらを見ている。[p]

#eruku
[voice id="v00256"]
[ruby text="ほ" ]穂[ruby text="あ" ]在[ruby text="ろ" ]呂[ruby text="え" ]叡[ruby text="る" ]留[ruby text="く" ]久だ。[r][l]
#eruku
[voice id="v00257"]
君たちのような若いお嬢さんも参加しているとは驚きだなあ。[p]
#eruku
[voice id="v00258"]
よほど洋館が好きなのかい？[p]
#eruku
[voice id="v00259"]
それとも、コスプレを楽しみに来たのかい？[p]

;【伏線4: 叡留久の香水】
#
叡留久から、ふわっと甘い香水の匂いが漂う。[p]

#juri
[voice id="v00260"]
あなた、からかったら可哀想でしょう？[p]

#
叡留久の隣にいた女性が、美しい声で嗜めた。[p]

#juri
[voice id="v00261"]
初めまして。妻の[ruby text="じゅ" ]珠[ruby text="り" ]璃よ。よろしくね。[p]

#
ザ・キャリアウーマン。[p]
#
整ったメイク、高そうな服、そして……圧倒的なプロポーション。[p]

#eruku
[voice id="v00262"]
はは、すまない。[p]
#eruku
[voice id="v00263"]
君のその衣装があまりに決まっていたから、ついね。[p]
#eruku
[voice id="v00264"]
君の手作りかい？[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00265"]
いえ！ 友人の力作なんです！[p]
#mahoru
[voice id="v00266"]
お二人はご夫婦での参加なんですね、素敵です！[p]

[reset_message_chara]

#juri
[voice id="v00267"]
ええ、そうよ。[p]

;【伏線5: SNSの写真】
#juri
[voice id="v00268"]
SNSでここの写真を見つけてね。夫にお願いしたの。[p]

#
珠璃がスマホの画面を見せてくる。[p]
#
ネイルまで完璧に手入れされた指先。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00269"]
わあ、素敵な写真……これ、山下公園ですか？[p]

[reset_message_chara]

#juri
[voice id="v00270"]
そうよ。この辺りの雰囲気、昔から好きなの。[p]

[chara_mod name="eruku" face="surprised2" time="1000"]

[chara_mod name="eruku" face="normal"]

#eruku
[voice id="v00271"]
……ああ、本当にいい場所だ。[p]

#juri
[voice id="v00272"]
この洋館も素敵よね。[p]
#juri
[voice id="v00273"]
ねえあなた、うちにもサンルームを作りましょうよ。[p]

#eruku
[voice id="v00274"]
おお、いいね。[p]
#eruku
[voice id="v00275"]
それじゃ、いっちょ張り切って頑張ろうかな。[p]

[iscript]
f.status["chara_05"].owned = true;
f.status["chara_06"].owned = true;
[endscript]

; ★ バグ修正：[reset_message_chara] は [mask] の前に置く ★
; （mask 中の chara_hide が layer 参照エラーを起こすため）
[reset_message_chara]
[mask]
; 12:57 → 13:00（夫妻との会話で約3分経過）
[advance_time min=3]
[gage_draw place="舞黒館:リビング"]
[mask_off]

[notify_profile ids="chara_05,chara_06"]

[playse storage="door_open.mp3"]

#
その時、玄関の方で再び物音がした。[p]

; ---- airi は画面外 → message_chara 使用 ----
[message_chara name="airi" face="normal"]

#airi
[voice id="v00276"]
お姉ちゃん、最後の方たちが来たみたい。[p]

[reset_message_chara]

#
少しして、リビングに入ってきたのは対照的な二人組だった。[p]

[chara_hide_all]

; ---- kazuto・mary は charapos で表示 → message_chara 不使用 ----
[charapos name="kazuto" face="normal" num="1"]
[charapos name="mary" face="normal" num="2"]

#mary
[voice id="v00277"]
Hello, everyone.[r][l]
#mary
[voice id="v00278"]
I'm Mary. It's wonderful to be here.[p]

; ---- airi は画面外 → message_chara 使用 ----
[message_chara name="airi" face="surprised"]

#airi
[voice id="v00279"]
ヒッ……え、英語！？[p]
#airi
[voice id="v00280"]
あ、あわわ……は、はろー……？[p]

[reset_message_chara]

#
愛理が固まった。[p]
#
英語の成績はトップクラスなのに、会話となると全く話にならないのが愛理の可愛いところだ。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00281"]
It's lovely to meet you too, Mary![p]
#mahoru
[voice id="v00282"]
I'm Mahoru Mashiro, and this is my sister Airi.[p]
#mahoru
[voice id="v00283"]
Don't worry, she's just a little shy.[p]

[reset_message_chara]

; ---- mary は charapos 表示中 → chara_mod で表情変更 ----
[chara_mod name="mary" face="smile"]

#mary
[voice id="v00284"]
Oh, your English is perfect![p]
#mary
[voice id="v00285"]
でも、日本語でも大丈夫ですよ？[p]

[message_chara name="airi" face="surprised"]

#airi
[voice id="v00286"]
へ……？[p]

[reset_message_chara]

#mary
[voice id="v00287"]
ふふ、少しなら話せますから。[p]

[message_chara name="airi" face="smile"]

#airi
[voice id="v00288"]
よ、よかったぁ……。[p]
#airi
[voice id="v00289"]
日本語お上手ですね、びっくりしました。[p]

[reset_message_chara]

#mary
[voice id="v00290"]
イギリスから来ました、メアリーです。[p]
#mary
[voice id="v00291"]
まだ勉強中なので、変な言葉だったら教えてくださいね。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00292"]
イギリス……！ いいなあ、紅茶の国！[p]
#mahoru
[voice id="v00293"]
私も住んでみたいなあ。[p]

[reset_message_chara]

[message_chara name="airi" face="normal"]

#airi
[voice id="v00294"]
お姉ちゃん、それはすごく偏見よ……。[p]

[reset_message_chara]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v00295"]
え、そうかなあ？[p]
#mahoru
[voice id="v00296"]
ごめんなさい、つい興奮しちゃって。[p]

[reset_message_chara]

#mary
[voice id="v00297"]
いいんですよ。[p]
#mary
[voice id="v00298"]
私も紅茶とミステリーが大好きですから。[p]

[chara_mod name="mary" face="thinking"]

#mary
[voice id="v00299"]
……。[p]

#
メアリーは私と愛理の顔をじっと見つめた。[r]
#
なんだか感慨深げにこちらを見つめる。[p]

#mary
[voice id="v00300"]
あの……もしかして、真白さんは……[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00301"]
え、何ですか？ 私の顔に何かついてます？[p]

[reset_message_chara]

[chara_mod name="mary" face="smile"]

#mary
[voice id="v00302"]
あ……いえ、なんでもないんです。[p]
#mary
[voice id="v00303"]
ただ、とても親しみを感じてしまって。[p]
#mary
[voice id="v00304"]
仲良くしてくださいね。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00305"]
もちろんです！ こちらこそ！[p]

[reset_message_chara]

#
メアリーさんの不思議な雰囲気。初めて会った気がしないのは、なぜだろう。[p]

#kazuto
[voice id="v00306"]
おい、荷物を置きに行きたいんだが？[p]

#
冷たい声が割って入った。[r]
#
メアリーと一緒に入ってきた、不機嫌そうな青年だった。[p]

; ---- kazuto は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="kazuto" face="normal"]

#kazuto
[voice id="v00307"]
[ruby text="じょ" ]徐[ruby text="おん" ]音[ruby text="かず" ]和[ruby text="と" ]人。医大生だ。[p]
#kazuto
[voice id="v00308"]
まあ、よろしく。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00309"]
あ、はい。真白真歩流です……。[p]
#mahoru
[voice id="v00310"]
医大生なんだ、すごいね！[p]

[reset_message_chara]

#kazuto
[voice id="v00311"]
別に何てことはない。[p]
#kazuto
[voice id="v00312"]
それより……お前、なんだその格好は？[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00313"]
ふふ、似合ってるでしょう！[p]

[reset_message_chara]

#kazuto
[voice id="v00314"]
……。馬鹿はどこにでもいるもんだな。[p]
#kazuto
[voice id="v00315"]
荷物を置きに行く。失礼。[p]

[chara_hide name="kazuto"]

#
和人はそれだけ言うと、さっさと歩き去ってしまった。[p]

[message_chara name="airi" face="normal"]

#airi
[voice id="v00316"]
クールだね……。でも、格好いいかも。[p]

[reset_message_chara]

[message_chara name="mahoru" face="anger"]

#mahoru
[voice id="v00317"]
馬鹿って何よ！[p]
#mahoru
[voice id="v00318"]
私、何か悪いことしたわけじゃないのにー！[p]

[reset_message_chara]

[message_chara name="airi" face="normal"]

#airi
[voice id="v00319"]
だから言ったじゃない。[p]

[reset_message_chara]

; ---- mary は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="mary" face="smile"]

#mary
[voice id="v00320"]
ふふ、面白い方たちが揃いましたね。[p]
#mary
[voice id="v00321"]
私も、荷物を置いてきます。[p]

[chara_hide name="mary"]

#
これで全員揃った。[p]
#
無事にお父さんの手がかりを見つけて、楽しく過ごせたらいい。[p]

#
一息ついていると、甘い香りと共に小出里亜が現れた。[p]

[chara_hide_all]

; ---- koderia は charapos で表示 → message_chara 不使用 ----
[charapos name="koderia" face="normal" num="0"]

#koderia
[voice id="v00322"]
皆様、お揃いでしょうか？[p]
#koderia
[voice id="v00323"]
これから、舞黒館の管理者である朱志香様よりご挨拶があります。[p]
#koderia
[voice id="v00324"]
それでは、朱志香様お願いします。[p]

[chara_hide_all]
@bg storage="event/guidance.png"


#jushika
[voice id="v00325"]
皆様、お待たせしました。[p]
#jushika
[voice id="v00326"]
改めて、舞黒館へようこそ。[p]

#jushika
[voice id="v00327"]
舞黒館は1930年に[ruby text="まい" ]舞[ruby text="くろ" ]黒[ruby text="ほう" ]邦[ruby text="む" ]夢が建てた洋館です。[p]

#jushika
[voice id="v00328"]
アールデコを基調とした美しい外観と広い庭園に囲まれています。[p]

#jushika
[voice id="v00329"]
庭園には数多くのハーブも植えられており、香り豊かなひと時を楽しめます。[p]

#jushika
[voice id="v00330"]
また、舞黒は遊び心が豊かで洋館にもいろんな仕掛けをしていたと聞いております。[p]

#jushika
[voice id="v00331"]
私は夫からここの管理を引き継いで、まだ半年になったばかり。[p]

#jushika
[voice id="v00332"]
至らぬ点もあるかと思いますが、皆様に楽しい機会をお届けできるよう、尽力いたします。[p]

#koderia
[voice id="v00333"]
それでは、長旅の疲れを癒やすティータイムといたしましょう。[p]
#koderia
[voice id="v00334"]
ダイニングへご案内します。[p]

[bg storage="dining.png" cross="true"]
; 13:00 → 13:10（ダイニングへの移動とセッティングで約10分経過）
[advance_time min=10]
[gage_draw place="舞黒館:ダイニング"]
@charapos name=jushika face=normal num=1
@charapos name=koderia face=normal num=2

; ---- koderia は charapos 表示中（bg変わっても非表示にされるまで有効）----
#koderia
[voice id="v00335"]
当館自慢の、オリジナルブレンドティーです。[p]

#
注がれた紅茶から、華やかな香りが立ち上る。[p]

; ---- mary は画面外（chara_hide済み）→ message_chara 使用 ----
[charapos name="mary" face="normal" num="3"]

#mary
[voice id="v00336"]
いい香り……。[p]
#mary
[voice id="v00337"]
でも、少し珍しい香りですね。これは……？[p]

[reset_message_chara]

; ---- koderia は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="koderia" face="smile"]

#koderia
[voice id="v00338"]
ハーブを数種類ブレンドしております。[p]
#koderia
[voice id="v00339"]
リラックス効果が高いんですよ。[p]

#mary
[voice id="v00340"]
まあ、素敵。[p]
#mary
[voice id="v00341"]
……いただきます。[p]

[mask]
; 13:10 → 14:00（ティータイムで約50分経過）
[advance_time min=50]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide name="mary"]
[mask_off]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00342"]
ご馳走様でした。[p]
#mahoru
[voice id="v00343"]
とても美味しかったです！[p]

[reset_message_chara]

; ---- koderia は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="koderia" face="smile"]

#koderia
[voice id="v00344"]
それは良かったです。[p]
#koderia
[voice id="v00345"]
この後は庭園でゆっくりしてください。近隣にも洋館がありますので見学するなら今のうちです。[p]
#koderia
[voice id="v00346"]
15時までは外へ通じる門を開放しておりますので、ぜひ散策してみてくださいね。[p]
#koderia
[voice id="v00347"]
また、本日はみなとみらいで大規模なイベントをやっております。[p]
#koderia
[voice id="v00348"]
港の見える丘公園より向こうへは規制がかかっているため、立ち入りできないので散策の際はお気を付けください。[p]

#koderia
[voice id="v00349"]
それでは、当館名物のメイフェア・ガーデンへ移動しましょう。[p]

[chara_hide_all]

[playse storage="drop.mp3" ]

; ---- mahoru は画面外 → message_chara 使用 ----
[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00350"]
あ、メアリーさん、何か落としましたよ。[p]

[reset_message_chara]

; ---- mary は charapos で表示 → message_chara 不使用 ----
[charapos name="mary" face="surprised" num="0"]

#mary
[voice id="v00351"]
あ、ペンダントが外れて落ちたのね。[p]
#mary
[voice id="v00352"]
気づいてくれてありがとうございます。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00353"]
今、拾いますね。[p]

[pre_resonance]

[chara_mod name="mahoru" face="panic"]

#mahoru
[voice id="v00354"]
あれ……？[p]
#mahoru
[voice id="v00355"]
なに……これ……？[p]

[reset_message_chara]

#
ペンダントに触れた瞬間、頭の中にノイズが走った。[p]
#
目の前の景色は揺れ、まるで世界が崩れ落ちるような感覚に襲われた。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v00356"]
うっ……！[p]
#mahoru
[voice id="v00357"]
一体……これは……？[p]

[reset_message_chara]

; ---- mary は charapos 表示中 → message_chara 不使用 ----
[chara_mod name="mary" face="surprised"]

#mary
[voice id="v00358"]
真歩流さん、大丈夫ですか？[p]
#mary
[voice id="v00359"]
顔が真っ青ですよ。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v00360"]
（何が起きたんだろう……？）[p]
#mahoru
[voice id="v00361"]
（落ち着いて、深呼吸しよう）[p]
#mahoru
[voice id="v00362"]
（スー、ハー。スーハー……）[p]

[reset_message_chara]

[chara_mod name="mahoru" face="normal"]
[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00363"]
もう、大丈夫です！[p]
#mahoru
[voice id="v00364"]
ご心配おかけしました。[p]

[reset_message_chara]

[chara_mod name="mary" face="thinking"]

#mary
[voice id="v00365"]
何事もなくてよかったです。[p]
#mary
[voice id="v00366"]
あの、真歩流さん、もしかして……。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00367"]
何ですか？[p]

[reset_message_chara]

[chara_mod name="mary" face="smile"]

#mary
[voice id="v00368"]
いえ、何でもありません。[p]
#mary
[voice id="v00369"]
体調が悪くなったらいつでも言ってくださいね。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00370"]
わかりました！[p]
#mahoru
[voice id="v00371"]
（さっきのは一体何だったんだろう……？）[p]

[reset_message_chara]

[fadeoutbgm time="1000"]

[chara_mod name="mary" face="no_say"]

#mary
[voice id="v00372"]
……。[p]

[chara_hide_all]

[playse storage="walk.mp3" sprite_time="00:00-00:02"]

[wait time="2000"]

[iscript]
f.status["chara_07"].owned = true;
f.status["chara_08"].owned = true;
f.status["chara_11"].owned = true;
[endscript]

[notify_profile ids="chara_07,chara_08,chara_11"]

[image storage="../bgimage/dark.png" time="1000"]

[freeimage layer="1"]

[chapter_end]

[jump storage="scene2.ks" target="start"]

*itemlist
[call storage="system/item_list.ks"]
[s]
