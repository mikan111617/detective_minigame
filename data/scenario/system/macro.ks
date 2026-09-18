;===============================================================================
; UI・ゲージ関連マクロ
;===============================================================================

;-----------------------------------------------------------
; [gage_draw]
; 機能：現在地・時刻などの画面上部UIを一括描画します（デザイン案 1b）。
; 引数：place（場所名）, hide_time（"true"で時刻を非表示 ※回想シーン等で使用）
; 備考：時刻は f.game_time（分単位）から自動生成します。
;       時刻のセット・進行は [set_time] / [advance_time] で行ってください。
;       描画の実体は message_ui.ks の [hud_draw]（左上のプレート、右上の
;       資料／MENU、右下の AUTO／SKIP／LOG）です。
;-----------------------------------------------------------

[macro name="gage_draw"]

    ; --- 1. 表示内容を控える ---
    ; [hud_draw] 単独（[clearfix] 後の描き直しなど）でも同じプレートが出るように、
    ; 場所名と時刻の表示状態はゲーム変数に残しておく
    [eval exp="f.hud_place = (mp.place !== undefined) ? mp.place : ''"]
    [eval exp="f.hud_hide_time = (mp.hide_time !== undefined && mp.hide_time == 'true')"]

    ; --- 2. 描画処理 ---
    ; 一旦レイヤー1（UI用）をクリアして再描画
    [freeimage layer="1"]
    [hud_draw]

[endmacro]

;-----------------------------------------------------------
; [set_time]
; 機能：ゲーム内時刻を指定した時・分で設定する
; 引数：hour（時 例:12）, min（分 例:55）
; 使用例：[set_time hour=12 min=55]  → 12:55 にセット
;-----------------------------------------------------------
;-----------------------------------------------------------
; [hud_hide]
; 機能：画面左上の「場所名｜時刻」プレートだけを消す。
;       右上の 資料／MENU と右下の AUTO／SKIP／LOG はそのまま残る。
; 用途：時刻の概念がない場面（プロローグの回想、エンディングの後日譚）。
; 備考：以降 [show_menu] や [clearfix] で描き直されても消えたままになる。
;       再び出したいときは [gage_draw place="..."] を呼ぶ。
;-----------------------------------------------------------
[macro name="hud_hide"]
    [eval exp="f.hud_place = ''"]
    [eval exp="f.hud_hide_time = true"]
    [freeimage layer="1"]
    [hud_draw]
[endmacro]

[macro name="set_time"]
    [eval exp="f.game_time = (mp.hour !== undefined ? Number(mp.hour) : 0) * 60 + (mp.min !== undefined ? Number(mp.min) : 0)"]
[endmacro]

;-----------------------------------------------------------
; [advance_time]
; 機能：ゲーム内時刻を指定した分数だけ進める
; 引数：min（進める分数 例:30）
; 使用例：[advance_time min=5]  → 現在時刻から5分後に進む
; 備考：[gage_draw] の直前に呼び出してください。
;-----------------------------------------------------------
[macro name="advance_time"]
    [eval exp="f.game_time = (f.game_time || 0) + (mp.min !== undefined ? Number(mp.min) : 0)"]
[endmacro]

[macro name="hp_gage_draw"]
  ; ; --- 1. HPゲージの計算 ---
    ; ; 現在のHPが0〜最大値の範囲に収まるように補正
    ; [eval exp="f.hp = Math.max(0, Math.min(f.hp, f.hp_max))"]
    ; ; HPの割合から、ゲージ画像の表示幅(width)を計算
    ; [eval exp="f.hpbar_w = Math.floor(f.hpbar_w_max * f.hp / f.hp_max)"]

    ; ; --- 2. 純真ゲージの計算 ---
    ; ; 現在の値が0〜最大値の範囲に収まるように補正
    ; [eval exp="f.pureness = Math.max(0, Math.min(f.pureness, f.pureness_max))"]
    ; ; 割合からゲージ画像の表示幅を計算
    ; [eval exp="f.pureness_w = Math.floor(f.pureness_w_max * f.pureness / f.pureness_max)"]

     ; 各種テキスト表示（体力ラベル、場所、時間）
    ; [ptext layer="1" text="体力" x=40 y=120 size=32 color="0xfbcb46" edge="0x000000" align="left" width=400 bold="false"]
    ; [ptext layer="1" text="%place" x=87 y=6 size=50 color="0xffffff" align="left" width=600 bold="false"]
    ; [ptext layer="1" text="%time" x=87 y=6 size=50 color="0xffffff" align="right" width=700 bold="false"]
    
    ; ; HPゲージ本体の描画
    ; [image layer="1" visible="true" folder="image" storage="append_theme/hp_gauge_base.png" x=136 y=110 width=690 height=69]
    ; [image layer="1" visible="true" folder="image" storage="append_theme/hp_gauge_active_02.png" x=180 y=126 width="&f.hpbar_w" height="30"]

    ; 純真ゲージの描画（コメントアウト中の処理含む）
    ; [ptext layer="1" text="純真" x=904 y=120 size=32 color="0xfbcb46" edge="0x000000"]
    ; [image layer="1" visible="true" folder="image" storage="append_theme//hp_gauge_base.png" x=1000 y=110 width=690 height=69]
    ; [image layer="1" visible="true" folder="image" storage="append_theme//hp_gauge_active_01.png" x=1044 y=126 width="&f.pureness_w" height="30" ]
    ; [image layer="1" visible="true" folder="image" storage="append_theme/emblem_02.png" x=876 y=86 width=115 height=119]

[endmacro]


[macro name="scene_setup"]
    [show_menu]
    [position layer="message0" page=fore visible=true]
    [current layer="message0"]
[endmacro]

;-----------------------------------------------------------
; [initilize_hp]
; 機能：HPゲージ・純真ゲージ計算用変数の初期化
; 備考：ゲーム開始時（first.ksなど）に一度だけ呼び出してください
;-----------------------------------------------------------
[macro name="initilize_hp"]
    ; ---- HPゲージ定数＆初期値 ----
    [eval exp="f.hp_max=100"]
    [eval exp="f.hp=100"]
    [eval exp="f.hpbar_w_max=609"]
    [eval exp="f.hpbar_x=180"] 
    [eval exp="f.hpbar_y=126"] 

    ; ---- 純真値ゲージ定数＆初期値 ----
    ; [eval exp="f.pureness_max=100"]
    ; [eval exp="f.pureness=100"]
    ; [eval exp="f.pureness_w_max=609"]
    ; [eval exp="f.pureness_x=180"] 
    ; [eval exp="f.pureness_y=126"] 
[endmacro]


;===============================================================================
; 演出・エフェクト関連マクロ
;===============================================================================

;-----------------------------------------------------------
; [auto_resonance]
; 機能：強制受信演出（覚醒後・制御不能）
; 詳細：耳鳴りSE＋画面揺れ＋赤ノイズ＋サブリミナルテキスト
; 引数：text（一瞬表示される心の声）
;-----------------------------------------------------------
[macro name="auto_resonance"]
    [playse storage="tinnitus_short.mp3" volume=50 buf=1]
    [quake time=300 hmax="10" vmax="5"]
    ; 赤いグリッチノイズをオーバーレイ
    [layermode layer="1" time=100 mode="overlay" graphic="../bgimage/noise.png" opacity=100 color="0xFF0000"]
    [wait time=200]
    [free_layermode time=200]
    
    ; 心の声を赤字で一瞬表示（サブリミナル効果）
    [font color="0xFF4444" size=28 bold=true shadow="0x000000"]
    [ptext layer=2 x=100 y=300 text="%text" time=800 name="mind_voice"]
    [resetfont]
    [freeimage layer=2]
[endmacro]

;-----------------------------------------------------------
; [pre_resonance]
; 機能：共鳴演出（予兆・軽度）
; 詳細：auto_resonanceより軽いノイズ演出。「違和感」の表現用。
;-----------------------------------------------------------
[macro name="pre_resonance"]
    [playse storage="noise.mp3" volume=100 buf=1]
    [layermode layer="1" time=2000 mode="overlay" graphic="../bgimage/noise.png" opacity=200 color="0xFF0000"]
    [wait time=100]
    [free_layermode time=2000]
[endmacro]

;-----------------------------------------------------------
; [glitch_awaken]
; 機能：能力覚醒イベント用演出（強烈なノイズ）
; 詳細：ループSE＋激しい画面揺れ＋色調反転に近いノイズレイヤー
;-----------------------------------------------------------
[macro name="glitch_awaken"]
    [playse storage="noise.mp3" ]
    [layermode layer="1" time=3000 mode="screen" graphic="../bgimage/noise.png" opacity=200 color="0xFF0000"]
    [wait time=100]
    [free_layermode time=100]
[endmacro]

;-----------------------------------------------------------
; [system_log]
; 機能：脳内システムログ表示
; 詳細：機械的なフォントでログを表示する演出
; 引数：text（表示するログ内容）
;-----------------------------------------------------------
[macro name="system_log"]
    [font color="0x00FF00" face="tahoma" size=24 shadow="0x000000"]
    [ptext layer=2 x=50 y=200 text="%text" time=100 name="sys_log"]
    [resetfont]
[endmacro]

;-----------------------------------------------------------
; [credit_text]
; 機能：エンディングロール用テキスト表示
; 詳細：テキストを表示し、自動で上方向へスクロールさせる
; 引数：text（表示内容）, wait（次の行までの待ち時間）
;-----------------------------------------------------------
[macro name="credit_text"]
    [ptext layer="1" text="%text" x="0" y="0" width="1920" align="center" color="#ffffff" size="28" time="0" name="credit_item"]
    ; キーフレーム"credit_scroll"（別途定義が必要）を実行
    [kanim name="credit_item" keyframe="credit_scroll" easing="linear" time="10000"]
    ; 次の行が出るまでのウェイト（デフォルト4000ms）
    [wait time=%wait|4000]
[endmacro]


;===============================================================================
; キャラクター・立ち絵制御マクロ
;===============================================================================

;-----------------------------------------------------------
; [charapos]
; 機能：番号指定による簡易キャラクター配置
; 引数：name（キャラ名）, face（表情）, num（配置位置 1:左 〜 4:右）
;-----------------------------------------------------------
[macro name="charapos"]
    ; mp.num を数値に変換（他マクロ実行後にmp.numがundefinedになる対策）
    [eval exp="tf.chara_num = (mp.num !== undefined ? Number(mp.num) : 0)"]

    ; 位置番号に応じたX座標の設定
    [if exp="tf.chara_num == 1"]
        [eval exp="tf.set_x = 430"]
    [elsif exp="tf.chara_num == 2"]
        [eval exp="tf.set_x = 860"]
    [elsif exp="tf.chara_num == 3"]
        [eval exp="tf.set_x = 1290"]
    [elsif exp="tf.chara_num == 4"]
        [eval exp="tf.set_x = 0"]
    [else]
        ; num=0 またはそれ以外のデフォルト（中央付近）
        [eval exp="tf.set_x = 645"]
    [endif]

    ; 縦位置は固定
    [eval exp="tf.set_y = 200"]

    ; wait は既定で "true"（従来どおり、立ち絵が出そろってから次のタグへ進む）。
    ; 選択肢の直後だけ wait="false" を渡す。
    ;   wait="true"  … アニメ完了時に cancelWeakStop() と nextOrder() を呼ぶ。
    ;                  アニメ中にクリックするとエンジンが先に nextOrder() を
    ;                  走らせるため、完了時の nextOrder() が二重になり、
    ;                  出たばかりの一文が送られてしまう。
    ;   wait="false" … 開始直後に nextOrder()。完了時は cancelWeakStop() だけ。
    ;                  待ち時間が生まれないので二重送りも起きない。
    [eval exp="tf.charapos_wait = (mp.wait !== undefined ? mp.wait : 'true')"]

    ; キャラクター表示実行
    [chara_show name="%name" face="%face" left="&tf.set_x" top="&tf.set_y" width="600" time="500" reflect="false" wait="&tf.charapos_wait"]
[endmacro]

;-----------------------------------------------------------
; [message_chara]
; 機能：メッセージウィンドウ内（左側）への顔アイコン/立ち絵表示
; 詳細：前のキャラを自動で消去し、新しいキャラを表示する管理機能付き
; 引数：name（キャラ名）, face（表情）
;-----------------------------------------------------------
[iscript]
// メッセージ枠（message0 レイヤ）に出ている立ち絵を片づけるための共通処理。
//
// 以前は「直前に出したキャラ名」を tf.prev_name に覚えて [chara_hide] していた。
// しかし tf はセーブに含まれず、ロードしても復元されない。そのため
//   [message_chara] で表示 → セーブ → 再開 → 次の [message_chara]
// という流れだと前のキャラを消せず、立ち絵が重なったままになっていた。
//
// [chara_show] は kag.stat.charas[名前] に layer と is_show を書き込む。
// stat はセーブに含まれ、ロード時にレイヤのHTMLごと丸ごと復元されるので、
// 「いま実際に出ているのは誰か」はこちらを見れば必ず分かる。
window.MSG_CHARA = {
    // keep に渡した名前だけ残して、message0 の立ち絵をすべて片づける。
    // keep が空なら全部消す。
    sweep: function (keep) {
        // tyrano.plugin.kag は雛形で、実際に動いているのは TYRANO.kag の方。
        // ロード後は stat が実体側だけ差し替わるので、必ず実体を見る。
        var kag = window.TYRANO && window.TYRANO.kag;
        if (!kag || !kag.stat) { return; }

        keep = (keep === undefined || keep === null) ? "" : String(keep);

        var charas = kag.stat.charas || {};
        var layer = kag.layer.getLayer("message0", "fore");

        for (var name in charas) {
            var cpm = charas[name];
            if (!cpm || cpm.layer !== "message0" || cpm.is_show !== "true") { continue; }
            if (name === keep) { continue; }
            try { kag.chara.stopFrameAnimation(cpm); } catch (e) {}
            kag.chara.getCharaContainer(name, layer).stop(true, true).remove();
            cpm.is_show = "false";
        }

        // 記録に残っていない立ち絵が居座っていることもあるので、DOM 側も掃く
        layer.find(".tyrano_chara").each(function () {
            var j_chara = $(this);
            if (keep !== "" && j_chara.hasClass(keep)) { return; }
            j_chara.stop(true, true).remove();
        });
    }
};
[endscript]

[macro name="message_chara"]
    ; 1. 前のキャラクターを片づける
    ;    覚えていた名前ではなく「実際に message0 に出ているもの」を見るので、
    ;    セーブ／ロードをまたいでも取りこぼさない。
    ;    同じキャラを続けて指定したときは、そのまま残して出し直さない。
    [iscript]
    window.MSG_CHARA.sweep(mp.name);
    [endscript]

    ; 2. 新しいキャラクターを表示（メッセージレイヤー message0 の手前に表示）
    [chara_show name="%name" face="%face" layer="message0" zindex="999" reflect="true" left="0" width="400" top="700" time="0" wait="false"]
[endmacro]

;-----------------------------------------------------------
; [reset_message_chara]
; 機能：[message_chara]で表示したキャラを消去する
;-----------------------------------------------------------
[macro name="reset_message_chara"]
    [iscript]
    window.MSG_CHARA.sweep("");
    [endscript]
[endmacro]

;-----------------------------------------------------------
; [visible_message]
; 機能：メッセージウィンドウを表示し、指定キャラをウィンドウ横に表示する
; 引数：chara（キャラ名）, face（表情）
;-----------------------------------------------------------
[macro name="visible_message"]
    [layopt layer="message0" visible="true"]
    [chara_show name="%chara" layer="message0" zindex="999" reflect="true" left="0" width="400" top="700"  face="%face"]
[endmacro]

;-----------------------------------------------------------
; [talk_bl]
; 機能：BL風会話表示（キャラ表示→即時隠蔽？）
; 備考：特殊な演出意図（一瞬だけ表示、あるいは次のクリック待ちがない）と思われます
;-----------------------------------------------------------
[macro name="talk_bl"]
    ; キャラクターを左下に表示
    [chara_show name=%name face=%face layer="message0" zindex="999" reflect="true" left="0" width="400" top="700"]
        
    ; メッセージクリアと同時にキャラを隠す
    [cm] 
    [chara_hide name=%name time=200] 
[endmacro]


;===============================================================================
; システム・探索・メニュー関連マクロ
;===============================================================================

;-----------------------------------------------------------
; [show_menu]
; 機能：メッセージウィンドウと画面のUI（上部プレート・システム操作）を表示する
; 備考：資料（図鑑）・MENU は右上のプレート、AUTO／SKIP／LOG は右下の文字ボタン
;       として [hud_draw]（message_ui.ks）が描きます。
;-----------------------------------------------------------
[macro name="show_menu"]
    @layopt layer="message" visible="true"
    ; ティラノ標準のメニューボタンは使わない（HUDの MENU に集約）
    [hidemenubutton]
    [hud_draw]
[endmacro]

;-----------------------------------------------------------
; [chapter_end_save]
; 機能：[chapter_end] の「はい」から開くセーブ画面
; 備考：・セーブ欄の文字は、章末の確認メッセージではなく、その直前の会話文にする
;         （[chapter_end] の入口で tf.chapter_end_prev へ控えておく）
;       ・[showsave] のままだと、このセーブをロードしたとき同じタグから再開して
;         セーブ画面がもう一度開いてしまう。ロードで tf が空になることを使い、
;         ロード後に再開したときは画面を開かずに先へ進める
;-----------------------------------------------------------
[iscript]
tyrano.plugin.kag.tag.chapter_end_save = {
    pm: {},
    start: function (pm) {
        var kag = this.kag;
        var tf = kag.variable.tf;
        if (tf.chapter_end_save_open != 1) {
            kag.ftag.nextOrder();
            return;
        }
        var prev = tf.chapter_end_prev;
        if (!prev) {
            // 控えが無いときだけ、章末と分かる文字を出す
            var title = "チャプターエンド";
            prev = '<span class="backlog_text">' + title + '</span>';
        }
        kag.stat.current_save_str = prev;
        kag.stat.load_auto_next = true;
        kag.menu.displaySave(undefined, function () {
            kag.stat.load_auto_next = false;
            kag.variable.tf.chapter_end_save_open = 0;
            kag.ftag.nextOrder();
        });
    }
};
TYRANO.kag.ftag.master_tag.chapter_end_save = object(tyrano.plugin.kag.tag.chapter_end_save);
TYRANO.kag.ftag.master_tag.chapter_end_save.kag = TYRANO.kag;
[endscript]

;-----------------------------------------------------------
; [chapter_end]
; 機能：章の終了処理（暗転→セーブ確認）
; 備考：選択肢後のジャンプ先ラベル（*save_check_yes等）はこのマクロ定義外に記述が必要です
;-----------------------------------------------------------
[macro name="chapter_end"]
    ; セーブ欄に出すため、章末の確認メッセージが入る前の本文を控えておく
    [eval exp="tf.chapter_end_prev = TYRANO.kag.stat.current_save_str"]

    ; 画面をクリアして暗転
    [cm]
    [bg storage="chapter_end.png" time=1000]

    ; セーブ確認のメッセージ
    #
    ここまでの進行状況をセーブしますか？[p]

    ; 選択肢の表示
    [glink color="bth13_dk"  text="はい" target="*save_check_yes"]
    [glink color="bth13_dk"  text="いいえ" target="*save_check_no"]
    
    ; 選択待ち
    [s]

*save_check_yes
    [eval exp="tf.chapter_end_save_open = 1"]
    [chapter_end_save]
    [jump target="*save_check_no"]

*save_check_no    
    [cm]
[endmacro]

;-----------------------------------------------------------
; [free_layer_image]
; 機能：画面上の立ち絵・メッセージウィンドウ・レイヤー1画像を全消去
;-----------------------------------------------------------
[macro name="free_layer_image"]
    [freeimage layer="1"]
    [layopt layer="message0" visible="false"]
    [chara_hide_all]
[endmacro]

;-----------------------------------------------------------
; [back_investigation]
; 機能：探索パートなどへの復帰ジャンプ用ラッパー
; 引数：scene（ファイル名）, target（ラベル名）
;-----------------------------------------------------------
[macro name="back_investigation"]
    [jump storage="%scene" target="%target"]
[endmacro]

;-----------------------------------------------------------
; [check_icon]
; 機能：探索ポイントに「New」または「Check済み」アイコンを表示
; 引数：flag（チェックする変数名 "f.xxx" の "xxx" 部分）, x, y
;-----------------------------------------------------------
[macro name="check_icon"]
    ; mp.flag が undefined の場合は何も表示しない（他マクロ実行後の汚染対策）
    [if exp="mp.flag !== undefined && f[mp.flag] != 1"]
        ; 未読・新規の場合（icon_new_01）
        [image layer="1" visible="true" storage="append_theme/icon_new_01.png" folder="image" x=%x y=%y width=60 height=64]
    [elsif exp="mp.flag !== undefined && f[mp.flag] == 1"]
        ; 既読・調査済みの場合（icon_new_02）
        [image layer="1" visible="true" storage="append_theme/icon_new_01.png" folder="image" x=%x y=%y width=60 height=64]
    [endif]
[endmacro]

;==== マクロ定義：シーン切り替え ====
; 演出目的：暗転を用いたシーン切り替え処理を共通化し、再利用性を高める。
; （通常は common.ks などの共通ファイルに記述し、ゲーム起動時に読み込んでおきます）

[macro name="scene_transition" bgm_file="" bg_file=""]
    ; 1. 現在のシーンの終了処理
    [cm]
    [fadeoutbgm]
    
    ; 2. 画面の暗転
    ; パラメーターで受け取った時間を &mask_time で指定します
    [mask time=2000 effect="fadeInDown"]
      
    [bg storage=%bg_file]
    [playbgm storage=%bgm_file loop="true"]
    ; 4. 画面の明転
    [mask_off time=1000]
[endmacro]

;-----------------------------------------------------------
; [gun_click]
; 機能：拳銃を構える緊張演出（撃発前のクリック音）
; 詳細：スライド音→静寂の間 で場の空気を締める
;-----------------------------------------------------------
[macro name="gun_click"]
    [playse storage="gun_load.mp3" volume=90 buf=1]
    [quake time=200 hmax="3" vmax="2"]
    ; 画面を一瞬だけ薄暗くして緊張感を演出
    [layermode layer="2" time=0 mode="normal" color="0x000000" opacity=80]
    [wait time=400]
    [free_layermode layer="2" time=600]
[endmacro]


;-----------------------------------------------------------
; [gunshot]
; 機能：発砲演出（銃声→白フラッシュ→画面揺れ→赤ノイズ）
; 引数：fatal（"true" で致命的な演出、省略で非致命）
; 使用例：
;   [gunshot]           → 腕を撃つ程度の演出
;   [gunshot fatal="true"] → 致命的な被弾演出
;-----------------------------------------------------------
[macro name="gunshot"]
    ; 1. 銃声SE（即時）
    [playse storage="gunshot.mp3" volume=100 buf=1]

    ; 2. 白フラッシュ（発砲炎）
    [layermode layer="2" time=0 mode="normal" color="0xffffff" opacity=230]
    [wait time=60]
    [free_layermode layer="2" time=80]

    ; 3. 画面揺れ
    [if exp="mp.fatal == 'true'"]
        [quake time=600 hmax="18" vmax="12"]
    [else]
        [quake time=400 hmax="10" vmax="6"]
    [endif]

    ; 4. 赤いノイズオーバーレイ（被弾の衝撃）
    [layermode layer="1" time=0 mode="screen" graphic="../bgimage/noise.png" opacity=200 color="0xFF1100"]
    [wait time=80]
    [free_layermode layer="1" time=300]

    ; 5. 致命傷の場合は追加で暗転フラッシュ
    [if exp="mp.fatal == 'true'"]
        [wait time=100]
        [layermode layer="2" time=0 mode="normal" color="0x000000" opacity=180]
        [wait time=200]
        [free_layermode layer="2" time=800]
    [endif]
[endmacro]

;-----------------------------------------------------------
; [set_item_status]
; 機能：f.status の owned / secret をtrueにセットする
; 詳細：引数に "true" が渡された項目だけ true に変更する
;       引数が省略された項目は一切変化させない（true→true も保持）
; 引数：
;   id     （必須）f.status のキー名（例: "bottle", "chara_01"）
;   owned  （任意）"true" を渡すと owned = true にする
;   secret （任意）"true" を渡すと secret = true にする
;
; 使用例：
;   [set_item_status id="bottle" owned="true"]            ; owned だけ true に
;   [set_item_status id="eruku_phone" secret="true"]      ; secret だけ true に
;   [set_item_status id="key" owned="true" secret="true"] ; 両方 true に
;   [set_item_status id="bottle"]                         ; 何も変化しない
;-----------------------------------------------------------
[macro name="set_item_status"]
    [iscript]
    (function(){
        var id = mp.id;
        if(!id){ return; }

        // f.status / エントリが未定義なら安全に初期化
        if(typeof f.status === 'undefined'){ f.status = {}; }
        if(typeof f.status[id] === 'undefined'){
            f.status[id] = { owned: false, secret: false };
        }

        // owned: "true" が渡されたときだけ true にする
        // 省略・空・"false" は無視（既存値を絶対に下げない）
        if(mp.owned === 'true'){
            f.status[id].owned = true;
        }

        // secret: "true" が渡されたときだけ true にする
        if(mp.secret === 'true'){
            f.status[id].secret = true;
        }

        // 一度でも手に入れたものは、周回をまたいで図鑑に残す
        // （経路A・経路Bで手に入るものが違うため、f.status だけでは揃わない）
        try {
            var kag = window.TYRANO ? window.TYRANO.kag : tyrano.plugin.kag;
            var sfv = kag.variable.sf;
            if(!sfv.seen_items || typeof sfv.seen_items !== "object"){ sfv.seen_items = {}; }
            var cur = sfv.seen_items[id] || 0;
            if(f.status[id].secret){ sfv.seen_items[id] = 2; }
            else if(f.status[id].owned && cur < 1){ sfv.seen_items[id] = 1; }
            if(sfv.seen_items[id] !== cur){ kag.saveSystemVariable(); }
        } catch(e){}

        // 証拠品がすべて揃ったら称号を出す
        if(window.ACH){ window.ACH.checkAllItems(); }
    })();
    [endscript]
[endmacro]


;-----------------------------------------------------------
; [open_debug]
; 機能：デバッグ用シーンジャンパーを起動する
; 詳細：debug.ks の *debug_start へジャンプします。
;       タイトル画面の隠しトリガーから自動的に呼ばれますが、
;       開発中はシナリオ任意箇所に [open_debug] と書いても起動できます。
; 使用例：[open_debug]
; ★ 本番環境に残しても、タイトルの隠しトリガー以外から
;   呼ばれることはないため、プレイヤーには影響しません。
;-----------------------------------------------------------
[macro name="open_debug"]
    [jump storage="system/debug.ks" target="*debug_start"]
[endmacro]

; ============================================================
; voice_macro.ks
;
; 使用方法:
;   [voice id="v00001"]
;
; bufを変更したい場合:
;   [voice id="v00001" buf="2"]
;
; このマクロは内部タグ [voice_play] へ処理を渡します。
; voice_runtime.js を先に [loadjs] しておく必要があります。
; ============================================================
[macro name="voice"]
[voice_play id=%id buf=%buf|2]
[endmacro]

;-----------------------------------------------------------
; [shinsho_text]
; 機能：解決編の「警部の心証」（あと何回まで言い直せるか）を
;       tf.shinsho に文字列で用意する。
; 用途：[stand_select] の prompt に添える。
;       捜査手帳の提示モードは item_list.ks が自前で描くので不要。
; 備考：解決編の外（f.s8_phase != 1）では空文字になる。
;-----------------------------------------------------------
[macro name="shinsho_text"]
    [iscript]
    (function(){
        tf.shinsho = "";
        if(f.s8_phase !== 1){ return; }
        var left = (typeof f.s8_miss_left === "number") ? f.s8_miss_left : 0;
        var max  = (typeof f.s8_miss_max  === "number") ? f.s8_miss_max  : 0;
        if(max <= 0){ return; }
        var mark = "";
        for(var i = 0; i < max; i++){ mark += (i < left) ? "●" : "○"; }
        tf.shinsho = "<br>（警部の心証 " + mark + "）";
    })();
    [endscript]
[endmacro]

[return]
