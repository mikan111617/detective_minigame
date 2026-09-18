;一番最初に呼び出されるファイル
*init

[title name="舞黒館の惨劇"]

;メッセージボックスは非表示
@layopt layer="message" visible=false

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

; 初回起動時だけ、各種システムを読み込む前に言語を選んでもらう。
; 選択後はページ再読み込みになり、選択言語で以降のシナリオを読み込む。
;[call storage="system/language_select.ks"]  ; ダウト版では言語選択を省略

; テーマ一括変換プラグイン その１を読み込む
[plugin name="theme_kopanda_bth_13_dk"]

[stop_keyconfig]
[loadjs storage="voice_runtime.js"]
[call storage="system/macro.ks"]

; 称号システム（[achieve] / [achievement_screen] と sf.achievements）
; get_item.ks・puzzle.ks・ending_credit.ks から呼ぶので、それらより先に読む
[call storage="system/achievement.ks"]

; シナリオ画面のUI（デザイン案 1b）
; message_ui.ks … メッセージ帯・名前銘板の体裁と [hud_draw]（上部プレート／システム操作）
;                 [gage_draw] [show_menu] から呼ぶので macro.ks の後で読む
[call storage="system/message_ui.ks"]

; 調査パート共通UI（scene4 / scene7）
; investigation_ui.ks … 描画エンジンと [inv_set] [inv_map] [inv_room] マクロ
; inv_data_sceneX.ks  … 各章の部屋・調査ポイント・トピック定義
; scene4 の父親探索差分は、基礎データを読み込んだ後に上書きする
; scene7 では scene4 固有の館ギミックを再取得できないよう境界差分を適用する
; get_item.ks         … macro.ks の [get_item] を差し替える（必ず macro.ks の後で読む）
[call storage="system/investigation_ui.ks"]
[call storage="system/inv_data_scene4.ks"]
[call storage="system/inv_data_scene7.ks"]
[call storage="system/get_item.ks"]

; 館の仕掛け（ラジオ／ダイヤル錠／三色硝子）
[call storage="system/gimmick.ks"]

; 立ち絵つき選択肢画面（scene2 の庭園パートなど）
; choice_ui.ks … [stand_select] マクロ
[call storage="system/choice_ui.ks"]

; 事件発生パート（scene5 / scene6）の能動アクション
; incident_ui.ks … [inc_urgent]（制限時間つきの即断）[inc_alibi]（アリバイ表）
;                  [inc_insight] [inc_note] [inc_back]
[call storage="system/incident_ui.ks"]

; タイトルロゴの共通組みとタイトル演出（title.ks / scene1 で使用）
[call storage="system/title_ui.ks"]

[call storage="system/chara.ks"]

; 画面中央に額装カードで出す「報せ」（[notify_profile] / [notify_info]）
; 人物ファイルの表示に f.master_data を使うので init_item_data.ks より先に読む
[call storage="system/notify_ui.ks"]
[call storage="system/init_item_data.ks"]
; [load_all_music]
[chara_config talk_focus="brightness" pos_mode="false"]

[message_config control_line_break="true" line_spacing="20"]

; メッセージウィンドウを 1b の帯に組み替える（テーマの枠画像・名前枠を上書き）
[msg_ui_setup]

;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
@call storage="system/tyrano.ks"

; バックログ（ログ画面）は tf.system.backlog に溜まる。
;   tf はセーブに含まれず、ロード時も初期化されない（loadGameData は
;   variable.tf に一切触らない）。そのため、ロードすると直前まで遊んでいた
;   周回の本文がログに残ったままになる。読み込みの開始時に捨てる。
;   タイトルへ戻って新しく始めたときも同じなので、title.ks の *gamestart
;   からも同じ処理を呼ぶ。
[iscript]
(function(){
    var kag = tyrano.plugin.kag;
    if(!kag || !kag.on || kag.__backlogResetBound){ return; }
    kag.__backlogResetBound = true;
    var wipe = function(){
        try {
            var tfv = kag.variable.tf;
            if(tfv && tfv.system && tfv.system.backlog){ tfv.system.backlog = []; }
        } catch(e){}
    };
    kag.on("load-start", wipe);
    kag.__backlogWipe = wipe;   // 新規開始のときは title.ks から直接呼ぶ
})();
[endscript]

; 注意画面はアプリ起動中に一度だけ表示する。
; sessionStorage はタイトルへ戻る際の再読み込みでは残り、アプリ終了時に破棄される。
; 初回言語選択の再読み込みより後でフラグを立てるので、選択直後には必ず表示される。
[iscript]
tf.show_startup_caution = 0;
try {
    if (window.sessionStorage.getItem("maiguro_startup_caution_shown") !== "1") {
        window.sessionStorage.setItem("maiguro_startup_caution_shown", "1");
        tf.show_startup_caution = 1;
    }
} catch (e) {
    // sessionStorage を利用できない環境では、同一ページ内だけでも再表示を防ぐ。
    if (window.__maiguroStartupCautionShown !== true) {
        window.__maiguroStartupCautionShown = true;
        tf.show_startup_caution = 1;
    }
}
[endscript]

[if exp="tf.show_startup_caution==1"]
    [if exp="window.I18N && window.I18N.isEN()"]
        @bg storage="caution_en.png"
    [else]
        @bg storage="caution.png"
    [endif]
    @wait time="1000"
[endif]

;ダウト ミニゲームへ
[plugin name="doubt"]
@jump storage="doubt_main.ks"
