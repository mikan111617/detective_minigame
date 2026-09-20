;===============================================================================
; UI・ゲージ関連マクロ
;===============================================================================
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
; [free_layer_image]
; 機能：画面上の立ち絵・メッセージウィンドウ・レイヤー1画像を全消去
;-----------------------------------------------------------
[macro name="free_layer_image"]
    [freeimage layer="1"]
    [layopt layer="message0" visible="false"]
    [chara_hide_all]
[endmacro]

[return]
