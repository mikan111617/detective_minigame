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

; 舞黒相談所は [mask] で暗転したままここへ戻ってくる（*hint_leave）。
; 黒幕（.layer_mask）は自分では消えないので、ここで必ず畳む。
; 残したままだと、次に相談所へ入ったとき背景が黒幕の下に隠れてしまう。
; 黒幕が無いときは何もせず素通りするので、他の経路には影響しない。
[mask_off time=500]

;==== タッチ待ち画面（ロゴ＋TOUCH TO START）====
; 画面のどこを押しても *show_menu へ進む
[title_screen phase="touch"]
[s]

;==== タイトルメニューの表示 ====
; はじめから／つづきから／おまけ（sf.puzzle_unlocked のときだけ）／設定
*show_menu

; デバッグ起動（右下隅を5回すばやくタップ）は title_ui.ks の
; オーバーレイ内に組み込んでいる。

; ロゴとメニューの描画は [s] の直前に置く。
; 設定（[sleepgame]）から [awakegame] で戻ると [s] の直前のタグから
; 再開するため、ここに置いておかないと復帰時に画面が空になる。
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
