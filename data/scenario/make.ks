;このファイルは削除しないでください！
;
;make.ks はデータをロードした時に呼ばれる特別なKSファイルです。
;Fixレイヤーの初期化など、ロード時点で再構築したい処理をこちらに記述してください。
;
;

;──────────────────────────────────────────────
; 調査画面（investigation_ui.ks のマクロ）でセーブしたデータをロードしたときは、
; 画面そのものが復元されないので、保存されていた調査画面へ入り直して描き直す。
; マクロのスタックに調査画面の印（__inv）が残っていることで判定する。
;──────────────────────────────────────────────
[iscript]
(function(){
    var kf = TG.stat.f;
    var target = kf.inv_screen_target;
    if(!target){ return; }
    var inMacro = false;
    try {
        var arr = TG.stat.stack.macro || [];
        for(var i=0; i<arr.length; i++){ if(arr[i] && arr[i].__inv){ inMacro = true; } }
    } catch(e){}
    if(!inMacro){ return; }
    var data = (kf.INV_DATA || {})[kf.inv_chapter];
    if(!data || !data.storage){ return; }
    setTimeout(function(){
        if(window.INV_READY){ window.INV_READY(); }
        window.INV_ENGINE.clear();
        window.INV_ENGINE.popMacro();
        TG.ftag.startTag("jump", { storage: data.storage, target: target });
    }, 80);
})();
[endscript]

;make.ks はロード時にcallとして呼ばれるため、return必須です。
[return]

