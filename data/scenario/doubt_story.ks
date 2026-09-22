; ダウト ミニゲーム 物語パート

;--------------------------------------------------
; メッセージウィンドウの準備
;--------------------------------------------------
*setup
[bg storage="doubt/bg-salon.png" time="400"]
[deffont size="38" color="0xf6efe0" face="Zen Maru Gothic"]
[resetfont]
[layopt layer="message0" visible="true"]
; 物語を飛ばすボタンを出す（押すとスキップに入り、*finish の [skipstop] で止まる）
[doubt_skip show="true"]
[return]

*finish
[doubt_skip show="false"]
[skipstop]
[cm]
[layopt layer="message0" visible="false"]
[freeimage layer="base" time="300"]
[return]

;--------------------------------------------------
*prologue
@stopbgm
@bg storage="reference_room.png"
@charapos name="airi" num=0 face="smile"
@message_chara name="mahoru" face="smile"

#mahoru
ここにお父さんの手掛かりがあるといいんだけどなあ。[p]

#airi
きっとあるよ。[p]

私はこっちを見るから、お姉ちゃんはこのあたりを探して。[p]

#mahoru
うん、わかった。[p]

@chara_hide_all

#mahoru
じゃあ、早速このあたりを……。[p]

うん？[p]

何だろう、ここの本全部繋がっているみたい。[p]

#airi
どうかしたの、お姉ちゃん？[p]

#mahoru
なんか本がつながっているみたいで……。[p]

@charapos name="airi" num=0 face="smile"

#airi
どれどれ？[p]

#mahoru
ここ。[p]

#
がシャン。[p]

#mahoru
あ……。[p]

#
愛理に返事をしたときに、本棚の本を押し込んでしまった。[p]

瞬間、本棚が傾き、そのまま本棚と一緒に私と愛理は落下していった。[p]

@mask
@chara_hide_all
@reset_message_chara
[call target="*setup"]
@playbgm storage="talk.mp3"
@mask_off
@message_chara name="mahoru" num=0 face="normal"

#mahoru
うん……。ここは、一体どこなの？[p]

確か、愛理と一緒に調査をしていて、資料室にいたはずだけど。[p]

それに、この体……。[p]

愛理と同じナイスバディに……。[p]

#???
ようこそ、お客人。今宵は館の者が総出で、君をもてなそう。[p]

@charapos name="maicro" num=0 face="normal"

#mahoru
え……？　誰？[p]

#maicro
私は舞黒邦夢。館の主だ。[p]

#mahoru
舞黒邦夢……。[p]

あなたは既に故人のはずじゃ……。どうして、ここにいるの？[p]

#maicro
さあてね。[p]

まあ、一時の白昼夢のようなものさ。[p]

#mahoru
白昼夢……。[p]

いや、そんなことはいいの。[p]

愛理は……、金髪の女の子はいなかった？[p]

#maicro
そうか、彼女は君の妹だったか。[p]

残念だが、彼女は、この館に取り込まれた。[p]

#mahoru
取り込まれた？[p]

どういう意味？[p]

#maicro
彼女は敗北したのさ。[p]

この舞黒空間でね。[p]

#mahoru
何を意味不明なことを……。[p]

妹を返して、さもないと……。[p]

#maicro
ふふふ、勿論良いともさ。[p]

君が最後まで勝ち残れば、妹は帰ってくる。[p]

#mahoru
勝つ？[p]

#maicro
簡単なゲームさ。[p]

#maicro
ダウトを知っているだろう？[p]

#maicro
君にはダウトで勝負をしてもらう。[p]

#maicro
嘘を見抜き先に上がることができれば君の勝ち。見抜けなければ負けだ。[p]

#maicro
勝負は3人のバトルロワイアル。[p]

#maicro
誰かが先に上がれば、君の負けだ。[p]

#mahoru
いいわ。愛理を助けるためにも絶対に負けられないわ。[p]

それに、探偵に嘘くらべを挑むなんて、いい度胸ね。[p]

#mahoru
やってやろうじゃないの！[p]

#maicro
ふふ、いい心意気だ。[p]

それでは、始めようか。[p]

さあ、最初の君の相手は愛しの妹、愛理だ。[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

;--------------------------------------------------
*stage0
[call target="*setup"]
@charapos name="airi" num=1 face="normal"
@charapos name="kazuto" num=2 face="normal"

#
最初の卓では、愛理と和人が待っていた。[p]

@message_chara name="mahoru" num=0 face="normal"

#mahoru
愛理！[p]

良かった無事だったのね。[p]

#airi
お姉ちゃん、手加減しないからね！[p]

悪いけど、圧倒しちゃうんだから。[p]

#kazuto
やれやれ、そういうわけだからな、加減はしない。[p]

#mahoru
和人まで……。[p]

#mahoru
二人とも、本当に正気を失っているのね。[p]

いいわ。勝って二人の正気を取り戻させる。[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

*stage1
[call target="*setup"]
@playbgm storage="talk.mp3"
#
二つ目の卓。甘い香りと、鋭い視線。[p]

@charapos name="mary" num=1 face="normal"
@charapos name="reido" num=2 face="normal"

#mary
ああ、いいわ。[p]

この至高の香りが、私の心を落ち着かせてくれるの。[p]

@message_chara name="mahoru" num=0 face="normal"

#mahoru
メアリーさん、正気を取り戻して下さい。[p]

#mary
私は正気よ。[p]

世界を私の香りで染め上げるのが、私の夢。[p]

ふふふ、私の香りに酔いしれなさい。[p]

#reido
取り調べの時間です。[p]

う、やっぱりお酒など……。[p]

#mahoru
誰だっけこの人……。[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

*stage2
[call target="*setup"]
@playbgm storage="talk.mp3"
#
三つ目の卓では、珠璃と叡留久が札を揃えていた。[p]

@charapos name="eruku" num=1 face="normal"
@charapos name="juri" num=2 face="normal"

#eruku
さて、いい取引をしようか。[p]

最も勝つのは僕たちだけどね。[p]

#juri
ふふ、そうね。[p]

このエレガント夫婦の前には、誰も勝てないわ。[p]

真歩流さん、残念だけどあなたの命運は尽きたわ。[p]

@message_chara name="mahoru" num=0 face="normal"

#mahoru
何という圧倒的な勝ち組オーラなの……。[p]

このプレッシャーに耐えなければ……。[p]

#juri
ところで叡留久、さっきスマホがなっていたようだけど。[p]

#eruku
ああ、仕事仲間からの連絡だよ。[p]

#juri
なら、いいわ。[p]

#eruku
ああ、問題ないだろう？[p]

#mahoru
……？[p]

何のことかわからないけれど、いざ勝負！[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

*stage3
[call target="*setup"]
@playbgm storage="talk.mp3"

@charapos name="koderia" num=1 face="normal"
@charapos name="jushika" num=2 face="normal"

#
四つ目の卓。朱志香は、小出里亜の隣から一歩も動かない。[p]

#koderia
あら、真白様、まだ勝ち残っていたんですね。[p]

ふふ、お手柔らかにお願いしますね。[p]

#jushika
……真歩流さん。[p]

私達の前では、嘘は通用しませんよ。[p]

一瞬でけりをつけましょう。[p]

@message_chara name="mahoru" num=0 face="normal"

#mahoru
なんて迫力なの……。[p]

この圧倒的オーラに負けちゃいけない。[p]

#jushika
さあ、私達の手のひらで踊っていただきましょう。[p]

#koderia
逃れられますかね。私達から。[p]

#mahoru
この二人、何か企んでいるわね……。[p]

#mahoru
でも、負けないわ。[p]

#koderia
ふふ、真白様。[p]

やめてと言っても、私達は止まりませんよ。[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

*stage4
[call target="*setup"]
@playbgm storage="talk.mp3"

#
最後の卓。そこに座っていたのは――[p]

@charapos name="mahoru_awake" num=1 face="normal"
@charapos name="maicro" num=2 face="normal"

@message_chara name="mahoru" num=0 face="normal"

#mahoru
……待って。どうして私が、もう一人いるの！？[p]

#maicro
驚いたかね。今宵最後のもてなしだ。[p]

#mahoru_awake
あなた如きじゃ、相手にならないけど、せっかくだから、私が相手をしてあげるわ。[p]

あなたに愛理は救えない。[p]

#mahoru
……あなたは、私の分身……。[p]

#mahoru_awake
何を言っているの？[p]

私が本当の真白真歩流よ……。[p]

#maicro
ふふ、そうだね。[p]

君こそが本物。[p]

#mahoru
違う！！[p]

私が本物よ！！[p]

#mahoru_awake
いいわ、決着をつけましょう。[p]

どちらが本物か、嘘を見抜いた方が勝ちよ。[p]

#mahoru
この一戦に全てをかけるわ。[p]

@chara_hide_all
@reset_message_chara

#
もう一人の真歩流は、何も言わずに微笑んだ。ものすごく、強い。それだけは分かった。[p]
[call target="*finish"]
[return]

;--------------------------------------------------
; 隠し戦（出現条件を満たした時だけ）。二人の名前は出さない
*stage5
[call target="*setup"]
@playbgm storage="secret_boss.mp3"

#
最後の卓を片付けた時、まだ誰かが座っていることに気づいた。[p]

@charapos name="yuduki" num=1 face="normal"
@charapos name="arther" num=2 face="normal"

@message_chara name="mahoru" num=0 face="normal"

#mahoru
……あなたたちは？[p]

#yuduki
やっと来た！　ずっと待ってたんだから。[p]

#arther
失礼、招かれた客ではありません。勝手に混ざっているだけなんだ。[p]

#mahoru
勝手に……？[p]

#yuduki
だって、面白そうな勝負をしてるじゃない。[p]

私も混ぜてってお願いしたんだけど、舞黒さんに断られちゃって。[p]

君たちの出番はここじゃないってさ。[p]

#arther
それで、勝ち残った方を待っていた次第なんだ。[p]

最も来るかどうかはわからなかったけどね。[p]

#mahoru
私、もう終わったつもりだったんだけど……。[p]

#yuduki
そう言わないで。ここまで来た人と戦ってみたかったの。[p]

ねえ、お願い私と戦って！[p]

#arther
一つだけ言っておくと。彼女は手加減という言葉を知らないからな。[p]

そして相手にも同じものを求める。[p]

全力勝負じゃないと嫌がるんだ。[p]

#yuduki
当たり前でしょ。手加減されて勝っても、嬉しくないもん。[p]

#mahoru
……そういうの、嫌いじゃないわ。[p]

#mahoru
いいわ。最後に、もう一勝負。[p]

#yuduki
やった！　じゃあ、始めましょ。[p]

#arther
では、公正に。……そのうえで、遠慮なく。[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

;--------------------------------------------------
; 隠し戦に勝利した時だけ入る会話
*hidden_win
[call target="*setup"]

@stopbgm
@playbgm storage="talk.mp3"

@message_chara name="mahoru" num=0 face="normal"
@charapos name="yuduki" num=1 face="normal"
@charapos name="arther" num=2 face="normal"

#yuduki
……負けた。[p]

#mahoru
勝った……のよね？[p]

#yuduki
うん。完敗！[p]

でも、すっごく楽しかった！[p]

#arther
ここまで勝ち残っただけはある。[p]

最後まで、こちらの嘘を読むのをやめなかった。[p]

#mahoru
あなたたちも、とんでもなく強かったわよ。[p]

#yuduki
だから面白かったんじゃない。[p]

次は絶対に負けないから。[p]

#arther
次か……。[p]

君は次を信じているのか？[p]

#yuduki
もちろん！　一回勝ったくらいで終わりなんてつまらないでしょ？[p]

#mahoru
ふふ……望むところよ。[p]

#arther
では、その時まで。[p]

#yuduki
また遊ぼうね、真歩流！[p]

@chara_hide_all

#mahoru
何だろう。[p]

初めて会った気がしないのは……。[p]

@reset_message_chara

[call target="*finish"]
[return]

;--------------------------------------------------
; 出現条件を満たさなかった時。誰かがいたことだけを残して終わる
*no_hidden
[call target="*setup"]

#
最後の卓を片付けた時、卓の隅に、誰かが座っていた跡があった。[p]

#
札は伏せられたまま、二人分。[p]

#???
なんだ、私も遊べると思ったのになあ。[p]

#???
どうやら、時間が足りなかったみたいだな。[p]

#???
次に来たら、戦えるといいな。私が圧勝して見せるわ！[p]

#???
相変わらず強気だな。まあ、それがいいところだが。[p]

#mahoru
……今の声、誰？[p]

#
振り返っても、そこには誰もいなかった。[p]

@chara_hide_all
@reset_message_chara

[call target="*finish"]
[return]

;--------------------------------------------------
*clear
[call target="*setup"]

@playbgm storage="win.mp3"

@message_chara name="mahoru" num=0 face="normal"

#mahoru
か、勝ったの……。[p]

@charapos name="mahoru_awake" num=1 face="normal"
@charapos name="maicro" num=2 face="normal"

#maicro
見事だ。[p]

いい読みをしている。[p]

#mahoru_awake
……。[p]

#mahoru
あなたは凄く強かった。[p]

何度も勝てないかもって思った。[p]

#mahoru_awake
何故……。[p]

何故、あなたはそこまで戦えるの？[p]

#mahoru
え？[p]

#mahoru_awake
私はあなたよりも強い。[p]

なのに、どうして、私を乗り越えられるの？[p]

#mahoru
あなたにもわかっているでしょう？[p]

#mahoru_awake
……？[p]

#mahoru
愛理の為よ。[p]

大切な家族の為なら、どんな困難も乗り越えられるわ。[p]

#mahoru_awake
ああ……。[p]

そうか……。[p]

そうだったわね。[p]

#maicro
さて、名残惜しいが終幕だ。[p]

私達が敗れたことで、この舞黒空間が崩壊する。[p]

#mahoru
どうすればいいんですか？[p]

#maicro
何もせずとも、気づいたら戻っているさ。[p]

#maicro
安心したまえ、君の妹や館の客達も一緒に元の洋館へと戻っていくさ。[p]

#mahoru
良かった。[p]

#mahoru_awake
最後にわたしに選別をあげる。[p]

#mahoru
え……？[p]

#mahoru_awake
いつか、絶望的な状況になることがあるかもしれない。[p]

たとえ、どんなに困難な状況でもあきらめずに、真実を追求し続けなさい。[p]

そうすれば、本当に大切な人を助けることができる。[p]

その先にどんな運命が待っていたとしても。[p]

#mahoru
……うん、わかった。[p]

#maicro
それじゃあ、またどこかで会おう。[p]

さらばだ。[p]

@mask
@chara_hide_all
@reset_message_chara
@bg storage="reference_room.png"
@message_chara name="mahoru" face="smile"
@fadeoutbgm
@mask_off

#mahoru
ここは……。[p]

#
気が付くと私は資料室に立っていた。[p]

崩れたはずの本棚も何事もなく、そこにあった。[p]

#airi
もう、お姉ちゃん聞いているの？[p]

@charapos name=airi num=0 face=anger

#airi
ぼーっとしていないで探してよ！[p]

#mahoru
愛理！！[p]

元に戻ったのね。[p]

#airi
何言っているのお姉ちゃん。[p]

あ、さては資料探しながら、うたた寝してたんでしょう？[p]

#mahoru
うたた寝……。[p]

うん、そうかもしれない。[p]

でも、愛理がいてよかった。[p]

私の大切な妹。[p]

@chara_mod name="airi" face="surprised"

#airi
お姉ちゃん……急にどうしたの。[p]

#mahoru
ううん。[p]

何でもないよ。[p]

さあ、お父さんの手掛かりを探さなくっちゃね。[p]

#
きっと私はどんな困難も乗り越えてみせる。[p]

どんな苦境にあっても、どれほど悲しいことがあっても。[p]

#mahoru
あれ？[p]

@chara_mod name="airi" face="smile"

#airi
どうしたの？[p]

何か見つかったの？[p]

#mahoru
ここの棚の本。[p]

なんか一つにつながっているみたいで……。[p]

#

@mask
@chara_hide_all
@reset_message_chara
@mask_off
[doubt_skip show="false"]
[skipstop]

@jump storage="system/ending_credit.ks"
