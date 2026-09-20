;===============================================================================
; message_ui.ks  ―― シナリオ画面のUI（デザイン案 1b「額装＋帯」）
;
;   [msg_ui_setup]  … メッセージウィンドウ（下端まで沈む帯）と名前銘板の組みを適用。
;                     first.ks で一度だけ呼びます。
;   [hud_draw]      … 画面上部のプレート（場所／時刻・資料／MENU）と、
;                     右下のシステム操作（AUTO／SKIP／LOG）を描画します。
;
; 仕様（デザイン 1b）：
;   ・メッセージ枠は画像枠をやめ、画面下端まで沈む帯（銅の一本罫＋グラデ）。
;   ・話者名はメッセージ下辺・中央の六角銘板。名前が空のときは自動で消えます。
;   ・場所／時刻は左上、資料／MENU は右上の額装プレート。
;   ・Q.SAVE／Q.LOAD／SCREEN／TITLE は MENU（セーブ・ロード・設定・タイトル）へ。
;
; 実装メモ：
;   ・帯と銘板の体裁は CSS（!important）で当てています。エンジンが要素に直接
;     書き込むインラインスタイル（[position] やセーブデータからの復元）よりも
;     CSS を優先させるためです。
;   ・HUD は fixlayer クラスを持つので [clearfix] で消えます（従来のテーマボタンと同じ）。
;   ・クリックは document への委譲で拾います。[load] や [awakegame] で
;     復元された HUD でも、ハンドラを貼り直さずに反応します。
;===============================================================================

;-------------------------------------------------------------------------------
; SAVE_TIME … セーブ／ロード画面の各欄に、セーブ時のゲーム内時刻を出す
;   テーマの save.html / load.html から呼ぶ。時刻はセーブデータの f.game_time から組む。
;   HUD と同じく、[gage_draw hide_time="true"] の場面（回想など）や、時刻が
;   まだ決まっていない場面では出さない。
;-------------------------------------------------------------------------------
[iscript]
window.SAVE_TIME = {
  label: function(stat){
    var kf = stat && stat.f;
    if(!kf || kf.hud_hide_time === true){ return ""; }
    if(kf.game_time === undefined || kf.game_time === null || kf.game_time === ""){ return ""; }
    var t = Number(kf.game_time);
    if(!isFinite(t)){ return ""; }
    var hm = Math.floor(t / 60) + ":" + ("0" + (t % 60)).slice(-2);
    var head = "現在時刻";
    return head + " " + hm;
  },
  fill: function(wrapper){
    var data = [];
    try { data = TYRANO.kag.menu.getSaveData().data || []; } catch(e){ return; }
    $(wrapper + " .save_list_item").each(function(){
      var d = data[Number($(this).attr("data-num"))];
      var s = (d && d.save_date) ? window.SAVE_TIME.label(d.stat) : "";
      $(this).find(".save_list_item_gametime").text(s);
    });
  }
};
[endscript]

[iscript]
window.MSGUI = {
  GOLD:  "#c8a060",
  LIGHT: "#f2d882",
  TITLE: "'Waosagi',serif",
  BODY:  "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",

  // 操作の種類（クラス名 msgui-role-XXX で委譲する）
  ROLES: ["siryou", "menu", "auto", "skip", "backlog"],

  base: function(){ return document.getElementById("tyrano_base") || document.body; },

  css: function(){
    if(document.getElementById("msgui-css")){ return; }
    var M = window.MSGUI;
    var st = document.createElement("style");
    st.id = "msgui-css";
    st.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}"

      // ── 背景：わずかに沈ませ、四隅を落とす（帯の文字を読ませるため） ──
      + ".base_fore,.base_back{filter:brightness(0.92) saturate(0.96)}"
      + ".base_fore::after,.base_back::after{content:'';position:absolute;left:0;top:0;"
        + "width:100%;height:100%;pointer-events:none;"
        + "background:radial-gradient(120% 80% at 50% 35%,rgba(12,8,4,0) 40%,rgba(12,8,4,0.62) 100%)}"

      // ── メッセージウィンドウ：下端まで沈む帯 ──
      + ".message0_fore .message_outer,.message0_back .message_outer{"
        + "left:0!important;top:790px!important;width:1920px!important;height:300px!important;"
        + "border:0!important;border-radius:0!important;opacity:1!important;"
        + "background-color:transparent!important;background-repeat:no-repeat!important;"
        + "background-size:100% 100%!important;"
        + "background-image:linear-gradient(0deg,rgba(26,15,7,0.9) 0%,rgba(30,18,9,0.74) 48%,"
          + "rgba(34,21,11,0.28) 88%,rgba(34,21,11,0) 100%)!important;"
        + "-webkit-backdrop-filter:blur(2px);backdrop-filter:blur(2px)}"
      // 帯の上辺を締める銅の一本罫
      + ".message0_fore .message_outer::before,.message0_back .message_outer::before{"
        + "content:'';position:absolute;left:0;top:0;width:100%;height:2px;pointer-events:none;"
        + "background:linear-gradient(90deg,rgba(200,160,96,0),rgba(200,160,96,0.9) 18%,"
          + "rgba(242,216,130,0.95) 50%,rgba(200,160,96,0.9) 82%,rgba(200,160,96,0))}"

      // ── 本文：帯の中に流す ──
      // 左は [message_chara] の立ち絵（画面左・幅400px）を避ける位置から、
      // 下辺は名前銘板のぶんを空ける
      + ".message0_fore .message_inner,.message0_back .message_inner{"
        + "left:0!important;top:750px!important;width:1920px!important;height:330px!important;"
        + "box-sizing:border-box!important;padding:56px 200px 96px 360px!important;"
        + "text-shadow:0 2px 4px rgba(0,0,0,0.8)}"

      // ── 話者名：帯の下辺・中央に置く六角銘板 ──
      + ".message0_fore .chara_name_area,.message0_back .chara_name_area{"
        + "left:50%!important;right:auto!important;top:auto!important;bottom:28px!important;"
        + "width:auto!important;max-width:none!important;transform:translateX(-50%);"
        + "display:block;padding:10px 46px!important;white-space:nowrap;text-align:center!important;"
        + "font-family:" + M.TITLE + "!important;font-size:40px!important;line-height:1.2!important;"
        + "letter-spacing:0.14em!important;color:#F6E4B4!important;"
        + "text-shadow:0 2px 8px rgba(0,0,0,0.9)!important;"
        + "background:linear-gradient(180deg,#3a2410,#1a1006);border:1px solid #a57c34;"
        + "box-shadow:0 10px 26px rgba(0,0,0,0.6),inset 0 1px 0 rgba(242,216,130,0.25);"
        + "-webkit-clip-path:polygon(26px 0,calc(100% - 26px) 0,100% 50%,calc(100% - 26px) 100%,26px 100%,0 50%);"
        + "clip-path:polygon(26px 0,calc(100% - 26px) 0,100% 50%,calc(100% - 26px) 100%,26px 100%,0 50%)}"
      // 銘板の両端に打つ小さな菱形
      + ".message0_fore .chara_name_area::before,.message0_fore .chara_name_area::after,"
        + ".message0_back .chara_name_area::before,.message0_back .chara_name_area::after{"
        + "content:'';position:absolute;top:50%;margin-top:-5px;width:9px;height:9px;"
        + "background:" + M.GOLD + ";transform:rotate(45deg)}"
      + ".message0_fore .chara_name_area::before,.message0_back .chara_name_area::before{left:20px}"
      + ".message0_fore .chara_name_area::after,.message0_back .chara_name_area::after{right:20px}"
      // 地の文（話者なし）のときは銘板ごと消す
      + ".message0_fore .chara_name_area:empty,.message0_back .chara_name_area:empty{display:none!important}"

      // ── HUD（上部プレートと右下のシステム操作） ──
      + ".msgui-hud{position:absolute;left:0;top:0;width:100%;height:100%;z-index:99999999;"
        + "pointer-events:none;font-family:" + M.BODY + "}"
      + ".msgui-plate{position:absolute;top:44px;display:flex;align-items:center;gap:20px;"
        + "padding:14px 28px;border:1px solid #a8823c;pointer-events:auto}"
      // 左のプレートは表示だけなので、クリックは画面（文字送り）に通す
      + ".msgui-plate-l{left:56px;pointer-events:none;"
        + "background:linear-gradient(90deg,rgba(24,15,7,0.9),rgba(24,15,7,0.5))}"
      + ".msgui-plate-r{right:56px;background:linear-gradient(270deg,rgba(24,15,7,0.9),rgba(24,15,7,0.5))}"
      + ".msgui-plate span{font-size:30px;line-height:1.1;color:#dfc48e;letter-spacing:0.14em;"
        + "text-shadow:0 1px 3px rgba(0,0,0,0.75);white-space:nowrap}"
      + ".msgui-place{font-family:" + M.TITLE + ";position:relative;top:-3px }"
      // 解決編だけ出る「警部の心証」。残り数が減ったことに気づけるよう、地の金より赤みを強くする
      + ".msgui-shin{color:#e0a06a !important;letter-spacing:0.06em !important}"
      + ".msgui-sep{display:block;width:1px;height:28px;background:#a8823c;opacity:0.7}"
      + ".msgui-sys{position:absolute;right:72px;bottom:34px;display:flex;gap:52px;pointer-events:auto}"
      + ".msgui-sys span{font-size:22px;line-height:1.1;color:#9c8253;letter-spacing:0.34em;"
        + "text-shadow:0 1px 3px rgba(0,0,0,0.75);padding-bottom:8px}"
      + ".msgui-hit{cursor:pointer;transition:color .18s ease,box-shadow .18s ease}"
      + ".msgui-plate .msgui-hit:hover{color:" + M.LIGHT + "}"
      + ".msgui-sys .msgui-hit:hover,.msgui-sys .msgui-hit.msgui-on{"
        + "color:#dfc48e;box-shadow:inset 0 -1px 0 " + M.GOLD + "}";
    document.head.appendChild(st);
  },

  // f.game_time（分）から "H:MM" を組む。[gage_draw hide_time="true"] のときは空。
  timeStr: function(){
    var kf = TG.stat.f;
    if(kf.hud_hide_time === true){ return ""; }
    var t = kf.game_time || 0;
    return Math.floor(t / 60) + ":" + ("0" + (t % 60)).slice(-2);
  },

  // 解決編（scene8 / true_end）でだけ出す「警部の心証」。
  // f.s8_phase が 1 のあいだだけ、残り回数を ●／○ で並べる。
  shinStr: function(){
    var kf = TG.stat.f;
    if(!kf || kf.s8_phase !== 1){ return ""; }
    var mx = (typeof kf.s8_miss_max  === "number") ? kf.s8_miss_max  : 0;
    var lf = (typeof kf.s8_miss_left === "number") ? kf.s8_miss_left : 0;
    if(mx <= 0){ return ""; }
    var mk = "";
    for(var i = 0; i < mx; i++){ mk += (i < lf) ? "●" : "○"; }
    return "心証 " + mk;
  },

  clear: function(){
    var el = document.getElementById("msgui-hud");
    if(el && el.parentNode){ el.parentNode.removeChild(el); }
  },

  render: function(){
    var M = window.MSGUI;
    M.css();
    M.bind();
    M.clear();

    // 「舞黒館:リビング」のような表記は銅罫のかわりに区切りを入れて読ませる
    var place = (TG.stat.f.hud_place || "").replace(/[:：]/g, " ｜ ");
    var time  = M.timeStr();
    var shin  = M.shinStr();

    var h = '<div id="msgui-hud" class="fixlayer msgui-hud">';

    if(place !== "" || time !== "" || shin !== ""){
      h += '<div class="msgui-plate msgui-plate-l">';
      var first = true;
      if(place !== ""){ h += '<span class="msgui-place">' + place + '</span>'; first = false; }
      if(time !== ""){
        if(!first){ h += '<span class="msgui-sep"></span>'; }
        h += '<span class="msgui-time">' + time + '</span>'; first = false;
      }
      if(shin !== ""){
        if(!first){ h += '<span class="msgui-sep"></span>'; }
        h += '<span class="msgui-shin">' + shin + '</span>';
      }
      h += '</div>';
    }

    h += '<div class="msgui-plate msgui-plate-r">'
       +   '<span class="msgui-hit msgui-role-siryou">資料</span>'
       +   '<span class="msgui-sep"></span>'
       +   '<span class="msgui-hit msgui-role-menu">MENU</span>'
       + '</div>'
       + '<div class="msgui-sys">'
       +   '<span class="msgui-hit msgui-role-auto">AUTO</span>'
       +   '<span class="msgui-hit msgui-role-skip">SKIP</span>'
       +   '<span class="msgui-hit msgui-role-backlog">LOG</span>'
       + '</div>'
       + '</div>';

    var tmp = document.createElement("div");
    tmp.innerHTML = h;
    M.base().appendChild(tmp.firstElementChild);
    M.syncState();
  },

  // AUTO／SKIP の点灯をエンジンの状態に合わせる
  syncState: function(){
    $(".msgui-role-auto").toggleClass("msgui-on", TG.stat.is_auto === true);
    $(".msgui-role-skip").toggleClass("msgui-on", TG.stat.is_skip === true);
  },

  // [button role="..."] と同じ動作を文字ボタンから起こす
  action: function(role){
    var M = window.MSGUI;

    // セーブを伴う操作は、文字送り中・ウェイト中は受け付けない
    if(role === "siryou" || role === "menu"){
      if(TG.stat.is_adding_text || TG.stat.is_wait){ return; }
    }

    var was_skip = (TG.stat.is_skip === true);
    var was_auto = (TG.stat.is_auto === true);
    TG.setSkip(false);
    if(role !== "auto"){ TG.ftag.startTag("autostop", { next:"false" }); }

    switch(role){
      case "siryou":
        // [sleepgame] 中の再入を防ぐ（資料画面から資料画面を開かせない）
        if(TG.tmp.sleep_game !== null){ return; }
        TG.tmp.sleep_game = {};
        TG.ftag.startTag("sleepgame", { storage:"system/item_list.ks", next:false });
        break;

      case "menu":
        TG.menu.showMenu();
        break;

      case "backlog":
        TG.menu.displayLog();
        break;

      case "auto":
        if(was_auto){ TG.setAuto(false); }
        else{
          if(TG.layer.layer_event.isDisplayed()){ TG.layer.layer_event.click(); }
          TG.setAuto(true);
        }
        break;

      case "skip":
        if(!was_skip){
          if(TG.layer.layer_event.isDisplayed()){ TG.layer.layer_event.click(); }
          TG.setSkip(true);
        }
        break;
    }

    M.syncState();
  },

  // クリックは #tyrano_base への委譲で拾う（復元された HUD でも効くように）
  // document ではなく #tyrano_base に貼るのは、エンジンが document の mousedown で
  // オート・スキップを解除するより手前で伝播を止めるため（[button role] と同じ作り）。
  bind: function(){
    var M = window.MSGUI;
    if(M._bound){ return; }
    var j_base = $("#tyrano_base");
    if(j_base.length === 0){ return; }
    M._bound = true;

    for(var i = 0; i < M.ROLES.length; i++){
      (function(role){
        var sel = ".msgui-role-" + role;
        j_base.on("mousedown touchstart", sel, function(e){
          e.stopPropagation();
        });
        j_base.on("click", sel, function(e){
          e.stopPropagation();
          window.MSGUI.action(role);
          return false;
        });
      })(M.ROLES[i]);
    }

    TG.on("auto-start auto-stop skip-start skip-stop", function(){
      window.MSGUI.syncState();
    });
  }
};
[endscript]


;===============================================================================
; [msg_ui_setup]
;   メッセージウィンドウを 1b の帯に組み替える。first.ks で一度だけ呼ぶこと。
;   （テーマプラグインの枠画像・名前枠の指定を上書きします）
;===============================================================================
[macro name="msg_ui_setup"]
    ; 帯の位置と本文の余白（体裁の最終的な指定は msgui-css 側）
    [position layer="message0" page="fore" left=0 top=750 width=1920 height=330 margint=56 marginl=360 marginr=200 marginb=96]

    ; 本文の書体（1b：42px／やや明るい生成り色）
    [font size="42" color="0xF4EAD6"]
    [deffont size="42" color="0xF4EAD6"]

    [iscript]
    window.MSGUI.css();
    window.MSGUI.bind();
    [endscript]
[endmacro]


;===============================================================================
; [hud_draw]
;   上部プレート（場所／時刻・資料／MENU）と右下のシステム操作を描き直す。
;   場所名・時刻の表示状態は [gage_draw] が f.hud_place / f.hud_hide_time に残す。
;===============================================================================
[macro name="hud_draw"]
    ; ティラノ標準のメニューボタンは使わない（HUDの MENU に集約）
    [hidemenubutton]
    [iscript]
    window.MSGUI.render();
    [endscript]
[endmacro]
