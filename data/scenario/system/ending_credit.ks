;=========================================
; ending_credit.ks
; エンディングクレジットロール
;=========================================
*ending_credits
; --- 初期化 ---
[chara_hide_all time=0]
[cm]
[clearfix]
[layopt layer="message" visible=false]
[mask time="1000"]
@image storage="bg/bg-title.png" folder="image/doubt"
@playbgm storage="ending.mp3"
; 背景を少し暗くぼかす演出
[filter layer="base" brightness="50" blur="2"]

[mask_off time="1000"]

; =========================================
; iscript でクレジットHTMLを一括生成
; =========================================
[iscript]
(function () {

    // 既に存在する場合は除去（セーブ/ロード対策）
    var old = document.getElementById('credit_overlay');
    if (old) old.parentNode.removeChild(old);

    // ---- クレジット項目定義 ----
    // { role: "役割テキスト（省略可）", name: "名前テキスト" }
    // role を省略すると名前だけ大きく表示
    var items = [
        { name: "舞黒館の惨劇 探偵少女はダウトで勝ちの目を見るか" },
        { role: "制作", name: "プロジェクト：舞黒館" },
        { role: "シナリオ", name: "ひんやりミカン" },
        { role: "UI画像", name: "空想曲線<br>ゲームUIセット vol.23 (02 ダーク)" },
        { role: "背景", name: "舞黒館" },
        { role: "キャラクター", name: "" },
        { role: "", name: "真白　真歩流" },
        { role: "", name: "真白　愛理" },
        { role: "", name: "徐音　和人" },
        { role: "", name: "メアリー・キング" },
        { role: "", name: "富礼知　朱志香" },
        { role: "", name: "灰音　小出里亜" },
        { role: "", name: "穂在呂　叡留久" },
        { role: "", name: "穂在呂　珠璃" },
        { role: "", name: "零度　警部" },
        { role: "BGM", name: "Suno AI" },
        { name: "Special Thanks" },
        { name: "プレイしてくださった<br>すべての方へ" }
    ];

    // ---- スクロール速度（px/s）----
    // 項目数に応じて自動計算：最後の行が画面上端を抜けるまでの時間
    var ITEM_HEIGHT    = 120;   // 1項目あたりの高さ (px)
    var SCROLL_PX_PER_S = 60;   // スクロール速度 (px/s)
    var VIEWPORT_H     = 1080;

    var totalH = items.length * ITEM_HEIGHT + VIEWPORT_H * 2;
    var durationMs = Math.round(totalH / SCROLL_PX_PER_S * 1000);

    // ---- HTML 生成 ----
    var html = '';
    items.forEach(function (item) {
        if (item.role) {
            html += '<div class="credit-block">'
                  +   '<div class="credit-role">' + item.role + '</div>'
                  +   '<div class="credit-name">' + item.name + '</div>'
                  + '</div>';
        } else {
            html += '<div class="credit-block credit-title">'
                  +   '<div class="credit-name credit-name--big">' + item.name + '</div>'
                  + '</div>';
        }
    });

    // ---- オーバーレイ DOM 構築 ----
    var overlay = document.createElement('div');
    overlay.id  = 'credit_overlay';
    overlay.innerHTML =
        '<style>'
        + '#credit_overlay {'
        +   'position:fixed; top:0; left:0; width:100%; height:100%;'
        +   'overflow:hidden; z-index:9999; pointer-events:none;'
        + '}'
        + '#credit_inner {'
        +   'position:absolute; width:100%; text-align:center;'
        +   'top:' + VIEWPORT_H + 'px;'
        +   'animation: credit_scroll ' + durationMs + 'ms linear forwards;'
        + '}'
        + '@keyframes credit_scroll {'
        +   'from { transform: translateY(0); }'
        +   'to   { transform: translateY(-' + totalH + 'px); }'
        + '}'
        + '.credit-block {'
        +   'margin: 0 auto 60px; padding: 0 40px;'
        +   'max-width: 900px;'
        + '}'
        + '.credit-role {'
        +   'font-size: 22px; color: #aaa; letter-spacing: 0.2em;'
        +   'margin-bottom: 10px;'
        + '}'
        + '.credit-name {'
        +   'font-size: 32px; color: #fff; letter-spacing: 0.1em;'
        +   'line-height: 1.6;'
        + '}'
        + '.credit-title { margin-bottom: 80px; }'
        + '.credit-name--big {'
        +   'font-size: 48px; font-weight: bold;'
        +   'color: #f5e6c8; letter-spacing: 0.15em;'
        + '}'
        + '</style>'
        + '<div id="credit_inner">' + html + '</div>';

    document.body.appendChild(overlay);

    // アニメーション終了後にオーバーレイを消してエンジンを再開
    var inner = overlay.querySelector('#credit_inner');
    var finished = false;

    function finishCredits() {
        if (finished) return;   // 二重発火防止
        finished = true;
        if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
        // クリック用ハンドラを除去
        document.removeEventListener('click', skipHandler, true);
        document.removeEventListener('touchend', skipHandler, true);
        TG.ftag.startTag("jump", { target: "*ending_message" });
    }

    // 自然終了
    inner.addEventListener('animationend', finishCredits);

    // クリック／タップでスキップ
    function skipHandler(e) {
        finishCredits();
    }
    // overlay は pointer-events:none なので document 側で拾う（capture=true）
    document.addEventListener('click', skipHandler, true);
    document.addEventListener('touchend', skipHandler, true);

})();
[endscript]

; スクロールが終わるまでエンジンを停止
[s]

; ========================================
; エンディング後メッセージ
; ========================================

*ending_message
; フェードアウト
[mask time=2000 effect=fadeIn]

; クレジット情報の消去
[free_filter layer="base"]
[freeimage layer="1"]
[fadeoutbgm time=5000]

; メッセージウィンドウの復帰
[layopt layer="message" visible=true]
[current layer="message0"]

[mask_off time=1000]

; --- 終了処理 ---
*ending_done
[cm]
[clearfix]
[free_layer_image]
[layopt layer="message" visible=false]
; アーケードプレイの締め（全戦突破画面 → ランキング登録 → タイトル）へ
[jump storage="doubt_main.ks" target="*arcade_ending"]
