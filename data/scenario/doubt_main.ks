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
[eval exp="f.doubt_used_continue = false"]
[call storage="doubt_story.ks" target="*prologue"]
; 通常アーケードは必ず最初のステージ会話へ。下のデバッグ入口へ流れ込ませない
[jump target="*arcade_stage"]

;--------------------------------------------------
; デバッグ：タイトルの「デバッグ」から、好きな卓に直接入る。
;   f.doubt_stage / f.doubt_total / f.doubt_lives / f.doubt_debug_story は
;   doubt_debug が用意している。
;--------------------------------------------------
*arcade_debug
[eval exp="f.doubt_used_continue = false"]
[jump target="*arcade_stage" cond="f.doubt_debug_story"]
[jump target="*arcade_round_start"]

*arcade_stage
[call storage="doubt_story.ks" target="&'*stage' + f.doubt_stage"]

; ここから、この卓のラウンドが始まる（設定画面で決めた数だけ先に勝った方の勝ち）
*arcade_round_start
[doubt_round_init]

*arcade_battle
; 最終戦と隠し戦は専用のBGM
@playbgm storage="boss_battle.mp3" cond="f.doubt_stage>=4"
@playbgm storage="card.mp3" cond="f.doubt_stage<4"
[doubt_vs pair="&f.doubt_stage"]
[doubt_battle pair="&f.doubt_stage"]
[doubt_result pair="&f.doubt_stage"]
[jump target="*arcade_round_lose" cond="!f.doubt_win"]

; このラウンドを取った。決めた数に届いたら次の卓へ
[eval exp="f.doubt_win_count++"]
[jump target="*arcade_stage_clear" cond="f.doubt_win_count >= f.doubt_rounds"]
[eval exp="f.doubt_round++"]
[jump target="*arcade_battle"]

; このラウンドを落とした。相手が先に取り切ったら敗北
*arcade_round_lose
[eval exp="f.doubt_lose_count++"]
; 隠し戦は本編クリア後の追加勝負。負けても本編クリアは取り消さない
[jump target="*arcade_hidden_lose" cond="f.doubt_stage == 5 && f.doubt_lose_count >= f.doubt_rounds"]
[jump target="*arcade_lose" cond="f.doubt_lose_count >= f.doubt_rounds"]
[eval exp="f.doubt_round++"]
[jump target="*arcade_battle"]

; 一度もラウンドを落とさずに勝ち抜いた時だけ、余興のハイアンドローに挑める
*arcade_stage_clear
[doubt_highlow cond="f.doubt_lose_count == 0"]
; 体験版は第一戦を遊び終えたところで終了する
[jump target="*arcade_demo_end" cond="f.doubt_demo && f.doubt_stage >= f.doubt_demo_last"]
; 隠し戦に勝った時だけ、専用会話と解放を挟んで通常エンディングへ
[jump target="*arcade_hidden_win" cond="f.doubt_stage == 5"]
[eval exp="f.doubt_stage++"]
[jump target="*arcade_hidden_gate" cond="f.doubt_stage == 5"]
[jump target="*arcade_clear" cond="f.doubt_stage > 5"]
[jump target="*arcade_stage"]

*arcade_demo_end
@playbgm storage="title.mp3"
[doubt_demo_end]
[jump target="*title"]

*arcade_hidden_win
[call storage="doubt_story.ks" target="*hidden_win"]
[doubt_unlock_hidden]
[jump target="*arcade_clear"]

*arcade_hidden_lose
; 隠し戦はボーナス戦なので、敗北しても通常エンディングへ進む
[jump target="*arcade_clear"]

; 隠し戦の出現条件
;   ラスボス戦までに一度もコンティニューしていない、または通算が規定点に届いている
*arcade_hidden_gate
[jump target="*arcade_stage" cond="!f.doubt_used_continue || f.doubt_total >= 40000"]
; 条件を満たしていない時は、誰かがいたことだけをほのめかして終わる
[call storage="doubt_story.ks" target="*no_hidden"]
[jump target="*arcade_clear"]

*arcade_lose
[doubt_continue]
; 続ける時は、同じ卓のラウンドを最初から数え直す
[jump target="*arcade_round_start" cond="f.doubt_continue"]
@playbgm storage="game_over.mp3"
[doubt_gameover]
@playbgm storage="title.mp3"
; ゲームオーバー時は残機ボーナスを付けず、その時点のスコアでランキングへ
[jump target="*arcade_ranking_no_bonus"]

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

; クリア時だけ残機ボーナスを足す
*arcade_ranking
[doubt_bonus]

; ゲームオーバー時はここへ直接来るので、残機ボーナスは発生しない
*arcade_ranking_no_bonus
[doubt_ranking register="true"]
[jump target="*title"]

;==================================================
; 体験版フリー対戦
;   愛理＆和人（pair 0）と一戦だけ遊び、終了後はタイトルへ戻る
;==================================================
*simple
[eval exp="f.doubt_total = 0; f.doubt_lives = 1; f.doubt_pair = 0"]

*simple_battle
@playbgm storage="card.mp3"
[doubt_vs pair="0"]
[doubt_battle pair="0"]
@playbgm storage="title.mp3"
[jump target="*title"]
