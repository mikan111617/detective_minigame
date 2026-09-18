;==== bad_end.ks ====
; シーン：バッドエンド・全てが灰になる

*bad_end_start
@clearstack
;----------------------------------------------------------
; 既に見たことのあるエンディングなら、スタッフロールまで飛ばせる
;----------------------------------------------------------
[iscript]
tf.ending_seen = (window.ACH && window.ACH.has("end_bad")) ? 1 : 0;
[endscript]
[if exp="tf.ending_seen == 1"]
[cm]
[clearfix]
[free_layer_image]
[position layer="message0" page=fore visible=true]
[bg storage="dark.png" time=600]
#
このエンディングは一度見ています。[p]
#
スタッフロールまで飛ばしますか？[p]

[glink color="bth13_dk" text="このまま読む"           target="*bad_end_read"]
[glink color="bth13_dk" text="スタッフロールまで飛ばす" target="*bad_end_skip"]
[s]
[endif]

*bad_end_read
[cm]
[clearfix]
[free_layer_image]
[show_menu]
; 後日譚なので場所名と時刻は出さない
[hud_hide]
[position layer="message0" page=fore visible=true]
[call storage="system/chara.ks"]
[bg storage="living_night.png" time=1000]
[playbgm storage="Incident_Occurred.mp3" loop=true]
[chara_hide_all layer="message0"]

; キャラクター表示（警部のみ num=0）
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#
真歩流は、集めた証拠を見つめていた。[p]
#
だが――。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03132"]
（……わからない。どうしたらいいのか？）[p]

[reset_message_chara]
#
真歩流の頭の中は混乱していた。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03133"]
私……分かりません……分からなくなっちゃいました。[p]

[reset_message_chara]
#
真歩流は力なく答えた。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03134"]
（どこに毒があるの……？ 誰が……誰が……犯人なの……？）[p]

[reset_message_chara]
#
思考は空回りして、物事を余計に複雑に見せていた。[r]
#
人を信じることも、疑うことも、もう訳が分からなくなっていた。[p]

; 和人の報告（警部と和人 num=2, num=1）
[chara_hide_all]
[charapos name="reido" face="normal" num="2"]
[charapos name="kazuto" face="pursue" num="1"]

#kazuto
[voice id="v03135"]
愛理の容体がさらに悪化している。[p]

#kazuto
[voice id="v03136"]
救急車はまだ到着しないのか。[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03137"]
そんな……。嫌よ……[p]

[reset_message_chara]

#kazuto
[voice id="v03138"]
諦めるな。お前の妹はまだ必死に戦っているんだぞ。[p]

#
和人の言葉にハッとする。[p]

[message_chara name="mahoru" face="anger"]

#mahoru
[voice id="v03139"]
そうよ……愛理……絶対に助けるんだから。[p]

[reset_message_chara]
#
崩れかけた心を何とか持ち直す。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v03140"]
（私が……私がこのまま何もしなければ……）[p]
#mahoru
[voice id="v03141"]
（愛理は……死んでしまう……）[p]

[reset_message_chara]
#reido
[voice id="v03142"]
真白さん、私たちが全力で捜索します。部下たちの捜査が進めば証拠も見つかるでしょう。もう少し、耐えてください。[p]

[message_chara name="mahoru" face="anger"]

#mahoru
[voice id="v03143"]
私も頑張ります。[p]

[reset_message_chara]


; 火事の発生
[fadeoutbgm]
[wait time=1000]

; メアリー表示（他は一旦消すか、焦点を合わせる）
[chara_hide_all]
[charapos name="mary" face="surprised" num="0"]

#mary
[voice id="v03144"]
あっ……煙が……！[p]

#
メアリーが叫んだ。[r]
#
サンルームの方から、煙が立ち上っていた。[p]

; 警部表示
[chara_hide_all]
[charapos name="reido" face="order" num="0"]
[playbgm storage="fire_crisis.mp3"]

#reido
[voice id="v03145"]
火事だ！[p]
#reido
[voice id="v03146"]
全員、外へ！ 早く！[p]

#
警察官たちが動き出した。[r]
#
真歩流は唖然とした。[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03147"]
火事……？[p]

[reset_message_chara]
#
サンルームから、赤い炎が見え始めた。[r]
#
炎は急速に広がっていく。[p]

#警察
早く逃げてください！[p]

#
警察官が叫んだ。[r]
#
朱志香、珠璃、メアリーが次々と外へ逃げ出した。[p]
#
真歩流は立ち尽くしていた。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03148"]
愛理……愛理がまだ……！[p]

[reset_message_chara]
#
真歩流は寝室へと駆け出した。[p]

#reido
[voice id="v03149"]
真白さん！ 危ない！[p]

#
零度警部が制止しようとしたが、真歩流は止まらなかった。[p]

[chara_hide_all]
[quake count=5 time=300 hmax=20 vmax=20]

#
廊下はすでに煙で充満していた。[r]
#
真歩流は咳き込みながら、寝室へと向かった。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03150"]
愛理！ 愛理！！[p]

[reset_message_chara]
[bg storage="room_fire.png" time=500]
[chara_hide_all]

; 寝室に誰もいない（愛理はベッド、真歩流はメッセージのみ）
[message_chara name="mahoru" face="cry"]

#
寝室のドアを開けると、愛理がベッドに横たわっていた。[p]

#mahoru
[voice id="v03151"]
愛理！ 起きて！[p]

[reset_message_chara]
#
真歩流は愛理を抱き起こそうとした。[r]
#
だが――。[p]

[quake count=10 time=1000 hmax=30 vmax=30]

#
その時、天井から何かが落ちてきた。[r]
#
炎に包まれた梁が、真歩流と愛理の間に落ちた。[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03152"]
きゃあ！[p]

[reset_message_chara]
#
真歩流は後ろに飛びのいた。[r]
#
炎が二人を隔てた。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03153"]
愛理！ 愛理！！[p]

[reset_message_chara]
#
真歩流は叫んだ。[r]
#
だが、炎は激しく燃え上がり、近づくことができなかった。[p]

#reido
[voice id="v03154"]
真白さん！ もう無理です！ 逃げてください！[p]

#
階下から微かに零度警部の声が聞こえた。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03155"]
いや！ 愛理を置いていけない！[p]

[reset_message_chara]
#
真歩流は必死に叫んだ。[r]
だが、炎はどんどん広がっていく。[r]
#
煙で息ができなくなってきた。[p]

; 和人登場
[charapos name="kazuto" face="pursue" num="0"]

#kazuto
[voice id="v03156"]
真白！[p]

#
和人が部屋へ駆け込んできた。[p]

[message_chara name="mahoru" face="cry"]

#mahoru
[voice id="v03157"]
愛理を！ 愛理を助けなきゃ！[p]

[reset_message_chara]
#kazuto
[voice id="v03158"]
俺が運ぶから、お前は道を確保してくれ。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v03159"]
ありがとう……和人。[p]

[reset_message_chara]
#
和人は愛理を担いで、三人は廊下に出た。[p]

#
火はものすごい勢いで建物を燃やしている。[p]

#
急いで1階へと降りた。[p]
[mask]
[chara_hide_all]
[bg storage="hallway_burning.png"]
[mask_off]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03160"]
愛理、もう少しで外だからね。[p]

[reset_message_chara]
#
その時、大きな崩れる音が聞こえてきた。[p]

#kazuto
[voice id="v03161"]
真白！[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03162"]
きゃあ！[p]

[reset_message_chara]

[quake count=5 time=300 hmax=20 vmax=20]
@bg storage="hallway_burning_after.png"

#
突き飛ばされ、崩れ落ちてきた床に潰されるのを何とか避けることができた。[p]

@bg storage="hallway_burning_after.png"

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03163"]
う、うう。[p]

#mahoru
[voice id="v03164"]
愛理！ 和人！ 大丈夫！[p]

[reset_message_chara]
#kazuto
[voice id="v03165"]
……ああ。[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03166"]
良かった。[p]

#mahoru
[voice id="v03167"]
すぐに行くから待ってて。[p]

[reset_message_chara]
#kazuto
[voice id="v03168"]
来るな！[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03169"]
何言ってるの？[p]

#mahoru
[voice id="v03170"]
置いていけるわけないじゃない！[p]

[reset_message_chara]
#kazuto
[voice id="v03171"]
悪かった。[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v03172"]
え？[p]

[reset_message_chara]
#kazuto
[voice id="v03173"]
お前に冷たく言ったこと……。[p]

; 愛

#airi
[voice id="v03174"]
お姉ちゃん……。[p]

[message_chara name="mahoru" face="cry"]

#mahoru
[voice id="v03175"]
愛理！ 大丈夫なの？[p]

[reset_message_chara]

#airi
[voice id="v03176"]
お姉ちゃん……。[p]

#airi
[voice id="v03177"]
今までありがとう。[p]

#airi
[voice id="v03178"]
いっぱい、いろんなことをして、本当に楽しかったよ。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03179"]
ちょっと、何を言っているの！？[p]

#mahoru
[voice id="v03180"]
今行くから！[p]

[reset_message_chara]
#
愛理を急いで助けたいが、崩れてきた天井で床が崩れて思うように進めない。[p]

; 警部登場
[charapos name="reido" face="rescue" num="0"]

#reido
[voice id="v03181"]
皆さんけがはありませんか？[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03182"]
警部さん！[p]

#mahoru
[voice id="v03183"]
愛理と和人が！[p]

[reset_message_chara]
#reido
[voice id="v03184"]
愛理さん、徐音さん、けがはありませんか？[p]
#reido
[voice id="v03185"]
今応援を……。[p]

#kazuto
[voice id="v03186"]
警部さん……真白を連れて早く外へ。[p]

#reido
[voice id="v03187"]
徐音さん……。[p]

#kazuto
[voice id="v03188"]
早く、お願いします！[p]

[chara_mod name="reido" face="regrettable"]

#reido
[voice id="v03189"]
……。[p]

#reido
[voice id="v03190"]
すぐにレスキュー隊が来ます。[p]

#reido
[voice id="v03191"]
それまで辛抱してください。[p]

#reido
[voice id="v03192"]
行きますよ、真白さん。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03193"]
警部さん、何を言っているんですか？[p]

#mahoru
[voice id="v03194"]
愛理が……まだ中にいるんですよ！[p]

[reset_message_chara]

#reido
[voice id="v03195"]
今の我々に彼らを救う方法はありません。[p]

#reido
[voice id="v03196"]
さあ、急いで！[p]

#
真歩流は抵抗したが、零度警部に引きずられて外へと連れ出された。[p]

[message_chara name="mahoru" face="panic"]

#mahoru
[voice id="v03197"]
いや！ 愛理！ 愛理いいいい！！[p]

[mask]
[bg storage="event/kazuto_last.png"]
[reset_message_chara]
[chara_hide_all]

[mask_off]

#kazuto
[voice id="v03198"]
すまないな。[p]

#kazuto
[voice id="v03199"]
助けられなくて。[p]

#airi
[voice id="v03200"]
どうして謝るの……。[p]

#airi
[voice id="v03201"]
お礼を言うのは私だよ……。[p]

#airi
[voice id="v03202"]
お姉ちゃんを助けてくれてありがとう……。[p]

#airi
[voice id="v03203"]
ああ、もっといろんなことを話したかったな……。[p]

#airi
[voice id="v03204"]
和人さん、彼女はいるの？[p]

#kazuto
[voice id="v03205"]
いや、いない。[p]

#airi
[voice id="v03206"]
じゃあ……さ、私、和人さんの彼女になってもいいかな……？[p]

#kazuto
[voice id="v03207"]
……ああ、いいよ。[p]

#kazuto
[voice id="v03208"]
だから、安心しろ。[p]

#kazuto
[voice id="v03209"]
最期まで一緒だからな。[p]

#airi
[voice id="v03210"]
ありが……とう。[p]

#airi
[voice id="v03211"]
和人さ……ん。[p]

#airi
[voice id="v03212"]
……。[p]

#kazuto
[voice id="v03213"]
……。[p]

#kazuto
[voice id="v03214"]
……母さん。[p]

#kazuto
[voice id="v03215"]
ごめん。[p]

#kazuto
[voice id="v03216"]
俺、結局誰も救えなかったよ……。[p]

; 外観へ移動
[mask]
[bg storage="home_burning.png" time=0]
[chara_hide_all]
[mask_off]

#
真歩流の叫びが、夜空に響いた。[p]
#
洋館は、激しく燃え上がっていた。[p]
#
真歩流は、呆然と炎を見つめていた。[p]

[message_chara name="mahoru" face="cry"]

#mahoru
[voice id="v03217"]
愛理……[p]

[reset_message_chara]
#
涙が止まらなかった。[p]
やがて、消防車が到着したが――。[r]
#
すでに、館の大部分が炎に包まれていた。[p]
#
消火活動が始まったが、火の勢いは強かった。[p]

[message_chara name="mahoru" face="cry"]

#mahoru
[voice id="v03218"]
（何もできなかった……）[p]
#mahoru
[voice id="v03219"]
（お父さんの手がかりを見つけることも。愛理を救うことも）[p]
#mahoru
[voice id="v03220"]
（全て――失敗した）[p]

[reset_message_chara]
#
火事は、明け方近くになってようやく鎮火した。[r]
#
洋館は、ほぼ全焼していた。[p]
消防隊員が館内を調べ、二人の遺体が発見された。[r]
#
愛理と、和人だった。[p]

#
真歩流は、その場に崩れ落ちた。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03221"]
愛理……愛理……[p]
[reset_message_chara]

#
何度も妹の名を呼んだ。[r]
#
だが、もう返事は返ってこなかった。[p]

; 警部表示
[charapos name="reido" face="apologize" num="0"]

#reido
[voice id="v03222"]
真白さん……[p]

#reido
[voice id="v03223"]
大変……申し訳ありません。[p]

#reido
[voice id="v03224"]
ご家族を……お助けすることができませんでした……[p]

[message_chara name="mahoru" face="dispair"]

#mahoru
[voice id="v03225"]
私は……私は……[p]

#mahoru
[voice id="v03226"]
何もできなかった……。[p]
#mahoru
[voice id="v03227"]
いやあああああああああああああああああああああああああああああああああああああ。[p]

[reset_message_chara]
#
真歩流は声がかれるまで叫び続け、涙が枯れるまで泣き続けた。[p]

#
その後の調査で、犯人は特定できなかった。[r]
#
証拠の多くは炎に焼かれて失われた。[p]

[chara_hide_all]
[fadeoutbgm]

; エピローグ：数週間後
[mask time=2000]
[bg storage="mahoru_room_dark.png" time=0]
[chara_hide_all]
[reset_message_chara]
[mask_off time=2000]

#
真歩流は、愛理の葬儀を終えた後、自分の部屋に引きこもった。[r]
#
誰が訪ねてきても、ドアを開けることはなかった。[p]

#
数か月後。[p]
真歩流は、徐々に部屋から出るようになった。[r]
#
だが、その目は虚ろだった。[p]
笑うことも、泣くこともできなくなっていた。[r]
#
ただ、毎日、愛理の墓の前で過ごした。[p]

[message_chara name="mahoru" face="dispair"]

#mahoru
[voice id="v03228"]
ごめんね、愛理……[p]

[reset_message_chara]

; エピローグ：冬
[bg storage="rainy_day.png" time=2000]

#
季節が変わり、冬が来た。[p]
真歩流は相変わらず、愛理の墓の前で過ごしていた。[r]
#
雪が降り始めても、動こうとしなかった。[p]

[message_chara name="mahoru" face="dispair"]

#mahoru
[voice id="v03229"]
会いたいよ……。愛理……[p]

[reset_message_chara]
#
凍えた手で、墓石に触れた。[p]
洋館で起きた惨劇の真相は、炎と共に消えた。[r]
#
犯人も、動機も、全てが謎のまま――。[p]
ただ、真歩流の心に残ったのは――。[r]
#
愛理を失った悲しみと、自分への怒りだけだった。[p]

;エンディングクレジット
*bad_end_skip
[eval exp="f.normalend = 0"]
[eval exp="f.trueend = 0"]
[eval exp="f.badend = 1"]
[cm]
[clearfix]
[free_layer_image]
[jump storage="system/ending_credit.ks" target="*ending_credits"]
