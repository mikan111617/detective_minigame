;=========================================
; scene5.ks
; シーン：事件発生・メイドの死・事情聴取
;=========================================

*start
@clearstack
[mask]
[cm]
[clearfix]
[freeimage layer="1"]
[show_menu]
; scene4 末尾 18:00 → 夕食準備時間を経て 18:30 にセット
[set_time hour=18 min=30]
[gage_draw place="舞黒館:キッチン"]
[bg storage="kitchen.png" time=1000]
[playbgm storage="Incident_Occurred.mp3" loop=true]
[mask_off]

[call storage="system/chara.ks"]

; 事件発生パートの記録を初期化する。
; ここで拾った「気づき」が、scene6 終盤で零度警部に切れる論拠になる。
[iscript]
f.s56_insight       = {};
f.s56_urgent_acted  = 0;
f.s56_urgent_frozen = 0;
f.s56_trace_try     = 0;
// scene5 の推理で零度警部から得た信頼。scene6 の初期値へ引き継ぐ。
f.s5_reido_trust = 0;
f.s5_taken_call = 0;
f.s5_taken_pose = 0;
f.s5_taken_look = 0;
[endscript]

;=========================================
; 1. 小出里亜の発作
;=========================================

#
真歩流と愛理は悲鳴の方向へと駆け出した。[p]
#
キッチンの入り口に、小出里亜が倒れていた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01600"]
小出里亜さん！[p]
[reset_message_chara]

[chara_hide_all]

[bg storage="event/koderia_painful.png" time=1500]
[bg storage="event/koderia_painful2.png" time=1500]


#
小出里亜は床に倒れ、苦しそうに喘いでいた。[r]
#
顔面は蒼白で、額には冷や汗が浮かんでいる。[p]

[charapos name="koderia" face="painful" num="0"]

#koderia
[voice id="v01601"]
う……ぐ……っ……！[p]

[quake count=3 time=300 hmax=10 vmax=10]

#
口から呻き声が漏れる。[r]
#
体が痙攣し、激しく苦しんでいるのが分かった。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01602"]
（何が起きてるの……！？　考えて、考えて——）[p]
[reset_message_chara]


;-----------------------------------------
; ★即断① 救急車が来るまでの数十秒に、何をするか
;   選ばなかったこと・間に合わなかったことは、そのまま結果として残る
;-----------------------------------------
*s5_round1
[iscript]
tf.inc = {
storage: "scene5.ks",
tag:   "緊急",
title: "手を動かせ",
lead:  "小出里亜が痙攣している。救急車はまだ来ない。",
prompt:"――今、何をする！？",
limit: 9,
timeout: "*s5_act_none",
choices: []
};
if(!f.s5_taken_call){
tf.inc.choices.push({ text:"名前を呼び続ける", sub:"意識をこちらへ繋ぎ止める", target:"*s5_act_call" });
}

if(!f.s5_taken_look){
tf.inc.choices.push({ text:"キッチンの中を見る", sub:"何が起きたのかを掴む", target:"*s5_act_look" });
}
[endscript]
[inc_urgent]


;--- 呼びかける -------------------------------------------
*s5_act_call
[inc_back place="舞黒館:キッチン"]
[eval exp="f.s5_taken_call=1"]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01603"]
小出里亜さん！　小出里亜さん、私が分かりますか！？[p]
[reset_message_chara]

#
呼びかけに応えるように、小出里亜の瞼がわずかに震えた。[r]
#
濁った瞳が、一度だけ——真歩流の顔を捉えた。[p]

#
だが、それはほんの一瞬だった。[r]
#
視線はすぐに逸れ、真歩流の肩越し——廊下へ続く入口の方を、さまようように探しはじめた。[p]

#
そこには、まだ誰もいない。[r]
#
それでも小出里亜は、そちらを見ることをやめなかった。[p]

[inc_insight id="koderia_eyes" name="小出里亜さんは、真歩流ではない誰かを探していた"]
[jump target="*s5_act_return"]


;--- 周囲を見る -------------------------------------------
*s5_act_look
[inc_back place="舞黒館:キッチン"]
[eval exp="f.s5_taken_look=1"]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01604"]
（何が……何が原因なの……！）[p]
[reset_message_chara]

#
顔を上げ、キッチンの中を素早く見回す。[p]

#
調理台の上は、片づいている。[r]
#
ただ、コンロにかけられたポットだけが、火を止められないまま湯気を上げ続けていた。[p]

[inc_insight id="kitchen_pot" name="コンロのポットが、火にかけられたままだった"]
[jump target="*s5_act_return"]


;--- 動けなかった -----------------------------------------
*s5_act_none
[inc_back place="舞黒館:キッチン"]

#
——体が、動かなかった。[p]

#
目の前で人が壊れていくのを、ただ見ていることしかできない。[r]
#
指一本を動かすのに、途方もない時間がかかった。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01605"]
（……私、何もしてない）[p]
[reset_message_chara]

[jump target="*s5_act_return"]


;--- 即断の合流点 -----------------------------------------
*s5_act_return

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01606"]
小出里亜さん、小出里亜さん！ しっかりして！[p]
[reset_message_chara]

; 朱志香が飛び込んでくる
[chara_hide_all]
[charapos name="koderia" face="painful" num="1"]
[charapos name="jushika" face="surprised" num="2"]
[charapos name="airi" face="surprised" num="3"]

#
朱志香が真歩流の叫びを聞いて飛び込んできた。[p]

[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v01607"]
小出里亜さん！？[p]

#jushika
[voice id="v01608"]
……今すぐ救急車を呼びます！[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01609"]
朱志香さん、お願いします！[p]
[reset_message_chara]

#
朱志香はすぐにスマートフォンを取り出し、119番に通報した。[p]

; 叡留久登場
[chara_hide_all]
[charapos name="eruku" face="surprised" num="0"]

#eruku
[voice id="v01610"]
どうした！？ 何があった！？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01611"]
小出里亜さんが突然倒れて……和人を呼んできてください！ 2Fの資料室にいると思います！[p]
[reset_message_chara]

[chara_mod name="eruku" face="surprised"]
#eruku
[voice id="v01612"]
わかった！[p]

#
叡留久は迷わず2階へと駆け上がっていった。[p]

[chara_hide_all]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01613"]
小出里亜さん……！ もう少しだから、もう少しだけ——[p]
[reset_message_chara]

#koderia
[voice id="v01614"]
う……ああ……っ！[p]

[quake count=4 time=500 hmax=15 vmax=10]

#
苦しさは増すばかりで、小出里亜の体がより激しく痙攣する。[p]

;=========================================
; 2. 和人の診察と小出里亜の死
;=========================================

; 和人が駆け下りてくる
[chara_hide_all]
[charapos name="koderia" face="painful" num="1"]
[charapos name="kazuto" face="thinking" num="2"]

#
足音が廊下を走ってきた。[r]
#
和人がキッチンに飛び込み、素早く小出里亜の傍に膝をついた。[p]

#kazuto
[voice id="v01615"]
脈拍……異常に速い。それにこれは——[p]

#
和人は素早く状態を確認しながら、応急処置を試みた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01616"]
和人、小出里亜さんは——[p]
[reset_message_chara]

[chara_mod name="kazuto" face="pursue"]
#kazuto
[voice id="v01617"]
……黙っていろ。今は集中する。[p]

#
和人の手が止まらない。[r]
#
だが——それでも、小出里亜の苦しみは激しさを増していく一方だった。[p]

#koderia
[voice id="v01618"]
ぐ……う……[p]

[quake count=3 time=500 hmax=15 vmax=12]

#
小出里亜の震える手が、ゆっくりと空を掴もうとするように伸びた。[p]

#koderia
[voice id="v01619"]
……か……ん……[p]

#
それきり——手の力が抜けた。[r]
#
小出里亜の体から、すべての緊張が消えた。[p]

[wait time=1500]

[chara_mod name="kazuto" face="pursue"]

#
和人はすぐにAEDを要求し、胸骨圧迫を始めた。[p]

#kazuto
[voice id="v01620"]
AEDを持ってこい！ 誰か——！[p]

[chara_hide_all]
[charapos name="kazuto" face="pursue" num="1"]
[charapos name="eruku" face="surprised" num="2"]

#eruku
[voice id="v01621"]
館内にあるはずだ、今すぐ——！[p]

#
叡留久が駆け出す。数分後、AEDが持ち込まれ、和人が処置を続けた。[p]

[quake count=2 time=400 hmax=5 vmax=5]

[wait time=2000]

#
——しかし。[p]
#
いくら試みても、命は戻らなかった。[p]

[chara_mod name="kazuto" face="regret"]

#kazuto
[voice id="v01622"]
……[p]

#
和人はゆっくりと手を止め、目を伏せた。[p]

#kazuto
[voice id="v01623"]
……だめだ。[p]

#kazuto
[voice id="v01624"]
彼女は息を引き取った。[p]

[wait time=1500]


;=========================================
; 3. 一同の動揺
;=========================================

[chara_hide_all]
[charapos name="airi" face="cry" num="1"]
[charapos name="mary" face="surprised" num="2"]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01625"]
そんな……嘘でしょ……？ 小出里亜さん……？[p]
[reset_message_chara]

#airi
[voice id="v01626"]
お姉ちゃん……[p]

[chara_hide_all]
[charapos name="juri" face="shout" num="0"]

#
珠璃は蒼白な顔で壁にもたれかかり、口元を手で覆っていた。[p]

[chara_hide_all]
[charapos name="eruku" face="thinking" num="0"]

#
叡留久は険しい表情で遺体のそばに立ち、一言も発さない。[p]

[chara_hide_all]
[charapos name="mary" face="surprised" num="0"]

#
メアリーは両手で口を覆い、涙をこらえていた。[p]

[chara_hide_all]
[charapos name="jushika" face="cry" num="0"]

#jushika
[voice id="v01627"]
小出里亜さん……どうして——[p]

#
電話を終えた朱志香が戻り、小出里亜の顔を見た瞬間、膝から崩れそうになった。[r]
#
その手が細かく震えていた。[p]


;=========================================
; 4. 真歩流と和人の対立
;=========================================

[chara_hide_all]
[charapos name="kazuto" face="pursue" num="1"]
[charapos name="airi" face="cry" num="2"]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01628"]
小出里亜さん……嘘ですよね？[p]
[reset_message_chara]

#
遺体に近づこうとした瞬間、和人が無言で前に立ちふさがった。[p]

[chara_mod name="kazuto" face="pursue"]
#kazuto
[voice id="v01629"]
現場に近づくな。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01630"]
現場って何！？ 小出里亜さんは……だって——[p]
[reset_message_chara]

#kazuto
[voice id="v01631"]
それ以上近づくと、証拠が失われる可能性がある。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01632"]
証拠……？ 何の話をしているの！？[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v01633"]
あくまで可能性の話だ。[p]

#kazuto
[voice id="v01634"]
……小出里亜が、何らかの方法で殺された可能性がある。[p]

[wait time=500]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01635"]
そんなわけない！[p]

#mahoru
[voice id="v01636"]
この館にいるのは、みんな優しい人たちだよ！ 誰もそんなことする人なんていない！[p]
[reset_message_chara]

#
真歩流の頬を涙が伝った。[p]

#kazuto
[voice id="v01637"]
……絶対なんてない。[p]

#kazuto
[voice id="v01638"]
そうでなくとも、何が原因なのかわからないのに安易に近づくな！[p]

#
和人はそれだけ言い捨てた。[r]
#
冷たくも、揺るぎない声で。[p]

[chara_mod name="airi" face="cry"]
#airi
[voice id="v01639"]
お姉ちゃん、落ち着いて。[p]

#
愛理が真歩流の腕をそっと引いた。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01640"]
愛理……[p]
[reset_message_chara]

#
二人は静かに泣き崩れた。[r]
#
キッチンに、重苦しい沈黙が落ちた。[p]

[chara_hide_all]
[charapos name="jushika" face="cry" num="0"]

#jushika
[voice id="v01641"]
……警察を呼びます。[p]

#
朱志香は失意の中、再びスマートフォンを手に取った。[p]

@fadeoutbgm

;=========================================
; 5. 警察到着（18:45）
;=========================================

[fadeoutbgm time=1000]
[mask time=1000]

[bg storage="living_night.png" time=0]
[chara_hide_all]

; 18:45 に確定
[set_time hour=18 min=45]
[playbgm storage="Searching_for_Clues.mp3"]
[gage_draw place="舞黒館:リビング"]
[wait time=2000]
[mask_off time=1000]


#
やがて、サイレンの音が近づいてきた。[r]
#
数台のパトカーが舞黒館の前に停まり、警察官たちが館内へと入ってきた。[p]

#
しかし、その数は思ったより少なかった。[r]
#
みなとみらいのオータムフェスティバルの警備で、ほとんどの警察官が出払っているのだという。[p]

#
そんな中に、一人の男性がいた。[r]
#
三十代後半と思われる、落ち着いた眼差しの人物だ。[p]

[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v01642"]
横浜中央署の零度です。[p]

#reido
[voice id="v01643"]
警備が手薄な中、私と数名の部下でこの場を取り仕切ります。[p]

#reido
[voice id="v01644"]
まず現場を確認し、その後、全員から事情をお伺いします。[p]

#
零度警部は冷静な声で言った。[p]

; 名乗ったこの場面で、人物名鑑に零度警部を登録する
[iscript]
f.status["chara_09"].owned = true;
[endscript]
[notify_profile ids="chara_09"]

[chara_hide_all]
[charapos name="reido" face="normal" num="2"]
[charapos name="kazuto" face="thinking" num="1"]

#reido
[voice id="v01645"]
医大生の方がいらっしゃると聞きましたが。[p]

#kazuto
[voice id="v01646"]
はい、私です。[p]

#reido
[voice id="v01647"]
発見時の状況を教えてください。[p]

#kazuto
[voice id="v01648"]
駆けつけたときには胸を押さえて苦しんでいました。[p]

#kazuto
[voice id="v01649"]
AEDと心肺蘇生を試みましたが……[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v01650"]
なるほど……ありがとうございます。鑑識を呼べ。それから——[p]

#
零度警部は参加者たちを見回した。[p]

#reido
[voice id="v01651"]
全員の事情聴取を行います。[p]

#
零度警部は部下たちに指示を出し、参加者たちをリビングへと集めた。[p]


;=========================================
; 6. 全員の事情聴取
; 「亡くなる直前、何をしていたか」
;=========================================

[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v01652"]
皆さん、小出里亜さんが亡くなる直前、どこで何をしていたか教えてください。[p]

#
一同は顔を見合わせた。[p]

; ── 朱志香の証言 ────────────────────────
[chara_hide_all]
[charapos name="jushika" face="thinking" num="1"]
[charapos name="reido" face="normal" num="2"]

#reido
[voice id="v01653"]
富礼知さん、あなたから。[p]

#jushika
[voice id="v01654"]
私は……ダイニングでこの後のスケジュールを確認しながら、時折キッチンの小出里亜さんと話をしていました。[p]

#jushika
[voice id="v01655"]
小出里亜さんはいつも通りに見えました……急に悲鳴を聞くまでは。[p]

#reido
[voice id="v01656"]
わかりました。[p]

; ── 和人の証言 ────────────────────────
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="1"]
[charapos name="reido" face="normal" num="2"]

#reido
[voice id="v01657"]
徐音さん。[p]

#kazuto
[voice id="v01658"]
2階の資料室で資料を調べていた。叡留久氏が呼びに来るまで、そこにいた。[p]

#reido
[voice id="v01659"]
一人で？[p]

#kazuto
[voice id="v01660"]
ああ。[p]

; ── 叡留久の証言 ────────────────────────
[chara_hide_all]
[charapos name="eruku" face="thinking" num="1"]
[charapos name="reido" face="normal" num="2"]

#reido
[voice id="v01661"]
穂在呂さん。[p]

#eruku
[voice id="v01662"]
私たちもダイニングで珠璃と一緒にいました。[p]

#eruku
[voice id="v01663"]
悲鳴を聞いて駆け付けた後、真歩流さんに言われ、2Fへ和人君を呼びに行ったんです。[p]

; ── 珠璃の証言 ────────────────────────
[chara_hide_all]
[charapos name="juri" face="thinking" num="1"]
[charapos name="reido" face="normal" num="2"]

#reido
[voice id="v01664"]
奥様の方は。[p]

#juri
[voice id="v01665"]
夫と同じです。ダイニングで叡留久と話していました。ずっと一緒でした。[p]

; ── メアリーの証言 ────────────────────────
[chara_hide_all]
[charapos name="mary" face="thinking" num="1"]
[charapos name="reido" face="normal" num="2"]

#reido
[voice id="v01666"]
メアリーさん。[p]

#mary
[voice id="v01667"]
私も同じです。[p]

; ── 真歩流・愛理の証言 ────────────────────────
[chara_hide_all]
[charapos name="airi" face="cry" num="1"]
[charapos name="reido" face="normal" num="2"]

[message_chara name="mahoru" face="cry"]

#reido
[voice id="v01668"]
真白さんたちは？[p]

#mahoru
[voice id="v01669"]
二人で館内を散策していました。ダイニングへ戻ってきたところで……悲鳴を聞いたんです。[p]

[reset_message_chara]

#airi
[voice id="v01670"]
姉と一緒にいました。ずっと二人で行動していました。[p]

#reido
[voice id="v01671"]
……わかりました。[p]

#
零度警部は部下を振り返り、小声で何かを指示した。[p]

[chara_hide_all]


;=========================================
; 7. ★和人のアリバイを検討する
;    零度警部が「発症直前に一人だった和人」を確認する。
;    プレイヤーは一度だけ、警部の見方にある前提を崩せるか考える。
;    正解しても不正解でも先へ進み、正解時だけ「気づき」と信頼+1を得る。
;=========================================

;-----------------------------------------
; 零度警部は、発症直前に一人だった和人へ目を向ける
;-----------------------------------------
[chara_hide_all]
[charapos name="reido" face="normal" num="1"]
[charapos name="kazuto" face="thinking" num="2"]

#
部下の手帳を覗き込んでいた零度警部が、静かに顔を上げた。[p]

#reido
[voice id="v01672"]
徐音さん。もう一度だけ、確認させてください。[p]

#reido
[voice id="v01673"]
小出里亜さんが倒れる直前まで、あなたは2階の資料室に——お一人でしたね。[p]

#kazuto
[voice id="v01674"]
そう言った。[p]

#reido
[voice id="v01675"]
どなたか、あなたをそこで見た方は？[p]

#kazuto
[voice id="v01676"]
……いない。[p]

#
零度警部は、それ以上は何も言わなかった。[r]
#
ただ、手帳に短く何かを書き足しただけだった。[p]

[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v01677"]
念のためです。皆さんのお話は、すべて同じように確かめています。[p]

#
そう言い添えた声は、あくまで穏やかだった。[r]
#
だからこそ——余計に、耳に残った。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01678"]
（警部さんは、和人を見てる）[p]
#mahoru
[voice id="v03823"]
（和人を疑っているんだ）[p]
[reset_message_chara]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01679"]
（確かに……小出里亜さんが倒れた18時30分ごろ、和人だけは一人だった）[p]

#mahoru
[voice id="v01680"]
（でも——本当に、そこだけを見ればいいの？）[p]
[reset_message_chara]

[chara_hide_all]

;-----------------------------------------
; 一度きりの推理
; 「正解するまで選択肢を潰す」形にはせず、その場で気づけたかを残す
;-----------------------------------------
*s5_trace
[iscript]
tf.inc = {
storage: "scene5.ks",
tag:   "検討",
title: "和人のアリバイ",
lead:  "発症直前、和人には目撃者がいない。零度警部はそこを確認している。",
prompt: "——この見方で、見落としていることは？",
steps: [
{ time:"18:20頃", label:"小出里亜がダイニングへ来る",
note:"夕食準備の完了を報告し、その後キッチンへ戻った",
link:"約十分後" },
{ time:"18:30", label:"小出里亜がキッチンで倒れる",
note:"悲鳴の後、真歩流と愛理が駆けつけた", mark:true },
{ time:"18:30頃", label:"和人は2階の資料室に一人",
note:"本人の証言のみ。目撃した人物はいない", mark:true }
],
choices: [
{ text:"目撃者のいない和人の証言を、まず疑う", target:"*s5_trace_wrong_kazuto" },
{ text:"現場のキッチンを、もっと詳しく調べる", target:"*s5_trace_wrong_kitchen" },
{ text:"発症時刻と、原因が生じた時刻は同じとは限らない", target:"*s5_trace_correct" }
]
};
[endscript]
[inc_trace]


;--- 不正解①：和人の証言そのものに目を向ける ----------------
*s5_trace_wrong_kazuto
[inc_back place="舞黒館:リビング"]
[bg storage="living_night.png" time=0]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01681"]
（目撃者がいないなら、和人が嘘をついている可能性はある）[p]

#mahoru
[voice id="v01682"]
（……でも、それは警部さんがもう確かめていることだ）[p]
[reset_message_chara]

#
疑いを深くしただけで、見える範囲は何も広がらなかった。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01683"]
（違う……何か、もっと大きな見落としがある気がする）[p]
[reset_message_chara]

[jump target="*s5_trace_miss_done"]


;--- 不正解②：発症した場所に視線を固定する ------------------
*s5_trace_wrong_kitchen
[inc_back place="舞黒館:リビング"]
[bg storage="living_night.png" time=0]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01684"]
（倒れたのはキッチン。なら、原因もキッチンにあるはず……）[p]
[reset_message_chara]

#
そう考えた瞬間、さっき見たポットや調理台が頭に浮かんだ。[r]
#
けれど、それ以上には繋がらなかった。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01685"]
（……今は、まだ分からない）[p]
[reset_message_chara]

[jump target="*s5_trace_miss_done"]


;--- 不正解共通：答えは保証しない。その時点の見方のまま進む --
*s5_trace_miss_done
[chara_hide_all]
[charapos name="reido" face="thinking" num="1"]
[charapos name="kazuto" face="thinking" num="2"]

#
零度警部は再び和人へ視線を戻した。[p]

#reido
[voice id="v01686"]
徐音さんの証言はこちらで裏を取ります。[p]

#reido
[voice id="v01687"]
現時点で、誰か一人に絞るつもりはありません。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01688"]
（……警部さんは、まだ決めつけてはいない）[p]

#mahoru
[voice id="v01689"]
（なのに私は、和人が疑われていることばかり気にしてる……）[p]
[reset_message_chara]

#
引っかかりは残ったまま、形にはならなかった。[p]

[chara_hide_all]
[jump target="*s5_trace_end"]


;--- 正解：発症時刻と摂取時刻を切り離す --------------------
*s5_trace_correct
[inc_back place="舞黒館:リビング"]
[bg storage="living_night.png" time=0]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01690"]
（……待って）[p]

#mahoru
[voice id="v01691"]
（どうして私は、18時30分が“何かあった時刻”だと思ってるの？）[p]

#mahoru
[voice id="v01692"]
（あれは——小出里亜さんが倒れた時刻でしかない）[p]
[reset_message_chara]

#
私の中で、時間の並び方が変わった。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01693"]
警部さん。[p]

#mahoru
[voice id="v01694"]
ひとつ、いいですか。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="thinking" num="1"]
[charapos name="kazuto" face="thinking" num="2"]

#reido
[voice id="v01695"]
……何でしょう？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01696"]
和人に18時30分の目撃者がいないことは分かります。[p]

#mahoru
[voice id="v01697"]
でも——小出里亜さんに何かが起きたのも、18時30分だったとは限らないですよね。[p]

#mahoru
[voice id="v01698"]
もしかしたら、小出里亜さんが倒れる前に何かがあったのかもしれない。[p]
[reset_message_chara]

#
零度警部の手が止まった。[p]

[chara_mod name="reido" face="normal"]
#reido
[voice id="v01699"]
……その通りです。[p]

#reido
[voice id="v01700"]
発症時刻は、原因が生じた時刻の証明にはなりません。[p]

#reido
[voice id="v01701"]
勿論、逆もしかりですが。[p]

#
零度警部はほんの一瞬だけ、真歩流を見る目を変えた。[p]

[iscript]
f.s5_reido_trust = 1;
[endscript]
[inc_insight id="koderia_route" name="発症した時刻と、原因が生じた時刻は一致するとは限らない"]
[achieve id="s56_alibi"]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01702"]
（だったら……もっと前まで遡らないと）[p]

#mahoru
[voice id="v01703"]
（小出里亜さんが、最後に誰かと接触したところまで——）[p]
[reset_message_chara]

[chara_hide_all]

; 正解したプレイヤーへの情報の広がりを、人物の並びで見せる
[iscript]
tf.inc = {
storage: "scene5.ks",
target:  "*s5_trace_correct_people",
tag:   "整理",
title: "発症前に接触できた人",
lead:  "18時20分ごろ。小出里亜がダイニングへ報告に来た、そのとき。",
faces: [
{ id:"juri",    name:"珠璃",     note:"夫と並んで座っていた" },
{ id:"eruku",   name:"叡留久",   note:"珠璃と話し込んでいた" },
{ id:"mary",    name:"メアリー", note:"少し離れた席にいた" },
{ id:"jushika", name:"朱志香",   note:"この後の予定を確かめていた" }
]
};
[endscript]
[inc_trace]


*s5_trace_correct_people
[inc_back place="舞黒館:リビング"]
[bg storage="living_night.png" time=0]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01704"]
（……四人）[p]

#mahoru
[voice id="v01705"]
（和人だけじゃない）[p]

#mahoru
[voice id="v01706"]
（小出里亜さんに何かできた人は——もっといる）[p]
[reset_message_chara]

#
キッチンの中だけなら、事故で片づけられたかもしれない。[r]

#
真歩流は、その先を考えるのをやめた。[r]
#
考えたくなかった、と言った方が正しい。[p]

[chara_hide_all]
[jump target="*s5_trace_end"]


*s5_trace_end
[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01707"]
（……違う。誰も、そんなことしてない）[p]
[reset_message_chara]

[chara_hide_all]


;=========================================
; 8. 聴取終了後の発表（19:10）
;=========================================

[mask time=500]
[bg storage="living_night.png" time=0]
[chara_hide_all]
; 事情聴取終了時刻 19:10 に確定
[set_time hour=19 min=10]
[gage_draw place="舞黒館:リビング"]

[mask_off time=500]

#
全員の聴取が終わった。[p]

[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v01708"]
お待たせしました。一点、お伝えします。[p]

#
零度警部は静かな声で続けた。[p]

#reido
[voice id="v01709"]
小出里亜さんの直接の死因は、毒物による可能性があると連絡が入りました。[p]

#reido
[voice id="v01710"]
ただし——毒の摂取経路も、毒物そのものも、まだ発見されていません。[p]

#
一同が息を呑んだ。[p]

#reido
[voice id="v01711"]
そのため現時点では、事故か事件かを断定できない状態です。[p]

#reido
[voice id="v01712"]
捜査を継続します。皆さんは当面、この館からの退館をお控えください。[p]

#reido
[voice id="v01713"]
それから——引き続き調査を行いますので、皆さんはリビングでお待ちください。[p]

#
零度警部と部下たちが動き出した。[p]

[chara_hide_all]


;=========================================
; 9. 真歩流の心情・悲しみ
;=========================================

[charapos name="airi" face="cry" num="0"]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01714"]
（事故……きっと事故よ）[p]

#mahoru
[voice id="v01715"]
（小出里亜さんは、何かの間違いで、毒を……）[p]

#mahoru
[voice id="v01716"]
（この館にいる人たちの中に、人を殺す人なんて……絶対にいない）[p]
[reset_message_chara]

#airi
[voice id="v01717"]
お姉ちゃん……[p]

#
愛理が静かに真歩流の隣に座った。[r]
#
二人の間に、言葉のない時間が流れた。[p]


;=========================================
; 10. メアリーのペンダント
;=========================================

[chara_hide_all]
[charapos name="mary" face="thinking" num="0"]

#
そこへ、メアリーが静かに近づいてきた。[p]

[chara_mod name="mary" face="no_say"]
#mary
[voice id="v01718"]
真歩流さん……[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01719"]
メアリーさん……[p]
[reset_message_chara]

#
メアリーは首からペンダントを外し、そっと真歩流に差し出した。[p]

[chara_mod name="mary" face="normal"]

#mary
[voice id="v01720"]
真歩流さん……これを持っていてくれませんか？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01721"]
え、メアリーさんの大切なペンダントですよね。[p]

#mahoru
[voice id="v01722"]
どうしてですか？[p]
[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v01723"]
持っていたら、また無くしてしまいそうで、イベント中だけでよいので持っていてくれませんか？[p]

#mary
[voice id="v01724"]
真歩流さんにしか、お願いできないんです……[p]

#
メアリーは優しく微笑んだ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01725"]
わかりました。そういうことなら。[p]
[reset_message_chara]

#
真歩流はペンダントを受け取った。[p]

#
——その瞬間。[p]

[pre_resonance]

[chara_mod name="mahoru" face="surprised"]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01726"]
っ……！[p]
[reset_message_chara]

#
頭の中でノイズが弾けた。[p]
#
そして——かすかな声が聞こえた。[p]

#
『……ずは……とり……』[p]

[wait time=500]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01727"]
（……今の、声……？）[p]

#mahoru
[voice id="v01728"]
（また、ノイズ……？）[p]
[reset_message_chara]

#
声は断片的で、意味が取れなかった。[r]
#
だが、そのトーンはどこか——不気味に感じられた。[p]

#
ペンダントをポケットにしまい、メアリーにノイズのことを訊いてみる。[p]

[message_chara name="mahoru" face="normal"]
#mahoru

#mahoru
[voice id="v01729"]
あの、メアリーさん、このペンダントを持っていると何か起きたりしないですか？[p]

#mahoru
[voice id="v01730"]
なんか、頭がぐらぐらしたり、電撃が走ったような感覚になったり……[p]

[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v01731"]
……いえ、特に何もないですよ？[p]

#mary
[voice id="v01732"]
真歩流さん、何か気になることでもありますか？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01733"]
いえ、大丈夫です。[p]

#mahoru
[voice id="v01734"]
すみません、変なことを聞いてしまって。[p]
[reset_message_chara]

#
こうして私は、メアリーのペンダントを預かることになった。[p]

; 握ると声が聞こえることまで、この場で分かっている
[set_item_status id="pendant" owned="true" secret="true"]
[get_item id="pendant" name="ペンダント"]

[chara_hide_all]


;=========================================
; 11. 待機・エンディング
;=========================================

[charapos name="airi" face="normal" num="1"]
[charapos name="mary" face="thinking" num="2"]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01735"]
（さっきの声……何だったんだろう）[p]

#mahoru
[voice id="v01736"]
（ペンダントに触るたびに、ノイズが走る）[p]

#mahoru
[voice id="v01737"]
（気のせい……だよね。疲れているだけ）[p]
[reset_message_chara]

#airi
[voice id="v01738"]
お姉ちゃん、大丈夫？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01739"]
うん。……ちょっと、色々考えてた。[p]
[reset_message_chara]

#
リビングでは、他の参加者たちも黙ったまま座っていた。[r]
#
廊下からは、警察官たちが行き交う足音が続いていた。[p]

#
事故か、事件か——[r]
#
答えは、まだ誰も持っていない。[p]

#
真歩流は膝の上で手を握りしめた。[p]
小出里亜さんが最後に伸ばした手。[r]
#
あの時の「……か……ん……」という言葉が、頭から消えなかった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01740"]
（……か……ん……）[p]

#mahoru
[voice id="v01741"]
（小出里亜さん、最後に何を言おうとしていたの……）[p]
[reset_message_chara]

[chara_hide_all]
[freeimage layer="1"]

[chapter_end]

[jump storage="scene6.ks" target="*start"]
