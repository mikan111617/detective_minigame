;========================================
*prologue

[clearfix]
[cm]
[freeimage layer="0"]
[bg storage="dark.png" time=1000]

;BGM開始
[stopbgm]
[position layer="message0" page=fore visible=true]
[current layer="message0"]
[show_menu]
; 1935年の回想なので、場所名と時刻のプレートは出さない
[hud_hide]

#maicro
[voice id="v00373"]
それにしても、全く……結局このような事態になろうとは。[p]

#maicro
[voice id="v00374"]
嘆かわしい。[p]

#yuduki
[voice id="v00375"]
こんにちは。[p]

#arther
[voice id="v00376"]
ご無沙汰しています。[p]

#arther
[voice id="v00377"]
あの一件以来でしょうか。[p]

#maicro
[voice id="v00378"]
おお、よく来たね。[p]

#yuduki
[voice id="v00379"]
彼が帰ってしまう前に挨拶をしようと思って。[p]

#maicro
[voice id="v00380"]
そうか……。[p]

#maicro
[voice id="v00381"]
辛いだろう。[p]

#arther
[voice id="v00382"]
身が裂けるような思いです。[p]

#yuduki
[voice id="v00383"]
こんなことになるなんて、想像もしていなかった。[p]

#arther
[voice id="v00384"]
すまない、一緒に居られなくて。[p]

#arther
[voice id="v00385"]
両親には何があっても残ると言ったのだが……。[p]

#yuduki
[voice id="v00386"]
寂しいけど、仕方ないわよ。[p]

[voice id="v00387"]
あなたが残ったらきっと大変な目に遭うわ。[p]

#arther
[voice id="v00388"]
そんな簡単に割り切れない。[p]

[voice id="v00389"]
やっぱり、私だけでも……。[p]

#yuduki
[voice id="v00390"]
ありがとう、その気持ちだけで嬉しい。[p]

[voice id="v00391"]
大丈夫よ、いつまでも殺伐とした状態になるわけじゃない。[p]

#arther
[voice id="v00392"]
……。[p]

[voice id="v00393"]
そうだな。[p]

#maicro
[voice id="v00394"]
私らもいる。[p]

[voice id="v00395"]
君も妹さん共々、絶対に元気でいるんだぞ。[p]

#arther
[voice id="v00396"]
勿論です。[p]

[voice id="v00397"]
そうだ、これを預かっていただきたいんです。[p]

#maicro
[voice id="v00398"]
おお、これは……。[p]

#yuduki
[voice id="v00399"]
なになに？[p]

#arther
[voice id="v01458"]
私に何かあった時の為の保険だ。[p]

#arther
[voice id="v01459"]
もし、困ったことになったら、ここへ来れば大丈夫だ。[p]

#yuduki
[voice id="v00400"]
そんな不吉なこと言わないで！[p]

[voice id="v00401"]
必ず……帰ってきて。[p]

#arther
[voice id="v00402"]
ああ……！[p]

#arther
[voice id="v00403"]
何があっても必ず。[p]

#maicro
[voice id="v00404"]
必ずまた再会しよう。[p]

[voice id="v00405"]
この殺伐とした空気が消えたその時に……。[p]

#

; ==== マスクによる場面転換 ====
[mask time=600 effect="fadeIn" color="0x000000"]

@jump storage="scene1.ks" target="*prologue"
