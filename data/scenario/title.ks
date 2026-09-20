*start
[cm]
[title name="舞黒館の惨劇 ver1.2"]
@clearstack

;==== 背景とBGMのセットアップ ====

[layopt layer="message0" visible="false"]
[layopt layer="0" visible="true"]
[clearfix]
[freeimage layer="0"]
[bg storage="title.png" ]
[playbgm storage="WhispersintheStardust_Cover.mp3" loop=true]
[hidemenubutton]

[mask_off time=500]

;==== タッチ待ち画面（ロゴ＋TOUCH TO START）====
; 画面のどこを押しても *show_menu へ進む
[title_screen phase="touch"]
[s]

*show_menu
[title_screen phase="menu"]
[s]

*gamestart
; タイトルのロゴをクリアしてからシーン開始
[iscript]
if(window.TL){ window.TL.clear("tl-title"); }
// バックログは tf に溜まり、タイトルへ戻っても消えない。
// 新しく始めたのに前の周回の本文がログに残らないよう、ここで捨てる。
if(tyrano.plugin.kag.__backlogWipe){ tyrano.plugin.kag.__backlogWipe(); }
[endscript]
@jump storage="prologue.ks"
