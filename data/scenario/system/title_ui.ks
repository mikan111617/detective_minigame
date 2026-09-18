;===============================================================================
; title_ui.ks  ―― タイトルロゴの共通組みとタイトル演出
;
;   [title_screen phase="touch"]  … タイトル画面（ロゴ＋TOUCH TO START）
;   [title_screen phase="menu"]   … タイトル画面（ロゴ＋メニュー）
;   [tl_cutin]                    … scene1 のタイトル表記演出（1文字ずつ落とす）
;
; ロゴは両画面で同じ組み（YDWaosagi・「舞黒館の」172px＋「惨劇」212px）。
; first.ks から [call storage="title_ui.ks"] で読み込む。
;===============================================================================

[iscript]
window.TL = {
  TITLE_TEXT: "舞黒館の惨劇",
  GRIM_FROM: 4,                 // ここから先（惨劇）を深紅の大字で組む
                                // ※「舞黒館の惨劇」は6文字。4 にしないと該当が無くなる
  SUB: "THE TRAGEDY AT THE Mr MAICRO HOUSE",
  // 英語版のロゴ。Waosagi は日本語書体なので、欧文はセリフ体で組む
  EN_LINE1: "THE TRAGEDY",
  EN_LINE2: "AT MAICRO HOUSE",
  EN_SIZE: 118,
  EN_FONT: "'Waosagi',serif",
  SUB_EN_CUTIN: "MAIKURO-KAN NO SANGEKI",
  ACCENT: "#1d4f8a",            // メニューの菱形が点る色
  FONT: "'Waosagi',serif",
  BODY: "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",

  base: function(){ return document.getElementById("tyrano_base") || document.body; },

  // 英語表示かどうか（data/others/i18n.js が読み込まれていないときは日本語）
  isEN: function(){ return !!(window.I18N && window.I18N.isEN()); },

  css: function(){
    if(document.getElementById("tl-css")){ return; }
    var st = document.createElement("style");
    st.id = "tl-css";
    st.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:block}"
      + "@keyframes tlChar{0%{opacity:0;transform:translateY(-46px) scale(1.5);filter:blur(9px)}"
        + "60%{filter:blur(0)}100%{opacity:1;transform:none;filter:blur(0)}}"
      + "@keyframes tlRule{from{transform:scaleX(0)}to{transform:scaleX(1)}}"
      + "@keyframes tlUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:none}}"
      + "@keyframes tlFlick{0%,100%{opacity:0.34}50%{opacity:0.9}}"
      + "@keyframes tlFade{from{opacity:0}to{opacity:1}}"
      + "@keyframes tlOut{from{opacity:1}to{opacity:0}}"
      // ── メニューの行組み（ホバーで菱形が点り、金の罫が右へ伸びる） ──
      + ".tl-row{display:flex;align-items:center;gap:20px;padding:13px 10px;cursor:pointer;"
        + "border-bottom:1px solid rgba(168,130,58,0.14);transition:border-color .2s ease}"
      + ".tl-row:hover{border-bottom-color:rgba(168,130,58,0.5)}"
      + ".tl-mark{flex-shrink:0;width:18px;font-size:17px;color:rgba(168,130,58,0.28);transition:color .2s ease}"
      + ".tl-row:hover .tl-mark{color:" + this.ACCENT + "}"
      + ".tl-label{font-family:'Waosagi',serif;font-size:44px;line-height:1.1;letter-spacing:0.12em;"
        + "white-space:nowrap;color:#b9a578;transition:color .2s ease}"
      + ".tl-row:hover .tl-label{color:#f7e6c2;text-shadow:0 0 22px rgba(200,160,90,0.45)}"
      + ".tl-en{font-size:17px;letter-spacing:0.28em;white-space:nowrap;color:#5f5031;transition:color .2s ease}"
      + ".tl-row:hover .tl-en{color:#9c8047}"
      + ".tl-state{min-width:72px;text-align:right;font-size:19px;font-weight:bold;letter-spacing:0.18em;"
        + "color:#9c8047;transition:color .2s ease,text-shadow .2s ease}"
      + ".tl-row:hover .tl-state{color:#f7e6c2;text-shadow:0 0 18px rgba(200,160,90,0.42)}"
      + ".tl-line{width:30px;height:1px;background:rgba(168,130,58,0.25);"
        + "transition:width .24s ease,background .2s ease}"
      + ".tl-row:hover .tl-line{width:86px;background:#a8823a}"
      // ── 右側に独立させたボイス切替ボタン ──
      // ── 右上に積むボタン（言語切替／ボイス切替） ──
      + ".tl-side{position:absolute;right:56px;top:48px;z-index:20;"
        + "display:flex;flex-direction:column;align-items:stretch;gap:14px}"
      + ".tl-voice-button{display:flex;align-items:center;gap:18px;min-width:278px;padding:18px 22px;"
        + "border:1px solid rgba(168,130,58,0.48);background:linear-gradient(100deg,rgba(8,6,14,0.86),rgba(24,18,22,0.7));"
        + "box-shadow:0 12px 34px rgba(0,0,0,0.42),inset 0 0 0 1px rgba(255,232,186,0.035);"
        + "color:#b9a578;cursor:pointer;font-family:"+this.BODY+";text-align:left;"
        + "transition:border-color .2s ease,box-shadow .2s ease,background .2s ease}"
      + ".tl-voice-button:hover,.tl-voice-button:focus-visible{outline:none;border-color:#a8823a;"
        + "background:linear-gradient(100deg,rgba(16,12,22,0.94),rgba(40,28,26,0.82));"
        + "box-shadow:0 12px 38px rgba(0,0,0,0.52),0 0 22px rgba(168,130,58,0.17)}"
      + ".tl-voice-mark{font-size:14px;color:rgba(168,130,58,0.5)}"
      + ".tl-voice-copy{display:flex;flex-direction:column;gap:3px;flex:1}"
      + ".tl-voice-jp{font-family:'Waosagi',serif;font-size:31px;line-height:1;letter-spacing:.14em}"
      + ".tl-voice-en{font-size:12px;line-height:1;letter-spacing:.34em;color:#75633d}"
      + ".tl-voice-state{min-width:66px;padding:8px 8px 7px;border-left:1px solid rgba(168,130,58,.3);"
        + "font-size:17px;font-weight:bold;line-height:1;letter-spacing:.16em;text-align:right;color:#75633d}"
      + ".tl-voice-button.is-on .tl-voice-mark,.tl-voice-button.is-on .tl-voice-state{"
        + "color:#f0d89f;text-shadow:0 0 16px rgba(200,160,90,.4)}"
      // 言語ボタンは英語の表示が入るので、見出しと状態の幅だけ広げる
      + ".tl-lang-title{font-family:"+this.BODY+";font-size:25px;letter-spacing:.08em}"
      + ".tl-lang-state{min-width:104px}";
    document.head.appendChild(st);
  },

  clear: function(id){
    var el = document.getElementById(id);
    if(el && el.parentNode){ el.parentNode.removeChild(el); }
  },

  mount: function(html){
    window.TL.css();
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    var el = tmp.firstElementChild;
    window.TL.clear(el.id);
    window.TL.base().appendChild(el);
    return el;
  },

  // タイトル画面のロゴ。日本語は縦横の字組みが効くので原文のまま、
  // 英語は横に伸びるので2行に割って組み直す。
  logoHTML: function(){
    var TL = this, en = TL.isEN();

    var head = '<div style="position:absolute;left:112px;top:84px;display:flex;flex-direction:column">'
      + '<div style="display:flex;align-items:center;gap:20px;padding-left:5px">'
        + '<div style="width:70px;height:1px;background:linear-gradient(90deg,transparent,#a8823a)"></div>'
        + '<div style="font-size:23px;letter-spacing:0.62em;color:#b08f4c">MYSTERY ADVENTURE</div></div>';

    var glow = '<div style="position:absolute;left:-46px;top:-30px;width:520px;height:300px;'
      + 'background:radial-gradient(closest-side,rgba(150,26,26,0.34),transparent 72%);filter:blur(28px)"></div>';

    var body;
    if(en){
      body = '<div style="position:relative;margin-top:30px">' + glow
        + '<div style="position:relative;font-family:'+TL.EN_FONT+';font-size:'+TL.EN_SIZE+'px;'
          + 'line-height:1.02;letter-spacing:0.02em;color:#f6ecd2;'
          + 'text-shadow:'+TL.charShadow(false)+'">'+TL.EN_LINE1+'</div>'
        + '<div style="position:relative;margin-top:8px;padding-left:78px;font-family:'+TL.EN_FONT+';'
          + 'font-size:'+TL.EN_SIZE+'px;line-height:1.02;letter-spacing:0.02em;color:#f3dcc4;'
          + 'text-shadow:'+TL.charShadow(true)+'">'+TL.EN_LINE2+'</div></div>';
    } else {
      body = '<div style="position:relative;margin-top:34px;display:flex;align-items:flex-start">' + glow
        + '<div style="position:relative;font-family:'+TL.FONT+';font-size:172px;line-height:1;'
          + 'letter-spacing:0.045em;color:#f6ecd2;text-shadow:'+TL.charShadow(false)+'">舞黒館の</div></div>'
        + '<div style="position:relative;display:flex;align-items:flex-end;margin-top:6px;padding-left:392px">'
        + '<div style="position:relative;left:-100px;height:205px;font-family:'+TL.FONT+';font-size:212px;'
          + 'line-height:1;letter-spacing:0.045em;color:#f3dcc4;'
          + 'text-shadow:0 0 30px rgba(178,32,26,0.72),0 0 3px rgba(255,226,196,0.6),'
          + '0 12px 50px rgba(0,0,0,0.95),0 3px 0 #8a1a1a">惨劇</div></div>';
    }

    // 帯の下に添える一行。日本語版は英題、英語版は原題を置く。
    var sub = en
      ? '<div style="font-family:'+TL.FONT+';font-size:30px;letter-spacing:0.34em;color:#8f7540;'
        + 'white-space:nowrap">'+TL.TITLE_TEXT+'</div>'
      : '<div style="font-size:20px;letter-spacing:0.4em;color:#8f7540;white-space:nowrap">'+TL.SUB+'</div>';

    return head + body
      + '<div style="display:flex;align-items:center;gap:22px;margin-top:30px;padding-left:6px">'
        + '<div style="width:300px;height:1px;background:linear-gradient(90deg,#a8823a,rgba(168,130,58,0.1))"></div>'
        + sub + '</div></div>';
  },

  // scene1 のタイトル表記。日本語は1文字ずつ落とす。
  cutinCharsHTML: function(){
    var TL = this, text = TL.TITLE_TEXT, out = "";
    for(var i=0;i<text.length;i++){
      var grim = (i >= TL.GRIM_FROM);
      out += '<div style="font-family:'+TL.FONT+';font-size:'+(grim?208:168)+'px;line-height:1;'
        + 'letter-spacing:0.04em;color:'+(grim?"#f3dcc4":"#f6ecd2")+';'
        + 'text-shadow:'+TL.charShadow(grim)+';opacity:0;'
        + 'animation:tlChar .78s '+(0.45 + i*0.19).toFixed(2)+'s cubic-bezier(.18,.85,.3,1.06) both">'
        + text.charAt(i)+'</div>';
    }
    return '<div style="display:flex;align-items:flex-end;justify-content:center">'+out+'</div>';
  },

  // 英語は1語ずつ。落ちる順は日本語と同じく左上から右下へ。
  cutinWordsHTML: function(){
    var TL = this;
    var rows = [
      { words: TL.EN_LINE1.split(" "), grim: false, size: 112 },
      { words: TL.EN_LINE2.split(" "), grim: true,  size: 112 }
    ];
    var out = "", n = 0;
    for(var r=0;r<rows.length;r++){
      var row = rows[r], line = "";
      for(var i=0;i<row.words.length;i++){
        line += '<div style="font-family:'+TL.EN_FONT+';font-size:'+row.size+'px;line-height:1.04;'
          + 'letter-spacing:0.02em;color:'+(row.grim?"#f3dcc4":"#f6ecd2")+';'
          + 'text-shadow:'+TL.charShadow(row.grim)+';opacity:0;'
          + 'animation:tlChar .78s '+(0.45 + n*0.28).toFixed(2)+'s cubic-bezier(.18,.85,.3,1.06) both">'
          + row.words[i]+'</div>';
        n++;
      }
      out += '<div style="display:flex;align-items:flex-end;justify-content:center;gap:28px">'
        + line + '</div>';
    }
    return out;
  },

  // 「惨劇」だけ深紅のにじみと下辺の朱シャドウを重ねる
  charShadow: function(grim){
    return grim
      ? "0 0 34px rgba(178,32,26,0.8),0 0 3px rgba(255,226,196,0.6),"
        + "0 12px 50px rgba(0,0,0,0.95),0 3px 0 #8a1a1a"
      : "0 0 2px rgba(255,240,205,0.5),0 10px 44px rgba(0,0,0,0.95),0 2px 0 #7a1c1c";
  }
};
[endscript]


;===============================================================================
; [title_screen phase="touch"|"menu"]
;   前提：直前に [bg storage="title.png"] で背景を出しておく
;   phase="touch" … 画面のどこを押しても *show_menu へ
;   phase="menu"  … はじめから／つづきから／おまけ／設定
;===============================================================================
[iscript]
// タイトル画面の描画本体。マクロからも [awakegame] 復帰時のフックからも呼ぶ
window.TL.render = function(phaseArg){
  var TL = window.TL, phase = (phaseArg === "menu") ? "menu" : "touch";
  var sf = TG.variable.sf;

  // 初回起動時はボイスをオフにする。以後はプレイヤーの選択を保持する。
  if(typeof sf.voice_enabled === "undefined"){
    sf.voice_enabled = 0;
    try { TG.saveSystemVariable(); }
    catch(e){ console.error("ボイス初期設定の保存に失敗しました", e); }
  }

  var h = '<div id="tl-title" style="position:absolute;top:0;left:0;width:100%;height:100%;'
    + 'z-index:999999997;font-family:'+TL.BODY+';color:#e0c07a;box-sizing:border-box;'
    + 'animation:tlFade .8s ease both">';

  // ── 背景の重ね（画像は [bg] で出しているので、ここは調色のみ） ──
  h += '<img src="./data/bgimage/title.png" alt="" style="position:absolute;inset:0;width:100%;height:100%;'
    + 'object-fit:cover;transform:scale(1.04)">'
    + '<div style="position:absolute;inset:0;background:linear-gradient(104deg,rgba(6,5,12,0.94) 0%,'
      + 'rgba(8,6,14,0.82) 34%,rgba(10,8,16,0.34) 62%,rgba(12,9,16,0.62) 100%)"></div>'
    + '<div style="position:absolute;inset:0;background:radial-gradient(78% 66% at 46% 40%,'
      + 'rgba(0,0,0,0) 32%,rgba(3,2,8,0.82) 100%)"></div>'
    + '<div style="position:absolute;inset:0;background:linear-gradient(180deg,rgba(4,3,9,0.72) 0%,'
      + 'rgba(4,3,9,0) 26%,rgba(4,3,9,0) 62%,rgba(4,3,9,0.9) 100%)"></div>'
    + '<div style="position:absolute;inset:0;opacity:0.055;background-image:repeating-linear-gradient(0deg,'
      + 'rgba(255,255,255,0.9) 0px,rgba(255,255,255,0.9) 1px,transparent 1px,transparent 4px)"></div>';

  // ── ロゴ ──
  h += TL.logoHTML();

  // ── メニュー ──
  if(phase === "menu"){
    var voiceOn = (sf.voice_enabled == 1);
    var rows = [
      { label:"はじめから", en:"NEW GAME", fn:"tlNew" },
      { label:"つづきから", en:"CONTINUE", fn:"tlLoad" },
      { label:"記録", en:"RECORDS", fn:"tlRecords" }
    ];
    // いずれかのエンディングを見ていれば、ヒントの部屋へ入れるようにする
    var _ach = (sf.achievements && typeof sf.achievements === "object") ? sf.achievements : {};
    if(_ach.end_bad == 1 || _ach.end_normal == 1 || _ach.end_true == 1){
      rows.push({ label:"舞黒相談所", en:"CONSULTATION", fn:"tlHint" });
    }
    if(sf.puzzle_unlocked == 1){ rows.push({ label:"おまけ", en:"EXTRA", fn:"tlExtra" }); }
    // rows.push({ label:"設定", en:"CONFIG", fn:"tlConfig" });

    h += '<div style="position:absolute;left:120px;bottom:80px;display:flex;flex-direction:column;'
      + 'gap:2px;width:600px">';
    for(var i=0;i<rows.length;i++){
      h += '<div class="tl-row" onclick="window.'+rows[i].fn+'()">'
        + '<div class="tl-mark">◆</div>'
        + '<div style="display:flex;align-items:baseline;gap:16px;flex-shrink:0">'
          + '<div class="tl-label">'+rows[i].label+'</div>'
          + '<div class="tl-en">'+rows[i].en+'</div></div>'
        + '<div style="flex:1;min-width:20px"></div>'
        + (rows[i].state ? '<div class="tl-state">'+rows[i].state+'</div>' : '')
        + '<div class="tl-line"></div></div>';
    }
    h += '</div>';

    // メニューの行数に影響しない独立ボタンとして右側に積む。
    var isEN = TL.isEN();
    h += '<div class="tl-side">';

    // 言語切替。英語版には音声を用意していないので、ボイスの上に置いて先に目に入るようにする。
    h += '<button id="tl-lang-button" type="button" class="tl-voice-button is-on"'
      + ' aria-label="' + (isEN ? 'Switch the language to Japanese' : '言語を英語に切り替える') + '">'
      + '<span class="tl-voice-mark">◆</span>'
      + '<span class="tl-voice-copy">'
        + '<span class="tl-voice-jp' + (isEN ? ' tl-lang-title' : '') + '">'
          + (isEN ? 'Language' : '言語') + '</span>'
        + '<span class="tl-voice-en">' + (isEN ? 'TAP FOR 日本語' : 'LANGUAGE') + '</span></span>'
      + '<span class="tl-voice-state tl-lang-state">' + (isEN ? 'ENGLISH' : '日本語') + '</span></button>';

    // 英語版はボイス無し。切り替えても鳴らないので、ボタン自体を出さない。
    // if(!isEN){
    //   h += '<button id="tl-voice-button" type="button" class="tl-voice-button'+(voiceOn ? ' is-on' : '')+'"'
    //     + ' aria-pressed="'+(voiceOn ? 'true' : 'false')+'" aria-label="ボイスを'+(voiceOn ? 'オフ' : 'オン')+'にする">'
    //     + '<span class="tl-voice-mark">◆</span>'
    //     + '<span class="tl-voice-copy"><span class="tl-voice-jp">ボイス</span>'
    //     + '<span class="tl-voice-en">VOICE</span></span>'
    //     + '<span class="tl-voice-state">'+(voiceOn ? 'ON' : 'OFF')+'</span></button>';
    // }

    // h += '</div>';
  } else {
    h += '<div style="position:absolute;left:0;right:0;bottom:38px;display:flex;justify-content:center">'
      + '<div style="font-size:21px;letter-spacing:0.52em;color:#c9b285;'
        + 'animation:tlFlick 2.6s ease-in-out infinite">TOUCH  TO  START</div></div>';
  }

  // ── デバッグ起動（右下隅を5回すばやくタップ） ──
  // オーバーレイの内側に置くことで、ロゴやメニューに隠れず必ず拾える。
  // 透明・見た目なしなので一般プレイヤーには見えない。
  h += '<div id="tl-debug" style="position:absolute;right:0;bottom:0;width:120px;height:120px;'
    + 'z-index:30;opacity:0;cursor:default"></div>';

  h += '</div>';

  var el = TL.mount(h);

  var voiceButton = el.querySelector("#tl-voice-button");
  if(voiceButton){
    voiceButton.onclick = function(e){
      if(e && e.stopPropagation){ e.stopPropagation(); }
      window.tlVoiceToggle();
    };
  }

  var langButton = el.querySelector("#tl-lang-button");
  if(langButton){
    langButton.onclick = function(e){
      if(e && e.stopPropagation){ e.stopPropagation(); }
      window.tlLangToggle();
    };
  }

  var dbg = el.querySelector("#tl-debug");
  if(dbg){
    var taps = 0, tapTimer = null;
    dbg.onclick = function(e){
      // タッチ待ちの全画面クリックに拾われないよう、ここで止める
      if(e && e.stopPropagation){ e.stopPropagation(); }
      taps++;
      if(taps === 1){
        tapTimer = setTimeout(function(){ taps = 0; }, 5000);   // 5秒でリセット
      }
      if(taps >= 5){
        clearTimeout(tapTimer);
        taps = 0;
        window.tlDebug();
      }
    };
  }

  // タッチ待ちの間は画面全体がメニューへの入口
  if(phase !== "menu"){
    el.style.cursor = "pointer";
    el.onclick = function(){ window.tlToMenu(); };
  }

  function go(pm){
    TL.clear("tl-title");
    TG.ftag.startTag("jump", pm);
  }
  window.tlToMenu = function(){ go({ storage:"title.ks", target:"*show_menu" }); };
  window.tlDebug  = function(){ go({ storage:"system/debug.ks", target:"*debug_start" }); };
  window.tlNew    = function(){ go({ storage:"title.ks", target:"*gamestart" }); };
  window.tlExtra  = function(){ go({ storage:"puzzle.ks" }); };
  window.tlHint   = function(){ go({ storage:"system/hint_room.ks", target:"*start" }); };
  window.tlAchievement = function(){
    go({ storage:"system/achievement.ks", target:"*achievement_start" });
  };
  // 称号と図鑑は「記録」にまとめて、その中で分ける
  window.tlRecords = function(){ go({ storage:"system/gallery.ks", target:"*start" }); };
  window.tlLoad   = function(){ TG.menu.displayLoad(); };
  // 言語を切り替える。system/*.ks は起動時に一度だけ [call] され、
  // その中で組み立てた JS（このメニューを含む）は読み直されない。
  // 中途半端に混ざるのを避けるため、切り替えたらページごと読み込み直す。
  window.tlLangToggle = function(){
    if(!window.I18N){ return; }
    var next = window.I18N.isEN() ? "ja" : "en";
    TL.clear("tl-title");
    window.I18N.setLang(next, function(){
      window.location.reload();
    });
  };
  window.tlVoiceToggle = function(){
    var kag = (window.TYRANO && window.TYRANO.kag) ? window.TYRANO.kag : TG;
    var sfv = kag.variable.sf;
    sfv.voice_enabled = (sfv.voice_enabled == 1) ? 0 : 1;
    try { kag.saveSystemVariable(); }
    catch(e){ console.error("ボイス設定の保存に失敗しました", e); }
    TL.render("menu");
  };
  // 設定は [sleepgame] で抜けるため、先にロゴを畳んでおく。
  // 復帰時は [s] の直前（このマクロ呼び出し）から再開するので描き直される。
  // window.tlConfig = function(){
  //   TL.clear("tl-title");
  //   TG.ftag.startTag("sleepgame", { storage:"../plugin/theme_kopanda_bth_13_dk/config.ks" });
  // };
};

// 設定から [awakegame] で戻ると [s] から再開するため、シナリオの進行では
// 描き直されない。ロード完了のイベントでタイトルに戻ったことを拾って描き直す。
if(!window.TL._hooked){
  window.TL._hooked = true;
  // [awakegame] では load-complete まで来ないことがあるので、
  // ロード系のイベントをまとめて拾い、少し待ってから状態を見て描き直す
  TG.on("load-start load-beforemaking load-complete", function(){
    // タイトルのロゴ・メニューは #tyrano_base の直下に重ねた素の DOM なので、
    // ロードでレイヤーの中身が差し替わっても自動では消えない。
    // 「つづきから」でセーブデータを読むと、復元されたゲーム画面がこの重ね絵に
    // 隠れて「音だけ鳴って画面が変わらない」状態になるため、
    // ロードが始まった時点で必ず畳んでおく。
    window.TL.clear("tl-title");
    setTimeout(function(){
      if(TG.stat.current_scenario === "title.ks" && !document.getElementById("tl-title")){
        window.TL.render("menu");
      }
    }, 400);
  });
}
[endscript]

[macro name="title_screen"]
[iscript]
window.TL.render(mp.phase);
[endscript]
[endmacro]


;===============================================================================
; [tl_cutin time="5200"]  タイトル表記の演出（scene1）
;   タイトル画面と同じ組みを1文字ずつ落とし、上下の金の細罫が締める
;===============================================================================
[macro name="tl_cutin"]
[iscript]
(function(){
  var TL = window.TL;
  // 日本語は1文字ずつ、英語は1語ずつ落とす。英語は横に長いので2行に割る。
  var chars = TL.isEN() ? TL.cutinWordsHTML() : TL.cutinCharsHTML();

  var rule = 'width:760px;height:1px;background:linear-gradient(90deg,transparent,#a8823a,transparent);'
    + 'transform-origin:center;';

  var h = '<div id="tl-cutin" style="position:absolute;top:0;left:0;width:100%;height:100%;'
    + 'z-index:999999997;background:#040309;font-family:'+TL.BODY+';box-sizing:border-box">'
    + '<img src="./data/bgimage/title.png" alt="" style="position:absolute;inset:0;width:100%;height:100%;'
      + 'object-fit:cover;opacity:0.16;filter:grayscale(0.6) brightness(0.7)">'
    + '<div style="position:absolute;inset:0;background:radial-gradient(62% 58% at 50% 48%,'
      + 'rgba(70,10,10,0.3),rgba(3,2,8,0.97) 78%)"></div>'
    + '<div style="position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;'
      + 'justify-content:center">'
      + '<div style="'+rule+'animation:tlRule 1.1s .15s cubic-bezier(.2,.8,.25,1) both"></div>'
      + '<div style="margin:52px 0 6px 0">'+chars+'</div>'
      + '<div style="'+rule+'animation:tlRule 1.1s 2.4s cubic-bezier(.2,.8,.25,1) both"></div>'
      + '<div style="margin-top:38px;font-size:24px;letter-spacing:0.52em;color:#9c8047;'
        + 'animation:tlUp 1.4s 2.8s ease-out both">'
        + (TL.isEN() ? TL.SUB_EN_CUTIN : TL.SUB) + '</div></div></div>';

  TL.mount(h);
})();
[endscript]
[eval exp="tf.tl_wait = (mp.time !== undefined) ? Number(mp.time) : 5200"]
[wait time="&tf.tl_wait"]
[iscript]
(function(){
  var el = document.getElementById("tl-cutin");
  if(!el){ return; }
  el.style.animation = "tlOut .7s ease forwards";
  setTimeout(function(){ if(el.parentNode){ el.parentNode.removeChild(el); } }, 760);
})();
[endscript]
[wait time=780]
[endmacro]

[return]
