;一番最初に呼び出されるファイル
*init

[title name="舞黒館の惨劇 探偵少女はダウトで勝ちの目を見るか"]

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

;ダウト ミニゲームへ
[plugin name="doubt"]
@jump storage="doubt_main.ks"
