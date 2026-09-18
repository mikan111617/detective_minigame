;==== debug.ks ====
; ★ デバッグ専用：シーン／状態ジャンパー
; 起動方法：タイトル画面の右下隅（見えない）を 5回すばやくタップ
;
; 2026-08-25 更新
; ・scene4 地下書斎を追加
; ・scene7 セージ推理 → 濡れた瓶 → 薬学研究本 → 本丸地下入口の状態を追加
; ・scene8 の最新TRUE条件に対応
; ・scene8 の推理に必要な捜査済みフラグをルート別に自動セット
; ・証拠品全所持とシナリオフラグのセットを分離
; ・route A / B を維持したまま各テストへ移動可能

;-----------------------------------------------------------
*debug_start
;-----------------------------------------------------------
[cm]
[clearfix]
[freeimage layer=0]
[freeimage layer=1]
[chara_hide_all]
[hidemenubutton]
[layopt layer=message0 visible=false]
[stopbgm]

;-----------------------------------------------------------
; デバッグパネル HTML
; ★ CSSセレクターは #id ではなく .class を使う
;-----------------------------------------------------------
[html name="debug_panel_html"]
<style>
    .dbg_overlay {
        position: absolute;
        top: 0; left: 0;
        width: 1920px; height: 1080px;
        background: rgba(0, 0, 0, 0.95);
        font-family: "Courier New", "Lucida Console", monospace;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: flex-start;
        padding: 34px 40px 70px;
        box-sizing: border-box;
        pointer-events: auto;
        z-index: 9999;
        user-select: none;
        overflow-y: auto;
        overflow-x: hidden;
    }

    .dbg_header {
        font-size: 38px;
        font-weight: bold;
        color: #00ff88;
        letter-spacing: 6px;
        text-shadow: 0 0 16px #00ff88;
        margin-bottom: 8px;
    }
    .dbg_subtitle {
        font-size: 18px;
        color: #557766;
        letter-spacing: 3px;
        margin-bottom: 8px;
    }
    .dbg_warn {
        font-size: 14px;
        color: #ff7755;
        letter-spacing: 1px;
        margin-bottom: 28px;
    }

    .dbg_sect {
        margin-top: 28px;
        margin-bottom: 10px;
        font-size: 16px;
        color: #b28a55;
        letter-spacing: 5px;
    }

    .dbg_grid {
        display: grid;
        grid-template-columns: repeat(2, 840px);
        gap: 12px;
        width: 1700px;
    }

    .dbg_scene_btn {
        background: rgba(0, 255, 136, 0.06);
        border: 1px solid #00aa55;
        color: #00ff88;
        font-family: "Courier New", monospace;
        font-size: 21px;
        padding: 15px 25px;
        text-align: left;
        cursor: pointer;
        transition: all 0.15s;
        border-radius: 3px;
    }
    .dbg_scene_btn:hover {
        background: rgba(0, 255, 136, 0.18);
        border-color: #00ff88;
        color: #ffffff;
        box-shadow: 0 0 12px rgba(0, 255, 136, 0.35);
        transform: translateX(4px);
    }

    .dbg_num {
        display: block;
        font-size: 12px;
        color: #007744;
        letter-spacing: 3px;
        margin-bottom: 4px;
    }

    .dbg_note {
        display: block;
        font-size: 12px;
        color: #668878;
        margin-top: 5px;
        letter-spacing: 1px;
    }

    .dbg_test_grid {
        display: grid;
        grid-template-columns: repeat(3, 555px);
        gap: 12px;
        width: 1700px;
    }
    .dbg_test_btn {
        background: rgba(64, 140, 255, 0.08);
        border: 1px solid #4777bb;
        color: #a9caff;
        font-family: "Courier New", monospace;
        font-size: 17px;
        padding: 14px 18px;
        text-align: left;
        cursor: pointer;
        border-radius: 3px;
        transition: all 0.15s;
    }
    .dbg_test_btn:hover {
        background: rgba(64, 140, 255, 0.20);
        border-color: #8db7ff;
        color: #ffffff;
        box-shadow: 0 0 12px rgba(80, 140, 255, 0.30);
    }
    .dbg_test_btn .dbg_num { color: #5978a8; }

    .dbg_route_grid {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 14px;
        width: 1700px;
    }
    .dbg_route_btn {
        background: rgba(60, 120, 255, 0.08);
        border: 1px solid #3a6ecf;
        color: #9dc0ff;
        font-family: "Courier New", monospace;
        font-size: 17px;
        padding: 12px 28px;
        cursor: pointer;
        transition: all 0.15s;
        border-radius: 3px;
        letter-spacing: 1px;
    }
    .dbg_route_btn:hover {
        background: rgba(60, 120, 255, 0.20);
        color: #ffffff;
    }
    .dbg_route_btn.on {
        background: rgba(90, 150, 255, 0.35);
        border-color: #9dc0ff;
        color: #ffffff;
        box-shadow: 0 0 12px rgba(90, 150, 255, 0.45);
    }

    .dbg_state_btn {
        background: rgba(170, 100, 255, 0.08);
        border: 1px solid #8150b7;
        color: #d2b3ff;
        font-family: "Courier New", monospace;
        font-size: 16px;
        padding: 12px 24px;
        cursor: pointer;
        border-radius: 3px;
    }
    .dbg_state_btn:hover {
        background: rgba(170, 100, 255, 0.20);
        color: #ffffff;
    }

    .dbg_route_note {
        font-size: 13px;
        color: #7488ad;
        letter-spacing: 1px;
        margin-bottom: 10px;
        text-align: center;
    }

    .dbg_status {
        min-width: 300px;
        color: #d4c2ff;
        font-size: 14px;
        align-self: center;
    }

    .dbg_end_grid {
        display: grid;
        grid-template-columns: repeat(3, 555px);
        gap: 12px;
        width: 1700px;
    }
    .dbg_end_btn {
        background: rgba(255, 170, 60, 0.06);
        border: 1px solid #aa7722;
        color: #ffbb55;
        font-family: "Courier New", monospace;
        font-size: 20px;
        padding: 15px 22px;
        text-align: left;
        cursor: pointer;
        transition: all 0.15s;
        border-radius: 3px;
    }
    .dbg_end_btn:hover {
        background: rgba(255, 170, 60, 0.18);
        border-color: #ffbb55;
        color: #ffffff;
        box-shadow: 0 0 12px rgba(255, 170, 60, 0.35);
    }
    .dbg_end_btn .dbg_num { color: #7a5410; }
    .dbg_end_note {
        display: block;
        font-size: 12px;
        color: #8a693a;
        letter-spacing: 1px;
        margin-top: 5px;
    }

    .dbg_close_btn {
        margin-top: 34px;
        background: transparent;
        border: 1px solid #ff4466;
        color: #ff4466;
        font-family: "Courier New", monospace;
        font-size: 20px;
        padding: 12px 70px;
        cursor: pointer;
        transition: all 0.15s;
        border-radius: 3px;
        letter-spacing: 2px;
    }
    .dbg_close_btn:hover {
        background: rgba(255, 68, 102, 0.18);
        box-shadow: 0 0 10px rgba(255, 68, 102, 0.4);
    }
</style>

<div class="dbg_overlay">
    <div class="dbg_header">🔧 DEBUG PANEL</div>
    <div class="dbg_subtitle">― 舞黒館の惨劇 ― 2026-08-25</div>
    <div class="dbg_warn">⚠ シーン直行は通常プレイの前提フラグを省略します。細部確認には下の CHECKPOINT を使用してください。</div>

    <div class="dbg_grid">
        <button class="dbg_scene_btn" onclick="dbgJump('scene1.ks','*prologue')">
            <span class="dbg_num">SCENE 01</span>
            プロローグ ― 舞黒館へ
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('scene2.ks','*start')">
            <span class="dbg_num">SCENE 02</span>
            庭園・ルート分岐
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('scene3.ks','*start')">
            <span class="dbg_num">SCENE 03</span>
            お茶会までの自由行動
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('scene4.ks','*start')">
            <span class="dbg_num">SCENE 04</span>
            父の足取り・館内探索・地下書斎
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('scene5.ks','*start')">
            <span class="dbg_num">SCENE 05</span>
            事件発生・事情聴取
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('scene6.ks','*start')">
            <span class="dbg_num">SCENE 06</span>
            叡留久の死・愛理の危機
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('scene7.ks','*start')">
            <span class="dbg_num">SCENE 07</span>
            毒物捜査・第二の地下入口
        </button>
        <button class="dbg_scene_btn" onclick="dbgJump('system/debug.ks','*dbg_scene8')">
            <span class="dbg_num">SCENE 08</span>
            解決編 ― 珠璃の尋問
            <span class="dbg_note">全証拠品＋選択中ルートの捜査済みフラグをセット</span>
        </button>
    </div>

    <div class="dbg_sect">― CHECKPOINT ―</div>
    <div class="dbg_test_grid">
        <button class="dbg_test_btn" onclick="dbgJump('system/debug.ks','*dbg_s4_hidden_study')">
            <span class="dbg_num">SCENE 04</span>
            地下書斎へ直行
            <span class="dbg_note">父の来館・資料調査済みとして手記と推理を確認</span>
        </button>

        <button class="dbg_test_btn" onclick="dbgJump('system/debug.ks','*dbg_s7_sage_intro')">
            <span class="dbg_num">SCENE 07</span>
            和人 ― セージ仮説を相談
            <span class="dbg_note">濡れた瓶は未発見。次の容器探索への導線確認用</span>
        </button>

        <button class="dbg_test_btn" onclick="dbgJump('system/debug.ks','*dbg_s7_bottle_retry')">
            <span class="dbg_num">SCENE 07</span>
            和人 ― 濡れた瓶を持って再相談
            <span class="dbg_note">「不自然な液体・容器について」が未完了状態から開始</span>
        </button>

        <button class="dbg_test_btn" onclick="dbgJump('system/debug.ks','*dbg_s7_plant_locked')">
            <span class="dbg_num">SCENE 07</span>
            観葉植物 ― 本取得前
            <span class="dbg_note">薬学研究の本が無いので鉢が調査対象に出ないことを確認</span>
        </button>

        <button class="dbg_test_btn" onclick="dbgJump('system/debug.ks','*dbg_s7_plant_unlocked')">
            <span class="dbg_num">SCENE 07</span>
            観葉植物 ― 本取得後
            <span class="dbg_note">薬学研究の本を所持し、鉢の調査が解放された状態</span>
        </button>

        <button class="dbg_test_btn" onclick="dbgJump('system/debug.ks','*dbg_s7_second_basement')">
            <span class="dbg_num">SCENE 07</span>
            サンルーム ― 第二の地下入口
            <span class="dbg_note">現在選択中の ROUTE に合わせて発見直前の状態を再現</span>
        </button>
    </div>

    <div class="dbg_sect">― ROUTE ―</div>
    <div class="dbg_route_note">scene2 で決まる分岐。scene3以降やCHECKPOINTへ進む前に選択してください。</div>
    <div class="dbg_route_grid">
        <button id="dbg_route_a" class="dbg_route_btn" onclick="dbgRoute(0)">
            ROUTE A ／ サンルーム経路
        </button>
        <button id="dbg_route_b" class="dbg_route_btn" onclick="dbgRoute(1)">
            ROUTE B ／ 和人先行経路
        </button>
    </div>

    <div class="dbg_sect">― STATE ―</div>
    <div class="dbg_route_note">証拠品とTRUE条件を分離しました。意図しないTRUE分岐を防げます。</div>
    <div class="dbg_route_grid">
        <button class="dbg_state_btn" onclick="dbgGrantItems()">
            証拠品・人物カードを全所持
        </button>
        <button class="dbg_state_btn" onclick="dbgTrueState(1)">
            TRUE条件 5つをON
        </button>
        <button class="dbg_state_btn" onclick="dbgTrueState(0)">
            TRUE条件をOFF
        </button>
        <span id="dbg_state_msg" class="dbg_status"></span>
    </div>

    <div class="dbg_sect">― ENDING ―</div>
    <div class="dbg_end_grid">
        <button class="dbg_end_btn" onclick="dbgJump('system/debug.ks','*dbg_bad_end')">
            <span class="dbg_num">ENDING A</span>
            バッドエンド
            <span class="dbg_end_note">全てが灰になる</span>
        </button>
        <button class="dbg_end_btn" onclick="dbgJump('system/debug.ks','*dbg_normal_end')">
            <span class="dbg_num">ENDING B</span>
            ノーマルエンド
            <span class="dbg_end_note">霧の中の明日</span>
        </button>
        <button class="dbg_end_btn" onclick="dbgJump('system/debug.ks','*dbg_true_end')">
            <span class="dbg_num">ENDING C</span>
            トゥルーエンド
            <span class="dbg_end_note">TRUE条件・地下書斎履歴・全証拠を自動セット</span>
        </button>
    </div>

    <button class="dbg_close_btn" onclick="dbgClose()">✕ タイトルへ戻る</button>
</div>
[endhtml]

[iscript]
(function(){
    var kag = tyrano.plugin.kag;

    window.dbgJump = function(storage, target) {
        kag.ftag.startTag("clearfix", {name:"debug_panel_html"});
        var params = {storage:storage};
        if(target){ params.target = target; }
        kag.ftag.startTag("jump", params);
    };

    window.dbgRoute = function(v) {
        var f = kag.stat.f;
        f.route_b = v;
        if(v === 1){
            f.talked_kazuto = 1;
            f.talked_couple = 1;
        }
        window.dbgRoutePaint();
        window.dbgStateMessage(v === 1 ? "ROUTE B に設定" : "ROUTE A に設定");
    };

    window.dbgRoutePaint = function() {
        var f = kag.stat.f;
        var a = document.getElementById("dbg_route_a");
        var b = document.getElementById("dbg_route_b");
        if(!a || !b){ return; }
        a.className = "dbg_route_btn" + (f.route_b == 1 ? "" : " on");
        b.className = "dbg_route_btn" + (f.route_b == 1 ? " on" : "");
    };

    window.dbgStateMessage = function(text) {
        var msg = document.getElementById("dbg_state_msg");
        if(msg){ msg.textContent = text; }
    };

    // アイテムのみ。シナリオフラグは勝手に変更しない。
    window.dbgGrantItems = function() {
        var f = kag.stat.f;
        if(!f.master_data || !f.status){
            kag.ftag.startTag("call", {storage:"system/init_item_data.ks"});
        }
        setTimeout(function(){
            var f2 = tyrano.plugin.kag.stat.f;
            var list = f2.master_data || [];
            for(var i=0; i<list.length; i++){
                var id = list[i].id;
                if(f2.status && f2.status[id]){
                    f2.status[id].owned = true;
                }
            }
            window.dbgStateMessage("証拠品・人物カード：全所持");
        }, 80);
    };

    // scene8 の TRUE 分岐条件は現在この5つ。
    window.dbgTrueState = function(on) {
        var f = kag.stat.f;
        var v = on ? 1 : 0;
        f.true_flag_mary       = v;
        f.s7_king_yuzuki_record = v;
        f.base_ment_found      = v;
        f.has_blueprint        = v;
        f.has_old_key          = v;
        window.dbgStateMessage(on ? "TRUE条件：5/5 ON" : "TRUE条件：OFF");
    };

    window.dbgClose = function() {
        kag.ftag.startTag("clearfix", {name:"debug_panel_html"});
        kag.ftag.startTag("jump", {storage:"title.ks"});
    };

    window.dbgRoutePaint();
})();
[endscript]

[s]


;===============================================================================
; 共通デバッグセットアップ
;===============================================================================

*dbg_visible_setup
[cm]
[clearfix]
[freeimage layer=0]
[freeimage layer=1]
[chara_hide_all]
[stopbgm]
[show_menu]
[position layer="message0" page=fore visible=true]
[current layer="message0"]
[return]


;===============================================================================
; scene4 CHECKPOINT
;===============================================================================

;--- 地下書斎 ---
*dbg_s4_hidden_study
[call target="*dbg_visible_setup"]
[call storage="system/init_item_data.ks"]
[iscript]
if(typeof f.route_b !== "number"){ f.route_b = 0; }

f.father_visit_found = 1;
f.father_research_found = 1;
f.event_genkan = 1;
f.event_arc_access = 1;
f.has_entrance_record = 1;

f.lounge_hidden_hint = 1;
f.hidden_study_entrance_found = 1;
f.hidden_study_entered = 0;
f.hidden_study_recent_trace = 0;
f.hidden_study_father_infer = 0;
f.hidden_study_secret = 0;
f.event_lounge_hidden_search = 1;

f.true_flag_mary = (typeof f.true_flag_mary === "number") ? f.true_flag_mary : 0;
[endscript]
[jump storage="scene4.ks" target="*hidden_study_enter"]


;===============================================================================
; scene7 CHECKPOINT 共通
; scene7 の *investigation_start を通ると s7_ フラグが全初期化されるため、
; CHECKPOINT は必要な状態だけをここで明示的に作り、該当イベントへ直行する。
;===============================================================================

*dbg_s7_common
[call target="*dbg_visible_setup"]
[call storage="system/init_item_data.ks"]
[iscript]
if(typeof f.route_b !== "number"){ f.route_b = 0; }
if(typeof f.hidden_study_entered !== "number"){ f.hidden_study_entered = 1; }
if(typeof f.base_ment_found !== "number"){ f.base_ment_found = 0; }

f.s6_trust_rank = 1;
f.game_time = 1260; // 21:00

// UI参照で未定義になりやすい主要値だけ初期化
var zeroFlags = [
    "s7_reido_1","s7_reido_2","s7_reido_3","s7_reido_4",
    "s7_jushika_1","s7_jushika_2","s7_jushika_3",
    "s7_juri_1","s7_juri_2","s7_juri_3",
    "s7_mary_1","s7_mary_2","s7_mary_3",
    "s7_kazuto_1","s7_kazuto_2","s7_kazuto_3","s7_kazuto_3_intro","s7_kazuto_4",
    "s7_airi_1","s7_airi_2",
    "s7_sun1_floor","s7_sun1_floor2","s7_sun1_plant",
    "s7_wet_bottle","s7_sage_request","s7_sage_done","s7_drag_book",
    "s7_sage_hypothesis","s7_sage_hint","s7_sage_match",
    "s7_pf1","s7_pf2","s7_pf3","s7_pf4","s7_pf5",
    "s7_fingerprint","s7_event_20","s7_event_40",
    "s7_map_dest"
];
for(var i=0;i<zeroFlags.length;i++){
    if(typeof f[zeroFlags[i]] === "undefined"){ f[zeroFlags[i]] = 0; }
}
f.s7_active_floor = 2;
[endscript]
[return]


;--- セージ仮説を和人に最初に相談 ---
*dbg_s7_sage_intro
[call target="*dbg_s7_common"]
[iscript]
f.s7_pf1 = 1;
f.s7_pf2 = 1;
f.s7_pf3 = 1;
f.s7_sage_hint = 1;
f.s7_sage_hypothesis = 1;
f.s7_kazuto_3_intro = 0;
f.s7_kazuto_3 = 0;
f.s7_wet_bottle = 0;
f.s7_sage_request = 0;
f.s7_drag_book = 0;
[endscript]
[jump storage="scene7.ks" target="*s7_kazuto_t3_intro"]


;--- 濡れた瓶を見つけた後、和人に再相談 ---
*dbg_s7_bottle_retry
[call target="*dbg_s7_common"]
[iscript]
f.s7_pf1 = 1;
f.s7_pf2 = 1;
f.s7_pf3 = 1;
f.s7_sage_hint = 1;
f.s7_sage_hypothesis = 1;
f.s7_kazuto_3_intro = 1;
f.s7_kazuto_3 = 0;
f.s7_wet_bottle = 1;
f.s7_bd_juri = 1;
f.s7_sage_request = 0;
if(f.status && f.status["bottle"]){ f.status["bottle"].owned = true; }
[endscript]
[jump storage="scene7.ks" target="*s7_kazuto_t3"]


;--- 本取得前：鉢がUIに出ないことを確認 ---
*dbg_s7_plant_locked
[call target="*dbg_s7_common"]
[iscript]
f.s7_kazuto_3_intro = 1;
f.s7_kazuto_3 = 1;
f.s7_sage_request = 1;
f.s7_sage_done = 0;
f.s7_drag_book = 0;
f.s7_sun1_plant = 0;
f.s7_active_floor = 1;
tf.inv_enter = 0;
[endscript]
[jump storage="scene7.ks" target="*s7_sunroom1"]


;--- 本取得後：鉢がUIに出ることを確認 ---
*dbg_s7_plant_unlocked
[call target="*dbg_s7_common"]
[iscript]
f.s7_kazuto_3_intro = 1;
f.s7_kazuto_3 = 1;
f.s7_sage_request = 1;
f.s7_sage_done = 1;
f.s7_kazuto_4 = 1;
f.s7_drag_book = 1;
f.s7_sun1_plant = 0;
f.s7_active_floor = 1;
if(f.status && f.status["drag_book"]){ f.status["drag_book"].owned = true; }
tf.inv_enter = 0;
[endscript]
[jump storage="scene7.ks" target="*s7_sunroom1"]


;--- 第二の地下入口発見直前 ---
*dbg_s7_second_basement
[call target="*dbg_s7_common"]
[iscript]
f.hidden_study_entered = 1;
f.base_ment_found = 0;
f.s7_sun1_floor2 = 0;
f.s7_active_floor = 1;

if(f.route_b == 1){
    // ROUTE B：鉢を詳しく調べた後に床板が解放
    f.s7_drag_book = 1;
    f.s7_kazuto_3 = 1;
    f.s7_sun1_plant = 1;
    if(f.status && f.status["drag_book"]){ f.status["drag_book"].owned = true; }
}else{
    // ROUTE A：床の毒の跡を調べた後に床板が解放
    f.s7_sun1_floor = 1;
}
[endscript]
[jump storage="scene7.ks" target="*s7_evt_sun1_floor2"]


;===============================================================================
; scene8
;===============================================================================

*dbg_scene8
[call target="*dbg_visible_setup"]
[call storage="system/init_item_data.ks"]
[iscript]
// ROUTEを選ばずに直行した場合は、画面上の初期表示どおりROUTE Aにする。
if(typeof f.route_b !== "number"){ f.route_b = 0; }

// item_list で何を要求されても選べるよう、全アイテムを所持
for(var i=0; i<(f.master_data || []).length; i++){
    var id = f.master_data[i].id;
    if(f.status && f.status[id]){ f.status[id].owned = true; }
}

// scene8 の推理を最後まで検証できるよう、通常のscene7完了時に
// 判明している捜査結果を補完する。
// TRUE条件はユーザーがSTATE欄でON/OFFした状態を保持する。
f.s7_koderia_secret = 1;
f.s7_koderia_cup_test = 1;

// 叡留久の摂取経路を立証する物証はルートごとに異なる。
// 反対ルートの物証は0にして、誤った経路が混ざらないようにする。
if(f.route_b == 1){
    f.s7_lipstick = 1;
    f.s7_eruku_cup = 0;
}else{
    f.s7_eruku_cup = 1;
    f.s7_lipstick = 0;
}

if(typeof f.true_flag_mary !== "number"){ f.true_flag_mary = 0; }
if(typeof f.s7_king_yuzuki_record !== "number"){ f.s7_king_yuzuki_record = 0; }
if(typeof f.base_ment_found !== "number"){ f.base_ment_found = 0; }
if(typeof f.has_blueprint !== "number"){ f.has_blueprint = 0; }
if(typeof f.has_old_key !== "number"){ f.has_old_key = 0; }
[endscript]
[jump storage="scene8.ks" target="*start"]


;===============================================================================
; エンディング直行
;===============================================================================

*dbg_end_setup
[eval exp="f.badend = 0"]
[eval exp="f.normalend = 0"]
[eval exp="f.trueend = 0"]
[call target="*dbg_visible_setup"]
[return]

;--- バッドエンド ---
*dbg_bad_end
[call target="*dbg_end_setup"]
[jump storage="ending/bad_end.ks" target="*bad_end_start"]

;--- ノーマルエンド ---
*dbg_normal_end
[call target="*dbg_end_setup"]
[jump storage="ending/normal_end.ks" target="*normal_end"]

;--- トゥルーエンド ---
*dbg_true_end
[call target="*dbg_end_setup"]
[call storage="system/init_item_data.ks"]
[iscript]
for(var i=0; i<(f.master_data || []).length; i++){
    var id = f.master_data[i].id;
    if(f.status && f.status[id]){ f.status[id].owned = true; }
}

// 現在の scene8 TRUE条件
f.true_flag_mary = 1;
f.s7_king_yuzuki_record = 1;
f.base_ment_found = 1;
f.has_blueprint = 1;
f.has_old_key = 1;

// TRUE ENDへ至るまでに確認済みである方が自然なscene4履歴
f.father_visit_found = 1;
f.father_research_found = 1;
f.hidden_study_entered = 1;
f.hidden_study_recent_trace = 1;
f.hidden_study_father_infer = 1;
f.hidden_study_secret = 1;

// 解決編側の主要捜査状態
f.s7_koderia_secret = 1;
f.s7_koderia_cup_test = 1;
f.s7_drag_book = 1;
f.s7_sage_done = 1;
f.s7_fingerprint = 1;
[endscript]
[jump storage="ending/true_end.ks" target="*true_end_start"]
