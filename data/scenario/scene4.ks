;=========================================
; scene4.ks
; シーン：自由行動 ～ 屋敷調査
;=========================================

*start
[cm]
[clearfix]
@clearstack
[freeimage layer="1"]
[showmenubutton]
[hud_draw]
[playbgm storage="Track_Down_the_Clues.mp3"]
[bg storage="hallway.png" time=1000]
[call storage="system/macro.ks"]
[call storage="system/init_item_data.ks"]

; scene3 末尾 16:30 に合わせて確定セット
[set_time hour=16 min=30]
[gage_draw place="舞黒館:廊下(1F)"]

; --- 変数初期化 ---
[iscript]
// ゲーム内時刻は set_time で管理（f.ap 廃止）
// リビング
f.event_hercule_1     = 0;  // 叡留久① 仕事の件
f.event_hercule_2     = 0;  // 叡留久② 戻ってきた後
f.event_mary_1        = 0;  // メアリー① ペンダントと親戚
f.event_mary_2        = 0;  // メアリー② 祖母と舞黒館 ※真エンドフラグ
f.event_sofa          = 0;  // ソファ→リップ発見
f.event_fireplace     = 0;  // 暖炉
// ダイニング
f.event_shurika       = 0;  // 朱志香の謝罪会話
f.event_dishes        = 0;  // 食器のA・K
f.evt_dining_table    = 0;  // ダイニングテーブル調査（check_icon用）
// サンルーム(1F)
f.event_juri       = 0;  // 珠璃の会話
f.event_kazuto_sun    = 0;  // 和人の独り言
f.event_sun1_plant    = 0;  // 観葉植物・床
f.event_sun1_table    = 0;  // サンルーム1Fテーブル調査（check_icon用）
f.base_ment_found = 0;            // サンルーム床の鍵穴発見　トゥルーエンドフラグ
// キッチン
f.event_ria_1         = 0;  // 小出里亜① 小瓶
f.event_ria_2         = 0;  // 小出里亜② メイドの経緯
f.event_kitchen_lip   = 0;  // リップ返却＋叡留久
f.event_kitchen_island = 0; // キッチンアイランド（check_icon用）
f.event_kitchen_stove  = 0; // キッチンコンロ（check_icon用）
// 廊下・玄関
f.event_airi_hall     = 0;  // 愛理との会話@廊下
f.event_genkan        = 0;  // 記帳表
// 宿泊部屋(2F)
f.event_bd_kazuto     = 0;  // 和人のリュック（和人の部屋）
f.event_bd_juri    = 0;  // 珠璃のスーツケース（穂在呂夫妻の部屋）
f.event_bd_mary       = 0;  // メアリーのスーツケース（メアリーの部屋）
f.event_bd_mary_desk  = 0;  // メアリーの部屋の机（絵画）
f.event_bd_mashiro    = 0;  // 自分たちの荷物（真白姉妹の部屋）
f.event_bd_mashiro_shelf = 0; // 真白姉妹の部屋の本棚（古い写真）
// サンルーム(2F)
f.event_sun2_check    = 0;  // 2Fサンルーム調査
f.event_sun2_key      = 0;  // （旧）奥の扉。暖炉のダイヤル錠へ移行
// 執務室(2F)
f.study_unlocked      = 0;  // 執務室解放フラグ
f.event_study_cabinet = 0;  // 本棚
f.event_study_chair   = 0;  // 椅子→パズル→鍵入手
// 資料室(2F)
f.event_arc_kazuto    = 0;  // 和人との会話@資料室
f.event_arc_plate     = 0;  // 増築工事の出資者リスト
f.event_arc_record    = 0;  // 当時の記録表
f.event_arc_route     = 0;  // 秘密の避難経路資料
f.event_arc_shelf     = 0;  // 上段の本棚（三色硝子の仕掛け）
// 談話室(2F)
f.event_lounge        = 0;  // 談話室訪問
f.event_lounge_shelf  = 0;  // 飾り棚のラジオ
// 地下書斎（scene4 の到達点）
f.lounge_hidden_hint          = 0;
f.hidden_study_entrance_found = 0;
f.hidden_study_entered        = 0;
f.hidden_study_recent_trace   = 0;
f.hidden_study_father_infer   = 0;
f.hidden_study_furechi_infer  = 0;
f.hidden_study_secret         = 0;
f.event_lounge_hidden_search  = 0;
// ── 館の仕掛け ──
// 設計図ルート：談話室のラジオ → 四桁 → サンルーム2Fの暖炉
f.radio_code_known    = 0;  // ラジオで四桁の数字を聞いた
f.event_sun2_fireplace = 0; // 暖炉のダイヤル錠を開けた
// 鍵ルート：三色の硝子 → 資料室で重ねる → 執務机
f.event_kunimu        = 0;  // 朱志香から舞黒邦夢の話を聞いた
f.study_model         = 0;  // 模型のガラスケースの鍵を借りた
f.glass_blue          = 0;  // 青い硝子（廊下1F）
f.glass_red           = 0;  // 赤い硝子（ダイニングの壁の絵）
f.glass_green         = 0;  // 緑の硝子（和人の部屋の書棚）
f.glass_solved        = 0;  // 三色硝子を重ね、「執務机裏」の文字を読んだ
f.event_dining_picture   = 0;  // ダイニングの壁の絵
f.event_bd_kazuto_shelf  = 0;  // 和人の部屋の書棚
f.event_study_desk       = 0;  // 執務机
f.study_security_on      = 0;  // 施錠された執務机を一度調べた
// アイテム
f.has_lipstick        = 0;  // 口紅所持
f.has_old_key         = 0;  // 古びた鍵所持
f.has_entrance_record = 0;  // 入館記録書所持
f.has_blueprint       = 0;  // 古い設計図所持
// フラグ・スコア
f.map_dest            = "";
f.active_floor        = 1;   // フロアマップで最後に表示していた階（1 or 2）

// 父・奢禄の調査
f.event_shurika_father = 0;
f.father_visit_found    = 0;
f.event_arc_access      = 0;
f.father_research_found = 0;
f.event_study_drawings  = 0;
f.study_drawings_checked = 0;

// 証拠品フラグ(他のチャプターに持ち越すため)
f.morning_action = 0;
[endscript]

;------------------------------------------------------------------
; トゥルーエンド用の共通フラグ
;   true_flag_mary … メアリーの目的（親戚を探しに来た）を知る。
;                    scene4 のメアリー会話でも、scene7 の手紙の話でも立つ。
;   has_blueprint / has_old_key は scene4 で取得した時点でそのまま持ち越す。
;   base_ment_found は scene7 の事件捜査でサンルームを精査したときに初めて立つ。
;   scene7 ではさらに、キング家と結月の記録を探す。
;   scene8 の分岐条件は、これら5つがすべて揃っていること。
;------------------------------------------------------------------
[eval exp="f.true_flag_mary = 0"]

[charapos name="airi" face="normal" num="0"]

;=========================================
; オープニング
;=========================================

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v01037"]
#mahoru
さて、愛理。朱志香さんが夕食まで自由にしていいって言ってたね。[p]

[voice id="v01038"]
#mahoru
今のうちに、館内を調べてみよう。[p]

[reset_message_chara]
#airi
[voice id="v01039"]
#airi
うん！ お父さんの手がかりが見つかるといいね。[p]

[message_chara name="mahoru" face="light_thinking"]

#mahoru
[voice id="v01040"]
#mahoru
（この館にきっと、お父さんに繋がる何かがあるはず……）[p]

[reset_message_chara]

#airi
[voice id="v03955"]
館を調べるなら、最初は朱志香さんに話を聞いてみようよ。[p]

[voice id="v03956"]
勿論怪しまれないようにね！[p]

#TIPS
このパートでは時間を使って、館内を自由に移動し、調査を行うことができます。[p]
#TIPS
新しいことがわかる調査・会話をするたびに3分時間が経過します。[p]
#TIPS
部屋の移動や、すでに調べ終えた場所をもう一度見るだけなら時間は進みません。[p]
#TIPS
各場所での調査や会話を通じて、お父さんの手がかりを集めましょう。[p]
#TIPS
18時00分になると、自動的に次のパートへ進みます。[p]

#

;=========================================
; フロアマップ（調査ハブ）
;=========================================
*investigation_start
[cm]
[clearfix]
; 18:00（1080分）になったら探索終了
[jump cond="f.game_time >= 1080" target="*time_over"]

[inv_set chapter="s4"]
[bg storage="hallway.png" time=500]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_map]

; --- 移動先ディスパッチ ---
*dispatch_from_map
; 館マップ経由の入室であることを示す（部屋の導入テキストはこのときだけ再生）
[eval exp="tf.inv_enter = 1"]
[jump cond="f.map_dest=='living'"   target="*scene_living"]
[jump cond="f.map_dest=='dining'"   target="*scene_dining"]
[jump cond="f.map_dest=='kitchen'"  target="*scene_kitchen"]
[jump cond="f.map_dest=='sunroom1'" target="*scene_sunroom1"]
[jump cond="f.map_dest=='rouka1'"   target="*scene_rouka1"]
[jump cond="f.map_dest=='genkan'"   target="*scene_genkan"]
[jump cond="f.map_dest=='bedroom'"  target="*scene_bedroom"]
; 宿泊部屋の各室（扉選択画面からも直接入るが、マップ復帰用に受け口を用意しておく）
[jump cond="f.map_dest=='bd_hozairo'" target="*scene_bd_hozairo"]
[jump cond="f.map_dest=='bd_kazuto'"  target="*scene_bd_kazuto"]
[jump cond="f.map_dest=='bd_mary'"    target="*scene_bd_mary"]
[jump cond="f.map_dest=='bd_mashiro'" target="*scene_bd_mashiro"]
[jump cond="f.map_dest=='sunroom2'" target="*scene_sunroom2"]
[jump cond="f.map_dest=='study'"    target="*scene_study"]
[jump cond="f.map_dest=='archive'"  target="*scene_archive"]
[jump cond="f.map_dest=='rouka2'"   target="*scene_rouka2"]
[jump cond="f.map_dest=='lounge'"   target="*scene_lounge"]
[jump cond="f.map_dest=='exit'"     target="*time_over"]
[jump target="*investigation_start"]


;=========================================
; 1F ── リビング（クリッカブル版）
;=========================================

*scene_living
[cm]
[inv_set chapter="s4"]
[bg storage="living.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_hercule_1   === 'undefined') f.event_hercule_1   = 0;
if (typeof f.event_hercule_2   === 'undefined') f.event_hercule_2   = 0;
if (typeof f.event_mary_1      === 'undefined') f.event_mary_1      = 0;
if (typeof f.event_mary_2      === 'undefined') f.event_mary_2      = 0;
if (typeof f.event_sofa        === 'undefined') f.event_sofa        = 0;
if (typeof f.event_fireplace   === 'undefined') f.event_fireplace   = 0;
if (typeof f.has_lipstick      === 'undefined') f.has_lipstick      = 0;
if (typeof f.event_kitchen_lip === 'undefined') f.event_kitchen_lip = 0;
if (typeof f.event_arc_record  === 'undefined') f.event_arc_record  = 0;
if (typeof f.event_dishes      === 'undefined') f.event_dishes      = 0;
[endscript]

; 館マップから入ってきたときだけ、部屋の導入テキストを再生する
[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:リビング"]
[charapos name="airi" face="normal" num="0"]

#
リビングには暖かな陽の光が差し込んでいた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="living"]


;-----------------------------------------------------------
; 旧UIのラベル：各イベントからの復帰先として残し、新しい部屋画面へ戻す
;-----------------------------------------------------------
*living_talk
*living_talk_ui
*living_investigate
[jump target="*scene_living"]


;=========================================
; イベント：叡留久との会話
;=========================================

*evt_hercule
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[layopt layer="message0" visible=true]

[if exp="f.event_hercule_1==1 && f.event_hercule_2==1"]
[charapos name="eruku" face="smile" num="0"]
#eruku
[voice id="v01041"]
#eruku
ゆっくり楽しんでいるよ。[p]

[voice id="v01042"]
#eruku
そういえば、知っているかい？[p]

[voice id="v01043"]
#eruku
この館を建てた舞黒氏は子供がいなくてね。[p]

[voice id="v01044"]
#eruku
亡くなった後、後見人がこの館で暮らしていたんだ。[p]

[voice id="v01045"]
#eruku
その後見人も亡くなり、売りに出された瞬間、富礼知氏が購入を決めたらしい。[p]

[voice id="v01046"]
#eruku
これだけいい家なら僕も欲しくなってきたな。[p]

[iscript]
f.game_time = Math.min((f.game_time||0) + 4, 1080);
[endscript]
[jump cond="f.game_time >= 1080" target="*time_over"]
[jump target="*living_talk"]
[endif]

[if exp="f.event_hercule_1==1 && f.event_kitchen_lip==1 && f.event_hercule_2==0"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_hercule_2 = 1;
[endscript]
[charapos name="eruku" face="smile" num="0"]

#
ソファに腰かけた叡留久は、今度は本を読んでいた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01047"]
#mahoru
もういいんですか？ お仕事。[p]
[reset_message_chara]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v01048"]
#eruku
ひとまずは。ゆっくり寛がせてもらっているよ。[p]

#eruku
[voice id="v01049"]
#eruku
こういう場所に来ても仕事が気になってしまうのは生来の気質でね。[p]

[voice id="v01050"]
#eruku
でも、今はこの館の雰囲気を楽しんでいるよ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01051"]
#mahoru
気持ちはわかります。[p]

[voice id="v01052"]
#mahoru
この異国感がたまらないんですよね。[p]
[reset_message_chara]

#eruku
[voice id="v01053"]
#eruku
ははは、君は本当にユニークだな。[p]

[voice id="v01054"]
#eruku
いっそ、本場のイギリスで探偵を開業するというのはどうだい？[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v01055"]
#mahoru
！？[p]

[voice id="v01056"]
#mahoru
……[p]

@chara_mod name="mahoru" face="light_thinking"

#mahoru
[voice id="v01057"]
#mahoru
ありかも。[p]

@reset_message_chara

@charapos name=airi face=anger num=4

#airi
[voice id="v01058"]
#airi
無いわよ。[p]

[jump target="*living_talk"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_hercule_1 = 1;
[endscript]
[charapos name="eruku" face="normal" num="0"]

#
叡留久はソファに腰かけ、スマートフォンを操作していた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01059"]
#mahoru
叡留久さん、またお仕事ですか？[p]
[reset_message_chara]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v01060"]
#eruku
バレてしまったか。……珠璃には内緒にしてほしいなあ？[p]

[message_chara name="airi" face="thinking"]
#airi
[voice id="v01061"]
#airi
それ、絶対怒られますよ？[p]
[reset_message_chara]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v01062"]
#eruku
大丈夫だよ。珠璃はわかっているからね。[p]

[voice id="v01063"]
#eruku
それに、もう終わったからね。[p]

#
叡留久は軽く笑ってみせた。[p]

[chara_mod name="eruku" face="normal"]
#eruku
[voice id="v01064"]
#eruku
さて……少し館内を散策してくるか。君たちも、楽しむといいさ。[p]

#
叡留久はそう言って颯爽とリビングを後にした。[p]

[jump target="*living_talk"]


;=========================================
; イベント：メアリーとの会話
;=========================================

*evt_mary
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[layopt layer="message0" visible=true]

[if exp="f.event_mary_2==1 || (f.event_mary_1==1 && f.event_mary_2==0 && f.event_arc_record==0 && f.event_dishes==0)"]
[charapos name="mary" face="smile" num="0"]
#mary
[voice id="v01065"]
#mary
この館は、とても落ち着く場所ですね。[p]
[jump target="*living_talk"]
[endif]

[if exp="f.event_mary_1==1 && f.event_mary_2==0 && (f.event_arc_record==1 || f.event_dishes==1)"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_mary_2 = 1;
[endscript]
[charapos name="mary" face="normal" num="2"]
[charapos name="airi" face="thinking" num="1"]

#
愛理が、メアリーに真剣な表情で向き直った。[p]

#airi
[voice id="v01066"]
#airi
メアリーさん、少し聞いてもいいですか？[p]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v01067"]
#mary
……何でしょうか。[p]

#airi
[voice id="v01068"]
#airi
今回のこの宿泊イベントに参加したのって、親戚の方と関係があるんですか？[p]

#
メアリーの目が、わずかに見開かれた。[p]

[chara_mod name="mary" face="surprised"]
#mary
[voice id="v01069"]
#mary
どうして……？[p]

#airi
[voice id="v01070"]
#airi
だって、親戚の方を探して日本に来ているのに、それを忘れて宿泊イベントに参加するとは思えなくて。[p]

#
しばらくの沈黙の後、メアリーはゆっくりと息を吐いた。[p]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v01071"]
#mary
……ご明察です。祖母から聞いたんです。もしかしたら、舞黒館に何か手がかりがあるかもしれないって。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01072"]
#mahoru
（私たちと目的は同じなんだ）[p]
[reset_message_chara]

#
愛理と真歩流は、静かに顔を見合わせた。[p]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01073"]
#airi
……手がかりが見つかるといいですね。[p]

; メアリーの目的を知った（scene7 の手紙の話と同じ共通フラグ）
[eval exp="f.true_flag_mary = 1"]

#mary
[voice id="v01074"]
#mary
……きっと見つけてみせます。[p]

[jump target="*living_talk"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_mary_1 = 1;
[endscript]
[charapos name="mary" face="smile" num="2"]
[charapos name="airi" face="normal" num="1"]

#
メアリーは窓辺に腰かけ、外の景色を眺めていた。[r]

#
真歩流と愛理が近づくと、メアリーは穏やかに振り返った。[p]

#mary
[voice id="v01075"]
#mary
真歩流さん、先ほどはありがとうございました。ペンダントを見つけていただいて。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01076"]
#mahoru
いえ、いつの間にか持っていたので、見つかってよかったです。[p]

[voice id="v01077"]
#mahoru
……そのペンダントはやっぱり大切なものなんですね。[p]
[reset_message_chara]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v01078"]
#mary
はい。これは……親戚の手がかりになるものなんです。失くしてしまったら大変で。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01079"]
#mahoru
親戚……ですか。日本に親戚の方がいるんですか？[p]
[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v01080"]
#mary
それがよくわからなくて。ずっと交流が途絶えていて……もう何十年も連絡を取っていないらしいんです。[p]

#mary
[voice id="v01081"]
#mary
家族の話をあまり聞かせてもらえなかったので、名前も顔もわからない。でも、どこかにいるはずだと思って、日本に来ました。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v01082"]
#mary
……変な話をしてしまいましたね。気にしないでください。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01083"]
#mahoru
いえ。見つかるといいですね、その親戚の方が。[p]
[reset_message_chara]

[jump target="*living_talk"]


;=========================================
; イベント：メアリーの香水
;   前提：メアリーの部屋でスーツケースを調べている（f.event_bd_mary）
;=========================================

*evt_mary_perfume
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[layopt layer="message0" visible=true]

[if exp="f.event_mary_perfume==1"]
[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01084"]
#mahoru
（メアリーさんの香水……大切に使わせてもらおう）[p]
[reset_message_chara]
[jump target="*living_talk"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_mary_perfume = 1;
[endscript]

[charapos name="mary" face="normal" num="2"]
[charapos name="airi" face="normal" num="1"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01085"]
#mahoru
メアリーさん。お部屋の前を通ったとき、すごくいい香りがして……[p]
[reset_message_chara]

[chara_mod name="mary" face="surprised"]
#mary
[voice id="v01086"]
#mary
あら、気づかれてしまいましたか。[p]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v01087"]
#mary
お恥ずかしい話ですけど、旅行にも一式持ってきてしまうんです。[p]

#
メアリーは鞄から小さな硝子の瓶を取り出し、真歩流の手のひらに載せた。[p]

#mary
[voice id="v01088"]
#mary
これ、差し上げます。素材から選んで、自分で調香したものなんですよ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01089"]
#mahoru
えっ、いいんですか？[p]
[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v01090"]
#mary
ええ。イギリスで作ったものですから、日本ではきっと珍しいと思います。[p]

[chara_mod name="airi" face="smile"]
#airi
[voice id="v01091"]
#airi
わあ、いい匂い……お姉ちゃん、よかったね。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01092"]
#mahoru
ありがとうございます。大切にします。[p]
[reset_message_chara]

[get_item id="perfume"]
[iscript]
f.status["perfume"].owned = true;
[endscript]

[chara_hide_all]
[jump target="*living_talk"]


;=========================================
; イベント：ソファ
;=========================================

*evt_sofa
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_sofa==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01093"]
#mahoru
（口紅は小出里亜さんに届けてあげないと……）[p]
[reset_message_chara]
[jump target="*living_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
; 経路Bでは口紅はお茶会で叡留久が拾っている。調査ピンも出さない設定だが、
; 万一ここへ来た場合に口紅を二重に発生させないよう保険をかけておく
[jump cond="f.route_b == 1" target="*living_investigate"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_sofa = 1;
f.has_lipstick = 1;
[endscript]

#
真歩流がソファのクッションを整えようとすると、その隙間から口紅が一本、転がり落ちた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01094"]
#mahoru
あれ……？ 口紅だ。[p]

[voice id="v01095"]
#mahoru
誰のかな？[p]
[reset_message_chara]

#airi
[voice id="v01096"]
#airi
小出里亜さんのかも。キッチンに届けてあげようよ。[p]

[get_item id="lip"]
[iscript]
f.status["lip"].owned = true;
[endscript]
[jump target="*living_investigate"]


;=========================================
; イベント：暖炉
;=========================================

*evt_fireplace
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_fireplace==1"]
[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01097"]
#mahoru
やっぱりしっかりした作りだなあ……冬に来てみたいな。[p]
[reset_message_chara]
[jump target="*living_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_fireplace = 1;
[endscript]

#
暖炉を覗き込んでみると、しっかりとした作りで、今でも普通に使えそうだとわかった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01098"]
#mahoru
冬に来たら、ここで火が焚けるのかな。いいなあ。[p]
[reset_message_chara]

#airi
[voice id="v01099"]
#airi
今は秋だからね。[p]

[voice id="v01100"]
#airi
そういえば、この洋館って至る所に暖炉があるなあ。[p]

[voice id="v01101"]
#airi
どれも同じなのかな？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01102"]
#mahoru
次に見かけたら調べてみようか。[p]
[reset_message_chara]


[jump target="*living_investigate"]

;=========================================
; 1F ── ダイニング（クリッカブル版）
;=========================================

*scene_dining
[cm]
[inv_set chapter="s4"]
[bg storage="dining.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_shurika    === 'undefined') f.event_shurika    = 0;
if (typeof f.event_dishes     === 'undefined') f.event_dishes     = 0;
if (typeof f.evt_dining_table === 'undefined') f.evt_dining_table = 0;
if (typeof f.event_arc_record === 'undefined') f.event_arc_record = 0;
if (typeof f.study_unlocked   === 'undefined') f.study_unlocked   = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:ダイニング"]
[charapos name="jushika" face="normal" num="0"]

#
ダイニングに入ると、朱志香が一人でテーブルを拭いていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="dining"]


;-----------------------------------------------------------
; 旧UIのラベル：各イベントからの復帰先として残す
;-----------------------------------------------------------
*dining_talk
*dining_talk_return
*dining_talk_ui
*dining_investigate
[jump target="*scene_dining"]


;=========================================
; イベント：朱志香との会話
;=========================================

*evt_shurika_father
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="jushika" face="normal" num="2"]
[charapos name="airi" face="normal" num="1"]

[if exp="f.event_shurika_father==1"]
[chara_mod name="jushika" face="normal"]
; ▼ 要ボイス収録
#jushika
[voice id="v01489"]
半年前の来館者でしたら、玄関の記帳記録を確認するのが一番確実かと思います。[p]
[jump storage="scene4.ks" target="*dining_talk_return"]
[endif]

[jump cond="f.game_time >= 1080" storage="scene4.ks" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_shurika_father = 1;
[endscript]

; ▼ 以下、新規会話は要ボイス収録
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01490"]
朱志香さん。ひとつ、聞きたいことがあるんです。[p]

#mahoru
[voice id="v01491"]
半年くらい前に、真白奢禄という人がこの館へ来ませんでしたか？　私たちの父なんです。[p]
[reset_message_chara]

#
朱志香の手が、ほんの一瞬だけ止まった。[p]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v01492"]
……半年前、ですか。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01493"]
この館には見学や催しで多くの方がお見えになりますので、記憶だけで確かなことを申し上げるのは難しいですね。[p]

#jushika
[voice id="v01494"]
ですが、玄関の記帳台には過去の来館記録も保管しております。[p]

#jushika
[voice id="v01495"]
もしお父様が記帳されていれば、そちらで確認できるかもしれません。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01496"]
ありがとうございます。見てみます。[p]
[reset_message_chara]

[jump storage="scene4.ks" target="*dining_talk_return"]


;===============================================================================
; 差し替え：玄関の記帳台
;   ・現在の宿泊者の入館記録（珠璃たちが早く来た証拠）は維持
;   ・半年前の真白奢禄の来館と「資料閲覧」を追加
;===============================================================================

*evt_shurika
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="jushika" face="normal" num="2"]
[charapos name="airi" face="normal" num="1"]

[if exp="f.event_shurika==1"]
[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01103"]
#jushika
何かご入用でしたら、お気軽にお声がけください。[p]
[jump target="*dining_talk_return"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_shurika = 1;
[endscript]

#
声をかけると、朱志香は顔を上げてやや申し訳なさそうな表情になった。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01104"]
#jushika
真白様……執務室でのことは、本当に申し訳ございませんでした。危険な目に遭わせてしまって。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01105"]
#mahoru
いえ、朱志香さんのせいじゃないですよ。ハプニングです、ハプニング。[p]
[reset_message_chara]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v01106"]
#jushika
……真白様は、お優しいですね。[p]

#
しばらく沈黙が続いた後、真歩流は何となく気になっていたことを訊いてみた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01107"]
#mahoru
朱志香さんって……お子さんはいらっしゃるんですか？[p]
[reset_message_chara]

#
朱志香の手が、一瞬だけ止まった。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01108"]
#jushika
……昔、いましたよ。[p]

[voice id="v01109"]
#jushika
今はもういないですけどね。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01110"]
#mahoru
すみません。そうとは知らずに……[p]
[reset_message_chara]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01111"]
#jushika
いえ、構いませんよ。[p]

[voice id="v01112"]
#jushika
……でも、会えるのなら、会いたいですね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01113"]
#mahoru
朱志香さん……[p]
[reset_message_chara]

#
朱志香はそれ以上語ろうとしなかった。[p]

[jump target="*dining_talk_return"]


;=========================================
; イベント：舞黒邦夢について聞く
;   ・館主のこと＝館中に仕掛けが隠されていること
;   ・「三つの原色を重ねれば、知識の宝庫に新たな兆しが現れる」というヒント
;   ・あわせて執務室の出入りを許可してもらう
;=========================================

*evt_shurika_kunimu
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="jushika" face="normal" num="2"]
[charapos name="airi" face="normal" num="1"]

[if exp="f.event_kunimu==1"]
[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01114"]
#jushika
三つの原色を重ねれば、知識の宝庫に新たな兆しが現れる――でしたね。[p]
[jump target="*dining_talk_return"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_kunimu   = 1;
f.study_unlocked = 1;
[endscript]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01115"]
#mahoru
朱志香さん。この館を建てた方って、どんな人だったんですか？[p]
[reset_message_chara]

[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01116"]
#jushika
舞黒邦夢様――戦前の資産家で、政治家もされていた方です。[p]

[voice id="v01117"]
#jushika
留学先の英仏で学ばれて、戦争を止めようと各国の要人と交渉を重ねていらした。[p]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01118"]
#jushika
立派な方でしたが……なんと申しますか、少し、遊び心のありすぎる方でして。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01119"]
#mahoru
遊び心？[p]
[reset_message_chara]

[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01120"]
#jushika
館のあちこちに、仕掛けやからくりを仕込んでおられるのです。[p]

[voice id="v01121"]
#jushika
訪ねてきた客人を退屈させないように、と。[p]

#airi
[voice id="v01122"]
#airi
えっ、それって……宝探しみたいな？[p]

[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01123"]
#jushika
ええ。どうぞ、解いていただいて構いませんよ。壊しさえしなければ。[p]

[voice id="v01124"]
#jushika
わたくしどもも、全部は把握しておりませんの。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01125"]
#mahoru
い、いいんですか？[p]
[reset_message_chara]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01126"]
#jushika
はい。ひとつだけ、言い伝えられているものがございます。[p]

#
朱志香は、暗誦するように言った。[p]

#jushika
[voice id="v01127"]
#jushika
――三つの原色を重ねれば、知識の宝庫に新たな兆しが現れる。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01128"]
#mahoru
三つの原色……知識の宝庫……？[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01129"]
#airi
知識の宝庫って、本がたくさんある場所――資料室のことじゃない？[p]

[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01130"]
#jushika
さて。それは、お二人でお確かめくださいませ。[p]

[voice id="v01131"]
#jushika
……ああ、それと。よろしければ執務室もご覧になりますか？[p]

#jushika
[voice id="v01497"]
先ほどの壁の仕掛けは、もう動かないように固定してありますから。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01133"]
#mahoru
ぜひ！ ありがとうございます。[p]
[reset_message_chara]

[get_item name="舞黒邦夢の言い伝え" type="info" memo="「三つの原色を重ねれば、知識の宝庫に新たな兆しが現れる」――館には邦夢が仕込んだ仕掛けがいくつも隠されているらしい。"]
[get_item name="執務室" type="info"]

[jump target="*dining_talk_return"]


;=========================================
; イベント：資料室の模型について（ガラスケースの鍵を借りる）
;=========================================

*evt_shurika_model
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="jushika" face="normal" num="2"]
[charapos name="airi" face="normal" num="1"]

[if exp="f.study_model==1"]
[chara_mod name="jushika" face="smile"]
#jushika
[voice id="v01134"]
#jushika
模型の鍵は、お使いになったらお返しくださいね。[p]
[jump target="*dining_talk_return"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.study_model = 1;
[endscript]

[chara_mod name="jushika" face="normal"]
#jushika
[voice id="v01135"]
#jushika
……ところで、2階の資料室を見てくださったんですね。足をお運びいただき、ありがとうございます。[p]

[voice id="v01136"]
#jushika
資料室に、模型がありましたでしょう？[p]

[voice id="v01137"]
#jushika
あれにも仕掛けがあって、この鍵を使うと中にある資料が読めます。[p]

[voice id="v01138"]
#jushika
よかったらどうぞ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01139"]
#mahoru
ありがとうございます！[p]

[voice id="v01140"]
#mahoru
でも、どうして模型の中に資料があるんですか？[p]
[reset_message_chara]

@chara_mod name="jushika" face="thinking"

#jushika
[voice id="v01141"]
#jushika
……[p]

@chara_mod name="jushika" face="normal"
[voice id="v01142"]
#jushika
ごゆっくり、見学なさってください。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01143"]
#mahoru
無かったことにされた！[p]
[reset_message_chara]

[get_item name="模型の鍵" type="info"]

[jump target="*dining_talk_return"]

;=========================================
; イベント：食器棚
;=========================================

*evt_dishes
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="jushika" face="smile" num="2"]
[charapos name="airi" face="normal" num="1"]

[if exp="f.event_dishes==1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01144"]
#mahoru
『A・K』……アーサー王だったらなあ。[p]
[reset_message_chara]
[jump target="*dining_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_dishes = 1;
[endscript]

#
食器棚には、年代を感じさせる上品な食器が並んでいた。[p]

#jushika
[voice id="v01145"]
#jushika
それらは当時実際に使用していたものなんですよ。館ごと引き継いだので、そのまま残っているんです。[p]

#
真歩流が食器を手に取ってみると、その裏面にイニシャルが刻まれていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01146"]
#mahoru
……『A・K』？ 誰のイニシャルだろう。[p]
[reset_message_chara]

#airi
[voice id="v01147"]
#airi
A・K……あの頃ここに住んでいた人かな？[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01148"]
#mahoru
わかった！？ アーサー王！[p]
[reset_message_chara]

@chara_mod name="jushika" face="thinking"

#jushika
[voice id="v01149"]
#jushika
……[p]

[chara_mod name="airi" face="stunned"]

#airi
[voice id="v01150"]
#airi
そんなわけないでしょう！[p]

[jump target="*dining_investigate"]


;=========================================
; イベント：テーブル
;=========================================

*evt_dining_table
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.evt_dining_table==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01151"]
#mahoru
（このテーブルを囲んで食事をして、その後は談話室へ移ったのかもしれない）[p]
[reset_message_chara]
[jump target="*dining_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.evt_dining_table = 1;
[endscript]

#
古くて立派な木のテーブル。長い年月を経ているのに、丁寧に磨かれていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01152"]
#mahoru
昔の人たちも、ここで食事をしながら団欒してたのかな。[p]
[reset_message_chara]

#airi
[voice id="v01153"]
#airi
きっとね。でも、食事が終わったらずっとここにいたわけじゃないと思う。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01154"]
#mahoru
あ、そうか。談話室もあったよね。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01155"]
#airi
うん。食事の後に場所を移して、そこでゆっくり話したりしてたのかも。[p]

[voice id="v01156"]
#airi
各国から人が来ていたなら、あっちの方が社交の場だったのかもしれないね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01157"]
#mahoru
談話室か……どんな部屋なのか、ちょっと気になってきた。[p]
[reset_message_chara]

[jump target="*dining_investigate"]


;=========================================
; イベント：壁の絵（赤い硝子）
;=========================================

*evt_dining_picture
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:ダイニング"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_dining_picture==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01158"]
#mahoru
（額の裏にあったのは、赤い硝子の板だった）[p]
[reset_message_chara]
[jump target="*dining_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_dining_picture = 1;
f.glass_red = 1;
[endscript]

#
壁に掛かった風景画。よく見ると、額がわずかに傾いていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01159"]
#mahoru
……ちょっとだけ、まっすぐに直しておこうかな。[p]
[reset_message_chara]

#
額に手をかけて水平に戻すと、裏側で何かがカタリと落ちた。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01160"]
#airi
お姉ちゃん、何か落ちたよ！[p]

#
額の裏に挟まっていたのは、手のひらほどの赤い硝子の板だった。[r]
#
縁は真鍮で縁取られていて、装飾品というより部品のように見える。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01161"]
#mahoru
硝子……？ こんなところに挟まってるなんて。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01162"]
#airi
わざと隠した、って感じだよね。[p]

[get_item id="glass_red"]
[iscript]
f.status["glass_red"].owned = true;
[endscript]

[chara_hide_all]
[jump target="*dining_investigate"]

;=========================================
; サンルーム（1F）── 話しかける / 調べる 分離版
;=========================================

*scene_sunroom1
[cm]
[inv_set chapter="s4"]
[bg storage="sunroom.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_juri    === 'undefined') f.event_juri    = 0;
if (typeof f.event_sun1_plant === 'undefined') f.event_sun1_plant = 0;
if (typeof f.event_sun1_table === 'undefined') f.event_sun1_table = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:サンルーム(1F)"]
[charapos name="juri" face="normal" num="0"]

#
陽光があふれるサンルーム。庭へと続く大きな窓から、緑の庭園が見渡せた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="sunroom1"]


;-----------------------------------------------------------
; 旧UIのラベル：各イベントからの復帰先として残す
;-----------------------------------------------------------
*sunroom_talk
*sunroom_talk_return
*sunroom_talk_ui
*sunroom_investigate
[jump target="*scene_sunroom1"]

;=========================================
; イベント：床
;=========================================


*evt_juri
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(1F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="juri" face="normal" num="1"]
[charapos name="airi" face="normal" num="2"]

[if exp="f.event_juri==1"]
[chara_mod name="juri" face="smile"]
#juri
[voice id="v01175"]
#juri
ここはいつ来ても気持ちがいいわ。ゆっくりしていって。[p]
[jump storage="scene4.ks" target="*scene_sunroom1"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_juri = 1;
[endscript]

#
珠璃はサンルームの椅子にゆったりと腰かけ、窓の外を眺めていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01176"]
#mahoru
珠璃さん、サンルームがお好きなんですね。[p]
[reset_message_chara]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v01177"]
#juri
ええ。ここは開放感があって、暖かくて……気持ちがいいわ。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01178"]
#airi
叡留久さんと一緒じゃなくて、いいんですか？[p]

#
愛理の無邪気な問いに、珠璃は少し間を置いた。[p]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v01179"]
#juri
……今はいいの。今だけはね。[p]

#airi
[voice id="v01180"]
#airi
そう……ですか。[p]

#juri
[voice id="v01181"]
#juri
……彼も仕事づくめだからね。ゆっくりさせてあげたいのよ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01182"]
#mahoru
珠璃さんが見ていないと仕事しちゃいそうですけどね。[p]
[reset_message_chara]

#juri
[voice id="v01183"]
#juri
……そうかもしれないわね。[p]

[voice id="v01184"]
#juri
もう少し、したら彼の所へ戻るわ。[p]

#
珠璃はそう言って、窓の外を見つめていた。[p]

[jump storage="scene4.ks" target="*scene_sunroom1"]

;=========================================
; イベント：観葉植物
;=========================================

*evt_sun1_plant
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(1F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_sun1_plant==1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01185"]
#mahoru
（この大きな鉢、動かしたら床を傷つけそうだな……）[p]
[reset_message_chara]
[jump target="*sunroom_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_sun1_plant = 1;
[endscript]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01186"]
#mahoru
大きい観葉植物だよね……。[p]

[voice id="v01187"]
#mahoru
鉢だけでもすごく重そう。[p]
[reset_message_chara]

#airi
[voice id="v01188"]
#airi
これ、一人で動かすのは大変そうだね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01189"]
#mahoru
床がちょっと傷んでるのも、この鉢を動かしたからかな。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01190"]
#airi
そうかも。よく見ると、この辺だけ床の感じも少し違うね。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01191"]
#mahoru
……後で足元も見てみようかな。[p]
[reset_message_chara]

[jump target="*sunroom_investigate"]


;=========================================
; イベント：テーブル
;=========================================

*evt_sun1_table
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(1F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_sun1_table==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01192"]
#mahoru
（庭にあったホワイトセージ……昔から薬草として親しまれてきたんだっけ）[p]
[reset_message_chara]
[jump target="*sunroom_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_sun1_table = 1;
[endscript]

#
テーブルの椅子に腰かけると、窓の向こうに庭園が大きく広がって見えた。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01193"]
#mahoru
ここ、座って見ると庭がよく見えるね。[p]
[reset_message_chara]

#airi
[voice id="v01194"]
#airi
本当だ。……あ、あそこ。白っぽい葉がまとまってるところ。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01195"]
#mahoru
あれ、何だろう。[p]
[reset_message_chara]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01196"]
#airi
ホワイトセージじゃない？[p]

[voice id="v01197"]
#airi
ヨーロッパには「長生きしたければ五月にセージを食べろ」っていう言い回しもあるらしいよ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01198"]
#mahoru
へえ。セージって、そんなに昔から身体にいいものとして使われてたんだ。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01199"]
#airi
薬草としては有名みたい。でも、同じセージでも種類はいろいろあるけどね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01200"]
#mahoru
庭だけでも知らないものがいっぱいあるなあ。[p]
[reset_message_chara]

[jump target="*sunroom_investigate"]

;=========================================
; 1F ── キッチン（クリッカブル版）
;=========================================

*scene_kitchen
[cm]
[inv_set chapter="s4"]
[bg storage="kitchen.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_ria_1          === 'undefined') f.event_ria_1          = 0;
if (typeof f.event_ria_2          === 'undefined') f.event_ria_2          = 0;
if (typeof f.event_kitchen_lip    === 'undefined') f.event_kitchen_lip    = 0;
if (typeof f.event_kitchen_island === 'undefined') f.event_kitchen_island = 0;
if (typeof f.event_kitchen_stove  === 'undefined') f.event_kitchen_stove  = 0;
if (typeof f.has_lipstick         === 'undefined') f.has_lipstick         = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:キッチン"]
[charapos name="koderia" face="normal" num="0"]

#
キッチンにやってきた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="kitchen"]


;-----------------------------------------------------------
; 旧UIのラベル：各イベントからの復帰先として残す
;-----------------------------------------------------------
*kitchen_talk
*kitchen_talk_return
*kitchen_talk_ui
*kitchen_investigate
[jump target="*scene_kitchen"]


;=========================================
; イベント：小出里亜との会話
;=========================================

*evt_ria
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[chara_hide_all]
[layopt layer="message0" visible=true]

[if exp="f.event_ria_1==1 && f.event_ria_2==1"]
[charapos name="koderia" face="smile" num="0"]
#koderia
[voice id="v01201"]
#koderia
夕食まで、もう少しですよ。楽しみにしていてくださいね。[p]
[jump target="*kitchen_talk_return"]
[endif]

[if exp="f.event_ria_1==1 && f.event_ria_2==0"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_ria_2 = 1;
[endscript]
[charapos name="koderia" face="smile" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01202"]
#mahoru
小出里亜さんって、メイドさん以外にもお仕事されているんですか？[p]
[reset_message_chara]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v01203"]
#koderia
ええ。日本ではメイドというより秘書や世話係という位置づけで、普段は事務のお手伝いもしているんですよ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01204"]
#mahoru
朱志香さんのところで働くことになったのは、どういう経緯で？[p]
[reset_message_chara]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v01205"]
#koderia
実は、私の家……灰音の家なんですが、富礼知家とは昔お付き合いがあって。[p]

[voice id="v01498"]
交流が途絶えていたのですが、お手伝いを探していると聞いたんです。[p]

#koderia
[voice id="v01499"]
私が働きたいと申し出たら、朱志香様が快く受け入れてくださったんです。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v01206"]
#mahoru
どうして、舞黒館で働こうと思ったんですか？[p]
[reset_message_chara]

#koderia
[voice id="v01207"]
#koderia
洋館でメイドって素晴らしい取り合わせだと思いませんか？[p]

[voice id="v01208"]
#koderia
私ずっと憧れていたんです。[p]

[voice id="v01209"]
#koderia
ちゃんとしたメイドに。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v01210"]
#mahoru
わかります！ 洋館にメイドさんは雰囲気ありますよね！[p]
[voice id="v01211"]
#mahoru
探偵ものではよく出てくるのに全然見たことなかったので、小出里亜さんを見てドキドキしましたもん！[p]
[reset_message_chara]

@chara_mod name="koderia" face="smile"

#koderia
[voice id="v01212"]
#koderia
ふふふ、ありがとうございます。[p]

[voice id="v01213"]
#koderia
そのようなわけで大きな洋館を持つ富礼知家に来たんです。[p]


[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v01214"]
#mahoru
良かったですね、夢がかなって。[p]
[reset_message_chara]

@chara_mod name="koderia" face="normal"

#koderia
[voice id="v01215"]
#koderia
……[p]

[voice id="v01216"]
#koderia
ええ、そうですね。[p]

[jump target="*kitchen_talk_return"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_ria_1 = 1;
[endscript]
[charapos name="koderia" face="normal" num="0"]

#
棚の前で、小出里亜が小さなガラス瓶を手に取っているところだった。[r]
#
真歩流が興味を惹かれて近づくと、小出里亜はびくっと振り返った。[p]

[chara_mod name="koderia" face="surprised"]
#koderia
[voice id="v01217"]
#koderia
ひゃっ！？　真白様、いつからそこに……[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01218"]
#mahoru
今来ました。何ですか、それ？[p]
[reset_message_chara]

#
真歩流が手を伸ばしかけると、小出里亜は慌てて棚へ戻した。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v01219"]
#koderia
こ、これは特別な香りづけ用のスパイスなんです……！ 企業秘密ということで、よろしくお願いします……！[p]

#
小出里亜は急いで瓶を棚にしまった。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01220"]
#mahoru
（……きっと甘い高級ジュースとかだろうなあ）[p]
[reset_message_chara]

[jump target="*kitchen_talk_return"]


;=========================================
; イベント：口紅を渡す
;=========================================

*evt_kitchen_lip
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_kitchen_lip = 1;
f.has_lipstick = 0;
[endscript]

#
キッチンのドアに手をかけた瞬間、中から会話の気配がした。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01221"]
#mahoru
……誰かいる？[p]
[reset_message_chara]

;-----------------------------------------------------------
; ここから経路で分かれる。
;   経路A … 叡留久が小出里亜のカップで紅茶を飲んでいる。
;            カップは返されるので、夜の鑑識で両者の指紋が出る。
;   経路B … 口紅はお茶会で叡留久が拾っており、真歩流は持っていない。
;            毒はすでに口紅の外側を介して叡留久の体に入っている。
;            ここでは火傷を気遣う会話だけが交わされる。
;-----------------------------------------------------------
[jump cond="f.route_b == 1" target="*evt_kitchen_lip_b"]

#
かすかに声が聞こえてくる。[p]

#
……え、……い……てる？[p]
#
ああ……[p]

#
そっと扉を開けると、叡留久がカップを持ってキッチンから出てくるところだった。[p]

[charapos name="eruku" face="normal" num="0"]
; ▼ 要ボイス再録：v01222（旧「やあ、君も何か飲み物を取りに来たのかい？ 僕も喉が渇いちゃってね。」）
#eruku
[voice id="v01222"]
#eruku
やあ。喉が渇いてね、一杯もらっていたんだ。[p]

[chara_hide_all]
[charapos name="eruku" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]

; ▼ 以下、新規会話は要ボイス収録
#eruku
[voice id="v03812"]
小出里亜さん、ありがとう。紅茶、美味しかったよ。[p]

#
叡留久はカップを小出里亜に手渡した。[p]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v03813"]
……いえ。お口に合ったのなら何よりです。[p]

[chara_mod name="eruku" face="normal"]
; ▼ 要ボイス再録：v01223（旧「それじゃ、お先に失礼。」）
[voice id="v01223"]
#eruku
それじゃあ、僕はお先に。[p]

#
叡留久はそう言うと、ひとつ会釈してそのまま廊下へと去っていった。[p]

[chara_hide_all]
[charapos name="koderia" face="normal" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01224"]
#mahoru
小出里亜さん、これ落としてたんじゃないかと思って。[p]
[reset_message_chara]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v01225"]
#koderia
あら……！ ありがとうございます。リビングに忘れてしまっていたんですね。[p]

#
小出里亜は口紅を受け取り、丁寧に礼をした。[p]

[chara_hide_all]
; キッチンに留まる（investigation_start には戻らない）
[jump target="*scene_kitchen"]


;=========================================
; イベント：キッチンの様子を見る（経路B）
;   口紅は叡留久が持ったまま。返す場面は起きない。
;   代わりに、火傷を気遣う二人の会話を扉ごしに聞く。
;=========================================
*evt_kitchen_lip_b
;   ここで叡留久は、お茶会で拾った口紅を小出里亜へ返している。
;   真歩流には見えない。聞こえるのは礼の言葉だけで、
;   何に対する礼なのかは夜になるまで分からない。
; ▼ 以下、新規会話は要ボイス収録
#
かすかに声が聞こえてくる。[p]

#
……ありがとうございます。[p]
#
いいさ。手は大丈夫かい。[p]
#
はい、大丈夫です。[p]
#
それなら、良かった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03814"]
（小出里亜さんの火傷のこと、気にかけてるんだ）[p]
[reset_message_chara]

#
そっと扉を開けると、叡留久がキッチンから出てくるところだった。[r]
#
上着の前を軽く払うようにして、こちらへ会釈する。[p]

[charapos name="eruku" face="normal" num="0"]

#eruku
[voice id="v03815"]
やあ。[p]

#eruku
[voice id="v03816"]
小出里亜さんの手が心配でね。少し様子を見に来ていたんだ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03817"]
……お優しいんですね。[p]
[reset_message_chara]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v03818"]
そんな大層なものじゃないよ。[p]

; ▼ 要ボイス再録：v01223（旧「それじゃ、お先に失礼。」）
[chara_mod name="eruku" face="normal"]
#eruku
[voice id="v03954"]
それじゃあ、僕はお先に。[p]

#
叡留久はそう言うと、ひとつ会釈してそのまま廊下へと去っていった。[p]

[chara_hide_all]
[charapos name="koderia" face="normal" num="0"]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v03820"]
……真歩流様。お騒がせしてしまって、申し訳ありません。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03821"]
いえ。手、まだ痛みますか？[p]
[reset_message_chara]

#koderia
[voice id="v03822"]
もう平気ですよ。徐音様に診ていただきましたから。[p]

#
小出里亜はそう言って、右手をそっと後ろへ回した。[p]

#
もう片方の手は、エプロンのポケットのあたりを押さえていた。[p]

[chara_hide_all]
; キッチンに留まる（investigation_start には戻らない）
[jump target="*scene_kitchen"]


;=========================================
; イベント：キッチンアイランド
;=========================================

*evt_kitchen_island
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_kitchen_island==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01226"]
#mahoru
新鮮な野菜が並んでる。夕食が楽しみだな。[p]
[reset_message_chara]
[jump target="*kitchen_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_kitchen_island = 1;
[endscript]

#
テーブルには、調理道具が並べられていた。[r]
#
夕食の準備が着々と進んでいるようだ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01227"]
#mahoru
すごい……本格的だね。小出里亜さん、料理が得意なんだ。[p]
[reset_message_chara]

#airi
[voice id="v01228"]
#airi
美味しそうな匂いがしてきた。早く食べたいな。[p]

[voice id="v01229"]
#airi
キッチンで思い出したけど、私たちの宿泊する部屋も調べたほうがいいかも。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01230"]
#mahoru
どうして？[p]
[reset_message_chara]

#airi
[voice id="v01231"]
#airi
宿泊部屋って普段は非公開だから、何かあるかもしれない。[p]

[jump target="*kitchen_investigate"]


;=========================================
; イベント：コンロ・棚
;=========================================

*evt_kitchen_stove
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:キッチン"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_kitchen_stove==1"]
[if exp="f.event_ria_1==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01232"]
#mahoru
（小出里亜さんがしまった小瓶……あれは本当にスパイスなのかな）[p]

[voice id="v01233"]
#mahoru
もしかして、輸入物の高級な何かだったりして……[p]

[voice id="v01234"]
#mahoru
うーん、気になる。[p]
[reset_message_chara]

[else]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01235"]
#mahoru
年代物のコンロだけど、しっかり現役みたいだね。[p]
[reset_message_chara]
[endif]
[jump target="*kitchen_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_kitchen_stove = 1;
[endscript]

#
年代を感じさせる大きな鋳鉄製のコンロが、堂々と構えていた。[r]
#
磨き込まれた銅製の鍋がいくつも吊るされている。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01236"]
#mahoru
すごい存在感……。昔の西洋館みたいだね。[p]
[reset_message_chara]

#airi
[voice id="v01237"]
#airi
本当に。この館、どこを見ても凝ってるよね。[p]

[if exp="f.event_ria_1==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01238"]
#mahoru
（そういえば……小出里亜さんがここの棚に戻していたあの瓶。絶対ジュースだよね！）[p]
[reset_message_chara]
[endif]

[jump target="*kitchen_investigate"]

;=========================================
; 1F ── 廊下
;=========================================
*scene_rouka1
[cm]
[bg storage="hallway.png" time=500]
[chara_hide_all]
[charapos name="airi" face="normal" num="0"]
[scene_setup]
[gage_draw place="舞黒館:廊下(1F)"]

[if exp="f.event_airi_hall == 0"]
[iscript]
f.event_airi_hall = 1;
[endscript]

#
廊下を歩いていると、愛理が立ち止まった。[p]

#airi
[voice id="v01239"]
#airi
お姉ちゃん、お父さんの手がかりが見つかるといいね。[p]

#airi
[voice id="v01240"]
#airi
……なんとなくだけど、2Fにある資料室が怪しい気がするんだよね。[p]

[message_chara name="mahoru" face="light_thinking"]

#mahoru
[voice id="v01241"]
#mahoru
どうして？[p]

[reset_message_chara]
#airi
[voice id="v01242"]
#airi
舞黒館の過去の記録とかがあるなら、そこに何かあるかもしれないでしょ。[p]

#airi
[voice id="v01243"]
#airi
お父さんが舞黒館に来た理由も、そこにあるかも。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v01244"]
#mahoru
そうだね。行ってみよう。[p]

[reset_message_chara]

;--- 階段脇の飾り棚から青い硝子を見つける ---
[iscript]
f.glass_blue = 1;
[endscript]

#
歩き出そうとしたとき、階段脇の飾り棚が目に入った。[r]
#
硝子戸の中に、写真立てや小物に混じって、板状の硝子が立てかけてある。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01245"]
#airi
お姉ちゃん、これ何だろう。青いガラスの板……[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01246"]
#mahoru
飾りにしては地味だね。……縁が真鍮で縁取られている。[p]
[reset_message_chara]

#
手のひらほどの、真鍮縁の青い硝子板だった。[r]
#
埃をかぶっておらず、時折誰かが手に取っているように見える。[p]

[get_item id="glass_blue"]
[iscript]
f.status["glass_blue"].owned = true;
[endscript]

[else]
#
廊下は静かだった。[p]
[endif]

[chara_hide_all]
[jump target="*investigation_start"]


;=========================================
; 1F ── 玄関（クリッカブル版）
;=========================================

*scene_genkan
[cm]
[inv_set chapter="s4"]
[bg storage="entrance.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_genkan        === 'undefined') f.event_genkan        = 0;
if (typeof f.has_entrance_record === 'undefined') f.has_entrance_record = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[charapos name="airi" face="normal" num="0"]

#
ステンドグラスが彩る玄関ホール。外の光が床に色鮮やかな模様を描いていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="genkan"]


;=========================================
; イベント：記帳台を調べる
;=========================================

*evt_genkan_record
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:玄関(1F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_genkan==1"]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01500"]
（半年前、お父さんは確かに舞黒館へ来ていた。目的は「資料閲覧」……）[p]
[reset_message_chara]
[jump storage="scene4.ks" target="*scene_genkan"]
[endif]

[jump cond="f.game_time >= 1080" storage="scene4.ks" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_genkan = 1;
f.has_entrance_record = 1;
f.father_visit_found = 1;
[endscript]

#
玄関の脇にある記帳台に、宿泊者全員の入館記録が置いてあった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01248"]
#mahoru
これ、入館の際に記入したやつだ。[p]
[reset_message_chara]

#
ページをめくっていくと、ある記述が目に留まった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01249"]
#mahoru
……珠璃さんたち、随分早く来たんだね。[p]
[voice id="v01250"]
#mahoru
うーん、やっぱりこういうのは早く来るのがマナーなのかな。[p]
[reset_message_chara]

#airi
[voice id="v01251"]
#airi
それにしても随分早いね。[p]

[voice id="v01252"]
#airi
……。[p]

[get_item id="records"]
[eval exp="f.morning_action = 1"]
[set_item_status id="records" owned="true"]

; ここから父親探索の進展
; ▼ 要ボイス収録
#
記帳台の下には、日付ごとに綴じられた過去の来館記録も並んでいた。[p]
#
真歩流は半年前の冊子を取り出し、ページを一枚ずつ追っていった。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01501"]
……お姉ちゃん。ここ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01502"]
「真白 奢禄」……。[p]

#mahoru
[voice id="v01503"]
お父さんの名前だ。[p]
[reset_message_chara]

#airi
[voice id="v01504"]
本当に来てたんだ……。メールに舞黒館って書いてあっただけじゃなかったんだね。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01505"]
来館目的は……「資料閲覧」。[p]

#mahoru
[voice id="v01506"]
お父さん、ここで何かを調べてたんだ。[p]
[reset_message_chara]

[get_item name="父の来館記録" type="info" memo="半年前、真白奢禄が舞黒館を訪れていた。来館目的の欄には「資料閲覧」と記されている。"]

[chara_hide_all]
[jump storage="scene4.ks" target="*scene_genkan"]


;===============================================================================
; 新規イベント：資料閲覧簿
;   父が何を調べていたかを施設側の管理記録から追う
;===============================================================================

*scene_bedroom
[cm]
[inv_set chapter="s4"]
[bg storage="bedroom.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_bd_kazuto  === 'undefined') f.event_bd_kazuto  = 0;
if (typeof f.event_bd_juri === 'undefined') f.event_bd_juri = 0;
if (typeof f.event_bd_mary    === 'undefined') f.event_bd_mary    = 0;
if (typeof f.event_bd_mashiro === 'undefined') f.event_bd_mashiro = 0;
if (typeof f.event_bd_mary_desk    === 'undefined') f.event_bd_mary_desk    = 0;
if (typeof f.event_bd_mashiro_shelf === 'undefined') f.event_bd_mashiro_shelf = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:宿泊部屋(2F)"]
[charapos name="airi" face="normal" num="0"]

#
宿泊部屋の並ぶ一角には、誰もいなかった。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01253"]
#mahoru
部屋ごとに分かれてるんだね。どの部屋から見てみようか。[p]
[reset_message_chara]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_wing id="bedroom"]


;-----------------------------------------------------------
; 宿泊部屋：穂在呂夫妻の部屋
;-----------------------------------------------------------
*scene_bd_hozairo
[cm]
[inv_set chapter="s4"]
[bg storage="room_hoaro.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:穂在呂夫妻の部屋(2F)"]

#
穂在呂夫妻の部屋。夫婦二人分の荷物が、きちんと壁際にまとめられていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="bd_hozairo"]


;-----------------------------------------------------------
; 宿泊部屋：和人の部屋
;-----------------------------------------------------------
*scene_bd_kazuto
[cm]
[inv_set chapter="s4"]
[bg storage="room_kazuto.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:和人の部屋(2F)"]

#
和人の部屋。物が少なく、荷物はきちんと一か所に置かれていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="bd_kazuto"]


;-----------------------------------------------------------
; 宿泊部屋：メアリーの部屋
;-----------------------------------------------------------
*scene_bd_mary
[cm]
[inv_set chapter="s4"]
[bg storage="room_mary.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:メアリーの部屋(2F)"]

#
メアリーの部屋。扉を開けた瞬間、柔らかな花の香りがふわりと流れ出した。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="bd_mary"]


;-----------------------------------------------------------
; 宿泊部屋：真白姉妹の部屋
;-----------------------------------------------------------
*scene_bd_mashiro
[cm]
[inv_set chapter="s4"]
[bg storage="room_mashiro.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[gage_draw place="舞黒館:真白姉妹の部屋(2F)"]
[charapos name="airi" face="smile" num="0"]

#
私と愛理にあてがわれた部屋。朝に置いたバッグがそのままになっていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="bd_mashiro"]


;=========================================
; イベント：和人のリュックを調べる
;=========================================

*evt_bd_kazuto
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:和人の部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_kazuto==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01254"]
#mahoru
（リュックパンパンで重くないのかな？）[p]
[reset_message_chara]
[jump target="*scene_bd_kazuto"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_kazuto = 1;
[endscript]

#
和人のリュックサックは几帳面に置かれていた。[r]
#
外からでも中身がうっすらと見える。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01255"]
#mahoru
本と……薬を入れるような瓶？[p]

[voice id="v01256"]
#mahoru
勉強のために持ってきたのかな？[p]
[reset_message_chara]

#airi
[voice id="v01257"]
#airi
宿泊イベントで？[p]

[voice id="v01258"]
#airi
大学の帰りにそのまま来たんじゃない。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01259"]
#mahoru
確かにそうかも。[p]

[voice id="v01260"]
#mahoru
和人は宿泊イベントに来たのにあまり楽しんでなさそうだけど、何かあったのかな。[p]
[reset_message_chara]

#airi
[voice id="v01261"]
#airi
何か別で目的があるとか？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01262"]
#mahoru
何かって？[p]

[reset_message_chara]

#airi
[voice id="v01263"]
#airi
例えば、誰かに会いに来たとか……そんなわけないね。[p]

[jump target="*scene_bd_kazuto"]


;=========================================
; イベント：和人の部屋の書棚（緑の硝子）
;=========================================

*evt_bd_kazuto_shelf
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:和人の部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_kazuto_shelf==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01264"]
#mahoru
（本の奥に、緑の硝子が挟まっていた）[p]
[reset_message_chara]
[jump target="*scene_bd_kazuto"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_kazuto_shelf = 1;
f.glass_green = 1;
[endscript]

#
壁際の書棚には、革張りの古書がびっしりと並んでいた。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01265"]
#airi
……ねえお姉ちゃん。ここだけ、背表紙の高さが揃ってないよ。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01266"]
#mahoru
本当だ。一冊だけ、奥に押し込まれてる。[p]
[reset_message_chara]

#
その本を引き出すと、奥の板との隙間に、緑の硝子板が立てて挟まれていた。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01267"]
#airi
緑色の硝子だ！[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01268"]
#mahoru
……館のあちこちに散らばってる、ってことかな。[p]
[reset_message_chara]

[get_item id="glass_green"]
[iscript]
f.status["glass_green"].owned = true;
[endscript]

[chara_hide_all]
[jump target="*scene_bd_kazuto"]


;=========================================
; イベント：珠璃のスーツケースを調べる
;=========================================

*evt_bd_juri
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:穂在呂夫妻の部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_juri==1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01269"]
#mahoru
（持ち手だけ濡れてたのは……何だったんだろう）[p]
[reset_message_chara]
[jump storage="scene4.ks" target="*scene_bd_hozairo"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_juri = 1;
[endscript]

#
珠璃のスーツケースを何気なく見ると、持ち手の部分がうっすらと濡れていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01270"]
#mahoru
……ここだけ濡れてる。何かこぼしたのかな。[p]
[reset_message_chara]

[jump storage="scene4.ks" target="*scene_bd_hozairo"]


;=========================================
; イベント：メアリーのスーツケースを調べる
;=========================================

*evt_bd_mary
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:メアリーの部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_mary==1"]
[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01271"]
#mahoru
（いい香り……メアリーさんらしいな）[p]
[reset_message_chara]
[jump target="*scene_bd_mary"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_mary = 1;
[endscript]

#
メアリーのスーツケースのそばを通りかかると、複数の花の香りがふわりと漂ってきた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01272"]
#mahoru
香水……たくさん持ってきてるんだね。手作りって言ってたし、研究熱心なんだなあ。[p]
[reset_message_chara]

[jump target="*scene_bd_mary"]


;=========================================
; イベント：メアリーの部屋の机（絵画）
;=========================================

*evt_bd_mary_desk
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:メアリーの部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_mary_desk==1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01273"]
#mahoru
（絵の裏の言葉……青き光は真っすぐな道の中に、かあ）[p]
[reset_message_chara]
[jump target="*scene_bd_mary"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_mary_desk = 1;
[endscript]

#
窓際の書き物机には、布のかかった額が立てかけられていた。[r]
#
布をそっとめくると、油絵の具の厚みが指先に触れた。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01274"]
#airi
わ……綺麗な絵。湖かな。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01275"]
#mahoru
うん。あ、縁のところに文字が入ってる。[p]

[voice id="v01276"]
#mahoru
……『舞黒邦夢肖像』？　この帽子のおじさんが、舞黒邦夢さん？[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01277"]
#airi
お姉ちゃん、裏。裏にも何か書いてあるよ。[p]

#
額を裏返すと、褪せたインクで一行だけ書き込まれていた。[p]

#
青き光は真っすぐな道の中に……[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01278"]
#mahoru
青き光……。意味はわからないけど、覚えておこう。[p]
[reset_message_chara]

[get_item id="picture"]
[iscript]
f.status["picture"].owned = true;
[endscript]

[chara_hide_all]
[jump target="*scene_bd_mary"]


;=========================================
; イベント：自分たちの荷物を調べる
;=========================================

*evt_bd_mashiro
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:真白姉妹の部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_mashiro==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01279"]
#mahoru
（忘れ物はない。他の宿泊部屋も、普段は見られない場所なんだよね）[p]
[reset_message_chara]
[jump target="*scene_bd_mashiro"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_mashiro = 1;
[endscript]

#
朝に置いたままのバッグを開けてみる。[r]
#
着替えと洗面用具を確認したが、忘れ物はなさそうだ。[p]

[chara_mod name="airi" face="smile"]
#airi
[voice id="v01280"]
#airi
よし。これなら帰る時に慌てなくて済むね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01281"]
#mahoru
こうして見ると、普通の宿泊部屋だね。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01282"]
#airi
私たちの部屋はね。[p]

[voice id="v01283"]
#airi
そういえば、他の人の寝室ってどうなってるんだろう。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01284"]
#mahoru
え、勝手に見ていいの？[p]
[reset_message_chara]

#airi
[voice id="v01285"]
#airi
調査のためでしょ。宿泊部屋は普段は非公開みたいだし、今だから見られるものもあるかもしれないよ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01286"]
#mahoru
……なるほど。じゃあ、他の部屋も少し見てみようか。[p]
[reset_message_chara]

[jump target="*scene_bd_mashiro"]


;=========================================
; イベント：真白姉妹の部屋の本棚（古い写真）
;=========================================

*evt_bd_mashiro_shelf
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:真白姉妹の部屋(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_bd_mashiro_shelf==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01287"]
#mahoru
（1935年の写真……どんな人たちだったんだろう）[p]
[reset_message_chara]
[jump target="*scene_bd_mashiro"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_bd_mashiro_shelf = 1;
[endscript]

#
部屋の本棚には、背の高い洋書が隙間なく並んでいた。[r]
#
その一冊を抜くと、間から一枚の写真がひらりと落ちた。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01288"]
#airi
写真……？　ずいぶん古いね。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01289"]
#mahoru
セピア色になってる。洋館の中で撮ったのかな。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01290"]
#airi
裏に文字。……1935年。それと、名前がいくつか。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01291"]
#mahoru
舞黒邦夢さんと親しかった人たち、ってことかな。[p]

[voice id="v01292"]
#mahoru
（この人たちの中に、私の知ってる誰かがいたりして……なんてね）[p]
[reset_message_chara]

[get_item id="old_photo"]
[iscript]
f.status["old_photo"].owned = true;
[endscript]

[chara_hide_all]
[jump target="*scene_bd_mashiro"]


;=========================================
; 2F ── サンルーム（クリッカブル版）
;=========================================

*scene_sunroom2
[cm]
[inv_set chapter="s4"]
[bg storage="sunroom_second.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_sun2_check === 'undefined') f.event_sun2_check = 0;
if (typeof f.event_sun2_fireplace === 'undefined') f.event_sun2_fireplace = 0;
if (typeof f.radio_code_known === 'undefined') f.radio_code_known = 0;
if (typeof f.has_old_key      === 'undefined') f.has_old_key      = 0;
if (typeof f.has_blueprint    === 'undefined') f.has_blueprint    = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]

#
2階のサンルームは1階よりも小ぢんまりとしていたが、趣のある空間だった。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="sunroom2"]


;=========================================
; イベント：椅子を調べる
;=========================================

*evt_sun2_chair
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_sun2_check==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01293"]
#mahoru
（椅子に座った高さから見ると、暖炉の炉と上部の間に妙な隙間が見えた）[p]
[reset_message_chara]
[jump target="*scene_sunroom2"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_sun2_check = 1;
[endscript]

#
ふかふかの椅子に腰を下ろすと、身体がゆっくり沈み込んだ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01294"]
#mahoru
うわ、すごく座り心地いい。[p]

[voice id="v01295"]
#mahoru
昔の椅子なのに、ちゃんと手入れされてるんだね。[p]
[reset_message_chara]

#airi
[voice id="v01296"]
#airi
本当。……あれ？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01297"]
#mahoru
どうしたの？[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01298"]
#airi
座ると目線が低くなるからかな。暖炉のところ、立ってた時には気づかなかったけど……。[p]

[voice id="v01299"]
#airi
炉の燃やすところと、その上の部分の間に少し隙間がある。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01300"]
#mahoru
本当だ。飾りにしては妙な隙間だね。[p]
[reset_message_chara]

#airi
[voice id="v01301"]
#airi
暖炉そのものを調べたら、何かわかるかもしれないね。[p]

[jump target="*scene_sunroom2"]


;=========================================
; イベント：暖炉
;=========================================

*evt_sun2_fireplace
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:サンルーム(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

; ── すでに開けている ──
[if exp="f.event_sun2_fireplace==1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01302"]
#mahoru
（設計図……地下の通路、本当にあるのかな）[p]
[reset_message_chara]
[jump target="*scene_sunroom2"]
[endif]

; ── 初回だけ：蓋が外れてダイヤル錠が現れる（ここが「成果」なので時間を使う） ──
[if exp="f.event_sun2_dial_found!=1"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.event_sun2_dial_found = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01303"]
#mahoru
暖炉っていいなあ。[p]

[reset_message_chara]

#airi
[voice id="v01304"]
#airi
お姉ちゃんあんまりべたべた触って壊さないでよ。[p]

@playse storage="break.mp3"

#
パキャ。[p]

[message_chara name="mahoru" face="aho"]

#mahoru
[voice id="v01305"]
#mahoru
あれっ……[p]

[reset_message_chara]

@chara_mod name="airi" face=surprised

#airi
[voice id="v01306"]
#airi
ちょっと！ 今の音は何！[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v01307"]
#mahoru
どどど、どうしよう愛理！ 蓋が取れちゃった！[p]

[reset_message_chara]

#airi
[voice id="v01308"]
#airi
蓋？[p]

@chara_mod name="airi" face="thinking"

#airi
[voice id="v01309"]
#airi
これ、側面が外れるようになっているみたい。[p]

[voice id="v01310"]
#airi
その下にはダイヤル式の仕掛けがあるね。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01311"]
#mahoru
なんだ、良かった！[p]

[reset_message_chara]

@chara_mod name="airi" face="anger"
#airi
[voice id="v01312"]
#airi
良かったじゃないでしょ、お姉ちゃん！！[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01313"]
#mahoru
ひいい！ ごめんなさい！[p]

[reset_message_chara]

@chara_mod name="airi" face="thinking"
#airi
[voice id="v01314"]
#airi
でも、このダイヤル式の仕掛けを解いたらどうなるんだろう。[p]
[else]

#
暖炉の側面を外すと、真鍮の環が四つ並んだダイヤル錠が現れる。[p]
[endif]

; ── 四桁を知らないうちは、錠を眺めるだけ ──
[if exp="f.radio_code_known!=1"]
[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01315"]
#airi
当てずっぽうで回しても、たぶん一万通りだよ……[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01316"]
#mahoru
どこかに数字の手がかりがあるはず。探してみよう。[p]
[reset_message_chara]
[chara_hide_all]
[jump target="*scene_sunroom2"]
[endif]

; ── 四桁を聞いていれば、ダイヤル錠に挑戦できる ──
[chara_mod name="airi" face="normal"]
#airi
[voice id="v01317"]
#airi
ラジオが読み上げてた数字……試してみようよ。[p]

[chara_hide_all]
[layopt layer="message0" visible=false]
; 挑戦するだけなら時間は使わない。開錠できたときにだけ3分を数える
[jump cond="f.game_time >= 1080" target="*time_over"]
[call storage="system/gimmick.ks" target="*gm_dial"]

[show_menu]
[bg storage="sunroom_second.png" time=300]
[gage_draw place="舞黒館:サンルーム(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="tf.gm_result != 'solved'"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01318"]
#mahoru
……もう一度、落ち着いて合わせてみよう。[p]
[reset_message_chara]
[chara_hide_all]
[jump target="*scene_sunroom2"]
[endif]

[iscript]
f.event_sun2_fireplace = 1;
f.has_blueprint = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

#
四つの環が数字を揃えた瞬間、内側で閂の外れる音がした。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01319"]
#mahoru
開いた！[p]
[reset_message_chara]

#
炉の奥は小さな金庫になっており、分厚い古い資料が収まっていた。[p]

[charapos name="airi" face="surprised" num="0"]
#airi
[voice id="v01320"]
#airi
これ……設計図？[p]

#
二人で広げてみると、舞黒館の詳細な建築図面だった。[r]
#
かなり古いものだが、保存状態は良い。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01321"]
#airi
見て、お姉ちゃん。ここ……地下部分に空間が描かれてる！[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01322"]
#mahoru
やっぱり地下はあるんだね……！？[p]
[reset_message_chara]

#airi
[voice id="v01323"]
#airi
資料室にあった『秘密の避難経路』って、これのことだったんだ。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01324"]
#airi
設計図を確認すると……地下部分に続く入口がある。でも、この館のどこにあるんだろう。[p]

; 地下への入口を知ったことは has_blueprint がそのまま示すので、別フラグは持たない
[get_item id="blueprint"]
[iscript]
f.status["blueprint"].owned = true;
[endscript]
[chara_hide_all]
[free_layer_image]
; サンルーム(2F)に留まる
[jump target="*scene_sunroom2"]


;=========================================
; 2F ── 資料室（クリッカブル版）
;=========================================

*scene_archive
[cm]
[inv_set chapter="s4"]
[bg storage="reference_room.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_arc_kazuto  === 'undefined') f.event_arc_kazuto  = 0;
if (typeof f.event_arc_plate   === 'undefined') f.event_arc_plate   = 0;
if (typeof f.event_arc_record  === 'undefined') f.event_arc_record  = 0;
if (typeof f.event_arc_route   === 'undefined') f.event_arc_route   = 0;
if (typeof f.event_kazuto_sun  === 'undefined') f.event_kazuto_sun  = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[charapos name="kazuto" face="normal" num="0"]

#
資料室には、舞黒館に関する様々な資料が保管されていた。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="archive"]


;-----------------------------------------------------------
; 旧UIのラベル：各イベントからの復帰先として残す
;-----------------------------------------------------------
*archive_talk
*archive_talk_return
*archive_talk_ui
*archive_investigate
[jump target="*scene_archive"]


;=========================================
; イベント：和人との会話
;=========================================

*evt_arc_access
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_arc_access==1"]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01507"]
（お父さんは半年前、地下増築や建築、それに戦前の記録まで調べていた……）[p]
[reset_message_chara]
[jump storage="scene4.ks" target="*archive_investigate"]
[endif]

[jump cond="f.game_time >= 1080" storage="scene4.ks" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_arc_access = 1;
f.father_research_found = 1;
[endscript]


#
棚の端に、比較的新しい革表紙の冊子があった。[r]
#
表紙には「資料閲覧簿」と印字されている。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01508"]
古い資料は貴重だから、誰が何を見たか記録してるみたい。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01509"]
だったら……半年前の記録もあるかも。[p]
[reset_message_chara]

#
玄関の記帳簿で見つけた日付まで遡る。[r]
#
そこには「真白 奢禄」の名前が記されていた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01510"]
あった……！[p]
[reset_message_chara]

#airi
[voice id="v01511"]
閲覧した資料も書いてあるよ。[p]

#
――舞黒館　地下増築関係資料。[r]
#
――舞黒館　建築関係資料。[r]
#
――昭和十年前後　訪問者記録。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01512"]
お父さん、舞黒館そのものについてかなり調べてたんだ。[p]
#mahoru
[voice id="v01513"]
何を探してたんだろう……。[p]
[reset_message_chara]

[get_item name="父の資料閲覧記録" type="info" memo="半年前、奢禄は舞黒館の地下増築・建築関係資料・昭和十年前後の訪問者記録を閲覧していた。"]
[chara_hide_all]
[jump storage="scene4.ks" target="*archive_investigate"]

*evt_arc_kazuto
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="kazuto" face="normal" num="0"]

[if exp="f.event_arc_kazuto==1"]
[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v01325"]
#kazuto
……まだここにいる。気になることが残っているからな。[p]
[jump target="*archive_talk_return"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_arc_kazuto = 1;
[endscript]

#
資料室の隅で、和人が古い資料をめくっていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01326"]
#mahoru
和人、ここで何を調べているの？[p]
[reset_message_chara]

#kazuto
[voice id="v01327"]
#kazuto
過去の資料を見ていただけだ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01328"]
#mahoru
……そういえば、どうして今回のイベントに参加したの？[p]
[reset_message_chara]

#
和人はしばらく黙っていたが、やがて口を開いた。[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v01329"]
#kazuto
……俺の母親が経営していた薬屋の庭で、品種改良したセージを育てていた。[p]

#kazuto
[voice id="v01330"]
#kazuto
日本でしか育たない特殊な品種で、脳機能の働きを向上させる効果があると言われている。[p]

[voice id="v01331"]
#kazuto
それが、舞黒館の庭にあると聞いたから、見に来た。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01332"]
#mahoru
脳機能を改善するセージ？ 初めて聞いた。[p]

[reset_message_chara]

#kazuto
[voice id="v01333"]
#kazuto
そうだろうな。何と言ってもそのセージは母さんが作った品種だからな。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01334"]
#mahoru
和人のお母さんが作ったの？[p]

[reset_message_chara]

#kazuto
[voice id="v01335"]
#kazuto
俺の母親は、元は薬の研究をしていたからな。[p]

[voice id="v01336"]
#kazuto
そのセージが本当にあるのか確かめに来たんだ。[p]

[message_chara name="airi" face="normal"]
#airi
[voice id="v01337"]
#airi
どうして、わざわざ確かめに来たの？ 調べればすぐにわかりそうだけど。[p]

[reset_message_chara]

#kazuto
[voice id="v01338"]
#kazuto
ホワイトセージと見分けがつきにくいからな。[p]

[voice id="v01339"]
#kazuto
知識のある人間じゃないと見分けるのは難しいんだ。[p]

#airi
[voice id="v01340"]
#airi
確かにそれだと難しいね。[p]

#kazuto
[voice id="v01341"]
#kazuto
それに……母さんの研究資料が紛失していてな。[p]

[voice id="v01342"]
#kazuto
もしかしたら、ここにあるんじゃないかと思ったんだ……[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01343"]
#mahoru
優しいんだね和人。[p]

[reset_message_chara]

#kazuto
[voice id="v01344"]
#kazuto
……そんなんじゃない。[p]

[voice id="v01345"]
#kazuto
俺は……[p]

#
和人はそこまで言うと黙ってしまった。[p]

[jump target="*archive_talk_return"]

;=========================================
; イベント：壁のプレートを調べる
;=========================================

*evt_arc_plate
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_arc_plate==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01346"]
#mahoru
（真白小五郎……私たちと同じ名字。何か繋がりがあるのかな）[p]
[reset_message_chara]
[jump target="*archive_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_arc_plate = 1;
[endscript]

#
壁に、「地下増築工事 共同出資者一覧　昭和五年」と題した書類があった。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01347"]
#airi
お姉ちゃん、見て！　この名前……[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01348"]
#mahoru
『真白小五郎』……真白って、私たちと同じ名字！[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01349"]
#airi
何か関係があるのかな。でも、同じ名字というだけで他人って可能性もある……[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01350"]
#mahoru
それに……『富礼知』って名前もある。[p]
[voice id="v01351"]
#mahoru
昔この館の工事に関わった家だって、朱志香さんが言っていたよね。[p]
[reset_message_chara]

#airi
[voice id="v01352"]
#airi
もしかしたら、私たちの家系はここに縁があるのかもしれない。[p]

[voice id="v01353"]
#airi
（お父さんはその謎を探っていたんじゃ……）[p]

; 富礼知家が地下増築工事の出資者だったと分かった
[set_item_status id="photo" secret="true"]
[get_item id="photo" type="info"]

[jump target="*archive_investigate"]


;=========================================
; イベント：記録表を調べる
;=========================================

*evt_arc_record
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_arc_record==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01354"]
#mahoru
（世界中から要人が来ていたんだ……すごいなあ）[p]
[reset_message_chara]
[jump target="*archive_investigate"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_arc_record = 1;
[endscript]

#
棚の一角に、「戦前の訪問者記録」と書かれた冊子があった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01355"]
#mahoru
この記録、すごい数の訪問者……世界各国から来てたんだね。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01356"]
#airi
当時の舞黒館は、各国の要人が訪れるほどの場所だったんだね。第二次世界大戦が始まる前までだけど。[p]

#
当時の記録は非常に貴重なため、厳重に保管されているという注記があった。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01357"]
#mahoru
朱志香さんに頼めば見せてくれるかな。[p]
[reset_message_chara]

[jump target="*archive_investigate"]


;=========================================
; イベント：秘密の経路に関する資料を読む
;=========================================

*evt_arc_route
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_arc_route==1"]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01514"]
（古い模型では、2階談話室の窓側だけ外形と室内の奥行きが合っていない……）[p]
[reset_message_chara]
[jump storage="scene4.ks" target="*archive_investigate"]
[endif]

[jump cond="f.game_time >= 1080" storage="scene4.ks" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_arc_route = 1;
f.lounge_hidden_hint = 1;
[endscript]

#
朱志香から借りた鍵でガラスケースを開け、舞黒館の古い模型を間近で確認する。[r]
#
台座には、増築当時の記録をまとめた薄い冊子も収められていた。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01515"]
昭和五年に、地下施設を増築したって書いてある。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01516"]
地下……。やっぱり、この館には表から見えない場所があるんだ。[p]
[reset_message_chara]

#
記録には、舞黒邦夢が地下に重要なものを保管するための設備も設けたことが簡潔に記されていた。[p]

#airi
[voice id="v01517"]
重要なものって、何だろう。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01518"]
そこまでは書いてないね。[p]
[reset_message_chara]

#
真歩流は模型を横から覗き込み、実際に歩いた館内を思い返した。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01519"]
……あれ？[p]
#mahoru
[voice id="v01520"]
愛理。2階の談話室って、窓側はあんなに張り出してたっけ。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01521"]
模型だと、部屋の外側が少し膨らんでるね。[p]
#airi
[voice id="v01522"]
でも中から見たとき、そんな奥行きなかった気がする。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01523"]
壁の厚みだけじゃ説明できないよね。[p]
#mahoru
[voice id="v01524"]
……談話室を見てみよう。[p]
[reset_message_chara]

; 邦夢が昭和五年（1930年）に地下を増築したと分かった
[set_item_status id="chara_11" secret="true"]
[get_item id="chara_11" type="info"]

[get_item name="模型と談話室のずれ" type="info" memo="古い模型では、2F談話室の窓側が実際の室内より外へ張り出して見える。模型と現在の部屋の奥行きが一致していない。"]

[chara_hide_all]
[jump storage="scene4.ks" target="*archive_investigate"]

*evt_arc_shelf
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:資料室(2F)"]
[chara_hide_all]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

; ── すでに解いている ──
[if exp="f.glass_solved==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01364"]
#mahoru
（三枚の硝子が示したのは――『執務机裏』）[p]
[reset_message_chara]
[jump target="*archive_investigate"]
[endif]

; ── 初回だけ：光る台座を見つける（ここが「成果」なので時間を使う） ──
[if exp="f.event_arc_shelf!=1"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.event_arc_shelf = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

#
梯子を登って上段の棚に手を伸ばすと、本の列の裏に木の板がはめ込まれていた。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01365"]
#airi
お姉ちゃん、そこ！　板の真ん中が明るくない？[p]

#
板を外すと、内側から乳白色の光が漏れた。[r]
#
背後に小さな灯りが仕込まれていて、板は硝子を載せるための台になっている。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01366"]
#mahoru
ここに、何かを重ねろってこと……？[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01367"]
#airi
三つの原色を重ねれば、知識の宝庫に新たな兆しが現れる――[p]

[endif]

; ── 三色が揃っていない ──
[if exp="f.glass_blue!=1 || f.glass_red!=1 || f.glass_green!=1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01368"]
#mahoru
原色は三つ……青、赤、緑。それらを象徴する何かがあるのかも。[p]
[reset_message_chara]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01369"]
#airi
館のどこかに、隠されてるはずだよ。[p]

[chara_hide_all]
[jump target="*archive_investigate"]
[endif]

; ── 三色揃った：仕掛けに挑戦 ──
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01370"]
#mahoru
青、赤、緑……三枚とも揃った。[p]
[reset_message_chara]

[chara_mod name="airi" face="smile"]
#airi
[voice id="v01371"]
#airi
重ねてみよう！[p]

[chara_hide_all]
[layopt layer="message0" visible=false]
; 重ね直すだけなら時間は使わない。読み解けたときにだけ3分を数える
[jump cond="f.game_time >= 1080" target="*time_over"]
[call storage="system/gimmick.ks" target="*gm_glass"]

[show_menu]
[bg storage="reference_room.png" time=300]
[gage_draw place="舞黒館:資料室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="tf.gm_result != 'solved'"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01372"]
#mahoru
……もう少し、丁寧に重ねてみよう。[p]
[reset_message_chara]
[chara_hide_all]
[jump target="*archive_investigate"]
[endif]

[iscript]
f.glass_solved = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

[playse storage="switch_on.mp3"]

#
三枚の硝子が正しく噛み合った瞬間、灯りの上に四つの文字が浮かび上がった。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01373"]
#mahoru
……『執務机裏』？[p]
[reset_message_chara]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01374"]
#airi
執務室の机の裏！ 邦夢さんの仕掛け、次はあそこってこと！[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01375"]
#mahoru
行ってみよう。[p]
[reset_message_chara]

[get_item name="執務机裏" type="info" memo="三色の硝子が結んだ四文字。執務室の机の裏に、次の仕掛けがある。"]

[chara_hide_all]
[jump target="*archive_investigate"]


;=========================================
; 2F ── 執務室（クリッカブル版）
;=========================================

*scene_study
[cm]
[inv_set chapter="s4"]
[bg storage="office.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_study_cabinet === 'undefined') f.event_study_cabinet = 0;
if (typeof f.event_study_chair   === 'undefined') f.event_study_chair   = 0;
if (typeof f.has_old_key         === 'undefined') f.has_old_key         = 0;
[endscript]

[if exp="tf.inv_enter == 1"]
[eval exp="tf.inv_enter = 0"]
[scene_setup]
[charapos name="airi" face="normal" num="0"]

#
執務室は重厚な雰囲気の部屋だった。[p]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="study"]


;=========================================
; イベント：本棚を調べる
;=========================================

*evt_study_drawings
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_study_drawings==1"]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01525"]
（舞黒館の図面には、改築時に作られたはずの一部の図面が見当たらない）[p]
[reset_message_chara]
[jump storage="scene4.ks" target="*scene_study"]
[endif]

[jump cond="f.game_time >= 1080" storage="scene4.ks" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_study_drawings = 1;
f.study_drawings_checked = 1;
[endscript]

; ▼ 要ボイス収録
#
本棚の下段には、筒状に丸められた建築図面が年代順に収められていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01526"]
1階、2階、外構……増改築の図面もある。[p]
[reset_message_chara]

#airi
[voice id="v01527"]
ずいぶん細かく残ってるね。[p]

#
二人で図面を確認していく。[r]
#
ところどころ、図面番号が飛んでいる箇所があった。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01528"]
これ、なくなった図面があるってことかな。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01529"]
そうみたい。何の図面だったんだろう……。[p]
[reset_message_chara]

[get_item name="欠けた建築図面" type="info" memo="執務室の建築図面一式は一部の番号が欠けている。何の図面が失われたのかは、この時点では分からない。"]
[chara_hide_all]
[jump storage="scene4.ks" target="*scene_study"]

; 館の地下に関する情報は、この模型・資料側から独立して発見する。

*evt_study_cabinet
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_study_cabinet==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01376"]
#mahoru
（1946年の手記。若い二人との約束と、再会できなかった心残り……）[p]
[reset_message_chara]
[jump target="*scene_study"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_study_cabinet = 1;
[endscript]

#
執務室の本棚を調べると、舞黒館に関する大量の資料が詰め込まれていた。[p]

[charapos name="airi" face="surprised" num="0"]
#airi
[voice id="v01377"]
#airi
すごい資料の数だね。どれも古そう……。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v01378"]
#mahoru
何だか頭がパンクしてきたよ。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01379"]
#airi
待って。これ、舞黒邦夢さんの手記じゃない？[p]

#
革表紙の手帳を開くと、1935年と記されたページに、濃いインクの文字が残っていた。[p]

#
「1935年――あの年には、本当に様々なことがあった。[r]
#
素晴らしい出会いもあれば、二度と思い出したくない出来事もあった。[p]

世界には再び戦争の影が差し始め、あの若い二人も離れ離れになった。[r]
#
だが、私は彼らと交わした約束を守るつもりだ。[p]

幸い、この館には今も多くの客人が訪れる。[r]
#
人の出入りが多いことが、かえって良い目くらましになるだろう。[p]

#
……ただ一つ心残りなのは、ーー」[p]

#
ページはそこで切れてしまっていた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01380"]
#mahoru
若い二人……約束……？[p]
[reset_message_chara]

#airi
[voice id="v01381"]
#airi
それに「目くらまし」って、何を隠してたんだろう。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01382"]
#mahoru
他にも関連するものがあるかもしれない。[p]
[reset_message_chara]

#airi
[voice id="v01383"]
#airi
（お父さんは舞黒邦夢にまつわる謎を調べていたのかな？）[p]

[voice id="v01384"]
（そうだとしたら、なぜ……？）[p]

[jump target="*scene_study"]


;=========================================
; イベント：椅子を調べる
;=========================================

*evt_study_chair
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.event_study_chair==1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01530"]
（さっきは、邦夢さんの仕掛けで大変な目に遭った。この部屋には、まだ何かあるのかもしれない）[p]
[reset_message_chara]
[jump target="*scene_study"]
[endif]

[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
f.event_study_chair = 1;
[endscript]

#
革張りの執務椅子を見て、ふと昼間の騒ぎを思い出した。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01531"]
あの壁の仕掛けは、もう動かないように固定してあるんだよね。[p]
[reset_message_chara]

#airi
[voice id="v01532"]
うん。でも、邦夢さんが残したものが、あれだけとは限らないかも。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01533"]
この部屋をもう少し調べてみよう。[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*scene_study"]


;=========================================
; イベント：執務机を調べる
;   三色硝子を解く前 … 朱志香が設置した錠で引き出しは開かない
;   解いた後         … 机の裏の隠し箱から古びた鍵
;=========================================

*evt_study_desk
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

; ── すでに鍵を手に入れている ──
[if exp="f.event_study_desk==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01393"]
#mahoru
（机の裏の隠し箱は、もう空っぽ）[p]
[reset_message_chara]
[jump target="*scene_study"]
[endif]

; ── 硝子の四文字を読む前：引き出しは施錠されている ──
; 2回目以降は時間を使わない
[if exp="f.glass_solved!=1"]
[jump cond="f.study_security_on==1" target="*evt_study_desk_again"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.study_security_on = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

#
重厚な執務机。引き出しに手をかけてみたが、電子錠が赤く点灯したまま開かない。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01534"]
これは朱志香さんが付けた、普通の防犯用の鍵みたいだね。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01535"]
無理に開けるのはやめよう。邦夢さんの仕掛けは、引き出しとは別の場所にあるのかも。[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*scene_study"]
[endif]

; ── 硝子の四文字を読んだ後：机の裏を覗く ──
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.event_study_desk = 1;
f.has_old_key = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

#
「執務机裏」――四文字の通りに、机の下へもぐり込む。[p]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01396"]
#airi
……天板の裏、何も貼ってないよ？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01397"]
#mahoru
待って。奥の板、ここだけ木目が違う。[p]
[reset_message_chara]

#
爪をかけて手前に引くと、板の一部が箱状にせり出してきた。[p]

[playse storage="switch_off.mp3"]

#
中から出てきたのは、不思議と光沢を保った古い鍵だった。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01398"]
#airi
これが、仕掛けの終着点……！[p]

[glink color="bth13_dk" target="*study_key_show" text="朱志香さんに見せる"]
[glink color="bth13_dk" target="*study_key_keep" text="そのまま黙って持っておく"]
[s]


;=========================================
; 二度目以降（執務机は施錠されたまま）
;=========================================

*evt_study_desk_again
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01536"]
（引き出しは電子錠で開かない。手がかりを見つけてから、机そのものを調べよう）[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*scene_study"]


;=========================================
; 鍵を見つけたあとの選択
;=========================================

*study_key_show
[chara_hide_all]
[charapos name="jushika" face="normal" num="0"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]

#
朱志香を呼んで見せると、彼女は驚いた様子で鍵を眺めた。[p]

#jushika
[voice id="v01410"]
#jushika
まあ……こんなところに。ありがとうございます、真歩流様。[p]

#jushika
[voice id="v01411"]
#jushika
本当に解いてしまわれるなんて。邦夢様も喜んでおられますよ。[p]

[voice id="v01412"]
#jushika
よろしければ記念に差し上げます。見つけてくださったのですから。[p]

[voice id="v01413"]
#jushika
この館が建った頃から残っているものですから、大切にしてくださいね。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01414"]
ありがとうございます。大切にします。[p]
[reset_message_chara]

[get_item id="key"]
[iscript]
f.status["key"].owned = true;
[endscript]
[chara_hide_all]
; 執務室に留まる
[jump target="*scene_study"]


*study_key_keep
[chara_hide_all]
[charapos name="airi" face="normal" num="0"]
[show_menu]
[gage_draw place="舞黒館:執務室(2F)"]

#
真歩流はそっと鍵をポケットにしまった。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01415"]
（どこかで役に立つかもしれない。とりあえず持っておこう）[p]
[reset_message_chara]

[get_item id="key"]
[iscript]
f.status["key"].owned = true;
[endscript]
[chara_hide_all]
; 執務室に留まる
[jump target="*scene_study"]


;=========================================
; 2F ── 廊下
;=========================================
*scene_rouka2
[cm]
[bg storage="hallway_second.png" time=500]
[chara_hide_all]
[charapos name="airi" face="normal" num="0"]
[scene_setup]
[gage_draw place="舞黒館:廊下(2F)"]

#
2階の廊下は静かで、各部屋への扉が並んでいた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01416"]
#mahoru
どこから調べようか。[p]
[reset_message_chara]

#airi
[voice id="v01417"]
#airi
そういえば、荷物を置いた隣の部屋って談話室だっけ？[p]

; ▼ 要ボイス再録：v01418（旧「何もないと思うけど行ってみたいな。」）
;    談話室にはラジオ＝四桁の数字（設計図ルートの起点）がある。
;    否定の台詞が導線を殺していたので、興味を持たせる形に変更。
[voice id="v01418"]
#airi
使ってなさそうな部屋だけど……なんだか気になるんだよね。[p]

[chara_hide_all]
[glink color="bth13_dk" target="*scene_lounge" text="◆ 談話室へ行く" x=560 y=380 width=800 size=30]
[glink color="bth13_dk" target="*investigation_start" text="◆ フロアマップへ戻る" x=560 y=500 width=800 size=30]
[s]


;=========================================
; 2F ── 談話室
;=========================================
*scene_lounge
[cm]
[inv_set chapter="s4"]
[bg storage="talk_room.png" time=500]
[chara_hide_all]
[freeimage layer="1"]

[iscript]
if (typeof f.event_lounge === 'undefined') f.event_lounge = 0;
[endscript]

[gage_draw place="舞黒館:談話室(2F)"]

; 初めて入ったときだけ、部屋の導入を再生する
[if exp="f.event_lounge == 0"]
[scene_setup]
[charapos name="airi" face="normal" num="0"]

#
2階の廊下から一つ扉を開けると、そこは談話室だった。[p]
#
大きな木製のテーブルと椅子が整然と並んでいる。[p]
#
ピンクのカーテン越しに、西洋の柔らかな陽光が差し込んでいた。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01419"]
#mahoru
ここが談話室か……広くて明るいね！[p]
[reset_message_chara]

#airi
[voice id="v01420"]
#airi
本当。このテーブル、すごく立派だね。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01421"]
#mahoru
使いきれないくらいの広さよね。大勢で会議でもしてたのかな。[p]
[reset_message_chara]

#airi
[voice id="v01422"]
#airi
舞黒館だもの。各国の外交官が集まって、何か重要な話し合いをしていたんじゃないかな。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01423"]
#mahoru
なんか……歴史のロマンを感じるね。[p]
[reset_message_chara]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01424"]
#airi
えっ、お姉ちゃんがそういうこと言うの、珍しい。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01425"]
#mahoru
えっ、私だってそういうこと思うよ！[p]
[reset_message_chara]

[chara_mod name="airi" face="smile"]
#airi
[voice id="v01426"]
#airi
まあ……確かに素敵な場所だね。お父さんがここに来たくなった気持ち、少しわかる気がする。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01427"]
#mahoru
……うん。お父さんもこうして、いろんな部屋を見て回ったのかな。[p]
[reset_message_chara]

[iscript]
f.event_lounge = 1;
[endscript]
[endif]

[cm]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="lounge"]


;=========================================
; イベント：飾り棚（ラジオ）
;=========================================

*evt_lounge_shelf
[freeimage layer="1"]
[show_menu]
[gage_draw place="舞黒館:談話室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

; ── 初回だけ：ラジオを見つける（ここが「成果」なので時間を使う） ──
[if exp="f.event_lounge_shelf!=1"]
[jump cond="f.game_time >= 1080" target="*time_over"]
[iscript]
f.event_lounge_shelf = 1;
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

#
壁際の飾り棚。扉を開けると、中に木製の箱が押し込まれていた。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01428"]
#mahoru
重い……何だろう、これ。[p]
[reset_message_chara]

#
引き出してみると、丸みを帯びた木の筐体に、真鍮の環と硝子窓。[r]
#
古い――けれど手入れの行き届いたラジオだった。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01429"]
#airi
わあ、アンティークのラジオだ！　まだ動くのかな？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01430"]
#mahoru
埃をかぶってないってことは……たぶん、動くね。[p]
[reset_message_chara]

#
差し込みを繋ぐと、真空管がじんわりと橙色に灯り、雑音が流れはじめた。[p]
#
ざあざあと鳴りつづける砂嵐。つまみを回しても、鳴りやむ気配はない。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01431"]
#mahoru
……この雑音のどこかに、何か入ってるのかな。[p]
[reset_message_chara]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01432"]
つまみをゆっくり回してみて。[r]
#airi
[voice id="v01537"]
雑音が薄くなるところがあったら、そこに何か入ってるはずだよ。[p]
[endif]

; ── すでに四桁を聞いている：合わせ直さない（何度も手がかりを拾えてしまうため） ──
[if exp="f.radio_code_known==1"]
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01433"]
#mahoru
（つまみはもう合わせてある。……あの四桁は、ちゃんと書き留めた）[p]
[reset_message_chara]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01434"]
#airi
同じ数字を繰り返してるだけだよ。手がかりボードに残ってるから、いつでも見られるね。[p]

[chara_hide_all]
[jump target="*scene_lounge_stay"]
[endif]

[chara_hide_all]
[layopt layer="message0" visible=false]
; つまみを合わせ直すだけなら時間は使わない。四桁を聞き取れたときにだけ3分を数える
[jump cond="f.game_time >= 1080" target="*time_over"]
[call storage="system/gimmick.ks" target="*gm_radio"]

[show_menu]
[bg storage="talk_room.png" time=300]
[gage_draw place="舞黒館:談話室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.radio_code_known!=1"]
[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01435"]
#mahoru
雑音ばかり……まだ、どこにも当たってないみたい。[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01436"]
端から端まで、ゆっくり回してみようよ。[r]
#airi
[voice id="v01538"]
雑音が引っこむところを見つけたら、そこで手を止めるの。[p]

[chara_hide_all]
[jump target="*scene_lounge_stay"]
[endif]

[iscript]
f.game_time = Math.min((f.game_time||0) + 3, 1080);
[endscript]

#
砂嵐がすうっと引いて、そのうしろから女性の声が滲み出した。[r]
#
穏やかな声が、ゆっくりと数字を読み上げていく。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01437"]
#mahoru
……今の、数字？[p]
[reset_message_chara]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01438"]
#airi
四桁だったよね。放送……じゃないよ、これ。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01439"]
#mahoru
同じ数字を、ずっと繰り返してる。[p]

[voice id="v01440"]
#mahoru
――これ、誰かに宛てた合図なんじゃない？[p]
[reset_message_chara]

[chara_mod name="airi" face="thinking"]
#airi
[voice id="v01441"]
#airi
四桁の数字で開くもの……この館のどこかに、あるのかも。[p]

[get_item name="ラジオの四桁" type="info" memo="談話室のラジオが繰り返し読み上げていた四桁の数字。四桁で開く錠が、館のどこかにあるはず。"]

[chara_hide_all]
[jump target="*scene_lounge_stay"]


;=========================================
; 談話室に留まる（導入テキストは再生しない）
;=========================================

*scene_lounge_stay
[cm]
[inv_set chapter="s4"]
[clearfix]
[chara_hide_all]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]
[inv_room id="lounge"]



;===============================================================================
; 2F談話室 → 舞黒邦夢の地下書斎
;===============================================================================
*evt_lounge_hidden_search
[cm]
[freeimage layer="1"]
[show_menu]
[bg storage="talk_room.png" time=300]
[gage_draw place="舞黒館:談話室(2F)"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="normal" num="0"]

[if exp="f.hidden_study_entrance_found==1"]
[jump target="*hidden_study_confirm"]
[endif]


[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01539"]
模型だと、この窓側はもう少し外へ張り出してた。[p]
#mahoru
[voice id="v01540"]
でも実際の部屋は……普通に窓があるだけなんだよね。[p]
[reset_message_chara]

#airi
[voice id="v01541"]
壁の中に空間があるのかな。[p]

#
二人で窓枠や壁板を調べてみたが、動きそうな場所は見つからなかった。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01542"]
うーん……絶対この辺だと思ったのに。[p]
[reset_message_chara]

#
真歩流は窓際のソファに目を向けた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01543"]
愛理。これ、ちょっと動かしてみよう。[p]
[reset_message_chara]

#
二人でソファをずらす。[r]
#
その下に現れたのは、周囲と変わらない木の床だった。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01544"]
何にもない……！[p]
#mahoru
[voice id="v01545"]
もう、絶対ここだと思ったのに！[p]
[reset_message_chara]

#
悔しそうに真歩流が床を踏み鳴らした。[p]
#
――コン。[p]

[chara_mod name="airi" face="surprised"]
#airi
[voice id="v01546"]
……お姉ちゃん。もう一回。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01547"]
え？[p]
[reset_message_chara]

#airi
[voice id="v01548"]
今の音。そこだけ軽かった。[p]

#
真歩流は場所をずらしながら、今度は意識して床を踏んだ。[r]
#
コン、コン――コォン。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v01549"]
本当だ。ここだけ下が空洞みたい。[p]
[reset_message_chara]

#
絨毯をめくり、床板の継ぎ目に沿って指を這わせる。[r]
#
細い切れ目と、小さな指掛かりが隠されていた。[p]

#airi
[voice id="v01550"]
これ……蓋になってる。[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01551"]
鍵穴はない。[p]
#mahoru
[voice id="v01552"]
見つけられなければ、それで十分だったんだ……。[p]
[reset_message_chara]

#
二人で持ち上げると、床板の一部が静かに開いた。[r]
#
暗闇の中へ、細い階段が続いている。[p]

[eval exp="f.hidden_study_entrance_found=1"]
[get_item name="談話室の隠し階段" type="info" memo="2F談話室のソファと絨毯の下に、地下へ続く隠し階段があった。鍵はなく、入口そのものが巧妙に隠されている。"]

*hidden_study_confirm
[cm]
[show_menu]
[bg storage="talk_room.png" time=200]
[gage_draw place="舞黒館:談話室(2F)"]
[charapos name="airi" face="thinking" num="0"]
[layopt layer="message0" visible=true]

#airi
[voice id="v01553"]
この先、見に行く？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01554"]
入ったら、夕食までに他の場所を調べる時間はなくなると思う。[p]
[reset_message_chara]

#
この先へ進むと、自由探索は終了します。[r]
#
地下書斎を調べますか？[p]

[chara_hide_all]
[glink color="bth13_dk" target="*hidden_study_enter" text="◆ 地下へ進む" x=560 y=380 width=800 size=30]
[glink color="bth13_dk" target="*scene_lounge_stay" text="◆ いったん探索へ戻る" x=560 y=500 width=800 size=30]
[s]

*hidden_study_enter
[cm]
[clearfix]
[eval exp="f.hidden_study_entered=1"]
[eval exp="f.event_lounge_hidden_search=1"]
[freeimage layer="1"]
@playbgm storage="basement_area.mp3"
[bg storage="secret_area.png" time=1200]
[chara_hide_all]
[show_menu]
[gage_draw place="舞黒館:地下書斎"]
[layopt layer="message0" visible=true]
[charapos name="airi" face="surprised" num="0"]


#
長い階段を降りた先に、小さな部屋が現れた。[p]
#
木張りの壁。古い本棚。大きな地球儀。真鍮の望遠鏡。[p]
#
壁には船の絵が並び、棚には瓶の中に収められた帆船模型がいくつも飾られている。[p]

#airi
[voice id="v01555"]
……秘密基地みたい。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v01556"]
舞黒邦夢さん、こういうの好きだったのかな。[p]
[reset_message_chara]

#
中央の丸机には、古びた手記が置かれていた。[p]

#
――昭和十年。[p]
#
憤懣を募らせる軍部が、あるものを探し始めている。[r]
#
彼らだけではない。各国の諜報機関の者たちも、同じものを求めて動いているようだ。[p]
#
非常に慎重を要する事柄ゆえ、ここに詳細を記すことはできない。[r]
#
だが、あれが誰かの手に渡れば、間違いなく戦争の火種となろう。[p]
#
だからこそ、誰にも渡してはならない。[r]
#
私にできることは、それを守ることだけだ。[p]
#
……もっとも、悪いことばかりではなかった。[r]
#
この一件のおかげで、こっそりと私だけの秘密の部屋を作ることができたのだから。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01557"]
「あれ」って……何のこと？[p]
[reset_message_chara]

#airi
[voice id="v01558"]
軍部だけじゃなくて、外国の人たちまで探してたもの……。[p]

[get_item name="舞黒邦夢の昭和十年の手記" type="info" memo="1935年、軍部や各国の諜報機関が『あるもの』を探していた。邦夢は、それが誰かの手に渡れば戦争の火種になると警戒していた。"]

#
手記を戻そうとしたとき、真歩流は机の表面に目を留めた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01559"]
……愛理。ここ、見て。[p]
[reset_message_chara]

#
部屋の隅や本棚には、長い年月を思わせる埃が積もっている。[p]
#
ところが入口から机までの床だけ、埃がわずかに薄い。[p]
#
椅子の脚の周囲には一度引き出したような筋があり、本棚の一角にも本を抜いた跡が残っていた。[p]

#airi
[voice id="v01560"]
掃除した跡……？[p]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01561"]
ううん。部屋全体はこんなに埃だらけなのに、触ったところだけ薄い。[p]
#mahoru
[voice id="v01562"]
誰かがここへ来て、私たちみたいに調べたんだ。[p]
[reset_message_chara]

#
舞黒邦夢が亡くなったのは1975年。[r]
#
その後を引き継いだ人物も、1998年には亡くなっている。[r]
#
それから2025年までには、長い空白がある。[p]

[eval exp="f.hidden_study_recent_trace=1"]
[get_item name="地下書斎に残る新しい痕跡" type="info" memo="長年使われていないはずの地下書斎で、入口から机までの埃が薄く、椅子や本棚にも近年誰かが調べたような跡が残っていた。"]

[jump target="*hidden_study_deduction"]

*hidden_study_deduction
[cm]
[chara_hide_all]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*hidden_study_deduction_father', text:'半年前に舞黒館を調べていた父', kind:'look' });
tf.choices.push({ target:'*hidden_study_deduction_old', text:'昔この部屋を引き継いだ人物', kind:'look' });
tf.choices.push({ target:'*hidden_study_deduction_unknown', text:'今の情報では全く見当がつかない', kind:'look' });
tf.choices.push({ target:'*hidden_study_deduction_furechi', text:'館の持ち主である富礼知家の人たち', kind:'look' });
tf.hidden_study_prompt = "最近、この地下書斎を調べた人物として最も可能性が高いのは？";
[endscript]
[stand_select storage="scene4.ks" se="decide.mp3" prompt="&tf.hidden_study_prompt"]

*hidden_study_deduction_old
[cm]
[show_menu]
[bg storage="secret_area.png" time=200]
[gage_draw place="舞黒館:地下書斎"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01563"]
でも、その人が亡くなったのは1998年。[p]
#mahoru
[voice id="v01564"]
この触られ方は、それよりずっと新しく見える。[p]
[reset_message_chara]
[jump target="*hidden_study_deduction"]

*hidden_study_deduction_unknown
[cm]
[show_menu]
[bg storage="secret_area.png" time=200]
[gage_draw place="舞黒館:地下書斎"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01565"]
断定はできない。でも、半年前にこの館へ来て、建築や古い記録まで調べていた人を知ってる。[p]
[reset_message_chara]
[jump target="*hidden_study_deduction"]

*hidden_study_deduction_furechi
[cm]
[show_menu]
[bg storage="secret_area.png" time=200]
[gage_draw place="舞黒館:地下書斎"]
[chara_hide_all wait="false"]
[charapos name="airi" face="thinking" num="0" wait="false"]
; 富礼知家を疑ったルート。父を疑ったルートとは別のフラグで記録する。
[eval exp="f.hidden_study_furechi_infer=1"]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01566"]
……朱志香さんや旦那さんかもしれない。[p]
#mahoru
[voice id="v01567"]
舞黒館の今の所有者だから、見つけていてもおかしくない。[p]
[reset_message_chara]

#airi
[voice id="v01568"]
確かにそうだね。[p]

#airi
[voice id="v01569"]
なら、どうしてここは公開しないんだろうね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01570"]
多分、公開したくなかったんじゃないかな。[p]

#mahoru
[voice id="v01571"]
こういう場所があるなら、他にもあるって思われたら困るでしょ。[p]
[reset_message_chara]

#airi
[voice id="v01572"]
言われてみれば、仕掛けがあるって聞いてたからここへ来れたもんね。[p]

[voice id="v01573"]
この部屋のこと、朱志香さんたちにも話す？[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01574"]
……今はやめよう。[p]
#mahoru
[voice id="v01575"]
邦夢さんの手記には、誰かの手に渡ったら危険なものがあるみたいに書かれてた。[p]
#mahoru
[voice id="v01576"]
それに、ここには最近誰かが来た形跡もある。[p]
#mahoru
[voice id="v01577"]
誰がここを知ってるのか分からないうちは、むやみに話さない方がいいと思う。[p]
[reset_message_chara]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01578"]
分かった。私たちだけの秘密だね。[p]

[eval exp="f.hidden_study_secret=1"]

#
二人は手記を元の場所へ戻し、触れたものをできるだけ元通りにして地下書斎を後にした。[p]

@chara_hide_all
[set_time hour=18 min=0]
[jump target="*time_over"]

*hidden_study_deduction_father
[cm]
[show_menu]
[bg storage="secret_area.png" time=200]
[gage_draw place="舞黒館:地下書斎"]
[chara_hide_all wait="false"]
[charapos name="airi" face="thinking" num="0" wait="false"]
[eval exp="f.hidden_study_father_infer=1"]

[message_chara name="mahoru" face="light_thinking"]
#mahoru
[voice id="v01579"]
……お父さんだった可能性が高い。[p]
#mahoru
[voice id="v01580"]
半年前に舞黒館へ来て、この館の沿革や建築まで調べていた。[p]
#mahoru
[voice id="v01581"]
それなら、この部屋を見つけていてもおかしくない。[p]
[reset_message_chara]

#airi
[voice id="v01582"]
でも、絶対にお父さんだって証拠はないよね。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v01583"]
うん。断定はできない。[p]
#mahoru
[voice id="v01584"]
でも……お父さんがここで何を追っていたのかには、少し近づいた気がする。[p]
[reset_message_chara]

#airi
[voice id="v01585"]
この部屋のこと、朱志香さんたちにも話す？[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v01586"]
……今はやめよう。[p]
#mahoru
[voice id="v01587"]
邦夢さんの手記には、誰かの手に渡ったら危険なものがあるみたいに書かれてた。[p]
#mahoru
[voice id="v01588"]
それに、ここには最近誰かが来た形跡もある。[p]
#mahoru
[voice id="v01589"]
誰がここを知ってるのか分からないうちは、むやみに話さない方がいいと思う。[p]
[reset_message_chara]

[chara_mod name="airi" face="normal"]
#airi
[voice id="v01590"]
分かった。私たちだけの秘密だね。[p]

[eval exp="f.hidden_study_secret=1"]

#
二人は手記を元の場所へ戻し、触れたものをできるだけ元通りにして地下書斎を後にした。[p]

@chara_hide_all
[set_time hour=18 min=0]
[jump target="*time_over"]

;=========================================
; パート3：惨劇の始まり
;=========================================
*time_over
[playbgm storage="tea_party.mp3"]
[bg storage="hallway.png" time=1000]
[chara_hide_all]
[charapos name="airi" face="normal" num="0"]
[showmenubutton]
[hud_draw]
[position layer="message0" page=fore visible=true]
[current layer="message0"]
[set_time hour=18 min=0]
[gage_draw place="舞黒館:廊下(1F)"]

[if exp="f.hidden_study_entered!=1"]
[if exp="f.father_visit_found==1 && f.father_research_found==1"]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01591"]
お父さんが半年前にここへ来て、舞黒館について調べていたことまでは分かった。[p]
#mahoru
[voice id="v01592"]
でも、その先で何を見つけたのかはまだ分からない……。[p]
[reset_message_chara]
[elsif exp="f.father_visit_found==1"]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01593"]
少なくとも、お父さんが半年前にこの館へ来ていたことは分かった。[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="light_thinking"]
; ▼ 要ボイス収録
#mahoru
[voice id="v01594"]
まだ、お父さんがここで何をしていたのかまでは掴めなかった……。[p]
[reset_message_chara]
[endif]
[endif]

; ── 館の仕掛け（設計図・地下への鍵）の取り逃し告知 ──
;    どちらも scene4 限定なので、ここで気づけないと取り返しがつかない。
[if exp="f.has_blueprint!=1 || f.has_old_key!=1"]
[message_chara name="mahoru" face="light_thinking"]

; ▼ 要ボイス収録
#mahoru
[voice id="v01595"]
（それにしても……）[p]
; ▼ 要ボイス収録
#mahoru
[voice id="v01597"]
（この館、まだ見ていない場所がたくさんあった気がする）[p]

; ▼ 要ボイス収録
#airi
[voice id="v01598"]
お姉ちゃん、けっこう歩き回ったのにね。[p]

#airi
[voice id="v01599"]
夕食のあと、まだ時間があるといいんだけど。[p]
[reset_message_chara]
[endif]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v01444"]
#mahoru
そろそろ夕食の時間だし、皆のところに戻ろうか。[p]

[reset_message_chara]
#airi
[voice id="v01445"]
#airi
そうだね。[p]

#
真歩流と愛理は、ダイニングへと向かった。[p]

[chara_hide_all]
[bg storage="dining.png" time=1000]
[advance_time min=5]
[gage_draw place="舞黒館:ダイニング"]
[charapos name="koderia" face="normal" num="0"]

#
ダイニングには、次第に皆が集まり始めていた。[p]

#koderia
[voice id="v01446"]
#koderia
あら、真歩流様、愛理様。お帰りなさい。[p]

[chara_hide_all]
[charapos name="jushika" face="normal" num="2"]
[charapos name="koderia"    face="normal" num="1"]

#jushika
[voice id="v01447"]
#jushika
もうじき夕食の準備が終わりますよ。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v01448"]
#mahoru
わあ、楽しみです。[p]

[reset_message_chara]
[charapos name="airi"    face="normal" num="3"]

#airi
[voice id="v01449"]
#airi
お腹ペコペコだよ。[p]

#koderia
[voice id="v01450"]
#koderia
では、皆さん。夕食の準備に戻りますね。[p]

[chara_hide name="koderia"]

[chara_hide_all]
[charapos name="juri"    face="normal" num="1"]
[charapos name="eruku" face="normal" num="2"]

#juri
[voice id="v01451"]
#juri
夕食はどんな料理かしら。[p]

#eruku
[voice id="v01452"]
#eruku
楽しみだな。[p]

[chara_hide_all]
[charapos name="mary" face="normal" num="0"]

#mary
[voice id="v01453"]
#mary
私もお腹が空きました。[p]

[chara_hide_all]

#koderia
[voice id="v01454"]
#koderia
……あああああっ！！[p]
[quake time=1000]

[stopbgm]

[charapos name="airi" face="surprised" num="0"]

#airi
[voice id="v01455"]
#airi
え、な……何！？[p]

[message_chara name="mahoru" face="surprised"]

#mahoru
[voice id="v01456"]
#mahoru
キッチンの方から……！[p]

[voice id="v01457"]
#mahoru
小出里亜さん！[p]

[reset_message_chara]
#
私たちは急いでキッチンの方へと駆け出した。[p]

[chara_hide_all]
[freeimage layer="1"]

[chapter_end]

[jump storage="scene5.ks" target="*start"]

