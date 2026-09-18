;=========================================
; ending_credit.ks
; エンディングクレジットロール
;=========================================
*ending_credits
[iscript]
if(typeof f.bad_end_count === 'undefined') f.bad_end_count = 0;
if(typeof f.normal_end_count === 'undefined') f.normal_end_count = 0;
if(typeof f.true_end_count === 'undefined') f.true_end_count = 0;
[endscript]

; --- 初期化 ---
[chara_hide_all time=0]
[cm]
[clearfix]
[layopt layer="message" visible=false]
[mask time="1000"]

; --- 背景・BGM 分岐 ---
[if exp="f.badend == 1"]
    [bg storage="event/bad_end.png" time=0]
    [playbgm storage="Searching_for_Clues_verbad.mp3"]
[elsif exp="f.normalend == 1"]
    [bg storage="event/normal_end.png" time=0]
    [playbgm storage="Living_with_the_Scars.mp3"]
[else]
    [bg storage="event/grand_final.png" time=0]
    [playbgm storage="Main_theme.mp3"]
[endif]

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
        { name: "舞黒館の惨劇" },
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
        { role: "", name: "真白　奢禄" },
        { role: "", name: "クロエ・キング"},
        { role: "BGM", name: "Suno AI" },
        { role: "SE素材", name: "効果音ラボ<br>OtoLogic<br>ポケットサウンド" },
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

; --- 経路ごとの解決を記録する ---
; ノーマルエンド以上に到達した周回だけ数える。経路A・経路Bの両方を
; 解き終えると称号「二つの筋書き」が付く。sf なので周回をまたいで残る。
[iscript]
(function(){
    if(!(f.normalend == 1 || f.trueend == 1)){ return; }
    var kag = (window.ACH && window.ACH.kag) ? window.ACH.kag() : window.TYRANO.kag;
    var sfv = kag.variable.sf;
    if(!sfv.route_cleared || typeof sfv.route_cleared !== "object"){ sfv.route_cleared = {}; }
    sfv.route_cleared[(f.route_b == 1) ? "b" : "a"] = 1;
    if(sfv.route_cleared.a && sfv.route_cleared.b && window.ACH){
        window.ACH.grant("both_routes");
    } else {
        try { kag.saveSystemVariable(); } catch(e){}
    }
})();
[endscript]

; --- エンディング分岐判定 ---

[if exp="f.badend == 1"]
    [if exp="f.bad_end_count < 1"]
        [eval exp="f.bad_end_count = 1"]
    [endif]
    [achieve id="end_bad"]
    ; バッドエンドの場合
    #
    エンディング3「全ては闇に散って……」[p]
    
    ここまでゲームをプレイしてくださりありがとうございます。[p]
    残念ながらバッドエンド到達です……。[p]

    証拠が足りていなかった、あるいは推理パートで推理を間違えるとこのエンディングになります。[p]

    証拠が不足していると推理が中断されて、バッドエンドになります。[p]
    
    また、最後の推理パートでは零度警部の心証が無い状態で間違えるとバッドエンドになってしまいます。[p]
    心証は推理を間違えるたびに減っていきます。[p]
    
    零度警部の心証は最初の事件が発生してから調査までの間の行動で変動します。[p]
    
    そのため、慎重に選択肢を選んで、再度挑戦してみてください。[p]
    [jump target="*hint_section"]

[elsif exp="f.normalend == 1"]
    [if exp="f.normal_end_count < 1"]
        [eval exp="f.normal_end_count = 1"]
    [endif]
    [achieve id="end_normal"]
    ; ノーマルエンドの場合
    #
    エンディング1「舞黒館の惨劇」[p]
    
    ここまでゲームをプレイしてくださりありがとうございます。[p]
    物語は一応の結末を迎えましたが、まだ明かされていない真実があります。[p]
    父親はどこへ行ったのか？[p]
    その結末を見るためには真エンディングにたどり着く必要があります。[p]
    [jump target="*hint_section"]

[elsif exp="f.trueend == 1"]
[bg storage="event/grand_end.png" cross="3000"]
    [if exp="f.true_end_count < 1"]
        [eval exp="f.true_end_count = 1"]
    [endif]
    [achieve id="end_true"]
    ; トゥルーエンドの場合
    #
    エンディング2「過去の縁は今の絆」[p]
    
    おめでとうございます！[r]
    トゥルーエンドです！[p]

    ここまでゲームをプレイしてくださり本当にありがとうございました。[p]
    最後にささやかですが、特典があります。[p]
    ゲーム本編で遊べるパズルゲームをタイトル画面から遊べるようになります。[p]
    
    ; パズル解放フラグ（例）
    [eval exp="sf.puzzle_unlocked = true"]

    最後にここまでプレイしていただき、本当にありがとうございました。[p]
    まだ、謎が残っている部分もありますが、それは別の物語で明らかになるかもしれません。[p]
    それではまたどこかでお会いしましょう！[p]

    @mask
    @wait time="1000"
    @bg storage="dark.png"
    @mask_off
    #
    惨劇から1週間後。[p]

    #airi
    ねえ、お姉ちゃん豪華客船の話聞いた？[p]

    #mahoru
    うん、私たちが舞黒館に泊まった日のことでしょう？[p]

    #airi
    そうそれ！[p]

    まだ見つかってないんだって。[p]

    どこに消えちゃったんだろうね。[p]

    #mahoru
    わからない。だけど……。[p]

    #airi
    お姉ちゃん？[p]

    #mahoru
    ……。[p]
    ううん、何でもない。[p]
    行こう！[p]

    #
    （もしも、あの日、私たちが豪華客船に乗っていたら……）[p]

    [layopt layer="message" visible=false]
    [bg storage="event/secret.png"]

    @wait time="5000"

    [jump target="*ending_done"]

[else]
    ; その他のエンディング（予備）
    #
    エンディング2「真実の先にあるもの」[p]
    [jump target="*hint_section"]

[endif]
; --- ヒント表示セクション（True以外で通過） ---
*hint_section
#
エンディングは全部で3つあります。[p]
ぜひ、すべてのエンディングを目指してプレイしてみてください！[p]

真エンディングにたどり着くための条件は四つあります。[p]

①秘密の隠し部屋を見つけること。[p]

②とある人物の本当の参加理由を明らかにすること。[p]

③事件中に舞黒邦夢の手記を見つけること。[p]

④地下への入り口を見つけること。[p]

タイトル画面の「舞黒相談所」から、真エンディング等のヒントを得ることができます。[p]

ヒントを参考に真エンディングを目指してみてください！[p]

最後に改めまして、本ゲームをプレイしていただき、ありがとうございました。[p]
他のエンディングでお待ちしています。[p]

@jump target="ending_done"

; --- 終了処理 ---
*ending_done
[cm]
[clearfix]
[free_layer_image]
[layopt layer="message" visible=false]
; タイトル画面へ戻る
[jump storage="title.ks" target="*start"]
