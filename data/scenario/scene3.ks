;=========================================
; scene3.ks
; シーン：お茶会準備～お茶会開始
;
;   お茶会が始まるまでは時刻表示を伏せている
;   （[gage_draw ... hide_time="true"]／完全な時系列ではないため）。
;   お茶会開始の [set_time hour=15 min=30] で表示を戻す。
;=========================================

*start
@clearstack
[cm]
[clearfix]
[freeimage layer="1"]
[showmenubutton]
[hud_draw]
[playbgm storage="Eternal_Peace.mp3"]

; ルートBの仕掛けで舞黒邦夢の書簡を発見したか
[eval exp="f.s3_kunimu_letter = 0"]

;----------------------------------------------------------
; 0. リビング：どうしてこの館で
;----------------------------------------------------------
[mask]
[bg storage="living.png" time=1000]
[gage_draw place="舞黒館:リビング" hide_time="true"]
[mask_off]

[chara_hide_all]

#
リビングのソファに腰を下ろすと、天井の高さがよく分かった。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00406"]
#mahoru
（お父さんは、どうしてこの館の名前を書き残したんだろう）[p]

[voice id="v00407"]
#mahoru
（そもそも、この宿泊イベントって——）[p]
[reset_message_chara]

#
最後に見た父の背中を思い出す。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00408"]
#mahoru
（……）[p]
[reset_message_chara]

#
顔を上げると、朱志香がお茶会の準備を進めているのが見えた。[p]

[charapos name="jushika" face="normal" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00409"]
#mahoru
朱志香さん。ひとつ、聞いてもいいですか？[p]
[reset_message_chara]

#jushika
[voice id="v00410"]
#jushika
ええ、なんでしょう。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00411"]
#mahoru
どうして、この館で宿泊イベントを開こうと思ったんですか？[p]
[reset_message_chara]

#jushika
[voice id="v00412"]
#jushika
あら、真面目なご質問ですね。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v00413"]
#jushika
この館を、これからも残していきたいのです。[p]
[voice id="v00414"]
#jushika
そのためには、人に来ていただかないと始まりません。[p]

#jushika
[voice id="v00415"]
#jushika
でも、ただ古い建物を見せるだけでは、一度きりで終わってしまいます。[p]
[voice id="v00416"]
#jushika
何度も足を運んでいただける形はないものかと、ずっと考えていました。[p]

#jushika
[voice id="v00417"]
#jushika
新しい使い道を探す——その第一歩が、今回の宿泊イベントです。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00418"]
#mahoru
そうなんですね。[p]

[voice id="v00419"]
#mahoru
（大変なんだなあ、こういうのって）[p]
[reset_message_chara]

#jushika
[voice id="v00420"]
#jushika
おかげさまで、皆様には楽しんでいただけているようですし。[p]

#jushika
[voice id="v00421"]
#jushika
それでは、ごゆっくり楽しんでください。[p]

#
朱志香はリビングを後にしながら言った。[p]

[chara_hide_all]

;----------------------------------------------------------
; 1. キッチン：お茶会準備と秘密のつまみ食い
;----------------------------------------------------------
[mask]
[bg storage="kitchen.png" time=1000]
; scene2 末尾 14:55 → 15:05（移動・準備で+10分）
[advance_time min=10]
[gage_draw place="舞黒館:キッチン" hide_time="true"]
[mask_off]

[chara_hide_all]
[charapos name="jushika" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]

#jushika
[voice id="v00422"]
#jushika
カップとソーサーの準備はいいかしら？[p]
[voice id="v00423"]
#jushika
私はこのティーバッグを用意するわ。[p]
[voice id="v00424"]
#jushika
この洋館の雰囲気に合わせて、特別にイギリスから取り寄せた茶葉なの。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00425"]
#koderia
はい、朱志香様。カップの準備もばっちりです。[p]
[voice id="v00426"]
#koderia
とても良い香りの茶葉です。皆様もきっと喜ばれますね。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v00427"]
#jushika
ええ、そうね。[p]
[voice id="v00428"]
#jushika
……あら、もう15時を過ぎたわね。[p]
[voice id="v00429"]
#jushika
正面の門を閉めてくるわ。[p]
[voice id="v00430"]
#jushika
キッチンのことは任せたわよ。[p]

#koderia
[voice id="v00431"]
#koderia
畏まりました。いってらっしゃいませ。[p]

[chara_hide name="jushika"]

; メイド一人になるので中央配置へ
[charapos name="koderia" face="normal" num="0"]

#
朱志香がキッチンを後にすると、小出里亜はふうっと息を吐き、戸棚からこっそりと焼き菓子を取り出した。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00432"]
#koderia
ふふっ、少しだけ味見を……ん、美味しい。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00433"]
#mahoru
あ！ 小出里亜さん、つまみ食いしてる！[p]
[reset_message_chara]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v00434"]
#koderia
ひゃあっ！？[p]

#
手伝いをしようとキッチンにやってきた私たちに見つかり、小出里亜は肩をびくっと跳ねさせた。[p]

; キャラ配置（愛理、珠璃、メアリーも登場）
[chara_hide_all]
[charapos name="koderia" face="surprised" num="1"]
[charapos name="airi" face="normal" num="2"]
[charapos name="juri" face="smile" num="3"]
[charapos name="mary" face="normal" num="4"]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00435"]
#mahoru
ごめんなさい、驚かせちゃって。[p]
[voice id="v00436"]
#mahoru
暇だったから、皆でお手伝いしようと思って来たんだけど……。[p]
[reset_message_chara]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00437"]
#koderia
も、もう……真白様たちったら。[p]
[voice id="v00438"]
#koderia
見られてしまったからには仕方ありませんね。[p]
[voice id="v00439"]
#koderia
皆様には内緒にしていただく代わりに、このお菓子をお配りしますね。[p]

#airi
[voice id="v00440"]
#airi
ふふ、ありがとうございます。[p]
[voice id="v00441"]
#airi
とても美味しいクッキーですね。[p]

#juri
[voice id="v00442"]
#juri
本当ね。上品な甘さで紅茶に合いそう。[p]
[voice id="v00443"]
#juri
……ところでメアリーさん。あなたは日本に来て、どれくらいになるの？[p]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v00444"]
#mary
私ですか？[p]
[voice id="v00445"]
#mary
そうですね……2か月ほど前から滞在しています。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v00446"]
#airi
2か月で、そんなに日本語が流暢なんですか？[p]
[voice id="v00447"]
#airi
一体、誰から教わったんでしょうか。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00448"]
#mary
祖母から教わったんです。[p]
[voice id="v00449"]
#mary
私の祖母は、若いころ日本で過ごしたことがあり、日本語が上手なんですよ。[p]
[voice id="v00450"]
#mary
なので、小さい頃から、日本の言葉を教えてもらっていたんです。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00451"]
#mahoru
そうだったんですね！[p]
[voice id="v00452"]
#mahoru
日本には、どうして長期間滞在しているんですか？ 観光とか？[p]
[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v00453"]
#mary
いえ……実は、親戚に会うために来たんです。[p]
[voice id="v00454"]
#mary
日本のどこかにいるはずなんですけど、祖母の代から交流が途絶えてしまっていて。[p]
[voice id="v00455"]
#mary
今は手がかりを探している途中なんです。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00456"]
#mahoru
どうして、交流が途絶えちゃったんですか？[p]
[reset_message_chara]

#mary
[voice id="v00457"]
#mary
当時は大きな戦争があったりして、イギリスと日本でなかなか行き来ができなかったみたいです。[p]
[voice id="v00458"]
#mary
戦後は戦後で復興に忙しかったり。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00459"]
#koderia
でも、なんだかロマンチックなお話ですね！[p]
[voice id="v00460"]
#koderia
遠い異国の地で、運命の出会いを探すなんて……まるで恋を求める恋愛小説のようですね。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00461"]
#mary
ふふふ……。[p]
[voice id="v00462"]
#mary
確かにそうかもしれませんね。[p]
[voice id="v00463"]
#mary
会いたいという気持ちは恋にも近いかもしれません。[p]

#koderia
[voice id="v00464"]
#koderia
おお、いいですね～。[p]
[voice id="v00465"]
#koderia
実は私にも、意中の相手がいるんです。[p]
[voice id="v00466"]
#koderia
でも、あと一歩のところで恋仲が進展しなくて……やきもきしているんです。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v00467"]
#airi
えっ、小出里亜さんに好きな人が？[p]
[voice id="v00468"]
#airi
相手はどんな人なんですか！[p]

#koderia
[voice id="v00469"]
#koderia
ちょっと変わっていますけど、面白い人ですよ。[p]
[voice id="v00470"]
#koderia
余裕がある感じって言えばいいんでしょうか。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v00471"]
#airi
あの、私……恋愛に憧れはあるんですけど、どうやってお付き合いすればいいのか分からなくて。[p]
[voice id="v00472"]
#airi
どうしたら燃えるような恋ができるんですか？[p]

#juri
[voice id="v00473"]
#juri
あら、愛理さんったら可愛い悩みね。[p]
[voice id="v00474"]
#juri
燃えるような恋……か。[p]

#airi
[voice id="v00475"]
#airi
珠璃さんは叡留久さんとどうやってお付き合いしたんですか！[p]
[voice id="v00476"]
#airi
私、早く恋をしたいんです！[p]

[chara_mod name="juri" face="surprised"]
#juri
[voice id="v00477"]
#juri
あらあら、すごい積極的ね。[p]
[voice id="v00478"]
#juri
恋に恋している感じね。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00479"]
#juri
でも、そうね。[p]
[voice id="v00480"]
#juri
焦ってはダメよ。必ず本当に心から好きっていう人が現れるわ。[p]
[voice id="v00481"]
#juri
その時になったら、全力でぶつかっていけばいいのよ。[p]

#koderia
[voice id="v00482"]
#koderia
珠璃様の仰る通りですね。[p]
[voice id="v00483"]
#koderia
私も、もっと真っ直ぐにぶつかってみようかしら。[p]
[voice id="v00484"]
#koderia
真歩流様は恋はしていないんですか？[p]

[message_chara name="mahoru" face="aho"]
#mahoru
[voice id="v00485"]
#mahoru
あ、えーと。[p]

[voice id="v00486"]
#mahoru
鯉は好きです。[p]
[reset_message_chara]

[playse storage="door_open.mp3"]

#
その時、玄関の方から、散歩に行っていた和人と叡留久が帰ってくる音が聞こえた。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v00487"]
#koderia
あ、男性陣がお戻りになったようですね。[p]
[voice id="v00488"]
#koderia
女子の秘密の時間はここまでにして、お茶会の準備を始めますね。[p]
[voice id="v00489"]
#koderia
皆さんはゆっくり休んでいてください。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00490"]
#mahoru
はーい。それじゃあ愛理、リビングに行こうか。[p]
[reset_message_chara]

; 経路Aでは、お茶会までの短い時間を自由に過ごす。
; 同じ場所でも、時間が進めばそこにいる人物が変わる。
; 事件解決に必須の「珠璃が席順とカップを決める場面」は、この後に必ず見る。
; 真エンドの伏線になる朱志香と小出里亜の会話もプレイヤーには必ず提示するが、
; 真歩流本人はその会話を見聞きしていない。
[jump cond="f.route_b == 0" target="*s3a_living_start"]

;----------------------------------------------------------
; 1-b. 廊下：戻ってきた二人（経路B）
;----------------------------------------------------------
[mask effect="fadeInDown"]
[bg storage="hallway.png" time=1000]
[gage_draw place="舞黒館:廊下" hide_time="true"]
[chara_hide_all]
[mask_off]

[charapos name="kazuto" face="thinking" num="0"]

#
散歩から戻った和人は、廊下の窓際で足を止めていた。[p]
#
窓から庭園の方に視線を向ける。[p]

#kazuto
[voice id="v00491"]
#kazuto
……。[p]

#
しばらく眺めた後、物思いにふけるように考え事を始めていた。[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="0"]

#
少し離れた柱の陰では、叡留久が窓の外を眺めていた。[p]

#
そこへ、盆を抱えた小出里亜が通りかかった。[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]

#koderia
[voice id="v00492"]
#koderia
叡留久様。お飲み物をお持ちしましょうか。[p]

#eruku
[voice id="v00493"]
#eruku
いや、結構だ。……ああ、そうだ。[p]
[voice id="v00494"]
#eruku
庭に白い花が咲いていただろう。あれは何という花だい？[p]

#koderia
[voice id="v00495"]
#koderia
あの白いセージですか？[p]

[voice id="v00496"]
#koderia
あれは市場には出回っていないものだと聞いています。[p]

[chara_mod name="eruku" face="surprised2"]
#eruku
[voice id="v00497"]
#eruku
出回っていない？[p]

#koderia
[voice id="v00498"]
#koderia
はい。庭師の方が特別に選んで植えたものだと。[p]

[chara_mod name="eruku" face="normal"]
#eruku
[voice id="v00499"]
#eruku
——ありがとう、助かるよ。[p]

#koderia
[voice id="v00500"]
#koderia
はい。また、何かありましたらいつでも……。[p]

#
小出里亜は一礼すると、盆を抱え直して廊下を戻っていった。[p]

[chara_hide_all]
[charapos name="eruku" face="thinking" num="0"]

#
その背中を見送ってから、叡留久はもう一度スマートフォンを取り出した。[p]
#
短く打ち込んで、画面を伏せる。[p]

[chara_hide_all]

;----------------------------------------------------------
; 2. 珠璃と和人
;    経路A … サンルーム。珠璃は先に来ていて、和人が散歩から戻ってくる
;    経路B … 廊下。散歩から早く戻った和人と、向かう途中の珠璃が鉢合わせる
;----------------------------------------------------------
[mask effect="fadeInDown"]
; 移動 +5分 → 15:10
[advance_time min=5]
[chara_hide_all]

[jump cond="f.route_b == 1" target="*s3_hall_juri"]


;── 経路A：サンルーム ──────────────────────
*s3_sunroom_juri
[bg storage="sunroom.png" time=1000]
[gage_draw place="舞黒館:サンルーム" hide_time="true"]
[mask_off]

#
女子会が終わった後、サンルームにて。[p]

[charapos name="juri" face="normal" num="0"]

#
珠璃は一人、サンルームの椅子に腰掛けて外の景色を眺めていた。[p]
#
そこへ、散歩から戻った和人がふらりと足を踏み入れた。[p]

[chara_hide_all]
[charapos name="juri" face="normal" num="1"]
[charapos name="kazuto" face="normal" num="2"]

#juri
[voice id="v00501"]
#juri
あら、和人君。[p]
[voice id="v00502"]
#juri
おかえりなさい。叡留久とはどんな話をしたの？[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00503"]
#kazuto
……あんたの旦那の、仕事の話だ。[p]

#juri
[voice id="v00504"]
#juri
……やっぱりね。[p]
[voice id="v00505"]
#juri
あの人は本当に仕事が大好きだから。[p]
[voice id="v00506"]
#juri
悪気はないのよ。だから、あまり悪く思わないでね。[p]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v00507"]
#kazuto
別に、何とも思っていない。[p]
[voice id="v00508"]
#kazuto
ただ、薬を扱うからには、気をつけてほしいだけだ。[p]

[chara_mod name="juri" face="thinking"]
#juri
[voice id="v00509"]
#juri
……何か気になることでもあるの？[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00510"]
#kazuto
母親が薬剤師だったからだ。[p]

[voice id="v00511"]
#kazuto
立派な人だったが、薬で命を落とした。[p]

#
和人の短い言葉に込められた重苦しい響きに、珠璃は目を見開いた。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00512"]
#juri
……そう。[p]
[voice id="v00513"]
#juri
ごめんなさいね、嫌な思いをさせちゃったかしら。[p]

#kazuto
[voice id="v00514"]
#kazuto
いや、そんなことはない。[p]
[voice id="v00515"]
#kazuto
薬に過敏になっているのは俺だから……。[p]

#juri
[voice id="v00516"]
#juri
……。[p]
[voice id="v00517"]
#juri
私はそろそろリビングへ行くわ。[p]
[voice id="v00518"]
#juri
ここでゆっくりするといいわよ。[p]

#
珠璃は短く謝罪すると、サンルームを後にした。[p]

[chara_hide name="juri"]
[charapos name="kazuto" face="normal" num="0"]

#
一人残された和人は、ふと視線を落とした。[p]
#
サンルームの隅にある観葉植物の鉢。[p]
#
その周りの床がほんのり濡れているように見えた。[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00519"]
#kazuto
（……誰かが水でもやったのか）[p]

#
和人はそれ以上気に留めることなく、サンルームに留まって一人考え事に沈んだ。[p]

[chara_hide_all]
[jump target="*s3a_living_talk"]


;── 経路B：廊下 ────────────────────────────
*s3_hall_juri
[bg storage="hallway.png" time=1000]
[gage_draw place="舞黒館:廊下" hide_time="true"]
[mask_off]

#
女子会が終わった後、一階の廊下で。[p]

[charapos name="juri" face="normal" num="0"]

#
珠璃はサンルームの方へ足を向けていた。[p]

#
——そこへ、正面から足音が近づいてきた。[p]

[chara_hide_all]
[charapos name="juri" face="surprised" num="1"]
[charapos name="kazuto" face="normal" num="2"]

#
散歩から戻ってきた和人と、ちょうど鉢合わせる形になった。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00520"]
#juri
あら、和人君。[p]
[voice id="v00521"]
#juri
ずいぶん早いお帰りね。叡留久とはどんな話をしたの？[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00522"]
#kazuto
……あんたの旦那の、仕事の話だ。[p]

#juri
[voice id="v00523"]
#juri
……やっぱりね。[p]
[voice id="v00524"]
#juri
あの人は本当に仕事が大好きだから。[p]
[voice id="v00525"]
#juri
悪気はないのよ。だから、あまり悪く思わないでね。[p]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v00526"]
#kazuto
別に、何とも思っていない。[p]
[voice id="v00527"]
#kazuto
ただ、薬を扱うからには、気をつけてほしいだけだ。[p]

[chara_mod name="juri" face="thinking"]
#juri
[voice id="v00528"]
#juri
……何か気になることでもあるの？[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00529"]
#kazuto
母親が薬剤師だったからだ。[p]

[voice id="v00530"]
#kazuto
立派な人だったが、薬で命を落とした。[p]

#
和人の短い言葉に込められた重苦しい響きに、珠璃は目を見開いた。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00531"]
#juri
……そう。[p]
[voice id="v00532"]
#juri
ごめんなさいね、嫌な思いをさせちゃったかしら。[p]

#kazuto
[voice id="v00533"]
#kazuto
いや、そんなことはない。[p]
[voice id="v00534"]
#kazuto
薬に過敏になっているのは俺だから……。[p]

#
珠璃は短く謝罪すると、和人の背後——サンルームの扉の方へ、ちらりと目をやった。[p]

#juri
[voice id="v00535"]
#juri
……。[p]
[voice id="v00536"]
#juri
私はリビングへ行くわ。[p]
[voice id="v00537"]
#juri
和人君は、ゆっくりしていくといいわよ。[p]

#
そう言って、珠璃は来た廊下を戻っていった。[p]

[chara_hide_all]
[charapos name="kazuto" face="normal" num="0"]

#
一人になった和人はサンルームへ足を運んだ。[p]

[mask time=400]
[bg storage="sunroom.png" time=0]
[gage_draw place="舞黒館:サンルーム" hide_time="true"]
[mask_off time=400]

#
午後の光が差し込むだけの、静かな部屋だった。[r]
#
隅には大きな観葉植物の鉢。[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00538"]
#kazuto
（……静かだな）[p]

#
和人はそのままサンルームに留まり、一人考え事に沈んだ。[p]

[chara_hide_all]

*s3_after_juri
;----------------------------------------------------------
; 3. キッチン：朱志香と小出里亜の真意
;----------------------------------------------------------
[mask effect="fadeInDown"]
[bg storage="kitchen.png" time=1000]
; サンルームからキッチンへ +5分 → 15:15
[advance_time min=5]
[gage_draw place="舞黒館:キッチン" hide_time="true"]
[mask_off]

[charapos name="jushika" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]

#
門を閉め終えた朱志香が、小出里亜の様子を見にキッチンへと戻ってきた。[p]

#jushika
[voice id="v00539"]
#jushika
小出里亜さん、準備は順調かしら？[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00540"]
#koderia
はい、朱志香様。[p]
[voice id="v00541"]
#koderia
準備は完璧に整っております。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v00542"]
#koderia
……朱志香様。少しお伺いしてもよろしいですか？[p]
[voice id="v00543"]
#koderia
今回のこの宿泊イベント……本当の開催理由は何なのでしょうか。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v00544"]
#jushika
どういう意味かしら？[p]
[voice id="v00545"]
#jushika
山手にあるこの洋館を活用して、横浜への観光誘致を図る。[p]
[voice id="v00546"]
#jushika
その第一弾の企画として開催したと、お伝えしているはずだけれど。[p]

#koderia
[voice id="v00547"]
#koderia
ええ、存じていますよ。[p]
[voice id="v00548"]
#koderia
ですが……オータムフェスティバルで人がほとんど、そちらに行っている中での開催理由は何かなと？[p]

#
小出里亜の追及に、朱志香は静かに目を伏せた。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v00549"]
#jushika
……強いて言うなら、その中でも舞黒館にどんな人が集まるのか知りたいと思ったからよ。[p]
[voice id="v00550"]
#jushika
どうしてそんなことが気になるの？[p]

#koderia
[voice id="v00551"]
#koderia
何となく、気になっただけです。[p]

#
小出里亜はふと視線を外し、ポツリと呟いた。[p]

#koderia
[voice id="v00552"]
#koderia
朱志香様……。[p]
[voice id="v00553"]
#koderia
私は……本当の家族に……会いたいです。[p]

#
その言葉に、朱志香は一瞬目を伏せる。[p]
#
やがて、静かな声で答えた。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v00554"]
#jushika
……いつか、会えるわ。[p]
[voice id="v00555"]
#jushika
きっとね……。[p]

#
朱志香はそれだけ告げると、足早にキッチンを後にした。[p]

[chara_hide name="jushika"]
[charapos name="koderia" face="normal" num="0"]

[fadeoutbgm]

#
朱志香の背中を見送った小出里亜は、ゆっくりとキッチンの棚を開けた。[p]
#
そこから小さな瓶を取り出す。[p]

[chara_mod name="koderia" face="evil"]
#koderia
[voice id="v00556"]
#koderia
……ええ、きっと。[p]

[chara_hide_all]

#

;----------------------------------------------------------
; 3-b. 執務室と、廊下
;----------------------------------------------------------

;── 執務室：朱志香 ─────────────────────────
; 経路Aは *s3a_before_tea の終わりからここへ跳んでくる（経路Bは素通し）
*s3_office_jushika
[mask effect="fadeInDown"]
[bg storage="office.png" time=1000]
[gage_draw place="舞黒館:執務室" hide_time="true"]
[mask_off]

[charapos name="jushika" face="normal" num="0"]

#
執務室。朱志香は引き出しを開け、小さな紙包みを取り出した。[p]

#
中身を別の缶へ移し替えると、缶の底に指先で小さく印をつける。[p]

#jushika
[voice id="v00557"]
#jushika
……これでいいわね。[p]

#
朱志香は缶を戸棚へ戻し、引き出しに鍵をかけた。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v00558"]
#jushika
……。[p]

[chara_hide_all]

;----------------------------------------------------------
; 4. リビング
;    経路A … メアリーの香水。そのあと珠璃はダイニングの席を決めに行く
;    経路B … 珠璃がサンルームを使えなかった側。舞黒館の話と、
;            到着直後に見つけた仕掛けの見学
;----------------------------------------------------------
*s3_living_a
[mask effect="fadeInDown"]
[playbgm storage="Eternal_Peace.mp3"]
[bg storage="living.png"]
; 場所移動 +5分 → 15:20
[advance_time min=5]
[gage_draw place="舞黒館:リビング" hide_time="true"]
[mask_off]

[jump cond="f.route_b == 1" target="*s3_living_b"]


;── 経路A：メアリーの香水 ───────────────────

[charapos name="mary" face="smile" num="1"]
[charapos name="airi" face="normal" num="2"]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00559"]
#mahoru
わあ、すごくいい香り！[p]
[reset_message_chara]

#
メアリーが取り出した小さなガラス瓶から、ふわりと花の香りが漂った。[p]

#mary
[voice id="v00560"]
#mary
ふふ、ありがとうございます。[p]
[voice id="v00561"]
#mary
私の手作り香水なんです。成分は私が一から全て決めたんですよ。[p]

[chara_mod name="airi" face="smile"]
#airi
[voice id="v00562"]
#airi
手作りですか！ すごいですね。[p]
[voice id="v00563"]
#airi
お店で売っているものみたいに洗練された香りです。[p]

#mary
[voice id="v00564"]
#mary
香水が大好きで、最高の香りを作るために色々と研究しているんです。[p]

#
丁度珠璃が戻ってきた。[p]

[chara_hide_all]
[charapos name="juri" face="normal" num="1"]
[charapos name="mary" face="smile" num="2"]
[charapos name="airi" face="normal" num="3"]

#juri
[voice id="v00565"]
#juri
あら、いい香りね。メアリーさんの香水かしら？[p]

#mary
[voice id="v00566"]
#mary
はい。もしよければ、珠璃さんも一緒に試してみませんか？[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00567"]
#juri
ええ、嬉しいわ。[p]

#
珠璃は手首に少し香水をつけ、香りを確かめた。[p]

#juri
[voice id="v00568"]
#juri
本当に素敵な香りね。気分が落ち着くわ。[p]

#mary
[voice id="v00569"]
#mary
ふふふ、ありがとうございます。[p]

#juri
[voice id="v00570"]
#juri
……さて、私はダイニングの支度を手伝ってくるわね。[p]

#
珠璃はそう言って席を立ち、リビングを後にした。[p]

;----------------------------------------------------------
; 4-b. ダイニング：席を決める（経路A）
;----------------------------------------------------------
[mask effect="fadeInDown"]
[bg storage="dining.png" time=1000]
[gage_draw place="舞黒館:ダイニング" hide_time="true"]
[chara_hide_all]
[mask_off]

#
ダイニングでは、小出里亜が配膳台にカップとソーサーを並べていた。[p]

[charapos name="koderia" face="normal" num="1"]
[charapos name="juri" face="normal" num="2"]

#juri
[voice id="v00571"]
#juri
お手伝いするわ。[p]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v00572"]
#koderia
まあ、珠璃様。お客様にそんな。[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00573"]
#juri
座る場所も決めておかないと、皆さん迷ってしまうでしょう？[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00574"]
#koderia
……では、お言葉に甘えて。[p]

#
珠璃は席順のとおりに、カップを一客ずつ並べ替えていった。[p]

#juri
[voice id="v00575"]
#juri
朱志香さんは、こちらの上座ね。[p]
[voice id="v00576"]
#juri
叡留久はその隣。私はその向かい。[p]

#juri
[voice id="v00577"]
#juri
愛理さんと真歩流さんは、並んで座りたいでしょうから、こちら。[p]

#koderia
[voice id="v00578"]
#koderia
仲がよろしいですものね。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00579"]
#juri
……メアリーさんは、どうしましょうか。[p]

#koderia
[voice id="v00580"]
#koderia
メアリー様は、窓の外を眺めていらっしゃることが多いように思います。[p]

#juri
[voice id="v00581"]
#juri
そう。じゃあ、窓際の愛理さんの隣ね。[p]

#juri
[voice id="v00582"]
#juri
小出里亜さんは？[p]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v00583"]
#koderia
私は給仕がありますので……。[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00584"]
#juri
朱志香さんが座らせるわよ、きっと。[p]
[voice id="v00585"]
#juri
立ったり座ったりするなら、扉に近いこの席がいいんじゃないかしら。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00586"]
#koderia
……ありがとうございます。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v00587"]
#koderia
それでは、私はお菓子を持ってまいりますね。[p]

[chara_hide_all]
[charapos name="juri" face="normal" num="0"]

#
足音が遠ざかっていく。[p]

#
珠璃は並んだカップを整えてその場を後にした。[p]

[chara_hide_all]


[jump target="*s3_after_living"]

;── 経路B：舞黒館の話と、到着直後に見つけた仕掛け ──────
*s3_living_b
#
一方、リビングでは。[p]

[charapos name="mary" face="smile" num="1"]
[charapos name="airi" face="normal" num="2"]

#
私と愛理がソファに落ち着くと、少し遅れて珠璃が廊下から入ってきた。[p]

[chara_hide_all]
[charapos name="juri" face="normal" num="1"]
[charapos name="mary" face="smile"  num="2"]
[charapos name="airi" face="normal" num="3"]

#juri
[voice id="v00589"]
#juri
あら、皆さんこちらでしたのね。[p]
[voice id="v00590"]
#juri
ご一緒してもよろしいかしら。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00591"]
#mahoru
どうぞどうぞ。[p]
[reset_message_chara]

;--- メアリーが舞黒館について語る -------------------------
#
四人でソファを囲むと、メアリーがふと窓の外へ目をやった。[p]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v00592"]
#mary
……こうして中から見ると、本当に立派なお屋敷ですね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00593"]
#mahoru
メアリーさん、この館のこと詳しいんですか？[p]
[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00594"]
#mary
ええ、少しだけ。[p]
[voice id="v00595"]
#mary
親戚を探している都合で、日本の古い洋館は片っ端から調べているんです。[p]

#mary
[voice id="v00596"]
#mary
ここは、その中でも特別でした。[p]

;--- 舞黒館の来歴 ---------------------------------------
#mary
[voice id="v00597"]
#mary
この館を建てたのは、舞黒邦夢という方ですが。[p]
[voice id="v00598"]
#mary
戦前は資産家で、もとは政治家をされていました。[p]

#mary
[voice id="v00599"]
#mary
若い頃に留学されていて——[p]
[voice id="v00600"]
#mary
そこで見たヨーロッパの景色が忘れられなくて、この横浜に同じものを建てたそうです。[p]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v00601"]
#airi
それでこんなに本格的なんですね。[p]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v00602"]
#mary
ええ。それに、舞黒氏は話をするのが大好きな方だったと聞きます。[p]
[voice id="v00603"]
#mary
だからこの洋館には、日夜たくさんの人が出入りしていたそうです。[p]

#mary
[voice id="v00604"]
#mary
人が集まる場所には、自然と情報も集まります。[p]
[voice id="v00605"]
#mary
知りたいことがあって足を運ぶ要人も、少なくなかったとか。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00606"]
#mahoru
……なんだか、物々しい話ですね。[p]
[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00607"]
#mary
それがそうでもないんです。[p]
[voice id="v00608"]
#mary
舞黒氏は殺伐としたことが、何より嫌いな方だったそうで。[p]

#mary
[voice id="v00609"]
#mary
だから建物のあちこちに仕掛けを施したり、意匠を凝らしたりして——[p]
[voice id="v00610"]
#mary
訪れた人を楽しませていたと書かれていました。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00611"]
#mahoru
仕掛け……？[p]
[reset_message_chara]

#mary
[voice id="v00612"]
#mary
さあ。どんなものかまでは、書いてありませんでした。[p]
[voice id="v00613"]
#mary
探してみたら見つかるかもしれませんね。[p]

;--- 時代が翳っていく ------------------------------------
[chara_mod name="mary" face="normal"]
#mary
[voice id="v00614"]
#mary
けれど、1930年代に入ると、そうも言っていられなくなります。[p]
[voice id="v00615"]
#mary
政治は不安定になり、軍部は憤懣を高めていった。[p]

#mary
[voice id="v00616"]
#mary
この館からも、少しずつ人の足が遠のいていったそうです。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v00617"]
#airi
そんな時期に、人を集めるなんて……。[p]

#mary
[voice id="v00618"]
#mary
それでも舞黒氏は人を招き続けました。[p]
[voice id="v00619"]
#mary
集まって話をすれば、不安は少しは薄れるでしょう。[p]

#mary
[voice id="v00620"]
#mary
そういう方だったんです。[p]

;--- 戦後から現在まで ------------------------------------
#mary
[voice id="v00621"]
#mary
だからでしょうか。[p]
[voice id="v00622"]
#mary
戦後、舞黒館はGHQに接収されましたが、すぐに返還されたそうです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00623"]
#mahoru
接収されたのに、すぐ返ってきたんですか？[p]
[reset_message_chara]

#mary
[voice id="v00624"]
#mary
ええ。よほど人望があったのでしょうね。[p]

#mary
[voice id="v00625"]
#mary
舞黒氏が亡くなった後は、知人のご一家に管理を任せていたそうです。[p]
[voice id="v00626"]
#mary
それでも人の出入りは絶えなかった。[p]

#mary
[voice id="v00627"]
#mary
困っている人、行き場のない人を引き取っては、元気づけて送り出す。[p]
[voice id="v00628"]
#mary
そんな拠りどころになっていたみたいです。[p]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v00629"]
#airi
素敵ですね……。[p]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v00630"]
#mary
そのご一家も亡くなって、住む人がいなくなった。[p]
[voice id="v00631"]
#mary
そこを買い取ったのが、富礼知の家——今の朱志香さんのご主人の実家です。[p]

#
私も愛理も、いつの間にか話に聞き入っていた。[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00632"]
#juri
まあ、ずいぶんお詳しいのね。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00633"]
#mary
調べるのが好きなだけです。[p]

#juri
[voice id="v00634"]
#juri
——私も、ひとつ知っているわ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00635"]
#mahoru
えっ。[p]
[reset_message_chara]

; ▼ 要ボイス再録：v00636（旧「今朝、面白い仕掛けを見つけたの。」）
;    参加者は今日の昼に集合しており、前夜から館にいたわけではない。
#juri
[voice id="v00636"]
#juri
着いてすぐ、面白い仕掛けを見つけたの。[p]
; ▼ 要ボイス再録：v00637（旧「早くに目が覚めてしまって、館の中を歩いていたときにね。」）
[voice id="v00637"]
#juri
ずいぶん早くに着いてしまって、館の中を歩いていたときにね。[p]

[chara_mod name="airi" face="smile"]
#airi
[voice id="v00638"]
#airi
見たいです！[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00639"]
#mary
私も、ぜひ。[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00640"]
#juri
それじゃあ、皆さんも誘いましょうか。[p]
[voice id="v00641"]
#juri
お茶会の前の余興ということで。[p]

#
私たちはダイニングにいた叡留久と、キッチンの朱志香と小出里亜にも声をかけた。[p]
#
サンルームの和人にも。[p]

[chara_hide_all]
[charapos name="juri" face="normal" num="1"]
[charapos name="eruku" face="smile" num="2"]

#eruku
[voice id="v00642"]
#eruku
仕掛け？　ますます面白いじゃないか。[p]

#juri
[voice id="v00643"]
#juri
場所は二階よ。[p]

[voice id="v00644"]
#juri
先に行っていて。[p]

#eruku
[voice id="v00645"]
#eruku
君は？[p]

[chara_mod name="juri" face="smile"]
[voice id="v00647"]
#juri
先が細いものを取ってくるわ。あの仕掛けを出すには必要なのよ。[p]

#
珠璃はそう言って、宿泊部屋の方へ歩いていった。[p]

[chara_hide_all]


;----------------------------------------------------------
; 4-c. 二階廊下：海の向こうで
;----------------------------------------------------------
[mask effect="fadeInDown"]
[bg storage="hallway_second.png" time=1000]
[gage_draw place="舞黒館:二階廊下" hide_time="true"]
[chara_hide_all]
[mask_off]

#
二階の廊下には、大きなステンドグラスがはめ込まれていた。[p]
#
青と緑の硝子を通した光が、床に海のような模様を落としている。[p]

[charapos name="airi" face="surprised" num="0"]

#airi
[voice id="v00648"]
#airi
わあ……きれい。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00649"]
#mahoru
どうやったら、こんな模様描けるんだろうね。[p]
[reset_message_chara]

#
ステンドグラスは見事なまでに美しく光を放っていた。[p]

#airi
[voice id="v00650"]
#airi
どこにあるんだろうね？[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="0"]

#eruku
[voice id="v00651"]
#eruku
うーん、ステンドグラスが何かの形とか？[p]

#
あれやこれやと皆で調べてみる。[p]

#
そこへ、珠璃が階段を上がってきた。[p]

@chara_hide_all
[charapos name="juri" face="normal" num="0"]

#juri
[voice id="v00652"]
#juri
お待たせ。ちょっと待ってね。[p]

#
珠璃は、ステンドグラスの脇の壁にボールペンを当てた。[p]

#juri
[voice id="v00653"]
#juri
手だとなかなか開けられないの……よ。[p]

#juri
[voice id="v00654"]
#juri
開いたわ！[p]

#
腰の高さの壁に、真鍮の小さな蓋がついていた。[p]
#
持ち上げると、細かな文字盤と、押し込み式の小さな鍵が並んでいる。[p]

#
文字盤の上には、彫り込まれた一文があった。[p]

#
——海の向こうで君は何を感じる？[p]

[chara_hide_all]
[charapos name="mary" face="thinking" num="1"]
[charapos name="jushika" face="normal" num="2"]

#jushika
[voice id="v00655"]
#jushika
こんなところに仕掛けがあったなんて、気づきませんでした。[p]

#mary
[voice id="v00656"]
#mary
……舞黒氏らしい仕掛けですね。[p]

[chara_hide_all]
[charapos name="juri" face="smile" num="1"]
[charapos name="eruku" face="smile" num="2"]

#eruku
[voice id="v00657"]
#eruku
海の向こうで何を感じるか……。[p]
[voice id="v00658"]
#eruku
——さて、答えは何がいいかな。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00659"]
#juri
あなたが答えるの？[p]

#eruku
[voice id="v00660"]
#eruku
こういうものは、得意なんだ！[p]

[voice id="v00661"]
#eruku
……と言いたいところだけど、せっかくだ。[p]
[voice id="v00662"]
#eruku
真白さん。君なら、何と答える？[p]

[cm]
[chara_hide_all]
[iscript]
tf.choices = [
{ target:'*s3_riddle_wrong',   text:'お金',     kind:'look', name:'お金' },
{ target:'*s3_riddle_wrong',   text:'懐かしさ', kind:'look', name:'懐かしさ' },
{ target:'*s3_riddle_correct', text:'ぬくもり', kind:'look', name:'ぬくもり' },
{ target:'*s3_riddle_wrong',   text:'希望',     kind:'look', name:'希望' }
];
[endscript]
[stand_select storage="scene3.ks" se="decide.mp3" prompt="——海の向こうで君は何を感じる？"]

;----------------------------------------------------------
; 仕掛け：不正解
;   現行どおり、叡留久が「じゆう」を試して蓋に叩かれる。
;----------------------------------------------------------
*s3_riddle_wrong
[cm]
[show_menu]
[gage_draw place="舞黒館:二階廊下" hide_time="true"]
[chara_hide_all wait="false"]
[charapos name="juri" face="normal" num="1" wait="false"]
[charapos name="eruku" face="smile" num="2" wait="false"]

#eruku
[voice id="v00663"]
#eruku
なるほど。それも悪くない。[p]
[voice id="v00664"]
#eruku
でも、俺なら——「じゆう」だな。[p]
[voice id="v00665"]
#eruku
海の向こうと聞いて、それ以外に思いつかない。[p]

#
叡留久は文字をひとつずつ押し込んでいった。[p]
#
最後の鍵が、かちりと沈んだ。[p]

[playse storage="crash.mp3"]

#
——真鍮の蓋が、勢いよく落ちた。[p]

[chara_mod name="eruku" face="surprised"]
#eruku
[voice id="v00666"]
#eruku
いたっ！？[p]

#
蓋は叡留久の手の甲を、ぴしゃりと叩いていた。[p]

[chara_hide_all]
[charapos name="airi" face="smile" num="1"]
[charapos name="eruku" face="surprised2" num="2"]

#airi
[voice id="v00667"]
#airi
ふふっ……[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00668"]
#mahoru
ごめんなさい、笑っちゃだめですよね。[p]

[voice id="v00669"]
#mahoru
でも、これ……[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="mary" face="smile" num="1"]
[charapos name="kazuto" face="normal" num="2"]

#mary
[voice id="v00670"]
#mary
どうやら、違ったみたいですね。[p]

#kazuto
[voice id="v00671"]
#kazuto
……悪趣味だな。[p]

#mary
[voice id="v00672"]
#mary
ええ。でも、叩かれた方は、きっとその日のことを覚えています。[p]

[chara_hide_all]
[charapos name="eruku" face="smile" num="1"]
[charapos name="juri" face="smile" num="2"]

#eruku
[voice id="v00673"]
#eruku
まったく、一本取られたよ。[p]

#juri
[voice id="v00674"]
#juri
ふふ。悔しかった？[p]

#eruku
[voice id="v00675"]
#eruku
悔しいね。[p]
[voice id="v00676"]
#eruku
——だが、悪くない。[p]

#
叡留久は赤くなった手の甲をさすりながら、それでも笑っていた。[p]

[jump target="*s3_riddle_end"]

;----------------------------------------------------------
; 仕掛け：正解
;   scene2 の石碑「感じているのはあなたのぬくもり」と対応。
;   正解しても事件解決に必須の証拠にはならず、舞黒館の過去が一歩だけ開く。
;----------------------------------------------------------
*s3_riddle_correct
[cm]
[show_menu]
[gage_draw place="舞黒館:二階廊下" hide_time="true"]
[chara_hide_all wait="false"]
[charapos name="airi" face="normal" num="1" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00677"]
#mahoru
「ぬくもり」……かな。[p]
[reset_message_chara]

#airi
[voice id="v00678"]
#airi
ぬくもり？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00679"]
#mahoru
うん。なんとなく、その言葉が浮かんだの。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="eruku" face="smile" num="1"]
[charapos name="juri" face="normal" num="2"]

#eruku
[voice id="v00680"]
#eruku
いいね。じゃあ、それで試してみよう！[p]

#
叡留久が「ぬ・く・も・り」と、一文字ずつ鍵を押し込んでいく。[p]

#
最後の鍵が沈んだ。[p]

#
——カチリ。[p]

#
文字盤の下から低い音がして、壁の一部がほんの少し前へせり出した。[p]

[chara_mod name="juri" face="surprised"]
#juri
[voice id="v00681"]
#juri
……開いた？[p]

[chara_hide_all]
[charapos name="jushika" face="surprised" num="1"]
[charapos name="mary" face="thinking" num="2"]

#jushika
[voice id="v00682"]
#jushika
隠し棚ですね。[p]

#
細い隠し棚の中には、古びた紙束が収められていた。[p]
#
何通かの書簡の控えらしい。[p]

#
長い年月の湿気で紙同士が貼りつき、インクもほとんど褪せている。[p]
#
無理に剥がせば崩れてしまいそうで、とても読める状態ではなかった。[p]

#
ただ、一枚だけ。[p]
#
二つ折りになった内側の文字が、辛うじて残っていた。[p]

[chara_hide_all]

#
『1936年7月10日』[p]

#
『元気にしているか？』[p]

#
『彼女から手紙が届いているから、もう知っていると思うが、[r]
#
君の子供が生まれた。』[p]

#
『おめでとう。君は父親になった。』[p]

#
『君から預かったものも、大切に保管している。[r]
#
安心してくれ。』[p]

#
『体を大切にな。』[p]

#
『舞黒邦夢』[p]

[eval exp="f.s3_kunimu_letter = 1"]

[charapos name="airi" face="surprised" num="1"]
[charapos name="mary" face="thinking" num="2"]

#airi
[voice id="v00683"]
#airi
子供……？[p]
[voice id="v00684"]
#airi
これ、誰に宛てた手紙なんだろう。[p]

#mary
[voice id="v00685"]
#mary
……1936年。[p]

#
メアリーは日付を見つめたまま、しばらく黙っていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00686"]
#mahoru
（それに——「君から預かったもの」。）[p]
[voice id="v00687"]
#mahoru
（舞黒さんは、一体何を預かっていたんだろう。）[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="eruku" face="smile" num="1"]
[charapos name="juri" face="smile" num="2"]

#eruku
[voice id="v00688"]
#eruku
いやあ、これは大当たりだ！[p]
[voice id="v00689"]
#eruku
昔の人の手紙が出てくるとは思わなかったな。[p]

#juri
[voice id="v00690"]
#juri
ふふ、よかったわね。[p]

[jump target="*s3_riddle_end"]

*s3_riddle_end
[chara_hide_all]
[charapos name="jushika" face="normal" num="0"]

#jushika
[voice id="v00691"]
#jushika
名残惜しいですが、そろそろお茶会のお時間です。[p]
[voice id="v00692"]
#jushika
支度の続きをしてまいりますね。[p]

[chara_hide_all]

[jump target="*kitchen_ready"]
*s3_after_living
;----------------------------------------------------------
; 5. ダイニング：叡留久の密かな連絡
;----------------------------------------------------------
[mask effect="fadeInDown"]
[chara_hide_all]
[bg storage="sunroom_second.png" time=1000]
; リビングからダイニングへ +5分 → 15:25
[advance_time min=5]
[gage_draw place="舞黒館:サンルーム2F" hide_time="true"]
[mask_off]

[charapos name="eruku" face="normal" num="0"]

#
2Fのサンルームでは、叡留久が一人で本を読んでいた。[p]
#
静寂の中、彼のスマートフォンのバイブレーションが短く鳴る。[p]

[chara_mod name="eruku" face="thinking"]
#eruku
[voice id="v00693"]
#eruku
……。[p]

#
叡留久は無言で画面を確認し、素早くフリックして返信を済ませた。[p]
#
そして何事もなかったかのようにスマートフォンを伏せ、再び黙々と本を読み始めた。[p]

[chara_hide_all]


;----------------------------------------------------------
; 6. キッチン：運命の歯車
;----------------------------------------------------------
*kitchen_ready
[mask effect="fadeInDown"]
[bg storage="kitchen.png" time=1000]
; 最終準備 +5分 → 15:30（お茶会開始時刻に合わせて確定）
[advance_time min=5]
[gage_draw place="舞黒館:キッチン" hide_time="true"]
[mask_off]

[if exp="f.route_b == 1"]
#
2階から戻ってきて、小出里亜の手伝いをするためキッチンへと向かった。[p]
[else]
#
トイレから戻った珠璃と合流し、小出里亜の手伝いをするためキッチンへと向かった。[p]
[endif]

; メアリーの手には毒が付いている。準備に加わると誰彼構わず移してしまうので、
; ここで一度キッチンから離してある（代わりに朱志香が手伝いに入る）


[if exp="f.route_b == 0"]
[charapos name="mary" face="normal" num="0"]
#mary
[voice id="v00694"]
#mary
私は、叡留久さんと和人さんをお呼びしてきますね。[p]

#
メアリーはそう言って、キッチンを出ていった。[r]
#
入れ替わりに、朱志香が入ってくる。[p]

[endif]

[chara_hide_all]
[charapos name="jushika" face="normal" num="0"]

#jushika
[voice id="v00695"]
#jushika
皆さん、お手伝いいただきありがとうございます。[p]

[chara_hide_all]
[charapos name="koderia" face="normal" num="1"]
[charapos name="juri" face="normal" num="2"]
[charapos name="jushika" face="normal" num="3"]
[charapos name="airi" face="normal" num="4"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00696"]
#mahoru
小出里亜さん、お菓子の盛り付け、手伝いますね。[p]
[reset_message_chara]

#koderia
[voice id="v00697"]
#koderia
ありがとうございます。助かります。[p]

#
愛理と私でお菓子が乗った皿を運ぶ。[p]

#juri
[voice id="v00698"]
#juri
私はカップを運ぶわ。小出里亜さん、ポットをお願い。[p]

#koderia
[voice id="v00699"]
#koderia
勿論です。ありがとうございます。[p]

#
小出里亜がポットに手を伸ばしたその時。[p]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v00700"]
#koderia
あっ……。[p]

#
小出里亜がポットを持ち上げた瞬間、ポットの蓋がパカっと開き、持ち上げた拍子にお湯が手にかかってしまったのだ。[p]

#koderia
[voice id="v00701"]
#koderia
あっ……熱い！[p]

#
小出里亜は小さく悲鳴を上げ、反射的に自分の手を舐めて冷ました。[p]

#koderia
[voice id="v00702"]
#koderia
ふう、ふう。[p]

#
冷ましながら、必死に手をなめている。[p]

;── 経路B：ここで毒が口紅の外側へ移る ────────────────────
;   蓋の毒 → 熱湯 → 小出里亜の手 → （舐めて摂取）
;                              └→ 口紅の外側 → 叡留久
;   プレイヤーの目の前で移るが、この時点では誰も——真歩流も——
;   何が起きたのか分からない。
[if exp="f.route_b == 1"]
; ▼ 以下、新規会話は要ボイス収録
#
小出里亜はエプロンのポケットを探り、ハンカチを引き出した。[p]

#
——その拍子に、何かが一緒に跳ね出した。[p]

#
床へ落ちかけたそれを、小出里亜は火傷したほうの手で咄嗟に押さえる。[p]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v03783"]
……あ。[p]

#
小さな口紅だった。[r]
#
小出里亜はそれを握り込むように拾い、そっとポケットへ戻した。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03784"]
（……かわいい口紅。）[p]
[reset_message_chara]
[endif]
;── 経路B ここまで ──

[chara_mod name="juri" face="surprised"]
#juri
[voice id="v00703"]
#juri
小出里亜さん、ごめんなさい。ポットの蓋をしっかりと閉めたつもりだったんだけど……[p]

#
珠璃は急いでポットの蓋を閉め直した。[p]
#
小出里亜は水道の水で手を冷やした。[p]

[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v00704"]
#jushika
小出里亜さん、大丈夫？[p]

[voice id="v00705"]
#jushika
濡らしたタオルを持ってくるわ。[p]

#
朱志香は急いでタオルを用意して、小出里亜の手に当てた。[p]
#
珠璃はこぼれたお湯とポットを拭いた。[p]

@chara_mod name="jushika" face="normal"

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00706"]
#koderia
ありがとうございます、朱志香様、珠璃様。[p]
[voice id="v00707"]
#koderia
もう大丈夫です。[p]

#airi
[voice id="v00708"]
#airi
本当に大丈夫なんですか？[p]

[voice id="v00709"]
#airi
凄い熱そうでしたけど。[p]

#koderia
[voice id="v00710"]
#koderia
ご心配くださり、ありがとうございます。[p]
[voice id="v00711"]
#koderia
けれど、大丈夫ですよ。[p]

;── 経路B：ここで毒を落とす。誰も気に留めない ──
[if exp="f.route_b == 1"]
[chara_mod name="juri" face="normal"]
#juri
[voice id="v00712"]
#juri
——ごめんなさい、お茶会の前に少し手を洗わせて。[p]

#koderia
[voice id="v00713"]
#koderia
どうぞ、お使いください。[p]

#juri
[voice id="v00714"]
#juri
ありがとう。[p]

[endif]
;── 経路B ここまで ──

#
小出里亜は微笑むと、しっかりとポットを持ち直した。[p]

#koderia
[voice id="v00715"]
#koderia
さあ、ダイニングへ参りましょう。[p]
[voice id="v00716"]
#koderia
お茶会の準備は、これで完了です。[p]

[fadeoutbgm]

[chara_hide name="koderia"]
[chara_hide name="airi"]
[chara_hide name="juri"]
[chara_hide name="jushika"]

;----------------------------------------------------------
; 6-b. キッチン：手当てと、白いセージ（経路B）
;   ここから *tea_party_start の直前までが、経路Bだけで流れる場面
;----------------------------------------------------------
[if exp="f.route_b == 1"]

[mask effect="fadeInDown"]
[bg storage="kitchen.png" time=1000]
[gage_draw place="舞黒館:キッチン" hide_time="true"]
[chara_hide_all]
[mask_off]

#
やはり火傷の手当てをした方がいいという話になり、キッチンで和人が手当てをすることになった。[p]

[charapos name="koderia" face="normal" num="1"]
[charapos name="kazuto" face="normal" num="2"]

#kazuto
[voice id="v00717"]
#kazuto
手を出せ。[p]

#koderia
[voice id="v00718"]
#koderia
え……。[p]

#kazuto
[voice id="v00719"]
#kazuto
いいから。[p]

#
和人は小出里亜の手を取ると、水道の水を細く出し、その下へ持っていった。[p]

#kazuto
[voice id="v00720"]
#kazuto
このまま冷やせ。十分は動くな。[p]

#koderia
[voice id="v00721"]
#koderia
そんなに、ですか。[p]

#kazuto
[voice id="v00722"]
#kazuto
赤みの引き方で決める。[p]

#
水の音だけが、しばらく続いた。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00723"]
#koderia
……お詳しいんですね。[p]

#kazuto
[voice id="v00724"]
#kazuto
一応医大生だからな。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v00725"]
#koderia
医大生……。[p]

#
小出里亜は水にさらした手を見つめたまま、そっと口を開いた。[p]

#koderia
[voice id="v00726"]
#koderia
徐音様は、どうして今回のイベントにいらしたのですか。[p]

#kazuto
[voice id="v00727"]
#kazuto
……。[p]

#koderia
[voice id="v00728"]
#koderia
無理に答えなくても大丈夫ですよ。[p]

#kazuto
[voice id="v00729"]
#kazuto
いや。[p]

#
和人は蛇口の勢いを少しだけ緩めた。[p]

#kazuto
[voice id="v00730"]
#kazuto
庭に咲いている白いセージが気になるからだ。[p]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v00731"]
#koderia
……セージ、ですか。[p]

#kazuto
[voice id="v00732"]
#kazuto
ああ。[p]

#
それきり、和人は何も言わなかった。[p]

[chara_hide_all]
[charapos name="koderia" face="normal" num="0"]

#koderia
[voice id="v00733"]
#koderia
（お庭の、白いお花……）[p]

[chara_hide_all]

[endif]
;── 6-b（経路B）ここまで ──

;----------------------------------------------------------
; 7. ダイニング：お茶会開始
;----------------------------------------------------------
*tea_party_start
[mask]
[cm]
[chara_hide_all]
[bg storage="dining.png" time=1000]
[playbgm storage="tea_party.mp3"]
; ここから時刻表示を戻す。お茶会開始は 15:30
[set_time hour=15 min=30]
[gage_draw place="舞黒館:ダイニング"]
[mask_off]

#
ダイニングテーブルには、美しいティーセットと、先ほどキッチンで用意されたお菓子が並べられていた。[p]

[chara_hide_all]
[charapos name="koderia" face="smile" num="1"]
[charapos name="jushika" face="normal" num="2"]

#koderia
[voice id="v00734"]
#koderia
皆様、お待たせいたしました。[p]
[voice id="v00735"]
#koderia
ただいま、順番に紅茶をお配りいたしますね。[p]

#jushika
[voice id="v00736"]
#jushika
小出里亜さん、あなたは座っていて。手が痛むでしょう。[p]
[voice id="v00737"]
#jushika
私が茶葉を入れていくわ。[p]

#koderia
[voice id="v00738"]
#koderia
そんな、朱志香様。[p]

#jushika
[voice id="v00739"]
#jushika
たまには私にもやらせてちょうだい。[p]

[chara_hide_all]
[charapos name="jushika" face="normal" num="1"]
[charapos name="juri" face="smile" num="2"]

#jushika
[voice id="v00740"]
#jushika
珠璃様。申し訳ありませんが、お運びいただけますか。[p]

#juri
[voice id="v00741"]
#juri
ええ、喜んで。[p]

#
朱志香が一杯ずつ淹れ、それを珠璃が受け取って席へ運んでいく。[p]

;── 経路B：口紅が叡留久の手に渡る ────────────────────────
;   キッチンで毒が移った口紅が、ここで持ち主を変える。
;   叡留久は拾った口紅の外側を手で拭い、その手で茶菓子を口へ運ぶ。
;   自分が贈った品なので、確かめるまでもなく持ち主が分かっている。
;   これが経路Bにおける叡留久の摂取経路になる。
[if exp="f.route_b == 1"]
; ▼ 以下、新規会話は要ボイス収録
#
席に腰を下ろした小出里亜が、エプロンの裾を直した。[p]

#
その拍子に、小さなものが膝から滑り落ちて、卓の下へ転がっていった。[p]

#
それは長い卓の下をゆっくりと転がって、向こう側の椅子の足元で止まった。[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="0"]

#
叡留久は足元に何かが当たった感じがして、身をかがめた。[p]

#
落ちていたそれを拾い上げ、確かめもせずに握り込んだ。[p]

#
ほんの一瞬、珠璃のほうへ視線を向けた。[p]

#
それから指先で外側を軽く拭って、上着の内ポケットへ滑り込ませた。[r]

#
それから、何事もなかったように、皿の茶菓子をひとつ摘まんで口へ運んだ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03785"]
（……叡留久さん、何をしていたんだろう？）[p]
[reset_message_chara]

[chara_hide_all]
[endif]
;── 経路B ここまで ──

#
やがて全員の手元にカップが行き渡り、思い思いの会話が始まった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00742"]
#mahoru
（せっかくのお茶会だもの。いろんな人とお話ししてみよう）[p]
[reset_message_chara]

[chara_hide_all]

;----------------------------------------------------------
; お茶会：自由行動パート（6人のうち4人ぶん）
;   f.tea_turn … 済んだ行動回数。4回で紅茶の交換イベントへ
;----------------------------------------------------------
[iscript]
f.tea_turn    = 0;
f.tea_kazuto  = 0;
f.tea_jushika = 0;
f.tea_koderia = 0;
f.tea_eruku   = 0;
f.tea_juri    = 0;
f.tea_mary    = 0;
[endscript]

*tea_talk_loop
[clearfix]
[chara_hide_all]
[reset_message_chara]
[hidemenubutton]
[cm]

; 時刻表示を更新
[gage_draw place="舞黒館:ダイニング"]

; 選択画面は全面のオーバーレイになるので、資料ボタンは一旦片付ける
[clearfix]

; 4人ぶん話したらお茶会の締めへ
[jump cond="f.tea_turn >= 4" target="*tea_exchange"]

;-----------------------------------------------------------
; 選択肢の生成
;-----------------------------------------------------------
[iscript]
tf.choices = [];
if(f.tea_kazuto  == 0){ tf.choices.push({target:'*tea_kazuto',  text:'朱志香を見ている和人',     kind:'talk', chara:['kazuto']}); }
if(f.tea_jushika == 0){ tf.choices.push({target:'*tea_jushika', text:'席を回る朱志香',           kind:'talk', chara:['jushika']}); }
if(f.tea_koderia == 0){ tf.choices.push({target:'*tea_koderia', text:'給仕をする小出里亜',       kind:'talk', chara:['koderia']}); }
if(f.tea_eruku   == 0){ tf.choices.push({target:'*tea_eruku',   text:'手元を気にする叡留久',     kind:'talk', chara:['eruku']}); }
if(f.tea_juri    == 0){ tf.choices.push({target:'*tea_juri',    text:'夫の隣に座る珠璃',         kind:'talk', chara:['juri']}); }
if(f.tea_mary    == 0){ tf.choices.push({target:'*tea_mary',    text:'紅茶の香りを確かめるメアリー', kind:'talk', chara:['mary']}); }

tf.tea_prompt = "お茶会が始まった。誰の様子を見ようか……。<br>"
+ "（あと " + (4 - f.tea_turn) + " 人ぶんくらいは、席を立てそう）";
[endscript]

; 念のため：選択肢が尽きていたら締めへ
[jump cond="tf.choices.length == 0" target="*tea_exchange"]

[stand_select storage="scene3.ks" se="decide.mp3" prompt="&tf.tea_prompt"]


;==========================================================
; ① 和人 ―― 朱志香を見つめている／小出里亜の視線
;==========================================================
*tea_kazuto
[eval exp="f.tea_kazuto = 1"]
[eval exp="f.tea_turn = f.tea_turn + 1"]
[advance_time min=8]
[gage_draw place="舞黒館:ダイニング"]
[show_menu]

[chara_hide_all wait="false"]
[charapos name="kazuto" face="normal" num="1" wait="false"]
[charapos name="jushika" face="normal" num="2" wait="false"]

#
和人は紅茶にほとんど口をつけないまま、朱志香の方をじっと見ていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00743"]
#mahoru
（さっきから、ずっと朱志香さんを見てる……）[p]
[reset_message_chara]

#
その視線に気づいたのか、朱志香がふと顔を上げた。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v00744"]
#jushika
……和人様。どうかされましたか？[p]
[voice id="v00745"]
#jushika
先ほどから、私の顔をじっと見ていらっしゃるようですが。[p]

#kazuto
[voice id="v00746"]
#kazuto
……いや。[p]
[voice id="v00747"]
#kazuto
知り合いに似ている気がしただけで、他意はない。[p]

#jushika
[voice id="v00748"]
#jushika
そうですか。[p]
[voice id="v00749"]
#jushika
ところで……和人様。私たちは以前、どこかでお会いしたことはありませんか？[p]

[chara_mod name="kazuto" face="look_away"]
#kazuto
[voice id="v00750"]
#kazuto
…………。[p]

#
和人は一瞬視線を逸らした。[p]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v00751"]
#kazuto
……いや、初対面だろう。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v00752"]
#jushika
……そうでしたか。失礼いたしました。[p]

[chara_hide_all]
[charapos name="koderia" face="normal" num="0"]

#
——ふと、給仕の手を止めた小出里亜が、二人のやり取りを見ていることに気づいた。[p]

#koderia
[voice id="v00753"]
#koderia
……。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00754"]
#mahoru
（小出里亜さん、会話には入ってこないけど……）[p]

[voice id="v00755"]
#mahoru
（さっきから、和人の方ばかり見ている気がする）[p]
[reset_message_chara]

#
視線に気づいた小出里亜は、何事もなかったように微笑むと、また紅茶を注ぎに戻っていった。[p]

[chara_hide_all]
[jump target="*tea_talk_loop"]


;==========================================================
; ② 朱志香 ―― 紅茶の感想／カップを見つめる
;==========================================================
*tea_jushika
[eval exp="f.tea_jushika = 1"]
[eval exp="f.tea_turn = f.tea_turn + 1"]
[advance_time min=8]
[gage_draw place="舞黒館:ダイニング"]
[show_menu]

[chara_hide_all wait="false"]
[charapos name="jushika" face="smile" num="0" wait="false"]

#
朱志香はティーポットを手に席を回り、私たちのところへやってきた。[p]

#jushika
[voice id="v00756"]
#jushika
真歩流様、愛理様。紅茶はいかがですか？[p]
[voice id="v00757"]
#jushika
お口に合っておりますでしょうか。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00758"]
#mahoru
はい、すごく美味しいです。[p]
[reset_message_chara]

[message_chara name="airi" face="smile"]
#airi
[voice id="v00759"]
#airi
香りがとても良いですね。[p]
[voice id="v00760"]
#airi
こんな紅茶、初めて飲みました。[p]
[reset_message_chara]

#jushika
[voice id="v00761"]
#jushika
それは良かった。[p]
[voice id="v00762"]
#jushika
わざわざ輸入して用意した甲斐がありました。[p]

#jushika
[voice id="v00763"]
#jushika
この茶葉は、この館が建った頃に愛されていたものと同じ産地のものなのですよ。[p]
[voice id="v00764"]
#jushika
今日という日のために、ずいぶん前から取り寄せておりました。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00765"]
#mahoru
そこまで考えて用意してくださったんですね。[p]
[reset_message_chara]

#jushika
[voice id="v00766"]
#jushika
おもてなしですもの。当然です。[p]

#
朱志香は満足そうに微笑んだ。[p]

;--- ここで一拍。睡眠薬の伏線（プレイヤーにだけ引っかかりを残す） ---
[chara_mod name="jushika" face="thinking"]

#
——そして、ふと言葉を切ると。[p]
#
テーブルに並んだカップを、ひとつひとつ、じっと見つめていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00767"]
#mahoru
（……朱志香さん？）[p]
[reset_message_chara]

#
声をかけようとしたときには、朱志香はもう次の席へと歩き出していた。[p]

[chara_hide_all]
[jump target="*tea_talk_loop"]


;==========================================================
; ③ 小出里亜 ―― おかわり／中座／和人への視線
;==========================================================
*tea_koderia
[eval exp="f.tea_koderia = 1"]
[eval exp="f.tea_turn = f.tea_turn + 1"]
[advance_time min=8]
[gage_draw place="舞黒館:ダイニング"]
[show_menu]

[chara_hide_all wait="false"]
[charapos name="koderia" face="smile" num="0" wait="false"]

#
小出里亜がティーポットを持って、席のあいだを回っていた。[p]

#koderia
[voice id="v00768"]
#koderia
紅茶のおかわりはいかがですか。[p]

[chara_hide_all]
[charapos name="koderia" face="smile" num="1"]
[charapos name="eruku" face="smile" num="2"]

#eruku
[voice id="v00769"]
#eruku
お、それじゃあ貰おうかな。[p]
[voice id="v00770"]
#eruku
この紅茶、本当にうまいね。何杯でもいけそうだ。[p]

#koderia
[voice id="v00771"]
#koderia
ありがとうございます。[p]

#
小出里亜は丁寧な手つきで、叡留久のカップに紅茶を注いだ。[p]

[chara_hide_all]
[charapos name="koderia" face="normal" num="0"]

#koderia
[voice id="v00772"]
#koderia
……申し訳ありません。少しだけ、席を外させていただきます。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00773"]
#mahoru
どうかしたんですか？[p]
[reset_message_chara]

#koderia
[voice id="v00774"]
#koderia
いえ、お手洗いに。[p]
[voice id="v00775"]
#koderia
すぐに戻りますので。[p]

#
小出里亜はポットを置くと、静かにダイニングを出ていった。[p]

#
——そして、いくらもしないうちに戻ってきた。[p]

#
戻ってきた小出里亜は、給仕に戻る前に一度だけ足を止めて。[p]
#
和人の座っている方へ、まっすぐに視線を向けた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00776"]
#mahoru
（……和人の方を見てる）[p]

[voice id="v00777"]
#mahoru
（気のせい、かな）[p]
[reset_message_chara]

#
小出里亜はすぐに表情を戻すと、何事もなかったようにポットを取り上げた。[p]

[chara_hide_all]
[jump target="*tea_talk_loop"]


;==========================================================
; ④ 叡留久 ―― スマートフォン（SNS の伏線）
;==========================================================
*tea_eruku
[eval exp="f.tea_eruku = 1"]
[eval exp="f.tea_turn = f.tea_turn + 1"]
[advance_time min=8]
[gage_draw place="舞黒館:ダイニング"]
[show_menu]

[chara_hide_all wait="false"]
[charapos name="eruku" face="normal" num="0" wait="false"]

#
叡留久は紅茶を片手に、時折スマートフォンへ目を落としていた。[p]
#
何度か画面を操作しては、また伏せる。それを繰り返している。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00778"]
#mahoru
お仕事ですか？[p]
[reset_message_chara]

[chara_mod name="eruku" face="surprised2"]
#eruku
[voice id="v00779"]
#eruku
おっと、見られてしまったか。[p]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v00780"]
#eruku
ああ、仕事の連絡でね。[p]
[voice id="v00781"]
#eruku
ちょうど今、新しい事業の話が動いているところなんだ。[p]

#eruku
[voice id="v00782"]
#eruku
この庭園の花と、歴史ある洋館……。[p]
[voice id="v00783"]
#eruku
香りと美容に特化した店を出せたら面白いと思ってね。[p]
[voice id="v00784"]
#eruku
美味しい紅茶を飲みながら、体に良いものをつまめる——そんな空間さ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00785"]
#mahoru
わあ、素敵ですね。行ってみたいです。[p]
[reset_message_chara]

#eruku
[voice id="v00786"]
#eruku
だろう？　……っと、いけない。[p]
[voice id="v00787"]
#eruku
今日は仕事のことは忘れると、珠璃と約束したんだった。[p]

#
叡留久はスマートフォンを伏せて、上着のポケットにしまった。[p]

; 休暇中でも仕事の連絡を手放せないこと、珠璃との約束が分かった
[set_item_status id="chara_05" secret="true"]
[get_item id="chara_05" type="info"]

;── 経路B：内ポケットの口紅を気にしている ──
[if exp="f.route_b == 1"]
; ▼ 以下、新規会話は要ボイス収録
#
その手が一瞬だけ、内ポケットのあたりで止まる。[r]
#
何かを確かめるように押さえてから、すぐに離した。[p]
[endif]
;── 経路B ここまで ──

#
——けれど、それからしばらくして。[p]
#
彼はまた、テーブルの下でこっそりと画面を確認していた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v00788"]
#mahoru
（そんなに急ぎのご用事なのかな）[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*tea_talk_loop"]


;==========================================================
; ⑤ 珠璃 ―― 馴れ初めの話
;==========================================================
*tea_juri
[eval exp="f.tea_juri = 1"]
[eval exp="f.tea_turn = f.tea_turn + 1"]
[advance_time min=8]
[gage_draw place="舞黒館:ダイニング"]
[show_menu]

[chara_hide_all wait="false"]
[charapos name="juri" face="normal" num="1" wait="false"]
[charapos name="eruku" face="smile" num="2" wait="false"]

#
珠璃は叡留久の隣で、静かに紅茶を口に運んでいた。[p]
#
夫が身振り手振りで何かを話すたび、呆れたように、けれど楽しそうに相槌を打っている。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00789"]
#mahoru
ふふっ、お二人とも本当に仲が良いですね。[p]
[voice id="v00790"]
#mahoru
お二人の馴れ初めって、どんな感じだったんですか？[p]
[reset_message_chara]

#eruku
[voice id="v00791"]
#eruku
ははは、俺たちかい？[p]
[voice id="v00792"]
#eruku
学生の頃、全国有数の女子高に通う珠璃を見かけてね。[p]
[voice id="v00793"]
#eruku
一目惚れして、何度も何度もアプローチをして、やっと付き合ってもらえたんだ。[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00794"]
#juri
ええ。[p]
[voice id="v00795"]
#juri
この人のしつこいアプローチに、私が根負けしたのよ。[p]

#
珠璃は上品に微笑んだ。[p]

#eruku
[voice id="v00796"]
#eruku
俺はいつも仕事ばかりだからな。[p]
[voice id="v00797"]
#eruku
今日は二人で楽しもうということで、ここへ来たんだ。[p]
[voice id="v00798"]
#eruku
……まあ、さっきも少し仕事をしてしまったけどね。ははは！[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v00799"]
#juri
……仕方のない人ね。[p]

#
珠璃は呆れたようにため息をついたが、その態度は慣れたものだった。[p]

[message_chara name="airi" face="surprised"]
#airi
[voice id="v00800"]
#airi
（これが、大人の恋が実った結果……。いいなあ！）[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="mary" face="normal" num="1"]
[charapos name="eruku" face="normal" num="2"]

#mary
[voice id="v00801"]
#mary
叡留久さんは、どうしてこの場所を選ばれたんですか？[p]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v00802"]
#eruku
横浜という街は、人を集めるのにとても適しているからね。[p]
[voice id="v00803"]
#eruku
次のビジネスの拠点にしようという考えもあった。[p]
[voice id="v00804"]
#eruku
それから……珠璃が洋館を好きだというのも、理由の一つさ。[p]

#
その言葉を聞いて、珠璃は何も言わずに嬉しそうに微笑んだ。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00805"]
#mary
素敵ですね。[p]
[voice id="v00806"]
#mary
いつか、私も……。[p]

#
メアリーは何かを言いかけたが、ふと口をつぐみ、少し寂しそうに視線を落とした。[p]

[chara_hide_all]
[jump target="*tea_talk_loop"]


;==========================================================
; ⑥ メアリー ―― 紅茶を語る（飲まないことへの違和感の下地）
;==========================================================
*tea_mary
[eval exp="f.tea_mary = 1"]
[eval exp="f.tea_turn = f.tea_turn + 1"]
[advance_time min=8]
[gage_draw place="舞黒館:ダイニング"]
[show_menu]

[chara_hide_all wait="false"]
[charapos name="mary" face="normal" num="0" wait="false"]

#
メアリーはカップを両手で包むようにして、立ちのぼる香りを確かめていた。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00807"]
#mahoru
メアリーさん、紅茶がお好きなんですか？[p]
[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00808"]
#mary
ええ、大好きです。[p]
[voice id="v00809"]
#mary
イギリスでは、一日に何杯も飲みますから。[p]

#mary
[voice id="v00810"]
#mary
祖母がとても紅茶にうるさい人で。[p]
[voice id="v00811"]
#mary
茶葉の量も、お湯の温度も、蒸らす時間も——全部きっちり決まっているんです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00812"]
#mahoru
そんなに違うものなんですか？[p]
[reset_message_chara]

#mary
[voice id="v00813"]
#mary
違いますよ。[p]
[voice id="v00814"]
#mary
同じ茶葉でも、淹れ方ひとつで別の飲み物になります。[p]

#mary
[voice id="v00815"]
#mary
香りを嗅げば、だいたい分かります。[p]
[voice id="v00816"]
#mary
どこの茶葉で、どんなふうに淹れられたのか。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00817"]
#mahoru
すごい……。[p]
[voice id="v00818"]
#mahoru
じゃあ、今日の紅茶はどうですか？[p]
[reset_message_chara]

#
メアリーはカップに鼻を近づけて——ほんの少しだけ、眉を寄せた。[p]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v00819"]
#mary
……とても良い茶葉です。[p]
[voice id="v00820"]
#mary
朱志香さんが選ばれただけのことはありますね。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00821"]
#mary
きっと、この館にいちばん似合うお茶ですよ。[p]

#
そう言って、メアリーは嬉しそうに微笑んだ。[p]

;--- 語るだけ語って、カップには手をつけない ---
#
——けれど。[p]
#
そのカップは、テーブルに置かれたままだった。[p]

[chara_hide_all]
[jump target="*tea_talk_loop"]

;==========================================================
; 紅茶の交換（お茶会の締め）
;==========================================================
*tea_exchange
[gage_draw place="舞黒館:ダイニング"]
[show_menu]
[chara_hide_all]

;----------------------------------------------------------
; 紅茶の交換
;----------------------------------------------------------
#
愛理は一杯目を早々に飲み干して、二杯目にはコーヒーを頼んでいた。[p]

#
お茶会が和やかに進む中、愛理がメアリーの手元を見て首を傾げた。[p]

@bg storage="event/airi_mary_tea.png" cross="true"

#airi
[voice id="v00822"]
#airi
メアリーさん、どうかしたんですか？[p]
[voice id="v00823"]
#airi
紅茶、全然手をつけていないみたいですけど……。[p]

#mary
[voice id="v00824"]
#mary
ああ……。[p]
[voice id="v00825"]
#mary
実は、この紅茶の香りが、あまり好きじゃなくて……。[p]

#airi
[voice id="v00826"]
#airi
そうだったんですね。[p]
[voice id="v00827"]
#airi
もしよかったら、私もらいますよ？[p]
[voice id="v00828"]
#airi
この香り好きなんです。[p]

#mary
[voice id="v00829"]
#mary
いいんですか？[p]
[voice id="v00830"]
#mary
ありがとうございます、愛理さん。[p]

#airi
[voice id="v00831"]
#airi
どういたしまして。[p]
[voice id="v00832"]
#airi
ところでお菓子は食べないんですか？[p]

#mary
[voice id="v00833"]
#mary
最近おなか周りが少し気になるので、今日は我慢の日です。[p]

#airi
[voice id="v00834"]
#airi
メアリーさん綺麗だから、そんなこと気にしなくてもいいと思いますよ。[p]

#mary
[voice id="v00835"]
#mary
ありがとうございます、愛理さん。[p]
[voice id="v00836"]
#mary
愛理さんもとても綺麗ですよ。[p]

#airi
[voice id="v00837"]
#airi
ふふっ、ありがとうございます。[p]
[voice id="v00838"]
#airi
うん、やっぱり紅茶は美味しいです。[p]

#mary
[voice id="v00839"]
#mary
ふふふ、それは良かったです。[p]
[voice id="v00840"]
#mary
私、お手洗いに行ってきますね。[p]

@bg storage="event/airi_mary_tea2.png" cross="true" time="5000"

#airi
[voice id="v00841"]
#airi
メアリーさん、紅茶好きって言っていたのに……。[p]
[voice id="v00842"]
#airi
もったいない、こんなにおいしいのになあ……。[p]

; ※ メアリーが紅茶を飲まなかったことへの違和感は、ここでは真歩流に言わせない。
;   調査パートで気づかせるため、f.tea_mary（談義を聞いたか）だけ残してある。

;----------------------------------------------------------
; ペンダント紛失事件と執務室へ
;----------------------------------------------------------
[mask effect="fadeInDown"]
[chara_hide_all]
@bg storage="dining.png"
[gage_draw place="舞黒館:ダイニング"]
; 自由行動で 4回×8分＝32分 進んでいるので、締めは 8分だけ（合計40分で従来どおり）
[advance_time min=8]
[mask_off]

#
お茶会が終わって、参加者たちが立ち上がり、朱志香と小出里亜が机の上のものを片付け始めた時のことだった。[p]

[charapos name="mary" face="surprised" num="0"]

#mary
[voice id="v00843"]
#mary
あっ……！[p]
[voice id="v00844"]
#mary
ない……私のペンダントが、ない……！[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v00845"]
#mahoru
えっ、ペンダントって、あの大切な……！？[p]
[voice id="v00846"]
#mahoru
どこで落としたか覚えてますか？[p]

[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v00847"]
#mary
机の上に、置いておいたはずなんです。[p]
[voice id="v00848"]
#mary
でも、どこにも……。[p]

[chara_hide_all]
[charapos name="jushika" face="thinking" num="1"]
[charapos name="koderia" face="normal" num="2"]

#jushika
[voice id="v00849"]
#jushika
机の上……。[p]
[voice id="v00850"]
#jushika
もしかすると、先ほど机の上のものをまとめて片付けた時に、一緒になってしまったのかもしれません。[p]

#koderia
[voice id="v01460"]
すぐに確認してまいります。[p]

#jushika
[voice id="v01461"]
片付けたものは、一度執務室へ運びました。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01462"]
私たちも手伝います。人数が多い方が、早く見つかると思いますから。[p]
[reset_message_chara]

#jushika
[voice id="v01463"]
……そうですね。それでは、皆様も一緒にお願いいたします。[p]

[chara_hide_all]
[playse storage="walk.mp3" sprite_time="00:00-00:04"]
[bg storage="hallway.png" time=2000 cross="true"]
[bg storage="office.png" time=2000 cross=true]
[gage_draw place="舞黒館:執務室"]

#
私たちは朱志香に連れられ、館の奥にある執務室へと足を踏み入れた。[p]

[charapos name="jushika" face="normal" num="0"]

#jushika
[voice id="v01464"]
ここは、かつて舞黒邦夢様が執務室として使っていた部屋です。[p]

#jushika
[voice id="v01465"]
古い家具や貴重な品も残っていますので、気をつけて探しましょう。[p]

[chara_hide_all]
[charapos name="airi" face="normal" num="0"]

@message_chara name=mahoru face=normal

#mahoru
[voice id="v00857"]
#mahoru
よし、手分けして探そう！[p]

@reset_message_chara

#airi
[voice id="v00858"]
#airi
うん。あっちの箱の中に入ってるかもしれない。[p]

#
私たちは執務室の中を探し始めた。[p]
#
机の引き出し、棚の中、箱の中……。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01466"]
あ、あそこに見えているのは……もしかして。[p]
[reset_message_chara]

#
棚の下に、小さな光が見えた。[p]

#
同じとき、朱志香は机の上に置かれていた茶葉の缶を手に取ると、壁際の古い収納棚へしまった。[p]

#
缶を奥へ押し込み、棚の扉を閉めた――その直後だった。[p]

[playse storage="door_locked.mp3"]

#
壁の内側から、重い金属が噛み合う音が響いた。[p]

[chara_hide_all]
[charapos name="eruku" face="surprised" num="0"]

#eruku
[voice id="v01467"]
……今の音は？[p]

#
叡留久が扉へ手をかけたが、扉はびくともしなかった。[p]

#eruku
[voice id="v01468"]
だめだ。鍵が掛かっている。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01469"]
えっ！？　さっきまでは開いていたのに……！[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="jushika" face="surprised" num="0"]

#jushika
[voice id="v01470"]
こんな仕掛け、私は知りません。[p]

#
皆で手分けして壁や家具を調べると、入口脇の壁板がわずかに浮いていた。[p]
#
板を外した奥には、いくつもの絵柄が並ぶ古い操作盤が隠されていた。[p]

#
その下には、かすれた文字が刻まれている。[p]

#
「同じ絵を揃えた者に、扉を開こう――舞黒邦夢」[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01471"]
舞黒邦夢さんの仕掛け……？[p]
[reset_message_chara]

#
操作盤を調べようとした、その時だった。[p]

[playse storage="earthquake.mp3"]
[quake time=3000 hmax="20" vmax="10"]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01472"]
きゃっ！？[p]
[reset_message_chara]

[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v01473"]
地震……！　皆さん、伏せてください！[p]

#
突然の激しい揺れに、私たちは急いで身を低くした。[p]

[playse storage="crash.mp3"]

#
棚の上の重い装飾品が滑り落ち、今も使用されていた古いガス灯を直撃した。[r]
#
継ぎ目が弾け飛び、鈍い破裂音が響く。[p]

[playse storage="gas_leak.mp3"]
[layermode layer="1" time=500 mode="screen" color="0x55ff55" opacity=100]

#
揺れは収まったが、破損した支管からガスの匂いが室内へ広がっていく。[p]

[chara_hide_all]
[charapos name="kazuto" face="impatience" num="1"]
[charapos name="eruku" face="surprised" num="2"]
[playbgm storage="crisis.mp3"]

#kazuto
[voice id="v01474"]
叡留久さん、布を！　俺と二人で漏れている箇所を押さえて！[p]

#eruku
[voice id="v01475"]
わかった！[p]

#
和人と叡留久は厚い布を破損箇所へ押し当て、噴き出すガスを少しでも食い止めようとした。[p]

[chara_hide_all]
[charapos name="jushika" face="surprised" num="0"]

#jushika
[voice id="v01476"]
この支管の元栓は廊下側にあります。ここからでは閉められません……！[p]

[chara_hide_all]
[charapos name="airi" face="surprised" num="0"]

#airi
[voice id="v01477"]
だったら、扉を開けるしかない！[p]

#airi
[voice id="v01478"]
お姉ちゃんは絵合わせをお願い。私たちは、ほかに出口がないか探すから！[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01479"]
わかった！[p]

#mahoru
[voice id="v01480"]
ガスが充満する前に、絶対に開けてみせる……！[p]
[reset_message_chara]

[chara_hide_all]

#TIPS
このイベントは失敗するとゲームオーバーとなるため、セーブをすることをお勧めします。[p]

[chapter_end]

[chara_hide_all]

;----------------------------------------------------------
; パズルゲーム呼び出し
;----------------------------------------------------------
[iscript]
// パズルゲームをストーリーモードで実行するための設定
tf.puzzle_mode = 'story';
[endscript]

[call storage="puzzle.ks"]

; パズルの結果によって分岐
[if exp="tf.puzzle_result == 'success'"]
[jump target="*puzzle_clear"]
[else]
[jump target="*puzzle_fail"]
[endif]


;----------------------------------------------------------
; 失敗（ゲームオーバー）
;----------------------------------------------------------
*puzzle_fail
[fadeoutbgm]
[position layer="message0" page=fore visible=true]
[cm]
[free_layermode]
[bg storage="dark.png" time=1000]

#
ガスが部屋に充満し、意識が遠のいていく……。[p]
#
私たちは、息苦しさの中で力尽きた。[p]

[cm]
[free_layer_image]
[layopt layer="message0" page=fore visible=false]
[jump storage="title.ks"]


;----------------------------------------------------------
; 成功（脱出と能力の予兆）
;----------------------------------------------------------
*puzzle_clear
[show_menu]
[fadeoutbgm]
[cm]
[free_layermode]
[playse storage="door_open.mp3"]
[position layer="message0" page=fore visible=true]

; ガスイベント終了：16:25 に確定
[set_time hour=16 min=25]
[chara_hide_all]
[charapos name="airi" face="surprised" num="0"]

@message_chara name=mahoru face=surprised
#mahoru
[voice id="v00884"]
#mahoru
開いたっ！[p]

@reset_message_chara

#
ロックされた扉が開いた。[p]
#
その拍子に、内側の板がわずかにずれ、[r]
#
その裏に、彫り込まれた文字が覗いている。[p]
#
しかし、今は読んでいる暇などない。[p]

#airi
[voice id="v00885"]
#airi
お姉ちゃん、ナイス！ 皆さん、早く外へ！[p]
[mask]
[bg storage="hallway_second.png" time=500]
[gage_draw place="舞黒館:廊下(2F)"]
[mask_off]

#
私たちは間一髪で執務室から脱出し、廊下で大きく息を吸い込んだ。[p]

#
朱志香がすぐに廊下側の元栓を閉めると、破損した支管から噴き出していたガスが止まった。[p]

[chara_hide_all]
[charapos name="mary" face="surprised" num="0"]

#mary
[voice id="v00886"]
#mary
あ……！[p]
[voice id="v00887"]
#mary
真白さんが持っているのは……！[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00888"]
#mahoru
え？[p]

#
私の手の中には、いつの間にかメアリーさんのペンダントが握られていた。[p]
#
無意識のうちに拾い上げていたらしい。[p]

#mahoru
[voice id="v00889"]
#mahoru
あ、よかった。見つかって……。[p]

#
ペンダントを握りしめた、その瞬間。[p]

[pre_resonance]
[chara_mod name="mahoru" face="surprised"]

#mahoru
[voice id="v00890"]
#mahoru
っ……！？[p]

#
頭の奥で、強烈なノイズが弾けた。[p]

#
『……だ。……が……あさんを……』[p]

#mahoru
[voice id="v00891"]
#mahoru
（……え？ 今の、声……？）[p]
[reset_message_chara]

#
誰かの感情の波が、直接脳内に流れ込んでくるような……奇妙な感覚。[p]
#
私は咄嗟に首を振り、そのノイズを頭から追い出した。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00892"]
#mahoru
はい、メアリーさん。[p]
[voice id="v00893"]
#mahoru
大切なもの、見つかってよかったですね。[p]

[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00894"]
#mary
……ありがとうございます、真白さん。[p]

#
メアリーはペンダントを受け取ると、何も言わずに私を静かに見つめていた。[p]

[chara_hide_all]
[mask effect="fadeInDown"]
[playbgm storage="tea_party.mp3"]
[advance_time min=5]
[mask_off]

;----------------------------------------------------------
; 叡留久と写真
;----------------------------------------------------------
; 脱出後の後処理・叡留久シーン +5分 → 16:30

#
廊下側の元栓を閉め、扉を開けたまましばらく空気を入れ替えた。[p]

[bg storage="office.png" time=500]
[gage_draw place="舞黒館:執務室"]

#
私たちは、恐る恐る執務室へ戻った。[p]

[charapos name="jushika" face=normal num=0]
#jushika
[voice id="v00895"]
#jushika
もう大丈夫です。[p]
[voice id="v00896"]
#jushika
入ってきて問題ないですよ。[p]

[chara_hide_all]

[charapos name="eruku" face=normal num=1]
[charapos name="jushika" face=surprised num=2]

#eruku
[voice id="v00897"]
#eruku
ふう、何事もなくて安心だ。[p]

#eruku
[voice id="v01481"]
まさか、館に残っていた古い仕掛けで閉じ込められるとはな。[p]

#jushika
[voice id="v01482"]
申し訳ありません。私も、あのような仕掛けが残っているとは知りませんでした。[p]

#
外れた壁板の裏側には、小さな金属板が取り付けられていた。[p]

#eruku
[voice id="v01483"]
「客人諸君、余興は楽しめただろうか――舞黒邦夢」……だとさ。[p]

@chara_mod name="jushika" face="normal"

#eruku
[voice id="v01484"]
実に楽しませてもらったよ……ハプニングもあったがね。[p]

#jushika
[voice id="v01485"]
きっと、客人の驚いた顔を見たかったのでしょうね……。[p]

#jushika
[voice id="v01486"]
館を預かる私も、ドキッとしたくらいですから。[p]

#eruku
[voice id="v01487"]
では、執務机についている新しい電子錠は？　あれも邦夢の仕掛けですか？[p]

#jushika
[voice id="v01488"]
いいえ。あちらは館を購入した後、重要な書類を守るために私が業者へ頼んで取り付けたものです。[p]

[voice id="v00903"]
#eruku
ん？ この写真は……。[p]

#
部屋の隅に落ちていた荷物の中に、古い写真立てが転がっているのを叡留久が見つけた。[p]

@chara_hide_all

[image visible="true" layer="2" folder="image/item" storage="photo.png" x=300 y=200]

[voice id="v00904"]
#eruku
朱志香さん。これは……朱志香さんとご主人の写真ですか？[p]

#jushika
[voice id="v00905"]
#jushika
……ええ。[p]
[voice id="v00906"]
#jushika
半年前に亡くなった主人との、最後の写真です。[p]

#eruku
[voice id="v00907"]
#eruku
綺麗なところですね。[p]

#jushika
[voice id="v00908"]
#jushika
主人のお気に入りの場所だったんです。[p]
[voice id="v00909"]
#jushika
この時はもう後がないことがわかっていましたから。[p]
[voice id="v00910"]
#jushika
最後の思い出に撮ったのです。[p]

#eruku
[voice id="v00911"]
#eruku
そうでしたか。[p]
[voice id="v00912"]
#eruku
きっとご主人もいい思い出と共に旅立たれたことと思います。[p]

[freeimage layer="2" time=1000 wait="true"]

[charapos name="kazuto" face="normal" num="1"]

#kazuto
[voice id="v00913"]
#kazuto
……。[p]

[charapos name="koderia" face="normal" num="2"]


#koderia
[voice id="v00914"]
#koderia
和人様、どうかされましたか？[p]

#kazuto
[voice id="v00915"]
#kazuto
何でもない。[p]
[voice id="v00916"]
#kazuto
先に下に戻る。[p]

#
和人は言い捨てると話しかけようとする小出里亜を無視し、足早に部屋を出ていった。[p]

[chara_hide name="kazuto"]

#koderia
[voice id="v00917"]
#koderia
徐音……和人。[p]

[charapos name="juri" face="normal" num="1"]
#juri
[voice id="v00918"]
#juri
どうかしたの？[p]
[voice id="v00919"]
#juri
彼のことが気になるのかしら？[p]

#koderia
[voice id="v00920"]
#koderia
そういうわけでは……いえ、そうですね。[p]
[voice id="v00921"]
#koderia
確証はないんですけど、徐音様は何かを隠しています。[p]

[chara_mod name="juri" face="thinking"]
#juri
[voice id="v00922"]
#juri
隠している……？[p]
[voice id="v00923"]
#juri
いったい何を？[p]

#koderia
[voice id="v00924"]
#koderia
わかりません。[p]
[voice id="v00925"]
#koderia
でも、そんな気がするんです。[p]

[chara_mod name="juri" face="normal"]

#juri
[voice id="v00926"]
#juri
そう……。[p]
[voice id="v00927"]
#juri
なら、彼に直接聞いてみればいいじゃない。[p]
[voice id="v00928"]
#juri
何か隠していませんか？ってね。[p]

[chara_mod name="koderia"face="smile"]

#koderia
[voice id="v00929"]
#koderia
ふふふ。そうですね。[p]

[mask effect="fadeInDown"]
[chara_hide_all]
[bg storage="hallway.png"]
[gage_draw place="舞黒館:廊下(1F)"]
[mask_off]
[charapos name="kazuto" face="normal" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00930"]
#mahoru
あれ、和人。[p]
[voice id="v00931"]
#mahoru
どうしたの？[p]

[reset_message_chara]

#kazuto
[voice id="v00932"]
#kazuto
お前が持っていたペンダント、あれはどこにあったんだ？[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00933"]
#mahoru
え？ ああ、あれは……。[p]
[voice id="v00934"]
#mahoru
机の上の書類の間に挟まっていたの。[p]
[voice id="v00935"]
#mahoru
いつの間にかつかんでいたみたい。[p]

[reset_message_chara]

#kazuto
[voice id="v00936"]
#kazuto
……そうか。[p]
[voice id="v00937"]
#kazuto
なあ、お前はペンダントがどうして執務室にあったと思う？[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00938"]
#mahoru
え、小出里亜さんが間違って持ってきたんじゃないの？[p]

[reset_message_chara]

#kazuto
[voice id="v00939"]
#kazuto
よく考えてみろ。[p]
[voice id="v00940"]
#kazuto
あそこは執務室だ。館内の貴重品を保管している場所だぞ。[p]
[voice id="v00941"]
#kazuto
そこにメイドが出入りしていると思うか？[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00942"]
#mahoru
確かに変だけど。[p]
[voice id="v00943"]
#mahoru
じゃあ、朱志香さん？[p]
[voice id="v00944"]
#mahoru
でも、誰でも間違えることはあるよ。[p]

[reset_message_chara]

#kazuto
[voice id="v00945"]
#kazuto
間違える？[p]
[voice id="v00946"]
#kazuto
いいか、メアリーのペンダントは執務室にあった。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00947"]
#mahoru
うん、そうだね。[p]

[reset_message_chara]


#kazuto
[voice id="v00948"]
#kazuto
お前は机の上のものを片付けるために、わざわざ執務室に行くか？[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00949"]
#mahoru
……まさか、どこか近くにまとめておくよ。[p]
[voice id="v00950"]
#mahoru
大事なものとかあったら別だけど。[p]
[voice id="v00951"]
#mahoru
だからどうしたの？[p]

[reset_message_chara]

#kazuto
[voice id="v00952"]
#kazuto
富礼知はわざわざ執務室にペンダントを含めた荷物を持って行った。[p]
[voice id="v00953"]
#kazuto
お前の言うとおり、貴重な品でもあれば別だが、わざわざ執務室に荷物を運んだ理由は何だと思う？[p]

#
和人に言われてようやく気づいた。[p]
#
なぜ朱志香さんがペンダントを執務室に持っていったのか。[p]
#
間違えて持って行ってしまったのか、それとも……。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00954"]
#mahoru
わからないけど、間違えたんじゃなければ何か事情があったんじゃない？[p]
[voice id="v00955"]
#mahoru
なんにせよ、見つかってよかったよ。[p]

[reset_message_chara]

#kazuto
[voice id="v00956"]
#kazuto
何もわかっていないな。[p]
[voice id="v00957"]
#kazuto
……忠告しておく。[p]
[voice id="v00958"]
#kazuto
お前はいつか必ず痛い目を見ることになる。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v00959"]
#mahoru
どうして？[p]

[reset_message_chara]

#kazuto
[voice id="v00960"]
#kazuto
それが自覚できないからだ。[p]
[voice id="v00961"]
#kazuto
まあ、いい。[p]
[voice id="v00962"]
#kazuto
俺は先に戻る。[p]

[chara_hide_all]

#
和人はそう言い捨てると、足早にリビングへと向かった。[p]

[message_chara name="mahoru" face="light_thinking"]

#mahoru
[voice id="v00963"]
#mahoru
和人、どうしてあんなに怒っているんだろう……。[p]
[voice id="v00964"]
#mahoru
私何かしたのかな……。[p]

[reset_message_chara]
[get_item id="photo"]
[set_item_status id="photo" owned="true"]

[chapter_end]

[jump storage="scene4.ks" target="*start"]

;===============================================================================
; 経路A：お茶会までの自由時間
;   15:05頃から3回行動。1回につき5分進む。
;   同じ場所を選んでも、時間経過でそこにいる人物・出来事が変わる。
;   殺人事件前なので「怪しい人物を探す」のではなく、宿泊客として自由に過ごす。
;   事件解決に必須の「珠璃が席順とカップを決める場面」は自由時間後に必ず表示する。
;   真エンドの伏線になる朱志香と小出里亜の会話もプレイヤーには必ず提示するが、
;   真歩流本人はその場にいない。
;===============================================================================

*s3a_living_start
[cm]
[chara_hide_all]
[reset_message_chara]

[bg storage="living.png" time=500]
[gage_draw place="舞黒館:リビング" hide_time="true"]
[show_menu]
[charapos name="airi" face="normal" num="0"]

#airi
[voice id="v00965"]
#airi
お茶会までは、まだ少し時間があるみたいだね。[p]
; ▼ 要ボイス再録：v00966（旧「せっかくだし、館の中を少し歩いてみる？」）
[voice id="v00966"]
#airi
リビングで待たせてもらおうか。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00967"]
#mahoru
いいね！[p]
; ▼ 要ボイス再録：v00968（旧「さっきまでみんなで話してたし、好きに過ごしてみようか。」）
[voice id="v00968"]
#mahoru
さっきまでみんなで話してたし、少し休もうか。[p]
[reset_message_chara]

;----------------------------------------------------------
; メアリーの香水
;   香りに敏感であることを、ここで一度だけ見せておく。
;   お茶会でメアリーが紅茶に口をつけない理由に繋がる。
;----------------------------------------------------------
[chara_hide_all]
[charapos name="mary" face="normal" num="1"]
[charapos name="airi" face="normal" num="2"]

#
リビングでは、メアリーが窓辺で小さなガラス瓶を光に透かしていた。[p]

#airi
[voice id="v00969"]
#airi
綺麗な瓶ですね。香水ですか？[p]

#mary
[voice id="v00970"]
#mary
ええ。自分で調合したものなんです。[p]
[voice id="v00971"]
#mary
香りを考えている時間が好きで、旅行にもいつも持ってきてしまうんですよ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00972"]
#mahoru
へえ、自分で作れるんだ！[p]
[reset_message_chara]

#airi
[voice id="v00973"]
#airi
こうしてると、本当に旅行に来たみたいですね。[p]

#mary
[voice id="v00974"]
#mary
ふふ。私は、こういう古い洋館に来ると落ち着くんです。[p]

; ここで一度、サンルームで起きていることを見せる。
; このあと珠璃がリビングへ来るのは、この場面が理由。
[chara_hide_all]
[mask effect="fadeInDown"]
[jump target="*s3_sunroom_juri"]


;==========================================================
; リビング：舞黒館と庭園の話
;   珠璃が席を外したあと、叡留久と小出里亜の二人が中心になる。
;   ここで置く伏線は三つ。
;     ・灰音家と富礼知家が古い工事で繋がっていたこと
;     ・その付き合いが、あるときを境に途絶えたこと（小出里亜の出自）
;     ・庭園を造り、草花を指定したのが亡くなった富礼知であること
;   経路Bではメアリーが館の来歴を詳しく語る。経路Aでは伝聞の範囲に留める。
;==========================================================
*s3a_living_talk
[cm]
[show_menu]
[bg storage="living.png" time=500]
[gage_draw place="舞黒館:リビング" hide_time="true"]
[chara_hide_all]
[charapos name="mary" face="normal" num="1"]
[charapos name="airi" face="normal" num="2"]

#
しばらくして、廊下の方から足音が近づいてきた。[p]

[charapos name="juri" face="normal" num="3"]
#juri
[voice id="v00975"]
#juri
あら。皆さん、こちらにいたのね。[p]

#juri
[voice id="v00976"]
#juri
もう少ししたらお茶会ね。[p]
[voice id="v00977"]
#juri
こういう場所でいただく紅茶は、きっと格別でしょうね。[p]

#airi
[voice id="v00978"]
#airi
楽しみです！[p]

; ▼ 以下、新規会話は要ボイス収録
#juri
[voice id="v03786"]
……ごめんなさい。少しお手洗いをお借りするわ。[p]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v03787"]
でしたら、私もご一緒します。場所を教えていただけますか。[p]

#
二人は連れ立ってリビングを出ていった。[p]

[chara_hide name="juri"]
[chara_hide name="mary"]

;----------------------------------------------------------
; 叡留久と小出里亜
;----------------------------------------------------------
[chara_hide_all]
[charapos name="eruku" face="smile" num="0"]

#
入れ替わりに、叡留久が顔を出した。[p]

#eruku
[voice id="v03788"]
やあ。君たちはここにいたのか。[p]

#eruku
[voice id="v03789"]
散歩のあとは、どうも手持ち無沙汰でね。[p]

#
そこへ、盆を抱えた小出里亜が入ってきた。[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="1"]
[charapos name="koderia" face="smile" num="2"]

#koderia
[voice id="v03790"]
お茶の支度が一段落しましたので、少しだけ手が空きました。[p]

#koderia
[voice id="v03791"]
カップの数も揃いましたし、あとはお時間を待つばかりです。[p]

;--- 舞黒館の来歴（伝聞の範囲） ---------------------------
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03792"]
小出里亜さん。この舞黒館って、舞黒邦夢さんが建てたんですよね。[p]
[reset_message_chara]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v03793"]
ええ。ずいぶん昔の方ですけれど。[p]

#koderia
[voice id="v03794"]
私も、朱志香様から伺った程度のことしか存じ上げないのですが……[p]

#koderia
[voice id="v03795"]
戦争の前に、この洋館で大きな工事があったそうです。[p]

#koderia
[voice id="v03796"]
そのときに、灰音の家と——富礼知の家も、協力していたと。[p]

[chara_mod name="eruku" face="surprised2"]
#eruku
[voice id="v03797"]
へえ。じゃあ、富礼知家とは古い付き合いなんだね。[p]

#koderia
[voice id="v03798"]
そう聞いています。……ただ。[p]

#koderia
[voice id="v03799"]
あるときを境に、お付き合いはほとんど無くなってしまったそうで。[p]

#koderia
[voice id="v03800"]
理由までは、私も聞かされておりません。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v03801"]
（……そうなんだ）[p]
[reset_message_chara]

;--- 庭園を造ったのは誰か ----------------------------------
[chara_mod name="eruku" face="normal"]
#eruku
[voice id="v03802"]
じゃあ、もうひとつ聞いてもいいかい。[p]

#eruku
[voice id="v03803"]
あの庭園も、舞黒邦夢さんが作ったのかい？[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v03804"]
いいえ。あの庭園を造られたのは、亡くなった富礼知様です。[p]

#koderia
[voice id="v03805"]
舞黒館をお買いになってしばらくして、庭を造られたと聞いています。[p]

#koderia
[voice id="v03806"]
植える草花は全て富礼知様がご指定なさって、手入れは市の方にお任せしていたそうですよ。[p]

[chara_mod name="eruku" face="thinking"]
#eruku
[voice id="v03807"]
……へえ。[p]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v03808"]
参考になるよ。ありがとう。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v03809"]
お役に立てたのなら何よりです。[p]

#koderia
[voice id="v03810"]
それでは、私はそろそろ戻りますね。[p]

#
小出里亜は一礼して、キッチンへ戻っていった。[p]

[chara_hide name="koderia"]

[chara_mod name="eruku" face="normal"]
#eruku
[voice id="v03811"]
さて。僕もそろそろ動くとしよう。[p]

#
叡留久もリビングを出ていく。[p]

;----------------------------------------------------------
; 廊下：叡留久のスマートフォン
;----------------------------------------------------------
[chara_hide_all]
[mask effect="fadeInDown"]
[bg storage="hallway.png" time=500]
[gage_draw place="舞黒館:廊下" hide_time="true"]
[mask_off]

#
見送りに廊下へ出ると、叡留久は階段の手前で足を止めていた。[p]
#
スマートフォンの画面を確認し、短く何かを打ち込む。[r]
#
そして、すぐに画面を伏せた。[p]

[charapos name="eruku" face="normal" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01013"]
#mahoru
お仕事ですか？[p]
[reset_message_chara]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v01014"]
#eruku
はは、つい癖でね。[p]
[voice id="v01015"]
#eruku
せっかくの休みなのに、珠璃に怒られてしまうな。[p]

; ▼ 要ボイス収録
#
叡留久は肩をすくめると、そのまま二階へ上がっていった。[p]

[chara_hide_all]
[jump target="*s3a_before_tea"]



*s3a_before_tea
[cm]
[show_menu]
[set_time hour=15 min=20]
[bg storage="hallway.png" time=500]
[gage_draw place="舞黒館:廊下" hide_time="true"]
[chara_hide_all]
[charapos name="airi" face="normal" num="0"]

#airi
[voice id="v01016"]
#airi
そろそろお茶会の時間が近いね。[p]
[voice id="v01017"]
#airi
リビングに戻って待ってようか。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01018"]
#mahoru
うん！[p]
[reset_message_chara]

; 真歩流たちがリビングへ戻った、その頃。
; この場面はプレイヤーにだけ提示され、真歩流は見聞きしていない。
[chara_hide_all]
[mask effect="fadeInDown"]
[bg storage="kitchen.png" time=500]
[gage_draw place="舞黒館:キッチン" hide_time="true"]
[mask_off]

[charapos name="jushika" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]

#
門を閉め終えた朱志香が、小出里亜の様子を見にキッチンへと戻ってきた。[p]

#jushika
[voice id="v01019"]
#jushika
小出里亜さん、準備は順調かしら？[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v01020"]
#koderia
はい、朱志香様。[p]
[voice id="v01021"]
#koderia
準備は完璧に整っております。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v01022"]
#koderia
……朱志香様。少しお伺いしてもよろしいですか？[p]
[voice id="v01023"]
#koderia
今回のこの宿泊イベント……本当の開催理由は何なのでしょうか。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01024"]
#jushika
どういう意味かしら？[p]
[voice id="v01025"]
#jushika
山手にあるこの洋館を活用して、横浜への観光誘致を図る。[p]
[voice id="v01026"]
#jushika
その第一弾の企画として開催したと、お伝えしているはずだけれど。[p]

#koderia
[voice id="v01027"]
#koderia
ええ、存じていますよ。[p]
[voice id="v01028"]
#koderia
ですが……オータムフェスティバルで人がほとんど、そちらに行っている中での開催理由は何かなと？[p]

#
小出里亜の追及に、朱志香は静かに目を伏せた。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v01029"]
#jushika
……強いて言うなら、その中でも舞黒館にどんな人が集まるのか知りたいと思ったからよ。[p]
[voice id="v01030"]
#jushika
どうしてそんなことが気になるの？[p]

#koderia
[voice id="v01031"]
#koderia
何となく、気になっただけです。[p]

#
小出里亜はふと視線を外し、ポツリと呟いた。[p]

#koderia
[voice id="v01032"]
#koderia
朱志香様……。[p]
[voice id="v01033"]
#koderia
私は……本当の家族に……会いたいです。[p]

#
その言葉に、朱志香は一瞬目を伏せる。[p]
#
やがて、静かな声で答えた。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01034"]
#jushika
……いつか、会えるわ。[p]
[voice id="v01035"]
#jushika
きっとね……。[p]

#
朱志香はそれだけ告げると、足早にキッチンを後にした。[p]

[chara_hide name="jushika"]
[charapos name="koderia" face="normal" num="0"]

[fadeoutbgm]

#
朱志香の背中を見送った小出里亜は、ゆっくりとキッチンの棚を開けた。[p]
#
そこから小さな瓶を取り出す。[p]

[chara_mod name="koderia" face="evil"]
#koderia
[voice id="v01036"]
#koderia
……ええ、きっと。[p]


[chara_hide_all]
; このあとは執務室（朱志香が缶に印をつける場面）へ。
; リビングへの切り替えは *s3_living_a が自前で行うので、ここではしない。
[jump target="*s3_office_jushika"]

