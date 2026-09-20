; ダウト ミニゲーム 全体の流れ
; タイトル画面は title.ks が受け持つ

;==================================================
*title
[jump storage="title.ks" target="*start"]

;==================================================
; アーケードプレイ（4ペア＋最終戦・物語つき）
;==================================================
*arcade
[eval exp="f.doubt_total = 0; f.doubt_lives = 1; f.doubt_stage = 0"]
[call storage="doubt_story.ks" target="*prologue"]

*arcade_stage
[call storage="doubt_story.ks" target="&'*stage' + f.doubt_stage"]

*arcade_battle
@playbgm storage="card.mp3"
[doubt_vs pair="&f.doubt_stage"]
[doubt_battle pair="&f.doubt_stage"]
[doubt_result pair="&f.doubt_stage"]
[jump target="*arcade_lose" cond="!f.doubt_win"]
[eval exp="f.doubt_stage++"]
[jump target="*arcade_clear" cond="f.doubt_stage > 4"]
[jump target="*arcade_stage"]

*arcade_lose
[doubt_continue]
[jump target="*arcade_battle" cond="f.doubt_continue"]
[doubt_gameover]
@playbgm storage="title.mp3"
[jump target="*arcade_ranking"]

*arcade_clear
[call storage="doubt_story.ks" target="*clear"]
; doubt_story.ks の *clear は、最後に system/ending_credit.ks へ @jump する。
; クレジットが流れ終わると、下の *arcade_ending に戻ってくる。

; エンディングクレジットの後
*arcade_ending
@clearstack
@playbgm storage="title.mp3"
[doubt_clear]
[jump target="*arcade_ranking"]

; 5位以内なら名前を入れて登録し、ランキングを表示してタイトルへ
*arcade_ranking
[doubt_ranking register="true"]
[jump target="*title"]

;==================================================
; シンプルプレイ（物語を飛ばして対戦のみ）
;   相手選択 → 対戦 → 結果 → 相手選択に戻る
;   「もどる」でタイトルへ
;==================================================
*simple
[eval exp="f.doubt_total = 0; f.doubt_lives = 1"]

*simple_select
[doubt_select]
[jump target="*title" cond="f.doubt_pair < 0"]

*simple_battle
@playbgm storage="card.mp3"
[doubt_vs pair="&f.doubt_pair"]
[doubt_battle pair="&f.doubt_pair"]
[doubt_result pair="&f.doubt_pair"]
@playbgm storage="title.mp3"
[jump target="*simple_select"]
