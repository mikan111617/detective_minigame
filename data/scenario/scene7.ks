;=========================================
; scene7.ks
; シーン：自由行動②（事件捜査）
;=========================================

*start
@clearstack
[cm]
[clearfix]
[freeimage layer="1"]
[show_menu]
[playbgm storage="sad_story.mp3" loop=true]
[bg storage="room_mashiro_night.png" time=1000]

;-----------------------------------------
; 捜査の開始時刻は、scene6 で零度警部からどれだけ信を得たかで変わる。
; 話し込むほど出発は遅れるが、そのぶん手ぶらで歩き出さずに済む。
;   2=信頼 … 20:35 開始。警部が死因の見立てを先に話してくれている
;   1=普通 … 20:30 開始
;   0=早い … 20:25 開始。ただしリビングは 20:40 まで鑑識が入っている
;-----------------------------------------
[iscript]
if(typeof f.s6_trust_rank !== "number"){ f.s6_trust_rank = 1; }
[endscript]

[if exp="f.s6_trust_rank==2"]
[set_time hour=20 min=35]
[elsif exp="f.s6_trust_rank==1"]
[set_time hour=20 min=30]
[else]
[set_time hour=20 min=25]
[endif]
[gage_draw place="舞黒館:宿泊部屋(2F)"]


;=========================================
; 1. 愛理のそばで決意
;=========================================

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02041"]
（愛理を助けるために……調査を始めないと。）[p]
#mahoru
[voice id="v02042"]
（でも……もし見つけられなかったら。）[p]
#mahoru
[voice id="v02043"]
（毒物を特定できなければ、愛理は——。）[p]
[reset_message_chara]

#
愛理の顔を見つめた。[r]
#
夜の静寂の中、苦しそうに眠る妹の顔を。[p]

[bg storage="event/airi_painful.png" time=1000]

#airi
[voice id="v02044"]
お……姉ちゃん……[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02045"]
愛理！ 起きてるの？[p]
[reset_message_chara]

#airi
[voice id="v02046"]
ちょっとだけ……なら話せるよ……[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02047"]
無理しないで！[p]

#mahoru
[voice id="v02048"]
大丈夫、絶対に助けるから……！[p]
[reset_message_chara]

#airi
[voice id="v02049"]
お姉ちゃん……不安そうな顔してる。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02050"]
そんなこと——。[p]
[reset_message_chara]

#airi
[voice id="v02051"]
お姉ちゃんなら……絶対に大丈夫。[p]
#airi
[voice id="v02052"]
どんな時にも……絶対にあきらめなかったもん……[p]
#airi
[voice id="v02053"]
私はお姉ちゃんのことを……信じているから。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02054"]
愛理……[p]
[reset_message_chara]

#
涙をこらえ、真歩流はその言葉を胸に刻んだ。[p]
#
（愛理のために、絶対に諦めない……！）[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02055"]
（絶対に——愛理を助ける！）[p]
[reset_message_chara]

;=========================================
; 2. リビングで全員から了承を得る
;=========================================

[mask time=500]
[bg storage="living_night.png" time=0]
[chara_hide_all]
[gage_draw place="舞黒館:リビング"]
[mask_off time=500]

[charapos name="reido" face="normal" num="0"]

#
夜のリビングに、参加者全員が集まっていた。[p]

[message_chara name="mahoru" face="shout"]
#mahoru
[voice id="v02056"]
皆さん、零度警部のご許可のもと、私が毒物の手がかり探しに協力します。[p]
#mahoru
[voice id="v02057"]
愛理を助けるために……お願いします！[p]

[voice id="v03957"]
力を貸してください。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="jushika" face="thinking" num="1"]
[charapos name="juri" face="cry" num="2"]
[charapos name="mary" face="thinking" num="3"]
#jushika
[voice id="v02058"]
……ええ。何でも話しますよ。[p]

#juri
[voice id="v02059"]
……わかりました。可能な限り協力するわ。[p]

#mary
[voice id="v02060"]
勿論です。愛理さんのために、できることは何でも。[p]

@chara_hide_all

;-----------------------------------------
; 零度警部の出方は、捜査協力を願い出たときにどれだけ信を得たかで変わる
;-----------------------------------------
[charapos name="reido" face="normal" num="0"]

[if exp="f.s6_trust_rank==2"]
#reido
[voice id="v02061"]
真白さん。歩き出す前に、こちらの見立てをお伝えします。[p]

#reido
[voice id="v02062"]
お二人とも、外傷はなく、争った跡もありません。[p]

#reido
[voice id="v02063"]
解剖の結果が出るのは、早くて明日です。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02064"]
じゃあ、今の時点では死因は……[p]
[reset_message_chara]

#reido
[voice id="v02065"]
断定はできません。ですが、毒物の可能性を考えるなら——。[p]

#reido
[voice id="v02066"]
まず、ご遺体を見るべきでしょう。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02067"]
私が、ですか。[p]
[reset_message_chara]

#reido
[voice id="v02068"]
立ち合いはします。鑑識も付けましょう。[p]

#reido
[voice id="v02069"]
叡留久さんは廊下に、小出里亜さんはキッチンに。そのままにしてあります。[p]

#reido
[voice id="v02070"]
見たくなければ、無理にとは言いません。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02071"]
……いえ。行きます。[p]
[reset_message_chara]

; ▼ 以下、新規会話は要ボイス収録
;    信頼を得た回だけ解放される「次にどこを見るべきか相談する」トピックを、
;    ここで名指しして伝える。解放されていることが伝わらないと見返りにならない。
#reido
[voice id="v03824"]
それと——歩いていて、次に何を見るべきか迷ったら。[p]

#reido
[voice id="v03825"]
私のところへ来てください。何度でも構いません。[p]

#reido
[voice id="v03826"]
私はこのリビングにいます。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03827"]
……はい。ありがとうございます。[p]
[reset_message_chara]

#
警部は先に手の内を見せてくれた。[r]
#
そのぶん、時計の針はもう二十時三十五分を回っている。[p]

[elsif exp="f.s6_trust_rank==1"]
#reido
[voice id="v02072"]
我々も並行して調べます。何か出たら、その都度お知らせください。[p]

; ▼ 以下、新規会話は要ボイス収録
#reido
[voice id="v03828"]
こちらの見立ては、まだお伝えできる段階にありません。[p]

#
——手ぶらで、けれど誰にも止められずに歩き出せる。[r]
#
時刻は二十時三十分。[p]

[else]
[chara_mod name="reido" face="order"]
#reido
[voice id="v02073"]
——ひとつだけ。[p]

#reido
[voice id="v02074"]
この部屋の鑑識が終わっていません。[p]

#reido
[voice id="v02075"]
リビングでの聞き込みと調べものは、二十時四十分以降にしてください。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02076"]
わかりました……。[p]
[reset_message_chara]

#reido
[voice id="v02077"]
それでは、お願いします。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02078"]
……はい。わかりました。[p]
[reset_message_chara]

; ▼ 以下、新規会話は要ボイス収録
#
警部は、それ以上は何も教えてくれなかった。[r]
#
早く放り出されたぶん、時刻はまだ二十時二十五分。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03829"]
（何も持たないまま、十分だけ早く歩き出す。）[p]
[reset_message_chara]
[endif]

#mahoru
[voice id="v02079"]
（よし——始めよう。）[p]
[reset_message_chara]

@chara_hide_all

#TIPS
愛理を救うために、毒の手がかりを捜索します。[p]
#TIPS
館内の様々な場所には事件に関わるものが隠れています。[p]
#TIPS
参加者全員の協力も必要になるので、証拠品を集めながら調査を進めてください。[p]
#TIPS
必要な情報がどれだけ集まっているかは画面の中央に表示されます。[p]
#TIPS
また、証拠品の発見や特定のアイテム会話を通じて、新たな会話やイベントが解放されます。[p]
#TIPS
場所を調べると1分、人と話すと2分の時間を消費しますので、残り時間には常に注意してください。[p]
#TIPS
21時半を過ぎると、館内の調査は強制終了となります。[p]
#TIPS
捜査に迷ったら、マップ選択画面の「捜査メモ」を確認してください。[p]

[chapter_end]

[playbgm storage="A_Step_Toward_the_Truth.mp3" loop=true]


;=========================================
; 3. 変数初期化
;=========================================

*investigation_start
[iscript]
// 別のセーブから入り直したときに前の調査状況が残らないよう、
// s7_ で始まる調査フラグは毎回すべて落としてから初期化する
for(var _k in f){
if(_k.indexOf("s7_") === 0){ f[_k] = 0; }
}
// === 零度警部会話フラグ ===
f.s7_reido_1 = 0;
f.s7_reido_2 = 0;
f.s7_reido_3 = 0;
f.s7_reido_4 = 0;
// === 経路A：カップ照合 ===
f.s7_koderia_cup_clue = 0;
f.s7_koderia_cup_test = 0;
// === 朱志香会話フラグ ===
f.s7_jushika_1 = 0;
f.s7_jushika_2 = 0;
f.s7_jushika_3 = 0;
// === 珠璃会話フラグ ===
f.s7_juri_1 = 0;
f.s7_juri_2 = 0;
// === メアリー会話フラグ ===
f.s7_mary_1 = 0;
f.s7_mary_2 = 0;
f.s7_mary_3 = 0;
// === 和人会話フラグ ===
f.s7_kazuto_1 = 0;
f.s7_kazuto_2 = 0;
f.s7_kazuto_3 = 0;
f.s7_kazuto_3_intro = 0; // セージ仮説を和人に最初に相談した
f.s7_kazuto_4 = 0;
// === 愛理会話フラグ ===
f.s7_airi_1 = 0;
f.s7_airi_2 = 0;
// === 調査フラグ ===
f.s7_sofa = 0;
f.s7_eruku_phone = 0;
f.s7_phone_wiped = 0;   // 1台目が初期化されていた
f.s7_eruku_phone2 = 0;  // 叡留久のスーツケースの2台目
f.s7_bd_eruku = 0;
f.s7_fireplace = 0;
f.s7_carpet = 0;          // ポットの蓋（経路Bのみ）
f.s7_dishes = 0;
f.s7_dining_table = 0;
f.s7_kitchen_stove = 0;
f.s7_kitchen_cup   = 0;    // 流しに残った小出里亜のカップ
f.s7_eruku_cup     = 0;    // そのカップから叡留久の指紋が出た（経路Aのみ）
f.s7_lipstick     = 0;     // 小出里亜のエプロンから出た口紅（経路Bのみ）
                           //   外側に偽聖女／二人分の指紋／底に「To E.／E.H.」の刻印
f.s7_pf6           = 0;    // 毒物の手がかり⑥（叡留久の摂取経路の物証）
f.s7_koderia_body = 0;  // キッチンの小出里亜の遺体
f.s7_eruku_body = 0;    // 1F廊下の叡留久の遺体
f.s7_sun1_floor = 0;
f.s7_sun1_floor2 = 0;
f.s7_sun1_floor2_open = 0; // 条件成立を明示的に保持し、画面再描画前でも表示を安定させる
f.s7_sun1_plant = 0;
f.s7_bd_kazuto = 0;
f.s7_bd_juri = 0;
f.s7_wet_bottle = 0;
f.s7_bd_mary = 0;
f.s7_bd_airi = 0;       // 愛理のベッドサイド（真白姉妹の部屋）
f.s7_lounge_table = 0;  // 談話室：テーブル
f.s7_lounge_window = 0; // 談話室：窓際のカーテン
f.s7_sun2_chair = 0;
f.s7_rouka1_seen = 0;   // 1F廊下
f.s7_rouka2_glass = 0;  // 2F廊下：ステンドグラス
f.s7_gimmick_lid = 0;   // 2F廊下：仕掛けの蓋（経路Bのみ）
f.s7_kazuto_desk = 0;   // 和人の机（経路Bのみ）
f.s7_main_shelf = 0;    // メインルームの棚のボールペン（経路Bのみ）
f.s7_pen_logic = 0;     // ボールペンの問答をすべて通した
// === 館の仕掛け（scene4 と共通のフラグ。昼に解いていれば引き継がれる） ===
if (typeof f.radio_code_known      === 'undefined') f.radio_code_known      = 0;
if (typeof f.event_lounge_shelf    === 'undefined') f.event_lounge_shelf    = 0;
if (typeof f.event_sun2_fireplace  === 'undefined') f.event_sun2_fireplace  = 0;
if (typeof f.glass_blue            === 'undefined') f.glass_blue            = 0;
if (typeof f.glass_red             === 'undefined') f.glass_red             = 0;
if (typeof f.glass_green           === 'undefined') f.glass_green           = 0;
if (typeof f.glass_solved          === 'undefined') f.glass_solved          = 0;
if (typeof f.event_dining_picture  === 'undefined') f.event_dining_picture  = 0;
if (typeof f.event_bd_kazuto_shelf === 'undefined') f.event_bd_kazuto_shelf = 0;
if (typeof f.event_arc_shelf       === 'undefined') f.event_arc_shelf       = 0;
if (typeof f.event_study_desk      === 'undefined') f.event_study_desk      = 0;
if (typeof f.study_security_on     === 'undefined') f.study_security_on     = 0;
f.s7_study_cabinet = 0;
f.s7_newspaper = 0;
f.s7_study_chair = 0;
f.s7_tea_can = 0; // 執務室の茶葉缶（鑑識で毒物・薬物なし）
f.s7_king_yuzuki_record = 0; // 舞黒邦夢の1936年の記録（キング家と結月）
f.s7_arc_plate = 0;
f.s7_arc_record = 0;
f.s7_arc_route = 0;
// === 毒（手がかり）発見フラグ ===
f.s7_pf1 = 0;   // 小出里亜の遺体
f.s7_pf2 = 0;   // 叡留久の遺体
f.s7_pf3 = 0;   // 愛理の体
f.s7_pf4 = 0;   // A:サンルームの床／B:和人の机
f.s7_pf5 = 0;   // A:観葉植物の鉢／B:二階廊下の仕掛け
// === 条件フラグ ===
f.s7_kazuto_secret = 0;
f.s7_sage_request = 0;
f.s7_sage_done = 0;
f.s7_jushika_morning = 0;
f.s7_jushika_tea = 0;   // 朱志香：紅茶を淹れたのは私
f.s7_juri_3 = 0;        // 珠璃：紅茶を運んだのは私
f.s7_exchange_topic = 0;
// === トゥルーエンドフラグ ===
// true_flag_mary は scene4 と共通。scene4 のメアリー会話で立っていることが
// あるので、ここでは 0 に戻さず、未定義のときだけ初期化する。
if (typeof f.true_flag_mary === 'undefined') f.true_flag_mary = 0;
f.s7_true_hint = 0;   // 3つ揃ったときの気づきを一度だけ出すための記録
// === 時間経過イベントフラグ ===
f.s7_event_20 = 0;  // 20分経過（20:50）
f.s7_event_40 = 0;  // 40分経過（21:10）
// === 証拠フラグ ===
f.s7_koderia_secret = 0;
f.s7_poison_complete = 0;
f.s7_marder_reason = 0;
f.s7_drag_book = 0;
f.s7_wet_bottle = 0;
f.s7_fingerprint = 0;

f.s7_sage_hint   = 0;      // セージ成分の考察を出した
f.s7_sage_hypothesis = 0; // 考察を終え、和人に相談できる
f.s7_garden_sage = 0;      // 庭：偽聖女を採取した
f.s7_garden_soil = 0;      // 庭：株が抜かれた跡を見た
f.s7_sage_match  = 0;      // 庭の株と検出成分の照合が済んだ
f.s7_reido_hint_used = 0;  // 零度警部に一度でも相談した

f.s7_map_dest = "";
f.s7_active_floor = 1;  // フロアマップで最後に表示していた階（1 or 2）

// 零度警部の信を得ていれば、死因の話（トピック①）はもう聞いている。
// s7_ で始まるフラグは上のループで一度ゼロに戻るので、必ずこの後で立てる。
if(f.s6_trust_rank === 2){ f.s7_reido_1 = 1; }
[endscript]


;=========================================
; フロアマップ（調査ハブ）
;=========================================
*investigation_hub
[cm]
[clearfix]
[free_layer_image]

[inv_set chapter="s7"]
[bg storage="hallway_night.png" time=500]
[chara_hide_all]
[hidemenubutton]

; ── 時間経過イベントチェック ──────────────────────
; 20分経過（20:50 = 1250分）
[if exp="f.game_time >= 1250 && f.s7_event_20 == 0"]
[eval exp="f.s7_event_20 = 1"]
[jump target="*s7_interval_20"]
[endif]
; 40分経過（21:10 = 1270分）
[if exp="f.game_time >= 1270 && f.s7_event_40 == 0"]
[eval exp="f.s7_event_40 = 1"]
[jump target="*s7_interval_40"]
[endif]

; ── 毒物の手がかりが3つ揃ったときの気づき（一度だけ） ──
;    和人の「発見したセージ成分について」が解放されたことを、
;    真歩流の独り言で知らせる
[if exp="f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_sage_hint!=1"]
[eval exp="f.s7_sage_hint = 1"]
[jump target="*s7_sage_hint"]
[endif]

; ── 真エンドに必要な5つが揃ったときの気づき（一度だけ） ──
[if exp="f.true_flag_mary==1 && f.s7_king_yuzuki_record==1 && f.base_ment_found==1 && f.has_blueprint==1 && f.has_old_key==1 && f.s7_true_hint!=1"]
[eval exp="f.s7_true_hint = 1"]
[jump target="*s7_true_hint"]
[endif]

[freeimage layer="1"]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[iscript]
// 条件付き調査点をマップ描画より先に確定する。
// 直前のイベントで立ったフラグが次の操作まで表示へ反映されない環境がある。
if(f.hidden_study_entered==1 && ((f.route_b!=1 && f.s7_sun1_floor==1) || (f.route_b==1 && f.s7_sun1_plant==1))){
  f.s7_sun1_floor2_open = 1;
}
[endscript]
[inv_map]


;--------------------------------------------------
; ディスパッチ
;--------------------------------------------------
*s7_dispatch
; 館マップ経由の入室であることを示す（部屋の導入テキストはこのときだけ再生）
[eval exp="tf.inv_enter = 1"]
[jump cond="f.s7_map_dest=='genkan'"   target="*scene_genkan"]
[jump cond="f.s7_map_dest=='garden'"   target="*s7_garden"]
[jump cond="f.s7_map_dest=='living'"   target="*s7_living"]
[jump cond="f.s7_map_dest=='dining'"   target="*s7_dining"]
[jump cond="f.s7_map_dest=='kitchen'"  target="*s7_kitchen"]
[jump cond="f.s7_map_dest=='sunroom1'" target="*s7_sunroom1"]
[jump cond="f.s7_map_dest=='rouka1'"   target="*s7_rouka1"]
[jump cond="f.s7_map_dest=='bedroom'"  target="*s7_bedroom"]
; 宿泊部屋の各室（扉選択画面からも直接入るが、マップ復帰用に受け口を用意しておく）
[jump cond="f.s7_map_dest=='bd_main'"    target="*s7_bd_main"]
[jump cond="f.s7_map_dest=='bd_hozairo'" target="*s7_bd_hozairo"]
[jump cond="f.s7_map_dest=='bd_kazuto'"  target="*s7_bd_kazuto"]
[jump cond="f.s7_map_dest=='bd_mary'"    target="*s7_bd_mary"]
[jump cond="f.s7_map_dest=='bd_mashiro'" target="*s7_bd_mashiro"]
[jump cond="f.s7_map_dest=='lounge'"     target="*s7_lounge"]
[jump cond="f.s7_map_dest=='sunroom2'" target="*s7_sunroom2"]
[jump cond="f.s7_map_dest=='archive'"  target="*s7_archive"]
[jump cond="f.s7_map_dest=='study'"    target="*s7_study"]
[jump cond="f.s7_map_dest=='rouka2'"   target="*s7_rouka2"]
[jump cond="f.s7_map_dest=='exit'"     target="*time_over"]
[jump target="*investigation_hub"]


;===========================================
; 時間経過イベント
;===========================================

;--------------------------------------------------
; 毒物の手がかりが3つ揃ったときの考察
;   共通項と「無害なセージ」の矛盾をプレイヤー自身が整理する
;--------------------------------------------------
*s7_sage_hint
[cm]
[bg storage="hallway_night.png" time=500]
[chara_hide_all]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[layopt layer="message0" visible=true]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02080"]
（三人の体から見つかったものを、もう一度整理しよう。）[p]
[reset_message_chara]

#
三人に共通していたものは何か？[p]

*s7_sage_q1_retry
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[layopt layer="message0" visible=true]

; ▼ 要ボイス収録
#
——もう一度、三人に共通していたものを考える。[p]

*s7_sage_q1
[glink color="bth13_dk" target="*s7_sage_q1_wrong_place" text="同じ場所で倒れた" x=510 y=310 width=900 size=28]
[glink color="bth13_dk" target="*s7_sage_q1_correct" text="セージに似た成分が検出された" x=510 y=440 width=900 size=28]
[glink color="bth13_dk" target="*s7_sage_q1_wrong_drink" text="同じ飲み物を口にした" x=510 y=570 width=900 size=28]
[s]

*s7_sage_q1_wrong_place
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02081"]
（違う。小出里亜さんはキッチン、叡留久さんは廊下、愛理はリビングで倒れた。）[p]
#mahoru
[voice id="v02082"]
（場所は三人とも別々だった。）[p]
; ▼ 要ボイス収録
#mahoru
[voice id="v03830"]
（……一度、頭を整理してから考え直そう。）[p]
[reset_message_chara]

; 考え直すぶん、夜の持ち時間を使う
[advance_time min=2]
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_sage_q1_retry"]

*s7_sage_q1_wrong_drink
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02083"]
（同じ飲み物を口にしたとは限らない。）[p]
#mahoru
[voice id="v02084"]
（今、三人を確実に繋いでいるものは——。）[p]
; ▼ 要ボイス収録
#mahoru
[voice id="v03831"]
（……一度、頭を整理してから考え直そう。）[p]
[reset_message_chara]

; 考え直すぶん、夜の持ち時間を使う
[advance_time min=2]
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_sage_q1_retry"]

*s7_sage_q1_correct
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02085"]
（三人とも、セージに似た同じ成分が出ている。）[p]

#mahoru
[voice id="v02086"]
（でも鑑識の人は、セージそのものに毒はないと言っていた。）[p]

#mahoru
[voice id="v02087"]
（だったら——これはセージだけで起きたことじゃない？）[p]
[reset_message_chara]

#
無害なセージで三人が倒れた。この矛盾を説明するには？[p]

*s7_sage_q2_retry
[cm]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[layopt layer="message0" visible=true]

; ▼ 要ボイス収録
#
——もう一度、無害なはずのセージで三人が倒れた理由を考える。[p]

*s7_sage_q2
[glink color="bth13_dk" target="*s7_sage_q2_wrong_forensics" text="鑑識が間違っている" x=460 y=260 width=1000 size=26]
[glink color="bth13_dk" target="*s7_sage_hypothesis" text="普通とは違う品種だった" x=460 y=375 width=1000 size=26]
[glink color="bth13_dk" target="*s7_sage_hypothesis" text="何かを加えると毒に変わった" x=460 y=490 width=1000 size=26]
[glink color="bth13_dk" target="*s7_sage_q2_wrong_other" text="三人はセージ以外の毒を飲んだ" x=460 y=605 width=1000 size=26]
[s]

*s7_sage_q2_wrong_forensics
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02088"]
（鑑識の結果を疑うだけじゃ、三人から同じ成分が出た理由を説明できない。）[p]
; ▼ 要ボイス収録
#mahoru
[voice id="v03832"]
（……一度、頭を整理してから考え直そう。）[p]
[reset_message_chara]

; 考え直すぶん、夜の持ち時間を使う
[advance_time min=2]
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_sage_q2_retry"]

*s7_sage_q2_wrong_other
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02089"]
（別の毒だったとしても、三人から出たセージみたいな成分が偶然とは思えない。）[p]
; ▼ 要ボイス収録
#mahoru
[voice id="v03833"]
（……一度、頭を整理してから考え直そう。）[p]
[reset_message_chara]

; 考え直すぶん、夜の持ち時間を使う
[advance_time min=2]
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_sage_q2_retry"]

*s7_sage_hypothesis
[eval exp="f.s7_sage_hypothesis=1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02090"]
（普通のセージとは違う種類だったのかもしれない。）[p]

#mahoru
[voice id="v02091"]
（それとも、何かを混ぜたことで性質が変わった……？）[p]

#mahoru
[voice id="v02092"]
（私には判断できない。植物に詳しい和人に確かめよう。）[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*investigation_hub"]


*s7_true_hint
[cm]
[bg storage="hallway_night.png" time=500]
[chara_hide_all]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[layopt layer="message0" visible=true]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02093"]
サンルームの床下の鍵穴と、執務室で見つけた鍵の形がそっくりだった。[p]
#mahoru
[voice id="v02094"]
試したいけど、今はそれどころじゃない。[p]
[reset_message_chara]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02095"]
事件が終わったら警部さんに相談してみよう。[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*investigation_hub"]


;--------------------------------------------------
; 20分経過イベント（20:50）BGM変更①
;--------------------------------------------------
*s7_interval_20
[cm]
[bg storage="hallway_night.png" time=500]
[chara_hide_all]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[playbgm storage="A_Step_Toward_the_Truth_1.2.mp3" loop=true]

[charapos name="reido" face="order" num="0"]

#
夜の廊下で、零度警部が部下に声をかけた。[p]

#reido
[voice id="v02096"]
手がかりはまだつかめないのか？[p]

#
申し訳ありません、警部。もう少し時間を……[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v02097"]
時間は有限だ。急いでくれ。[p]

[chara_hide_all]
[jump target="*investigation_hub"]


;--------------------------------------------------
; 40分経過イベント（21:10）BGM変更②
;--------------------------------------------------
*s7_interval_40
[cm]
[bg storage="hallway_night.png" time=500]
[chara_hide_all]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[playbgm storage="A_Step_Toward_the_Truth_1.5.mp3" loop=true]

[charapos name="reido" face="order" num="0"]

#
廊下に、零度警部の張り詰めた声が響いた。[p]

#reido
[voice id="v02098"]
もう時間がないぞ！ 急いで手がかりを見つけろ！[p]

#
部下たちが一斉に動き出した。[r]
#
夜の館に、緊迫した足音が響き渡った。[p]

[chara_hide_all]
[jump target="*investigation_hub"]

;=========================================
; 1F ── 玄関（クリッカブル版）
;=========================================

*scene_genkan
[cm]
[inv_set chapter="s7"]
[bg storage="entrance_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_genkan        === 'undefined') f.event_genkan        = 0;
if (typeof f.has_entrance_record === 'undefined') f.has_entrance_record = 0;
[endscript]

; 館マップから入ってきたときだけ、部屋の導入テキストを再生する
[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:玄関"]

#
ステンドグラスが彩る玄関ホール。外の光が床に色鮮やかな模様を描いていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="genkan"]

;=========================================
; イベント：記帳台を調べる
;=========================================

*evt_genkan_record
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:玄関(1F)"]
[layopt layer="message0" visible=true]

[if exp="f.event_genkan==1"]
[message_chara name="mahoru" face="normal"]

; ▼ 要ボイス再録：v02099（旧「朱志香さんに今朝何をしていたのか聞いてみようかな……」）
#mahoru
[voice id="v02099"]
朱志香さんに到着したころのことを聞いてみようかな……[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*scene_genkan"]
[endif]

[iscript]
f.game_time = Math.min((f.game_time||0) + 7, 1290);
f.event_genkan = 1;
f.has_entrance_record = 1;
[endscript]

#
玄関の脇にある記帳台に、宿泊者全員の入館記録が置いてあった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02100"]
これ、入館のときに記入したやつだよね。[p]
[reset_message_chara]

#
ページをめくっていくと、ある記述が目に留まった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02101"]
……珠璃さんたち、随分早く来たんだね。[p]
#mahoru
[voice id="v02102"]
うーん、やっぱりこういうのは早く来るのがマナーなのかな。[p]
; ▼ 要ボイス再録：v02103（旧「朱志香さんに今朝は何をしていたのか聞いてみようかな。」）
#mahoru
[voice id="v02103"]
朱志香さんに到着したころのことを聞いてみようかな。[p]
[reset_message_chara]

[get_item id="records"]

[set_item_status id="records" owned="true"]
[eval exp="f.morning_action = 1"]
[jump target="*scene_genkan"]


;===========================================
; 1F ── リビング
;===========================================

;===========================================
; 庭（メイフェア・ガーデン）
;   館の外。昼に歩いた庭を、夜にもう一度見に行く。
;   薬学研究の本を持っていると、偽聖女を見分けられる。
;===========================================
*s7_garden
[cm]
[inv_set chapter="s7"]
[bg storage="garden_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:庭"]

#
勝手口から外へ出ると、夜の庭が広がっていた。[r]
#
昼にあれほど明るかった花壇は、今はただ黒い塊にしか見えない。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02104"]
（懐中電灯……ありがとうございます。）[p]
[reset_message_chara]

#警察
足元にお気をつけて。あまり奥までは行かないように。[p]

; 昼に記念撮影をしていれば、その場所を思い出す
[if exp="f.group_photo==1"]
; ▼ 要ボイス収録
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03834"]
（……このあたりだ。）[p]

#mahoru
[voice id="v03835"]
（昼に、みんなで写真を撮った場所。）[p]
[reset_message_chara]
[endif]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="garden"]


;--- ハーブの花壇 ------------------------------------------
*s7_evt_garden_sage
[cm]
[freeimage layer="1"]
[show_menu]
[bg storage="garden_night.png" time=0]
[gage_draw place="舞黒館:庭"]
[layopt layer="message0" visible=true]
[advance_time min=1]

[if exp="f.s7_garden_sage==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02105"]
（偽聖女はもう採った。念のため、警部にも場所を伝えてある。）[p]
[reset_message_chara]
[jump target="*s7_garden"]
[endif]

#
懐中電灯を向けると、細長い葉をつけた草がひとかたまりに植わっていた。[r]
#
昼に見たときは、ただのハーブだと思っていた一角だ。[p]

[if exp="f.s7_drag_book!=1"]
; ── 本を持っていない：見分けがつかない ──
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02106"]
（……セージ、だよね。）[p]

#mahoru
[voice id="v02107"]
（でも、セージって普通の香草だし……）[p]
[reset_message_chara]

#
葉をつまんで匂いを嗅いでみる。[r]
#
知っている匂いのような、そうでないような。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02108"]
（だめ……私には、どれが何の草かなんて分からないよ。）[p]

#mahoru
[voice id="v02109"]
（植物に詳しい人か……何か、調べられるものがあれば。）[p]
[reset_message_chara]

[jump target="*s7_garden"]
[endif]

; ── 本を持っている：偽聖女を見分ける ──
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02110"]
（この葉の形……どこかで。）[p]
[reset_message_chara]

#
真歩流は和人から預かった本を開いた。[r]
#
懐中電灯の光の下で、頁の図と目の前の株を、何度も見比べる。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02111"]
（……同じ、だよね。）[p]

#mahoru
[voice id="v02112"]
（葉のふちの切れ込みも、裏の毛の生え方も、本のとおり。）[p]
[reset_message_chara]

#
偽聖女（ヴァイス・セージ）。[r]
#
——和人の母親が研究していたという、セージの改良品種。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02113"]
（どうして、こんなものが舞黒館の庭に……）[p]
[reset_message_chara]

#
真歩流は同行の警察官を呼び、株をひとつ、袋に収めてもらった。[p]

#警察
これは……こちらで預かって、鑑識に回します。[p]

#警察
真白さん、よく気づきましたね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02114"]
本のおかげです。[p]
[reset_message_chara]

[eval exp="f.s7_garden_sage=1"]
[get_item id="garden_sage"]
[set_item_status id="garden_sage" owned="true"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02115"]
（これが本当に事件の毒と同じものなのか……警部に確かめてもらおう。）[p]
[reset_message_chara]

[jump target="*s7_garden"]


;--- 花壇のふち --------------------------------------------
*s7_evt_garden_soil
[cm]
[freeimage layer="1"]
[show_menu]
[bg storage="garden_night.png" time=0]
[gage_draw place="舞黒館:庭"]
[layopt layer="message0" visible=true]
[advance_time min=1]

[if exp="f.s7_garden_soil==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02116"]
（土が少しだけ掘り返されて、株がひとつ抜けた跡があった。）[p]
[reset_message_chara]
[jump target="*s7_garden"]
[endif]
[eval exp="f.s7_garden_soil=1"]

#
花壇のふちに、土がわずかに乱れている場所があった。[r]
#
株がひとつ、根ごと抜き取られた跡だ。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02117"]
（雨は降っていないのに、この跡だけ土の色が違う。）[p]

#mahoru
[voice id="v02118"]
（新しい……たぶん、今日のうちのもの。）[p]
[reset_message_chara]

#警察
庭師が入ったという話は聞いていませんね。[p]

#警察
土の乾き具合からして、抜かれたのは今日の昼頃でしょう。[p]

#警察
昼間のうちに、誰かがここから草を抜いた——ということになります。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02119"]
（誰かが、この庭から何かを持っていった。）[p]
[reset_message_chara]

[jump target="*s7_garden"]


*s7_living
[cm]
; 説得を急がせた回（rank 0）は、20:40 まで鑑識がリビングに入っている
[if exp="f.s6_trust_rank==0 && f.game_time < 1240"]
[jump target="*s7_living_closed"]
[endif]
[inv_set chapter="s7"]
[bg storage="living_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="thinking" num="1"]
[charapos name="jushika" face="thinking" num="2"]
[charapos name="juri" face="cry" num="3"]
[charapos name="mary" face="thinking" num="4"]

#
夜のリビング。朱志香、珠璃、メアリー、零度警部が沈黙の中で待機していた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="living"]


;--------------------------------------------------
; 鑑識中で入れないとき（rank 0 のみ・20:40 まで）
;--------------------------------------------------
*s7_living_closed
[cm]
[clearfix]
[show_menu]
[bg storage="hallway_night.png" time=300]
[chara_hide_all]
[gage_draw place="舞黒館:廊下(1F)"]
[layopt layer="message0" visible=true]

#
リビングの入口には規制線が張られ、鑑識官が黙々と作業を続けていた。[p]

#警察
すみません、この部屋はまだ通せません。[p]

#警察
二十時四十分には終わる予定です。それまで、他をお願いします。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02120"]
（……先に、別の場所を回ろう。）[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*investigation_hub"]


;--------------------------------------------------
; キャラクター選択
;--------------------------------------------------
*s7_living_chara
[jump target="*s7_living"]


;===========================================
; 零度警部 トピックハブ
;===========================================
*s7_reido_hub
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[eval exp="tf.inv_talk = 'reido'"]
[jump target="*s7_living"]

; ── トピック①本編 ───────────────────────────────
*s7_reido_t1
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_reido_1=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02121"]
警部、小出里亜さんと叡留久さんの死因について、何かわかりましたか？[p]
[reset_message_chara]
#reido
[voice id="v02122"]
それが、まだ何とも言えないのです。[p]

#reido
[voice id="v02123"]
外傷はなく、争った跡もありません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02124"]
じゃあ、何が原因なんですか。[p]
[reset_message_chara]

#reido
[voice id="v02125"]
解剖の結果が出るのは早くて明日です。[p]

#reido
[voice id="v02126"]
ただ——毒物の可能性を考えるなら、まずご遺体を見るべきでしょう。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02127"]
私が、ですか。[p]
[reset_message_chara]

#reido
[voice id="v02128"]
立ち会いはします。鑑識も付けましょう。[p]

#reido
[voice id="v02129"]
叡留久さんは廊下に、小出里亜さんはキッチンに。そのままにしてあります。[p]

#reido
[voice id="v02130"]
見たくなければ、無理にとは言いません。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02131"]
……いえ。行きます。[p]
[reset_message_chara]

[jump target="*s7_reido_hub"]

*s7_reido_t1r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02132"]
（死因はまだ分からない。廊下とキッチンに、二人が残されたまま。）[p]

#mahoru
[voice id="v02133"]
（……自分の目で確かめないと。）[p]

[reset_message_chara]
[jump target="*s7_reido_hub"]

; ── トピック②本編 ───────────────────────────────
*s7_reido_t2
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_reido_2=1"]
#reido
[voice id="v02134"]
ちょうど良かった。小出里亜さんのスマートフォンの調査と叡留久さんのスマートフォンの調査が終わりました。[p]

#reido
[voice id="v02135"]
結論から言いましょう。[p]

#reido
[voice id="v02136"]
二人は……不倫関係にあったようです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02137"]
え……！？[p]
[reset_message_chara]

#reido
[voice id="v02138"]
小出里亜さんは『エミリー』というSNSアカウントを持っており、二人の間でやり取りをしているのも確認できました。[p]

#reido
[voice id="v02139"]
お茶会の後に一度キッチンで会っていることもわかりました。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02140"]
そ、そんな……叡留久さんどうして。[p]

#mahoru
[voice id="v02141"]
それに小出里亜さんの好きな人って……叡留久さんだったの。[p]

[reset_message_chara]

#reido
[voice id="v02142"]
二人はこのイベントで会う予定だったようです。[p]

#reido
[voice id="v02143"]
一緒に舞黒館の宿泊イベントに参加するという投稿をしています。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02144"]
……[p]
[reset_message_chara]

#reido
[voice id="v02145"]
申し訳ない。こんなことをあなたが知る必要はなかったのに……[p]

#reido
[voice id="v02146"]
珠璃さんには、まだ伝えないようにお願いします。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02147"]
……わかりました。[p]
[reset_message_chara]
[eval exp="f.s7_marder_reason = 1"]

[set_item_status id="koderia_phone" owned="true" secret="true"]
[set_item_status id="eruku_phone" secret="true"]
[get_item id="koderia_phone" type="info"]
[get_item id="eruku_phone" type="info"]

[jump target="*s7_reido_hub"]

*s7_reido_t2r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="normal" num="0"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v02148"]
（小出里亜さんは『エミリー』として叡留久さんと親密な関係にあった。）[p]

#mahoru
[voice id="v02149"]
（珠璃さん……きっと悲しむだろうな。）[p]

; face="sad" は未登録（chara/mahoru/sad.png も無い）ため light_thinking に変更。
; 悲しみを強く出したい場合の登録済みの選択肢は cry。
[chara_mod name="mahoru" face="light_thinking"]
[reset_message_chara]
[jump target="*s7_reido_hub"]

; ── トピック③本編 ───────────────────────────────
*s7_reido_t3
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_reido_3=1"]
[if exp="f.route_b == 1"]

#reido
[voice id="v03836"]
ポットや調理器具を調べましたが、ポットの持ち手の隙間から毒物が検出されました。[p]

#reido
[voice id="v03837"]
また……雑巾類は洗浄されており、こちらからは毒物は出ていません。[p]
[message_chara name="mahoru" face="thinking"]

#mahoru
[voice id="v03838"]
ポットの持ち手から……[p]
[reset_message_chara]

#reido
[voice id="v03839"]
ですが、元々ついていたのか、後からついたのかはわかりません。[p]

@else
#reido
[voice id="v02150"]
ポットや調理器具を調べましたが、ポット表面から毒物は検出されませんでした。[p]

#reido
[voice id="v02151"]
また……雑巾類は洗浄されており、こちらからも毒物は出ていません。[p]
[message_chara name="mahoru" face="thinking"]

#mahoru
[voice id="v02152"]
手がかりはなしですか……[p]
[reset_message_chara]

#reido
[voice id="v02153"]
ですが、誰かが意図的に洗浄をした可能性も捨てきれません。[p]

@endif
#reido
[voice id="v02154"]
ポットは証拠として保管してあるので、見たいときは言ってください。[p]


[if exp="f.status['pot'].owned != true"]
[get_item id="pot"]
[iscript]
f.status["pot"].owned = true;
[endscript]
[endif]
[jump target="*s7_reido_hub"]

*s7_reido_t3r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
[if exp="f.route_b == 1"]
#mahoru
[voice id="v03840"]
（ポットの持ち手の隙間から毒が出た。布巾で洗浄済み——誰かが証拠を消したのかもしれない。）[p]
@else
#mahoru
[voice id="v02155"]
（ポット表面からは毒が出なかった。布巾も洗浄済み——誰かが証拠を消したのかもしれない。）[p]
@endif
[reset_message_chara]
[jump target="*s7_reido_hub"]

; ── トピック④本編 ───────────────────────────────
*s7_reido_t4
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_reido_4=1"]
[eval exp="f.s7_sage_done=1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02156"]
零度警部！ 実験したいことがあるんです。[p]
[reset_message_chara]

#reido
[voice id="v02157"]
何です？[p]

[mask]
[mask_off]

#reido
[voice id="v02158"]
……なるほど。[p]

#reido
[voice id="v02159"]
徐音さんから教えてもらった方法——検出されたセージの成分に強いアルコールをかければいいんですね。[p]

#
零度警部が鑑識に指示を出した。しばらくして——[p]

#reido
[voice id="v02160"]
……反応が出ました。強い毒性反応です。[p]

#reido
[voice id="v02161"]
死因はセージのような物質にアルコールを混ぜた毒物である可能性が極めて高い。[p]

#reido
[voice id="v02162"]
しかし、なぜ徐音さんはわかったんだ？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02163"]
（和人の言ったとおりだった……）[p]
[reset_message_chara]

#reido
[voice id="v02164"]
ともあれ、これで死因が特定できた。後は摂取経路を特定するのみ。[p]

#reido
[voice id="v02165"]
ご協力に感謝します、真白さん。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02166"]
和人に報告しよう。[p]
[reset_message_chara]

[get_item id="poison" name="毒物（死因特定）"]
[eval exp="f.s7_poison_complete = 1"]
[set_item_status id="poison" owned="true"]
[jump target="*s7_reido_hub"]

*s7_reido_t4r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02167"]
（死因は偽聖女とアルコールの混合毒——あとはどこで摂取したのかを特定しなければ。）[p]
[reset_message_chara]
[jump target="*s7_reido_hub"]


;--- トピック⑤：庭のセージの鑑定 --------------------------
*s7_reido_t5
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_sage_match=1"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02168"]
警部。庭で採った株を、鑑定に回してもらえませんか。[p]
[reset_message_chara]

#reido
[voice id="v02169"]
庭の草を、ですか。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02170"]
はい。[p]

#mahoru
[voice id="v02171"]
遺体から出たセージの成分と、この庭の株が同じものかどうか。[p]

#mahoru
[voice id="v02172"]
それが分かれば——毒がどこから来たのかが、はっきりします。[p]
[reset_message_chara]

#
零度警部はしばらく真歩流の顔を見ていた。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v02173"]
……我々は、外から持ち込まれたものだとばかり考えていた。[p]

#reido
[voice id="v02174"]
館の中を探すことばかりに気を取られて、庭は誰も見ていない。[p]

#reido
[voice id="v02175"]
すぐに回します。[p]

[mask]
[mask_off]

#
数分後。鑑識官が戻ってきた。[p]

#警察
警部。簡易の分析だけ、先にお伝えします。[p]

#警察
現段階でははっきりとは言えませんが——。[p]

#警察
庭から採取された株から、ご遺体の検出成分と近しいものが出ています。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02176"]
近しい……[p]
[reset_message_chara]

#警察
ええ。ただ、同一のものと断じるには、もう少し時間をいただきたい。[p]

#警察
品種の同定までは、こちらで持ち帰って詳しく調べさせます。[p]

#警察
それと、もうひとつ。[p]

#警察
花壇には、株がひとつ抜き取られた跡が残っていました。[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v02177"]
——断定はできない。ですが、筋は見えました。[p]

#reido
[voice id="v02178"]
毒は外から持ち込まれたものではなく、この館の庭にあったものかもしれない。[p]

#
零度警部の声が、はっきりと硬くなった。[p]

#reido
[voice id="v02179"]
もしそうなら、犯人は毒を用意して来たのではない。[p]

#reido
[voice id="v02180"]
この庭のものを使える立場にいた人間だ、ということになります。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02181"]
（庭に自由に出られたのは……今日、この館にいた全員。）[p]

#mahoru
[voice id="v02182"]
（でも、そこに偽聖女が生えていると知っていた人は——。）[p]
[reset_message_chara]

#reido
[voice id="v02183"]
真白さん。これは大きい。[p]

#reido
[voice id="v02184"]
結果が出しだい、すぐにお伝えします。ご協力感謝します。[p]

[set_item_status id="garden_sage" owned="true" secret="true"]
[jump target="*s7_reido_hub"]

*s7_reido_t5r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02185"]
（庭の株から、二人と近しい成分。それに、抜き取られた跡。）[p]

#mahoru
[voice id="v02186"]
（同じものだって確かめられれば——毒の出どころは、この庭ってことになるよね。）[p]
[reset_message_chara]
[jump target="*s7_reido_hub"]


;===========================================
; 零度警部 トピック⑥ ── 小出里亜のカップ（経路A）
; メアリーのカップの鑑識結果から、同じ方法で被害者のカップを特定する。
;===========================================
*s7_reido_t6
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_koderia_cup_test=1"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02187"]
警部。メアリーさんのカップは、指紋から見つけられたんですよね。[p]

#mahoru
[voice id="v02188"]
だったら、小出里亜さんが使っていたカップも探してもらえませんか？[p]
[reset_message_chara]

#reido
[voice id="v02189"]
理由を聞いても？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02190"]
小出里亜さんは、倒れる直前に一度ダイニングへ来ています。[p]

#mahoru
[voice id="v02191"]
倒れた場所と、毒を口にした場所が同じとは限りません。[p]

#mahoru
[voice id="v02192"]
メアリーさんのカップから薬物が出たなら、小出里亜さんのカップも確かめたいんです。[p]
[reset_message_chara]

#reido
[voice id="v02193"]
……分かりました。[p]

#reido
[voice id="v02194"]
お茶会で使われたカップは、鑑識がすべて保全しています。[p]

#reido
[voice id="v02195"]
灰音さんの指紋と照合させましょう。[p]

[mask time=500 effect="fadeIn" color="0x000000"]
[wait time=500]
[mask_off time=700]

#警察
警部、見つかりました。[p]

#警察
灰音小出里亜さんの指紋が残っているカップが一客あります。[p]

#警察
そして、縁から薬物反応が出ています。[p]

#警察
メアリーさんのカップから検出されたものと、同種の成分です。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02196"]
やっぱり……！[p]
[reset_message_chara]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02197"]
（小出里亜さんは、キッチンで毒を口にしたとは限らない。）[p]

#mahoru
[voice id="v02198"]
（お茶会の時、ダイニングで飲んだ紅茶から……。）[p]
[reset_message_chara]

[get_item name="小出里亜さんのカップの鑑定結果" type="clue"]
[jump target="*s7_reido_hub"]

*s7_reido_t6r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02199"]
（小出里亜さんのカップから、本人の指紋と薬物反応が出た。）[p]

#mahoru
[voice id="v02200"]
（倒れたキッチンじゃなく、お茶会で毒を口にした可能性がある。）[p]
[reset_message_chara]

[jump target="*s7_reido_hub"]


;--- 相談：毒の摂取経路について ----------------------------
;   零度警部の信を得た回だけ解放される。何度でも相談できる。
;   未調査の部屋を機械的に挙げるのではなく、三人が毒をどう口にしたかを
;   A/Bそれぞれの取得済み情報に応じて、答えを言い切らず段階的に助言する。
*s7_reido_hint
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]
; ▼ この相談だけは時間を消費しない（夜の持ち時間が厳しく、
;    ヒントを引くたびに削られるとクリアできなくなるため）
; 一度相談すると既読になるが、既読側も同じここへ来るので何度でも相談できる
[eval exp="f.s7_reido_hint_used=1"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02201"]
警部……次は、どこを見ればいいでしょうか。[p]
[reset_message_chara]

[iscript]
// 人物の会話を含む摂取経路の進行だけを見る。
// 一度見たかどうかではなく、推理に必要な情報フラグが立ったかで段階を進める。
tf.reido_hint_stage = "";

// 共通：愛理が他の参加者と違って口にしたものを確かめる。
if(f.s7_airi_1!=1){
  tf.reido_hint_stage = "airi_drink";
}else if(f.s7_mary_2!=1){
  tf.reido_hint_stage = "airi_source";
}else if(f.s7_airi_2!=1){
  tf.reido_hint_stage = "airi_test";

// 経路A：小出里亜のカップを特定し、叡留久と同じ器を使った事実へつなぐ。
}else if(f.route_b!=1 && f.s7_koderia_cup_clue!=1){
  tf.reido_hint_stage = "a_cup_identity";
}else if(f.route_b!=1 && f.s7_koderia_cup_test!=1){
  tf.reido_hint_stage = "a_cup_test";
}else if(f.route_b!=1 && f.s7_eruku_body!=1){
  tf.reido_hint_stage = "eruku_mouth";
}else if(f.route_b!=1 && f.s7_eruku_cup!=1){
  tf.reido_hint_stage = "a_shared_cup";
}else if(f.route_b!=1){
  tf.reido_hint_stage = "a_ready";

// 経路B：火傷した手の仕草と、拾われた贈り物に残る二人の痕跡をつなぐ。
}else if(f.s7_koderia_secret!=1){
  tf.reido_hint_stage = "b_burned_hand";
}else if(f.s7_koderia_body!=1 || f.s7_lipstick!=1){
  tf.reido_hint_stage = "b_belongings";
}else if(f.s7_eruku_body!=1){
  tf.reido_hint_stage = "eruku_mouth";
}else{
  tf.reido_hint_stage = "b_ready";
}
[endscript]

; ▼ 以下、摂取経路ヒントは要ボイス収録
[if exp="tf.reido_hint_stage=='airi_drink'"]
#reido
まず、倒れた場所から考えるのをやめましょう。[p]

#reido
真白愛理さんが、お茶会でほかの参加者とは違って口にしたものはありませんか。[p]

#reido
ご本人に、飲み物が誰から渡されたものだったのかを聞いてください。[p]

[elsif exp="tf.reido_hint_stage=='airi_source'"]
#reido
愛理さんが飲んだものの、元の持ち主に話を聞くべきです。[p]

#reido
なぜ自分では飲まず、愛理さんへ渡したのか。使った器も残っているかもしれません。[p]

[elsif exp="tf.reido_hint_stage=='airi_test'"]
#reido
証言だけでは、愛理さんが同じ毒を摂取したとは断定できません。[p]

#reido
辛い確認になりますが、愛理さんの身体からも同じ成分が出るか調べる必要があります。[p]

[elsif exp="tf.reido_hint_stage=='a_cup_identity'"]
#reido
お茶会のカップは、見た目だけでは誰が使ったものか分かりません。[p]

#reido
ですが、指紋なら持ち主をたどれます。まず一客を特定できれば、同じ方法をほかにも使えます。[p]

[elsif exp="tf.reido_hint_stage=='a_cup_test'"]
#reido
灰音さんは、倒れる前にダイニングにも来ています。[p]

#reido
倒れたキッチンではなく、お茶会で毒を口にした可能性を確かめるべきでしょう。[p]

#reido
灰音さんの指紋から使用したカップを特定し、縁の薬物反応を調べられます。[p]

[elsif exp="tf.reido_hint_stage=='eruku_mouth'"]
#reido
穂在呂さんが毒に触れたことと、口にしたことは別です。[p]

#reido
唇の外側だけでなく、内側にも成分が残っていないか。ご遺体を同じ観点で確認してください。[p]

[elsif exp="tf.reido_hint_stage=='a_shared_cup'"]
#reido
灰音さんのカップが分かったなら、それを使ったのが本人だけだったか確認してください。[p]

#reido
持ち手と縁に、もう一人分の指紋が残っているかもしれません。[p]

#reido
洗われずに残った器がないか、キッチンを見直してみましょう。[p]

[elsif exp="tf.reido_hint_stage=='a_ready'"]
#reido
摂取経路を考える材料は揃っています。[p]

#reido
愛理さんへ渡った紅茶。灰音さんのカップ。そして、そのカップに残ったもう一人の指紋。[p]

#reido
三人を一人ずつ分けて、いつ、誰の器から口にしたのかを並べてください。[p]

[elsif exp="tf.reido_hint_stage=='b_burned_hand'"]
#reido
灰音さんの火傷は、毒が体内へ入った瞬間と関係しているかもしれません。[p]

#reido
火傷した直後、その手をどうしたのか。事件前から館にいた人物なら見ているはずです。[p]

[elsif exp="tf.reido_hint_stage=='b_belongings'"]
#reido
毒の付いた手で別の物を押さえていれば、外側に成分が移ります。[p]

#reido
灰音さんが身につけていた物を、ポケットの中まで確認してください。[p]

#reido
本人以外の指紋や、持ち主を示す印が残っていれば、次に触れた人物を追えます。[p]

[elsif exp="tf.reido_hint_stage=='b_ready'"]
#reido
摂取経路を考える材料は揃っています。[p]

#reido
火傷した手の仕草。毒が外側へ移った持ち物。そこに残る二人分の指紋。そして、穂在呂さんの唇の内側。[p]

#reido
毒が手から物へ、物から次の人物へ渡った順番を並べてください。[p]
[endif]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03958"]
……ありがとうございます。考えてみます。[p]
[reset_message_chara]

[jump target="*s7_reido_hub"]



;===========================================
; 朱志香 トピックハブ
;===========================================
*s7_jushika_hub
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[eval exp="tf.inv_talk = 'jushika'"]
[jump target="*s7_living"]

*s7_jushika_t1
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_jushika_1=1"]
#jushika
[voice id="v02214"]
こんなことになってしまって……本当に申し訳ありません。[p]

#jushika
[voice id="v02215"]
小出里亜さんは……本当によく働いてくれていました。[p]

#jushika
[voice id="v02216"]
実は彼女、宿泊イベントを開催した際に、執務室に入っていたり……私の行動を気にしていたようでした。[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02217"]
そうなんですか？[p]
[reset_message_chara]

#jushika
[voice id="v02218"]
それが……私にも何かを尋ねようとしていたようで。でも、結局何も話してくれなかったんです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02219"]
（小出里亜さんは何を気にしていたんだろう？）[p]
[reset_message_chara]

[jump target="*s7_jushika_hub"]

*s7_jushika_t1r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="jushika" face="thinking" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02220"]
（小出里亜さんは執務室に入って、朱志香さんの行動を気にしていた——何かを知っていたのかも。）[p]
[reset_message_chara]
[jump target="*s7_jushika_hub"]

*s7_jushika_t2
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="jushika" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_jushika_2=1"]
[eval exp="f.s7_jushika_morning=1"]
[message_chara name="mahoru" face="normal"]
; ▼ 要ボイス再録：v02221（旧「朱志香さん、今朝のことを聞かせてください。それこそ、集合の時間から。」）
#mahoru
[voice id="v02221"]
朱志香さん、到着したころのことを聞かせてください。それこそ、集合の時間より前から。[p]
[reset_message_chara]
#jushika
[voice id="v02222"]
ええ。宿泊イベントの準備で早くから来ていて、小出里亜さんと一緒に準備をしていました。[p]
#jushika
[voice id="v02223"]
穂在呂夫妻が集合時間の40分以上前にいらして、四人でお茶をしていました。[p]

#jushika
[voice id="v02224"]
……そういえばその時、小出里亜さんが熱いお茶に指が触れてしまって。[p]

; ▼ 要ボイス再録：v02225（旧「……今朝もそうしていた、……」）
#jushika
[voice id="v02225"]
反射で指をなめる癖があったわ。あの時もそうしていた、四人で笑って話していたのに……[p]
[message_chara name="mahoru" face="cry"]

#mahoru
[voice id="v02226"]
朱志香さん……。[p]
[reset_message_chara]
[eval exp="f.s7_koderia_secret = 1"]
[set_item_status id="chara_04" secret="true"]
[get_item id="chara_04" type="info"]
[jump target="*s7_jushika_hub"]

*s7_jushika_t2r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="jushika" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
; ▼ 要ボイス再録：v02227（旧「（今朝の四人のお茶——……）」）
#mahoru
[voice id="v02227"]
（集合前の四人のお茶——小出里亜さんの指なめの癖。ここに鍵があるかもしれない。）[p]
[reset_message_chara]
[jump target="*s7_jushika_hub"]

*s7_jushika_t3
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_jushika_3=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02228"]
……少し、聞いてもいいですか。[p]

#mahoru
[voice id="v02229"]
この新聞記事の話って……[p]
[reset_message_chara]

#jushika
[voice id="v02230"]
舞黒館を買い取った後——私の娘が誘拐されたんです。[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02231"]
えっ……[p]
[reset_message_chara]
#jushika
[voice id="v02232"]
どれだけ探しても見つかりませんでした。[p]

#jushika
[voice id="v02233"]
私は娘を失った悲しさでどうにかなってしまいそうだった。[p]

#jushika
[voice id="v02234"]
それから、十数年が経ちました。[p]

#jushika
[voice id="v02235"]
ある日、小出里亜さんがうちで働きたいと言ってきたんです。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02236"]
小出里亜さんはどうして朱志香さんの所へ来たんですか？[p]
[reset_message_chara]

#jushika
[voice id="v02237"]
それはわかりません。[p]

#jushika
[voice id="v02238"]
ただ、小出里亜さんが灰音の家にもらわれてきた身の上と聞いて、家族を失う境遇を経験している私には断れなかった。[p]

#jushika
[voice id="v02239"]
それに彼女となら、良い関係が築けると思ったんです。[p]

[message_chara name="mahoru" face="thinking"]

#mahoru
[voice id="v02240"]
（小出里亜さんとそんなことが……）[p]

[reset_message_chara]

; 行方の分からない娘のことを聞いた
[set_item_status id="chara_03" secret="true"]
[get_item id="chara_03" type="info"]

[jump target="*s7_jushika_hub"]

*s7_jushika_t3r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="jushika" face="thinking" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02241"]
（朱志香さんと小出里亜さん、本当に仲が良かったのに……）[p]
[reset_message_chara]
[jump target="*s7_jushika_hub"]


;===========================================
; 珠璃 トピックハブ
;===========================================
;===========================================
; 朱志香 トピック④ ── お茶会の紅茶について
;===========================================
*s7_jushika_t4
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="jushika" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_jushika_tea=1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02242"]
朱志香さん。お茶会の紅茶って、どなたが用意されたんですか？[p]
[reset_message_chara]

#jushika
[voice id="v02243"]
紅茶を淹れたのは私です。[p]

#jushika
[voice id="v02244"]
一杯ずつ用意して、それを珠璃さんに渡しました。[p]

#jushika
[voice id="v02245"]
珠璃さんが皆さんのところへ運んでくださいました。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02246"]
珠璃さんが……[p]
[reset_message_chara]

#jushika
[voice id="v02247"]
ええ。小出里亜さんは手を火傷していましたから。[p]

#jushika
[voice id="v02248"]
お客様に運んでいただくのは、心苦しかったのですけれど。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02249"]
淹れるところは、どなたか見ていましたか？[p]
[reset_message_chara]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v02250"]
……いいえ。私が一人で淹れて、そのままお渡ししました。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02251"]
ありがとうございます。[p]
[reset_message_chara]

[jump target="*s7_jushika_hub"]

*s7_jushika_t4r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="jushika" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02252"]
（淹れたのは朱志香さん。一杯ずつ渡して、運んだのは珠璃さん。）[p]
[reset_message_chara]
[jump target="*s7_jushika_hub"]

;-----------------------------------------------------------
; 朱志香 ── 「薬学研究」の書類について
;   資料室の整理リストを見つけると解放。
;   真歩流の狙いは「愛理に使われた毒を特定すること」であって、
;   朱志香を疑うことではない。ここでは SNS 出品の事実だけが残る。
;-----------------------------------------------------------

*s7_jushika_t5
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_jushika_book=1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02253"]
朱志香さん。少しだけ、いいですか。[p]
[reset_message_chara]

#jushika
[voice id="v02254"]
……ええ。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02255"]
資料室で、整理済みの書類の一覧を見つけました。[p]
[reset_message_chara]

#jushika
[voice id="v02256"]
ああ……主人の遺品を片づけたときの控えですね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02257"]
その中に「薬学研究」という項目がありました。[p]

#mahoru
[voice id="v02258"]
あの書類、今はどこにありますか。[p]
[reset_message_chara]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v02259"]
……どうして、そんなことを？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02260"]
愛理に使われた毒が、まだ何なのか分からないんです。[p]

#mahoru
[voice id="v02261"]
薬の資料なら、何か書いてあるかもしれない。[p]

#mahoru
[voice id="v02262"]
可能性が少しでもあるなら、確かめておきたくて。[p]
[reset_message_chara]

#
朱志香はしばらく黙っていた。[r]
#
それから、申し訳なさそうに目を伏せた。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v02263"]
……お力になれません。[p]

#jushika
[voice id="v02264"]
あれは、もう手元にないんです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02265"]
え……[p]
[reset_message_chara]

#jushika
[voice id="v02266"]
遺品を整理したとき、まとめてSNSに出したんです。[p]

#jushika
[voice id="v02267"]
家財も、書類も。とても抱えきれる量ではなくて。[p]

#jushika
[voice id="v02268"]
中身までは、私も見ていません。[p]

#jushika
[voice id="v02269"]
目録に書いた「薬学研究」も、束の表書きのままです。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02270"]
その束は、今どこに……[p]
[reset_message_chara]

#jushika
[voice id="v02271"]
出品したその日のうちに、売れてしまいました。[p]

#jushika
[voice id="v02272"]
本当に、あっという間に。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02273"]
あっという間に……[p]
[reset_message_chara]

#jushika
[voice id="v02274"]
ええ。買われた方のお名前も、もう残っていません。[p]

#jushika
[voice id="v02275"]
お役に立てなくて、ごめんなさいね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02276"]
……いえ。ありがとうございます。[p]
[reset_message_chara]

#
この館にあった薬の資料は、事件の前に誰かの手へ渡っている。[r]
#
それが分かっただけでも、無駄ではないはずだった。[p]

[if exp="f.status['drag_book'].owned == true"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02277"]
（和人の本と、同じものだったのかな）[p]

#mahoru
[voice id="v02278"]
（それとも……ぜんぜん違うものだったのかな）[p]
[reset_message_chara]
[endif]

[jump target="*s7_jushika_hub"]

*s7_jushika_t5r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02279"]
（「薬学研究」の書類は、遺品整理のときにSNSで売られていた。）[p]

#mahoru
[voice id="v02280"]
（買った相手の名前も、もう残っていない。）[p]
[reset_message_chara]

[jump target="*s7_jushika_hub"]


*s7_juri_hub
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[eval exp="tf.inv_talk = 'juri'"]
[jump target="*s7_living"]

*s7_juri_t1
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="juri" face="cry" num="0"]
[advance_time min=2]
[eval exp="f.s7_juri_1=1"]
[eval exp="f.s7_kazuto_secret=1"]
#juri
[voice id="v02281"]
どうして……どうして叡留久が……[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02282"]
珠璃さん……一つ聞かせてください。小出里亜さんから何か聞いたりしていませんか？[p]

[reset_message_chara]

#juri
[voice id="v02283"]
……そういえば。小出里亜さんが和人のことを話していたわ。[p]
#juri
[voice id="v02284"]
『和人様は何かを隠している』って……女の勘だと言っていたけれど。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02285"]
和人が何かを隠している……[p]
[reset_message_chara]

#juri
[voice id="v02286"]
もう、いいかしら。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v02287"]
はい、ありがとうございます、珠璃さん。[p]
[reset_message_chara]

[jump target="*s7_juri_hub"]

*s7_juri_t1r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="juri" face="cry" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02288"]
（小出里亜さんは和人が何かを隠していると感じていたというけど……）[p]
[reset_message_chara]
[jump target="*s7_juri_hub"]

*s7_juri_t2
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="juri" face="cry" num="0"]
[advance_time min=2]
[eval exp="f.s7_juri_2=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02289"]
珠璃さん……叡留久さんのスマートフォンのパスワードって知っていますか？[p]
[reset_message_chara]
#juri
[voice id="v02290"]
彼の誕生日10月28日から取って、1028よ。[p]

#juri
[voice id="v02291"]
……もうすぐ誕生日だったのにね。[p]

#
真歩流は「1028」を入力してみると——ロックが解除された。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02292"]
……あれ？[p]
[reset_message_chara]

#
画面には、初期設定の壁紙だけが並んでいた。[r]
#
連絡先も、写真も、履歴も、何ひとつ残っていない。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02293"]
中身が……何もない。[p]

#mahoru
[voice id="v02294"]
初期化されてる……？[p]
[reset_message_chara]

[chara_mod name="juri" face="surprised"]
; ▼ 要ボイス再録：v02295（旧「そんなはずないわ。今朝も使っていたもの。」）
#juri
[voice id="v02295"]
そんなはずないわ。ついさっきまで使っていたもの。[p]

[mask]
[chara_hide_all]
[charapos name="reido" face="thinking" num=0]
[mask_off]

#reido
[voice id="v02296"]
拝見します。[p]

#
零度警部は画面を確かめると、静かに息を吐いた。[p]

#reido
[voice id="v02297"]
……確かに、消されていますね。[p]

#reido
[voice id="v02298"]
遠隔でも、手元でも、手順さえ知っていれば数分でできます。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02299"]
誰かが、消したってことですか。[p]
[reset_message_chara]

#reido
[voice id="v02300"]
犯人が痕跡を消したと考えるのが自然でしょう。[p]

#reido
[voice id="v02301"]
連絡先も履歴も残っていません。ずいぶん用心深い方のようですね。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v02302"]
（用心深い……？）[p]
[reset_message_chara]

[mask]
[chara_hide_all]
[charapos name="juri" face="cry" num="0"]
[mask_off]

#juri
[voice id="v02303"]
あの人、本当に仕事ばかりだったの。[p]

#juri
[voice id="v02304"]
叡留久のビジネスのために……少しでも役に立てればと思って。[p]

#juri
[voice id="v02305"]
SNSで格安だったから、薬の本を一気に購入したわ。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02306"]
（叡留久さんが「妻がSNSで薬の本を」と言っていたのは、このことか。）[p]
[reset_message_chara]

#juri
[voice id="v02307"]
叡留久のために買ったのに……。無駄になってしまったわね。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02308"]
珠璃さん……[p]
[reset_message_chara]

[eval exp="f.s7_phone_wiped=1"]

[chara_hide_all]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v02309"]
（叡留久さんの荷物も、見せてもらった方がいいかもしれない。）[p]
[reset_message_chara]

[jump target="*s7_juri_hub"]

*s7_juri_t2r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="juri" face="cry" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02310"]
（叡留久さんの誕生日：10月28日。スマホの中身は、きれいに消されていた。）[p]
[reset_message_chara]
[jump target="*s7_juri_hub"]


;===========================================
; 珠璃 トピック③ ── 紅茶を運んだことについて
;===========================================
*s7_juri_t3
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="juri" face="cry" num="0"]
[advance_time min=2]
[eval exp="f.s7_juri_3=1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02311"]
珠璃さん。お茶会の紅茶のことなんですけど。[p]

#mahoru
[voice id="v02312"]
朱志香さんから、珠璃さんが皆さんに配ってくださったと聞きました。[p]
[reset_message_chara]

#juri
[voice id="v02313"]
ええ。朱志香さんが紅茶を淹れて、私が受け取ったわ。[p]

#juri
[voice id="v02314"]
それを皆さんの席へ運んだだけよ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02315"]
どなたの分がどれか、分かっていましたか？[p]
[reset_message_chara]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v02316"]
席は決まっていたもの。順番に置いていっただけよ。[p]

#juri
[voice id="v02317"]
それが、どうかした？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02318"]
……いえ。ありがとうございます。[p]
[reset_message_chara]

[jump target="*s7_juri_hub"]

*s7_juri_t3r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="juri" face="cry" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02319"]
（紅茶を淹れたのは朱志香さん。席まで運んだのは珠璃さん。）[p]
[reset_message_chara]
[jump target="*s7_juri_hub"]


;===========================================
; メアリー トピックハブ
;===========================================
*s7_mary_hub
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[eval exp="tf.inv_talk = 'mary'"]
[jump target="*s7_living"]

*s7_mary_t1
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="mary" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_mary_1=1"]
#mary
[voice id="v02320"]
叡留久さんまで……どうして。[p]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02321"]
メアリーさん、大丈夫ですか？[p]
[reset_message_chara]
[chara_mod name="mary" face="smile"]
#mary
[voice id="v02322"]
真歩流さんこそ……辛いのに、私のことを気にかけてくれて。[p]
#mary
[voice id="v02323"]
でも……二人が亡くなったということは、二人に何か共通することがあるはずではないかと。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02324"]
（二人の共通点——お茶会で同じ場所にいたということ？）[p]
[reset_message_chara]
[jump target="*s7_mary_hub"]

*s7_mary_t1r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="mary" face="thinking" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02325"]
（二人の共通点を探す——それがヒントになるかもしれない。）[p]
[reset_message_chara]
[jump target="*s7_mary_hub"]

*s7_mary_t2
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="mary" face="normal" num="0"]
[advance_time min=2]
[eval exp="f.s7_mary_2=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02326"]
メアリーさん、どうして愛理に紅茶をあげたんですか？[p]
#mahoru
[voice id="v02327"]
おいしい紅茶だったのに。[p]
[reset_message_chara]
#mary
[voice id="v02328"]
……香りがあまり好みではなくて。私、香水を作るので香りには敏感なんです。[p]

#mary
[voice id="v02329"]
あの紅茶の香り——普通のハーブとは少し違う独特な香りだったので……[p]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02330"]
私は美味しかったですけど、メアリーさんには合わなかったんですね。[p]
#mahoru
[voice id="v02331"]
（香りが独特……？ 高級感のある紅茶の香りだったけど、苦手なのかな？）[p]
[reset_message_chara]

;── 交換された当のカップを証拠として押さえる ──
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02332"]
そのカップ、まだ残っていますか？[p]
[reset_message_chara]

#mary
[voice id="v02333"]
いえ、もう片づけられていて、他のカップと混ざっています。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02334"]
一応、警察に調べてもらいましょう。[p]
[reset_message_chara]

[mask time=600 effect="fadeIn" color="0x000000"]
[wait time=400]
[mask_off time=900]


#
鑑識が保全していた、お茶会で使われたカップを一つ一つ丁寧に調査してもらった。[p]

@chara_hide_all

#警察
メアリーさんの指紋が付いたカップが見つかりました。[p]

#警察
調査の結果、このカップの縁から非常に微量ではありますが、薬物反応が出ました。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02335"]
えっ！？　カップから薬物反応……！[p]
[reset_message_chara]

#警察
セージに近い成分を含んでいます。[p]

#警察
飲んだ時についたのか、それとも元々カップに付着していたのかまでは、まだ断定できません。[p]

#

[set_item_status id="tea_cup" owned="true" secret="true"]
[get_item id="tea_cup"]

[if exp="f.route_b != 1"]
[eval exp="f.s7_koderia_cup_clue=1"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02336"]
（待って。メアリーさんのカップを、指紋から見つけられたんだ。）[p]

#mahoru
[voice id="v02337"]
（だったら、小出里亜さんが使っていたカップも探せるんじゃない？）[p]

#mahoru
[voice id="v02338"]
（小出里亜さんは、倒れる直前に一度ダイニングへ来ている。）[p]

#mahoru
[voice id="v02339"]
（もし、あのカップからも同じ薬物が出たら——。）[p]

#mahoru
[voice id="v02340"]
（零度警部に頼んでみよう。）[p]
[reset_message_chara]
[endif]

[jump target="*s7_mary_hub"]

*s7_mary_t2r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="mary" face="normal" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[if exp="f.route_b != 1 && f.s7_koderia_cup_clue==1"]
#mahoru
[voice id="v02341"]
（メアリーさんのカップから薬物反応が出た。小出里亜さんのカップも、指紋から探せるかもしれない。）[p]
[else]
#mahoru
[voice id="v02342"]
（メアリーさんは紅茶の香りが合わなくて、愛理に紅茶を渡したんだよね。）[p]
[endif]
[reset_message_chara]
[jump target="*s7_mary_hub"]

*s7_mary_t3
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="mary" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_mary_3=1"]
; メアリーの目的を知った（scene4 のメアリー会話と同じ共通フラグ）
[eval exp="f.true_flag_mary=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02343"]
メアリーさん、勝手に持ち出してごめんなさい。[p]
#mahoru
[voice id="v02344"]
スーツケースの中に、英語の手紙が入っていたのが気になって。これ、どんな内容なんですか？[p]
[reset_message_chara]
#mary
[voice id="v02345"]
……差出人不明の手紙で。内容は——。[p]
#mary
[voice id="v02346"]
『日本の舞黒館に来れば、親戚のことについて知ることができる。』[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02347"]
その手紙を読んできたんですか？[p]
[reset_message_chara]
#mary
[voice id="v02348"]
ええ。[p]

#mary
[voice id="v02349"]
……もしかしたら、親戚を見つける手がかりになるかもしれない。だから、この宿泊イベントに参加したんです。[p]
; 手紙の内容を聞いたので、手帳の手紙とメアリーに追加情報を出す
[set_item_status id="letter" owned="true" secret="true"]
[set_item_status id="chara_07" secret="true"]
[get_item id="letter" type="info"]
[get_item id="chara_07" type="info"]
[jump target="*s7_mary_hub"]

*s7_mary_t3r
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="mary" face="thinking" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02350"]
（メアリーさんは差出人不明の手紙でここに呼ばれた——誰が、何のために？）[p]
[reset_message_chara]
[jump target="*s7_mary_hub"]


;--------------------------------------------------
; リビング：部屋を調べる
;--------------------------------------------------
*s7_living_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_living"]

*s7_evt_sofa
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[layopt layer="message0" visible=true]
[charapos name="reido" face="normal" num="0"]
[if exp="f.s7_sofa==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02351"]
（ここで叡留久さんのスマホを見つけた。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_living_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_sofa=1"]
[eval exp="f.s7_eruku_phone=1"]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02352"]
ソファのクッションの隙間に……スマートフォンだ！[p]
[reset_message_chara]
#reido
[voice id="v02353"]
叡留久さんのものですね。パスワードを調べる必要がありそうです。珠璃さんに聞いてみてはいかがでしょう。[p]
[get_item id="eruku_phone"]
[iscript]
f.status["eruku_phone"].owned = true;
[endscript]
[jump target="*s7_living_investigate"]

*s7_evt_fireplace
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[layopt layer="message0" visible=true]
[if exp="f.s7_fireplace==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02354"]
（暖炉は使われてなかった。落ちてたのは、食べ物の小さな欠片だけ）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_living_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_fireplace=1"]

#
暖炉を確認した。灰は冷え切っていて、今日使われた形跡はない。[p]

#
その場を離れようとした時、炉の脇に小さな欠片が落ちているのが目に入った。[r]
#
拾ってみると、クッキーの欠片だった。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02355"]
クッキー……。[p]

#mahoru
[voice id="v02356"]
もし毒が口から入ったんだとしたら、愛理が今日、何を食べて何を飲んだのか整理した方がいいのかも。[p]

#mahoru
[voice id="v02357"]
お茶会の時、私が気づかなかったこともあるはず。[p]

#mahoru
[voice id="v02358"]
……まず愛理に、何を口にしたのか聞いてみよう。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_living_investigate"]

;-------------------------------------------------------------------------------
; 1F ダイニング：食器棚
; 「食器全部が原因」仮説を弱める否定証拠
;-------------------------------------------------------------------------------

*s7_evt_carpet
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[layopt layer="message0" visible=true]

[if exp="f.s7_carpet==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02359"]
（ポットの蓋——ここからセージの成分が見つかった。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_kitchen_investigate"]
[endif]

[advance_time min=1]
[eval exp="f.s7_carpet=1"]

#
調理台の上に、お茶会で使われたポットが置かれていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02360"]
（お昼、小出里亜さんがこれで火傷したんだ。）[p]

#mahoru
[voice id="v02361"]
（蓋が開いて、お湯が手にかかって……）[p]

#mahoru
[voice id="v02362"]
鑑識さん、このポットを調べてもらえますか？[p]
[reset_message_chara]

#
警察の鑑識の人に調べてもらった。[p]

#警察
……持ち手から、植物由来の成分が検出されました。[p]

#警察
恐らくセージのような成分です。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02363"]
ポットの持ち手からセージの成分？[p]
[reset_message_chara]

#警察
拭き取られた形跡もあります。[p]
#警察
表面は綺麗にされていますが、縁の隙間までは落としきれていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02364"]
（どうして、持ち手にセージの成分が……？）[p]
[reset_message_chara]

[get_item name="ポットの蓋に残っていた成分" type="clue"]
[eval exp="f.s7_fingerprint=1"]
[jump target="*s7_kitchen_investigate"]


;===========================================
; 1F ── ダイニング
;===========================================

*s7_dining
[cm]
[inv_set chapter="s7"]
[bg storage="dining_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:ダイニング"]

#
夜のダイニング。お茶会の跡が残っており、警察の鑑識シートが貼られていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="dining"]

*s7_dining_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_dining"]

*s7_evt_dishes
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[layopt layer="message0" visible=true]
[if exp="f.s7_dishes==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02365"]
（食器全部が原因なら、被害はもっと広がってるはず。少なくとも、全部が汚れてたわけじゃなさそう）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_dining_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_dishes=1"]

#
食器棚には、同じ意匠のカップや皿が綺麗に並んでいた。[r]
#
お茶会で使われた食器も、回収された後ここに混ざっている。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02366"]
もし、この食器そのものに毒が付いていたのなら……どうして私たちは無事なんだろう。[p]

#mahoru
[voice id="v02367"]
みんな同じ種類の食器を使っていた。[p]

#mahoru
[voice id="v02368"]
食器が全部汚れてたなら、もっとたくさんの人に被害が出てるはずだよね。[p]

#mahoru
[voice id="v02369"]
……少なくとも、食器みんなに同じ仕掛けがしてあったわけじゃなさそう。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_dining_investigate"]

;-------------------------------------------------------------------------------
; 1F ダイニング：テーブル
; 被害者だけの「差分」を探すという捜査方針を提示
;-------------------------------------------------------------------------------

*s7_evt_dining_table
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[layopt layer="message0" visible=true]
[if exp="f.s7_dining_table==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02370"]
（被害を受けた人だけが触ったもの、口にしたもの――他の人との違いを探さないと）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_dining_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_dining_table=1"]

#
お茶会をした大きなテーブル。[r]
#
あの時は、みんながここに集まって同じ時間を過ごしていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02371"]
もし、この場所全体に毒が仕掛けられてたなら……もっとたくさんの人に被害が出てるはず。[p]

#mahoru
[voice id="v02372"]
でも、実際はそうじゃない。[p]

#mahoru
[voice id="v02373"]
被害を受けた人だけが触れたもの、口にしたもの――[p]

#mahoru
[voice id="v02374"]
何か、他の人とは違う行動があったんじゃないかな。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_dining_investigate"]

;-------------------------------------------------------------------------------
; 1F キッチン：コンロ
; 調理中の食事が直接の原因という仮説を鑑識で除外
;-------------------------------------------------------------------------------



*s7_kitchen
[cm]
[inv_set chapter="s7"]
[bg storage="kitchen_night_after_incident.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:キッチン"]

#
夜のキッチン。鑑識の調査が入った跡が残っている。[r]
#
床には白いシートが掛けられ、その前に警察官が一人、黙って立っていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="kitchen"]

*s7_kitchen_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_kitchen"]

*s7_evt_koderia_body
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[layopt layer="message0" visible=true]
[if exp="f.s7_koderia_body==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02375"]
（小出里亜さんの口から、セージに似た成分が出た。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_kitchen_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_koderia_body=1"]
[eval exp="f.s7_pf1=1"]

#
警察官がシートの端を、そっと持ち上げた。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02376"]
……小出里亜さん。[p]
[reset_message_chara]

#
昼と同じ制服のまま、小出里亜はそこに横たわっていた。[r]
#
右手の甲に、赤く残った火傷の跡が見える。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02377"]
鑑識さん。口の中を、調べてもらえますか。[p]
[reset_message_chara]

#警察
……唇と口の中から、セージに似た成分が検出されました。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02378"]
セージ……？　あの花のセージですか？[p]
[reset_message_chara]

#警察
似ている、というだけです。[p]

#警察
セージそのものに毒はありません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02379"]
（セージに近い、別の何か……）[p]

#mahoru
[voice id="v02380"]
（それに、この火傷。）[p]
[reset_message_chara]

[get_item name="小出里亜さんの口のセージ成分" type="clue"]

;── 経路B：エプロンのポケットに、口紅が残っている ──────────────
;   昼、火傷した手で押さえたときに外側へ毒が移った。
;   お茶会で落としたものを叡留久が拾い、拭ってから、
;   scene4 のキッチンで本人へ返している。だから彼の指紋が残る。
;   底の刻印「To E.／E.H.」が、贈り主が叡留久であることを示す。
;   経路Aの「流しのカップ（二人の指紋）」と同じ役割の物証。
[if exp="f.route_b == 1"]
; ▼ 以下、新規会話は要ボイス収録
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03841"]
鑑識さん。ポケットの中のものも、見せていただけますか。[p]
[reset_message_chara]

#警察
エプロンの前ポケットです。ハンカチと、これだけでした。[p]

#
差し出された袋に、小さな口紅が入っていた。[p]

#警察
外側から、ご遺体と同じ成分が出ています。[p]

#警察
繰り出した紅そのものからは出ていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03842"]
（外側だけ……。）[p]

#mahoru
[voice id="v03843"]
（毒のついた手で、これを掴んだってこと？）[p]
[reset_message_chara]

#
——お昼の、このキッチンの光景がよぎった。[r]
#
ポケットから跳ね出した何かを、小出里亜が火傷したほうの手で咄嗟に押さえていた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03844"]
（あれ、口紅だったんだ）[p]
[reset_message_chara]

#警察
それと——指紋が、二人分あります。[p]

#警察
灰音小出里亜さんと、穂在呂叡留久さんです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03845"]
叡留久さんの……？[p]
[reset_message_chara]

#警察
底に刻印もあります。[p]

#
袋ごと灯りにかざすと、細い文字が読めた。[p]

#
——To E.[r]
#
その下に、もっと小さく。E.H.[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03846"]
（イニシャル……）[p]
[reset_message_chara]

; 昼にキッチンで二人の会話を立ち聞きしていれば、ここで引っかかる
[if exp="f.event_kitchen_lip == 1"]
#
昼、キッチンの扉ごしに聞こえた声を思い出した。[p]

#
——ありがとうございます。[r]
#
——いいさ。手は大丈夫かい。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03847"]
（あのお礼……何に対してのお礼だったんだろう）[p]
[reset_message_chara]
[endif]

; 底の刻印から、贈り主が叡留久だと分かった
[set_item_status id="lip" owned="true" secret="true"]
[eval exp="f.s7_lipstick=1"]
[eval exp="f.s7_pf6=1"]
[get_item name="小出里亜さんの口紅" type="clue"]
[endif]
;── 経路B ここまで ──

[jump target="*s7_kitchen_investigate"]

;--- 流しのカップ ------------------------------------------
;   昼（scene4）、叡留久が小出里亜のカップで紅茶を飲み、そのまま返している。
;   経路A／B のどちらでも成立する（毒はこの時点で小出里亜の口に入っている）。
*s7_evt_kitchen_cup
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[layopt layer="message0" visible=true]
[if exp="f.s7_kitchen_cup==1"]
; ▼ 要ボイス収録
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03848"]
（流しのカップから、叡留久さんの指紋が出た。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_kitchen_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_kitchen_cup=1"]
; 毒物の手がかり⑥＝叡留久の摂取経路の物証。
; 経路Aはこの流しのカップ、経路Bは遺体の内ポケットの口紅がこれにあたる
[eval exp="f.s7_pf6=1"]

; ▼ 以下、新規会話は要ボイス収録
#
流しの縁に、ティーカップがひとつ置かれたままになっていた。[r]
#
洗い桶には浸けられておらず、底にわずかに紅茶が残っている。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03849"]
（几帳面な小出里亜さんが、洗わずに置いていくかな……）[p]
[reset_message_chara]

#mahoru
[voice id="v03850"]
鑑識さん。このカップ、調べてもらえますか。[p]

#警察
……指紋が二人ぶん出ました。[p]

#警察
ひとつは灰音小出里亜さん。もうひとつは——穂在呂叡留久さんのものです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03851"]
叡留久さんの……？[p]
[reset_message_chara]

#警察
持ち手と、縁。同じカップを二人が使っています。[p]

; 昼にキッチンで叡留久とすれ違っていれば、その場面を思い出す。
; 口紅を返しに行っていない周回では、真歩流は何も見ていないので思い出せない。
[if exp="f.event_kitchen_lip==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03852"]
（昼に、キッチンで会った。カップを持って出てくるところだった。）[p]

#mahoru
[voice id="v03853"]
（あれは……小出里亜さんのカップだったんだ。）[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03854"]
（叡留久さんが、小出里亜さんのカップで飲んでいた……？）[p]

#mahoru
[voice id="v03855"]
（そんなに近しかったなんて、誰からも聞いていない。）[p]
[reset_message_chara]
[endif]

[eval exp="f.s7_eruku_cup=1"]
[get_item name="流しのカップ" type="clue" memo="小出里亜が使っていたティーカップ。持ち手と縁から、小出里亜と叡留久の指紋が両方検出された。昼のうちに、二人が同じカップを使っている。"]
[jump target="*s7_kitchen_investigate"]


*s7_evt_kitchen_stove
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[layopt layer="message0" visible=true]
[if exp="f.s7_kitchen_stove==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02381"]
（コンロにも、調理中だったものにも、毒物やセージみたいな成分はなかった）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_kitchen_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_kitchen_stove=1"]

#
小出里亜が倒れた時、コンロにはまだ火が入っていた。[r]
#
鍋や調理器具も、その時の状態を保っている。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02382"]
倒れる直前まで料理をしてたなら、ここに何か残ってるかもしれない。[p]

#mahoru
[voice id="v02383"]
鑑識さん。コンロに掛かっていたものも調べてもらえますか？[p]
[reset_message_chara]

#警察
すでに確認しています。[p]

#警察
鍋の中身、調理器具、コンロ周辺から、毒物やセージに似た成分は検出されていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02384"]
……ってことは、少なくとも調理中のものが直接の原因ってわけじゃなさそう。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_kitchen_investigate"]

;-------------------------------------------------------------------------------
; 1F サンルーム：床下
; 正しい場所を早く調べただけで時間を失わないようにする
;-------------------------------------------------------------------------------

*s7_sunroom1
[cm]
[inv_set chapter="s7"]
[bg storage="sunroom_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:サンルーム1F"]

#
夜のサンルーム。窓の外には月明かりに照らされた暗い庭園が広がり、静けさが部屋を満たしていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[iscript]
// サンルーム内で前提となる痕跡を調べた直後にも、同じ画面で床板を表示する。
if(f.hidden_study_entered==1 && ((f.route_b!=1 && f.s7_sun1_floor==1) || (f.route_b==1 && f.s7_sun1_plant==1))){
  f.s7_sun1_floor2_open = 1;
}
[endscript]
[inv_room id="sunroom1"]

*s7_sunroom1_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_sunroom1"]

*s7_evt_sun1_floor
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(1F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_sun1_floor==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02385"]
（床の乾いた跡——ここからセージの成分が見つかった。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_sunroom1_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_sun1_floor=1"]
[eval exp="f.s7_pf4=1"]
#
床の一部に、何かが乾いた跡がある。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02386"]
ここ……何かこぼれた跡がある。鑑識さん、調べてもらえますか？[p]
[reset_message_chara]
#
警察の鑑識の人に調べてもらった。[p]

#警察
……セージに似た成分が検出されました。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02387"]
どうしてこんなところにセージが？[p]

#mahoru
[voice id="v02388"]
飾ってあったのかな？[p]

[reset_message_chara]

[get_item name="サンルーム床のセージ成分" type="clue"]
[jump target="*s7_sunroom1_investigate"]

*s7_evt_sun1_floor2
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(1F)"]
[layopt layer="message0" visible=true]

[if exp="f.base_ment_found==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02389"]
（床板の下に、もう一つの空間へ続くような鍵穴があった。）[p]
[reset_message_chara]
[advance_time min=1]
[eval exp="f.s7_sun1_floor2=1"]
[jump target="*s7_sunroom1_investigate"]
[endif]

; 経路Aでは床の毒の跡、経路Bでは鉢の調査をきっかけに、
; scene4 の館探索より細かく床面を見ることで初めて気づく。
[if exp="f.route_b != 1 && f.s7_sun1_floor==0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02390"]
今はまだ、この床を細かく見る理由がない。[p]
#mahoru
[voice id="v02391"]
先に、毒が残っていそうな場所を調べよう。[p]
[reset_message_chara]
[jump target="*s7_sunroom1_investigate"]
[endif]

[if exp="f.route_b == 1 && f.s7_sun1_plant==0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02392"]
今は事件の手がかりを優先しよう。[p]
#mahoru
[voice id="v02393"]
この辺りを詳しく調べるのは、何か気になるものを見つけてからでいい。[p]
[reset_message_chara]
[jump target="*s7_sunroom1_investigate"]
[endif]

[advance_time min=1]
[eval exp="f.s7_sun1_floor2=1"]
[eval exp="f.base_ment_found=1"]

#
毒の痕跡を見落とさないよう、床すれすれまで顔を近づけて確認していく。[p]
#
すると、床板の継ぎ目の一か所だけが、周囲とわずかに違って見えた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02394"]
……ここだけ、継ぎ目が不自然。[p]
[reset_message_chara]

#
指先でなぞると、板の端に小さなくぼみがある。[r]
#
埃を払うと、その奥から古びた小さな鍵穴が現れた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02395"]
鍵穴……？[p]

[if exp="f.hidden_study_entered==1"]
#mahoru
[voice id="v02396"]
……待って。[p]
#mahoru
[voice id="v02397"]
地下は、あの書斎だけじゃなかったの？[p]
[else]
#mahoru
[voice id="v02398"]
この下にも、何か空間がある……？[p]
[endif]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02399"]
今は愛理のことが先。[p]
#mahoru
[voice id="v02400"]
でも……これは覚えておこう。[p]
[reset_message_chara]

[get_item name="サンルーム床の隠し鍵穴" type="info"]
[jump target="*s7_sunroom1_investigate"]

*s7_evt_sun1_plant
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(1F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_sun1_plant==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02401"]
（観葉植物の鉢はもう調べた。鑑識の結果も聞いたよね）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_sunroom1_investigate"]
[endif]

[if exp="f.s7_kazuto_3==0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02402"]
大きな観葉植物の鉢……昼間も気になってた場所だよね。[p]

#mahoru
[voice id="v02403"]
でも、今の私じゃ何を調べればいいのか分からないかも。[p]

#mahoru
[voice id="v02404"]
もう少し毒物について情報を集めてから、ここへ戻ってこよう。[p]
[reset_message_chara]
[jump storage="scene7.ks" target="*s7_sunroom1_investigate"]
[endif]

[advance_time min=1]
[eval exp="f.s7_sun1_plant=1"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02405"]
和人からもらった本に書いてあった通りなら……[p]

#mahoru
[voice id="v02406"]
鑑識さんすみません。[p]

#mahoru
[voice id="v02407"]
この観葉植物の鉢、調べてもらえますか？[p]
[reset_message_chara]

#
警察の鑑識に調べてもらいました。[p]

[if exp="f.route_b == 1"]
#警察
……特に何も検出されませんでした。[p]

#警察
土も鉢の表面も、ごく普通の状態です。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02408"]
そう、ですか……[p]

#mahoru
[voice id="v02409"]
（本に書いてあった通りなら、ここだと思ったんだけどな）[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_sunroom1_investigate"]
[endif]

#警察
……毒性物質が微量ながら検出されました。この鉢に何かが混入していたようです。[p]

#警察
さらに――鉢の表面に指紋があります。採取して鑑定します。[p]

#警察
事件と関係があるか確認します。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02410"]
ありがとうございます。[p]

#mahoru
[voice id="v02411"]
ということは、誰かがサンルームの中で毒を捨てたんだ……[p]
[reset_message_chara]

[get_item name="観葉植物の鉢の毒性物質と指紋" type="clue"]
[eval exp="f.s7_pf5=1"]
[eval exp="f.s7_fingerprint = 1"]
[jump storage="scene7.ks" target="*s7_sunroom1_investigate"]

;-------------------------------------------------------------------------------
; 真白姉妹の部屋：愛理のベッドサイド
; 「別行動」ではなく「愛理だけが触れた／口にしたもの」へ絞る
;-------------------------------------------------------------------------------

*s7_rouka1
[cm]
[inv_set chapter="s7"]
[bg storage="hallway_night_after_incident.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:廊下(1F)"]

#
夜の廊下。警察官が行き来している。[r]
#
奥の壁際には白いシートが掛けられ、その周りだけ人が近づかない。[p]

[eval exp="f.s7_rouka1_seen=1"]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="rouka1"]

*s7_rouka1_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_rouka1"]


;-------------------------------------------------
; 1F廊下 ── 叡留久のご遺体
;-------------------------------------------------
*s7_evt_eruku_body
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:廊下(1F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_eruku_body==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02414"]
（叡留久さんの口からも、セージに似た成分が出た。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_rouka1_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_eruku_body=1"]
[eval exp="f.s7_pf2=1"]

#
警察官に断って、シートの端をめくってもらう。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02415"]
……叡留久さん。[p]
[reset_message_chara]

#
上着のポケットは裏返され、中身は鑑識の袋に移されていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02416"]
鑑識さん。口の中を調べてもらえますか。[p]

[reset_message_chara]

#警察
……セージに似た成分が検出されました。[p]

#警察
唇の内と外側からです。[p]

; ▼ 以下、新規会話は要ボイス収録
;    叡留久は昼に小出里亜のカップで紅茶を飲み、そのうえで直接口づけている。
;    「触れただけ」ではなく「口にした」痕跡が残っている、という報告に改める。
#警察
唇の外だけなら、触れた程度で済みます。[p]

#警察
ですが、内側にも残っています。口に含んでいます。[p]

[message_chara name="mahoru" face="thinking"]
; ▼ 要ボイス再録：v02417（旧「（触れた程度で、人が亡くなるの……？）」）
#mahoru
[voice id="v02417"]
（口に含んだ……？　でも、叡留久さんはずっとリビングやダイニングにいた。）[p]

; ▼ 要ボイス再録：v02418（旧「（ううん。それだけ強いってことだ。）」）
#mahoru
[voice id="v02418"]
（じゃあ——どこで、何を口にしたの。）[p]
[reset_message_chara]

; 経路A：カップの指紋を先に見つけていれば、ここで繋がる
[if exp="f.s7_eruku_cup==1"]
; ▼ 要ボイス収録
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03856"]
（流しのカップ。小出里亜さんと、叡留久さんの指紋。）[p]

#mahoru
[voice id="v03857"]
（同じカップで、紅茶を飲んでいた——）[p]
[reset_message_chara]
[endif]

[get_item name="叡留久さんの口のセージ成分" type="clue"]
[jump target="*s7_rouka1_investigate"]


*s7_rouka2
[cm]
[inv_set chapter="s7"]
[bg storage="hallway_second_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:廊下(2F)"]

#
夜の2階廊下。各部屋の扉が並んでいる。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="rouka2"]

*s7_rouka2_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_rouka2"]


;-------------------------------------------------
; 2F廊下 ── ステンドグラス
;-------------------------------------------------
*s7_evt_rouka2_glass
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:廊下(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_rouka2_glass==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02419"]
（庭にいたこと自体が原因なら、愛理だけが倒れた説明にならないよね。やっぱり「愛理だけの違い」を探さないと）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_rouka2_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_rouka2_glass=1"]

#
突き当たりの大きなステンドグラス。[r]
#
夜は色が沈み、硝子の向こうに庭の暗い輪郭がぼんやりと見える。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02420"]
そういえば、昼間はみんなで庭にも出た。[p]

#mahoru
[voice id="v02421"]
もし庭の植物に触れた時に毒が付いたのだとしたら……？[p]

#mahoru
[voice id="v02422"]
……ううん、私も愛理と同じ庭を歩いてる。それだけじゃ、愛理だけが倒れた説明にならないよね。[p]

#mahoru
[voice id="v02423"]
やっぱり、愛理だけが触ったものや口にしたものを探さないと。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_rouka2_investigate"]

*s7_evt_gimmick_lid
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:廊下(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_gimmick_lid==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02424"]
（仕掛けの蓋から、毒物の成分が出た。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_rouka2_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_gimmick_lid=1"]

#
壁の腰の高さに、真鍮の小さな蓋がある。[r]
#
昼にみんなで開けて、叡留久が手の甲を叩かれたあの仕掛けだ。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02425"]
（あのとき、珠璃さんはボールペンを持ってきた。）[p]

#mahoru
[voice id="v02426"]
鑑識さん。ここも調べてもらえますか。[p]
[reset_message_chara]

#警察
……検出されました。[p]

#警察
蓋の縁から——毒性のある成分です。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02427"]
毒……ここに？[p]
[reset_message_chara]

#警察
ごく微量です。何かが触れて、移った程度でしょう。[p]

#警察
指紋は検出されません。拭き取られています。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02428"]
（触れて、移った。）[p]

#mahoru
[voice id="v02429"]
（ボールペンで仕掛けの蓋を開けていた。）[p]

#mahoru
[voice id="v02430"]
（じゃあ——あのボールペンは、その前にどこを触っていたの。）[p]
[reset_message_chara]

[get_item name="仕掛けの蓋の毒性成分" type="clue"]
[eval exp="f.s7_pf5=1"]
[jump target="*s7_rouka2_investigate"]


;===========================================
; 2F ── 宿泊部屋（扉選択 → 各室）
;===========================================

*s7_bedroom
[cm]
[inv_set chapter="s7"]
[bg storage="bedroom_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:宿泊部屋(2F)"]

#
宿泊部屋の並ぶ一角。どの扉の前にも、警察官が一人ずつ立っていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02431"]
（部屋ごとに立ち合ってもらえる。どこから調べよう。）[p]
[reset_message_chara]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_wing id="bedroom"]


;--------------------------------------------------
; 宿泊部屋：穂在呂夫妻の部屋
;--------------------------------------------------
;--------------------------------------------------
; 宿泊部屋：メインルーム（各室へつながる共用スペース）
;--------------------------------------------------
*s7_bd_main
[cm]
[inv_set chapter="s7"]
[bg storage="bedroom_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]

#
四つの扉に囲まれた、共用のメインルーム。[r]
#
どの部屋へ入るにも、必ずここを通ることになる。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="bd_main"]

*s7_bd_main_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_bd_main"]


;-------------------------------------------------
; メインルーム ── 棚のボールペン（経路Bのみ）
;   拭かれていて指紋がひとつも出ない。なぜ拭いたのかを問答で詰める
;-------------------------------------------------
*s7_evt_main_shelf
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_main_shelf==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02432"]
（棚のボールペン——指紋がひとつも出なかった。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_bd_main_investigate"]
[endif]
[advance_time min=1]
[eval exp="f.s7_main_shelf=1"]

#
部屋の隅の棚。[r]
#
その端に、ボールペンが一本だけ置き忘れられていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02433"]
鑑識さん。これも調べてもらえますか。[p]
[reset_message_chara]

#警察
……何も検出されません。[p]

#警察
指紋もひとつも出ません。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02434"]
指紋も、ですか？[p]
[reset_message_chara]

#警察
ええ。きれいに拭き取られています。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02435"]
（このボールペン……）[p]

#mahoru
[voice id="v02436"]
（昼に、珠璃さんが持ってきたものに似ている気がする。）[p]

#mahoru
[voice id="v02437"]
（……でも、似ているだけかな。）[p]
[reset_message_chara]

[set_item_status id="ballpen" owned="true" secret="true"]
[get_item id="ballpen"]


;--- 問答① ボールペンは別のものか ------------------------
*s7_pen_q1
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s7_pen_q1_ok', text:'昼に珠璃さんが使っていたものと、同じ', kind:'look' });
tf.choices.push({ target:'*s7_pen_q1_ng', text:'見た目が似ているだけの、別のもの',   kind:'look' });
tf.pen_prompt = "このボールペンは、昼に見たものと同じだろうか。";
[endscript]
[stand_select storage="scene7.ks" se="decide.mp3" prompt="&tf.pen_prompt"]

*s7_pen_q1_ng
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02438"]
（別のもの……？）[p]

#mahoru
[voice id="v02439"]
（ううん。この棚に、他の誰かがペンを置いていく理由がない。）[p]
[reset_message_chara]
[jump target="*s7_pen_q1"]

*s7_pen_q1_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02440"]
（同じだ。）[p]

#mahoru
[voice id="v02441"]
（あの仕掛けの鍵を押すのに使って、そのまま持っていたはず。）[p]
[reset_message_chara]

;--- 問答② なぜ指紋が出ないのか --------------------------
*s7_pen_q2
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s7_pen_q2_ok', text:'誰かが指紋を拭き取ったから',       kind:'look' });
tf.choices.push({ target:'*s7_pen_q2_ng', text:'握っていないから、そもそも付かない', kind:'look' });
tf.pen_prompt = "どうして、このペンからは指紋がひとつも出ないんだろう。";
[endscript]
[stand_select storage="scene7.ks" se="decide.mp3" prompt="&tf.pen_prompt"]

*s7_pen_q2_ng
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02442"]
（ううん、それはない。）[p]

#mahoru
[voice id="v02443"]
（私たちは全員、珠璃さんがそのペンを握って使ったところを見ている。）[p]
[reset_message_chara]
[jump target="*s7_pen_q2"]

*s7_pen_q2_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02444"]
（拭き取られている。）[p]

#mahoru
[voice id="v02445"]
（使ったところは、みんなが見ていたのに。）[p]
[reset_message_chara]

;--- 問答③ なぜ拭いたのか --------------------------------
*s7_pen_q3
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s7_pen_q3_ok', text:'ペンが何かで汚れてしまったから', kind:'look' });
tf.choices.push({ target:'*s7_pen_q3_ng', text:'指紋を残したくなかったから',     kind:'look' });
tf.pen_prompt = "拭いた理由は、なんだろう。";
[endscript]
[stand_select storage="scene7.ks" se="decide.mp3" prompt="&tf.pen_prompt"]

*s7_pen_q3_ng
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02446"]
（それなら、棚に置きっぱなしにはしない。）[p]

#mahoru
[voice id="v02447"]
（持って帰るか、捨てるかするはずだもの。）[p]
[reset_message_chara]
[jump target="*s7_pen_q3"]

*s7_pen_q3_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋 メインルーム(2F)"]
[chara_hide_all wait="false"]
[eval exp="f.s7_pen_logic=1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02448"]
（汚れたから、拭いた。）[p]

#mahoru
[voice id="v02449"]
（拭いたら、指紋まで一緒に消えてしまった。）[p]
[reset_message_chara]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02450"]
（……でも、これだけじゃ何で汚れたのか分からない。）[p]

#mahoru
[voice id="v02451"]
（あの仕掛けを解いたときに、汚れたのかな。）[p]
[reset_message_chara]

[jump target="*s7_bd_main_investigate"]



;--------------------------------------------------
; 宿泊部屋：穂在呂夫妻の部屋
;--------------------------------------------------
*s7_bd_hozairo
[cm]
[inv_set chapter="s7"]
[bg storage="room_hoaro_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:穂在呂夫妻の部屋(2F)"]

#
穂在呂夫妻の部屋。主を失った荷物が、そのまま壁際に残されていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="bd_hozairo"]


;--------------------------------------------------
; 宿泊部屋：和人の部屋
;--------------------------------------------------
*s7_bd_kazuto
[cm]
[inv_set chapter="s7"]
[bg storage="room_kazuto_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:和人の部屋(2F)"]

#
和人の部屋。本人は愛理に付き添っていて、部屋は無人だった。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="bd_kazuto"]


;--------------------------------------------------
; 宿泊部屋：メアリーの部屋
;--------------------------------------------------
*s7_bd_mary
[cm]
[inv_set chapter="s7"]
[bg storage="room_mary_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:メアリーの部屋(2F)"]

#
メアリーの部屋。夜になっても、強い花の香りが部屋に残っていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="bd_mary"]


;--------------------------------------------------
; 宿泊部屋：真白姉妹の部屋（愛理と、付き添う和人）
;--------------------------------------------------
*s7_bd_mashiro
[cm]
[inv_set chapter="s7"]
[bg storage="room_mashiro_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:真白姉妹の部屋(2F)"]
[charapos name="kazuto" face="normal" num="0"]

#
私と愛理の部屋では、和人が愛理のそばに静かに付き添っていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="bd_mashiro"]


;--------------------------------------------------
; キャラクター選択
;--------------------------------------------------
*s7_bedroom_chara
[jump target="*s7_bd_mashiro"]


;===========================================
; 和人 トピックハブ
;===========================================
*s7_kazuto_hub
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[eval exp="tf.inv_talk = 'kazuto'"]
[jump target="*s7_bd_mashiro"]

*s7_kazuto_t1
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all wait="false"]
[charapos name="kazuto" face="normal" num="0" wait="false"]
[advance_time min=2]
[eval exp="f.s7_kazuto_1=1"]
#kazuto
[voice id="v02452"]
妹のことは任せろ。[p]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02453"]
……うん。絶対に見つけてくる。[p]
[reset_message_chara]

#kazuto
[voice id="v02454"]
調査をするときはまずは、被害者から調べるのがいいだろう。[p]

#kazuto
[voice id="v02455"]
直前に居た場所なんかも手がかりになるかもしれない。[p]

#kazuto
[voice id="v02456"]
原因がわからないことには話が進まないからな。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02457"]
わかった。ありがとう。[p]
[reset_message_chara]

[jump target="*s7_kazuto_hub"]

*s7_kazuto_t1r
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[charapos name="kazuto" face="normal" num="0"]
#kazuto
[voice id="v02458"]
早く毒物を特定してくれ。[p]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t2
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_kazuto_2=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02459"]
和人……珠璃さんから聞いた。小出里亜さんが和人が何かを隠しているって言っていたって。[p]

#mahoru
[voice id="v02460"]
何かあるの？[p]
[reset_message_chara]
#kazuto
[voice id="v02461"]
小出里亜の奴、そんなことを言っていたのか……[p]

#kazuto
[voice id="v02462"]
鋭いんだか、何だかな。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02463"]
和人……？[p]
[reset_message_chara]

#kazuto
[voice id="v02464"]
……朱志香の夫、富礼知——あいつが俺の母親を死に追いやった。[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02465"]
えっ……[p]
[reset_message_chara]
#kazuto
[voice id="v02466"]
詳細は言わない。ただ——だから俺はこの館が気になってきた。朱志香のことを、どこかで目の敵にしていた。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02467"]
（和人の動機……でも、だからといって和人が犯人とは限らない。）[p]
[reset_message_chara]

; 母親を亡くした経緯を聞いた
[set_item_status id="chara_08" secret="true"]
[get_item id="chara_08" type="info"]

[jump target="*s7_kazuto_hub"]

*s7_kazuto_t2r
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[charapos name="kazuto" face="thinking" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02468"]
（富礼知が和人の母親を死に追いやった——それがここに来た理由。）[p]
[reset_message_chara]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t3_intro
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_kazuto_3_intro=1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02469"]
和人、三か所からセージに似た成分が見つかった。[p]

#mahoru
[voice id="v02470"]
でも、普通のセージには毒がないんだよね。[p]

#mahoru
[voice id="v02471"]
違う品種だったのか、何かを混ぜたのか——私にはそこまで分からなくて。[p]
[reset_message_chara]

#kazuto
[voice id="v02472"]
その考え方でいい。[p]

#kazuto
[voice id="v02473"]
セージそのものは無害でも、品種や混ぜた物質によって性質が変わることはある。[p]

#kazuto
[voice id="v02474"]
何か、不自然な液体や容器は見つからなかったか？[p]

[if exp="f.s7_wet_bottle==1"]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02475"]
そういえば、気になるものを見つけた。[p]
[reset_message_chara]
[jump target="*s7_kazuto_bottle_select"]
[endif]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02476"]
まだ見つけてない……。[p]
[reset_message_chara]

#kazuto
[voice id="v02477"]
何かを混ぜたなら、調合や持ち運びに使った容器があるはずだ。[p]

#kazuto
[voice id="v02478"]
中身を捨てても、容器までは消えていないかもしれない。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02479"]
分かった。液体を入れられるものや、洗った跡があるものを探してみる。[p]
[reset_message_chara]

[notify_info text="和人から『不自然な液体・容器』を探すよう助言されました。"]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t3_intror
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]

[if exp="f.s7_sage_request==1"]
#kazuto
[voice id="v02480"]
零度警部にアルコール実験を頼め。急いで。[p]
[jump target="*s7_kazuto_hub"]
[endif]

#kazuto
[voice id="v02481"]
セージに何かを混ぜたなら、使った容器が残っているはずだ。[p]

#kazuto
[voice id="v02482"]
液体を入れられるものや、洗った跡があるものを探してみろ。[p]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t3
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]

[if exp="f.s7_sage_request==1"]
#kazuto
[voice id="v02483"]
もう零度警部にアルコール実験を頼めるはずだ。[p]
[jump target="*s7_kazuto_hub"]
[endif]

[if exp="f.s7_wet_bottle==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02484"]
和人。不自然な容器を見つけたかもしれない。[p]
[reset_message_chara]
[jump target="*s7_kazuto_bottle_select"]
[endif]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02485"]
まだ、不自然な容器は見つけられてない。[p]
[reset_message_chara]

#kazuto
[voice id="v02486"]
なら、まだこの話は終わってない。[p]

#kazuto
[voice id="v02487"]
液体を入れられるものや、洗った跡があるものを探してみろ。[p]

[notify_info text="『不自然な液体・容器について』は未解決です。"]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t3r
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]

[if exp="f.s7_sage_request==1"]
#kazuto
[voice id="v02488"]
零度警部にアルコール実験を頼め。急いで。[p]
[jump target="*s7_kazuto_hub"]
[endif]

#kazuto
[voice id="v02489"]
不自然な容器が見つかったら、もう一度持ってきてくれ。[p]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_bottle_select
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02490"]
（見つけたものの中で、不自然な液体や容器は——。）[p]
[reset_message_chara]

[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'bottle'"]
[jump target="*s7_kazuto_bottle_correct"]
[endif]

[show_menu]
[bg storage="room_mashiro_night.png"]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02491"]
これは……違うかな。[p]
[reset_message_chara]

#kazuto
[voice id="v02492"]
セージに何かを混ぜたなら、その液体を入れていた容器があるはずだ。[p]

#kazuto
[voice id="v02493"]
洗われているものがないか、もう一度考えてみろ。[p]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_bottle_correct
[show_menu]
[eval exp="f.s7_kazuto_3=1"]
[bg storage="room_mashiro_night.png"]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all wait="false"]
[charapos name="kazuto" face="thinking" num="0" wait="false"]
[eval exp="f.s7_sage_request=1"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02494"]
珠璃さんのスーツケースに入っていた、洗浄された瓶。[p]

#mahoru
[voice id="v02495"]
中から、水と一緒にアルコール消毒液が検出されたの。[p]

#mahoru
[voice id="v02496"]
洗うために使ったんじゃなくて、この瓶にアルコールが入っていたとしたら……？[p]
[reset_message_chara]

#kazuto
[voice id="v02497"]
アルコール……？[p]

[chara_mod name="kazuto" face="pursue"]
#kazuto
[voice id="v02498"]
まさか。[p]

#kazuto
[voice id="v02499"]
一つ試してほしい。発見されたセージの成分に、強いアルコールをかけてもらえ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02500"]
やっぱり、アルコールが関係してるの？[p]
[reset_message_chara]

#kazuto
[voice id="v02501"]
まだ可能性だ。零度警部に頼んで、毒性が生まれるか確かめてくれ。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02502"]
分かった。すぐ警部にお願いしてくる。[p]
[reset_message_chara]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t4
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[charapos name="kazuto" face="thinking" num="0"]
[advance_time min=2]
[eval exp="f.s7_kazuto_4=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02503"]
和人、実験で毒性反応が出た。なぜアルコールをかけるとわかったの？[p]
[reset_message_chara]
#kazuto
[voice id="v02504"]
……まさか本当に検出されるとは。[p]
[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v02505"]
母が研究していた。偽聖女（ヴァイス・セージ）——強いアルコールをかけると猛毒を発生するセージの一種だ。[p]
#kazuto
[voice id="v02506"]
もしかしたら使われているのではないかと思ったんだ。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02507"]
お母さんが研究していたものなの！？[p]
[reset_message_chara]
#kazuto
[voice id="v02508"]
ああ。だが今はそんなことは重要じゃない。[p]

#kazuto
[voice id="v02509"]
毒が見つからないことには偽聖女だと断定はできない。[p]

#kazuto
[voice id="v02510"]
毒はまだ見つかっていないが、使用した以上必ずどこかにあるはずだ。[p]

#kazuto
[voice id="v03858"]
昼間に回った場所を思い出して、回ってみるんだ。[p]

#kazuto
[voice id="v03859"]
それでもでなければ、ありそうもない場所を調べてみろ。[p]

#mahoru
[voice id="v03860"]
わかった。[p]
[reset_message_chara]

#kazuto
[voice id="v02511"]
それと、これを持っていけ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02512"]
これは？[p]
[reset_message_chara]

#kazuto
[voice id="v02513"]
この本は母の薬学研究についての資料だ。[p]

#kazuto
[voice id="v02514"]
複製したものだが、何かの役に立つだろう。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02515"]
ありがとう。[p]
[reset_message_chara]

[get_item id="drag_book"]
[eval exp="f.s7_drag_book =1"]
[set_item_status id="drag_book" owned="true"]
[jump target="*s7_kazuto_hub"]

*s7_kazuto_t4r
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[charapos name="kazuto" face="thinking" num="0"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02516"]
（偽聖女とアルコール——毒の捨て場所の近くに容器があるはず。）[p]
[reset_message_chara]
[jump target="*s7_kazuto_hub"]


;===========================================
; 愛理 トピックハブ
;===========================================
*s7_airi_hub
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[eval exp="tf.inv_talk = 'airi'"]
[jump target="*s7_bd_mashiro"]

*s7_airi_t1
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[advance_time min=2]
[eval exp="f.s7_airi_1=1"]
[eval exp="f.s7_exchange_topic=1"]
#airi
[voice id="v02517"]
お姉ちゃん……一つだけ。[p]
#airi
[voice id="v02518"]
お茶会の時……メアリーさんが、香りが苦手だからって……私が紅茶をもらったの。[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02519"]
紅茶を……もらった？[p]

#mahoru
[voice id="v02520"]
……愛理、教えてくれてありがとう。[p]

#mahoru
[voice id="v02521"]
ゆっくり休んでいて。[p]
[reset_message_chara]
[jump target="*s7_airi_hub"]

*s7_airi_t1r
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02522"]
（愛理はメアリーさんの紅茶を飲んだ。）[p]
[reset_message_chara]
[jump target="*s7_airi_hub"]

*s7_airi_t2
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[chara_hide_all]
[advance_time min=2]
[eval exp="f.s7_airi_2=1"]
[eval exp="f.s7_pf3=1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02523"]
愛理……辛いかもしれないけれど、確認したいことがあるの。少しだけ我慢してね。[p]
[reset_message_chara]
#
警察に応援を仰ぎ、愛理に簡易検査をお願いする——[p]
#airi
[voice id="v02524"]
……ごめんね……お姉ちゃん、心配かけて……[p]
[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02525"]
愛理が謝ることなんてないんだから。[p]
[reset_message_chara]
#
検査の結果、愛理の口からわずかにセージに似た成分が検出された。[p]
#
念のため、私の体も調べてもらったがセージの成分は検出されなかった。[p]
[get_item name="愛理の体のセージ成分" type="clue"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02526"]
（私とずっと一緒にいて、愛理にはセージの成分が検出された。）[p]
#mahoru
[voice id="v02527"]
（どうして、愛理からセージの成分が？）[p]
[reset_message_chara]

[jump target="*s7_airi_hub"]

*s7_airi_t2r
[cm]
[show_menu]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[bg  storage="event/airi_painful.png"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02528"]
（愛理の体からもセージが検出された。）[p]
[reset_message_chara]
[jump target="*s7_airi_hub"]


;--------------------------------------------------
; 宿泊部屋：部屋を調べる
;--------------------------------------------------
*s7_bedroom_investigate
; 行動のたびに時間を確認する（本文を読み終えてから切り替わる）
[jump cond="f.game_time >= 1290" target="*time_over"]
[jump target="*s7_bedroom"]

*s7_evt_bd_kazuto
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:和人の部屋(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_bd_kazuto==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02529"]
（和人のリュックサック——薬と瓶と医学書だった。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_bd_kazuto"]
[endif]
[advance_time min=1]
[eval exp="f.s7_bd_kazuto=1"]
#
警察の立ち会いのもと、和人のリュックサックを確認した。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02530"]
薬と瓶……それと、医学書が何冊か。今のところ特に怪しいものは……[p]
[reset_message_chara]
[jump target="*s7_bd_kazuto"]


;===========================================
; 2F 和人の部屋 ── 書棚（緑の硝子）
;===========================================

*s7_evt_kazuto_desk
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:和人の部屋(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_kazuto_desk==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02531"]
（和人の机の天板から、セージの成分が出た。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_bd_kazuto"]
[endif]
[advance_time min=1]
[eval exp="f.s7_kazuto_desk=1"]
[eval exp="f.s7_pf4=1"]

#
窓際の書き物机。天板の一角だけ、埃の乗り方が違っていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02532"]
……ここだけ、拭いてある。[p]

#mahoru
[voice id="v02533"]
鑑識さん、この机を調べてもらえますか。[p]
[reset_message_chara]

#警察
……天板から、セージに似た成分が検出されました。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02534"]
和人の部屋から……？[p]
[reset_message_chara]

#警察
それと、この机からは指紋がひとつも検出されません。[p]

#警察
徐音さんご本人のものすら、残っていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02535"]
（自分の机を、そこまできれいに拭く人がいる？）[p]
[reset_message_chara]

[get_item name="和人の机のセージ成分" type="clue"]
[jump target="*s7_bd_kazuto"]


;===========================================
; 2F 和人の部屋 ── 書棚（緑の硝子）
;===========================================



*s7_evt_bd_juri
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:穂在呂夫妻の部屋(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_bd_juri==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02536"]
（珠璃さんのスーツケース——濡れた瓶が入っていた。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_bd_hozairo"]
[endif]
[advance_time min=1]
[eval exp="f.s7_bd_juri=1"]
[eval exp="f.s7_wet_bottle=1"]
#
警察の立ち会いのもと、珠璃のスーツケースを確認した。[p]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v02537"]
持ち手が濡れていて……中に服と、洗浄された跡のある瓶が。[p]
[reset_message_chara]
#警察
成分を確認します……水に混じって、アルコール消毒液が検出されました。内部が丁寧に洗浄された瓶です。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02538"]
洗浄した瓶……何かを入れていたの？[p]
[reset_message_chara]
[get_item id="bottle" name="濡れた瓶"]
[eval exp="f.s7_wet_bottle = 1"]
[iscript]
f.status["bottle"].owned = true;
[endscript]
[jump target="*s7_bd_hozairo"]

*s7_evt_bd_eruku
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:穂在呂夫妻の部屋(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_bd_eruku==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02539"]
（叡留久さんのスーツケース——2台目のスマートフォンが入っていた。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_bd_hozairo"]
[endif]
[advance_time min=1]
[eval exp="f.s7_bd_eruku=1"]
[eval exp="f.s7_eruku_phone2=1"]

#
警察の立ち会いのもと、叡留久のスーツケースを開けた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02540"]
着替えと、書類と……[p]
[reset_message_chara]

#
内側のポケットに、硬いものが入っていた。[r]
#
指を差し込んで取り出す。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02541"]
……スマートフォン？[p]

#mahoru
[voice id="v02542"]
叡留久さんのは、リビングで見つけたのに。[p]
[reset_message_chara]

#警察
2台目、ということになりますね。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02543"]
（パスワード……同じかな。）[p]
[reset_message_chara]

#
「1028」を入力する。[r]
#
——今度は、画面が開いた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02544"]
……こっちは、消えてない。[p]
[reset_message_chara]

#
並んでいたのは、たったひとつのアプリと、たったひとりの相手だった。[p]

#
——『エミリー』。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02545"]
え……[p]
[reset_message_chara]

#
写真が数枚。[r]
#
どれも、叡留久と、顔の写っていない女性のものだった。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02546"]
（……見ちゃいけないものだ。）[p]
[reset_message_chara]

#
真歩流は画面を伏せた。[p]

[mask]
[chara_hide_all]
[charapos name="reido" face="normal" num=0]
[mask_off]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02547"]
零度警部。叡留久さんのスマートフォンです。[p]

#mahoru
[voice id="v02548"]
二台ありました。中身の確認を、お願いできますか。[p]
[reset_message_chara]

#reido
[voice id="v02549"]
二台……なるほど。[p]

#reido
[voice id="v02550"]
一台目が消されていた理由も、これで見えてきますね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02551"]
あの、『エミリー』という方と一緒にいるのを、見てしまって。[p]
[reset_message_chara]

#reido
[voice id="v02552"]
いくら故人のものとはいえ、勝手に盗み見をするのはどうかと思いますよ。[p]

#reido
[voice id="v02553"]
とはいえ、気になりますね。[p]

#reido
[voice id="v02554"]
今、小出里亜さんのスマートフォンも調べているところですから。[p]

#reido
[voice id="v02555"]
そちらもわかり次第、共有しましょう。[p]

; スーツケースの2台目で中身を確かめたので、叡留久のスマホの追加情報を出す
[set_item_status id="eruku_phone" owned="true" secret="true"]
[get_item id="eruku_phone" type="info"]

[chara_hide_all]
[jump target="*s7_bd_hozairo"]


*s7_evt_bd_mary
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:メアリーの部屋(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_bd_mary==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02556"]
（メアリーさんのスーツケース——英語の手紙が入っていた。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_bd_mary"]
[endif]
[advance_time min=1]
[eval exp="f.s7_bd_mary=1"]
#
警察の立ち会いのもと、メアリーのスーツケースを確認した。[p]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v02557"]
複数の香水の香り……すごく強い。[p]
[reset_message_chara]
#
そして、内ポケットに——英語で書かれた手紙が入っていた。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02558"]
英語……メアリーさんに読んでもらおう。[p]
[reset_message_chara]
[get_item id="letter"]
; 内容はまだ分からないので、追加情報はメアリーの話を聞いてから
[set_item_status id="letter" owned="true"]
[jump target="*s7_bd_mary"]


;-------------------------------------------
; メアリーの部屋の机（絵画）
; scene4 と同じフラグを使うので、昼に見つけていれば調査済みで並ぶ
;-------------------------------------------


*s7_evt_bd_airi
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:真白姉妹の部屋(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_bd_airi==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02559"]
（ベッドサイドから毒物は出なかった。愛理だけが触ったもの、口にしたものを探さないと）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_bd_mashiro"]
[endif]
[advance_time min=1]
[eval exp="f.s7_bd_airi=1"]

#
愛理の枕元には、飲みかけの水のカップが置かれていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02560"]
念のため、この周りも調べてもらえますか。[p]
[reset_message_chara]

#警察
そちらの水は我々が用意したものです。[p]

#警察
ベッドサイドも含めて成分を確認済みですが、毒物や異常な成分は検出されていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02561"]
……じゃあ、この部屋にあったものが原因ではなさそう。[p]

#mahoru
[voice id="v02562"]
私と愛理は、ほとんどずっと同じ場所にいた。[p]

#mahoru
[voice id="v02563"]
それなのに、愛理だけが……。[p]

#mahoru
[voice id="v02564"]
だったら――愛理だけが触ったもの、愛理だけが口にしたものがあるはずだよね。[p]
[reset_message_chara]

#
毛布を掛け直してやると、愛理はわずかに身じろぎした。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02565"]
（待っててね。絶対に間に合わせる）[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_bd_mashiro"]

;-------------------------------------------------------------------------------
; 2F サンルーム：古びた椅子
; 実際にハンカチが隙間へ落ち、リビングのソファを連想する
;-------------------------------------------------------------------------------



*s7_sunroom2
[cm]
[inv_set chapter="s7"]
[bg storage="sunroom_second_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]

#
夜の2階サンルーム。窓の外には暗闇が広がり、室内も薄暗かった。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="sunroom2"]

*s7_evt_sun2_chair
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_sun2_chair==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02566"]
（座面の隙間に物が落ちることもあるよね。リビングのソファも確認してみよう）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_sunroom2"]
[endif]
[advance_time min=1]
[eval exp="f.s7_sun2_chair=1"]

#
古びた椅子に腰を下ろすと、夜の静寂の中でキコキコと音がした。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02567"]
事件がなければ、今頃は愛理と館の仕掛けを探してたのかな……。[p]

#mahoru
[voice id="v02568"]
愛理……絶対に助ける。そのためにも、今は動かないと。[p]
[reset_message_chara]

#
立ち上がろうとして、膝の上に置いていたハンカチが滑り落ちた。[r]
#
ハンカチは座面の脇へ入り込み、隙間にすっぽり挟まった。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02569"]
あっ……こんなところに入っちゃうんだ。[p]
[reset_message_chara]

#
指を差し込んでハンカチを取り出す。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02570"]
……待って。[p]

#mahoru
[voice id="v02571"]
椅子の隙間に物が落ちるなら、ソファだって同じだよね。[p]

#mahoru
[voice id="v02572"]
リビングのソファも、ちゃんと確認してみよう。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_sunroom2"]

;-------------------------------------------------------------------------------
; 2F 談話室：テーブル
; 新しい未回収の謎は増やさず「事件現場ではない」という除外情報にする
;-------------------------------------------------------------------------------



*s7_lounge
[cm]
[inv_set chapter="s7"]
[bg storage="talk_room_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.s7_lounge_table  === 'undefined') f.s7_lounge_table  = 0;
if (typeof f.s7_lounge_window === 'undefined') f.s7_lounge_window = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:談話室(2F)"]

#
昼間、愛理と二人で覗いた談話室。[r]
#
今は照明が落とされ、大きなテーブルが闇の中に沈んでいた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02573"]
（お茶会はダイニングだったから、ここは事件と関係ないはず……）[p]
#mahoru
[voice id="v02574"]
（でも、念のため見ておこう。）[p]
[reset_message_chara]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="lounge"]


;--------------------------------------------------
; 談話室：テーブル
;--------------------------------------------------
*s7_evt_lounge_table
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:談話室(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_lounge_table==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02575"]
（談話室は今日は使われてない。事件の直接の現場ではなさそう）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_lounge"]
[endif]
[advance_time min=1]
[eval exp="f.s7_lounge_table=1"]

#
大きな木製のテーブルは、昼に見たときのまま整然と並んでいた。[r]
#
椅子の位置ひとつ動いていない。[p]

#警察
こちらの部屋は、本日は誰も使用していません。[p]

#警察
事件後に確認しましたが、新しい指紋や、薬物を疑う痕跡も出ていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02576"]
……ってことは、少なくとも談話室は事件の現場じゃなさそう。[p]

#mahoru
[voice id="v02577"]
調べる場所を一つ絞れた。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_lounge"]

;-------------------------------------------------------------------------------
; 2F 資料室：訪問者記録
; 真白小五郎の来館記録。昼の出資者リストを見ていれば読み方が変わる
;-------------------------------------------------------------------------------

*s7_evt_lounge_window
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:談話室(2F)"]
[layopt layer="message0" visible=true]

[if exp="f.s7_lounge_window==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02578"]
（窓の鍵は内側から閉まっていた。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_lounge"]
[endif]

[advance_time min=1]
[eval exp="f.s7_lounge_window=1"]

#
夜風でカーテンがわずかに揺れている。[r]
#
めくってみると、窓の鍵は内側からきちんと閉まっていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02579"]
外から誰かが入った跡はない……[p]

#mahoru
[voice id="v02580"]
——つまり、毒は外から持ち込まれたものじゃない。[p]

#mahoru
[voice id="v02581"]
（この館の中に、最初からあったんだ）[p]
[reset_message_chara]

#
警部に伝えれば、探す場所を絞ってもらえる。[p]

#
昼間、愛理と「歴史のロマンだね」と笑い合った部屋。[r]
#
その同じ場所で、こんなことを調べている自分が、少しだけ息苦しかった。[p]

[jump target="*s7_lounge"]


;===========================================
; 2F 談話室 ── 飾り棚（ラジオ）
;===========================================



*s7_archive
[cm]
[inv_set chapter="s7"]
[bg storage="reference_room_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]

#
夜の資料室。館内の調査で警察が通過した跡があった。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="archive"]

*s7_evt_arc_plate
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_arc_plate==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02582"]
（増築工事出資者リスト——灰音の名前があった。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_archive"]
[endif]
[advance_time min=1]
[eval exp="f.s7_arc_plate=1"]
#
「地下増築工事 共同出資者一覧」の書類があった。[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02583"]
『灰音』……小出里亜さんの家と同じ名字！ 富礼知家と灰音家は出資者だったんだ。[p]

#mahoru
[voice id="v02584"]
富礼知家と灰音家は昔から縁のある家だったのかもしれない。[p]

#mahoru
[voice id="v02585"]
小出里亜さんが富礼知家に来たのはその縁だったのかな？[p]
[reset_message_chara]

; 富礼知家が地下増築工事の出資者だったと分かった
[set_item_status id="photo" secret="true"]
[get_item id="photo" type="info"]

[jump target="*s7_archive"]

*s7_evt_arc_record
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_arc_record==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02586"]
（訪問者記録にも真白小五郎の名前があった。私たちの家と、この館……何か繋がりがあるのかな）[p]
[reset_message_chara]
[advance_time min=1]
[jump storage="scene7.ks" target="*s7_archive"]
[endif]
[advance_time min=1]
[eval exp="f.s7_arc_record=1"]

#
「舞黒館の訪問者記録」を確認した。[r]
#
世界各国の要人や文化人の名前が、何年にもわたって記されている。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02587"]
どうして、これだけの人たちがこの館へ来ていたんだろう……。[p]
[reset_message_chara]

#
ページをめくっていると、一つの名前に指が止まった。[p]

[if exp="f.event_arc_plate==1"]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02588"]
……また、真白小五郎。[p]

#mahoru
[voice id="v02589"]
地下増築工事の出資者一覧にも、この名前があった。[p]

#mahoru
[voice id="v02590"]
ただ出資しただけじゃない。本人も、何度も舞黒館に来てたんだ……。[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02591"]
……真白小五郎？[p]

#mahoru
[voice id="v02592"]
真白……私たちと同じ名字だよね。[p]

#mahoru
[voice id="v02593"]
もしかして、曾祖父たちもこの館に来てたの……？[p]
[reset_message_chara]
[endif]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02594"]
何のためにここへ来てたんだろう。[p]

#mahoru
[voice id="v02595"]
こんな時じゃなければ、もっと詳しく調べたいのに……。[p]
[reset_message_chara]

[jump storage="scene7.ks" target="*s7_archive"]

;-------------------------------------------------------------------------------
; 2F 執務室：執務椅子
; 「極限でも無意識の癖が出る」を説明せず、両手で涙を拭う描写だけ置く
;-------------------------------------------------------------------------------

*s7_evt_arc_route
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_arc_route==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02596"]
（地下室——設計図があれば場所がわかるかも。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_archive"]
[endif]
[advance_time min=1]
[eval exp="f.s7_arc_route=1"]
#
模型の台の所に資料が入っている。[p]

#
「地下の増築工事について」という冊子を確認した。[p]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02597"]
1930年、新たに地下室を増築……つまりこの館には地下があるの？[p]

#mahoru
[voice id="v02598"]
でも、地下に降りられる所なんてあったかな？[p]
[reset_message_chara]

; 邦夢が1930年に地下室を増築したと分かった
[set_item_status id="chara_11" secret="true"]
[get_item id="chara_11" type="info"]

[jump target="*s7_archive"]


;===========================================
; 2F 資料室 ── 上段の本棚（三色硝子の仕掛け）
;===========================================



*s7_evt_arc_inventory
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[layopt layer="message0" visible=true]

[if exp="f.s7_arc_inventory==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02599"]
（旦那さんの遺品整理の控え。目録に「薬学研究」の一行があった。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_archive"]
[endif]

[advance_time min=1]
[eval exp="f.s7_arc_inventory=1"]

#
棚の下の段に、細い冊子が一冊だけ立てかけてあった。[r]
#
表紙に「整理済 書類一覧」と手書きされている。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02600"]
整理済み……？[p]
[reset_message_chara]

#警察
ご主人が亡くなられた後の、遺品整理の控えでしょうね。[p]

#警察
残した品と、手放した品を分けて書いてあります。[p]

#
ページには、几帳面な字で品目が並んでいた。[r]
#
家具、衣類、書簡——そのどれにも、処分の日付が添えてあった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02601"]
ずいぶん丁寧に書いてあるんだ……[p]

#mahoru
[voice id="v02602"]
……あれ。[p]

#mahoru
[voice id="v02603"]
「薬学研究」……？[p]
[reset_message_chara]

#警察
分類名ですね。書類の束を、まとめてそう呼んでいたようです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02604"]
（薬学研究の書類が、この館にあった？）[p]
[reset_message_chara]

[if exp="f.status['drag_book'].owned == true"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02605"]
（待って。和人からもらった本も、薬学研究の写本だった）[p]

#mahoru
[voice id="v02606"]
（……同じもの、なのかな。まさか、ね）[p]

#mahoru
[voice id="v02607"]
（でも——もし同じなら）[p]

#mahoru
[voice id="v02608"]
（愛理に使われた毒が何なのか、そこに書いてあるかもしれない）[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02609"]
（薬の資料……愛理に使われた毒のことも、載っていたりしないかな）[p]
[reset_message_chara]
[endif]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02610"]
念のため、朱志香さんに聞いてみよう。[p]
[reset_message_chara]

[jump target="*s7_archive"]


;===========================================
; 2F ── 執務室
;===========================================

*s7_study
[cm]
[inv_set chapter="s7"]
[bg storage="office_night.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]

#
夜の執務室。事件後、立ち入りは自由になっていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
; 時間切れの確認（部屋を開く前に見る）
[jump cond="f.game_time >= 1290" target="*time_over"]
[inv_room id="study"]

*s7_evt_study_cabinet
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[layopt layer="message0" visible=true]
[if exp="f.s7_study_cabinet==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02611"]
（本棚では、娘の誘拐を報じた古い新聞記事と、鑑識済みの茶葉缶を確認した。）[p]
[reset_message_chara]
[advance_time min=1]
[jump target="*s7_study"]
[endif]
[advance_time min=1]
[eval exp="f.s7_study_cabinet=1"]
[eval exp="f.s7_newspaper=1"]
[eval exp="f.s7_tea_can=1"]

#
本棚を調べると、昼間、朱志香さんが片づけていた茶葉の缶が残されていた。[p]

#警察
その缶なら、すでに鑑識が中身を確認しています。[p]

#警察
通常の紅茶の茶葉です。三人から検出された成分も、その他の毒物や薬物も見つかっていません。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02612"]
（気になっていたけど、この缶は今回の事件とは関係ないみたい）[p]
[reset_message_chara]

#
さらに本棚の奥から、古びた新聞記事が見つかった。[p]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02613"]
舞黒館の購入後わずか半年——オーナーの娘が誘拐された？[p]
[reset_message_chara]
[iscript]
f.status["news_paper"].owned = true;
[endscript]
[get_item id="news_paper"]
[jump target="*s7_study"]
*s7_evt_study_chair
[cm]
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[layopt layer="message0" visible=true]
[advance_time min=1]

[if exp="f.s7_study_chair==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02614"]
（執務椅子のそばで見つけた、舞黒邦夢の1936年の記録。）[p]

#mahoru
[voice id="v02615"]
（キング家が残した家具と、結月という女の人のことが書かれていた。）[p]
[reset_message_chara]
[jump storage="scene7.ks" target="*s7_study"]
[endif]

[eval exp="f.s7_study_chair=1"]

#
椅子に触れた瞬間、昼の騒ぎが鮮明に蘇った。[p]

[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v02616"]
あの時は……まだ、みんな生きてた。[p]

#mahoru
[voice id="v02617"]
一緒に話して、笑ってたのに……。[p]
[reset_message_chara]

#
堪えていた涙が頬を伝った。[r]
#
気づけば真歩流は、いつものように両手で涙を拭っていた。[p]

[message_chara name="mahoru" face="anger"]
#mahoru
[voice id="v02618"]
……泣いてる場合じゃない。[p]

#mahoru
[voice id="v02619"]
愛理は今も戦ってる。[p]

#mahoru
[voice id="v02620"]
私も動かないと。[p]
[reset_message_chara]

#
椅子を机の前へ戻そうとすると、脚が何かに引っかかった。[r]
#
机と壁の隙間に、薄い書類箱が落ちている。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02621"]
こんなところに書類……？[p]
[reset_message_chara]

#
中には、舞黒邦夢が遺した手記が収められていた。[r]
#
そのうちの一枚には、「1936年」と記されている。[p]

#
『英国の外交官キング氏は任期を終え、近く日本を離れるという。[r]
#
別荘で使用していた家具一式を、この館へ寄贈してくれた。[p]

長く日本で暮らしてきた彼らとの縁が、[r]
#
この館に残ることを嬉しく思う。[p]

また、商家の娘である結月が、[r]
#
館の仕事を手伝ってくれることになった。[p]

来客の多いこの館に、[r]
#
よく気のつく彼女がいてくれるのは心強い。[p]

#
彼女に協力してもらい、声の仕掛けを作ったのは良い思い出だ。[p]
#
四つの数字を読み上げてもらい、その声を録音盤へ残した。[p]
#
談話室のラジオに仕込んだ装置も、うまく働いてくれるだろう。[p]
#
いつかこの館を訪れる者を、あの声が導いてくれるだろう』[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02622"]
キング……メアリーさんと同じ名字。[p]

#mahoru
[voice id="v02623"]
それに、結月という女の人。[p]

#mahoru
[voice id="v02624"]
この二つに、何か関係があるのかな……？[p]
[reset_message_chara]

; 昼に談話室のラジオを聞いているかどうかで受けを変える。
; 夜の談話室にラジオの調査点は無いので、聞いていない場合は
; 「昼に取り逃した」ことがプレイヤーに伝わるようにしておく。
[if exp="f.radio_code_known==1"]
[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02625"]
待って。談話室のラジオって……[p]

#mahoru
[voice id="v02626"]
あの雑音の向こうで数字を読んでいた、あの声。[p]

#mahoru
[voice id="v02627"]
（結月さん……八十年以上前の人の声を、私は聞いていたんだ）[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02628"]
談話室のラジオ……？[p]

#mahoru
[voice id="v02629"]
（そんなもの、昼に見た覚えがない）[p]

#mahoru
[voice id="v02630"]
（見落としてたんだ。あの部屋、ちゃんと調べておけばよかった）[p]
[reset_message_chara]
[endif]

[eval exp="f.s7_king_yuzuki_record=1"]
[get_item name="舞黒邦夢の1936年の手記" type="info" memo="外交官キング氏が別荘の家具一式を舞黒館へ寄贈し、商家の娘・結月が館で働き始めたことが記されている。"]

[jump storage="scene7.ks" target="*s7_study"]

;-------------------------------------------------------------------------------
; 2F 廊下：ステンドグラス
; 窓越しの庭→庭での接触仮説→「それだけでは愛理だけを説明できない」と除外
;-------------------------------------------------------------------------------

*time_over
[cm]
[bg storage="living_night.png" time=1000]
[chara_hide_all]
[show_menu]
[set_time hour=21 min=30]
[gage_draw place="舞黒館:リビング"]

#
愛理が倒れてから1時間以上が経過した。[p]

#
真歩流は、これまで集めた手がかりを頭の中で整理した。[p]

[freeimage layer="1"]
[chapter_end]

[jump storage="scene8.ks" target="*start"]
