;===============================================================================
; title.ks ―― ダウト ミニゲームのタイトル画面
;
;   [doubt_title] で画面を描き、[s] で入力待ちに入る。
;   モードのボタンを押すと、このファイルの
;   *arcade_start / *simple_start へ [jump] して先へ進む。
;   （system/title_ui.ks と同じ「描画タグ ＋ [s] ＋ ラベルへ jump」の作り）
;===============================================================================

*start
[cm]
[title name="舞黒館の惨劇 探偵少女はダウトで勝ちの目を見るか"]
@clearstack

;==== 画面とBGMのセットアップ ====
[layopt layer="message" visible="false"]
[layopt layer="message0" visible="false"]
[freeimage layer="base"]
[hidemenubutton]
@playbgm storage="title.mp3"

;==== タイトル画面（アーケードプレイ／シンプルプレイ）====
[doubt_title]
[s]

;==== ここから先はボタンの飛び先 ====
*arcade_start
[jump storage="doubt_main.ks" target="*arcade"]

*simple_start
[jump storage="doubt_main.ks" target="*simple"]

; タイトルの「ランキング」ボタンから
*ranking
[doubt_ranking]
[jump target="*start"]
