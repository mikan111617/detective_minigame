; ダウト ミニゲーム 全体の流れ
@clearstack

;==================================================
*title
[cm]
[freeimage layer="base"]
[doubt_title]
@playbgm storage="card.mp3"
[jump target="*arcade" cond="f.doubt_mode == 'arcade'"]
[jump target="*simple"]

;==================================================
; アーケードプレイ（4ペア＋最終戦）
;==================================================
*arcade
[eval exp="f.doubt_total = 0; f.doubt_lives = 1; f.doubt_stage = 0"]
[call storage="doubt_story.ks" target="*prologue"]

*arcade_stage
[call storage="doubt_story.ks" target="&'*stage' + f.doubt_stage"]

*arcade_battle
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
[jump target="*title"]

*arcade_clear
[call storage="doubt_story.ks" target="*clear"]
[doubt_clear]
[jump target="*title"]

;==================================================
; シンプルプレイ（1戦のみ・最終戦なし）
;==================================================
*simple
[eval exp="f.doubt_total = 0; f.doubt_lives = 1"]
[call storage="doubt_story.ks" target="*prologue"]

*simple_select
[doubt_select]
[jump target="*title" cond="f.doubt_pair < 0"]

*simple_battle
[doubt_vs pair="&f.doubt_pair"]
[doubt_battle pair="&f.doubt_pair"]
[doubt_result pair="&f.doubt_pair"]
[jump target="*title" cond="f.doubt_win"]
[doubt_continue]
[jump target="*simple_battle" cond="f.doubt_continue"]
[doubt_gameover]
[jump target="*title"]
