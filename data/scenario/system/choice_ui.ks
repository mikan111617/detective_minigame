;===============================================================================
; choice_ui.ks ―― 立ち絵つき選択肢画面
;
; 構成：
;   choice_ui.ks … [stand_select] マクロ（このファイル）
;
; 読み込み（first.ks）：
;   [call storage="choice_ui.ks"]
;
; 使い方：
;   [iscript]
;       tf.choices = [];
;       tf.choices.push({ target:'*talk_kazuto', text:'花壇を見つめる和人',
;                         kind:'talk', chara:['kazuto'] });
;   [endscript]
;   [stand_select storage="scene2.ks" prompt="さて、どこを見て回ろうか……。"]
;
; 選択肢データ（tf.choices の1要素）：
;   target … ジャンプ先ラベル（必須）
;   text   … 画面に出す選択肢の文言（必須）
;   kind   … talk / look / move / accuse。名前の横に出る種別ラベルの出し分け（省略可）
;   chara  … 立ち絵を出すキャラクター名の配列。例：['eruku','juri']
;            画像は data/fgimage/standing/<名前>.png を使う。
;            見つからない場合は standing/<日本語名>.png →
;            chara/<名前>/normal.png の順に代替する。
;   name   … 名前欄の文字列（省略時は [chara_new] の jname から自動生成）
;
; マクロの引数：
;   storage … 選択後のジャンプ先シナリオ（必須）
;             ※マクロ実行中は current_scenario が choice_ui.ks になるため、
;               呼び出し元のファイル名を必ず明示すること
;   prompt  … 画面下部に出す問いかけ（HTML可。省略時は非表示）
;   se      … 決定時に鳴らす効果音（省略時は無音）
;
; 注意：
;   ・選択肢はページ送りせず、常に全件を1画面に並べる。
;     件数に応じて文字サイズと行間を自動で詰める。
;   ・オーバーレイは画面全体を覆う。画面上部（ヘッダ帯）は暗くしないので、
;     [gage_draw] の場所・時刻プレートはそのまま読める。
;   ・オーバーレイ自体は pointer-events:none。クリックを拾うのは選択肢の行だけ。
;===============================================================================

[iscript]
window.SEL_ENGINE = {
  GOLD:   "#f2d882",
  ACCENT: "#c8a060",
  TITLE:  "'Waosagi',serif",
  BODY:   "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",

  KIND: { talk:"話しかける", look:"調べる", move:"移動する", accuse:"指名する" },

  STAND_DIR: "./data/fgimage/standing/",
  CHARA_DIR: "./data/fgimage/chara/",

  // 選択中の状態。画面はひとつしか出ないので使い回す
  st: null,

  // タッチ操作かどうか。スマホはカーソルを合わせられないので、
  // 「1回目のタップで選択（立ち絵を表示）」「もう一度タップで決定」の2段階にする
  touch: false,
  isTouchDevice: function(){
    try {
      if(window.matchMedia && window.matchMedia("(hover:none),(pointer:coarse)").matches){ return true; }
    } catch(e){}
    return ("ontouchstart" in window) || ((navigator.maxTouchPoints|0) > 0);
  },

  base: function(){ return document.getElementById("tyrano_base") || document.body; },

  css: function(){
    if(document.getElementById("sel-css")){ return; }
    var s = document.createElement("style");
    s.id = "sel-css";
    s.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}"
      + "@keyframes selfade{from{opacity:0}to{opacity:1}}"
      + "@keyframes selrise{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:none}}";
    document.head.appendChild(s);
  },

  // 選択画面の間だけメッセージウィンドウの枠を隠す（CSSのみ。タグの状態は触らない）
  hideMessage: function(){
    if(document.getElementById("sel-msg-hide")){ return; }
    var s = document.createElement("style");
    s.id = "sel-msg-hide";
    s.textContent = "#tyrano_base .layer[class*='message']{display:none !important}";
    document.head.appendChild(s);
  },
  showMessage: function(){
    var s = document.getElementById("sel-msg-hide");
    if(s && s.parentNode){ s.parentNode.removeChild(s); }
  },

  clear: function(){
    var el = document.getElementById("sel-overlay");
    if(el && el.parentNode){ el.parentNode.removeChild(el); }
    window.SEL_ENGINE.showMessage();
    if(window.SEL_ENGINE.keyHandler){
      window.removeEventListener("keydown", window.SEL_ENGINE.keyHandler, true);
      window.SEL_ENGINE.keyHandler = null;
    }
  },

  mount: function(html){
    window.SEL_ENGINE.css();
    window.SEL_ENGINE.clear();
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    window.SEL_ENGINE.base().appendChild(tmp.firstElementChild);
  },

  // [stand_select] は本体が [s] で止まるマクロなので、
  // 画面から離脱（jump）するときにマクロスタックを畳んでおく
  markMacro: function(){
    try {
      var st = TG.getStack("macro");
      if(st){ st.__sel = true; }
    } catch(e){}
  },
  popMacro: function(){
    try {
      var arr = TG.stat.stack.macro;
      while(arr && arr.length && arr[arr.length-1] && arr[arr.length-1].__sel){ arr.pop(); }
    } catch(e){}
  },

  // [chara_new] の jname を名前欄に流用する
  jname: function(id){
    try {
      var c = TG.stat.charas[id];
      if(c && c.jname){ return c.jname; }
    } catch(e){}
    return id;
  },

  // chara 指定（配列 / カンマ区切り / オブジェクト）を [{id,name}] に揃える
  people: function(c){
    var raw = c.chara;
    if(!raw){ return []; }
    if(typeof raw === "string"){ raw = raw.split(","); }
    if(!(raw instanceof Array)){ raw = [raw]; }
    var out = [];
    for(var i=0;i<raw.length;i++){
      var it = raw[i];
      if(typeof it === "string"){
        var id = it.replace(/^\s+|\s+$/g, "");
        if(id !== ""){ out.push({ id:id, name:window.SEL_ENGINE.jname(id) }); }
      } else if(it && it.id){
        out.push({ id:it.id, name:it.name || window.SEL_ENGINE.jname(it.id), src:it.src || "" });
      }
    }
    return out;
  },

  // 立ち絵は standing/<英名>.png を本命に、無ければ順に代替を試す
  srcList: function(p){
    var SEL = window.SEL_ENGINE, out = [];
    if(p.src){ out.push(p.src); }
    out.push(SEL.STAND_DIR + encodeURIComponent(p.id) + ".png");
    if(p.name && p.name !== p.id){ out.push(SEL.STAND_DIR + encodeURIComponent(p.name) + ".png"); }
    out.push(SEL.CHARA_DIR + encodeURIComponent(p.id) + "/normal.png");
    return out;
  },

  imgFail: function(el){
    var list = (el.getAttribute("data-src-list") || "").split("|");
    var i = parseInt(el.getAttribute("data-src-i") || "0", 10) + 1;
    if(i < list.length){
      el.setAttribute("data-src-i", String(i));
      el.src = list[i];
    } else {
      el.onerror = null;
      el.style.display = "none";
    }
  },

  // 選択中の選択肢の立ち絵。2人いるときは後ろの1人を少し落として重ねる
  artHTML: function(c){
    var SEL = window.SEL_ENGINE, ps = SEL.people(c), h = "";
    if(ps.length === 0){ return ""; }
    var two = ps.length > 1;
    var ht = two ? 900 : 990;
    for(var i=0;i<ps.length;i++){
      var srcs = SEL.srcList(ps[i]);
      h += '<img src="' + srcs[0] + '" alt=""'
        + ' data-src-list="' + srcs.join("|") + '" data-src-i="0"'
        + ' onerror="window.SEL_ENGINE.imgFail(this)"'
        + ' style="height:' + ht + 'px;width:auto;max-width:760px;object-fit:contain;'
        + 'object-position:bottom center;position:relative;flex-shrink:0;'
        + 'z-index:' + (i === 0 ? 2 : 1) + ';'
        + (i > 0 ? 'margin-left:-200px;margin-bottom:26px;' : '')
        + 'filter:' + (i > 0
            ? 'brightness(0.78) saturate(0.9) drop-shadow(0 24px 40px rgba(0,0,0,0.5))'
            : 'drop-shadow(0 24px 40px rgba(0,0,0,0.55))') + '">';
    }
    return h;
  },

  // 件数に応じた詰め方。ページ送りをしないので全件が必ず収まるようにする
  metrics: function(n){
    if(n <= 4){ return { on:56, off:47, pad:14, gap:12 }; }
    if(n <= 6){ return { on:50, off:43, pad:11, gap:9  }; }
    if(n <= 8){ return { on:44, off:38, pad:8,  gap:7  }; }
    if(n <= 10){ return { on:38, off:33, pad:6, gap:5  }; }
    return { on:32, off:28, pad:4, gap:4 };
  },

  // 行の見た目を選択状態に合わせて塗り直す
  paint: function(i){
    var SEL = window.SEL_ENGINE, st = SEL.st;
    if(!st || i < 0 || i >= st.choices.length){ return; }
    // 同じ行に入り直したときに立ち絵を読み直さない
    if(st.cur === i){ return; }
    st.cur = i;
    var m = st.metrics;
    for(var k=0;k<st.choices.length;k++){
      var on = (k === i);
      var row  = document.getElementById("sel-row-" + k);
      var text = document.getElementById("sel-text-" + k);
      var rule = document.getElementById("sel-rule-" + k);
      var mark = document.getElementById("sel-mark-" + k);
      if(!row){ continue; }
      row.style.transform = on ? "translateX(-14px)" : "none";
      row.style.opacity   = on ? "1" : "0.86";
      text.style.fontSize = (on ? m.on : m.off) + "px";
      text.style.color    = on ? "#fff6d8" : "#ddcda4";
      text.style.textShadow = on
        ? "0 0 26px rgba(240,210,140,0.55), 0 2px 12px rgba(0,0,0,0.95)"
        : "0 3px 14px rgba(0,0,0,1), 0 0 30px rgba(0,0,0,0.85)";
      rule.style.width = on ? "100%" : "0";
      mark.style.background  = on ? SEL.ACCENT : "transparent";
      mark.style.borderColor = on ? SEL.ACCENT : "#54401a";
      mark.style.boxShadow   = on ? "0 0 16px " + SEL.ACCENT : "none";
    }

    var c = st.choices[i];
    var stage = document.getElementById("sel-stage");
    if(stage){
      stage.innerHTML = SEL.artHTML(c);
      stage.style.animation = "none";
      // 立ち絵を差し替えるたびに出現アニメを掛け直す
      void stage.offsetWidth;
      stage.style.animation = "selrise .28s ease-out";
    }
    var ps = SEL.people(c);
    var nameEl = document.getElementById("sel-name");
    var kindEl = document.getElementById("sel-kind");
    if(nameEl){
      var nm = c.name || (ps.length ? ps.map(function(p){ return p.name; }).join("　・　") : "");
      nameEl.innerHTML = nm;
      nameEl.style.display = nm === "" ? "none" : "block";
    }
    if(kindEl){
      var kd = SEL.KIND[c.kind || (ps.length ? "talk" : "look")] || "";
      kindEl.innerHTML = kd;
      kindEl.style.display = kd === "" ? "none" : "block";
    }
  },

  // 選択肢が画面に収まりきらないときのスワイプスクロール。
  // index.html の body に ontouchmove="event.preventDefault()" があるため、
  // タッチでは普通のスクロールが効かないので指の動きから自前で送る
  bindSwipe: function(){
    var SEL = window.SEL_ENGINE;
    var el = document.getElementById("sel-list");
    if(!el){ return; }
    var startY = 0, startTop = 0, scale = 1, dragging = false;

    el.addEventListener("touchstart", function(e){
      if(!e.touches || e.touches.length !== 1){ return; }
      startY   = e.touches[0].clientY;
      startTop = el.scrollTop;
      // 画面は 1920x1080 を拡大縮小して表示しているので、指の移動量を実寸に直す
      var r = el.getBoundingClientRect();
      scale = (el.offsetHeight > 0 && r.height > 0) ? (r.height / el.offsetHeight) : 1;
      dragging = true;
      SEL.swiped = false;
    }, { passive:true });

    el.addEventListener("touchmove", function(e){
      if(!dragging){ return; }
      var d = startY - e.touches[0].clientY;
      if(Math.abs(d) > 8 && el.scrollHeight > el.clientHeight){
        SEL.swiped = true;
        el.scrollTop = startTop + d / scale;
        if(e.cancelable){ e.preventDefault(); }
      }
    }, { passive:false });

    el.addEventListener("touchend",    function(){ dragging = false; }, { passive:true });
    el.addEventListener("touchcancel", function(){ dragging = false; SEL.swiped = false; }, { passive:true });
  },

  // 決定のクリックがそのままゲーム画面まで届くと、飛んだ先の最初の [p] を
  // 送ってしまい、一文目が読まれずに飛ばされる。伝播が終わってから飛ぶ。
  shield: function(){
    var SEL = window.SEL_ENGINE;
    var old = document.getElementById("sel-shield");
    if(old && old.parentNode){ old.parentNode.removeChild(old); }
    var d = document.createElement("div");
    d.id = "sel-shield";
    d.style.cssText = "position:absolute;inset:0;z-index:999999999;background:transparent";
    d.addEventListener("click", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    d.addEventListener("pointerdown", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    SEL.base().appendChild(d);
    setTimeout(function(){ if(d.parentNode){ d.parentNode.removeChild(d); } }, 260);
  },

  decide: function(i){
    var SEL = window.SEL_ENGINE, st = SEL.st;
    if(!st || st.done){ return; }
    var c = st.choices[i];
    if(!c || !c.target){ return; }
    st.done = true;
    if(st.se){ TG.ftag.startTag("playse", { storage: st.se, buf: "3" }); }
    SEL.clear();
    SEL.shield();
    setTimeout(function(){
      SEL.popMacro();
      TG.ftag.startTag("jump", { storage: st.storage, target: c.target });
    }, 0);
  },

  open: function(o){
    var SEL = window.SEL_ENGINE;
    var list = (o.choices || []).filter(function(c){ return c && c.text && c.target; });
    if(list.length === 0){ return; }
    var n = list.length, m = SEL.metrics(n);
    SEL.touch  = SEL.isTouchDevice();
    SEL.armed  = -1;   // タッチで「選択済み（次のタップで決定）」になっている行
    SEL.swiped = false;
    SEL.st = { choices:list, storage:o.storage, se:o.se, metrics:m, cur:-1, done:false };

    var rows = "";
    for(var i=0;i<n;i++){
      rows += '<div id="sel-row-' + i + '" style="display:flex;align-items:center;justify-content:flex-end;'
        + 'gap:22px;cursor:pointer;padding:' + m.pad + 'px 4px ' + m.pad + 'px 40px;'
        + 'touch-action:manipulation;-webkit-tap-highlight-color:transparent;'
        + 'transition:transform .18s ease, opacity .18s ease">'
        + '<div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">'
          + '<div id="sel-text-' + i + '" style="font-family:' + SEL.TITLE + ';font-size:' + m.off + 'px;'
            + 'line-height:1.1;letter-spacing:0.04em;white-space:nowrap;'
            + 'transition:font-size .18s ease, color .18s ease">' + list[i].text + '</div>'
          + '<div id="sel-rule-' + i + '" style="height:2px;width:0;align-self:stretch;'
            + 'transition:width .22s ease;background:linear-gradient(90deg,rgba(200,160,96,0),'
            + SEL.ACCENT + ')"></div></div>'
        + '<div id="sel-mark-' + i + '" style="flex-shrink:0;width:14px;height:14px;border-radius:50%;'
          + 'border:2px solid #54401a;transition:background .18s ease, box-shadow .18s ease"></div></div>';
    }

    var h = '<div id="sel-overlay" style="position:absolute;top:0;left:0;width:100%;height:100%;'
      + 'z-index:999999998;pointer-events:none;font-family:' + SEL.BODY + ';color:#e8dcc0;'
      + 'box-sizing:border-box;animation:selfade .3s ease-out">';

    // 画面上部（[gage_draw] の場所・時刻プレート）は暗くしない
    h += '<div style="position:absolute;inset:0;background:linear-gradient(180deg,'
      + 'rgba(6,4,1,0) 0%,rgba(6,4,1,0) 13%,rgba(6,4,1,0.45) 46%,rgba(6,4,1,0.78) 100%)"></div>'
      + '<div style="position:absolute;inset:0;background:linear-gradient(270deg,'
      + 'rgba(6,4,1,0.92) 0%,rgba(6,4,1,0.78) 18%,rgba(6,4,1,0.42) 34%,rgba(6,4,1,0) 58%)"></div>';

    // 立ち絵
    h += '<div id="sel-stage" style="position:absolute;left:40px;bottom:0;z-index:1;isolation:isolate;'
      + 'display:flex;align-items:flex-end"></div>';

    // 名前＋種別ラベル
    h += '<div style="position:absolute;z-index:3;left:96px;bottom:196px;display:flex;align-items:center;gap:16px">'
      + '<div id="sel-name" style="padding:8px 30px;background:linear-gradient(90deg,'
        + 'rgba(46,32,8,0.95),rgba(14,10,3,0.8));border:1px solid #8a6524;border-radius:6px;'
        + 'font-family:' + SEL.TITLE + ';font-size:38px;color:#fdf1c8;'
        + 'text-shadow:0 2px 12px rgba(0,0,0,0.9)"></div>'
      + '<div id="sel-kind" style="padding:6px 18px;border:1px solid #7a5a1e;border-radius:999px;'
        + 'font-size:22px;color:#e0bd66;letter-spacing:0.14em;background:rgba(10,7,2,0.7)"></div></div>';

    // 選択肢（全件を1画面に。クリックを拾うのはここだけ）
    h += '<div style="position:absolute;z-index:4;right:104px;top:120px;bottom:210px;'
      + 'display:flex;align-items:center;justify-content:flex-end;pointer-events:auto">'
      + '<div style="display:flex;align-items:stretch;gap:34px;max-height:100%">'
      + '<div style="width:2px;background:linear-gradient(180deg,rgba(200,160,96,0),'
        + 'rgba(200,160,96,0.8),rgba(200,160,96,0))"></div>'
      + '<div id="sel-list" style="display:flex;flex-direction:column;justify-content:center;align-items:flex-end;'
        + 'gap:' + m.gap + 'px;overflow-y:auto;touch-action:pan-y;-webkit-overflow-scrolling:touch">'
      + '<div style="font-size:22px;letter-spacing:0.44em;color:#8a6a30;padding-right:8px;flex-shrink:0">SELECT</div>'
      + rows + '</div></div></div>';

    // 下部の帯と問いかけ
    h += '<div style="position:absolute;z-index:2;left:0;right:0;bottom:0;height:172px;'
      + 'background:linear-gradient(0deg,rgba(6,4,1,0.94),rgba(6,4,1,0.72) 55%,rgba(6,4,1,0))"></div>'
      + '<div style="position:absolute;z-index:3;left:96px;right:96px;bottom:64px;'
      + 'display:flex;align-items:flex-end;gap:40px">'
      + '<div style="flex:1;font-size:34px;line-height:1.5;color:#e6d7b0;'
        + 'text-shadow:0 2px 12px rgba(0,0,0,0.95);text-wrap:pretty">' + (o.prompt || "") + '</div>'
      + '<div style="display:flex;gap:26px;font-size:20px;color:#8a6a30;letter-spacing:0.1em;'
        + 'white-space:nowrap">' + (SEL.touch
            ? '<div>タップで選択</div><div>もう一度タップで決定</div>'
            : '<div>↑↓ 選択</div><div>Enter 決定</div>') + '</div></div>';

    h += '</div>';
    SEL.mount(h);
    SEL.hideMessage();

    for(var j=0;j<n;j++){
      (function(k){
        var el = document.getElementById("sel-row-" + k);
        if(!el){ return; }

        // 指で触れた時点でタッチ操作と判断する（マウスオーバーは無効にする）
        el.addEventListener("touchstart", function(){
          SEL.touch = true;
          SEL.swiped = false;
        }, { passive:true });

        el.addEventListener("mouseenter", function(){
          if(SEL.touch){ return; }
          SEL.paint(k);
        });

        el.addEventListener("click", function(){
          // スワイプ（一覧のスクロール）で指が動いたときは決定しない
          if(SEL.swiped){ SEL.swiped = false; return; }
          if(SEL.touch && SEL.armed !== k){
            SEL.armed = k;  // 1回目のタップ：立ち絵と名前を出すだけ
            SEL.paint(k);
            return;
          }
          SEL.paint(k);
          SEL.decide(k);    // 同じ行をもう一度タップ（PCはクリック）で決定
        });
      })(j);
    }

    SEL.bindSwipe();
    SEL.paint(0);

    SEL.keyHandler = function(e){
      var st = SEL.st;
      if(!st || st.done){ return; }
      var len = st.choices.length, k = e.key;
      if(k === "ArrowDown" || k === "ArrowRight"){ SEL.paint((st.cur + 1) % len); }
      else if(k === "ArrowUp" || k === "ArrowLeft"){ SEL.paint((st.cur + len - 1) % len); }
      else if(k === "Enter" || k === " " || k === "Spacebar"){ SEL.decide(st.cur); }
      else { return; }
      e.preventDefault();
      e.stopPropagation();
    };
    window.addEventListener("keydown", SEL.keyHandler, true);
  }
};
[endscript]


;===============================================================================
; [stand_select storage="scene2.ks" prompt="……"]
;   tf.choices の全選択肢を立ち絵つきの1画面に並べる
;===============================================================================
[macro name="stand_select"]
[iscript]
window.SEL_ENGINE.markMacro();
window.SEL_ENGINE.open({
  choices: tf.choices || [],
  storage: mp.storage || TG.stat.current_scenario,
  prompt:  mp.prompt || "",
  se:      mp.se || ""
});
[endscript]
[s]
[endmacro]

[return]
