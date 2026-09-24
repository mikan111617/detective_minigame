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

; 起動してから一度だけ、タイトルより前に注意書きを出す。
; tf はセーブに含まれず、開き直すと消えるので「今回の起動で出したか」の目印になる。
; タイトルへ戻ってきた時は tf が立ったままなので、二度目は出ない。
; この画面のクリックで音声が解禁され、下の [playbgm] が待たずに済む。
[doubt_caution time="5000" cond="!tf.doubt_caution_done"]
; 注意書きに続けてオープニングムービー（煉瓦書架 PRESENTS → 嵐の舞黒館 → タイトルロゴ）。
; 注意書きと同じく、起動して最初の一回だけ。クリックで飛ばせる。
[doubt_opening cond="!tf.doubt_caution_done"]
[eval exp="tf.doubt_caution_done = true"]

;==== タイトル画面（アーケードプレイ／シンプルプレイ）====
; BGM はタイトルを描いた後に鳴らす。
; 万一まだ音声が解禁されていなくても、[playbgm] が待つ間に画面が真っ暗にならない。
[doubt_title]
@playbgm storage="title.mp3"
[s]

;==== ここから先はボタンの飛び先 ====
*arcade_start
[jump storage="doubt_main.ks" target="*arcade"]

; 中断データから再開する時（f は [doubt_title] が中断した試合の直前に戻してある）
*arcade_resume
[jump storage="doubt_main.ks" target="*arcade_resume"]

*simple_start
[jump storage="doubt_main.ks" target="*simple"]

; タイトルの「ランキング」ボタンから
*ranking
[doubt_ranking]
[jump target="*start"]

; タイトルの「設定」ボタンから
*settings
[doubt_settings]
[jump target="*start"]

; タイトルの「遊び方」ボタンから
*help
[doubt_help]
[jump target="*start"]

; 開発用デバッグ。タイトルにはボタンを出さない

*debug
[doubt_debug]
[jump target="*start" cond="!f.doubt_debug_go"]
[jump storage="doubt_main.ks" target="*arcade_debug"]
