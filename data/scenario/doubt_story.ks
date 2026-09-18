; ダウト ミニゲーム 物語パート
; ※本文はすべて仮テキスト

;--------------------------------------------------
; メッセージウィンドウの準備
;--------------------------------------------------
*setup
[bg storage="doubt/bg-salon.png" time="400"]
[position layer="message0" left="140" top="760" width="1640" height="280" page="fore" visible="true" frame="none" color="0x0b1122" opacity="215" marginl="70" margint="80" marginr="70" marginb="30"]
[ptext name="chara_name_area" layer="message0" color="0xe8b54a" size="36" x="190" y="780" face="Kiwi Maru"]
[chara_config ptext="chara_name_area"]
[deffont size="38" color="0xf6efe0" face="Zen Maru Gothic"]
[resetfont]
[layopt layer="message0" visible="true"]
[return]

*finish
[cm]
[layopt layer="message0" visible="false"]
[freeimage layer="base" time="300"]
[return]

;--------------------------------------------------
*prologue
[call target="*setup"]
#
舞黒館の奥、普段は閉ざされている遊戯室に、明かりが灯っていた。[p]
#舞黒邦夢
ようこそ、お客人。今宵は館の者が総出で、君をもてなそう。[p]
#舞黒邦夢
遊びはダウト。嘘を見抜けば勝ち、見抜けなければ負けだ。[p]
#舞黒邦夢
ただし、この館で勝ち目が残っているのは君だけ。ほかの者は、とうに勝機を失っている。[p]
#舞黒邦夢
だから皆、好き勝手に札を出すだろう。それでも誰かが先に上がれば、君の負けだ。[p]
#真歩流
探偵に嘘くらべを挑むなんて、いい度胸ね。[p]
[call target="*finish"]
[return]

;--------------------------------------------------
*stage0
[call target="*setup"]
#
最初の卓では、愛理と和人が待っていた。[p]
#愛理
お姉ちゃん、手加減しないからね！[p]
[call target="*finish"]
[return]

*stage1
[call target="*setup"]
#
二つ目の卓。甘い香りと、鋭い視線。[p]
#零度警部
取り調べの時間だ。[p]
[call target="*finish"]
[return]

*stage2
[call target="*setup"]
#
三つ目の卓では、珠璃と叡留久が札を揃えていた。[p]
#叡留久
さて、いい取引をしようか。[p]
[call target="*finish"]
[return]

*stage3
[call target="*setup"]
#
四つ目の卓。朱志香は、小出里亜の隣から一歩も動かない。[p]
#小出里亜
ふふ、お手柔らかにお願いしますね。[p]
[call target="*finish"]
[return]

*stage4
[call target="*setup"]
#
最後の卓。そこに座っていたのは――[p]
#真歩流
……待って。どうして私が、もう一人いるの！？[p]
#舞黒邦夢
驚いたかね。今宵最後のもてなしだ。[p]
#
もう一人の真歩流は、何も言わずに微笑んだ。ものすごく、強い。それだけは分かった。[p]
[call target="*finish"]
[return]

;--------------------------------------------------
*clear
[call target="*setup"]
#舞黒邦夢
見事。今宵の嘘は、すべて君に暴かれた。[p]
#真歩流
……ごちそうさま。[p]
[call target="*finish"]
[return]
