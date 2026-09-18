;=========================================
; シーン：トゥルーエンド「絆、海を越えて」
;=========================================
*true_end_start
@clearstack
[cm]
[clearfix]
[show_menu]
[bg storage="after_inncident_sunroom.png" time=1000]
[playbgm storage="veiled_truth.mp3" loop=true]
[chara_hide_all]
[set_time hour=21 min=45]
[gage_draw place="舞黒館:サンルーム"]


;=========================================
; 1. サンルームの床下・地下への入り口
;=========================================

[charapos name="reido" face="order" num="1"]
[charapos name="kazuto" face="thinking" num="2"]
[charapos name="jushika" face="thinking" num="3"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03245"]
サンルームの観葉植物が、倒れている……[p]

#mahoru
[voice id="v03246"]
それに床が……[p]
[reset_message_chara]

#
床を調べてみると、[r]
#
その下に——小さな鍵穴のついている扉があった。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03247"]
こんな扉があったなんて。[p]

#mahoru
[voice id="v03248"]
私が見たのは鍵穴だけだったのに。[p]

#mahoru
[voice id="v03249"]
……だめ、開かない。[p]
[reset_message_chara]

#kazuto
[voice id="v03250"]
内側からも鍵がかけられるのか。[p]

#kazuto
[voice id="v03251"]
メアリーはよほど俺たちに下に来てほしくないようだな。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03252"]
この鍵穴の形、もしかして……[p]
[reset_message_chara]

#
私は執務室で手に入れた鍵を差し込む。[r]
#
ガチャリ、と鍵穴が回った。[p]
#
扉が静かに持ち上がり——暗い、地下へ続く階段が現れた。[p]

; 執務室の鍵が地下への扉の鍵だと分かった
[set_item_status id="key" secret="true"]

#kazuto
[voice id="v03253"]
お前どこでそんなもの拾ってきたんだ……[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03254"]
執務室で見つけたの。[p]

#mahoru
[voice id="v03255"]
鍵穴の形が似ていたから、もしかしてとは思っていたけど。[p]

[reset_message_chara]

[chara_mod name="reido" face="order"]
#reido
[voice id="v03256"]
メアリー・キングはこの下にいる可能性があります。[p]

#reido
[voice id="v03257"]
ここは私に任せて、皆さんは待機していてください。[p]

#reido
[voice id="v03258"]
じきに警官隊の応援と救急車も来ますから。[p]

#
零度警部は迷わず、階段を下りていった。[p]

[chara_hide_all]

;=========================================
; 2. 真歩流の直感
;=========================================

[charapos name="kazuto" face="normal" num="1"]
[charapos name="jushika" face="thinking" num="2"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03259"]
（メアリーさんは何をしに地下へ行ったの？）[p]

#mahoru
[voice id="v03260"]
（何だろう？ この胸のつっかえる感じは……）[p]
[reset_message_chara]

#
気がつくと、ポケットの中でメアリーのペンダントに触れていた。[r]
#
指先に、微かな温もりを感じた気がした。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03261"]
やっぱり行く。私も地下に！[p]
[reset_message_chara]

#kazuto
[voice id="v03262"]
馬鹿、待機しろと言われただろう。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03263"]
行かないといけないの！ なんか……行かないと後悔する気がするの！[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03264"]
……はあ。なら俺も行く。[p]

#kazuto
[voice id="v03265"]
ただし、勝手に動き回るなよ。[p]

#jushika
[voice id="v03266"]
私も行きます。舞黒館の管理者として、皆さんを危険にさらすわけにはいきません。[p]

[chara_hide_all]


;=========================================
; 3. 地下室探索
;=========================================

[mask time=1000]
[gage_draw place="舞黒館:地下室"]
[bg storage="basement.png" time=0]
[playbgm storage="basement_area.mp3"]
[mask_off time=1000]

#
階段を下りると——広い空間が広がっていた。[p]
古い木の香りと、わずかな湿気。[r]
#
薄暗い明かりの中に、古めかしい家具や書類、そして整然とした構造物が浮かび上がっていた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03267"]
これって……[p]
[reset_message_chara]

[charapos name="kazuto" face="thinking" num="1"]
[charapos name="jushika" face="thinking" num="2"]

#kazuto
[voice id="v03268"]
……見せてもらった設計図と、ほぼ同じ作りだな。[p]

#jushika
[voice id="v03269"]
舞黒邦夢の邸宅として、昭和五年——1930年に増築されたものです。[p]

#jushika
[voice id="v03270"]
当時のまま残っているようです。[p]

#jushika
[voice id="v03271"]
周辺に置かれている本や雑貨は、かなり古いものですから。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03272"]
どうしてそんなことがわかるんですか？[p]
[reset_message_chara]

#jushika
[voice id="v03273"]
置かれているものをよく見てください。[p]

#jushika
[voice id="v03274"]
文字が右から左に読めるようになっているでしょう？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03275"]
あ、本当だ。[p]

#mahoru
[voice id="v03276"]
それにしても、要人を避難させるために随分大きな地下を作ったんだね。[p]
[reset_message_chara]

#kazuto
[voice id="v03277"]
もしくは……他に本当の目的があったのかもしれない。[p]

#kazuto
[voice id="v03278"]
いずれにしても、何か理由があるはずだ……[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v03279"]
私、ひとつ気になっていることがあるの。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="normal"]

#kazuto
[voice id="v03280"]
何だ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03281"]
メアリーさんはどうして親戚を探しているんだろうって。[p]

#mahoru
[voice id="v03282"]
海外にいる親戚で連絡が途絶えていても探したくなるってすごいなって思ってたから。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03283"]
他に家族がいないとか……色々考えられる。[p]

#kazuto
[voice id="v03284"]
あの人の不可解な行動の数々は、それと関係があるのかもしれない。[p]

#jushika
[voice id="v03285"]
……[p]

#kazuto
[voice id="v03286"]
もう少し奥を探ろう。[p]

[chara_hide_all]


;=========================================
; 4. 開いている部屋の発見
;=========================================

#
地下室を進むにつれて、廊下は複雑に入り組んでいた。[r]
#
歴史の残滓が、あちこちに漂っている。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03287"]
——あそこ、扉が開いている。[p]
[reset_message_chara]

#
奥の一室に、光が漏れていた。[r]
#
真歩流はゆっくりと扉を押し開けた。[p]

;=========================================
; 5. 零度とメアリーとの対面
;=========================================

[mask time=400]
[bg storage="basement_room.png" time=0]
[mask_off time=400]

[charapos name="reido"   face="order"     num="1"]
[charapos name="mary" face="surprised" num="3"]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03288"]
警部……！　それに、メアリーさん！[p]
[reset_message_chara]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03289"]
皆さん……なぜここへ。待機するよう言いましたが。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03290"]
気になることがあって——メアリーさん。[p]
[reset_message_chara]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v03291"]
……真歩流さん。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03292"]
教えてください。どうして地下室のことが分かったんですか？[p]
#mahoru
[voice id="v03293"]
それにどうやってここへ？ 鍵がかかっていたのに……[p]
[reset_message_chara]

#mary
[voice id="v03294"]
それは……[p]

[chara_mod name="mary" face="no_say"]

#
メアリーは口をつぐんだ。[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v03295"]
メアリーさん。私からも聞かせてください。[p]

#reido
[voice id="v03296"]
なぜ、殺人事件が起きて、解決をしている中で姿を消したんですか？[p]

[chara_mod name="mary" face="surprised"]

#mary
[voice id="v03297"]
ごめんなさい、逃げたわけじゃないんです。[p]

#mary
[voice id="v03298"]
ただ……どうしても知りたいことがあって、サンルームにいるときに、偶然地下への入り口を見つけて。[p]

#mary
[voice id="v03299"]
事件となったら、調べられなくなるかもしれないと思って……[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03300"]
知りたいこと……それは何ですか？[p]

#
メアリーはしばらく黙っていた。[r]
#
そして——意を決したように、顔を上げた。[p]


;=========================================
; 6. メアリーの告発と朱志香の反論
;=========================================

[chara_hide_all]
[charapos name="reido"   face="thinking" num="1"]
[charapos name="kazuto"  face="thinking" num="2"]
[charapos name="jushika" face="normal"   num="3"]
[charapos name="mary"    face="thinking" num="4"]

#mary
[voice id="v03301"]
……私は、手紙でこの舞黒館に呼ばれました。[p]

#mary
[voice id="v03302"]
差出人の名前はありませんでした。[p]

#mary
[voice id="v03303"]
でも、舞黒館に私を呼び出せる人なんて、一人しか考えられません。[p]

[chara_mod name="mary" face="anger"]
#mary
[voice id="v03304"]
朱志香さん。あなたです。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03305"]
私ですか……[p]

#jushika
[voice id="v03306"]
……その手紙を私が書いたという証拠が、どこかにあるのですか？[p]

[chara_mod name="mary" face="surprised"]
#mary
[voice id="v03307"]
それは……[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03308"]
むしろ、私からすればあなたの方がよほど不可解です。[p]

#jushika
[voice id="v03309"]
殺人事件の最中に、誰にも告げず姿を消した。[p]

#jushika
[voice id="v03310"]
そのうえ——鍵のかかっていたはずのこの地下に、あなたは先回りしている。[p]

#jushika
[voice id="v03311"]
どうやって降りていらしたのです？　メアリーさん。[p]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v03312"]
……祖母から預かった鍵で、です。[p]

#
メアリーは、古びた鍵を握りしめた。[p]

#jushika
[voice id="v03313"]
おばあ様……ですか。[p]

#jushika
[voice id="v03314"]
そのおばあ様が舞黒館の鍵をお持ちだった——その証拠は？[p]

[chara_mod name="mary" face="no_say"]
#mary
[voice id="v03315"]
……[p]

#jushika
[voice id="v03316"]
ないのでしょう。[p]

#jushika
[voice id="v03317"]
証拠もなく人を疑うのなら——怪しいのは、あなたの方では？[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v03318"]
——そこまでにしてください。[p]

#reido
[voice id="v03319"]
今は殺人事件の最中です。ここで言い争っても仕方がありません。[p]

#reido
[voice id="v03320"]
全員、地上へ戻ります。お話は改めて伺いましょう。[p]

[chara_mod name="mary" face="surprised"]
#mary
[voice id="v03321"]
い、嫌です！[p]

#mary
[voice id="v03322"]
今戻ったら……もう二度と、ここへは来られません。[p]

#mary
[voice id="v03323"]
お願いします、あと少しだけ……！[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03324"]
メアリーさん。いい加減にしてください。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03325"]
（このままだと、メアリーさんは連れて行かれちゃう）[p]

#mahoru
[voice id="v03326"]
（でも……メアリーさんは、嘘をついていない気がする）[p]

[chara_mod name="mahoru" face="pursue"]
#mahoru
[voice id="v03327"]
警部、待ってください！[p]

#mahoru
[voice id="v03328"]
メアリーさんの話、私が整理します。[p]

#mahoru
[voice id="v03329"]
そうすれば、メアリーさんが逃げたわけじゃないってわかりますから。[p]
[reset_message_chara]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03330"]
……いいでしょう。手短にお願いします。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03331"]
どうぞ。お好きなだけ。[p]


;=========================================
; 7-1. 推理① メアリーの目的
;=========================================
;-----------------------------------------------------------
; 警部の心証（真相編でも継続する）
;   scene8 で使い残した回数をそのまま引き継ぐ。
;   scene8 のエンディング分岐で f.s8_phase は 0 に落とされているので、
;   ここで 1 に戻して左上のプレートと捜査手帳に再び出す。
;   使い切ってから誤ると、これまで通りノーマルエンドへ落ちる。
;-----------------------------------------------------------
[iscript]
if(typeof f.s8_miss_left !== "number"){
// 途中セーブからの再開などで欠けていた場合の保険
f.s8_miss_max  = (typeof f.s6_trust_rank === "number" ? f.s6_trust_rank : 1) + 1;
f.s8_miss_left = f.s8_miss_max;
}
f.s8_retry   = "";
f.s8_te_fail = "*mary_deduction_ng";
f.s8_phase   = 1;
[endscript]
[hud_draw]

[chara_hide_all]
[charapos name="jushika" face="normal"  num="1"]
[charapos name="mary"    face="thinking" num="3"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03332"]
まず——メアリーさんが、どうして舞黒館に来たのかです。[p]
[reset_message_chara]

#jushika
[voice id="v03333"]
観光でしょう？　うちは宿泊イベントを開いていたのですから。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03334"]
違います。メアリーさんには、はっきりした目的がありました。[p]

#mahoru
[voice id="v03335"]
それを証明できるものがあります。[p]
[reset_message_chara]

[chara_hide_all]

*q_te_purpose
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'letter'"]
[jump target="*mary_purpose_ok"]
[else]
[eval exp="f.s8_retry='*q_te_purpose_retry'; f.s8_te_fail='*mary_deduction_ng'"]
[jump target="*te_miss_common"]
[endif]

; ▼ 以下、新規会話は要ボイス収録
*q_te_purpose_retry
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03947"]
もう一度——メアリーさんが舞黒館へ来た目的を示すものを、お見せします。[p]
[reset_message_chara]
[chara_hide_all]
[jump target="*q_te_purpose"]

*mary_purpose_ok
[gage_draw place="舞黒館:地下室"]
[show_menu]
[chara_hide_all wait="false"]
[charapos name="jushika" face="thinking"  num="1" wait="false"]
[charapos name="mary"    face="surprised" num="3" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03336"]
メアリーさんのスーツケースに入っていた手紙です。[p]

#mahoru
[voice id="v03337"]
『親戚のことが知りたければ、宿泊イベントに参加せよ』——そう書いてありました。[p]

#mahoru
[voice id="v03338"]
メアリーさんの目的は——親戚を探すためです。[p]
[reset_message_chara]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v03339"]
……はい。その通りです。[p]

#mary
[voice id="v03340"]
私には、日本にいるはずの親戚がいます。[p]

#mary
[voice id="v03341"]
祖母がずっと探していて……見つけられないまま、歳を取ってしまった。[p]

#mary
[voice id="v03342"]
だから、私が代わりに来たんです。[p]


;=========================================
; 7-2. 推理② メアリーが朱志香を疑った理由
;=========================================

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03343"]
親戚探し。結構なことですね。[p]

#jushika
[voice id="v03344"]
けれど、それがどうして私を疑う理由になるのかしら。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03345"]
メアリーさんは、この宿泊イベントの間ずっと……みんなを見ていましたよね。[p]
[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v03346"]
……ええ。[p]

#mary
[voice id="v03347"]
私をここへ呼んだのが誰なのか、確かめたかったんです。[p]

#mary
[voice id="v03348"]
だから、皆さんの様子をずっと見ていました。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03349"]
趣味の悪いこと。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03350"]
その中で、メアリーさんが引っかかったものがあります。[p]

#mahoru
[voice id="v03351"]
あるものが無くなったからです。[p]

#mahoru
[voice id="v03352"]
それが、朱志香さんを疑う理由になりました。[p]
[reset_message_chara]

[chara_hide_all]

*q_te_doubt
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'pendant'"]
[jump target="*mary_doubt_ok"]
[else]
[eval exp="f.s8_retry='*q_te_doubt_retry'; f.s8_te_fail='*mary_deduction_ng'"]
[jump target="*te_miss_common"]
[endif]

; ▼ 以下、新規会話は要ボイス収録
*q_te_doubt_retry
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03948"]
メアリーさんの手元から無くなったもの——もう一度、お見せします。[p]
[reset_message_chara]
[chara_hide_all]
[jump target="*q_te_doubt"]

*mary_doubt_ok
[gage_draw place="舞黒館:地下室"]
[show_menu]
[chara_hide_all wait="false"]
[charapos name="jushika" face="thinking" num="1" wait="false"]
[charapos name="mary"    face="thinking" num="3" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03353"]
メアリーさんのペンダントが無くなった時のことです。[p]

#mahoru
[voice id="v03354"]
あのペンダント、執務室で見つかりましたよね。[p]
[reset_message_chara]

#mary
[voice id="v03355"]
はい。[p]

#mary
[voice id="v03356"]
あの部屋に入れるのは、朱志香さんと小出里亜さんだけだと聞きました。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03357"]
それに、私たちの荷物を執務室にまとめて運んだのは——朱志香さん、あなたです。[p]
[reset_message_chara]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03358"]
ええ、運びましたわ。[p]

#jushika
[voice id="v03359"]
客室を整えるために、皆さまのお荷物を一度あの部屋にまとめた。それだけのことです。[p]

#jushika
[voice id="v03360"]
落とし物が紛れ込んでいても、おかしくはないでしょう。[p]

#jushika
[voice id="v03361"]
——それだけでは、私を疑う理由にはなりませんわね。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03362"]
（……確かに。ペンダントを持って行っただけで、なんの疑いもない）[p]
[reset_message_chara]


;=========================================
; 7-3. 推理③ 朱志香がメアリーを呼び出す理由
;=========================================

#jushika
[voice id="v03363"]
そもそも——私がメアリーさんを呼び出して、何の得があるのです？[p]

[chara_mod name="mary" face="anger"]
#mary
[voice id="v03364"]
……地下へ、連れて行くためです。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03365"]
地下へ？　何のために。[p]

[chara_mod name="mary" face="no_say"]
#mary
[voice id="v03366"]
それは……[p]

#
メアリーは、そこで言葉に詰まってしまった。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03367"]
答えられないのですね。[p]

#jushika
[voice id="v03368"]
それに、今のお話は——私が地下のことを前から知っていた、という前提があってこそ。[p]

#jushika
[voice id="v03369"]
その証拠は、どこに？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03370"]
……ありますよ。[p]

#mahoru
[voice id="v03371"]
それは厳重に守られていましたから。[p]
[reset_message_chara]

[chara_hide_all]

*q_te_reason
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'key'"]
[jump target="*mary_reason_ok"]
[else]
[eval exp="f.s8_retry='*q_te_reason_retry'; f.s8_te_fail='*mary_deduction_ng'"]
[jump target="*te_miss_common"]
[endif]

; ▼ 以下、新規会話は要ボイス収録
*q_te_reason_retry
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03949"]
朱志香さんが地下のことを前から知っていた——その証拠を、もう一度お見せします。[p]
[reset_message_chara]
[chara_hide_all]
[jump target="*q_te_reason"]

*mary_reason_ok
[gage_draw place="舞黒館:地下室"]
[show_menu]
[chara_hide_all wait="false"]
[charapos name="jushika" face="surprised" num="1" wait="false"]
[charapos name="mary"    face="normal"    num="3" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03372"]
この鍵です。[p]

#mahoru
[voice id="v03373"]
執務室の、執務机の裏に隠されていました。[p]

#mahoru
[voice id="v03374"]
あの机には厳重なセキュリティがかけられていました。[p]
[reset_message_chara]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03375"]
だから何だというの？[p]

#jushika
[voice id="v03376"]
古い館です。前の所有者が、大切な鍵を隠していたとしても不思議ではないでしょう。[p]

#jushika
[voice id="v03377"]
それだけで、私が地下の存在を知っていた証拠にはなりませんわ。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03378"]
——いいえ。[p]

#mahoru
[voice id="v03379"]
前の所有者が守っていた鍵なら、その説明で通ります。[p]

#mahoru
[voice id="v03380"]
でも、あのセキュリティを取り付けたのは朱志香さん自身ですよね。[p]

[voice id="v03381"]
昼間、朱志香さんが言っていました。[p]
#mahoru
[voice id="v03382"]
この館を購入した後、重要な書類を守るために自分で業者へ頼んだって。[p]
[reset_message_chara]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03383"]
……。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03384"]
しかも、引き出しの中にあったのは普通の書類ばかりでした。[p]

#mahoru
[voice id="v03385"]
あれだけ厳重に守る理由が見当たらない。[p]

#mahoru
[voice id="v03386"]
でも机の裏には、この鍵が隠されていた。[p]

[voice id="v03387"]
つまり、守られていたのは引き出しの中身じゃない。[r]
#mahoru
[voice id="v03388"]
——この鍵だったんです。[p]

#mahoru
[voice id="v03389"]
朱志香さんは、この鍵が何の鍵なのか知っていた。[p]

#mahoru
[voice id="v03390"]
だからこそ、鍵が隠された机を、自分で取り付けたセキュリティで守った。[p]

#mahoru
[voice id="v03391"]
朱志香さん。あなたは宿泊イベントより前から——この地下室を知っていたんですよね。[p]
[reset_message_chara]

#jushika
[voice id="v03392"]
……よく、そこまで見ていましたね。[p]

[chara_hide_all]
[charapos name="reido"   face="thinking" num="1"]
[charapos name="jushika" face="thinking" num="2"]
[charapos name="mary"    face="normal"   num="3"]

#mary
[voice id="v03393"]
……私が姿を消した理由も、それです。[p]

[voice id="v03394"]
事件が起きれば、館の中は警察の方でいっぱいになる。[r]
#mary
[voice id="v03395"]
朱志香さんも、私から目を離さざるを得ない。[p]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v03396"]
誰の干渉も受けずに地下を確かめられるのは——今しかないと思ったんです。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03397"]
……少なくとも、あなたが逃亡のために姿を消したわけではないことは分かりました。[p]

#reido
[voice id="v03398"]
ですが、まだ一つ残っています。[p]

#reido
[voice id="v03399"]
朱志香さんが地下を知っていたとして——なぜ、あなたをここへ呼ぶ必要があったのか。[p]

;=========================================
; 7-4. メアリーの問い
;=========================================

[chara_hide_all]
[charapos name="jushika" face="thinking" num="1"]
[charapos name="mary"    face="anger"    num="3"]

#mary
[voice id="v03400"]
朱志香さん。今度は、私が聞かせてください。[p]

#mary
[voice id="v03401"]
あなたは——どうして、私をこの館に呼んだのですか。[p]

[jump target="*mary_confront_done"]


;=========================================
; 7-4-x. 心証を1つ使ってやり直す
;   解決編の *miss_common と同じ役割。
;   f.s8_retry   … やり直しの戻り先
;   f.s8_te_fail … 心証を使い切ったときの落ち先（ノーマルエンドへ繋がる）
;=========================================
*te_miss_common
[cm]
[clearfix]
[show_menu]
[gage_draw place="舞黒館:地下室"]
[layopt layer="message0" visible=true]
[chara_hide_all wait="false"]
[iscript]
// 落ち先が空だと [jump] がこのファイルの頭へ戻ってしまうので必ず埋めておく
if(!f.s8_te_fail){ f.s8_te_fail = "*mary_deduction_ng"; }
[endscript]
; ●が一つも残っていない状態で誤ったら、そこで終わり。先に判定してから減らす
[jump cond="(f.s8_miss_left||0) <= 0" target="&f.s8_te_fail"]
[eval exp="f.s8_miss_left = f.s8_miss_left - 1"]
[hud_draw]

[charapos name="reido" face="thinking" num="0" wait="false"]
; ▼ 以下、新規会話は要ボイス収録
#reido
[voice id="v03950"]
真白さん。今のは違います。[p]

#reido
[voice id="v03951"]
まだ聞いています。もう一度、組み立て直してください。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03952"]
……はい。[p]
[reset_message_chara]
[chara_hide_all]
[jump cond="f.s8_retry == ''" target="&f.s8_te_fail"]
[jump target="&f.s8_retry"]


;=========================================
; 7-5. 推理に失敗した場合（ノーマルエンドへ）
;=========================================

*mary_deduction_ng
; 推理パートはここで終わり。左上の心証表示も畳む
[eval exp="f.s8_phase = 0"]
[gage_draw place="舞黒館:地下室"]
[show_menu]
[chara_hide_all]
[charapos name="jushika" face="normal" num="1"]
[charapos name="mary"    face="no_say" num="3"]

#jushika
[voice id="v03402"]
……それが、何か関係がありまして？[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03403"]
あれ……違ったのかな……[p]

#mahoru
[voice id="v03404"]
すみません、勘違いでした……[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="order"  num="1"]
[charapos name="mary"  face="no_say" num="3"]

#reido
[voice id="v03405"]
——もう十分でしょう。全員、地上へ戻ります。[p]

#mary
[voice id="v03406"]
……[p]

#
メアリーは、それ以上何も言わなかった。[r]
#
私たちは零度警部に連れられて、地下を後にした。[p]

[mask]
[chara_hide_all]
[free_layer_image]
[bg storage="bedroom_night.png" time=0]
[position layer="message0" page=fore visible=true]
[playbgm storage="seeking_warmth.mp3"]
[mask_off]
;失敗の場合はノーマルエンドへ
[jump storage="ending/normal_end.ks" target="*return_normal"]


*mary_confront_done
#jushika
[voice id="v03407"]
……では、聞きましょう。[p]

#jushika
[voice id="v03408"]
仮に私が地下の存在を知っていたとして——どうしてメアリーさんを呼ぶ必要があるの？[p]

#mary
[voice id="v03409"]
……。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03410"]
（そこがまだ繋がってない）[p]

[voice id="v03411"]
（朱志香さんは地下を知っていた）[r]
#mahoru
[voice id="v03412"]
（メアリーさんは親戚を探していた）[p]

#mahoru
[voice id="v03413"]
（この二つを繋げるものは……）[p]
[reset_message_chara]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03414"]
朱志香さんは、メアリーさんを呼ぶ前から——キング家について調べていたんじゃないですか。[p]
[reset_message_chara]

#jushika
[voice id="v03415"]
……どうしてそう思うの？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03416"]
館を調べた時、A・Kのイニシャルが刻まれた食器がありました。[p]

#mahoru
[voice id="v03417"]
それに執務室には、舞黒館に関係した人たちの資料も残っていた。[p]

#mahoru
[voice id="v03418"]
Kはキング——メアリーさんの一族。[p]

#mahoru
[voice id="v03419"]
朱志香さんはこの館を調べる中で、キング家とメアリーさんに辿り着いた。[p]
[reset_message_chara]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03420"]
……父親譲りね。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03421"]
え……お父さん？[p]
[reset_message_chara]

#jushika
[voice id="v03422"]
ええ。あなたのお父様——奢禄さんに、この舞黒館の調査を依頼したのは私です。[p]

#jushika
[voice id="v03423"]
私は、地下にある一つの金庫を探していました。[p]

#jushika
[voice id="v03424"]
そこには莫大な価値の宝石が眠っていると言われていた。[p]

#jushika
[voice id="v03425"]
けれど、金庫は見つかっても開かなかった。[p]

#jushika
[voice id="v03426"]
そして奢禄さんは調査を終えた後、私にこう言いました。[p]

#jushika
[voice id="v03427"]
『この家の調査は、これ以上してはいけない』——と。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03428"]
お父さんが……ここに来てた……。[p]
[reset_message_chara]

#jushika
[voice id="v03429"]
その後、彼はさらに何かを調べると言って、姿を消しました。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03430"]
（お父さんは、この地下で何か危険なものに気づいた……？）[p]
[reset_message_chara]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03431"]
しかし、それでもメアリーさんを呼ぶ理由にはなりません。[p]

#reido
[voice id="v03432"]
金庫とメアリーさんに、何の関係が？[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03433"]
……そこまで分かっているなら、真歩流さんに答えてもらいましょうか。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03434"]
（金庫を開けられない）[p]

#mahoru
[voice id="v03435"]
（メアリーさんのおばあさんから送られてきたもの……）[p]

#mahoru
[voice id="v03436"]
（そして朱志香さんが、わざわざ執務室へ持ち込んだもの……）[p]
[reset_message_chara]

*q_te_safe
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'pendant'"]
[jump target="*correct_pendant"]
[else]
[eval exp="f.s8_retry='*q_te_safe_retry'; f.s8_te_fail='*bad_choice'"]
[jump target="*te_miss_common"]
[endif]

; ▼ 以下、新規会話は要ボイス収録
*q_te_safe_retry
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03953"]
（……もう一度。金庫を開けるために要るものは、なに。）[p]
[reset_message_chara]
[jump target="*q_te_safe"]

*bad_choice
[eval exp="f.s8_phase = 0"]
[gage_draw place="舞黒館:地下室"]
[show_menu]
#reido
[voice id="v03437"]
それが金庫とどう繋がるのです？[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03438"]
あれ……違う……。[p]
[reset_message_chara]

#jushika
[voice id="v03439"]
残念でしたね。[p]

#reido
[voice id="v03440"]
——ここまでです。全員、地上へ戻ります。[p]

[mask]
[chara_hide_all]
[free_layer_image]
[bg storage="bedroom_night.png" time=0]
[position layer="message0" page=fore visible=true]
[playbgm storage="seeking_warmth.mp3"]
[mask_off]
[jump storage="ending/normal_end.ks" target="*return_normal"]

*correct_pendant
; 最後の提示に正解。ここで推理パートは終わり、心証表示も畳む
[eval exp="f.s8_phase = 0"]
[gage_draw place="舞黒館:地下室"]
[show_menu]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03441"]
——ペンダントです。[p]

#mahoru
[voice id="v03442"]
メアリーさんのおばあ様は、舞黒館へ行くと知って、鍵と一緒にこのペンダントを送った。[p]

#mahoru
[voice id="v03443"]
ただの形見なら、このタイミングで送る必要はありません。[p]

#mahoru
[voice id="v03444"]
このペンダントは——金庫を開けるために必要な『証』の一つなんじゃないですか。[p]
[reset_message_chara]

#mary
[voice id="v03445"]
……祖母からも、そう聞いています。[p]

#mary
[voice id="v03446"]
地下の金庫を開くには、キング家に伝わるペンダントが必要だと。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03447"]
……。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03448"]
だから、ペンダントが執務室で見つかった。[p]

#mahoru
[voice id="v03449"]
朱志香さんは荷物を運ぶ時に、メアリーさんのペンダントを抜き取った。[p]

[voice id="v03450"]
でも、なくなったことに気づかれて大騒ぎになった。[r]
#mahoru
[voice id="v03451"]
このままじゃ宿泊イベントそのものが中止になるかもしれない。[p]

#mahoru
[voice id="v03452"]
だから『執務室に落ちていた』ことにして、見つけさせた。[p]
[reset_message_chara]

#mary
[voice id="v03453"]
……私が疑い始めたのも、それからです。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03454"]
でも、まだ変です。[p]

#mahoru
[voice id="v03455"]
ペンダントが欲しいだけなら、メアリーさんだけを呼び出せばいい。[p]

#mahoru
[voice id="v03456"]
どうしてわざわざ——宿泊イベントにしたんですか？[p]
[reset_message_chara]

#jushika
[voice id="v03457"]
……目立たせないためよ。[p]

#reido
[voice id="v03458"]
誰の目を？[p]

#jushika
[voice id="v03459"]
娘を誘拐した連中です。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v03460"]
十年以上前、私の娘——アンナは誘拐された。[p]

#jushika
[voice id="v03461"]
舞黒館を購入した時、そいつらは地下にある何かを狙って再び現れた。[p]

#jushika
[voice id="v03462"]
メアリー一人だけを呼べば、奴らに気づかれる可能性がある。[p]

#jushika
[voice id="v03463"]
だから大勢の宿泊客に紛れさせた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03464"]
娘さんが……誘拐……。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03465"]
……。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03466"]
それだけじゃないですよね。[p]

#mahoru
[voice id="v03467"]
宿泊なら——夜になれば、メアリーさんはこの館で眠る。[p]

#mahoru
[voice id="v03468"]
その時なら、ペンダントを奪ってもすぐには気づかれない。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]

#jushika
[voice id="v03469"]
……本当に鋭いですね。[p]

#jushika
[voice id="v03470"]
その通りです。[p]

#jushika
[voice id="v03471"]
本来は、お茶会でメアリーさんの紅茶に睡眠薬を入れるつもりでした。[p]

#jushika
[voice id="v03472"]
眠った後で拘束し、ペンダントと金庫を開くために必要なものを確かめる。[p]

#jushika
[voice id="v03473"]
でも珠璃さんが殺人計画を実行して——全部、狂ってしまった。[p]

[message_chara name="reido" face="thinking"]
#reido
[voice id="v03474"]
しかし、執務室にあった茶葉の缶は鑑識が調べています。[p]

#reido
[voice id="v03475"]
中から毒物も薬物も検出されなかった。[p]
[reset_message_chara]

#jushika
[voice id="v03476"]
薬を混ぜたのは、缶の中の茶葉ではありません。[p]

#jushika
[voice id="v03477"]
メアリーさんに出す一杯分だけ、先に取り分けておいたのです。[p]

#jushika
[voice id="v03478"]
あの騒ぎの後、細工した分だけ別の場所へ移しました。[p]

[message_chara name="kazuto" face="thinking"]
#kazuto
[voice id="v03479"]
……それで愛理だけ症状の出方が違った可能性があるのか。[p]

#kazuto
[voice id="v03480"]
毒以外の薬も体に入っていたなら、経過が他の二人と同じにならなくてもおかしくない。[p]
[reset_message_chara]

;=========================================
; 10. 真歩流の問い・拳銃の登場
;=========================================

[chara_hide_all]
[charapos name="jushika" face="normal" num="0"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03481"]
朱志香さん……どうして、そこまでして宝石を手に入れたいんですか？[p]
[reset_message_chara]

#
朱志香の表情が、静かに変わった。[p]

#jushika
[voice id="v03482"]
これ以上、語ることはないでしょう？[p]

[chara_mod name="jushika" face="shot"]

#
朱志香は——隠し持っていた拳銃を、ゆっくりと向けた。[p]

[chara_hide_all]
[playbgm storage="open_truth.mp3"]
[charapos name="reido"   face="order"  num="1"]
[charapos name="kazuto"  face="pursue" num="2"]
[charapos name="jushika" face="shot"  num="3"]
[charapos name="mary" face="surprised"  num="4"]
#reido
[voice id="v03483"]
富礼知さん、やめなさい！　武器を置いてください！[p]

#jushika
[voice id="v03484"]
お静かに、警部さん。[p]

#jushika
[voice id="v03485"]
ここで銃声が鳴っても、地上には聞こえません。皆さんは探索の途中でメアリーと共倒れになったことにする。[p]

[chara_mod name="jushika" face="shot"]
#jushika
[voice id="v03486"]
メアリーさん、こちらへ来なさい。[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v03487"]
行ってはいけません！[p]

[chara_mod name="jushika" face="shot"]
#jushika
[voice id="v03488"]
警部さん、殺されたいんですか？[p]

#
緊張が、部屋の空気を支配した。[r]
#
誰も動けない——そんな中で、真歩流は一つのことを思った。[p]


;=========================================
; 11. 再びペンダントを握る
;=========================================

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03489"]
（ペンダントを強く握れば……また誰かの声が聞こえるかもしれない）[p]

#mahoru
[voice id="v03490"]
（でも、さっきよりノイズが強くなってる）[p]

#mahoru
[voice id="v03491"]
（今ここで頭痛に動けなくなったら——朱志香さんに撃たれる）[p]

#mahoru
[voice id="v03492"]
（使うなら、タイミングを選ばないと……）[p]
[reset_message_chara]

#
どうする？[p]

[glink color="bth13_dk" target="*mistake" text="今すぐペンダントを握る" x=560 y=400 width=800 size=30]
[glink color="bth13_dk" target="*stay"       text="機会を待つ"             x=560 y=540 width=800 size=30]
[s]
*mistake
[glitch_awaken]

#
（ペンダントを握ると……また、頭が割れるように痛くなった！）[p]

[message_chara name="mahoru" face="preawake"]
#mahoru
[voice id="v03493"]
あ、頭が痛い。[p]
[reset_message_chara]

#
（ノイズは先ほどよりも大きく、頭痛が止まらない）[p]

[message_chara name="mahoru" face="preawake"]
#mahoru
[voice id="v03494"]
これじゃあ、動けない。[p]
[reset_message_chara]

#jushika
[voice id="v03495"]
……どうしたの？[p]

#jushika
[voice id="v03496"]
さあ、早くこっちにいらっしゃい。メアリー。[p]

[chara_hide_all]
[charapos name="jushika" face="shot" num="1"]
[charapos name="mary" face="surprised" num="2"]

#jushika
[voice id="v03497"]
メアリーさえ、来ればこちらのものです。[p]

#jushika
[voice id="v03498"]
さようなら、皆さん。[p]

#reido
[voice id="v03499"]
富礼知さん、やめてください！[p]

#
零度警部が急いで拳銃を構える。[p]

#
しかし、朱志香はメアリーを盾にして、銃を向け続けた。[p]

#reido
[voice id="v03500"]
くっ……[p]

[gunshot fatal="true"]

#
銃声が鳴り響く。[p]

#
零度警部は銃弾を受けて倒れた。[p]

[chara_mod name="mary" face="stop"]

#
メアリーさんが何かを言っているが耳がよく聞こえない。[p]

#
それだけじゃない、さっきからずっと、頭の中でノイズが鳴り続けている。[p]

#jushika
[voice id="v03501"]
さあ、あなたたち二人とも、さようなら。[p]

#kazuto
[voice id="v03502"]
くそ、真白しっかりしろ！[p]

#
和人は真歩流をかばうようにして、朱志香から離れようとした。[p]

[gunshot fatal="true"]

#
だが、拳銃の弾丸はいとも容易く人肉を貫き、その命を砕いた。[p]

[chara_hide_all]
[bg storage="dead.jpeg"]

#mary
[voice id="v03503"]
真歩流さん！！！[p]

#jushika
[voice id="v03504"]
ふふふ、邪魔者は片付いたわ。[p]

#jushika
[voice id="v03505"]
さあ、メアリー、金庫を開けてもらうわよ。[p]

#
意識が途絶えるその瞬間、大きな音が響き、同時に私の意識も完全に吹き飛ばされた。[p]

[mask]
[cm]
[clearfix]
[chara_hide_all]
[free_layer_image]
[bg storage="dark.png"]
[mask_off]
[jump storage="title.ks"]

*stay
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03506"]
（今じゃない）[p]

#mahoru
[voice id="v03507"]
（朱志香さんの意識が私から逸れる瞬間を待つんだ）[p]
[reset_message_chara]

#jushika
[voice id="v03508"]
……どうしたの？[p]

#jushika
[voice id="v03509"]
さあ、早くこっちにいらっしゃい。メアリー。[p]

#mary
[voice id="v03510"]
わかりました……[p]

[chara_hide_all]
[charapos name="jushika" face="shot" num="2"]
[charapos name="mary" face="surprised" num="4"]

#jushika
[voice id="v03511"]
メアリーさえ、来ればこちらのものです。[p]

#jushika
[voice id="v03512"]
さようなら、皆さん。[p]

[message_chara name="reido" face="order"]

#reido
[voice id="v03513"]
富礼知さん、やめなさい！[p]

[reset_message_chara]

#
零度警部が急いで拳銃を構える。[p]

#
しかし、朱志香はメアリーを盾にして、銃を向け続けた。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03514"]
どうしよう？ このままじゃ。[p]

#mahoru
[voice id="v03515"]
そうだ、握れないなら、投げつけよう。[p]

[reset_message_chara]

#
我がことながら、とんでもない発想だと思う。[p]

#
しかし、体が先に動く体質の私は、ペンダントをポケットから取り出すと、朱志香さんに向かって投げつけた。[p]

#jushika
[voice id="v03516"]
なっ……！[p]

[gunshot]

#
銃声が鳴り響く。[p]

#
銃弾は零度警部の肩をかすめ、壁に当たった。[p]

#
零度警部はすかさず、朱志香に向かって銃を構えた。[p]

[gunshot]

#jushika
[voice id="v03517"]
うっ……！[p]

#
警部の放った弾丸は朱志香の拳銃を弾き飛ばした。[p]

#reido
[voice id="v03518"]
富礼知さん、無駄な抵抗はせずにもうやめてください！[p]

[chara_hide_all]

@bg storage="event/last_stand.png"

#jushika
[voice id="v03519"]
……あんたは、私を止められないわよ！[p]

#jushika
[voice id="v03520"]
地下に来る階段の近くには発火装置がついている。[p]

#jushika
[voice id="v03521"]
発火装置が作動すれば、上の洋館は全焼。地下にはガスが充満して皆死ぬわ！[p]

#jushika
[voice id="v03522"]
発火装置は私が持っている。嘘だと思うなら撃ってみてごらんなさい。[p]

#jushika
[voice id="v03523"]
奢禄さんから『これ以上、この館を調べるな』と警告された時に用意した、最後の手段よ。[p]

#jushika
[voice id="v03524"]
館を焼けば、地上に残した証拠は消える。地下も焼けてしまうけれどね。[p]

#
その言葉に、全員が凍りついた。[p]

#kazuto
[voice id="v03525"]
なっ……！[p]

#kazuto
[voice id="v03526"]
あんた、相当いかれてるな。[p]

#kazuto
[voice id="v03527"]
お前も死ぬんだぞ！[p]

#jushika
[voice id="v03528"]
そうね、でも私は生きるわ。私にはやらないといけないことがあるのだから。[p]

#
朱志香の親指は、発火装置のスイッチにかかったままだった。[r]
#
零度警部も和人も、一歩も動けない。[p]

#mahoru
[voice id="v03529"]
……朱志香さんのやらなきゃいけないことって何ですか？[p]

#mahoru
[voice id="v03530"]
それは人を殺してまでもやることなんですか！？[p]

#jushika
[voice id="v03531"]
……あなたには関係ないことよ。[p]

#jushika
[voice id="v03532"]
さあ、メアリー。地下室の金庫を開けなさい。そうすれば、あなただけは命を助けてあげるわ。[p]

#
メアリーは、朱志香の言葉に従うしかなかった。[p]

#mary
[voice id="v03533"]
……わかりました。[p]

#mary
[voice id="v03534"]
でも、金庫の開閉にはペンダントが必要です。[p]

#
朱志香は、メアリーの言葉に一瞬だけ、動揺したような表情を見せた。[p]

#jushika
[voice id="v03535"]
そうね、わかっているわ。[p]

#jushika
[voice id="v03536"]
真歩流さん、取ってメアリーに渡しなさい。[p]

#jushika
[voice id="v03537"]
警部と和人君はそこでおとなしくね。[p]

#jushika
[voice id="v03538"]
妙な動きをしたら、発火装置を作動させる。[p]

#
朱志香に言われるがまま先ほど投げ捨てたペンダントを拾い上げる。[p]


#mahoru
[voice id="v03539"]
（発火装置を持たれている。今度は、誰も動けない）[p]

#mahoru
[voice id="v03540"]
（でも朱志香さんは、金庫とメアリーさんに意識を向けている）[p]

#mahoru
[voice id="v03541"]
（前にも、握った時に声が聞こえた。もう一度だけ————！）[p]

#
真歩流は、拾い上げたペンダントを力の限り握りしめた。[p]

@fadeoutbgm
@bg storage="event/awake.png"
#mahoru
[voice id="v03542"]
……！[p]

#mahoru
[voice id="v03543"]
う……だめ……[p]

#
激しいノイズが走る。[p]

#
割れるように頭が痛い。[p]

#mahoru
[voice id="v03544"]
あ……ぐ……[p]

#
今にも破裂しそうな頭痛が響く中、声が滑り込んできた。[p]

#
その声はまるで怒号のように重く響く。[p]

#???
許せなかった！[p]

#???
現実を見ろ。[p]

#???
寧ろあなたは疑わしいですよ。[p]

#???
これ以上知る必要はないでしょう？[p]

#mahoru
[voice id="v03545"]
……っ。[p]

#
怒りの声、疑念の声、憎しみの声……。[p]

#???
私が信じたから、愛理が死にかけたんでしょう？[p]

#mahoru
[voice id="v03546"]
（違う……）[p]

#???
私が疑っていれば、皆助かったんじゃないの？[p]

#
——気づけば、声は私の声になっていた。[p]

#mahoru
[voice id="v03547"]
（違う、違う、違う）[p]

[voice id="v03548"]
（私はただ……）[p]

#
激しい頭痛と疑念の声に気力がなくなり、気が遠くなる。[p]

#mahoru
[voice id="v03549"]
（やっぱり、私が間違ってたの……？）[p]

[voice id="v03550"]
（地下に来なければ、こんなことには……。）[p]

#???
お姉ちゃんらしくないよ。[p]

#???
お姉ちゃんはいつだって人を信じて、自分の信じることをやってきたじゃない。[p]

#mahoru
[voice id="v03551"]
（……そうだ）[p]

#mahoru
[voice id="v03552"]
（私は……それでも）[p]

#???
そんなお姉ちゃんが好きだよ、私は。[p]

#mahoru
[voice id="v03553"]
（諦めない！）[p]

#
瞬間怨嗟の声は消えた。[p]

ノイズは消えない。頭は今も割れそうな程だ。[r]
それでも——あふれてくるものの方が、ずっと大きかった。[p]

@mask
; ==== 画面フィルター（[filter] は V5.1 以降）====
[filter layer="all" sepia=100 grayscale=0 blur=0 brightness=96 contrast=104 hue=0 saturate=90]
@bg storage="event/jushika_annna.png"
[gage_draw place="" hide_time="true"]
; --- 解除する場合 ---
@mask_off
#
温かな思い出と悲痛な悲しみの織り交ざった複雑な心。[p]

#jushika
[voice id="v03554"]
アンナ……今日は何して遊ぼうか。[p]

#
流れ込んできた思いに堪えられなくなった。[p]

#
穏やかで優しい気持ち。[p]

それを踏み壊されてしまった悲しい気持ち。[p]

#
知らず、頬を涙が伝っている。[p]

#mahoru
[voice id="v03555"]
アンナ……。[p]

#
無意識に——その名前を、こぼしてしまった。[p]

@mask
[filter layer="all" sepia=0 grayscale=0 blur=0 brightness=100 contrast=100 hue=0 saturate=100]
@bg storage="event/awake.png"
[gage_draw place="舞黒館:地下室"]
@mask_off

#jushika
[voice id="v03556"]
何を泣いて——それになぜ、娘の名前を……？[p]

#jushika
[voice id="v03557"]
答えなさい、なぜ娘の名前を知っているのか！[p]

#mahoru
[voice id="v03558"]
……。[p]

#
私は何も言えず、和人の方へ視線を向けた。[p]

#
和人は朱志香さんを見つめてハッとしたような表情を浮かべた。[p]

@bg storage="basement_room.png"
@fadeoutbgm
[chara_hide_all]
[charapos name="jushika" face="shout" num="1"]
[charapos name="kazuto"  face="thinking"  num="2"]

@playbgm storage="veiled_truth.mp3"

#kazuto
[voice id="v03559"]
……『アンナ』。[p]

#kazuto
[voice id="v03560"]
その名前を口にした時の、あんたの顔。[p]

#kazuto
[voice id="v03561"]
それで、今までの違和感が一つに繋がった。[p]

#jushika
[voice id="v03562"]
何を言っているの？[p]

#
和人は朱志香さんを見つめたまま、ゆっくりと口を開いた。[p]

#kazuto
[voice id="v03563"]
富礼知朱志香。[p]

#kazuto
[voice id="v03564"]
あんたが探していた娘は——今も、この館にいるかもしれない。[p]

#jushika
[voice id="v03565"]
……？[p]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v03566"]
小出里亜だ。[p]

[message_chara name="mahoru" face="preawake"]
#mahoru
[voice id="v03567"]
小出里亜さんが……アンナさん？[p]
[reset_message_chara]

;=========================================
; 11-1. 和人が気づいたこと
;=========================================

#jushika
[voice id="v03568"]
……は？[p]

#jushika
[voice id="v03569"]
小出里亜が……私の、アンナ……？[p]

[chara_mod name="jushika" face="shout"]
#jushika
[voice id="v03570"]
馬鹿な！　そんなはずはない！[p]

#jushika
[voice id="v03571"]
アンナは幼いころに誘拐されて——どこかへ売られたはずよ！[p]

[voice id="v03572"]
もう日本にはいないと、ずっと――。[p]

#kazuto
[voice id="v03573"]
俺も、まだ確証まではない。[p]

#kazuto
[voice id="v03574"]
だが……警部。[p]

#kazuto
[voice id="v03575"]
小出里亜の身元調査は、どこまで進んでいる？[p]

[chara_hide_all]
[charapos name="reido"  face="thinking" num="1"]
[charapos name="jushika" face="thinking" num="2"]
[charapos name="kazuto" face="thinking" num="3"]

#reido
[voice id="v03576"]
……小出里亜さんは、灰音家の養子ですが。[p]

#reido
[voice id="v03579"]
叡留久さんとのやり取りの中で、[l]

[voice id="v03580"]
——『本当の家族が近くにいる』と考えていた形跡を確認しています。[p]

#reido
[voice id="v03581"]
DNA鑑定も依頼済みです。まだ結果は出ていませんが……。[p]

#reido
[voice id="v03582"]
富礼知さん、あなたは小出里亜さんのことに気付かなかったのですか？[p]

#jushika
[voice id="v03583"]
娘はもういないと思い込んでいたから……。[p]

[voice id="v03584"]
親近感は湧いていたけれど、私の中のアンナはあの時のまま……。[p]

#reido
[voice id="v03585"]
小出里亜さんは気づいて欲しかったのかもしれません。[p]

[voice id="v03586"]
母親に自分が娘であることを。[p]

[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v03587"]
……あの時……？[p]

[mask]
[chara_hide_all]
[charapos name="jushika" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]
[filter sepia="100"]
[bg storage="kitchen.png"]
[gage_draw place="舞黒館:キッチン" hide_time="true"]
[mask_off]

#koderia
[voice id="v03588"]
朱志香様。[p]

#koderia
[voice id="v03589"]
私は……本当の家族に……会いたいです。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v03590"]
……いつか、会えるわ。[p]

#jushika
[voice id="v03591"]
きっとね……。[p]

[mask]
[chara_hide_all]
[bg storage="basement_room.png"]
[filter sepia="0"]
[gage_draw place="舞黒館:地下室"]
[show_menu]
[mask_off]

;=========================================
; 12. 朱志香の崩壊
;=========================================

[fadeoutbgm time=2000]
[playbgm storage="sad_story.mp3" loop=true]

[charapos name="jushika" face="cry" num="0"]
#
朱志香は——その場に凍りついた。[p]

#jushika
[voice id="v03592"]
そんな……。[p]

#jushika
[voice id="v03593"]
アンナが……あの子が……。[p]

#
それでも発火装置は、まだ朱志香の手の中にあった。[r]
#
誰も奪っていない。押そうと思えば、今すぐ押せる。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03594"]
小出里亜さんは……ずっと、家族を探してたんです。[p]

#mahoru
[voice id="v03595"]
すぐそばにいたのに。[p]

#mahoru
[voice id="v03596"]
朱志香さんも、小出里亜さんも——お互いに気づけなかっただけなんです。[p]
[reset_message_chara]

#jushika
[voice id="v03597"]
私は……。[p]

#jushika
[voice id="v03598"]
あの子を取り戻すために……ずっと……。[p]

#jushika
[voice id="v03599"]
なのに、あの子が隣にいたのに……私は……。[p]

#
発火装置のスイッチにかかっていた指が、震えた。[r]
#
そして——ゆっくりと離れた。[p]

#
発火装置が朱志香の手から滑り、乾いた音を立てて床へ落ちた。[p]

#reido
[voice id="v03600"]
動かないでください！[p]

#
零度警部がすぐに発火装置を蹴り離した。[r]
#
それでも朱志香は抵抗しなかった。[p]

#jushika
[voice id="v03601"]
アンナ……。[p]

#jushika
[voice id="v03602"]
ごめんなさい……。[p]

#jushika
[voice id="v03603"]
ごめんなさい……！[p]

#
朱志香は膝から崩れ落ちた。[p]

;=========================================
; 13. 和人の告白・もう一つの家族の秘密
;=========================================

[fadeoutbgm time=1000]
[playbgm storage="veiled_truth.mp3"]

[chara_hide_all]
[charapos name="jushika" face="cry" num="1"]
[charapos name="kazuto" face="thinking" num="2"]

#kazuto
[voice id="v03604"]
……富礼知。[p]

#kazuto
[voice id="v03605"]
俺からも、あんたに話しておくことがある。[p]

#jushika
[voice id="v03606"]
……？[p]

#kazuto
[voice id="v03607"]
どうして、あんたと小出里亜が俺を見て『初めて会った気がしない』と言ったのか。[p]

#kazuto
[voice id="v03608"]
その理由も、これで分かった。[p]

#kazuto
[voice id="v03609"]
俺は——あんたの夫、富礼知との間に生まれた子供だ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03610"]
和人が……朱志香さんの旦那さんの子供……？[p]
[reset_message_chara]

#kazuto
[voice id="v03611"]
俺の母は、薬の研究をしていた。[p]

#kazuto
[voice id="v03612"]
アンナを失って憔悴していた富礼知は、珍しい薬を求めて母の店へ通っていたらしい。[p]

#kazuto
[voice id="v03613"]
富礼知は娘を取り戻すには珍しい薬が必要なのだと言っていたそうだ。[p]

[voice id="v03614"]
母は富礼知を励ました。[r]
#kazuto
[voice id="v03615"]
その中で二人は一夜を共にし——俺が生まれた。[p]

#jushika
[voice id="v03616"]
……。[p]

#kazuto
[voice id="v03617"]
富礼知は、しばらく俺の存在を知らなかった。[p]

#kazuto
[voice id="v03618"]
だが後になって知ると、母に研究成果と偽聖女を渡すよう迫った。[p]

#kazuto
[voice id="v03619"]
『子供を無事に育てたければ、全てを渡して自ら死ね』——そう脅した。[p]

#kazuto
[voice id="v03620"]
母は俺の目の前で、大量の薬を飲んで自ら命を絶った。[p]

#kazuto
[voice id="v03621"]
富礼知は母の研究資料を持ち去り、俺を母の実家へ送った。[p]

#kazuto
[voice id="v03622"]
俺はその日から——いつか富礼知に復讐するつもりで生きてきた。[p]

#kazuto
[voice id="v03623"]
小出里亜は、俺を見て何かを感じたんだろう。[p]

#kazuto
[voice id="v03624"]
俺と小出里亜は——母親こそ違うが、兄妹だったんだからな。[p]

[chara_mod name="jushika" face="cry"]
#jushika
[voice id="v03625"]
……知らなかった。[p]

#jushika
[voice id="v03626"]
私は……何も……。[p]

#kazuto
[voice id="v03627"]
本当は、あんたにも全部ぶつけるつもりだった。[p]

#kazuto
[voice id="v03628"]
でも……もういい。[p]

#kazuto
[voice id="v03629"]
俺が恨んでいた相手は、あんたじゃない。[p]

#
和人は、それ以上何も言わなかった。[p]

[chara_hide_all]
[charapos name="reido" face="thinking" num="1"]
[charapos name="jushika" face="cry" num="2"]
[charapos name="kazuto" face="thinking" num="3"]
[charapos name="mary" face="thinking" num="4"]

#reido
[voice id="v03630"]
……富礼知さん。[p]

#reido
[voice id="v03631"]
あなたが宝石を求めた本当の理由も、署で伺うことになります。[p]

#jushika
[voice id="v03632"]
復讐よ。[p]

#jushika
[voice id="v03633"]
アンナを誘拐した連中への。[p]

#jushika
[voice id="v03634"]
あいつらを全員見つけ出すために、金が必要だった。[p]

#jushika
[voice id="v03635"]
それに——あいつらも、この館の地下にある何かを狙っていた。[p]

#jushika
[voice id="v03636"]
だから先に奪ってやろうと思った。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03637"]
だから、お父さんは『これ以上調べるな』って……。[p]
[reset_message_chara]

#jushika
[voice id="v03638"]
奢禄さんも、何かに気づいたのでしょうね。[p]

#jushika
[voice id="v03639"]
だから私は、最悪の場合に館ごと証拠を消せるようにした。[p]

#reido
[voice id="v03640"]
……続きは署で伺います。[p]

#reido
[voice id="v03641"]
富礼知朱志香さん。銃刀法違反および殺人未遂の現行犯で逮捕します。[p]

#
零度警部が朱志香に手錠をかけた。[r]
#
朱志香は、もう抵抗しなかった。[p]

;=========================================
; 14. 金庫と手紙
;=========================================

[chara_hide_all]
[charapos name="mary" face="normal" num="0"]

#mary
[voice id="v03642"]
真歩流さん……最後に、確かめたいことがあります。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03643"]
何ですか？[p]
[reset_message_chara]

#mary
[voice id="v03644"]
奥の金庫です。[p]

#mary
[voice id="v03645"]
祖母は、ペンダントが『金庫を起こすための証』だと言っていました。[p]

#mary
[voice id="v03646"]
でも——それだけでは開かない、とも。[p]

#
メアリーは、真歩流からペンダントを受け取った。[r]
#
金庫の中央にある小さなくぼみへ、そっとはめ込む。[p]

[playse storage="decide.mp3"]

#
小さな機械音がして、金庫の脇にある手のひら型の読み取り装置へ光が灯った。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03647"]
動いた……でも、開かない。[p]
[reset_message_chara]

#mary
[voice id="v03648"]
はい。[p]

[voice id="v03649"]
ペンダントは鍵そのものじゃない。[r]
#mary
[voice id="v03650"]
本当の持ち主を確かめるための装置を起動するものなんです。[p]

#mary
[voice id="v03651"]
真歩流さん。そこへ手を置いてみてください。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03652"]
私が……？[p]
[reset_message_chara]

#mary
[voice id="v03653"]
お願いします。[p]

#
真歩流は戸惑いながらも、読み取り装置へ手を置いた。[p]

一秒。[r]
二秒。[r]

#
そして——。[p]

[playse storage="door_open.mp3"]

@chara_hide_all
@bg storage="event/true_treasure.png"

#
カチリ、と——重い金庫の扉が開いた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03654"]
……どうして、私の手で？[p]
[reset_message_chara]

#mary
[voice id="v03655"]
やっぱり……。[p]

#
金庫の中には、高価な宝石類と——一通の古い手紙が入っていた。[p]

#mary
[voice id="v03656"]
祖母から聞いていた話があります。[p]

#mary
[voice id="v03657"]
戦争で引き裂かれた、日本人の少女とイギリス人の青年の話です。[p]

#mary
[voice id="v03658"]
青年は帰国する前に、少女と——二人の間に生まれた子供、その子孫のために、この金庫を残した。[p]

#mary
[voice id="v03659"]
ペンダントを受け継いだ者が装置を起動し、少女の直系の血を引く者が手を置く。[p]

#mary
[voice id="v03660"]
その二つが揃った時だけ、金庫が開く。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03661"]
じゃあ……私が開けられたってことは……。[p]
[reset_message_chara]

#mary
[voice id="v03662"]
中の手紙を見てください。[p]

#
真歩流は古い封筒を手に取り、慎重に開いた。[p]

#
I will surely return to Japan someday.[r]
#
So I want you to stay safe and well until then.[p]
I know we'll meet again. I know it.[r]
#
So until that day... stay well, always...[p]

#
——日本語に訳すと、こう書いてある。[p]

#
僕は必ずいつか日本に戻ってくる。[r]
#
だから、君も必ず元気でいてほしい。[p]
きっと、きっとまた会える。[r]
#
だから——その日まで……いつまでも、元気に……[p]

#
そして——差出人と宛名に、真歩流の視線が釘付けになった。[p]

#
アーサー・キングより　真白結月へ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03663"]
真白……。[p]
[reset_message_chara]

#mary
[voice id="v03664"]
そうです。[p]

#mary
[voice id="v03665"]
真歩流さんと愛理さんは——かつてこの館で恋をした、日本人の少女とイギリス人の青年の末裔なんです。[p]

#mary
[voice id="v03666"]
そして私は、キング家の側からその血を受け継いでいる。[p]

#mary
[voice id="v03667"]
真歩流さん。[p]

#mary
[voice id="v03668"]
あなたと私は——遠い親戚なんです。[p]

#
事件のすべてが終わった後で、最後に残ったのは、誰かを追い詰めるための真実ではなかった。[p]
#
長い戦争と時間を越えて、離れていた二つの家族をもう一度結ぶための真実だった。[p]

#
誰も言葉を発せなかった。[r]
#
ただ——真歩流だけが、静かに手紙を胸に抱きしめていた。[p]

#
もう、ここにはいない遠い存在へと思いを馳せながら……。[p]

;=========================================
; 15. ダイジェスト
;=========================================

; ここから後日譚。場所名と時刻のプレートは出さない
[hud_hide]

[fadeoutbgm time=2000]

[mask time=2000]
[chara_hide_all]
[free_layer_image]
[layopt layer="message0" visible="true"]
[bg storage="dark.png" time=0]
[mask_off time=2000]

#
事件の後、珠璃さんは殺人と殺人未遂の罪を認め、服役することになった。[p]

[charapos name="juri" face="cry" num="0"]

#juri
[voice id="v03669"]
……罪を、償います。[p]

#juri
[voice id="v03670"]
いつかまた——人を心から信じられるように……[p]

[chara_hide_all]

#
朱志香さんは殺人未遂と銃刀法違反などの罪に問われ、実刑判決を受けた。[p]

#
そして愛理は、救急車で病院へ搬送された。[r]
#
和人の処置が功を奏し——愛理はすぐに回復した。[p]

[mask]
[charapos name="airi" face="smile" num="0"]
[bg storage="hospital.png"]
[mask_off]

#airi
[voice id="v03671"]
お姉ちゃん！　心配かけてごめんね！[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03672"]
愛理！ 元気になってよかった……！[p]
[reset_message_chara]

[chara_hide_all]

#
舞黒館の宿泊イベントから——一週間後。[p]


;=========================================
; 16. 空港・イギリスへ
;=========================================

[mask time=2000]
[bg storage="airport.png" time=0]
[mask_off time=2000]

[charapos name="mary" face="smile" num="1"]
[charapos name="airi"    face="smile" num="2"]

#mary
[voice id="v03673"]
では——出発しましょう。[p]

#airi
[voice id="v03674"]
お姉ちゃん、早く早く！[p]

#airi
[voice id="v03675"]
また、その格好で行くの？[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03676"]
もちろんよ！[p]

#mahoru
[voice id="v03677"]
今度は本家本元、探偵の国だからね！[p]
[reset_message_chara]

#
真歩流、愛理、メアリーの三人は——飛行機に乗り込んだ。[r]
#
行き先は、イギリス。[p]

[chara_hide_all]


;=========================================
; 17. イギリス・メアリーの実家
;=========================================

[playbgm storage="Eternal_Peace.mp3" loop=true]

[mask time=2000]
[bg storage="england_living.png" time=0]
[mask_off time=2000]

#
イギリス——メアリーの実家を訪ねると、そこには見覚えのある後ろ姿があった。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03678"]
お……お父さん……！？[p]
[reset_message_chara]

[chara_mod name="sharoku" face=""]
#sharoku
[voice id="v03679"]
真歩流、愛理……！[p]

[mask time=2000]
[bg storage="event/resume.png" time=0]
[mask_off time=2000]

#sharoku
[voice id="v03680"]
二人とも心配をかけてすまなかった。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03681"]
お父さん……！[p]

#mahoru
[voice id="v03682"]
すごく心配したんだから！[p]

[reset_message_chara]

[message_chara name="airi" face="cry"]
#airi
[voice id="v03683"]
もう、もう……！[p]

#airi
[voice id="v03684"]
お母さんも怒っているんだからね！[p]

[reset_message_chara]

#sharoku
[voice id="v03685"]
ああ、お母さんにも連絡をしたよ。ものすごく怒られたよ。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03686"]
それはそうよ……！[p]

#mahoru
[voice id="v03687"]
お父さん！　どうして一人でイギリスに……！[p]

#mahoru
[voice id="v03688"]
ちゃんと説明して！[p]

[reset_message_chara]


#sharoku
[voice id="v03689"]
ああ、全部話す。でも——その前に二人に会わせたい人がいるんだ。[p]

[mask time=2000]
[bg storage="england_living.png" time=0]
[mask_off time=2000]

#
奢禄の隣には、白髪の上品な老婦人が立っていた。[r]
#
穏やかな青い目が、真歩流と愛理をしっかりと見つめた。[p]

[chara_hide_all]
[charapos name="chroe" face="normal" num="1"]
[charapos name="sharoku" face="normal" num="2"]

#chroe
……懐かしい。[p]

#chroe
数十年ぶりに——結月に会えたようだわ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03690"]
……あなたは？[p]
[reset_message_chara]

#chroe
クロエ・キングよ。メアリーの祖母です。[p]

[charapos name="mary" face="smile" num="3"]

#mary
[voice id="v03691"]
おばあさま……[p]

#chroe
メアリー、よくここまで頑張りましたね。[p]

#
クロエはそっと、メアリーの手を取った。[p]


;=========================================
; 18. 奢禄の説明・書類の秘密
;=========================================

[chara_hide_all]
[charapos name="sharoku" face="" num="0"]

#sharoku
[voice id="v03692"]
真歩流、舞黒館の地下に金庫があっただろう。中は見たかい？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v03693"]
……うん、結月とアーサーという人の手紙があったよ。[p]

#mahoru
[voice id="v03694"]
あと、宝石もあった。そのままにしてきたけどね。[p]

#mahoru
[voice id="v03759"]
だけどお父さん、金庫はペンダントが無ければ、開かないはずじゃ。[p]
[reset_message_chara]

#sharoku
[voice id="v03760"]
真白の家にもペンダントがあるんだ。[p]

#sharoku
[voice id="v03761"]
私達のおじいさんが、アーサー・キングからもらったものでね。[p]

#mahoru
[voice id="v03762"]
じゃあ、お父さんは全部知っていたの？[p]

#sharoku
[voice id="v03763"]
いや、私もほとんど知らなかった。[p]

#sharoku
[voice id="v03764"]
けれど、舞黒館に行くときは持っておくようにとペンダントと共に父からもらったんだ。[p]

#sharoku
[voice id="v03765"]
何のことかはわからなかったが。[p]

#mahoru
[voice id="v03695"]
お父さんはどうして途中で調査をやめてしまったの？[p]
[reset_message_chara]

#sharoku
[voice id="v03696"]
……ああ、それが重要なことなんだ。[p]

#sharoku
[voice id="v03697"]
地下室の金庫にはとある書類があったんだ。私はその書類の危険性を瞬時に察知した。[p]

[message_chara name="airi" face="thinking"]
#airi
[voice id="v03698"]
書類？[p]

#airi
[voice id="v03699"]
そんな過去の書類に危険なものとかあるの？[p]

[reset_message_chara]

#sharoku
[voice id="v03700"]
不思議に思うのも無理はないさ。[p]

#sharoku
[voice id="v03701"]
なんせ、現代の技術でも不可能とされてきたことの資料だからね。[p]

[message_chara name="airi" face="thinking"]
#airi
[voice id="v03702"]
現代でも不可能な技術……？[p]

[reset_message_chara]

#sharoku
[voice id="v03703"]
だから、朱志香さんにばれないよう、こっそりと書類を取って、調査を止めるように伝えたんだ。[p]

#sharoku
[voice id="v03704"]
ただ、この書類をどうするかについては悩んだ。[p]

#sharoku
[voice id="v03705"]
なんせ、その内容は非常に危険なものだったから。[p]

#sharoku
[voice id="v03706"]
そこで内容について知る人物に、アドバイスをもらおうと思い、調べたらクロエさんにたどり着いたんだ。[p]

#sharoku
[voice id="v03707"]
二人とお母さんには本当に心配をかけてすまなかったと思っている。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v03708"]
その書類には……いったい何が書いてあったの？[p]
[reset_message_chara]

#sharoku
[voice id="v03709"]
ああ、それを話す前にクロエさんから話を聞いた方がわかりやすいだろうね。[p]

[chara_hide_all]
[charapos name="mary" face="normal" num="1"]
[charapos name="chroe" face="normal" num="2"]

#chroe
メアリー……あなたにあげたペンダントはどうしたの？[p]

#mary
[voice id="v03710"]
真歩流さんに預かってもらっています——[p]

#
メアリーは真歩流を見た。[p]

#chroe
真歩流さん、そのペンダントを持っていた時に……何か不思議なことはなかったかしら？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v03711"]
頭にノイズみたいなのが走って……声が聞こえたんです。人が考えているような——思考が、流れ込んでくるような感覚で。[p]
[reset_message_chara]

#chroe
そう。それは——脳波で人の感情や思考を読み取る力が、あなたにあるからなのよ。[p]

#chroe
真白家の血筋は、代々その力を潜在的に持っているの。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03712"]
え……？　お父さんも、愛理も？[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="sharoku" face="normal" num="1"]
[charapos name="airi"   face="normal" num="2"]
[charapos name="chroe" face="normal" num="4"]

#sharoku
[voice id="v03713"]
私にはない……[p]

#airi
[voice id="v03714"]
私も、そんな感覚は全然なかったわ。[p]

#chroe
その力は——幼少の頃に、強力な電波のような、脳に強く影響を与える外的要因がないと発現しないの。[p]

#chroe
あなたにはそれがあったのでしょうね。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03715"]
え……？ 思い出せないけど、そんなことあったのかなあ。[p]
[reset_message_chara]

[message_chara name="airi" face="normal"]
#airi
[voice id="v03716"]
食い入るように、金魚のアニメを見ていたから、それじゃないの。[p]

#airi
[voice id="v03717"]
毎日毎日ずっと見てたもんね。飽きもせずに。[p]
[reset_message_chara]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03718"]
いいじゃない！ それに、それは関係ないわよ！[p]
[reset_message_chara]

#chroe
フフフ、仲がいいのね、二人は。[p]

#chroe
話を戻しましょう。[p]

#chroe
そのペンダントには特別な電波を流す装置が埋め込まれていて、握ると対象者の脳内に電波が走る。[p]

#chroe
特殊な脳を持つ人物を特定するために作られたいわゆる判別装置のようなものね。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03719"]
それじゃあ、メアリーさんは私が親戚だって気づいていたの？[p]
[reset_message_chara]

[charapos name="mary" face="smile" num="3"]

#mary
[voice id="v03720"]
確信はなかったけど、苗字は真白で、舞黒館で出会ったでしょう？[p]

#mary
[voice id="v03721"]
偶然とは考えられなかったから。[p]

#chroe
話を戻すと、そのペンダントは脳波をコントロールできる人の脳を活性化させる効果があるの。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v03722"]
……つまり私は、ペンダントのおかげで人の考えを一時的に読み取ることができた、ということ？[p]
[reset_message_chara]

#chroe
そうよ、真歩流さん。あなたにはその力がある。[p]

[chara_hide_all]
[charapos name="sharoku" face="" num="0"]

#sharoku
[voice id="v03723"]
そして舞黒館にあった書類には——思考を読み取る力のこと、それから研究の詳細が記されていたんだよ。[p]

#sharoku
[voice id="v03724"]
人の思考を読む技術が確立されたら大変なことになる。[p]

#sharoku
[voice id="v03725"]
だからこれ以上調べてはいけないと思って、調査を止めたんだ。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v03726"]
そういうことだったんだ……[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="airi" face="thinking" num="1"]
[charapos name="chroe" face="normal" num="2"]

#airi
[voice id="v03727"]
あの……一つ聞いてもいいですか、クロエさん。[p]

#chroe
なんでしょう？[p]

#airi
[voice id="v03728"]
どうしてクロエさんが……そんなことを知っているんですか？[p]

#chroe
そうね、今から80年以上前のことよ……[p]

[fadeoutbgm]

;=========================================
; 19. クロエの告白
;=========================================
[mask]
[filter sepia="100"]
[bg storage="house_front.png"]
[playbgm storage="WhispersintheStardust_verArrange.mp3"]
[chara_hide_all]
[mask_off]

#chroe

#chroe
私はかつて兄アーサーと共に外交官である両親に連れられて日本へ行った。[p]

#chroe
兄も両親も知らなかったけれど——私はイギリス政府付きの諜報員だった。[p]

#chroe
私の任務は、あなたたちのお父様が持っている機密書類を回収することだったの。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03729"]
諜報員……？[p]
[reset_message_chara]

#chroe
ええ、イギリス政府は、機密書類を得ることで、人を超越する研究を進めようとしていたの。[p]

#chroe
思考が読めれば戦争も交渉事も有利に進められる。[p]

#chroe
戦争で疲弊し国力が落ちていた当時のイギリス政府からすれば、藁にも縋る思いだったのよ。[p]

#airi
[voice id="v03730"]
……確かに人の考えが読めたら途方もない力が得られるでしょうね。[p]

#chroe
ええ、政府は力が欲しかった。絶対的な権力と安定した治世を行えると考えていたんでしょう。[p]

#chroe
でも、私にはできなかった。[p]

#chroe
兄アーサーが結月と恋人になり、私もまた結月の親友となり、この関係を崩したくなかった。[p]

#chroe
そうこうしているうちに、第二次世界大戦が始まり、イギリス本国へと戻ってきて、戦争の終結を待った。[p]

#chroe
そして——戦争が終わった時、政府は友人であり義姉でもある結月を、存在ごと抹殺しようとした。[p]

#chroe
日本から来た結月たちの乗った船を、誤射と偽って撃沈させたのよ。[p]

#chroe
兄のアーサーは抗議運動を起こして、政治犯として拘束されて獄中死した。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03731"]
そんな……そんなのってないよ！[p]
[reset_message_chara]

#chroe
本当にそうね。[p]

#chroe
私も、その出来事を境に政府を見限った。[p]

#chroe
日本に残された結月とアーサーの子供——その子孫たちが無事に暮らせるように、あの手この手で政府の目を欺いたわ。[p]

#chroe
そして、いつか必ず結月と兄の子孫たちと連絡を取ろうと、思っていたの。[p]

#chroe
数十年かかったけれど……ようやく、ようやく……それが叶ったわ。[p]

#chroe
会えて嬉しいわよ——真歩流さん、愛理さん。[p]

[mask]
[bg storage="england_living.png"]
[filter sepia="0"]
[mask_off]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03732"]
私も……会えて本当に嬉しいです、クロエさん。[p]
[reset_message_chara]

;-----------------------------------------
; 古い写真を持っていると見られる特別な一枚絵
;-----------------------------------------
[if exp="f.status['old_photo'] && f.status['old_photo'].owned == true"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03733"]
あの……クロエさん。これ、洋館で見つけたんです。[p]
[reset_message_chara]

#
真歩流は、鞄からそっと一枚の古い写真を取り出した。[r]
#
セピア色の紙面には、洋館の広間に並んだ人々が写っている。[p]

[mask time=1200]
[bg storage="event/old_photo.png" time=0]
[mask_off time=1200]

#chroe
……まあ。[p]

#chroe
これは——1935年の、あの日の写真だわ。[p]

#chroe
舞黒さんと一緒に結月たちと撮ったのよ。一枚だけ、と。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03734"]
じゃあ、この中に……[p]
[reset_message_chara]

#chroe
ええ。兄のアーサーも、結月も、私もいるわ。[p]

#chroe
舞黒さんの右にいるのが兄、左にいるのが結月よ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03735"]
この人が結月おばあちゃん……[p]
[reset_message_chara]


#
クロエは棚から一冊の古いアルバムを取り出し、テーブルの上で開いた。[p]

#
空白のページばかりだった。[p]

[mask time=1200]
[bg storage="event/photo_album.png" time=0]
[mask_off time=1200]

#chroe
戦争が始まる直前に日本での思い出は全て処分されてしまった。[p]

#chroe
ずっと——もう一度会いたかった……[p]

#
クロエは真歩流から受け取った写真を、アルバムの空いた一枠にそっと収めた。[p]

#chroe
ありがとう、真歩流さん。[p]

[message_chara name="airi" face="smile"]
#airi
[voice id="v03736"]
……八十年越しの、忘れ物だね。[p]
[reset_message_chara]

[mask time=1200]
[bg storage="england_living.png" time=0]
[mask_off time=1200]

[achieve id="old_photo_ev"]

[endif]

[charapos name="airi" face="smile" num="0"]

#airi
[voice id="v03737"]
私たちの家族には……こんな壮大な物語があったんだね、お姉ちゃん。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03738"]
うん。それに今は本当に嬉しい。[p]

#mahoru
[voice id="v03739"]
また、こうして家族全員で会えたんだから……[p]
[reset_message_chara]

#
上を見上げると、イギリスの柔らかい青い空が広がっていた。[p]

[chara_hide_all]


;=========================================
; 20. 日本へ帰国・和人との再会
;=========================================

[fadeoutbgm time=2000]

[mask time=2000]
[bg storage="park.png" time=0]
[mask_off time=2000]

#
日本へ帰ってから——しばらく後。[p]

[charapos name="kazuto" face="normal" num="0"]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03740"]
和人！　久しぶり。[p]
[reset_message_chara]

#kazuto
[voice id="v03741"]
ああ。イギリスはどうだった。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03742"]
すごかったよ。色々あって……話すと長くなるんだけど。[p]
[reset_message_chara]

#kazuto
[voice id="v03743"]
そうか。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03744"]
和人、改めてありがとう。愛理を助けてくれて。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03745"]
当然のことをしたまでだ。礼はいらない。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03746"]
和人と会えて、良かった。本当に。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03747"]
……俺もだ。[p]

#
和人が、少し照れたような顔をした。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03748"]
あのね、和人——少しの間、また日本を離れてイギリスに行くことになるんだけど。[p]
[reset_message_chara]

#kazuto
[voice id="v03749"]
そうか。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03750"]
うん……なんか、寂しいな、って思って。[p]
[reset_message_chara]

#
真歩流が帰ろうと踵を返した——その時。[p]

#kazuto
[voice id="v03751"]
——真歩流。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03752"]
……え？[p]
[reset_message_chara]

#
和人は今まで「真白」と呼んでいた。[r]
#
名前で、呼んでくれた——初めて。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03753"]
（……なんで、こんなにうれしいんだろう）[p]
[reset_message_chara]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v03754"]
母さんの墓参りに行くんだが……一緒に来るか？[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03755"]
……うん。一緒に行く！[p]
[reset_message_chara]

#
二人は並んで、歩き始めた。[r]
#
秋の光が柔らかく降り注いで——遠く、海が光っていた。[p]

[chara_hide_all]

#
一つの物語が終わるとき、また新しい物語が始まる。[p]

#
人生という名の物語はこれからも続いていくのだ。[p]

[charapos name="kazuto" face="normal" num="0"]

#kazuto
[voice id="v03756"]
真歩流！[p]

#kazuto
[voice id="v03757"]
俺は……[p]

[pre_resonance]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03758"]
……え、えええええ！[p]
[reset_message_chara]

[eval exp="f.badend = 0"]
[eval exp="f.normalend = 0"]
[eval exp="f.trueend = 1"]
[jump storage="system/ending_credit.ks" target="*ending_credits"]
