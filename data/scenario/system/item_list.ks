;==== item_list.ks ====
; 資料画面（探偵の手帳・見開き版）と、証拠品を突きつける画面を統合したファイル。
; 一覧と詳細を1画面にまとめたので item_detail.ks への遷移は不要です。
;
;   資料として開く   : [call storage="system/item_list.ks"]
;                      （message_ui.ks の [sleepgame] からも同じ入口を使います）
;   証拠を提示させる : [call storage="system/item_list.ks" target="*select_mode"]
;                      → 選ばれた ID が tf.selected_id に入った状態で [return]
;
; ※ item_detail.ks / select_evidence_system.ks は廃止しました。

;-----------------------------------------------------------
; 入口
;-----------------------------------------------------------
[jump target="*view_mode"]

; 資料モード（閲覧するだけ。閉じるボタンで終了）
*view_mode
[eval exp="tf.nb_mode = 'view'"]
[jump target="*nb_open"]

; 調査パートの画面から開く（閉じると、開いたときの調査画面へ戻る）
*inv_view_mode
[eval exp="tf.nb_mode = 'view'"]
[jump target="*nb_open"]

; 図鑑モード（周回をまたいで、一度でも手にしたものを読み返す）
*gallery_mode
[eval exp="tf.nb_mode = 'gallery'"]
[jump target="*nb_open"]

; 提示モード（証拠品をひとつ選んで呼び出し元に返す）
*select_mode
[eval exp="tf.nb_mode = 'select'"]
[eval exp="tf.selected_id = ''"]
[jump target="*nb_open"]

;-----------------------------------------------------------
; 画面の初期化
;-----------------------------------------------------------
*nb_open
[cm]
[clearfix]
[hidemenubutton]

[layopt layer="message0" visible=false]
[layopt layer="fix" visible=false]

; 資料モードのときだけ、背景・立ち絵を消して手帳だけを見せる
; （提示モードは本編の途中に割り込むので、下の画面はそのまま残す）
[if exp="tf.nb_mode == 'view'"]
[freeimage layer=0]
[freeimage layer=1]
[freeimage layer=2]
[endif]

;-----------------------------------------------------------
; HTML（手帳の見開き）
;-----------------------------------------------------------
[html name="nb_html"]
<style>
body #nb_root{
    position:absolute; left:0; top:0; width:1920px; height:1080px;
    font-family:'Hiragino Kaku Gothic ProN','Yu Gothic','メイリオ',sans-serif;
    background:radial-gradient(120% 80% at 50% 35%,#241608 0%,#0d0805 100%);
    pointer-events:auto; user-select:none; -webkit-user-select:none;
}

/* 手帳の表紙 */
body #nb_cover{
    position:absolute; left:120px; top:48px; width:1680px; height:984px;
    background:linear-gradient(180deg,#3a2410,#241408);
    border:1px solid #a57c34; border-radius:6px;
    box-shadow:0 24px 60px rgba(0,0,0,0.7);
}

/* 見出し */
body #nb_title{
    position:absolute; left:140px; top:62px;
    display:flex; align-items:center; gap:22px;
    font-family:'Waosagi',serif; font-size:46px; letter-spacing:0.2em;
    color:#f2d882; text-shadow:0 2px 6px rgba(0,0,0,0.6);
}
body #nb_title i{ width:10px; height:10px; background:#c8a060; transform:rotate(45deg); display:block; }
body #nb_lead{
    position:absolute; left:150px; top:118px;
    font-size:24px; letter-spacing:0.14em; color:#b79a63;
}

/* タブ */
body #nb_tabs{ position:absolute; right:300px; top:56px; display:flex; align-items:flex-end; gap:10px; }
.nb_tab{
    min-width:190px; padding:14px 26px; text-align:center;
    font-size:28px; font-weight:bold; letter-spacing:0.12em; cursor:pointer;
    border:1px solid #a57c34; border-bottom:none; border-radius:6px 6px 0 0;
    background:linear-gradient(180deg,#4b3d33,#33271e); color:#c3ab86;
}
.nb_tab.active{ background:#efe4c8; color:#3e2b1d; padding-bottom:22px; }

/* 閉じるボタン（資料モードのみ） */
body #nb_close{
    position:absolute; right:128px; top:52px; width:72px; height:72px; cursor:pointer;
}

/* 紙面 */
body #nb_pages{
    position:absolute; left:140px; top:150px; width:1640px; height:862px;
    display:flex; background:#e9dcbc; border:1px solid #8a6a38;
    box-shadow:inset 0 2px 0 rgba(255,255,255,0.5);
}

/* 左ページ：一覧 */
body #nb_left{
    width:660px; height:100%; box-sizing:border-box; padding:26px 18px 26px 30px;
    background:linear-gradient(90deg,#efe4c8,#e6d7b2);
    display:flex; flex-direction:column; gap:14px;
}
body #nb_left_head{
    display:flex; align-items:baseline; justify-content:space-between;
    padding:0 6px 10px 2px; border-bottom:2px solid #b8a173;
}
body #nb_left_title{ font-family:'Waosagi',serif; font-size:34px; letter-spacing:0.12em; color:#3e2b1d; }
body #nb_count{ font-size:22px; color:#7a6647; letter-spacing:0.08em; }
body #nb_list{
    flex:1; overflow-y:auto; padding-right:10px;
    display:flex; flex-direction:column; gap:10px;
    scrollbar-width:thin; scrollbar-color:#a8925f rgba(0,0,0,0.12);
    -webkit-overflow-scrolling:touch; touch-action:pan-y;
}
body #nb_list::-webkit-scrollbar{ width:10px; }
body #nb_list::-webkit-scrollbar-thumb{ background:#a8925f; border-radius:5px; }
body #nb_list::-webkit-scrollbar-track{ background:rgba(0,0,0,0.12); }

.nb_row{
    display:flex; align-items:center; gap:20px; padding:12px 16px; box-sizing:border-box;
    min-height:104px; border:1px solid #c2ab7c; border-radius:3px;
    background:rgba(255,252,240,0.62); cursor:pointer;
}
.nb_row.active{
    background:#3a2410; border-color:#a57c34;
    box-shadow:0 6px 16px rgba(58,36,16,0.35);
}
.nb_row.empty{
    background:repeating-linear-gradient(135deg,rgba(140,120,84,0.10) 0 10px,rgba(140,120,84,0) 10px 20px);
    border-style:dashed; cursor:default;
}
.nb_thumb{
    flex:none; width:80px; height:80px; object-fit:cover;
    border:1px solid #8a6a38; background:#1c1109;
}
.nb_row.active .nb_thumb{ border-color:#c8a060; }
.nb_row.empty .nb_thumb{ background:rgba(120,100,70,0.18); }
.nb_texts{ flex:1; min-width:0; }
.nb_ruby{ font-size:18px; letter-spacing:0.1em; height:22px; color:#8a7350; }
.nb_row.active .nb_ruby{ color:#c0a878; }
.nb_name{
    font-size:30px; font-weight:bold; letter-spacing:0.04em; color:#3e2b1d;
    overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
}
.nb_row.active .nb_name{ color:#f2d882; }
.nb_row.empty .nb_name, .nb_row.empty .nb_ruby{ color:#9b8a68; }

/* 綴じ目 */
body #nb_bind{
    width:26px; height:100%; flex:none;
    background:linear-gradient(90deg,rgba(90,66,32,0.28),rgba(90,66,32,0.06) 45%,rgba(90,66,32,0.28));
    display:flex; flex-direction:column; align-items:center; justify-content:space-evenly;
    padding:70px 0; box-sizing:border-box;
}
body #nb_bind span{ width:2px; height:26px; background:#8a6a38; opacity:0.55; display:block; }

/* 右ページ：詳細 */
body #nb_right{
    flex:1; height:100%; box-sizing:border-box; padding:34px 44px 30px 40px;
    background:linear-gradient(90deg,#e6d7b2,#efe4c8);
    display:flex; flex-direction:column;
}
body #nb_detail{ display:flex; gap:38px; height:100%; }
body #nb_photo_col{ flex:none; width:340px; display:flex; flex-direction:column; gap:14px; }
body #nb_photo_frame{
    width:340px; height:430px; background:#efe8d6; border:1px solid #8a6a38;
    padding:12px; box-sizing:border-box; box-shadow:0 8px 18px rgba(60,40,16,0.25);
}
body #nb_photo{ width:100%; height:100%; object-fit:contain; background:#1c1109; }
body #nb_kind{ font-size:20px; letter-spacing:0.1em; color:#7a6647; text-align:center; }
body #nb_text_col{ flex:1; min-width:0; display:flex; flex-direction:column; }
body #nb_dt_ruby{ font-size:20px; color:#8a7350; letter-spacing:0.14em; height:26px; }
body #nb_dt_name{
    font-family:'Waosagi',serif; font-size:52px; line-height:1.2; color:#2f2013;
    padding-bottom:18px; border-bottom:2px solid #b8a173;
}
/* 紹介文の入れ物。長い文章はここをスクロールさせる（スマホはスワイプ） */
body #nb_dt_scroll{
    flex:1; min-height:0; overflow-y:auto; padding-right:12px;
    scrollbar-width:thin; scrollbar-color:#a8925f rgba(0,0,0,0.12);
    -webkit-overflow-scrolling:touch; touch-action:pan-y;
}
body #nb_dt_scroll::-webkit-scrollbar{ width:10px; }
body #nb_dt_scroll::-webkit-scrollbar-thumb{ background:#a8925f; border-radius:5px; }
body #nb_dt_scroll::-webkit-scrollbar-track{ background:rgba(0,0,0,0.12); }
body #nb_dt_text{
    font-size:29px; line-height:1.85; color:#33261a; margin-top:26px;
    white-space:pre-line; text-wrap:pretty;
}
body #nb_secret{
    margin-top:20px; background:rgba(160,40,40,0.10); border-left:6px solid #a33a3a;
    padding:22px 24px; display:none; white-space:pre-line;
}
body #nb_secret b{
    display:block; font-size:22px; color:#9c2f2f; letter-spacing:0.1em; margin-bottom:10px;
}
body #nb_secret span{ font-size:26px; line-height:1.7; color:#3a2416; }
body #nb_empty{
    height:100%; display:flex; align-items:center; justify-content:center;
    font-size:28px; color:#8a7350; letter-spacing:0.1em;
}

/* 「まだ下に続きがある」ことを知らせる目印 */
body .nb_more{
    flex:none; display:none; text-align:center; padding-top:8px;
    font-size:20px; letter-spacing:0.14em; color:#8a7350;
}
body .nb_more.on{ display:block; }

/* 提示モードの決定ボタン */
body #nb_submit_wrap{ display:none; margin-top:22px; padding-top:20px; border-top:2px solid #b8a173; }
body #nb_submit{
    display:block; width:100%; padding:20px 0; box-sizing:border-box;
    background:linear-gradient(180deg,#4b3d33,#33271e); border:1px solid #a57c34; border-radius:6px;
    font-family:inherit; font-size:32px; font-weight:bold; letter-spacing:0.14em;
    color:#f2d882; cursor:pointer;
}
body #nb_submit:hover{ background:linear-gradient(180deg,#5d4c3f,#3f3025); }

/* ログボタン（提示モードのみ。突きつける前に会話を読み返せるように） */
/* 手帳の表紙は right:120px までなので、閉じるボタンと同じ位置に収める */
body #nb_log_btn{
    display:none; position:absolute; right:128px; top:56px;
    padding:14px 34px; box-sizing:border-box;
    background:linear-gradient(180deg,#4b3d33,#33271e); border:1px solid #a57c34; border-radius:6px;
    font-family:inherit; font-size:28px; letter-spacing:0.16em; color:#f2d882; cursor:pointer;
}
body #nb_log_btn:hover{ background:linear-gradient(180deg,#5d4c3f,#3f3025); }

/* ログの紙面 */
body #nb_log{
    display:none; position:absolute; left:140px; top:150px; width:1640px; height:862px;
    background:#e9dcbc; border:1px solid #8a6a38; box-sizing:border-box; z-index:5;
    box-shadow:inset 0 2px 0 rgba(255,255,255,0.5);
}
body #nb_log_head{
    position:absolute; left:0; right:0; top:0; height:86px; box-sizing:border-box;
    display:flex; align-items:center; justify-content:space-between; padding:0 36px;
    border-bottom:2px solid #b8a173; color:#3e2b1d;
    font-size:32px; letter-spacing:0.16em;
}
body #nb_log_close{
    padding:10px 28px; background:linear-gradient(180deg,#4b3d33,#33271e);
    border:1px solid #a57c34; border-radius:6px; color:#f2d882;
    font-size:24px; letter-spacing:0.14em; cursor:pointer;
}
body #nb_log_body{
    position:absolute; left:0; right:0; top:86px; bottom:0; overflow-y:auto;
    padding:26px 40px; box-sizing:border-box; color:#3e2b1d;
    font-size:28px; line-height:1.9; letter-spacing:0.04em;
}
body #nb_log_body p{ margin:0 0 18px 0; }
</style>

<div id="nb_root">
    <div id="nb_cover"></div>

    <div id="nb_title"><i></i><span id="nb_title_text">捜査手帳</span></div>
    <div id="nb_lead"></div>

    <div id="nb_tabs">
        <div class="nb_tab" id="nb_tab_item" data-type="item">アイテム</div>
        <div class="nb_tab" id="nb_tab_chara" data-type="chara">人物</div>
    </div>

    <img id="nb_close" src="./data/image/append_theme/gallery_close.png">
    <div id="nb_log_btn">ログ</div>

    <div id="nb_log">
        <div id="nb_log_head"><span>これまでの会話</span><span id="nb_log_close">閉じる</span></div>
        <div id="nb_log_body"></div>
    </div>

    <div id="nb_pages">
        <div id="nb_left">
            <div id="nb_left_head">
                <span id="nb_left_title">証拠品</span>
                <span id="nb_count"></span>
            </div>
            <div id="nb_list"></div>
            <div class="nb_more" id="nb_list_more">▼</div>
        </div>

        <div id="nb_bind"><span></span><span></span><span></span><span></span><span></span><span></span><span></span></div>

        <div id="nb_right">
            <div id="nb_detail" style="display:none">
                <div id="nb_photo_col">
                    <div id="nb_photo_frame"><img id="nb_photo" src=""></div>
                    <div id="nb_kind"></div>
                </div>
                <div id="nb_text_col">
                    <div id="nb_dt_ruby"></div>
                    <div id="nb_dt_name"></div>
                    <div id="nb_dt_scroll">
                        <div id="nb_dt_text"></div>
                        <div id="nb_secret"><b>【追加情報】</b><span id="nb_secret_text"></span></div>
                    </div>
                    <div class="nb_more" id="nb_dt_more">▼</div>
                    <div id="nb_submit_wrap"><button id="nb_submit" type="button">これを突きつける</button></div>
                </div>
            </div>
            <div id="nb_empty">左の一覧から選んでください</div>
        </div>
    </div>
</div>
[endhtml]

;-----------------------------------------------------------
; JavaScript
;-----------------------------------------------------------
[iscript]

    // 見出し用フォント。@font-face は行頭に書くとタグとして解釈されてしまうので、
    // ここから <style> を差し込む（.ks の行頭の # @ * は本文記法として扱われるため）
    if(!document.getElementById("nb_font_css")){
        var nbFont = document.createElement("style");
        nbFont.id = "nb_font_css";
        nbFont.textContent = "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}";
        document.head.appendChild(nbFont);
    }

    // 画面用の状態と関数は window にまとめる（f に入れるとセーブデータに残るため）
    var NB = window.NB = {
        // 提示モードかどうか
        select: (tf.nb_mode === "select"),
        // 図鑑モードかどうか（周回をまたいだ記録を見る）
        gallery: (tf.nb_mode === "gallery"),
        // 前回開いていたタブを復元
        tab:    tf.current_tab_memory || "item",
        // 右ページに出している ID
        cur:    ""
    };

    var NB_BLANK = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7";

    // 図鑑モードでは f.status ではなく、周回をまたいだ記録を見る
    NB.lv = function(id){
        if(NB.gallery){ return (window.SEEN ? window.SEEN.level(id) : 0); }
        var st = (f.status || {})[id];
        if(!st){ return 0; }
        return st.secret ? 2 : (st.owned ? 1 : 0);
    };

    NB.imgSrc = function(item){
        var folder = (item.type == "chara") ? "fgimage/chara/" : "image/item/";
        return "./data/" + folder + item.image;
    };

    NB.esc = function(t){
        return String(t == null ? "" : t)
            .replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
    };

    // --- 見出し・閉じるボタンの出し分け ---
    if(window.SEEN && !NB.gallery){ window.SEEN.sync(); }
    $("#nb_title_text").text(NB.select ? "証拠品の提示" : (NB.gallery ? "図鑑" : "捜査手帳"));

    // 解決編の提示モードでは、あと何回まで言い直せるかを添える。
    // f.s8_phase は scene8 の間だけ 1（scene4 / scene7 の資料モードには出さない）。
    NB.shinsho = function(){
        var f = tyrano.plugin.kag.variable.f;
        if(!f || f.s8_phase !== 1){ return ""; }
        var left = (typeof f.s8_miss_left === "number") ? f.s8_miss_left : 0;
        var max  = (typeof f.s8_miss_max  === "number") ? f.s8_miss_max  : 0;
        if(max <= 0){ return ""; }
        var mark = "";
        for(var i = 0; i < max; i++){ mark += (i < left) ? "●" : "○"; }
        return "　／　警部の心証 " + mark;
    };

    $("#nb_lead").text(NB.select ? ("突きつけるものを選んでください" + NB.shinsho())
                      : (NB.gallery ? "これまでに手にしたものと、出会った人たち" : ""));
    $("#nb_close").css("display", NB.select ? "none" : "block");
    // 提示モードは本編に割り込むので、突きつける前に会話を読み返せるようにする
    $("#nb_log_btn").css("display", NB.select ? "block" : "none");

    // --- 一覧描画（未入手は空欄の枠として並べる） ---
    NB.updateList = function(){
        var master = f.master_data || [];
        // route を持つ証拠品は、その周回の経路のものだけを並べる
        // （経路Aの周回に経路B専用の空欄が並ばないようにする）
        // 図鑑では両方の経路のものを並べる
        var route = f.route_b ? "b" : "a";
        var list = [];
        for(var i=0;i<master.length;i++){
            if(master[i].type != NB.tab) continue;
            if(!NB.gallery && master[i].route && master[i].route !== route) continue;
            list.push(master[i]);
        }

        var owned_count = 0;
        var html = "";
        for(var j=0;j<list.length;j++){
            var it = list[j];
            var owned = NB.lv(it.id) > 0;
            if(owned) owned_count++;

            html += '<div class="nb_row' + (owned ? '' : ' empty') + '" data-id="' + it.id + '">'
                 +    '<img class="nb_thumb" src="' + (owned ? NB.imgSrc(it) : NB_BLANK) + '"'
                 +      ' onerror="this.src=\'' + NB_BLANK + '\'">'
                 +    '<div class="nb_texts">'
                 +      '<div class="nb_ruby">' + (owned ? NB.esc(it.ruby) : "") + '</div>'
                 +      '<div class="nb_name">' + (owned ? NB.esc(it.name) : "未発見") + '</div>'
                 +    '</div>'
                 +  '</div>';
        }
        if(list.length === 0) html = '<div style="padding:40px;text-align:center;color:#8a7350;font-size:26px">情報がありません</div>';

        $("#nb_list").html(html);
        $("#nb_left_title").text(NB.tab == "item" ? "証拠品" : "関係者");
        $("#nb_count").text(owned_count + " / " + list.length);

        // 取りこぼしの受け皿。scene 側は [get_item] の後で owned を立てることが
        // あり、入手時のフックだけだと最後の1個を拾えない。手帳を開けば必ず通る。
        if(window.ACH){ window.ACH.checkAllItems(); }

        // 最初の入手済みを選択
        var first = null;
        for(var k=0;k<list.length;k++){
            if(NB.lv(list[k].id) > 0){ first = list[k].id; break; }
        }
        NB.showDetail(first);

        $("#nb_list").scrollTop(0);
        NB.updateMore("nb_list", "nb_list_more");
    };

    // --- 詳細描画（同じ画面の右ページ） ---
    NB.showDetail = function(id){
        NB.cur = id || "";

        if(!id){
            $("#nb_detail").hide();
            $("#nb_empty").text(NB.select ? "提示できるものがありません" : "左の一覧から選んでください").show();
            $(".nb_row").removeClass("active");
            $("#nb_dt_more").attr("class", "nb_more");
            return;
        }
        var item = null;
        for(var i=0;i<f.master_data.length;i++){
            if(f.master_data[i].id === id){ item = f.master_data[i]; break; }
        }
        if(!item) return;
        var lv = NB.lv(id);

        $(".nb_row").removeClass("active");
        $('.nb_row[data-id="' + id + '"]').addClass("active");

        $("#nb_empty").hide();
        $("#nb_detail").css("display","flex");

        // 画像ファイルが無いときは、割れた画像アイコンを出さずに空欄にする
        $("#nb_photo").off("error").on("error", function(){ this.src = NB_BLANK; });
        $("#nb_photo").attr("src", NB.imgSrc(item));
        $("#nb_kind").text(item.type == "chara" ? "関係者" : "証拠品");
        $("#nb_dt_ruby").text(item.ruby || "");
        $("#nb_dt_name").text(item.name);
        $("#nb_dt_text").html(NB.esc(item.text_default).replace(/\r\n|\n/g,"<br>"));

        if(lv >= 2 && item.text_secret){
            $("#nb_secret_text").html(NB.esc(item.text_secret).replace(/\r\n|\n/g,"<br>"));
            $("#nb_secret").css("display","block");
        }else{
            $("#nb_secret").hide();
        }

        $("#nb_submit_wrap").css("display", NB.select ? "block" : "none");
        $("#nb_kind").text(NB.gallery
            ? (item.type == "chara" ? "関係者" : "証拠品")
            : (item.type == "chara" ? "関係者" : "証拠品"));
        $("#nb_dt_scroll").scrollTop(0);
        NB.updateMore("nb_dt_scroll", "nb_dt_more");
    };

    // --- スワイプスクロール（スマホ対応） ---
    // index.html の body に ontouchmove="event.preventDefault()" があるため、
    // タッチ操作では普通のスクロールが効かない。指の動きから自前でスクロールさせる。
    NB.bindSwipe = function(id, moreId){
        var el = document.getElementById(id);
        if(!el || el._nb_swipe) return;
        el._nb_swipe = true;

        var startY = 0, startTop = 0, scale = 1, dragging = false;
        var THRESHOLD = 8;

        el.addEventListener("touchstart", function(e){
            if(!e.touches || e.touches.length !== 1) return;
            startY   = e.touches[0].clientY;
            startTop = el.scrollTop;
            // 画面は 1920x1080 を拡大縮小して表示しているので、指の移動量を実寸に直す
            var r = el.getBoundingClientRect();
            scale = (el.offsetHeight > 0 && r.height > 0) ? (r.height / el.offsetHeight) : 1;
            dragging = true; el._swiped = false;
        }, { passive:true });

        el.addEventListener("touchmove", function(e){
            if(!dragging) return;
            var d = startY - e.touches[0].clientY;
            if(Math.abs(d) > THRESHOLD){
                el._swiped = true;
                el.scrollTop = startTop + d / scale;
                NB.updateMore(id, moreId);
                if(e.cancelable) e.preventDefault();
            }
        }, { passive:false });

        el.addEventListener("touchend",    function(){ dragging = false; }, { passive:true });
        el.addEventListener("touchcancel", function(){ dragging = false; el._swiped = false; }, { passive:true });

        // マウスホイールや PC でのスクロールでも目印を更新する
        el.addEventListener("scroll", function(){ NB.updateMore(id, moreId); }, { passive:true });
    };

    // --- 「▼ まだ下に続きがある」目印の出し分け ---
    NB.updateMore = function(id, moreId){
        var el = document.getElementById(id);
        var mk = document.getElementById(moreId);
        if(!el || !mk) return;
        var rest = el.scrollHeight - el.clientHeight - el.scrollTop;
        if(rest > 8){ mk.className = "nb_more on"; }
        else        { mk.className = "nb_more"; }
    };

    // --- イベント ---
    $(".nb_tab").removeClass("active");
    $(NB.tab == "item" ? "#nb_tab_item" : "#nb_tab_chara").addClass("active");

    $(".nb_tab").off("click").on("click", function(){
        NB.tab = $(this).data("type");
        tf.current_tab_memory = NB.tab;
        $(".nb_tab").removeClass("active");
        $(this).addClass("active");
        NB.updateList();
    });

    $("#nb_list").off("click", ".nb_row").on("click", ".nb_row", function(){
        var el = document.getElementById("nb_list");
        if(el && el._swiped){ el._swiped = false; return; }      // スワイプ直後は無視
        if($(this).hasClass("empty")) return;                     // 未入手は選べない
        NB.showDetail($(this).data("id"));
    });

    // ログ（提示モード）。手帳より前面に出すので、本文はここで組み立てる
    NB.openLog = function(){
        var sys = tyrano.plugin.kag.variable.tf.system || {};
        var log = sys.backlog || [];
        var h = "";
        for(var i = 0; i < log.length; i++){
            h += "<p>" + log[i] + "</p>";
        }
        if(h === ""){ h = "<p>まだ記録はありません。</p>"; }
        $("#nb_log_body").html(h);
        $("#nb_log").css("display", "block");
        $("#nb_log_body").scrollTop(99999999);
    };
    $("#nb_log_btn").off("click").on("click", function(){ NB.openLog(); });
    $("#nb_log_close").off("click").on("click", function(){ $("#nb_log").css("display","none"); });

    // クリックの中でそのまま飛ぶと、押したクリックが飛んだ先の本文まで届き、
    // 一文目が読まれずに送られてしまう。伝播が終わってから飛ぶ。
    NB.jump = function(target){
        var sh = document.createElement("div");
        sh.style.cssText = "position:absolute;inset:0;z-index:999999999;background:transparent";
        sh.addEventListener("click", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
        sh.addEventListener("pointerdown", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
        (document.getElementById("tyrano_base") || document.body).appendChild(sh);
        setTimeout(function(){ if(sh.parentNode){ sh.parentNode.removeChild(sh); } }, 260);
        setTimeout(function(){
            tyrano.plugin.kag.ftag.startTag("jump", { target: target });
        }, 0);
    };

    // 閉じる（資料モード）
    $("#nb_close").off("click").on("click", function(){
        NB.jump("*close_menu");
    });

    // 突きつける（提示モード）
    $("#nb_submit").off("click").on("click", function(){
        if(!NB.select || !NB.cur) return;
        tyrano.plugin.kag.variable.tf.selected_id = NB.cur;
        NB.jump("*select_done");
    });

    // スワイプスクロールを有効にする（一覧・紹介文の両方）
    NB.bindSwipe("nb_list",      "nb_list_more");
    NB.bindSwipe("nb_dt_scroll", "nb_dt_more");

    NB.updateList();

    // フォントや画像の読み込みで高さが変わることがあるので、少し後にも目印を見直す
    setTimeout(function(){
        NB.updateMore("nb_list",      "nb_list_more");
        NB.updateMore("nb_dt_scroll", "nb_dt_more");
    }, 300);

[endscript]

[s]

;-----------------------------------------------------------
; 閉じる（資料モード）
;-----------------------------------------------------------
*close_menu
[cm]
[clearfix name="nb_html"]
[if exp="tf.nb_mode == 'gallery'"]
    [freeimage layer=1]
    [layopt layer=message0 visible=true]
    [layopt layer=fix visible=true]
    [jump storage="system/gallery.ks" target="*gallery_menu"]
[endif]
; 調査パートから開いた場合は、[awakegame] ではなく元の調査画面へ戻る
[if exp="f.inv_nb_return != null && f.inv_nb_return != ''"]
[freeimage layer=1]
[layopt layer=message0 visible=false]
[layopt layer=fix visible=true]
[hidemenubutton]
[eval exp="tf.inv_nb_target = f.inv_nb_return"]
[eval exp="f.inv_nb_return = ''"]
[jump storage="&f.INV_DATA[f.inv_chapter].storage" target="&tf.inv_nb_target"]
[endif]

[freeimage layer=1]
[layopt layer=message0 visible=true]
[layopt layer=fix visible=true]
[showmenubutton]
[awakegame]

;-----------------------------------------------------------
; 選択完了（提示モード）
;   tf.selected_id に選んだ ID を入れて呼び出し元へ戻る
;-----------------------------------------------------------
*select_done
[cm]
[clearfix name="nb_html"]
[layopt layer=message0 visible=true]
[layopt layer=fix visible=true]
[showmenubutton]
[return]
