;一番最初に呼び出されるファイル
*init

[title name="舞黒館の惨劇 探偵少女はダウトで勝ちの目を見るか"]

;メッセージボックスは非表示
@layopt layer="message" visible=false

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

; 初回起動時だけ、各種システムを読み込む前に言語を選んでもらう。
; 選択後はページ再読み込みになり、選択言語で以降のシナリオを読み込む。
[call storage="system/language_select.ks"]

; テーマ一括変換プラグイン その１を読み込む
[plugin name="theme_kopanda_bth_13_dk"]

[stop_keyconfig]

; シナリオ画面のUI（デザイン案 1b）
; message_ui.ks … メッセージ帯・名前銘板の体裁と [hud_draw]（上部プレート／システム操作）
;                 [gage_draw] [show_menu] から呼ぶので macro.ks の後で読む
[call storage="system/message_ui.ks"]

; タイトル画面はダウト版の title.ks（[doubt_title]）で作るため、
; 本編用の system/title_ui.ks は読み込まない
;[call storage="system/title_ui.ks"]

[call storage="system/chara.ks"]

[chara_config talk_focus="brightness" pos_mode="false"]

[message_config control_line_break="true" line_spacing="20"]

@call storage="system/macro.ks"

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

;ダウト ミニゲームへ
[plugin name="doubt"]
@jump storage="title.ks" target="*start"
