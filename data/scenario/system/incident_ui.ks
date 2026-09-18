;===============================================================================
; incident_ui.ks ―― 事件発生パート（scene5 / scene6）の能動アクション
;
;   読むだけになりがちな「事件が起きる二章」に、プレイヤーが手を動かす場面を
;   差し込むための共通UI。物語の結末（二人の死・愛理の昏倒）は一切変えず、
;   「何を選び、何に気づき、何を覚えていたか」だけが変わるように作ってある。
;
;   [inc_urgent]   … 制限時間つきの即断。時間切れも“立ち尽くした”という結果になる
;   [inc_trace]    … 出来事を時系列に並べ、そこから掘るものを選ばせる
;   [inc_insight]  … 「気づき」を1件書き留める（画面右上に短く知らせる）
;   [inc_note]     … 画面右上に短い知らせを出すだけ
;
; 読み込み（first.ks）：
;   [call storage="system/incident_ui.ks"]
;
; 使い方（呼び出し側で tf.inc に設定を積んでからマクロを書く）：
;   [iscript]
;   tf.inc = { storage:"scene5.ks", limit:10, choices:[ ... ] };
;   [endscript]
;   [inc_urgent]
;
;   選択の結果は tf.inc.choices[i].target のラベルへ [jump] する。
;   [stand_select] と同じで、マクロの中で [s] して止まり、
;   決定時にマクロスタックを畳んでから飛ぶ。
;
; 気づき（f.s56_insight）：
;   { id: 表示名 } の連想配列。事件の夜に自分の目で拾ったものが入る。
;   scene6 終盤で零度警部の信頼を測るときに数を見る。
;   INC.hasInsight(id) / INC.insightCount() で参照する。
;
; 注意：
;   ・HTML は必ず JavaScript の文字列から組み立てる。.ks に生のHTMLを書くと
;     行頭の # や [ をタグ・話者名と誤認されるため。
;   ・行頭が [ # * ; @ で始まる行を [iscript] の中に作らないこと。
;   ・画面は 1920x1080 の座標系を CSS で縮小表示している。オーバーレイは
;     #tyrano_base の中に position:absolute で敷く。
;===============================================================================

[iscript]
window.INC = {

  TITLE: "'Waosagi',serif",
  BODY:  "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",
  RED:   "#d0463a",
  DEEP:  "#7c1d17",
  GOLD:  "#c8a060",
  PAPER: "#ecdfc2",
  DIM:   "#9a8a70",

  // 実際に動いているエンジンは window.TYRANO.kag のほう（achievement.ks と同じ理由）
  kag: function(){
    return (window.TYRANO && window.TYRANO.kag) ? window.TYRANO.kag : tyrano.plugin.kag;
  },
  base: function(){ return document.getElementById("tyrano_base") || document.body; },
  gf:   function(){ return window.INC.kag().stat.f; },
  gtf:  function(){ return window.INC.kag().variable.tf; },

  se: function(name){
    if(!name){ return; }
    try{ window.INC.kag().ftag.startTag("playse", { storage:name, buf:"3" }); }catch(e){}
  },

  esc: function(s){
    return String(s === undefined || s === null ? "" : s)
      .replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
  },

  //-------------------------------------------------------------------------
  // 気づき（scene5→scene6 をつなぐ唯一の持ち越し）
  //-------------------------------------------------------------------------
  insight: function(id, name){
    var f = window.INC.gf();
    if(!f.s56_insight || typeof f.s56_insight !== "object"){ f.s56_insight = {}; }
    if(!id || f.s56_insight[id]){ return false; }
    f.s56_insight[id] = name || id;
    return true;
  },
  hasInsight: function(id){
    var f = window.INC.gf();
    return !!(f.s56_insight && f.s56_insight[id]);
  },
  insightCount: function(){
    var f = window.INC.gf(), n = 0, k;
    if(!f.s56_insight){ return 0; }
    for(k in f.s56_insight){ if(f.s56_insight.hasOwnProperty(k)){ n++; } }
    return n;
  },

  //-------------------------------------------------------------------------
  // 共通の下ごしらえ
  //-------------------------------------------------------------------------
  css: function(){
    if(document.getElementById("inc-css")){ return; }
    var s = document.createElement("style");
    s.id = "inc-css";
    s.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}"
      + "@keyframes incfade{from{opacity:0}to{opacity:1}}"
      + "@keyframes incrise{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:none}}"
      + "@keyframes incpulse{0%,100%{opacity:.30}50%{opacity:.72}}"
      + "@keyframes incbeat{0%,100%{transform:scale(1)}12%{transform:scale(1.06)}24%{transform:scale(1)}"
        + "36%{transform:scale(1.03)}48%{transform:scale(1)}}"
      + "@keyframes incshake{0%,100%{transform:translate(0,0)}20%{transform:translate(-4px,2px)}"
        + "40%{transform:translate(3px,-3px)}60%{transform:translate(-3px,-2px)}80%{transform:translate(4px,3px)}}"
      + "@keyframes incslip{0%,100%{opacity:1}47%{opacity:.35}53%{opacity:.9}}"
      + ".inc-card{position:relative;display:flex;align-items:center;gap:20px;padding:16px 26px;"
        + "border:1px solid #5b3f1c;border-radius:8px;background:linear-gradient(90deg,"
        + "rgba(20,13,5,.94),rgba(10,7,3,.78));cursor:pointer;pointer-events:auto;"
        + "transition:transform .14s ease,border-color .14s ease,background .14s ease}"
      + ".inc-card:hover{transform:translateX(-10px);border-color:#d8b071;"
        + "background:linear-gradient(90deg,rgba(46,28,8,.96),rgba(16,10,4,.86))}"
      + ".inc-card.inc-off{opacity:.34;cursor:default;pointer-events:none}"
      + ".inc-card.inc-off:hover{transform:none;border-color:#5b3f1c}"
      + ".inc-btn{padding:14px 34px;border-radius:6px;border:1px solid #8a6524;"
        + "background:rgba(24,16,5,.94);color:#ecdfc2;font-size:23px;font-family:inherit;"
        + "cursor:pointer;letter-spacing:.1em;white-space:nowrap;pointer-events:auto}"
      + ".inc-btn:hover{background:rgba(58,38,10,.96);border-color:#d8b071}"
      + ".inc-btn:disabled{opacity:.35;cursor:default}"
      + ".inc-btn.inc-on{background:#c8a060;color:#0a0702;border-color:#f0dcae;font-weight:700}"
      + ".inc-chip{padding:10px 22px;border-radius:999px;border:1px solid #6c4c18;"
        + "background:rgba(18,12,4,.9);color:#e6d4a4;font-size:24px;cursor:pointer;"
        + "pointer-events:auto;white-space:nowrap;transition:all .14s ease}"
      + ".inc-chip:hover{border-color:#d8b071;background:rgba(52,34,10,.94)}"
      + ".inc-chip.inc-sel{background:#c8a060;color:#0a0702;border-color:#f4e2b4;font-weight:700}"
      + ".inc-chip.inc-bad{border-color:#d0463a;color:#f0a79c;animation:incshake .32s ease 2}";
    document.head.appendChild(s);
  },

  // 画面が出ている間だけメッセージ枠を隠す（タグの状態は触らない）
  hideMessage: function(){
    if(document.getElementById("inc-msg-hide")){ return; }
    var s = document.createElement("style");
    s.id = "inc-msg-hide";
    s.textContent = "#tyrano_base .layer[class*='message']{display:none !important}";
    document.head.appendChild(s);
  },
  showMessage: function(){
    var s = document.getElementById("inc-msg-hide");
    if(s && s.parentNode){ s.parentNode.removeChild(s); }
  },

  clear: function(){
    var I = window.INC;
    if(I.raf){ cancelAnimationFrame(I.raf); I.raf = null; }
    if(I.keyHandler){
      window.removeEventListener("keydown", I.keyHandler, true);
      I.keyHandler = null;
    }
    if(I.upHandler){
      window.removeEventListener("pointerup", I.upHandler, true);
      I.upHandler = null;
    }
    var el = document.getElementById("inc-overlay");
    if(el && el.parentNode){ el.parentNode.removeChild(el); }
    I.showMessage();
  },

  mount: function(html){
    var I = window.INC;
    I.css(); I.clear();
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    I.base().appendChild(tmp.firstElementChild);
    I.hideMessage();
  },

  el: function(sel){ return document.querySelector("#inc-overlay " + sel); },

  // 立ち絵は standing/<英名>.png を本命に、無ければ順に代替を試す
  //（choice_ui.ks の [stand_select] と同じ探し方）
  faceSrc: function(fc){
    var id = fc.id || "";
    var out = [];
    if(id){ out.push("./data/fgimage/standing/" + encodeURIComponent(id) + ".png"); }
    if(fc.name){ out.push("./data/fgimage/standing/" + encodeURIComponent(fc.name) + ".png"); }
    if(id){ out.push("./data/fgimage/chara/" + encodeURIComponent(id) + "/normal.png"); }
    return out.length ? out : [""];
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

  // [s] で止まっているマクロを畳んでから飛ぶ（choice_ui.ks と同じ作法）
  markMacro: function(){
    try{
      var st = window.INC.kag().getStack ? window.INC.kag().getStack("macro") : TG.getStack("macro");
      if(st){ st.__inc = true; }
    }catch(e){}
  },
  popMacro: function(){
    try{
      var arr = window.INC.kag().stat.stack.macro;
      while(arr && arr.length && arr[arr.length-1] && arr[arr.length-1].__inc){ arr.pop(); }
    }catch(e){}
  },

  // 決定してから飛ぶ。
  //   クリックのまま同期でジャンプすると、そのクリックがバブリングで
  //   ゲーム画面まで届き、飛んだ先の最初の [p] を送ってしまう
  //   （＝一文目が読まれずに飛ばされる）。
  //   イベントの伝播が終わってから飛ぶように、必ず一拍置く。
  goto: function(storage, target){
    var I = window.INC;
    if(I.st){ I.st.done = true; }
    I.clear();
    I.shield();
    setTimeout(function(){
      I.popMacro();
      I.kag().ftag.startTag("jump", { storage: storage, target: target });
    }, 0);
  },

  // 飛んだ直後の数百ミリ秒だけクリックを吸い取る覆い。
  // 連打で二文目まで送られるのも防ぐ。
  shield: function(){
    var I = window.INC;
    var old = document.getElementById("inc-shield");
    if(old && old.parentNode){ old.parentNode.removeChild(old); }
    var d = document.createElement("div");
    d.id = "inc-shield";
    d.style.cssText = "position:absolute;inset:0;z-index:999999999;background:transparent";
    d.addEventListener("click", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    d.addEventListener("pointerdown", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    I.base().appendChild(d);
    setTimeout(function(){ if(d.parentNode){ d.parentNode.removeChild(d); } }, 260);
  },

  //-------------------------------------------------------------------------
  // 画面右上の短い知らせ（気づきを書き留めたとき等）
  //-------------------------------------------------------------------------
  toast: function(title, text){
    var I = window.INC;
    I.css();
    var old = document.getElementById("inc-toast");
    if(old && old.parentNode){ old.parentNode.removeChild(old); }
    var d = document.createElement("div");
    d.id = "inc-toast";
    d.style.cssText = "position:absolute;top:150px;right:56px;z-index:999999999;"
      + "min-width:360px;max-width:640px;padding:18px 26px;border-radius:8px;"
      + "border:1px solid #8a6524;background:linear-gradient(90deg,rgba(16,11,3,.97),rgba(30,20,6,.93));"
      + "font-family:" + I.BODY + ";color:" + I.PAPER + ";animation:incrise .3s ease-out;"
      + "box-shadow:0 12px 34px rgba(0,0,0,.6);pointer-events:none";
    d.innerHTML =
        '<div style="font-size:17px;letter-spacing:.3em;color:' + I.GOLD + '">' + I.esc(title) + '</div>'
      + '<div style="margin-top:8px;font-size:25px;line-height:1.4">' + I.esc(text) + '</div>';
    I.base().appendChild(d);
    setTimeout(function(){
      if(!d.parentNode){ return; }
      d.style.transition = "opacity .5s ease";
      d.style.opacity = "0";
      setTimeout(function(){ if(d.parentNode){ d.parentNode.removeChild(d); } }, 520);
    }, 2600);
  },

  //-------------------------------------------------------------------------
  // 共通の枠。tag は画面種別の見出し、lead は状況説明、foot は操作説明
  //-------------------------------------------------------------------------
  shell: function(o){
    var I = window.INC;
    var tint = o.tint || "rgba(48,6,3,.55)";
    var h = '<div id="inc-overlay" style="position:absolute;top:0;left:0;width:100%;height:100%;'
      + 'z-index:999999998;pointer-events:none;font-family:' + I.BODY + ';color:' + I.PAPER + ';'
      + 'box-sizing:border-box;animation:incfade .28s ease-out">';

    // 下地。緊迫の画面は背景（事件現場のCG）を強めに透かし、
    // 落ち着いて考える画面は文字が読めるところまで沈める
    h += '<div style="position:absolute;inset:0;background:radial-gradient(78% 66% at 50% 46%,'
      + (o.alarm ? 'rgba(4,2,1,.30) 0%,rgba(4,2,1,.80) 100%'
                 : 'rgba(4,2,1,.62) 0%,rgba(4,2,1,.92) 100%') + ')"></div>';
    if(o.alarm){
      h += '<div style="position:absolute;inset:0;animation:incpulse 1.15s ease-in-out infinite;'
        + 'background:radial-gradient(72% 58% at 50% 50%,rgba(0,0,0,0) 42%,' + tint + ' 100%)"></div>';
    }

    // 見出し
    h += '<div style="position:absolute;top:48px;left:76px;display:flex;flex-direction:column;gap:8px">'
      + '<div style="font-size:19px;letter-spacing:.42em;color:' + (o.alarm ? I.RED : I.GOLD) + '">'
        + I.esc(o.tag || "") + '</div>'
      + '<div style="font-family:' + I.TITLE + ';font-size:44px;letter-spacing:.1em;color:#f6e6b8">'
        + I.esc(o.title || "") + '</div>'
      + '<div style="width:300px;height:1px;background:linear-gradient(90deg,#8a6524,rgba(138,101,36,0))"></div>'
      + (o.lead ? '<div style="max-width:900px;font-size:22px;line-height:1.8;color:' + I.DIM + '">'
          + I.esc(o.lead) + '</div>' : '')
      + '</div>';

    h += (o.body || "");

    h += '<div style="position:absolute;left:50%;bottom:44px;transform:translateX(-50%);'
      + 'display:flex;gap:30px;font-size:19px;letter-spacing:.12em;color:#8a7a5c;white-space:nowrap">'
      + (o.foot || "") + '</div>';

    h += '</div>';
    return h;
  },

  //=========================================================================
  // 1. 緊急の即断 ―― 制限時間つきの選択
  //    時間切れは失敗ではなく「立ち尽くした」という結果。物語は必ず先へ進む。
  //=========================================================================
  openUrgent: function(o){
    var I = window.INC;
    var list = (o.choices || []).filter(function(c){ return c && c.text && c.target; });
    if(list.length === 0){ return; }
    var limit = Number(o.limit || 10) * 1000;

    I.st = { kind:"urgent", storage:o.storage, done:false };

    var rows = "";
    for(var i=0;i<list.length;i++){
      rows += '<div class="inc-card" id="inc-c-' + i + '" style="animation:incrise .3s ease-out ' + (i*0.06) + 's both">'
        + '<div style="flex-shrink:0;width:42px;height:42px;border-radius:50%;border:1px solid #8a6524;'
          + 'display:flex;align-items:center;justify-content:center;font-size:22px;color:' + I.GOLD + '">'
          + (i+1) + '</div>'
        + '<div style="display:flex;flex-direction:column;gap:5px">'
          + '<div style="font-family:' + I.TITLE + ';font-size:34px;line-height:1.2;color:#fff3d6">'
            + I.esc(list[i].text) + '</div>'
          + (list[i].sub ? '<div style="font-size:19px;color:#a08c64">' + I.esc(list[i].sub) + '</div>' : '')
        + '</div></div>';
    }

    var body = ''
      // 残り時間
      + '<div style="position:absolute;top:52px;right:76px;display:flex;flex-direction:column;'
        + 'align-items:flex-end;gap:10px">'
        + '<div style="font-size:19px;letter-spacing:.3em;color:' + I.RED + '">TIME</div>'
        + '<div id="inc-t-num" style="font-family:' + I.TITLE + ';font-size:64px;line-height:1;color:#ffd7cc">'
          + (limit/1000).toFixed(1) + '</div>'
        + '<div style="width:420px;height:8px;border-radius:4px;background:rgba(255,255,255,.10);overflow:hidden">'
          + '<div id="inc-t-bar" style="width:100%;height:100%;border-radius:4px;'
            + 'background:linear-gradient(90deg,#d0463a,#ffb08a)"></div></div></div>'
      // 選択肢
      + '<div style="position:absolute;right:96px;bottom:150px;display:flex;flex-direction:column;'
        + 'align-items:stretch;gap:14px;width:820px">' + rows + '</div>'
      // 問いかけ
      + '<div style="position:absolute;left:76px;bottom:150px;max-width:760px;'
        + 'font-family:' + I.TITLE + ';font-size:40px;line-height:1.45;color:#ffe9c4;'
        + 'text-shadow:0 2px 14px rgba(0,0,0,.95);animation:incbeat 1.15s ease-in-out infinite">'
        + I.esc(o.prompt || "") + '</div>';

    I.mount(I.shell({
      tag: o.tag || "緊急",
      title: o.title || "即断",
      lead: o.lead || "",
      alarm: true,
      body: body,
      foot: '<div>クリック／タップで決定</div><div>1〜' + list.length + ' キーでも選べる</div>'
    }));

    var decide = function(i){
      var c = list[i];
      if(!c || !I.st || I.st.done){ return; }
      I.se(o.se || "decide.mp3");
      I.gf().s56_urgent_acted = (I.gf().s56_urgent_acted || 0) + 1;
      I.goto(o.storage, c.target);
    };

    for(var j=0;j<list.length;j++){
      (function(k){
        var el = document.getElementById("inc-c-" + k);
        if(el){ el.addEventListener("click", function(){ decide(k); }); }
      })(j);
    }

    I.keyHandler = function(e){
      if(!I.st || I.st.done){ return; }
      var n = parseInt(e.key, 10);
      if(n >= 1 && n <= list.length){
        decide(n - 1);
        e.preventDefault(); e.stopPropagation();
      }
    };
    window.addEventListener("keydown", I.keyHandler, true);

    // 残り時間の描画。0 になったら「立ち尽くした」側へ飛ぶ
    var start = (window.performance && performance.now) ? performance.now() : Date.now();
    var warned = false;
    var tick = function(){
      if(!I.st || I.st.done){ return; }
      var now = (window.performance && performance.now) ? performance.now() : Date.now();
      var left = Math.max(0, limit - (now - start));
      var bar = document.getElementById("inc-t-bar");
      var num = document.getElementById("inc-t-num");
      if(bar){ bar.style.width = (left / limit * 100) + "%"; }
      if(num){ num.textContent = (left / 1000).toFixed(1); }
      if(!warned && left <= limit * 0.34){
        warned = true;
        I.se("warning.mp3");
        if(num){ num.style.color = "#ff8f7c"; }
      }
      if(left <= 0){
        I.gf().s56_urgent_frozen = (I.gf().s56_urgent_frozen || 0) + 1;
        I.goto(o.storage, o.timeout || list[0].target);
        return;
      }
      I.raf = requestAnimationFrame(tick);
    };
    I.raf = requestAnimationFrame(tick);
  },

  //=========================================================================
  // 3. 足取りをたどる
  //    出来事を時系列に並べて見せ、そこから何を掘るかをプレイヤーに選ばせる。
  //    steps … 時系列の札／faces … 並べて見せる人物／choices … 問いの選択肢
  //    choices を省くと「続ける」だけの一枚絵になる。
  //=========================================================================
  openTrace: function(o){
    var I = window.INC;
    var steps = o.steps || [];
    var faces = o.faces || [];
    var list  = (o.choices || []).filter(function(c){ return c && c.text && c.target; });

    I.st = { kind:"trace", storage:o.storage, done:false };

    var body = "", d = 0;

    // ── 時系列の札 ──
    if(steps.length){
      var col = "";
      for(var i=0;i<steps.length;i++){
        if(i > 0){
          col += '<div style="display:flex;align-items:center;gap:14px;padding-left:26px;'
            + 'animation:incrise .34s ease-out ' + d.toFixed(2) + 's both">'
            + '<div style="font-size:26px;color:#7a6238">↓</div>'
            + '<div style="font-size:19px;color:#7a6238;letter-spacing:.1em">'
              + I.esc(steps[i-1].link || "") + '</div></div>';
          d += 0.10;
        }
        var mark = steps[i].mark
          ? ('border-color:#d0463a;box-shadow:0 0 26px rgba(208,70,58,.28)') : '';
        col += '<div style="display:flex;align-items:center;gap:22px;padding:18px 26px;'
          + 'border:1px solid #5b3f1c;border-radius:8px;background:linear-gradient(90deg,'
          + 'rgba(20,13,5,.94),rgba(10,7,3,.72));' + mark + ';'
          + 'animation:incrise .34s ease-out ' + d.toFixed(2) + 's both">'
          + '<div style="flex-shrink:0;width:112px;font-family:' + I.TITLE + ';font-size:27px;'
            + 'color:' + I.GOLD + ';letter-spacing:.04em">' + I.esc(steps[i].time || "") + '</div>'
          + '<div style="display:flex;flex-direction:column;gap:5px">'
            + '<div style="font-family:' + I.TITLE + ';font-size:31px;line-height:1.25;color:#fff3d6">'
              + I.esc(steps[i].label) + '</div>'
            + (steps[i].note ? '<div style="font-size:19px;color:#a08c64">'
                + I.esc(steps[i].note) + '</div>' : '')
          + '</div></div>';
        d += 0.18;
      }
      body += '<div style="position:absolute;left:88px;top:236px;width:' + (list.length ? 790 : 1000) + 'px;'
        + 'display:flex;flex-direction:column;gap:10px">' + col + '</div>';
    }

    // ── 並べて見せる人物（立ち絵） ──
    if(faces.length){
      var row = "";
      // 立ち絵は人数で高さを変える。名前と一言は絵の下に重ねて置く
      var ph = (faces.length >= 5) ? 460 : (faces.length >= 4 ? 540 : 620);
      for(var k=0;k<faces.length;k++){
        var srcs = I.faceSrc(faces[k]);
        row += '<div style="position:relative;display:flex;flex-direction:column;align-items:center;'
          + 'animation:incrise .34s ease-out ' + d.toFixed(2) + 's both">'
          + '<img src="' + srcs[0] + '" alt=""'
            + ' data-src-list="' + srcs.join("|") + '" data-src-i="0"'
            + ' onerror="window.INC.imgFail(this)"'
            + ' style="height:' + ph + 'px;width:auto;max-width:400px;object-fit:contain;'
            + 'object-position:bottom center;'
            + 'filter:drop-shadow(0 18px 30px rgba(0,0,0,.65))">'
          + '<div style="margin-top:-26px;padding:8px 26px;border-radius:6px;'
            + 'background:linear-gradient(90deg,rgba(46,32,8,.96),rgba(14,10,3,.88));'
            + 'border:1px solid #8a6524;font-family:' + I.TITLE + ';font-size:30px;color:#fdf1c8;'
            + 'white-space:nowrap">' + I.esc(faces[k].name) + '</div>'
          + (faces[k].note ? '<div style="margin-top:10px;font-size:19px;color:#a08c64;max-width:280px;'
              + 'text-align:center;line-height:1.5">' + I.esc(faces[k].note) + '</div>' : '')
          + '</div>';
        d += 0.16;
      }
      var ftop = steps.length ? 560 : 296;
      body += '<div style="position:absolute;left:140px;right:140px;top:' + ftop + 'px;display:flex;'
        + 'justify-content:center;align-items:flex-end;gap:24px">' + row + '</div>';
    }

    // ── 問いと選択肢 ──
    if(list.length){
      var rows = "";
      for(var j=0;j<list.length;j++){
        rows += '<div class="inc-card" id="inc-c-' + j + '" style="padding:16px 24px;'
          + 'animation:incrise .3s ease-out ' + (d + j*0.08).toFixed(2) + 's both">'
          + '<div style="flex-shrink:0;width:36px;height:36px;border-radius:50%;border:1px solid #8a6524;'
            + 'display:flex;align-items:center;justify-content:center;font-size:19px;color:' + I.GOLD + '">'
            + (j+1) + '</div>'
          + '<div style="font-family:' + I.TITLE + ';font-size:29px;line-height:1.3;color:#fff3d6">'
            + I.esc(list[j].text) + '</div></div>';
      }
      body += '<div style="position:absolute;right:76px;top:236px;width:900px;'
        + 'display:flex;flex-direction:column;gap:14px">'
        + '<div style="font-family:' + I.TITLE + ';font-size:36px;line-height:1.4;color:#ffe9c4;'
          + 'padding-bottom:14px;margin-bottom:6px;border-bottom:1px solid #5b3f1c">'
          + I.esc(o.prompt || "") + '</div>'
        + rows + '</div>';
    } else {
      body += '<div style="position:absolute;left:50%;bottom:46px;transform:translateX(-50%)">'
        + '<button class="inc-btn inc-on" id="inc-trace-ok">続ける</button></div>';
    }

    I.mount(I.shell({
      tag: o.tag || "整理",
      title: o.title || "足取りをたどる",
      lead: o.lead || "",
      body: body,
      foot: list.length
        ? '<div>掘り下げたいものを選ぶ</div><div>1〜' + list.length + ' キーでも選べる</div>'
        : ''
    }));

    var decide = function(i){
      var c = list[i];
      if(!c || !I.st || I.st.done){ return; }
      var f = I.gf();
      f.s56_trace_try = (f.s56_trace_try || 0) + 1;
      I.se(o.se || "decide.mp3");
      I.goto(o.storage, c.target);
    };

    for(var m=0;m<list.length;m++){
      (function(k){
        var el = document.getElementById("inc-c-" + k);
        if(el){ el.addEventListener("click", function(){ decide(k); }); }
      })(m);
    }

    var okb = document.getElementById("inc-trace-ok");
    if(okb){
      okb.addEventListener("click", function(){
        I.se("decide.mp3");
        I.goto(o.storage, o.target);
      });
    }

    I.keyHandler = function(e){
      if(!I.st || I.st.done){ return; }
      if(list.length){
        var n = parseInt(e.key, 10);
        if(n >= 1 && n <= list.length){
          decide(n - 1);
          e.preventDefault(); e.stopPropagation();
        }
      } else if(e.key === "Enter" || e.key === " " || e.key === "Spacebar"){
        I.se("decide.mp3");
        I.goto(o.storage, o.target);
        e.preventDefault(); e.stopPropagation();
      }
    };
    window.addEventListener("keydown", I.keyHandler, true);
  }
};
[endscript]


;===============================================================================
; [inc_note title="…" text="…"]   画面右上に短い知らせを出す
;===============================================================================
[macro name="inc_note"]
[iscript]
window.INC.toast(mp.title || "記録", mp.text || "");
[endscript]
[endmacro]


;===============================================================================
; [inc_insight id="…" name="…"]   気づきを1件書き留める
;   すでに持っている気づきなら何もしない（知らせも出ない）
;===============================================================================
[macro name="inc_insight"]
[iscript]
if(window.INC.insight(mp.id, mp.name)){
  window.INC.toast("気づきを書き留めた", mp.name || mp.id);
}
[endscript]
[endmacro]


;===============================================================================
; [inc_back place="舞黒館:キッチン"]
;   オーバーレイから戻ってきた直後の画面を元に戻す
;   （メッセージ枠・右下のシステム操作・左上の場所プレート）
;===============================================================================
[macro name="inc_back"]
[cm]
[show_menu]
[layopt layer="message0" visible=true]
[gage_draw place="%place"]
[endmacro]


;===============================================================================
; [inc_urgent]   制限時間つきの即断
;   tf.inc = { storage, tag, title, lead, prompt, limit(秒), timeout, choices:[{text,sub,target}] }
;===============================================================================
[macro name="inc_urgent"]
[cm]
[clearfix]
[hidemenubutton]
[layopt layer="message0" visible=false]
[iscript]
window.INC.markMacro();
window.INC.openUrgent(tf.inc || {});
[endscript]
[s]
[endmacro]


;===============================================================================
; [inc_trace]   出来事を時系列に並べ、そこから掘るものを選ばせる
;   tf.inc = { storage, target, tag, title, lead, prompt,
;              steps:[{time,label,note,link,mark}],
;              faces:[{name,note}],
;              choices:[{text,target}] }
;   choices を省くと「続ける」だけの画面になり、target へ進む。
;===============================================================================
[macro name="inc_trace"]
[cm]
[clearfix]
[hidemenubutton]
[layopt layer="message0" visible=false]
[iscript]
window.INC.markMacro();
window.INC.openTrace(tf.inc || {});
[endscript]
[s]
[endmacro]


[return]
