;=========================================
; scene6.ks
; シーン：叡留久の死・再事情聴取・愛理の危機・捜査協力
;=========================================

*start
@clearstack
[cm]
[clearfix]
[freeimage layer="1"]
[show_menu]
[playbgm storage="Searching_for_Clues.mp3" loop=true]
[bg storage="living_night.png" time=1000]

; scene5 の末尾 19:10 を引き継ぐ
[set_time hour=19 min=10]
[gage_draw place="舞黒館:リビング"]

; 個別聴取で言葉を濁したかどうか
[eval exp="f.s6_why_evaded=0"]

; scene5 を通らずにここへ来た場合（旧セーブ・デバッグ）でも参照できるようにしておく
[iscript]
if(typeof f.s56_insight !== "object" || f.s56_insight === null){ f.s56_insight = {}; }
if(typeof f.s56_urgent_acted  !== "number"){ f.s56_urgent_acted  = 0; }
if(typeof f.s56_urgent_frozen !== "number"){ f.s56_urgent_frozen = 0; }
// scene5 のアリバイ検討で得た信頼を初期値として引き継ぐ。
// 旧セーブ・デバッグでは 0 扱い。
var s5trust = Number(f.s5_reido_trust || 0);
if(!isFinite(s5trust)){ s5trust = 0; }
f.s6_trust      = s5trust;
f.s6_trust_rank = 1;
f.s6_talked     = 0;
[endscript]


;=========================================
; 1. 待機：リビング（選択制の会話パート）
;    警察の調べを待つ二十分。誰に何を聞くかはプレイヤーが決める。
;    ここで話した人数が、終盤の零度警部への説得に効いてくる。
;=========================================

[charapos name="reido" face="normal" num="0"]

#
零度警部の指示で、参加者たちはリビングに集められた。[p]
#
警察官たちが館内の調査を続けている中、一同は重苦しい沈黙の中で座っていた。[p]

#reido
[voice id="v01742"]
鑑識が現場を調べています。皆さんはしばらくここで待機してください。[p]

#
零度警部はそう告げると捜査へと戻っていった。[p]

[chara_hide_all]
[charapos name="airi" face="normal" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01743"]
（事故だって……そうだよね、きっと事故なんだ……）[p]
[reset_message_chara]

#airi
[voice id="v01744"]
お姉ちゃん……[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01745"]
大丈夫だよ、愛理。きっと、何かの間違いだから。[p]
[reset_message_chara]

#airi
[voice id="v01746"]
……ねえ。せっかくだから、みんなの様子を見てきたら？[p]

#airi
[voice id="v01747"]
お姉ちゃん、じっとしてるの苦手でしょ？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01748"]
（……そうだね）[p]

#mahoru
[voice id="v01749"]
（みんな、どんな気持ちでいるんだろう）[p]
[reset_message_chara]

; 会話フラグの初期化
[iscript]
f.s6_talk_kazuto  = 0;
f.s6_talk_eruku   = 0;
f.s6_talk_juri    = 0;
f.s6_talk_mary    = 0;
f.s6_talk_jushika = 0;
f.s6_talked       = 0;
[endscript]


;-----------------------------------------------------------
; 会話ハブ
;   和人と話すまでは、この場を離れられない
;-----------------------------------------------------------
*s6_wait_hub
[chara_hide_all]
[reset_message_chara]
[hidemenubutton]
[cm]
[gage_draw place="舞黒館:リビング"]
[clearfix]

[iscript]
// 話を聞けるのは3人まで。誰に聞くかで、後で警部に出せる話が変わる
tf.s6_left = 3 - (f.s6_talked || 0);
tf.choices = [];
if(tf.s6_left > 0){
if(f.s6_talk_kazuto  == 0){ tf.choices.push({target:'*s6_t_kazuto',  text:'ひとり考え込んでいる和人',   kind:'talk', chara:['kazuto']}); }
if(f.s6_talk_jushika == 0){ tf.choices.push({target:'*s6_t_jushika', text:'窓辺に立ち尽くす朱志香',     kind:'talk', chara:['jushika']}); }
if(f.s6_talk_eruku   == 0){ tf.choices.push({target:'*s6_t_eruku',   text:'落ち着かない様子の叡留久',   kind:'talk', chara:['eruku']}); }
if(f.s6_talk_juri    == 0){ tf.choices.push({target:'*s6_t_juri',    text:'夫に寄り添う珠璃',           kind:'talk', chara:['juri']}); }
if(f.s6_talk_mary    == 0){ tf.choices.push({target:'*s6_t_mary',    text:'俯いたままのメアリー',       kind:'talk', chara:['mary']}); }
}
// 和人とだけは、話してからでないと引き下がれない
if(f.s6_talk_kazuto  == 1){ tf.choices.push({target:'*s6_wait_end',  text:'席に戻って、黙って待つ',     kind:'move', name:'リビング'}); }

tf.s6_prompt = (tf.s6_left > 0)
? ("重い沈黙が続いている。<br>（あと " + tf.s6_left + " 人くらいなら、話を聞けるかな）")
: "重い沈黙が続いている。<br>（これ以上は、そっとしておいた方がいいよね）";
[endscript]

[jump cond="tf.choices.length == 0" target="*s6_wait_end"]

[stand_select storage="scene6.ks" se="decide.mp3" prompt="&tf.s6_prompt"]


;========================================
; 和人 ―― 盲目的に信じるということ
;========================================
*s6_t_kazuto
[advance_time min=4]
[eval exp="f.s6_talk_kazuto = 1"]
[eval exp="f.s6_talked = f.s6_talked + 1"]
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="kazuto" face="thinking" num="0" wait="false"]

#kazuto
[voice id="v01750"]
それにしても、奇妙だ。[p]

#kazuto
[voice id="v01751"]
小出里亜は、どこで毒物を摂取したんだ？[p]

[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v01752"]
それは……キッチンには、いろんなものがあるから。[p]

#mahoru
[voice id="v01753"]
何かの間違いで、口に入っちゃったんだよ。きっと。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v01754"]
偶然に毒物を摂取することはまず考えにくい。誰かが意図して——[p]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01755"]
やめてよ！[p]

#mahoru
[voice id="v01756"]
和人は本気でそんなことを言っているの！？　この中に犯人がいるって！？[p]
[reset_message_chara]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v01757"]
俺はただ、事実を述べているだけだ。[p]

#kazuto
[voice id="v01758"]
逆に聞くが——運悪く毒を摂取してしまったと、お前は本当に思っているのか？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01759"]
それは……[p]
[reset_message_chara]

#kazuto
[voice id="v01760"]
人を盲目的に信じることは、ある意味で人を信じないのと同じことだ。[p]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01761"]
違う……！　私はただ——[p]
[reset_message_chara]

#
言い返す言葉が、続かなかった。[p]

#kazuto
[voice id="v01762"]
……悪かった。今のは、言い方が過ぎた。[p]

[chara_mod name="kazuto" face="look_away"]
#kazuto
[voice id="v01763"]
だが、俺は撤回しない。[p]

#
和人はそれきり口を閉ざし、自分の手のひらを見つめていた。[p]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01764"]
（……どうして、そんな風にしか考えられないの）[p]
[reset_message_chara]

[jump target="*s6_wait_hub"]


;========================================
; 朱志香 ―― 長い付き合いと、口をついて出たもの
;========================================
*s6_t_jushika
[advance_time min=4]
[eval exp="f.s6_talk_jushika = 1"]
[eval exp="f.s6_talked = f.s6_talked + 1"]
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="jushika" face="surprised" num="0" wait="false"]

#
朱志香は窓の外を見たまま、身じろぎもしなかった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01765"]
朱志香さん……大丈夫ですか？[p]
[reset_message_chara]

#jushika
[voice id="v01766"]
……ごめんなさい。まだ、頭が追いついていなくて。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v01767"]
あの子とは、五年になるんです。[p]

#jushika
[voice id="v01768"]
住み込みで働いてもらって、館のことは何でも任せて……[p]

#jushika
[voice id="v01769"]
家族みたいなものだと、思っていました。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01770"]
そんなに長く……[p]
[reset_message_chara]

#jushika
[voice id="v01771"]
ええ。だから——[p]

#
そこで朱志香は言葉を切り、ふと、声のトーンを落とした。[p]

#jushika
[voice id="v01772"]
……このイベントは、どうなってしまうのかしら？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01773"]
え？[p]
[reset_message_chara]

[chara_mod name="jushika" face="panic"]
#jushika
[voice id="v01774"]
——あ、いえ。何でもありません。[p]

#jushika
[voice id="v01775"]
人が亡くなったのに、私は何を言っているのかしら。忘れてください。[p]

#
朱志香は自分の口元を手で押さえ、目を伏せた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01776"]
（朱志香さん、今……何を言いかけたんだろう）[p]

[reset_message_chara]

#jushika
[voice id="v01777"]
……ごめんなさい。少し、ひとりにさせてください。[p]

[jump target="*s6_wait_hub"]


;========================================
; 叡留久 ―― 毒という言葉への落ち着かなさ
;========================================
*s6_t_eruku
[advance_time min=4]
[eval exp="f.s6_talk_eruku = 1"]
[eval exp="f.s6_talked = f.s6_talked + 1"]
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="eruku" face="surprised" num="0" wait="false"]

#
叡留久はソファに浅く腰かけ、しきりに膝を揺すっていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01778"]
叡留久さん……[p]
[reset_message_chara]

#eruku
[voice id="v01779"]
ああ、真白さんか。[p]

#eruku
[voice id="v01780"]
いや——驚いたよ。本当に、あまりのことでね。[p]

[chara_mod name="eruku" face="thinking"]
#eruku
[voice id="v01781"]
昼間はあんなに元気だった人が、数時間でこんなことになるなんて……[p]

#eruku
[voice id="v01782"]
まだ、飲み込めていないんだ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01783"]
……はい。[p]
[reset_message_chara]

#
そこまでは、誰もが言いそうな言葉だった。[r]
#
けれど叡留久は、次の一言だけ声の調子を変えた。[p]

[chara_mod name="eruku" face="surprised2"]
#eruku
[voice id="v01784"]
……警部は、毒物と言っていたね。[p]

#eruku
[voice id="v01785"]
毒だとすると、警察は調べるんだろうね。その——[p]

#eruku
[voice id="v01786"]
我々の持ち物とか、携帯とか。そういうものまで……[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01787"]
どう、なんでしょう……[p]
[reset_message_chara]

#eruku
[voice id="v01788"]
いや、いいんだ。やましいことがあるわけじゃない。[p]

#eruku
[voice id="v01789"]
ただ、こういうのは気分のいいものじゃないだろう。[p]

#
そう言って笑いながら、[r]
#
叡留久の手は、上着の胸ポケットを何度も確かめていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01790"]
（叡留久さん……何をそんなに気にしているんだろう）[p]
[reset_message_chara]

[jump target="*s6_wait_hub"]


;========================================
; 珠璃 ―― 整いすぎた言葉と、流れた視線
;========================================
*s6_t_juri
[advance_time min=4]
[eval exp="f.s6_talk_juri = 1"]
[eval exp="f.s6_talked = f.s6_talked + 1"]
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="juri" face="surprised" num="0" wait="false"]

#
珠璃は夫の隣で、ハンカチを両手で握りしめていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01791"]
珠璃さん、お加減は……[p]
[reset_message_chara]

#juri
[voice id="v01792"]
……ええ。驚いてしまって、手の震えが止まらないの。[p]

[chara_mod name="juri" face="cry"]
#juri
[voice id="v01793"]
こんなことになるなんて……[p]

#juri
[voice id="v01794"]
お若い方だったのに……本当に、残念だわ。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01795"]
……はい。[p]
[reset_message_chara]

#
珠璃は目元をハンカチで押さえた。[p]

#juri
[voice id="v01796"]
捜査は警察がしてくれます。私たちは大人しく待ちましょう。[p]

#juri
[voice id="v01797"]
余計なことをして、かえって足を引っ張ってはいけないもの。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01798"]
……そうですね。[p]
[reset_message_chara]

#
——その時。[p]

#
ハンカチから顔を上げた珠璃の視線が、[r]
#
ほんの一瞬だけ、キッチンの方へ流れた。[p]

[wait time=600]

#
それは本当に短くて、[r]
#
瞬きひとつぶんの出来事だった。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v01799"]
……どうかしたかしら、真白さん？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01800"]
いえ、何でも……[p]
[reset_message_chara]

[jump target="*s6_wait_hub"]


;========================================
; メアリー ―― 言葉にならない
;========================================
*s6_t_mary
[advance_time min=4]
[eval exp="f.s6_talk_mary = 1"]
[eval exp="f.s6_talked = f.s6_talked + 1"]
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="mary" face="surprised" num="0" wait="false"]

#
メアリーは部屋の隅で、膝の上の両手をじっと見つめていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01801"]
メアリーさん……[p]
[reset_message_chara]

[chara_mod name="mary" face="no_say"]
#mary
[voice id="v01802"]
……[p]

#
返事はなかった。[r]
#
唇が動きかけて、そのまま閉じる。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01803"]
……無理に、お話しにならなくて大丈夫です。[p]
[reset_message_chara]

#
真歩流はそっと隣に腰を下ろした。[p]
#
しばらく、何も言わずに座っていた。[p]

[wait time=800]

[chara_mod name="mary" face="cry"]
#mary
[voice id="v01804"]
……さっきまで。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01805"]
はい。[p]
[reset_message_chara]

#mary
[voice id="v01806"]
さっきまで、あんなにお元気だったのに……[p]

#mary
[voice id="v01807"]
お茶を淹れてくださって、笑っていらして……[p]

#
そこで声が詰まった。[p]

#mary
[voice id="v01808"]
ごめんなさい。うまく、言葉が出てこないんです。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01809"]
……私もです。[p]
[reset_message_chara]

#
二人は黙ったまま、しばらく並んで座っていた。[p]

[jump target="*s6_wait_hub"]


;========================================
; 待機の終わり
;========================================
*s6_wait_end
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[layopt layer="message0" visible=true]

#
重苦しい沈黙が続いた。[p]


;=========================================
; 2. 叡留久の異変（19:30）
;=========================================

[mask]
[chara_hide_all]
[mask_off]

; 19:30 に確定
[set_time hour=19 min=30]

#
そうして、二十分ほどが経過したころ——[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="1"]
[charapos name="juri" face="normal" num="2"]

#eruku
[voice id="v01810"]
ふう……トイレに行ってくるよ。さっきの紅茶のせいかな。[p]

#juri
[voice id="v01811"]
……気をつけてね。[p]

#
叡留久は立ち上がり、廊下へと向かった。[p]

[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01812"]
和人……どうかしたの？[p]
[reset_message_chara]

#kazuto
[voice id="v01813"]
……いや、なんでもない。[p]

#
何かを考え込むように、和人は視線を落とした。[p]

[chara_hide_all]
[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01814"]
（和人は何を考えているんだろう……）[p]
[reset_message_chara]

#
その時だった。[p]

[playbgm storage="Incident_Occurred.mp3"]

#eruku
[voice id="v01815"]
うっ……ぐあああああっ！[p]

#
廊下から、叡留久の苦しそうな悲鳴が響いてきた。[p]

[charapos name="juri" face="shout" num="0"]

#juri
[voice id="v01816"]
叡留久！？[p]

#
珠璃が夫の名を叫び、真っ先に廊下へと駆け出した。[p]

[chara_hide_all]
[bg storage="hallway_night.png"]

[bg storage="event/eruku_painful2.png"time=1000]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01817"]
叡留久さん！[p]
[reset_message_chara]

#
全員が廊下へと急いだ。[r]
#
そこには——叡留久が苦しそうに呻きながら壁にもたれていた。[p]

[bg storage="event/eruku_painful.png"]

[charapos name="eruku" face="painful" num="2"]
[charapos name="juri" face="shout" num="1"]

#eruku
[voice id="v01818"]
お、おかしい……体が……ぐああああああ。[p]

[quake count=3 time=400 hmax=15 vmax=10]

#juri
[voice id="v01819"]
叡留久、どうしたの叡留久！！[p]

#juri
[voice id="v01820"]
どこが苦しいの！[p]

#eruku
[voice id="v01821"]
胸が……呼吸が……！[p]

#
和人が素早く駆け寄ろうとした。[p]

[chara_hide_all]
[charapos name="reido" face="order" num="0"]

#reido
[voice id="v01822"]
下がってください！　触れてはいけない！[p]

#
零度警部が制止の声を上げた。[p]
#
和人の足が、止まる。[p]


;-----------------------------------------
; ★即断 叡留久が倒れた数秒間
;   誰が動くかは変わらない。変わるのは、真歩流が何を見たか
;-----------------------------------------
[iscript]
tf.inc = {
storage: "scene6.ks",
tag:   "緊急",
title: "止まっている場合じゃない",
lead:  "警部の制止で、和人の足が止まった。叡留久はまだ呼吸をしている。",
prompt:"――どうする！？",
limit: 6,
timeout: "*s6_act_none",
choices: [
{ text:"和人の背中を押す",           sub:"今動けるのは、この人しかいない", target:"*s6_act_push" },
{ text:"警部に食い下がる",           sub:"許可をもぎ取る",                 target:"*s6_act_beg"  },
{ text:"叡留久さんから目を離さない", sub:"今しか見られないものがある",     target:"*s6_act_watch" }
]
};
[endscript]
[inc_urgent]


;--- 和人を押し出す ---------------------------------------
*s6_act_push
[inc_back place="舞黒館:廊下(1F)"]

[message_chara name="mahoru" face="shout"]
#mahoru
[voice id="v01823"]
和人、行って！[p]
[reset_message_chara]

#
背中を押した。[r]
#
和人は一瞬だけ真歩流を見て——何も言わずに走り出した。[p]

[inc_insight id="kazuto_moved" name="和人は、止められてもなお人を助けに行った"]
[jump target="*s6_eruku_care"]


;--- 警部に食い下がる -------------------------------------
*s6_act_beg
[inc_back place="舞黒館:廊下(1F)"]

[message_chara name="mahoru" face="shout"]
#mahoru
[voice id="v01824"]
警部さん！　彼はお医者さんの卵です！　触らないで見ているだけなんて、そんなの——！[p]
[reset_message_chara]

[charapos name="reido" face="order" num="0"]

#reido
[voice id="v01825"]
……徐音さん。手袋を。それから、私の目の届く場所でやってください。[p]

#
零度警部は、一秒だけ黙って——それだけ言った。[p]

[inc_insight id="reido_listened" name="零度警部は、理由さえ示せば人の言葉を聞く"]
[jump target="*s6_eruku_care"]


;--- 叡留久を見つめ続ける ---------------------------------
*s6_act_watch
[inc_back place="舞黒館:廊下(1F)"]

#
真歩流は、叡留久から目を離さなかった。[p]

#
苦しさに身をよじりながら、叡留久の右手が何度も口元へ伸びる。[r]
#
唇をぬぐい、その指を——見つめている。[p]

[inc_insight id="eruku_mouth" name="叡留久さんは倒れる直前、しきりに口元をぬぐっていた"]
[jump target="*s6_eruku_care"]


;--- 動けなかった -----------------------------------------
*s6_act_none
[inc_back place="舞黒館:廊下(1F)"]

#
声も出なかった。[r]
#
二度目なのに——いや、二度目だからこそ、体が言うことを聞かない。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01826"]
（また……また、見ているだけ）[p]
[reset_message_chara]

[jump target="*s6_eruku_care"]


;--- 合流：和人の処置 -------------------------------------
*s6_eruku_care
[chara_hide_all]
[charapos name="kazuto" face="pursue" num="1"]
[charapos name="reido" face="order" num="2"]

#
和人はすぐに叡留久の傍に膝をついた。[p]
#
素早く脈を確認し、症状を確かめる。[p]

#kazuto
[voice id="v01827"]
（……これは。まずい）[p]

#
和人は何かを悟ったように、すぐに処置を始めた。[p]

[chara_hide_all]
[charapos name="eruku" face="painful" num="2"]
[charapos name="juri" face="shout" num="1"]

#juri
[voice id="v01828"]
叡留久！　しっかりして！　叡留久！！[p]

[quake count=4 time=600 hmax=20 vmax=15]

#eruku
[voice id="v01829"]
じゅ……す……ない……[p]

#
叡留久の唇が、かすかに動いた。[r]
#
それきり——手から力が抜けた。[p]

[wait time=1500]

[chara_hide_all]
[charapos name="kazuto" face="pursue" num="0"]

#
和人が首筋に手を当て、脈を確認する。[p]

[wait time=2000]

[chara_mod name="kazuto" face="regret"]

#kazuto
[voice id="v01830"]
……[p]

#
和人はゆっくりと目を伏せた。[p]

[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

#
零度警部が歩み寄り、確認する。[r]
#
数秒の沈黙の後——警部は静かに首を横に振った。[p]

#reido
[voice id="v01831"]
……穂在呂叡留久さんの死亡を確認しました。[p]

;=========================================
; 3. 珠璃の錯乱・零度の対応
;=========================================

[chara_hide_all]
[charapos name="juri" face="cry" num="0"]

#juri
[voice id="v01832"]
叡留久……叡留久！！　嘘でしょ……！？[p]

[quake count=2 time=300 hmax=8 vmax=5]

#juri
[voice id="v01833"]
叡留久——！！！[p]

#
珠璃の叫びが廊下に響いた。[r]
#
体が崩れ落ち、遺体のそばで泣き続ける。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01834"]
そんな……叡留久さん……[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="normal" num="1"]
[charapos name="juri" face="cry" num="2"]

#
零度警部は珠璃のそばにしゃがみ、穏やかに肩に手を置いた。[p]

#reido
[voice id="v01835"]
穂在呂さん……落ち着いてください。[p]

#reido
[voice id="v01836"]
今はご主人を失った悲しい気持ちは、よく分かります。[p]

#reido
[voice id="v01837"]
でも、ご主人のためにも……今は、皆さんの安全を確保しなければならない。[p]

#reido
[voice id="v01838"]
何が原因かわからない以上、あなたも危険なのです！[p]

#
零度警部の声は静かで、温かみがあった。[p]
#
珠璃は泣きながらも、警部の言葉に少しずつ落ち着きを取り戻していった。[p]

[chara_hide_all]
[charapos name="reido" face="order" num="0"]

#reido
[voice id="v01839"]
全員、リビングへ戻ってください。[p]

#reido
[voice id="v01840"]
現場保存を行います。部下が案内します。[p]

#
警察官たちが動き、参加者たちをリビングへと誘導した。[p]


;=========================================
; 4. 再事情聴取の開始
;=========================================

[mask time=500]
[bg storage="living_night.png" time=0]
[chara_hide_all]
[mask_off time=500]
[playbgm storage="Searching_for_Clues.mp3" loop=true]
[gage_draw place="舞黒館:リビング"]

[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v01841"]
皆さん、不安な状況下と思いますが、今しばらく辛抱ください。[p]

#reido
[voice id="v01842"]
毒物の摂取元はいまだ特定できていません。このまま次の犠牲者を出すわけにはいかない。[p]

#reido
[voice id="v01843"]
全員、再度の事情聴取を行います。一人ずつ、執務室に来てください。[p]

#
零度警部の声には、焦りを押し殺したような張り詰めた緊張があった。[p]

#
こうして——参加者たちは一人ずつ執務室へと呼ばれていった。[p]


;=========================================
; 5. 珠璃の証言（和人告発）
;=========================================
[mask]
[chara_hide_all]
[bg storage="office_night.png" time=0]
[charapos name="juri" face="cry" num="1"]
[charapos name="reido" face="normal" num="2"]
[mask_off]

#reido
[voice id="v01844"]
奥様、当時の状況を——[p]

[chara_mod name="juri" face="shout"]
#juri
[voice id="v01845"]
犯人は決まっているじゃない！[p]

#reido
[voice id="v01846"]
……と言いますと？[p]

#juri
[voice id="v01847"]
毒を作れるのは和人よ！　医大生で、薬の知識がある。小出里亜さんが言ってたわ。和人には何かを隠しているって……！[p]

#juri
[voice id="v01848"]
あの人しかいないわ。ねえ、なんで早く逮捕しないの！？[p]

[chara_mod name="juri" face="cry"]
#juri
[voice id="v01849"]
叡留久を返して……叡留久を……！[p]

#
珠璃は泣き崩れながら、震える声で証言を続けた。[p]

[mask]
[chara_hide_all]
[mask_off]

;=========================================
; 6. 和人の証言（沈黙）
;=========================================

[charapos name="kazuto" face="thinking" num="1"]
[charapos name="reido" face="normal" num="2"]

#reido
[voice id="v01850"]
徐音さん、穂在呂奥様はこのように証言されていますが、あなたはどのように考えますか？[p]

#
和人は黙っていた。[p]

#reido
[voice id="v01851"]
何か言いたいことは？[p]

#kazuto
[voice id="v01852"]
……[p]


#
和人は何も言わなかった。[r]
#
その表情からは、何も読み取れない。[p]

#reido
[voice id="v01853"]
では、二人の被害者を見て気づいたことはないですか？[p]

#kazuto
[voice id="v01854"]
……二人の症状はよく似ていました。[p]

#kazuto
[voice id="v01855"]
確証はありませんが、恐らくは同じ毒物によるものだと思われます。[p]

#reido
[voice id="v01856"]
なるほど、わかりました。ありがとうございます。[p]

#kazuto
[voice id="v01857"]
……警部、一つお願いしたいことがあります。[p]

[chara_hide_all]


;=========================================
; 7. 真歩流の個別聴取（19:50）
;=========================================

[mask time=500]
[chara_hide_all]
[mask_off time=500]

; 真歩流の聴取開始 19:50 に確定
[set_time hour=19 min=50]
[gage_draw place="舞黒館:執務室(2F)"]

#
やがて、真歩流の番が来た。[p]

[charapos name="reido" face="normal" num="0"]
[message_chara name="mahoru" face="normal"]

#reido
[voice id="v01858"]
真白さん。事件当時、叡留久さんが倒れる直前——どこにいましたか？[p]

#mahoru
[voice id="v01859"]
リビングで皆と一緒にいました。叡留久さんの悲鳴が聞こえるまで、ずっと。[p]

#reido
[voice id="v01860"]
そうですか。真白さん、あなたは今回どうして宿泊イベントに参加したんですか？[p]

#mahoru
[voice id="v01861"]
え……えっと……[p]
[reset_message_chara]

#
真歩流は息を呑んだ。[p]
#
零度警部の目が、静かに、しかし鋭く真歩流を見つめている。[p]


;=========================================
; ★ここでどう答えるかで、警部との距離が変わる
;=========================================

*s6_why
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s6_why_honest', text:'父のことを、正直に話す',
kind:'talk', chara:['reido'] });
tf.choices.push({ target:'*s6_why_evade',  text:'言葉を濁す',
kind:'talk', chara:['reido'] });
[endscript]
[stand_select storage="scene6.ks" se="decide.mp3" prompt="――どうして、舞黒館へ来たのか。"]


;--- 正直に話す -------------------------------------------
*s6_why_honest
[cm]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[charapos name="reido" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01862"]
実は……私の父が、半年前から行方不明なんです。[p]

#mahoru
[voice id="v01863"]
父が最後に残した言葉が『舞黒館』で……何か手がかりがないかと思って、妹と参加したんです。[p]

#mahoru
[voice id="v01864"]
隠すつもりはありませんでした。訊かれなかったから、言わなかっただけで。[p]
[reset_message_chara]

#
零度警部の眉が、わずかに動いた。[r]
#
——値踏みではなく、確かめるような目だった。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v01865"]
……先に自分から言う人は、そう多くありません。[p]

@eval exp="f.s6_trust = f.s6_trust + 1"
[inc_insight id="reido_trust" name="零度警部に、隠しごとをしなかった"]
[jump target="*s6_why_after"]


;--- 言葉を濁す -------------------------------------------
*s6_why_evade
[cm]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[charapos name="reido" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01867"]
その……妹と、洋館に泊まってみたくて。ただ、それだけです。[p]
[reset_message_chara]

#
零度警部は手帳を閉じた。[r]
#
そして、真歩流の目をまっすぐに見た。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v01868"]
真白奢禄さん。半年前に行方不明届が出ています。[p]

#reido
[voice id="v01869"]
……ご家族ですね？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01870"]
……っ！[p]

#mahoru
[voice id="v01871"]
……父です。[p]

#mahoru
[voice id="v01872"]
父が最後に残した言葉が『舞黒館』で……何か手がかりがないかと思って、妹と参加したんです。[p]
[reset_message_chara]

#reido
[voice id="v01873"]
最初からそう言っていただきたかった。[p]

#reido
[voice id="v01874"]
こちらが調べれば分かることを伏せられると——それだけで、こちらは一歩下がるんです。[p]

[eval exp="f.s6_why_evaded=1"]
[jump target="*s6_why_after"]


*s6_why_after
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

[if exp="f.s6_why_evaded!=1"]
#
零度警部は部下に視線を送った。部下が素早く確認を取る。[p]

#警察
警部、真白奢禄さんの行方不明届が半年前に出されています。[p]
[endif]

#reido
[voice id="v01875"]
……わかりました。お父様の手がかりを探しに来ていたということですね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01876"]
はい。[p]
[reset_message_chara]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01877"]
警部さん。私は、これは事故だと思っています。[p]

#mahoru
[voice id="v01878"]
小出里亜さんも、叡留久さんも——誰かに殺されたんじゃない。何かの間違いで毒を摂取してしまったんです。[p]

#mahoru
[voice id="v01879"]
だって、この館にいる人たちは、誰も人を傷つけるような人じゃない。[p]
[reset_message_chara]

#
零度警部はしばらく黙っていた。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v01880"]
……真白さん。[p]

#reido
[voice id="v01881"]
毒物は現時点でいまだどこからも発見されていない。[p]

#reido
[voice id="v01882"]
偶然に何らかの毒物を摂取してしまったとしたら、その毒はどこから来たのか。[p]

#reido
[voice id="v01883"]
少なくとも私には、今回の件が事故である可能性は低いと思えます。[p]

#reido
[voice id="v01884"]
むしろ、あなたは疑わしいですよ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01885"]
え……[p]
[reset_message_chara]

#reido
[voice id="v01886"]
……あなたの言動は誰かを庇っているようにも見えるし、捜査をかく乱したいのかと取られても何も言えませんよ？[p]

#reido
[voice id="v01887"]
根拠も理由もないのに不用意なことは言わない方がいい……[p]

#reido
[voice id="v01888"]
何か思い出したことがあれば、すぐに申し出てください。以上です。[p]

#
真歩流は一礼し、執務室を出た。[p]


;=========================================
; 8. 廊下での罪悪感・和人の言葉
;=========================================

[mask time=500]
[bg storage="hallway_second_night.png" time=0]
[chara_hide_all]
[gage_draw place="舞黒館:廊下(2F)"]
[mask_off time=500]


[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01889"]
（私……間違っているのかな……）[p]

#mahoru
[voice id="v01890"]
（だって、本当に人を殺すような人なんていないじゃない）[p]

[reset_message_chara]

[charapos name="kazuto" face="normal" num="0"]

#
その時、和人が廊下に出てきた。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01891"]
和人……叡留久さんは事故だよね。事故で亡くなったんだよね？[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v01892"]
……俺が言ったことを覚えているか。[p]

#kazuto
[voice id="v01893"]
俺はお前に人を疑えと言いたいんじゃない。[p]

#kazuto
[voice id="v01894"]
ただ——ちゃんと現実をよく見ろ。[p]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01895"]
……[p]
[reset_message_chara]

#
和人はそれだけ言うと、廊下を歩き去った。[p]

;=========================================
; 9. 愛理の励まし・リビングへ
;=========================================

[chara_hide_all]
[charapos name="airi" face="normal" num="0"]

#
廊下の隅に、愛理が立っていた。[p]

#airi
[voice id="v01896"]
お姉ちゃん。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01897"]
愛理……私、間違っていたのかな——[p]

#mahoru
[voice id="v01898"]
誰も……悪い人なんていないって……[p]
[reset_message_chara]

#airi
[voice id="v01899"]
お姉ちゃんらしくないよ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01900"]
え？[p]
[reset_message_chara]

#airi
[voice id="v01901"]
お姉ちゃんはいつだって人を信じて、自分の信じることをやってきたじゃない。[p]

#airi
[voice id="v01902"]
そんなお姉ちゃんが好きだよ、私は。[p]

#airi
[voice id="v01903"]
それでいいんだよ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01904"]
愛理……[p]
[reset_message_chara]

#airi
[voice id="v01905"]
ほら、リビングに戻ろう。一緒にいよう。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01906"]
……うん。ありがとう。[p]
[reset_message_chara]

#
少しだけ、胸の重さが和らいだのを感じた。[p]

;=========================================
; 10. 愛理が倒れる（20:15）
;=========================================

[mask]
[chara_hide_all]
; 20:15 に確定
[set_time hour=20 min=15]
[gage_draw place="舞黒館:リビング"]
[bg storage="living_night.png"]
[playbgm storage="haunting_melody.mp3"]
[mask_off]

[chara_mod name="airi" face="surprised"]
[charapos name="airi" face="normal" num="1"]
[charapos name="mary" face="normal" num="2"]

#mary
[voice id="v01907"]
捜査は無事に進んでいるのでしょうか？[p]

#airi
[voice id="v01908"]
大丈夫ですよ。[p]

#airi
[voice id="v01909"]
警部さん優秀そうですし。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01910"]
……そうだね。これ以上誰も被害が出ないように……[p]
[reset_message_chara]

#airi
[voice id="v01911"]
あ……れ……？[p]

#
愛理が突然、顔を歪めた。[p]

@chara_hide_all

@bg storage="event/mahoru_airi_save.png"

#mahoru
[voice id="v01912"]
愛理！？[p]

#airi
[voice id="v01913"]
お姉……ちゃん……胸が……[p]

#
愛理の顔が蒼白になった。[r]
#
そのまま、体が崩れ落ちた。[p]

[quake count=3 time=400 hmax=8 vmax=5]

#mahoru
[voice id="v01914"]
愛理！　愛理！！[p]

#
真歩流が妹を抱きかかえた。愛理の体が小さく震えている。[p]


#kazuto
[voice id="v01915"]
見せろ！[p]

#kazuto
[voice id="v01916"]
脈が速い……瞳孔散大——[p]

#
和人の表情が、わずかに険しくなった。[p]

#kazuto
[voice id="v01917"]
（……小出里亜や穂在呂さんの症状に似ている。だが……何かが違う）[p]

#reido
[voice id="v01918"]
救急車の手配を急げ！[p]

#
部下が無線で連絡を取る。[p]

#警察
警部……オータムフェスティバルで打ち上げ前の花火が保管場所で連鎖的に誘爆する事故が発生しています。[p]
#警察
消防活動と避難誘導のため、周辺道路が封鎖されているとのことです。[p]

#警察
多数の負傷者が出て、市内の救急隊が現場へ集中しており、近隣病院も負傷者の受け入れで逼迫。[p]
#警察
市外から向かうと1時間以上かかるとのことです。[p]

#reido
[voice id="v01919"]
なんということだ……[p]

#reido
[voice id="v01920"]
徐音さん、彼女の容態は？[p]

#kazuto
[voice id="v01921"]
……急いで2Fのベッドへ運んでください。このままでは——[p]

#
零度警部はすぐに部下を呼び、愛理を2Fのベッドへと運ばせた。[p]


;=========================================
; 11. 血液検査・毒の発覚
;=========================================
[mask]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]
[bg storage="bedroom_night.png"]
[mask_off]

#kazuto
[voice id="v01922"]
警部、お願いがあります。血液検査の機材を持っている警察官はいますか？[p]

#reido
[voice id="v01923"]
……簡易のものなら。[p]

#kazuto
[voice id="v01924"]
それで構いません。すぐに。[p]

#
警察の協力のもと、和人が愛理の簡易血液検査を行った。[p]

[chara_mod name="kazuto" face="pursue"]
#kazuto
[voice id="v01925"]
……やはり。血液中の数値に異常が出ています。[p]

#kazuto
[voice id="v01926"]
毒物が体内に入っています。恐らく——このまま放置すると、呼吸器系に異常が出てくる可能性があります。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01927"]
そんな……愛理が……！[p]
[reset_message_chara]

#reido
[voice id="v01928"]
わかった。近隣で往診できる医師を探せ！[p]

#
部下たちが動いたが——数分後、戻ってきた部下の報告は絶望的なものだった。[p]

#警察
警部……往診できる医師にも連絡しましたが、事故対応に追われ、対応は難しいとのことです。[p]

#reido
[voice id="v01929"]
くっ……[p]

#
零度警部は目を閉じた。[r]
#
数秒の沈黙の後——腹をくくったような眼差しで顔を上げた。[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v01930"]
全員に命令する。館内を総動員で捜索せよ。[p]

#reido
[voice id="v01931"]
毒物の探索、及び摂取経路の特定を最優先とする。今すぐ取りかかれ！[p]

#reido
[voice id="v01932"]
また、少し離れても構わない。医者という医者に片っ端から連絡を取るんだ！[p]

#警察
は！[p]

#
警察官たちが一斉に動き出した。[p]


;=========================================
; 12. 和人の方法・毒物の特定
;=========================================

[chara_hide_all]
[charapos name="kazuto" face="thinking" num="1"]
[charapos name="reido" face="thinking" num="2"]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01933"]
和人……愛理を助けるために、何か方法はないの？[p]
[reset_message_chara]

#kazuto
[voice id="v01934"]
……一つだけある。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01935"]
本当に！？[p]
[reset_message_chara]

#kazuto
[voice id="v01936"]
毒物が何であるかがはっきりすれば、多少なりとも毒を中和することができる。[p]

#kazuto
[voice id="v01937"]
俺のリュックの中に……勉強用に持ってきた薬と、植物の標本、それから調合のための道具が入っている。[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v01938"]
待ってください。[p]

#reido
[voice id="v01939"]
なぜそのような物を持ち歩いているんですか？[p]

#
零度警部の視線が和人に向いた。[p]

#
——しかし警部は、その問いを飲み込んだ。[p]

#reido
[voice id="v01940"]
……確認します。毒が特定できれば、対処できる可能性があると？[p]

#kazuto
[voice id="v01941"]
ええ。ただし、正確な毒の成分が分からない限り手出しはできない。[p]

#kazuto
[voice id="v01942"]
下手に処置すれば、かえって危険です。[p]

#reido
[voice id="v01943"]
……わかりました。[p]

#
零度警部は一度目を閉じ、決断した。[p]

#reido
[voice id="v01944"]
徐音さんには愛理さんの処置を。そして我々は引き続き毒物と摂取経路を探します。[p]

#
和人は頷き、私たちは和人に愛理を任せて階下へ降りた。[p]


;=========================================
; 13. 真歩流の決断・捜査協力申し出（20:20）
;=========================================

[mask]
[chara_hide_all]
[gage_draw place="舞黒館:廊下"]
[bg storage="hallway_night.png" time=0]
[mask_off]

[charapos name="reido" face="normal" num="0"]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01945"]
零度警部！[p]
[reset_message_chara]

#reido
[voice id="v01946"]
……なんですか、真白さん。[p]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01947"]
私に事件の調査を手伝わせてください！[p]

#mahoru
[voice id="v01948"]
愛理を助けるために——私も何かしたいんです！[p]

#mahoru
[voice id="v01949"]
ただ、黙ってみているなんてできません！[p]
[reset_message_chara]

#
零度警部は静かに首を横に振った。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v01950"]
気持ちはわかります。しかし、あなたは今も容疑者の一人です。[p]

#reido
[voice id="v01951"]
捜査への関与は、認めることはできません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01952"]
（——ここで引いたら、終わり）[p]

#mahoru
[voice id="v01953"]
（感情じゃない。この人が納得する言葉を、選ばないと）[p]
[reset_message_chara]


;=========================================
; ★説得
;   零度警部の三つの問いに、これまで起きたことを自分の言葉で答える。
;   答え方の積み重ね（f.s6_trust）が、scene7 の捜査開始時刻と
;   警部が最初に何を話してくれるかを決める。
;=========================================

[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v01954"]
……それでは、伺いましょう。[p]

#
零度警部は手帳を閉じ、真歩流に正面から向き直った。[p]

#reido
[voice id="v01955"]
私は、あなたを捜査から外したい。理由は、あなたが容疑者だからです。[p]

#reido
[voice id="v01956"]
それを覆したいなら——今夜あったことを、あなたの言葉で話してください。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01957"]
……はい。[p]
[reset_message_chara]


;--- 問① 何を見たか ---------------------------------------
*s6_plea_q1
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
// scene5 で自分の力で「発症時刻≠摂取時刻」に気づけた場合だけ、
// その推理を零度警部へもう一度提示できる。信頼+1自体は scene5 で加点済み。
if(window.INC.hasInsight("koderia_route")){
tf.choices.push({ target:'*s6_plea_q1_a', text:'原因はわからないけど、倒れた時に何かがあったわけじゃない', kind:'talk', chara:['reido'] });
} else {
tf.choices.push({ target:'*s6_plea_q1_d', text:'小出里亜さんは、倒れる前にダイニングへ来ています', kind:'talk', chara:['reido'] });
}
tf.choices.push({ target:'*s6_plea_q1_b', text:'怖くて、あまりよく覚えていません',       kind:'talk', chara:['reido'] });
tf.choices.push({ target:'*s6_plea_q1_c', text:'事故だと思います。何度でもそう言います',   kind:'talk', chara:['reido'] });
[endscript]
[stand_select storage="scene6.ks" se="decide.mp3" prompt="「まず——今夜の事件に関して、あなたはどのように考えていますか？」"]


*s6_plea_q1_a
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]
; この観点での信頼+1は scene5 で獲得済み。ここでは二重加点しない。

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01958"]
小出里亜さんが倒れた時も、叡留久さんが倒れた時も、私はすぐ傍にいました。[p]

#mahoru
[voice id="v01959"]
その上で——ひとつ、考えたことがあります。[p]

#mahoru
[voice id="v01960"]
小出里亜さんは、倒れる十分前にダイニングへ来ています。[p]

#mahoru
[voice id="v01961"]
倒れた場所に原因が、あるわけじゃないと思います。[p]
[reset_message_chara]

#
零度警部の眉が、はっきりと動いた。[p]

#reido
[voice id="v01962"]
……先ほども、その点を指摘していましたね。[p]

#reido
[voice id="v01963"]
もう一度、あなたの言葉で聞かせてください。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01964"]
キッチン以外の場所に毒があるかもしれないということです。[p]
[reset_message_chara]

#reido
[voice id="v01965"]
……[p]

#reido
[voice id="v01966"]
それは、この館に着いてから私が言い続けていることです。[p]

#reido
[voice id="v01967"]
素人の口から出てくるとは思いませんでしたが。[p]

[jump target="*s6_plea_q2"]


; scene5 で核心まで届かなかった場合。事実は挙げられるが、まだ推理にはなっていない。
*s6_plea_q1_d
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01968"]
小出里亜さんは、倒れる前に一度ダイニングへ来ています。[p]

#mahoru
[voice id="v01969"]
そこには、何人か人がいました。[p]
[reset_message_chara]

#reido
[voice id="v01970"]
……それは調書にもあります。[p]

#reido
[voice id="v01971"]
大事な事実です。ですが——事実を並べるだけでは、まだ捜査の見方は変わらない。[p]

#
真歩流は唇を噛んだ。[r]
#
あの十分間に何があるのか、まだ自分の言葉では掴めていなかった。[p]

[jump target="*s6_plea_q2"]


*s6_plea_q1_b
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01972"]
……こわくて。正直、あまり覚えていなくて。[p]
[reset_message_chara]

#reido
[voice id="v01973"]
正直なのは結構です。[p]

#reido
[voice id="v01974"]
ですが、覚えていない人に何かを任せる理由には、なりません。[p]

[jump target="*s6_plea_q2"]


*s6_plea_q1_c
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="order" num="0" wait="false"]
[eval exp="f.s6_trust = f.s6_trust - 1"]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01975"]
事故です。何度でも言います。[p]

#mahoru
[voice id="v01976"]
この館に、人を殺すような人なんていません。[p]
[reset_message_chara]

#reido
[voice id="v01977"]
……真白さん。[p]

#reido
[voice id="v01978"]
見たことを訊いたのに、あなたは思っていることを答えた。[p]

#reido
[voice id="v01979"]
その二つを混ぜる人を、私は現場に立たせられません。[p]

[jump target="*s6_plea_q2"]


;--- 問② なぜ外していいと言えるか --------------------------
*s6_plea_q2
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s6_plea_q2_a', text:'私と愛理は片時も離れていません。', kind:'talk', chara:['reido'] });
tf.choices.push({ target:'*s6_plea_q2_b', text:'妹に毒を盛る理由が、私にありますか',                     kind:'talk', chara:['reido'] });
tf.choices.push({ target:'*s6_plea_q2_c', text:'私は犯人じゃない、信じてください。',                           kind:'talk', chara:['reido'] });
[endscript]
[stand_select storage="scene6.ks" se="decide.mp3" prompt="「では——なぜ、あなたを容疑から外していいと言えるのですか」"]


*s6_plea_q2_a
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]
[eval exp="f.s6_trust = f.s6_trust + 1"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01980"]
私と愛理は、館に着いてから片時も離れていません。[p]

#mahoru
[voice id="v01981"]
私の言葉じゃなくていいんです。全員の供述と、照らし合わせてください。[p]

#mahoru
[voice id="v01982"]
それで嘘があれば、その時に外してください。[p]
[reset_message_chara]

#
零度警部の目が、わずかに動いた。[p]

#reido
[voice id="v01983"]
……自分の言葉を信じてくれ、とは言わないのですね。[p]

#reido
[voice id="v01984"]
確かめられる形で話す人は、そう多くない。[p]

[jump target="*s6_plea_q3"]


*s6_plea_q2_b
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01985"]
妹に毒を盛る理由が、私にありますか？[p]

#mahoru
[voice id="v01986"]
倒れているのは、私の家族なんですよ。[p]
[reset_message_chara]

#reido
[voice id="v01987"]
筋は通っています。[p]

#reido
[voice id="v01988"]
ですが、動機がないことは、やっていないことの証明にはならない。[p]

[jump target="*s6_plea_q3"]


*s6_plea_q2_c
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="order" num="0" wait="false"]
[eval exp="f.s6_trust = f.s6_trust - 1"]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v01989"]
信じてください。それだけです。[p]
[reset_message_chara]

#reido
[voice id="v01990"]
信じる信じないで人が死ななくなるなら、警察は要りません。[p]

[jump target="*s6_plea_q3"]


;--- 問③ あなたが動く意味 ----------------------------------
*s6_plea_q3
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s6_plea_q3_a', text:'警察に話さないことでも私になら……', kind:'talk', chara:['reido'] });
tf.choices.push({ target:'*s6_plea_q3_b', text:'一人でも手が多い方がいいはずです',                 kind:'talk', chara:['reido'] });
tf.choices.push({ target:'*s6_plea_q3_c', text:'やることが多い警部より、私の方が早く動けます',                   kind:'talk', chara:['reido'] });
[endscript]
[stand_select storage="scene6.ks" se="decide.mp3" prompt="「最後に。警察がいるのに、あなたが動く意味は何ですか」"]


*s6_plea_q3_a
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]
[eval exp="f.s6_trust = f.s6_trust + 1"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v01991"]
皆さんは、警察の方には話さないことでも——私になら、話してくれるかもしれません。[p]

#mahoru
[voice id="v01992"]
同じ屋根の下で、同じものを食べて、一緒に笑った相手ですから。[p]
[reset_message_chara]

#
零度警部は、しばらく黙っていた。[p]

#reido
[voice id="v01993"]
……痛いところを突きますね。[p]

#reido
[voice id="v01994"]
それは、確かに我々にはできないことだ。[p]

[jump target="*s6_plea_extra"]


*s6_plea_q3_b
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01995"]
一人でも、手が多い方がいいはずです。[p]
[reset_message_chara]

#reido
[voice id="v01996"]
人手なら足りています。足りていないのは時間です。[p]

[jump target="*s6_plea_extra"]


*s6_plea_q3_c
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="order" num="0" wait="false"]
[eval exp="f.s6_trust = f.s6_trust - 1"]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v01997"]
警部より、私の方が早く動けます。[p]
[reset_message_chara]

#reido
[voice id="v01998"]
……その一言は、書き留めておきます。[p]

#reido
[voice id="v01999"]
素人が我々より早く動くと、現場が壊れるんですよ。[p]

[jump target="*s6_plea_extra"]


;--- 補足：この夜、実際に見たこと・聞いたこと ----------------
*s6_plea_extra
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

; 事件の夜に自分の目で拾った観察の数を数える
[iscript]
tf.s6_eye = 0;
if(window.INC.hasInsight("koderia_eyes")){ tf.s6_eye++; }
if(window.INC.hasInsight("kitchen_pot")){  tf.s6_eye++; }
if(window.INC.hasInsight("eruku_mouth")){  tf.s6_eye++; }
[endscript]

#reido
[voice id="v02000"]
ひとつだけ。あなたが見たもので、我々の調書にないものはありますか？[p]

[if exp="tf.s6_eye>=2"]
[eval exp="f.s6_trust = f.s6_trust + 1"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02001"]
あります。[p]
[reset_message_chara]

#
真歩流は、あの数十秒で目に焼きついたものを、順に並べていった。[p]
#
警部の手が、途中から手帳を走らせはじめた。[p]

#reido
[voice id="v02002"]
……なるほど。[p]

#reido
[voice id="v02003"]
どれも、部下の調書には一行も出てこない。[p]

#reido
[voice id="v02004"]
見ていた、というのは本当のようだ。[p]
[else]
[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02005"]
……すみません。[p]

#mahoru
[voice id="v02006"]
あの時は、必死で……何も、思い出せません。[p]
[reset_message_chara]

#reido
[voice id="v02007"]
そうですか。[p]

#reido
[voice id="v02008"]
無理に作られるより、ずっといい。[p]
[endif]

; 待っている間に、参加者と言葉を交わしていたか
[if exp="f.s6_talked>=3"]
[eval exp="f.s6_trust = f.s6_trust + 1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02009"]
それから——待っている間に、皆さんとお話ししました。[p]

#mahoru
[voice id="v02010"]
警部が聞き取った時とは、少し違うことを言っていた方もいます。[p]
[reset_message_chara]

#reido
[voice id="v02011"]
……それを、私に持ってくると。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02012"]
はい。約束します。[p]
[reset_message_chara]
[endif]

; ── 信頼度の判定 ──
;   2 = 信頼 ／ 1 = 普通 ／ 0 = 早い
[iscript]
var t = Number(f.s6_trust);
if(!isFinite(t)){ t = 0; }
if(t >= 5){ f.s6_trust_rank = 2; }
else if(t >= 1){ f.s6_trust_rank = 1; }
else { f.s6_trust_rank = 0; }
[endscript]

[if exp="f.s6_trust_rank==2"]
[achieve id="s56_plea"]
[endif]


*s6_plea_done
[cm]
[show_menu]
[chara_hide_all]
[bg storage="hallway_night.png" time=0]
[gage_draw place="舞黒館:廊下(1F)"]
[charapos name="reido" face="thinking" num="0"]

#
しばらくの沈黙。[p]

#reido
[voice id="v02013"]
……[p]

#reido
[voice id="v02014"]
供述の確認をしましょう。[p]

#
零度警部は部下に指示を出した。[r]
#
数分後、部下が戻ってくる。[p]

#警察
警部、全員の証言を確認しました。真白真歩流と真白愛理は、終始行動を共にしていたことが裏付けられています。[p]

#
零度警部は目を細めた。[p]

[chara_mod name="reido" face="normal"]
#reido
[voice id="v02015"]
……わかりました。[p]

#reido
[voice id="v02016"]
条件を付けます。必ず警察官一名を同伴すること。[p]

#reido
[voice id="v02017"]
得た情報は必ず私に報告すること。独断で行動しないこと。[p]

#reido
[voice id="v02018"]
これを守れるなら——協力を認めます。[p]

#警察
よろしいのですか、警部！？[p]

#警察
一般人に捜査をさせるなんて。[p]

#reido
[voice id="v02019"]
状況が状況だ。[p]

#reido
[voice id="v02020"]
もし、何かあれば、私が責任を負う。[p]

#警察
……了解しました。[p]

#警察
それでは、私が一緒に調査に当たります。[p]


;-----------------------------------------
; 信頼度で、この後の運びが変わる
;   2=信頼 … 警部が先に手の内を明かす。そのぶん出発は遅くなる
;   1=普通 … これまで通り
;   0=早い … 話は打ち切り。すぐ動けるが、リビングはまだ鑑識の中
;-----------------------------------------
[if exp="f.s6_trust_rank==2"]
[chara_mod name="reido" face="normal"]
#reido
[voice id="v02021"]
——真白さん。少し、時間をください。[p]

#reido
[voice id="v02022"]
やみくもに歩かれるより、こちらの持っているものを先にお渡しした方が早い。[p]

#
零度警部は部下を下がらせ、手帳を開いた。[r]
#
それから十分以上かけて、いま警察が掴んでいることを順に話してくれた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02023"]
（警部さん、こんなことまで……）[p]
[reset_message_chara]

#reido
[voice id="v02024"]
渡した以上は、必ず報告してください。それが条件です。[p]

[elsif exp="f.s6_trust_rank==1"]
#reido
[voice id="v02025"]
準備ができ次第、始めてください。[p]

#reido
[voice id="v02026"]
現場はまだ動いています。近づく前に、必ず一声かけること。[p]

[else]
[chara_mod name="reido" face="order"]
#reido
[voice id="v02027"]
——話は以上です。もう行ってください。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02028"]
え……[p]
[reset_message_chara]

#reido
[voice id="v02029"]
納得したから許すのではありません。時間がないから許すのです。[p]

#reido
[voice id="v02030"]
それと——リビングにはまだ入らないでください。鑑識が終わっていない。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02031"]
……はい。[p]
[reset_message_chara]
[endif]

; 20:20 に確定（実際に動き出す時刻は scene7 の冒頭で信頼度ごとに決まる）
[set_time hour=20 min=20]
[gage_draw place="舞黒館:リビング"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02032"]
……ありがとうございます！[p]

[reset_message_chara]

#
私の中で、何かが固まった。[p]

; 事件の夜、一度も立ち尽くさなかった
[if exp="f.s56_urgent_frozen==0 && f.s56_urgent_acted>=2"]
[achieve id="s56_hands"]
[endif]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02033"]
（愛理を助ける）[p]

#mahoru
[voice id="v02034"]
（そのために——必ず真相を解明する！）[p]
[reset_message_chara]

[iscript]
tf.s56_n = window.INC.insightCount();
[endscript]

[if exp="tf.s56_n>=4"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02035"]
（今夜、この目で見たこと。この耳で聞いたこと）[p]

#mahoru
[voice id="v02036"]
（ひとつも、忘れない）[p]
[reset_message_chara]
[elsif exp="tf.s56_n>=1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02037"]
（見落としたことも、たくさんある）[p]

#mahoru
[voice id="v02038"]
（それでも——覚えていることから、始めるしかない）[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02039"]
（私は、何も見ていなかった）[p]

#mahoru
[voice id="v02040"]
（でも、ここからは違う。ちゃんと、目を開ける）[p]
[reset_message_chara]
[endif]

[chara_hide_all]
[freeimage layer="1"]

[chapter_end]

[jump storage="scene7.ks" target="*start"]
