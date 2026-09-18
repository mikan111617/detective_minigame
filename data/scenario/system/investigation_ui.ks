;===============================================================================
; investigation_ui.ks  ―― 調査パート共通UI（scene4 / scene7 共用）
;
; 構成：
;   investigation_ui.ks   … 共通の描画エンジンとマクロ（このファイル）
;   inv_data_scene4.ks    … scene4（館内調査）の章データ
;   inv_data_scene7.ks    … scene7（毒物捜査）の章データ
;   clue_board.ks         … 手がかりボード
;   get_item.ks           … [get_item] 差し替え版
;
; 読み込み（first.ks）：
;   [call storage="investigation_ui.ks"]
;   [call storage="inv_data_scene4.ks"]
;   [call storage="inv_data_scene7.ks"]
;   [call storage="get_item.ks"]
;
; 各章の頭で章を指定：
;   [inv_set chapter="s4"]      ; scene4
;   [inv_set chapter="s7"]      ; scene7
;
; 画面呼び出し：
;   [inv_map]                   ; 館マップ
;   [inv_room id="living"]      ; 部屋画面
;
; 注意：
;   ・シナリオ本体（イベントラベル）とフラグは一切変更しません。
;     この UI は既存のラベルへジャンプするだけの「見た目の入れ替え」です。
;   ・エンジン本体は window.INV_ENGINE に置き、f.INV はその参照です。
;     セーブデータに関数は保存できないため、[load] 後は INV_READY() で
;     参照を貼り直します（下記 window.INV_READY）。
;===============================================================================

[iscript]
if(typeof f.INV_DATA === 'undefined'){ f.INV_DATA = {}; }

window.INV_ENGINE = {
  GOLD:"#f2d882", NEW:"#e0913c", POISON:"#c65a35", BLUE:"#4e88ad",

  // 見出し・数字はデザイン指定の和桜フォント、本文はゴシック
  TITLE: "'Waosagi',serif",
  BODY:  "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",

  cfg: function(){ return TG.stat.f.INV_DATA[TG.stat.f.inv_chapter] || {}; },

  base: function(){ return document.getElementById("tyrano_base") || document.body; },

  css: function(){
    if(document.getElementById("inv-css")){ return; }
    var st = document.createElement("style");
    st.id = "inv-css";
    st.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}"
      + "@keyframes invpulse{0%,100%{box-shadow:0 0 0 0 rgba(224,145,60,0.55)}"
      + "50%{box-shadow:0 0 0 14px rgba(224,145,60,0)}}"
      + "@keyframes invrise{from{opacity:0;transform:translateY(26px) scale(0.96)}to{opacity:1;transform:none}}"
      + "@keyframes invfade{from{opacity:0}to{opacity:1}}"
      // カードの高さは中身（バッジの折り返し）で変わるので、入りきらない分は縦スクロールで拾う
      + "#inv-overlay .inv-scroll{overflow-y:auto;overflow-x:hidden;scrollbar-width:thin;"
      + "scrollbar-color:#6c4c18 rgba(0,0,0,0)}"
      + "#inv-overlay .inv-scroll::-webkit-scrollbar{width:10px}"
      + "#inv-overlay .inv-scroll::-webkit-scrollbar-track{background:rgba(0,0,0,0)}"
      + "#inv-overlay .inv-scroll::-webkit-scrollbar-thumb{background:#6c4c18;border-radius:5px}"
      + "#inv-overlay .inv-scroll::-webkit-scrollbar-thumb:hover{background:#a07828}";
    document.head.appendChild(st);
  },

  // 発見物の出所（手がかりボード／発見演出の「どこで」表示用）
  setWhere: function(where){ TG.stat.f.inv_cur_where = where || ""; },

  clear: function(){
    var el = document.getElementById("inv-overlay");
    if(el){ el.remove(); }
  },

  mount: function(html){
    window.INV_ENGINE.css();
    window.INV_ENGINE.clear();
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    var el = tmp.firstElementChild;
    window.INV_ENGINE.base().appendChild(el);
    window.INV_ENGINE.bindScroll(el);
    return el;
  },

  esc: function(t){
    return String(t == null ? "" : t)
      .replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")
      .replace(/"/g,"&quot;");
  },

  // TyranoPlayer 側で touchmove が抑止されていても、地図や一覧を指で送れるようにする。
  bindScroll: function(root){
    if(!root){ return; }
    var list = root.querySelectorAll(".inv-scroll");
    for(var i=0;i<list.length;i++){
      (function(el){
        if(el._invScrollBound){ return; }
        el._invScrollBound = true;
        var startY = 0, startTop = 0, scale = 1, dragging = false;
        el.addEventListener("touchstart", function(e){
          if(!e.touches || e.touches.length !== 1){ return; }
          startY = e.touches[0].clientY;
          startTop = el.scrollTop;
          var r = el.getBoundingClientRect();
          scale = (el.offsetHeight > 0 && r.height > 0) ? (r.height / el.offsetHeight) : 1;
          dragging = true;
          el._invSwiped = false;
        }, { passive:true });
        el.addEventListener("touchmove", function(e){
          if(!dragging){ return; }
          var d = startY - e.touches[0].clientY;
          if(Math.abs(d) > 8){
            el._invSwiped = true;
            el.scrollTop = startTop + d / scale;
            if(e.cancelable){ e.preventDefault(); }
          }
        }, { passive:false });
        el.addEventListener("touchend", function(){ dragging = false; }, { passive:true });
        el.addEventListener("touchcancel", function(){ dragging = false; }, { passive:true });
        // スワイプを終えた指が、そのまま部屋カードのクリックにならないようにする。
        el.addEventListener("click", function(e){
          if(!el._invSwiped){ return; }
          e.preventDefault();
          e.stopPropagation();
          el._invSwiped = false;
        }, true);
      })(list[i]);
    }
  },

  // [inv_map] / [inv_room] は本体が [s] で停止するマクロなので、
  // 画面から離脱（jump）するときにマクロスタックを畳んでおく
  markMacro: function(){
    try {
      var st = TG.getStack("macro");
      if(st){ st.__inv = true; }
    } catch(e){}
  },
  popMacro: function(){
    try {
      var arr = TG.stat.stack.macro;
      while(arr && arr.length && arr[arr.length-1] && arr[arr.length-1].__inv){ arr.pop(); }
    } catch(e){}
  },

  fmt: function(min){ return Math.floor(min/60) + ":" + ("0" + (min%60)).slice(-2); },

  // 条件式（文字列）の評価。未指定は true
  test: function(expr){
    if(expr === undefined || expr === null || expr === ""){ return true; }
    if(expr === true){ return true; }
    try { return !!(new Function("f", "return (" + expr + ");"))(TG.stat.f); }
    catch(e){ return false; }
  },

  rooms: function(){ return window.INV_ENGINE.cfg().rooms || []; },

  room: function(id){
    var rs = window.INV_ENGINE.rooms();
    for(var i=0;i<rs.length;i++){ if(rs[i].id === id){ return rs[i]; } }
    return null;
  },

  // 表示対象の調査ポイント（cond を満たすものだけ）
  spots: function(r){
    var out = [], sp = r.spots || [];
    for(var i=0;i<sp.length;i++){ if(window.INV_ENGINE.test(sp[i].cond)){ out.push(sp[i]); } }
    return out;
  },

  // 表示対象の人物（present を満たすものだけ）
  chars: function(r){
    var out = [], cs = r.chars || [];
    for(var i=0;i<cs.length;i++){ if(window.INV_ENGINE.test(cs[i].present)){ out.push(cs[i]); } }
    return out;
  },

  actions: function(r){
    var out = [], as = r.actions || [];
    for(var i=0;i<as.length;i++){ if(window.INV_ENGINE.test(as[i].cond)){ out.push(as[i]); } }
    return out;
  },

  // 宿泊部屋のような「部屋の集合」（hub:true）がまとめている子部屋。
  // 子部屋も rooms 配列に並べ、parent に親の id を書いておく
  subRooms: function(r){
    var INV = window.INV_ENGINE, out = [], ids = r.subs || [];
    for(var i=0;i<ids.length;i++){
      var s = INV.room(ids[i]);
      if(s && INV.test(s.cond)){ out.push(s); }
    }
    return out;
  },

  // 館マップのカードに出すアイコン。ハブは子部屋にいる人をまとめて見せる
  cardChars: function(r){
    var INV = window.INV_ENGINE;
    if(!r.hub){ return INV.chars(r); }
    var subs = INV.subRooms(r), out = [];
    for(var i=0;i<subs.length;i++){ out = out.concat(INV.chars(subs[i])); }
    return out;
  },

  newTopicsForChar: function(c){
    var kf = TG.stat.f, n = 0, ts = c.topics || [];
    for(var i=0;i<ts.length;i++){
      if(window.INV_ENGINE.test(ts[i].cond) && kf[ts[i].flag] != 1){ n++; }
    }
    return n;
  },

  // poison:true は「毒に関係する調査候補」、poisonFlag は実際に増えるカウンター。
  // 調査済みフラグだけで毒発見表示を出すと、カウンターが増えていない場合にも
  // 赤い表示が出るため、必ず対応する poisonFlag の成立まで確認する。
  poisonFound: function(x){
    if(!x || !x.poison || !x.poisonFlag){ return false; }
    return TG.stat.f[x.poisonFlag] == 1;
  },

  // 部屋の進捗（ハブは子部屋の合計）
  stats: function(r){
    var INV = window.INV_ENGINE;
    if(r.hub){
      var subs = INV.subRooms(r), agg = { total:0, done:0, left:0, poison:false, newTopics:0 };
      for(var n=0;n<subs.length;n++){
        var ss = INV.stats(subs[n]);
        agg.total += ss.total; agg.done += ss.done; agg.left += ss.left;
        agg.newTopics += ss.newTopics; agg.poison = agg.poison || ss.poison;
      }
      return agg;
    }
    var kf = TG.stat.f, sp = window.INV_ENGINE.spots(r), done = 0, poison = false, nt = 0;
    for(var i=0;i<sp.length;i++){
      if(kf[sp[i].flag]==1){ done++; if(INV.poisonFound(sp[i])){ poison = true; } }
    }
    var cs = window.INV_ENGINE.chars(r);
    for(var j=0;j<cs.length;j++){
      for(var k=0;k<cs[j].topics.length;k++){
        var t = cs[j].topics[k];
        if(window.INV_ENGINE.test(t.cond) && kf[t.flag]!=1){ nt++; }
        if(kf[t.flag]==1 && INV.poisonFound(t)){ poison = true; }
      }
    }
    var acts = window.INV_ENGINE.actions(r);
    for(var m=0;m<acts.length;m++){ if(kf[acts[m].flag]!=1){ nt++; } }
    return { total:sp.length, done:done, left:sp.length-done, poison:poison, newTopics:nt };
  },

  // 部屋の状態：locked / passage / none / visited / unvisited / clear / untouched / progress
  state: function(r){
    var kf = TG.stat.f;
    if(r.lock && !window.INV_ENGINE.test(r.lock)){ return "locked"; }
    if(r.visitFlag){ return kf[r.visitFlag]==1 ? "visited" : "unvisited"; }
    if(r.passage){ return "passage"; }
    var st = window.INV_ENGINE.stats(r);
    // 調査対象も話題もまだ出てきていない部屋（条件付きの対象が解放前など）
    if(st.total === 0 && st.newTopics === 0){ return "none"; }
    if(st.total > 0 && st.left === 0 && st.newTopics === 0){ return "clear"; }
    if(st.done === 0 && st.newTopics === st.total + st.newTopics){ return "untouched"; }
    return st.done === 0 ? "untouched" : "progress";
  },

  // 章ごとのカウンタ（毒物の手がかり／見つけた手がかり）
  // flagsB を書くと、経路Bの周回だけそちらを数える（evidenceList と同じ約束）。
  // 手口が変われば、残る手がかりの数も変わるため。
  counter: function(){
    var cfg = window.INV_ENGINE.cfg(), kf = TG.stat.f, c = cfg.counter || {};
    var cf = (kf.route_b == 1 && c.flagsB) ? c.flagsB : c.flags;
    if(cf){
      var n = 0;
      for(var i=0;i<cf.length;i++){ if(kf[cf[i]]){ n++; } }
      return { label:c.label || "手がかり", n:n, max:cf.length, dots:true };
    }
    return { label:c.label || "見つけた手がかり", n:(kf.clue_log||[]).length, max:0, dots:false };
  },

  counterHTML: function(){
    var c = window.INV_ENGINE.counter(), h = "";
    h += '<div style="display:flex;align-items:center;gap:14px;padding:11px 18px;'
      + 'background:rgba(24,16,4,0.9);border:1px solid #6c4c18;border-radius:8px">'
      + '<div style="font-size:20px;letter-spacing:0.24em;color:#c9a24e;white-space:nowrap">'+c.label+'</div>';
    if(c.dots){
      h += '<div style="display:flex;gap:8px">';
      for(var i=0;i<c.max;i++){
        var on = i < c.n;
        h += '<div style="width:18px;height:18px;border-radius:50%;'
          + 'background:'+(on?window.INV_ENGINE.POISON:"transparent")+';'
          + 'border:2px solid '+(on?"#e08050":"#4c3410")+';'
          + (on?'box-shadow:0 0 12px rgba(198,90,53,0.7);':'')+'"></div>';
      }
      h += '</div><div style="font-family:'+window.INV_ENGINE.TITLE+';font-size:34px;line-height:1;color:#f6e6b4;white-space:nowrap">'
        + c.n+' / '+c.max+'</div>';
    } else {
      h += '<div style="font-family:'+window.INV_ENGINE.TITLE+';font-size:34px;line-height:1;color:#f6e6b4;white-space:nowrap">'+c.n+' 件</div>';
    }
    return h + '</div>';
  },

  // 収集カウンタ。所持品（ids）でもフラグ（flags）でも数えられる。
  // 何が該当するかは画面に出さず、件数とマーカーだけを見せる。
  // reveal（条件式）を書くと、それを満たすまでは見出しを伏せる（既定は "???"／hidden 表示）。
  // 物語がまだ触れていないもの（地下や設計図など）を見出しで先出ししないための仕組み。
  evidenceList: function(){
    var e = window.INV_ENGINE.cfg().evidence;
    if(!e){ return []; }
    var defs = (e instanceof Array) ? e : [e];
    var kf = TG.stat.f, stt = kf.status || {}, out = [];
    for(var d=0; d<defs.length; d++){
      var def = defs[d], n = 0, max = 0, i, found = [];
      // 所持品とフラグは同じカウンタに混ぜられる（証言のように品物が残らないものがあるため）
      // idsB を持つ定義は、経路Bの周回だけそちらを数える（手口が変わると要る証拠も変わる）
      var ids = (kf.route_b == 1 && def.idsB) ? def.idsB : def.ids;
      if(ids){
        max += ids.length;
        for(i=0;i<ids.length;i++){
          if(stt[ids[i]] && stt[ids[i]].owned){
            n++;
            var item = window.INV_ENGINE.master(ids[i]);
            found.push({
              id:ids[i], kind:"item",
              name:item ? item.name : ids[i],
              text:item ? (item.text_default || "") : "入手済みの証拠品です。",
              secret:(item && stt[ids[i]].secret) ? (item.text_secret || "") : "",
              image:item ? window.INV_ENGINE.itemImage(item) : ""
            });
          }
        }
      }
      var flags = (kf.route_b == 1 && def.flagsB) ? def.flagsB : def.flags;
      var flagInfo = (kf.route_b == 1 && def.flagInfoB) ? def.flagInfoB : (def.flagInfo || {});
      if(flags){
        max += flags.length;
        for(i=0;i<flags.length;i++){
          if(kf[flags[i]] == 1){
            n++;
            var fi = flagInfo[flags[i]] || {};
            found.push({ id:flags[i], kind:"record", name:fi.name || "確認済みの情報", text:fi.text || "調査中に確認した証言・鑑識情報です。", secret:"", image:"" });
          }
        }
      }
      if(max === 0){ continue; }
      var label = def.label || "証拠品", kind = def.kind || "item";
      // まだプレイヤーが知らないものは見出しを伏せる（進んだ数だけを見せる）
      if(def.reveal !== undefined && !window.INV_ENGINE.test(def.reveal)){
        label = def.hiddenLabel || "???";
        kind  = "hidden";
      }
      // unlock（条件式）を満たせない周回では、見出しにバツ印を重ねて選べないことを示す。
      // 押したときは lockNote を出す（真エンド条件のように、昼の探索で取り逃すと戻れないもの）。
      var locked = (def.unlock !== undefined && !window.INV_ENGINE.test(def.unlock));
      out.push({ label:label, kind:kind, n:n, max:max, found:found, locked:locked, lockNote:def.lockNote || "" });
    }
    return out;
  },

  evidenceHTML: function(){
    var list = window.INV_ENGINE.evidenceList(), h = "";
    for(var k=0; k<list.length; k++){
      var e = list[k], done = (e.n >= e.max), hidden = (e.kind === "hidden");
      // 伏せているものは青系、通常の証拠品は金系で色分けする
      var accent = hidden ? "#8fc3dd" : "#c8a060";
      var on_bd  = hidden ? "#a8d6ea" : "#e8c86a";
      var glow   = hidden ? "rgba(120,190,220,0.6)" : "rgba(200,160,96,0.6)";
      h += '<div onclick="window.invEvidence('+k+')" title="クリックして詳細を確認" style="position:relative;display:flex;align-items:center;gap:12px;padding:11px 18px;cursor:pointer;'
        + 'background:rgba(24,16,4,0.9);border:1px solid '+(done?accent:"#6c4c18")+';border-radius:8px">'
        + '<div style="font-size:20px;letter-spacing:0.24em;white-space:nowrap;'
          + 'color:'+(hidden?"#8fc3dd":"#c9a24e")+';'+(e.locked?'opacity:0.45;':'')+'">'+e.label+'</div>'
        + '<div style="display:flex;gap:7px;'+(e.locked?'opacity:0.45;':'')+'">';
      for(var i=0;i<e.max;i++){
        var flag = i < e.n;
        h += '<div style="width:13px;height:13px;transform:rotate(45deg);'
          + 'background:'+(flag?accent:"transparent")+';'
          + 'border:2px solid '+(flag?on_bd:"#4c3410")+';'
          + (flag?'box-shadow:0 0 10px '+glow+';':'')+'"></div>';
      }
      h += '</div><div style="font-family:'+window.INV_ENGINE.TITLE+';font-size:34px;line-height:1;'
        + 'color:#f6e6b4;white-space:nowrap;'+(e.locked?'opacity:0.45;':'')+'">'+e.n+' / '+e.max+'</div>'
        + '<div style="font-size:16px;color:#8a6a30;white-space:nowrap">詳細 ›</div>';
      if(e.locked){
        // 欄全体にバツ印を重ねる（クリックは下の欄へ通す）
        h += '<svg viewBox="0 0 100 100" preserveAspectRatio="none" style="position:absolute;inset:0;width:100%;height:100%;pointer-events:none">'
          + '<line x1="3" y1="8" x2="97" y2="92" stroke="#c0503a" stroke-width="5" vector-effect="non-scaling-stroke" stroke-linecap="round"/>'
          + '<line x1="97" y1="8" x2="3" y2="92" stroke="#c0503a" stroke-width="5" vector-effect="non-scaling-stroke" stroke-linecap="round"/></svg>';
      }
      h += '</div>';
    }
    return h;
  },

  master: function(id){
    var md = TG.stat.f.master_data || [];
    for(var i=0;i<md.length;i++){ if(md[i].id === id){ return md[i]; } }
    return null;
  },

  itemImage: function(item){
    if(!item || !item.image){ return ""; }
    return "./data/" + ((item.type === "chara") ? "fgimage/chara/" : "image/item/") + item.image;
  },

  memo: function(){
    var ms = window.INV_ENGINE.cfg().memo || [];
    for(var i=0;i<ms.length;i++){
      if(window.INV_ENGINE.test(ms[i].cond)){ return ms[i]; }
    }
    return null;
  },

  // 注意：マクロ本体の実行中は current_scenario が investigation_ui.ks になるため、
  // ジャンプ先は必ず章設定の storage（scene4.ks / scene7.ks）を明示する
  // 押したクリックがそのままゲーム画面へ届くと、飛んだ先の最初の [p] を
  // 送ってしまう。伝播が終わってから飛ぶようにし、直後の数百ミリ秒は
  // クリックを吸い取る覆いを置く。
  shield: function(){
    var old = document.getElementById("inv-shield");
    if(old && old.parentNode){ old.parentNode.removeChild(old); }
    var d = document.createElement("div");
    d.id = "inv-shield";
    d.style.cssText = "position:absolute;inset:0;z-index:999999999;background:transparent";
    d.addEventListener("click", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    d.addEventListener("pointerdown", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    window.INV_ENGINE.base().appendChild(d);
    setTimeout(function(){ if(d.parentNode){ d.parentNode.removeChild(d); } }, 260);
  },

  // 調査画面の右上に出す「資料／MENU」。ノベルパートの HUD と同じ操作を、
  // 調査画面（館マップ・部屋の扉・部屋）からも押せるようにする。
  sysHTML: function(){
    function btn(label, fn){
      return '<button onclick="' + fn + '" style="padding:12px 22px;background:rgba(18,12,3,0.92);'
        + 'border:1px solid #6c4c18;border-radius:6px;color:#e8c86a;font-size:20px;font-family:inherit;'
        + 'cursor:pointer;letter-spacing:0.12em;white-space:nowrap">' + label + '</button>';
    }
    return '<div style="display:flex;align-items:center;gap:10px">'
      + btn("資料", "window.invNotebook()")
      + btn("MENU", "window.invMenu()")
      + '</div>';
  },

  // いま出している調査画面のラベル。資料から戻るとき・ロード後の描き直しに使う
  markScreen: function(target){ TG.stat.f.inv_screen_target = target || ""; },

  go: function(label){
    TG.stat.f.inv_screen_target = "";
    var INV = window.INV_ENGINE;
    INV.clear();
    INV.shield();
    setTimeout(function(){
      INV.popMacro();
      TG.ftag.startTag("jump", { storage: INV.cfg().storage, target: label });
    }, 0);
  },

  toHub: function(){
    TG.variable.tf.inv_talk = "";
    window.INV_ENGINE.clear();
    window.INV_ENGINE.popMacro();
    TG.ftag.startTag("jump", { storage: window.INV_ENGINE.cfg().storage, target: window.INV_ENGINE.cfg().hubTarget });
  }
};

// 資料（手帳）を開く。閉じると、開いたときの調査画面へ戻る
window.invNotebook = function(){
  var INV = window.INV_ENGINE;
  TG.stat.f.inv_nb_return = TG.stat.f.inv_screen_target || INV.cfg().hubTarget;
  INV.clear();
  INV.shield();
  setTimeout(function(){
    INV.popMacro();
    TG.ftag.startTag("jump", { storage:"system/item_list.ks", target:"*inv_view_mode" });
  }, 0);
};

// MENU を開く。調査画面は重ねずにいったん隠し、メニューを閉じたら出し直す
window.invMenu = function(){
  var el = document.getElementById("inv-overlay");
  if(el){ el.style.display = "none"; }
  TG.menu.showMenu();
  var shown = false;
  var seq = window.INV_ENGINE._load_seq || 0;
  var timer = setInterval(function(){
    // ロードした場合は、隠したままの古い画面を捨てる（make.ks が描き直す）
    if((window.INV_ENGINE._load_seq || 0) !== seq){
      clearInterval(timer);
      var old = document.getElementById("inv-overlay");
      if(old && old.style.display === "none"){ old.remove(); }
      return;
    }
    // タイトルへ戻るなど、調査画面を離れたときも出し直さない
    if(String(TG.stat.current_scenario || "").indexOf("investigation_ui") === -1){
      clearInterval(timer);
      window.INV_ENGINE.clear();
      return;
    }
    var menu = TG.layer.getMenuLayer();
    var open = menu && menu.length && menu.css("display") !== "none" && menu.children().length > 0;
    if(open){ shown = true; return; }
    if(!shown){ return; }   // メニューの読み込み待ち
    clearInterval(timer);
    var back = document.getElementById("inv-overlay");
    if(back){ back.style.display = ""; }
  }, 150);
};

// ロードが起きたことを数えておく（MENU を閉じたときに、ロード前の画面を
// 出し直してしまわないようにするため）。画面の描き直しは make.ks で行う。
window.INV_ENGINE._load_seq = window.INV_ENGINE._load_seq || 0;
if(!window.INV_ENGINE._load_hooked){
  window.INV_ENGINE._load_hooked = true;
  TG.on("load-start", function(){
    window.INV_ENGINE._load_seq = (window.INV_ENGINE._load_seq || 0) + 1;
  });
}

// [load] でセーブデータを流し込むと f.INV の関数が失われるため、参照を貼り直す
window.INV_READY = function(){
  var kf = TG.stat.f;
  if(typeof kf.INV_DATA === 'undefined'){ kf.INV_DATA = {}; }
  if(!kf.INV || typeof kf.INV.cfg !== 'function'){ kf.INV = window.INV_ENGINE; }
};

f.INV = window.INV_ENGINE;
[endscript]


;===============================================================================
; [inv_set chapter="s4"]  章の切り替え
;===============================================================================
[macro name="inv_set"]
[eval exp="f.inv_chapter = mp.chapter"]
[iscript]
window.INV_READY();
[endscript]
[endmacro]


;===============================================================================
; [inv_map]  館マップ（部屋ごとのカード式ハブ）
;   前提：直前に [bg] で背景を出しておく
;   選択結果は章設定の destVar に入り、dispatchTarget へジャンプします
;===============================================================================
[macro name="inv_map"]
[iscript]
window.INV_READY();
(function(){
  var kf = TG.stat.f, INV = f.INV, cfg = INV.cfg();
  INV.markMacro();
  INV.markScreen(cfg.hubTarget);
  // マップに戻った時点で「今いる部屋／発見の出所」はクリアする
  kf.inv_cur_room = "";
  kf.inv_cur_room_id = "";
  kf.inv_cur_where = "";
  var floorVar = cfg.floorVar;
  if(kf[floorVar] !== 2){ kf[floorVar] = 1; }

  var gt = kf.game_time || 0;
  var remain = Math.max(0, cfg.endMin - gt);
  var span = cfg.endMin - (cfg.startMin || (cfg.endMin - 60));
  var remainPct = Math.max(0, Math.min(100, Math.round(remain / span * 100)));

  var CHIP = {
    untouched:{ label:"未調査",   bg:"rgba(190,110,40,0.94)", bd:"#e0913c", fg:"#2a1602" },
    progress: { label:"調査中",   bg:"rgba(40,27,7,0.92)",    bd:"#a07828", fg:INV.GOLD },
    clear:    { label:"調査済",   bg:"rgba(12,9,3,0.92)",     bd:"#3c2a0c", fg:"#6c5220" },
    passage:  { label:"通路",     bg:"rgba(20,14,4,0.92)",    bd:"#4c3410", fg:"#8a6a30" },
    none:     { label:"調査対象なし", bg:"rgba(20,14,4,0.92)",  bd:"#4c3410", fg:"#8a6a30" },
    locked:   { label:"立入不可", bg:"rgba(20,13,3,0.96)",    bd:"#5c3e14", fg:"#8a6028" },
    unvisited:{ label:"未訪問",   bg:"rgba(190,110,40,0.94)", bd:"#e0913c", fg:"#2a1602" },
    visited:  { label:"訪問済",   bg:"rgba(12,9,3,0.92)",     bd:"#3c2a0c", fg:"#6c5220" }
  };

  function card(r){
    var st = INV.stats(r), s = INV.state(r), chip = CHIP[s] || CHIP.progress;
    var dark = (s === "clear" || s === "locked" || s === "visited" || s === "none");
    var hot  = (s === "untouched" || s === "unvisited");

    var badges = "";
    function badge(text, bg, bd, fg){
      badges += '<div style="padding:7px 16px;border-radius:4px;font-size:20px;letter-spacing:0.08em;'
        + 'white-space:nowrap;background:'+bg+';border:1px solid '+bd+';color:'+fg+'">'+text+'</div>';
    }
    if(s === "locked"){ badge(r.lockNote || "まだ入れない", "rgba(255,255,255,0.03)", "#33230a", "#8a6028"); }
    else {
      if(st.left > 0){ badge("未調査 "+st.left+"件", "rgba(224,145,60,0.16)", INV.NEW, "#f0ab62"); }
      if(st.newTopics > 0){ badge("新しい話題 "+st.newTopics, "rgba(80,150,190,0.16)", INV.BLUE, "#8fc3dd"); }
      if(badges === ""){
        badge((r.passage || s === "none") ? "調査対象なし"
                : (s === "unvisited" ? "行ってみる" : "すべて調査済"),
              "rgba(255,255,255,0.03)", "#33230a", "#5a4218");
      }
    }

    var avatars = "";
    var cs = INV.cardChars(r);
    for(var i=0;i<cs.length;i++){
      var cnt = INV.newTopicsForChar(cs[i]);
      avatars += '<div style="position:relative;width:38px;height:38px;border-radius:50%;background:'+cs[i].color+';'
        + 'border:2px solid #0a0702;box-shadow:0 2px 8px rgba(0,0,0,0.8);display:flex;align-items:center;'
        + 'justify-content:center;font-size:19px;color:#fff;flex-shrink:0;'
        + (i?'margin-left:-9px;':'')+'">'+cs[i].initial
        + (cnt ? '<span style="position:absolute;right:-6px;top:-9px;width:22px;height:22px;border-radius:50%;'
          + 'display:flex;align-items:center;justify-content:center;background:#4e88ad;border:2px solid #0a0702;'
          + 'font-size:15px;font-weight:bold;color:#fff">!</span>' : '')+'</div>';
    }

    var pct = st.total ? Math.round(st.done / st.total * 100) : 0;
    var clickable = (s !== "locked") && r.target;
    var click = clickable ? ' onclick="window.invGo(\''+r.id+'\')"' : "";

    var h = '<div'+click+' style="border-radius:12px;overflow:hidden;background:rgba(13,9,3,0.94);'
      + 'border:1px solid '+(hot ? "#8a5c1e" : "#33230a")+';'
      + 'cursor:'+(clickable?"pointer":"not-allowed")+';opacity:'+(s==="locked"?0.55:1)+'">';

    h += '<div style="position:relative;height:186px;overflow:hidden">'
      + '<img src="./data/bgimage/'+r.bg+'" style="width:100%;height:100%;object-fit:cover;'
      + 'filter:'+(dark?"grayscale(0.7) brightness(0.5)":"brightness(0.82)")+'">'
      + '<div style="position:absolute;inset:0;background:linear-gradient(180deg,rgba(8,5,1,0.1),rgba(8,5,1,0.94))"></div>'
      + '<div style="position:absolute;top:14px;right:16px;padding:7px 16px;border-radius:4px;font-size:20px;'
        + 'letter-spacing:0.1em;white-space:nowrap;background:'+chip.bg+';border:1px solid '+chip.bd+';'
        + 'color:'+chip.fg+'">'+chip.label+'</div>';
    if(st.poison){
      h += '<div style="position:absolute;top:14px;left:16px;padding:7px 14px;border-radius:4px;font-size:18px;'
        + 'letter-spacing:0.12em;white-space:nowrap;background:rgba(190,70,40,0.92);color:#ffe9d2">毒の手がかり発見済</div>';
    }
    if(st.newTopics > 0){
      h += '<div style="position:absolute;top:'+(st.poison?58:14)+'px;left:16px;padding:7px 14px;border-radius:4px;'
        + 'font-size:18px;font-weight:bold;letter-spacing:0.1em;white-space:nowrap;'
        + 'background:rgba(54,112,150,0.96);border:1px solid #8fc3dd;color:#eef9ff">！ 新規会話</div>';
    }
    h += '<div style="position:absolute;left:20px;right:20px;bottom:16px;display:flex;align-items:center;gap:12px">'
      + '<div style="font-family:'+INV.TITLE+';font-size:38px;line-height:1.05;color:#f6e6b4;'
        + 'text-shadow:0 2px 10px rgba(0,0,0,0.8)">'+r.name+'</div>'
      + '<div style="flex:1;min-width:8px"></div>'
      + '<div style="display:flex;align-items:center;flex-shrink:0">'+avatars+'</div>'
      + '<div style="font-size:20px;color:#c9a24e;letter-spacing:0.1em;flex-shrink:0">'
        +(r.floorLabel || (r.floor+'F'))+'</div></div></div>';

    h += '<div style="padding:18px 20px 20px 20px;display:flex;flex-direction:column;gap:14px">'
      + '<div style="display:flex;align-items:center;gap:12px">'
        + '<div style="flex:1;height:10px;background:#1c1204;border-radius:5px;overflow:hidden">'
        + '<div style="height:100%;width:'+pct+'%;background:linear-gradient(90deg,#c8a060,#8a5c1e)"></div></div>'
        + '<div style="font-size:22px;color:#d8b050;white-space:nowrap">'
        + (st.total ? st.done+" / "+st.total : "—")+'</div></div>'
      + '<div style="display:flex;align-items:center;gap:10px;min-height:44px;flex-wrap:wrap">'+badges
        + '</div></div></div>';
    return h;
  }

  function tab(n){
    var on = (kf[floorVar] === n);
    return '<button onclick="window.invFloor('+n+')" style="padding:12px 42px;font-size:26px;'
      + 'font-family:inherit;cursor:pointer;border-radius:6px;letter-spacing:0.2em;white-space:nowrap;'
      + 'border:1px solid '+(on?"#c8a060":"#33230a")+';'
      + 'background:'+(on?"rgba(40,27,7,0.95)":"rgba(12,8,2,0.9)")+';'
      + 'color:'+(on?INV.GOLD:"#5a4218")+'">'+n+' F</button>';
  }

  function grid(floor){
    var rs = INV.rooms();
    var h = '<div style="display:grid;grid-template-columns:repeat(4,1fr);gap:24px">';
    // 子部屋（parent 付き）はハブのカードにまとめるので、マップには単独で出さない
    for(var i=0;i<rs.length;i++){ if(rs[i].floor === floor && !rs[i].parent){ h += card(rs[i]); } }
    return h + '</div>';
  }

  var h = '<div id="inv-overlay" style="position:absolute;top:0;left:0;width:100%;height:100%;z-index:999999998;'
    + 'display:flex;flex-direction:column;font-family:'+INV.BODY+';'
    + 'color:#e8dcc0;box-sizing:border-box;animation:invfade .3s ease-out">';

  h += '<img src="./data/bgimage/'+(cfg.mapBg||"hallway_night.png")+'" alt="" '
    + 'style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;'
    + 'opacity:0.22;filter:saturate(0.7)">'
    + '<div style="position:absolute;inset:0;background:radial-gradient(120% 90% at 50% 0%,'
    + 'rgba(10,7,2,0.72),rgba(6,4,1,0.97))"></div>';

  h += '<div style="position:relative;display:flex;align-items:center;gap:28px;padding:26px 48px;'
    + 'background:linear-gradient(180deg,rgba(14,10,3,0.96),rgba(10,7,2,0.82));border-bottom:1px solid #5c3e14">'
    + '<div style="display:flex;flex-direction:column;gap:6px">'
      + '<div style="font-size:20px;letter-spacing:0.42em;color:#8a6a30">INVESTIGATION</div>'
      + '<div style="font-family:'+INV.TITLE+';font-size:40px;color:#f2d882;letter-spacing:0.06em">'+cfg.title+'</div></div>'
    + '<div style="flex:1"></div>'
    + '<div style="display:flex;flex-direction:column;align-items:flex-end;gap:4px">'
      + '<div style="font-size:18px;letter-spacing:0.3em;color:#8a6a30">現在時刻</div>'
      + '<div style="font-family:'+INV.TITLE+';font-size:52px;line-height:1;color:#f6e6b4">'+INV.fmt(gt)+'</div></div>'
    + '<div style="width:1px;height:64px;background:#3c2a0c"></div>'
    + '<div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">'
      + '<div style="font-size:18px;letter-spacing:0.3em;color:#8a6a30;white-space:nowrap">'+cfg.endLabel+'</div>'
      + '<div style="display:flex;align-items:center;gap:10px">'
        + '<div style="font-size:34px;line-height:1;color:#d97a4a;font-weight:600">'+INV.fmt(remain)+'</div>'
        + '<div style="width:170px;height:8px;background:#241704;border-radius:4px;overflow:hidden">'
        + '<div style="height:100%;width:'+remainPct+'%;background:linear-gradient(90deg,#d97a4a,#8a4420)"></div>'
      + '</div></div></div>'
    + INV.sysHTML() + '</div>';

  // カウンタが増えても押し出されないよう折り返しを許可する。
  // 伸縮する余白（flex:1）を挟むと、折り返したときに一行目へ大きな空白が
  // 残ってしまうので置かない。左から順に詰めて、あふれた分だけ下へ回す。
  h += '<div style="position:relative;display:flex;align-items:center;flex-wrap:wrap;gap:14px;padding:18px 48px;'
    + 'background:rgba(9,6,2,0.86);border-bottom:1px solid #2e1f08">'
    + '<div style="display:flex;gap:12px;margin-right:14px">'+tab(1)+tab(2)+'</div>'
    + INV.counterHTML()
    + INV.evidenceHTML()
    + ((cfg.memo && cfg.memo.length) ? '<button onclick="window.invMemo()" style="display:flex;align-items:center;gap:10px;padding:14px 24px;'
      + 'background:rgba(38,30,18,0.96);border:1px solid #8fc3dd;border-radius:8px;color:#dff4ff;'
      + 'font-size:22px;font-family:inherit;cursor:pointer;letter-spacing:0.1em;white-space:nowrap">'
      + '<span style="font-size:24px;color:#8fc3dd">◇</span>捜査メモ</button>' : '')
    + '<button onclick="window.invBoard()" style="display:flex;align-items:center;gap:12px;padding:14px 28px;'
      + 'background:rgba(30,20,5,0.95);border:1px solid #a07828;border-radius:8px;color:#f2d882;'
      + 'font-size:22px;font-family:inherit;cursor:pointer;letter-spacing:0.1em;white-space:nowrap">'
      + '手がかりボード<span style="min-width:34px;padding:2px 10px;border-radius:17px;background:#c8a060;'
      + 'color:#0a0702;font-size:20px;font-weight:700;text-align:center">'+((kf.clue_log||[]).length)+'</span></button></div>';

  // バッジが2行になるとカードが伸びて下が切れるため、この領域はスクロールさせる
  h += '<div class="inv-scroll" style="position:relative;flex:1;min-height:0;padding:22px 48px 22px 48px">'
    + '<div style="display:'+(kf[floorVar]===1?"block":"none")+'">'+grid(1)+'</div>'
    + '<div style="display:'+(kf[floorVar]===2?"block":"none")+'">'+grid(2)+'</div></div>';

  h += '<div style="position:relative;display:flex;align-items:center;gap:20px;padding:26px 48px;'
    + 'background:linear-gradient(0deg,rgba(14,10,3,0.98),rgba(10,7,2,0.6))">'
    + '<div style="font-size:20px;color:#7a5c28">'+(cfg.hint||"")+'</div>'
    + '<div style="flex:1"></div>'
    + '<button onclick="window.invGo(\'exit\')" style="padding:16px 40px;background:#c8a060;border:none;'
      + 'border-radius:6px;color:#0a0702;font-size:24px;font-weight:700;font-family:inherit;cursor:pointer;'
      + 'letter-spacing:0.12em;white-space:nowrap">'+(cfg.exitLabel||"調査を終える")+'</button></div>';

  h += '</div>';
  INV.mount(h);

  window.invCloseModal = function(){
    var old = document.getElementById("inv-modal");
    if(old && old.parentNode){ old.parentNode.removeChild(old); }
  };

  // 捜査の答えではなく、今つなぐべき考え方だけを示す段階式メモ。
  window.invMemo = function(){
    var memo = INV.memo();
    if(!memo){ return; }
    window.invCloseModal();
    var root = document.getElementById("inv-overlay");
    if(!root){ return; }
    var tmp = document.createElement("div");
    tmp.innerHTML = '<div id="inv-modal" style="position:absolute;inset:0;z-index:80;display:flex;align-items:center;'
      + 'justify-content:center;background:rgba(3,2,1,0.82);padding:70px;box-sizing:border-box">'
      + '<div style="width:1050px;max-height:820px;display:flex;flex-direction:column;background:linear-gradient(160deg,#1f1608,#0d0904);'
        + 'border:1px solid #8fc3dd;border-radius:12px;box-shadow:0 28px 80px rgba(0,0,0,.75);overflow:hidden">'
      + '<div style="display:flex;align-items:center;gap:18px;padding:24px 30px;border-bottom:1px solid #3f6070">'
        + '<div style="font-size:18px;letter-spacing:.34em;color:#6fa2bd">INVESTIGATION NOTE</div>'
        + '<div style="flex:1"></div><button onclick="window.invCloseModal()" style="padding:10px 22px;background:#18232a;'
          + 'border:1px solid #6fa2bd;border-radius:6px;color:#dff4ff;font-size:20px;font-family:inherit;cursor:pointer">閉じる</button></div>'
      + '<div class="inv-scroll" style="padding:36px 42px 42px;overflow-y:auto">'
        + '<div style="font-family:'+INV.TITLE+';font-size:40px;color:#dff4ff;letter-spacing:.08em">'+INV.esc(memo.title||"次に考えること")+'</div>'
        + '<div style="margin-top:26px;font-size:28px;line-height:1.75;color:#e8dcc0;white-space:pre-line">'+INV.esc(memo.text||"")+'</div>'
        + '<div style="margin-top:30px;padding:22px 26px;border-left:5px solid #8fc3dd;background:rgba(78,136,173,.13);'
          + 'font-size:27px;line-height:1.65;color:#cfe8f5;white-space:pre-line">'+INV.esc(memo.question||"")+'</div>'
      + '</div></div></div>';
    var modal = tmp.firstElementChild;
    root.appendChild(modal);
    INV.bindScroll(modal);
  };

  // 上部の収集欄を押すと、入手済みの証拠・証言だけを一覧と詳細で読み返せる。
  window.invEvidence = function(k){
    var list = INV.evidenceList(), e = list[k];
    if(!e){ return; }
    window.invCloseModal();
    var root = document.getElementById("inv-overlay");
    if(!root){ return; }
    // この周回では解放できない欄は、中身を見せずに解放条件だけを出す
    if(e.locked){
      var lk = document.createElement("div");
      lk.innerHTML = '<div id="inv-modal" onclick="window.invCloseModal()" style="position:absolute;inset:0;z-index:80;display:flex;align-items:center;'
        + 'justify-content:center;background:rgba(3,2,1,0.82);padding:70px;box-sizing:border-box">'
        + '<div onclick="event.stopPropagation()" style="width:820px;background:linear-gradient(160deg,#1f1608,#0d0904);'
          + 'border:1px solid #c0503a;border-radius:12px;box-shadow:0 28px 80px rgba(0,0,0,.75);overflow:hidden">'
        + '<div style="display:flex;align-items:center;gap:18px;padding:22px 30px;border-bottom:1px solid #5c2c20">'
          + '<div style="font-family:'+INV.TITLE+';font-size:38px;color:#e8b0a0;letter-spacing:.1em">'+INV.esc(e.label)+'</div>'
          + '<div style="flex:1"></div><button onclick="window.invCloseModal()" style="padding:10px 22px;background:#2a1208;'
            + 'border:1px solid #c0503a;border-radius:6px;color:#f2d0c4;font-size:20px;font-family:inherit;cursor:pointer">閉じる</button></div>'
        + '<div style="padding:44px 42px 48px;font-size:30px;line-height:1.7;color:#e8dcc0;text-align:center">'
          + INV.esc(e.lockNote || "解放されていません") + '</div>'
        + '</div></div>';
      root.appendChild(lk.firstElementChild);
      return;
    }
    var rows = "";
    for(var i=0;i<e.found.length;i++){
      rows += '<button onclick="window.invEvidenceSelect('+i+')" style="width:100%;display:flex;align-items:center;gap:14px;'
        + 'padding:15px 18px;background:rgba(255,255,255,.035);border:1px solid #4c3410;border-radius:7px;'
        + 'color:#f0dca8;font-size:22px;line-height:1.35;text-align:left;font-family:inherit;cursor:pointer">'
        + '<span style="color:#c8a060">◆</span><span>'+INV.esc(e.found[i].name)+'</span></button>';
    }
    if(rows === ""){
      rows = '<div style="padding:30px 14px;color:#7a5c28;font-size:22px;line-height:1.6">まだ参照できる情報はありません。</div>';
    }
    var tmp = document.createElement("div");
    tmp.innerHTML = '<div id="inv-modal" style="position:absolute;inset:0;z-index:80;display:flex;align-items:center;'
      + 'justify-content:center;background:rgba(3,2,1,0.84);padding:55px;box-sizing:border-box">'
      + '<div style="width:1540px;height:900px;display:flex;flex-direction:column;background:linear-gradient(160deg,#201607,#0d0904);'
        + 'border:1px solid #a07828;border-radius:12px;box-shadow:0 28px 80px rgba(0,0,0,.78);overflow:hidden">'
      + '<div style="display:flex;align-items:center;gap:22px;padding:22px 30px;border-bottom:1px solid #5c3e14">'
        + '<div style="font-family:'+INV.TITLE+';font-size:38px;color:#f2d882;letter-spacing:.1em">'+INV.esc(e.label)+'</div>'
        + '<div style="font-size:22px;color:#9b7c3d">'+e.n+' / '+e.max+'</div><div style="flex:1"></div>'
        + '<button onclick="window.invCloseModal()" style="padding:10px 22px;background:#2a1b08;border:1px solid #a07828;'
          + 'border-radius:6px;color:#f2d882;font-size:20px;font-family:inherit;cursor:pointer">閉じる</button></div>'
      + '<div style="display:flex;flex:1;min-height:0">'
        + '<div class="inv-scroll" style="width:560px;overflow-y:auto;padding:24px;box-sizing:border-box;border-right:1px solid #3c2a0c;'
          + 'display:flex;flex-direction:column;gap:12px">'+rows+'</div>'
        + '<div class="inv-scroll" style="flex:1;min-width:0;overflow-y:auto;padding:34px 42px;box-sizing:border-box">'
          + '<div id="inv-evidence-empty" style="height:100%;display:flex;align-items:center;justify-content:center;'
            + 'font-size:25px;color:#7a5c28">左の一覧から選んでください</div>'
          + '<div id="inv-evidence-detail" style="display:none">'
            + '<div style="display:flex;gap:32px;align-items:flex-start">'
              + '<div id="inv-evidence-photo-wrap" style="width:260px;height:320px;flex-shrink:0;padding:10px;box-sizing:border-box;'
                + 'background:#160e05;border:1px solid #6c4c18"><img id="inv-evidence-photo" style="width:100%;height:100%;object-fit:contain"></div>'
              + '<div style="flex:1;min-width:0"><div id="inv-evidence-kind" style="font-size:18px;letter-spacing:.22em;color:#8a6a30"></div>'
                + '<div id="inv-evidence-name" style="margin-top:8px;font-family:'+INV.TITLE+';font-size:42px;line-height:1.3;color:#f2d882"></div>'
                + '<div id="inv-evidence-text" style="margin-top:26px;font-size:26px;line-height:1.75;color:#e8dcc0;white-space:pre-line"></div>'
              + '</div></div></div></div></div></div></div>';
    var modal = tmp.firstElementChild;
    root.appendChild(modal);
    INV.bindScroll(modal);
    window._invEvidenceEntries = e.found;
    window.invEvidenceSelect = function(i){
      var x = window._invEvidenceEntries[i];
      if(!x){ return; }
      document.getElementById("inv-evidence-empty").style.display = "none";
      document.getElementById("inv-evidence-detail").style.display = "block";
      document.getElementById("inv-evidence-kind").textContent = (x.kind === "item") ? "証拠品" : "証言・鑑識";
      document.getElementById("inv-evidence-name").textContent = x.name;
      document.getElementById("inv-evidence-text").textContent = x.text + (x.secret ? "\n\n【追加情報】\n"+x.secret : "");
      var wrap = document.getElementById("inv-evidence-photo-wrap"), img = document.getElementById("inv-evidence-photo");
      if(x.image){
        wrap.style.display = "block";
        img.onerror = function(){ wrap.style.display = "none"; };
        img.src = x.image;
      }else{
        wrap.style.display = "none";
        img.removeAttribute("src");
      }
    };
    if(e.found.length){ window.invEvidenceSelect(0); }
  };

  window.invFloor = function(n){
    TG.stat.f[floorVar] = n;
    f.INV.toHub();
  };
  window.invGo = function(id){
    var cf = f.INV.cfg();
    f.INV.clear();
    f.INV.popMacro();
    TG.stat.f[cf.destVar] = id;
    var r = f.INV.room(id);
    TG.stat.f[cf.floorVar] = (r && r.floor === 2) ? 2 : 1;
    TG.ftag.startTag("jump", { storage: cf.storage, target: cf.dispatchTarget });
  };
  window.invBoard = function(){
    f.INV.clear();
    f.INV.popMacro();
    TG.ftag.startTag("jump", { storage:"system/clue_board.ks" });
  };
})();
[endscript]
[s]
[endmacro]


;===============================================================================
; [inv_wing id="bedroom"]  部屋の集合（宿泊部屋など）の扉選択画面
;   前提：直前に [bg] で背景を出しておく
;   章データで hub:true と subs:[子部屋の id...] を指定した部屋で使います。
;   扉を選ぶと、その子部屋の target へ入ります（[inv_room] で描く）。
;===============================================================================
[macro name="inv_wing"]
[iscript]
window.INV_READY();
(function(){
  var kf = TG.stat.f, INV = f.INV;
  var r = INV.room(mp.id);
  INV.markMacro();
  // 章データに無い部屋を指定された場合は館マップへ戻す（進行不能を防ぐ）
  if(!r){ INV.toHub(); return; }
  INV.markScreen(r.target);
  // ハブ自体は調査対象を持たない。発見物の出所が混ざらないようクリアしておく
  kf.inv_cur_room = r.name;
  kf.inv_cur_room_id = r.id;
  kf.inv_cur_where = "";
  tf.inv_talk = "";

  var subs = INV.subRooms(r);
  var ws = INV.stats(r);

  // 扉の枚数で列数を決める。5部屋になったとき折り返して見切れていたので、
  // 多いときは札を低くして一行に収める
  var cols   = Math.min(subs.length, 5);
  var artH   = subs.length > 4 ? 210 : 300;
  var plateW = subs.length > 4 ?  92 : 118;
  var plateH = subs.length > 4 ? 130 : 168;
  var plateF = subs.length > 4 ?  48 :  62;

  function door(s, i){
    var st = INV.stats(s), stt = INV.state(s);
    var none  = (stt === "none");
    var clear = (stt === "clear" || none), fresh = (stt === "untouched" || stt === "unvisited");
    var chipBg = clear ? "rgba(12,9,3,0.92)" : (fresh ? "rgba(190,110,40,0.94)" : "rgba(40,27,7,0.92)");
    var chipBd = clear ? "#3c2a0c"           : (fresh ? "#e0913c"               : "#a07828");
    var chipFg = clear ? "#6c5220"           : (fresh ? "#2a1602"               : INV.GOLD);
    var chipTx = none ? "調査対象なし" : (clear ? "調査済" : (fresh ? "未調査" : "調査中"));

    var avatars = "";
    var cs = INV.chars(s);
    for(var a=0;a<cs.length;a++){
      var cnt = INV.newTopicsForChar(cs[a]);
      avatars += '<div style="position:relative;width:40px;height:40px;border-radius:50%;background:'+cs[a].color+';'
        + 'border:2px solid #0a0702;box-shadow:0 2px 8px rgba(0,0,0,0.8);display:flex;align-items:center;'
        + 'justify-content:center;font-size:20px;color:#fff;flex-shrink:0;'
        + (a?'margin-left:-9px;':'')+'">'+cs[a].initial
        + (cnt ? '<span style="position:absolute;right:-6px;top:-9px;width:22px;height:22px;border-radius:50%;'
          + 'display:flex;align-items:center;justify-content:center;background:#4e88ad;border:2px solid #0a0702;'
          + 'font-size:15px;font-weight:bold;color:#fff">!</span>' : '')+'</div>';
    }

    var badges = '<div style="padding:7px 16px;border-radius:4px;font-size:20px;letter-spacing:0.08em;'
      + 'white-space:nowrap;background:'+(st.left>0?"rgba(224,145,60,0.16)":"rgba(255,255,255,0.03)")+';'
      + 'border:1px solid '+(st.left>0?INV.NEW:"#33230a")+';'
      + 'color:'+(st.left>0?"#f0ab62":"#5a4218")+'">'
      + (st.left>0 ? "未調査 "+st.left+"件" : (none ? "調査対象なし" : "すべて調査済"))+'</div>';
    if(st.newTopics > 0){
      badges += '<div style="padding:7px 16px;border-radius:4px;font-size:20px;letter-spacing:0.08em;'
        + 'white-space:nowrap;background:rgba(80,150,190,0.16);border:1px solid '+INV.BLUE+';'
        + 'color:#8fc3dd">新しい話題 '+st.newTopics+'</div>';
    }

    var pct = st.total ? Math.round(st.done / st.total * 100) : 0;

    var h = '<div onclick="window.invDoor('+i+')" style="position:relative;display:flex;flex-direction:column;'
      + 'gap:18px;padding:0 0 22px 0;border-radius:12px;overflow:hidden;cursor:pointer;'
      + 'background:rgba(13,9,3,0.94);border:1px solid '+(fresh?"#8a5c1e":"#33230a")+'">';

    h += '<div style="position:relative;height:'+artH+'px;display:flex;align-items:center;justify-content:center;'
      + 'background:linear-gradient(180deg,rgba(46,32,10,0.9),rgba(10,7,2,0.95));border-bottom:1px solid #33230a">'
      + '<div style="width:'+plateW+'px;height:'+plateH+'px;border-radius:6px 6px 2px 2px;display:flex;align-items:center;'
        + 'justify-content:center;font-family:'+INV.TITLE+';font-size:'+plateF+'px;'
        + 'color:'+(clear?"#6c5220":"#f6e6b4")+';background:linear-gradient(180deg,#3a2708,#1a1104);'
        + 'border:2px solid '+(clear?"#3c2a0c":"#8a6524")+';'
        + (fresh?'box-shadow:0 0 26px rgba(224,145,60,0.28);':'')+'">'+(s.door||"")+'</div>'
      + '<div style="position:absolute;top:14px;right:16px;padding:7px 16px;border-radius:4px;font-size:20px;'
        + 'letter-spacing:0.1em;white-space:nowrap;background:'+chipBg+';border:1px solid '+chipBd+';'
        + 'color:'+chipFg+'">'+chipTx+'</div>';
    if(st.poison){
      h += '<div style="position:absolute;top:14px;left:16px;padding:7px 14px;border-radius:4px;font-size:18px;'
        + 'letter-spacing:0.12em;white-space:nowrap;background:rgba(190,70,40,0.92);color:#ffe9d2">毒の手がかり発見済</div>';
    }
    if(st.newTopics > 0){
      h += '<div style="position:absolute;top:'+(st.poison?58:14)+'px;left:16px;padding:7px 14px;border-radius:4px;'
        + 'font-size:18px;font-weight:bold;letter-spacing:0.1em;white-space:nowrap;'
        + 'background:rgba(54,112,150,0.96);border:1px solid #8fc3dd;color:#eef9ff">！ 新規会話</div>';
    }
    h += '</div>';

    h += '<div style="display:flex;flex-direction:column;gap:14px;padding:0 22px">'
      + '<div style="display:flex;flex-direction:column;gap:6px">'
        + '<div style="font-family:'+INV.TITLE+';font-size:34px;line-height:1.1;color:#f6e6b4">'+s.name+'</div>'
        + '<div style="font-size:21px;color:#8a6a30;letter-spacing:0.06em">'+(s.occupant||"")+'</div></div>'
      + '<div style="display:flex;align-items:center;gap:12px">'
        + '<div style="flex:1;height:10px;background:#1c1204;border-radius:5px;overflow:hidden">'
        + '<div style="height:100%;width:'+pct+'%;background:linear-gradient(90deg,#c8a060,#8a5c1e)"></div></div>'
        + '<div style="font-size:22px;color:#d8b050;white-space:nowrap">'
        + (st.total ? st.done+" / "+st.total : "—")+'</div></div>'
      + '<div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;min-height:44px">'+badges
        + '<div style="flex:1"></div>'
        + '<div style="display:flex;align-items:center">'+avatars+'</div></div>'
      + '</div></div>';
    return h;
  }

  var doors = "";
  for(var i=0;i<subs.length;i++){ doors += door(subs[i], i); }

  var h = '<div id="inv-overlay" style="position:absolute;top:0;left:0;width:100%;height:100%;z-index:999999998;'
    + 'display:flex;flex-direction:column;font-family:'+INV.BODY+';color:#e8dcc0;box-sizing:border-box;'
    + 'animation:invfade .3s ease-out">';

  h += '<img src="./data/bgimage/'+r.bg+'" alt="" style="position:absolute;inset:0;width:100%;height:100%;'
    + 'object-fit:cover;opacity:0.2;filter:saturate(0.7)">'
    + '<div style="position:absolute;inset:0;background:radial-gradient(120% 90% at 50% 0%,'
    + 'rgba(10,7,2,0.74),rgba(6,4,1,0.97))"></div>';

  h += '<div style="position:relative;display:flex;align-items:center;gap:24px;padding:26px 48px;'
    + 'background:linear-gradient(180deg,rgba(14,10,3,0.96),rgba(10,7,2,0.82));border-bottom:1px solid #5c3e14">'
    + '<button onclick="window.invWingBack()" style="padding:14px 28px;background:rgba(18,12,3,0.92);'
      + 'border:1px solid #6c4c18;border-radius:6px;color:#e8c86a;font-size:22px;font-family:inherit;'
      + 'cursor:pointer;white-space:nowrap">← 館マップ</button>'
    + '<div style="display:flex;flex-direction:column;gap:6px">'
      + '<div style="font-size:20px;letter-spacing:0.42em;color:#8a6a30">'+(r.wingLabel||"GUEST ROOMS")+'</div>'
      + '<div style="font-family:'+INV.TITLE+';font-size:40px;color:#f2d882;letter-spacing:0.06em;'
        + 'white-space:nowrap">'+r.name+'</div></div>'
    + '<div style="font-size:22px;color:#c9a24e;letter-spacing:0.16em">'+(r.floorLabel || (r.floor+'F'))+'</div>'
    + '<div style="flex:1"></div>'
    + '<div style="display:flex;align-items:center;gap:14px;padding:10px 22px;background:rgba(18,12,3,0.9);'
      + 'border:1px solid #4c3410;border-radius:6px">'
      + '<span style="font-size:19px;letter-spacing:0.24em;color:#8a6a30">調査</span>'
      + '<span style="font-family:'+INV.TITLE+';font-size:34px;line-height:1;color:#f6e6b4;white-space:nowrap">'
      + (ws.total ? ws.done+" / "+ws.total : "—")+'</span></div>'
    + '<div style="display:flex;align-items:center;gap:14px;padding:10px 22px;background:rgba(18,12,3,0.9);'
      + 'border:1px solid #4c3410;border-radius:6px">'
      + '<span style="font-size:19px;letter-spacing:0.24em;color:#8a6a30">時刻</span>'
      + '<span style="font-family:'+INV.TITLE+';font-size:34px;line-height:1;color:#f6e6b4">'
      + INV.fmt(kf.game_time||0)+'</span></div>'
    + INV.sysHTML() + '</div>';

  h += '<div class="inv-scroll" style="position:relative;flex:1;min-height:0;display:flex;align-items:center;padding:18px 48px;'
    + 'overflow-y:auto;overflow-x:hidden">'
    + '<div style="display:grid;grid-template-columns:repeat('+cols+',1fr);gap:'+(cols>4?18:26)+'px;width:100%">'
    + doors + '</div></div>';

  h += '<div style="position:relative;display:flex;align-items:center;gap:20px;padding:26px 48px;'
    + 'background:linear-gradient(0deg,rgba(14,10,3,0.98),rgba(10,7,2,0.6))">'
    + '<div style="font-size:20px;color:#7a5c28;letter-spacing:0.08em">'
    + (r.wingHint||"扉を選ぶと、その部屋に入って調査できます。")+'</div></div>';

  h += '</div>';
  INV.mount(h);

  window.invDoor = function(i){
    tf.inv_talk = "";
    // 子部屋の導入テキストは扉から入ったときだけ再生する
    tf.inv_enter = 1;
    f.INV.go(subs[i].target);
  };
  window.invWingBack = function(){ f.INV.toHub(); };
})();
[endscript]
[s]
[endmacro]


;===============================================================================
; [inv_room id="living"]  部屋画面（調査ポイント＋人物トピック＋固有アクション）
;   前提：直前に [bg] で部屋の背景を出しておく
;===============================================================================
[macro name="inv_room"]
; 会話相手にイベント絵（chars[].bg）があれば、部屋の背景をそれに差し替える
[iscript]
window.INV_READY();
(function(){
  tf.inv_bg = "";
  var r = f.INV.room(mp.id);
  if(!r){ return; }
  var talk = tf.inv_talk || "", cs = r.chars || [];
  for(var i=0;i<cs.length;i++){ if(cs[i].id === talk && cs[i].bg){ tf.inv_bg = cs[i].bg; } }
})();
[endscript]
[bg storage="&tf.inv_bg" time=300 cond="tf.inv_bg != ''"]

[iscript]
window.INV_READY();
(function(){
  var kf = TG.stat.f, INV = f.INV, cfg = INV.cfg();
  var r = INV.room(mp.id);
  INV.markMacro();
  // 章データに無い部屋を指定された場合は館マップへ戻す（進行不能を防ぐ）
  if(!r){ INV.toHub(); return; }
  INV.markScreen(r.target);
  kf.inv_cur_room = r.name;
  kf.inv_cur_room_id = r.id;   // 同名の部屋（1F/2Fのサンルーム）を区別するため
  kf.inv_cur_where = "";
  // 子部屋（宿泊部屋の各室など）は館マップではなく親の扉選択画面へ戻す
  var parent = r.parent ? INV.room(r.parent) : null;
  if(parent && !parent.target){ parent = null; }
  var talk = tf.inv_talk || "";
  var spots = INV.spots(r);
  var st = INV.stats(r);

  // 右パネルの開閉。会話中は必ず開いておく（トピックがパネル内にあるため）
  var panelOpen = (tf.inv_panel !== "closed") || talk !== "";
  // パネルが占める領域（画面 1920x1080 基準）
  var PANEL_L = 1920 - 44 - 520, PANEL_T = 118, PANEL_B = 1080 - 44;
  // ピンは中央寄せの丸(74px)＋ラベルなので、その外接矩形がパネルに掛かるかを見る
  function hiddenByPanel(sp){
    if(!panelOpen){ return false; }
    var halfW = Math.max(37, (String(sp.label).length * 22 + 38) / 2);
    var cx = sp.x / 100 * 1920, cy = sp.y / 100 * 1080;
    return (cx + halfW > PANEL_L) && (cy + 61 > PANEL_T) && (cy - 61 < PANEL_B);
  }

  // 未調査＝オレンジの「!」、調べたが収穫なし＝「−」、発見あり＝金／毒色の「✓」
  function ring(s){
    var done = (kf[s.flag] == 1);
    if(!done){ return { done:false, got:false, c:INV.NEW, mark:"!", tag:"未調査" }; }
    var poisonGot = INV.poisonFound(s);
    var got = !!(s.get || poisonGot);
    return { done:true, got:got, mark:(got ? "✓" : "−"), tag:(got ? "発見" : "異常なし"),
             c:(poisonGot ? INV.POISON : (got ? INV.GOLD : "#5a4218")) };
  }

  // ── 背景上のピン ──
  var pins = "", pinsHidden = 0;
  for(var i=0;i<spots.length;i++){
    var s = spots[i], g = ring(s);
    if(hiddenByPanel(s)){ pinsHidden++; continue; }
    pins += '<div onclick="window.invSpot('+i+')" style="position:absolute;left:'+s.x+'%;top:'+s.y+'%;'
      + 'transform:translate(-50%,-50%);display:flex;flex-direction:column;align-items:center;gap:10px;'
      + 'cursor:pointer;z-index:'+(g.done?4:6)+'">'
      + '<div style="width:74px;height:74px;border-radius:50%;display:flex;align-items:center;'
        + 'justify-content:center;border:2px solid '+g.c+';background:rgba(8,5,1,0.55);'
        + (g.done?'':'animation:invpulse 2.2s ease-out infinite;')+'">'
        + '<div style="width:50px;height:50px;border-radius:50%;display:flex;align-items:center;'
        + 'justify-content:center;font-size:28px;font-weight:700;color:#1a1004;background:'+g.c+'">'+g.mark+'</div></div>'
      + '<div style="padding:7px 18px;border-radius:4px;font-size:22px;letter-spacing:0.06em;white-space:nowrap;'
        + 'color:'+(g.done?"#c9b487":"#ffe0b8")+';background:rgba(8,5,1,0.86);border:1px solid '+g.c+'">'
        + s.label+'</div></div>';
  }

  // ── 調査対象リスト ──
  var rows = "";
  for(var j=0;j<spots.length;j++){
    var sp = spots[j], g2 = ring(sp);
    rows += '<div onclick="window.invSpot('+j+')" style="display:flex;align-items:flex-start;gap:14px;'
      + 'padding:14px 16px;border-radius:8px;cursor:pointer;'
      + 'background:'+(g2.done?"rgba(255,255,255,0.02)":"rgba(224,145,60,0.1)")+';'
      + 'border:1px solid '+(g2.done?"#2e1f08":"#7a4d16")+'">'
      + '<div style="flex-shrink:0;width:34px;height:34px;border-radius:50%;display:flex;align-items:center;'
        + 'justify-content:center;font-size:20px;font-weight:700;color:#1a1004;background:'+g2.c+'">'+g2.mark+'</div>'
      + '<div style="flex:1;display:flex;flex-direction:column;gap:4px">'
        + '<div style="font-size:24px;color:'+(g2.done?"#bda87c":"#f6e6b4")+'">'+sp.label+'</div>'
        + '<div style="font-size:19px;color:#7f6432;line-height:1.35">'+sp.note+'</div></div>'
      + '<div style="flex-shrink:0;font-size:19px;letter-spacing:0.1em;white-space:nowrap;color:'+g2.c+'">'
        + g2.tag+'</div></div>';
  }
  if(rows === ""){ rows = '<div style="padding:14px 4px;font-size:21px;color:#5a4218">調べられる場所はない。</div>'; }

  var panel = '<div style="flex-shrink:0;padding:22px 24px;background:rgba(14,10,3,0.94);'
    + 'border:1px solid #5c3e14;border-radius:10px;display:flex;flex-direction:column;gap:16px">'
    + '<div style="display:flex;align-items:center;gap:12px">'
      + '<div style="font-size:20px;letter-spacing:0.3em;color:#8a6a30;white-space:nowrap">この部屋を調べる</div>'
      + '<div style="flex:1"></div>'
      + '<div style="font-size:22px;color:#d8b050;white-space:nowrap">'+st.done+' / '+st.total+'</div></div>'
    + '<div style="display:flex;flex-direction:column;gap:10px">'+rows+'</div></div>';

  // ── 固有アクション（例：口紅を渡す） ──
  var acts = INV.actions(r);
  if(acts.length){
    var ah = "";
    for(var a=0;a<acts.length;a++){
      ah += '<div onclick="window.invAction('+a+')" style="display:flex;align-items:center;gap:12px;'
        + 'padding:14px 18px;border-radius:8px;cursor:pointer;background:rgba(200,160,96,0.12);'
        + 'border:1px solid #a07828">'
        + '<div style="flex-shrink:0;width:30px;font-size:20px;color:'+INV.GOLD+'">◆</div>'
        + '<div style="flex:1;font-size:23px;color:#f6e6b4">'+acts[a].label+'</div></div>';
    }
    panel += '<div style="flex-shrink:0;padding:22px 24px;background:rgba(14,10,3,0.94);'
      + 'border:1px solid #a07828;border-radius:10px;display:flex;flex-direction:column;gap:12px">'
      + '<div style="font-size:20px;letter-spacing:0.3em;color:#c9a24e;white-space:nowrap">できること</div>'
      + ah + '</div>';
  }

  // ── 人物とトピック ──
  var cs = INV.chars(r);
  if(cs.length){
    var chips = "", topics = "", talkName = "";
    for(var k=0;k<cs.length;k++){
      var c = cs[k], sel = (talk === c.id);
      var nt = 0;
      for(var m=0;m<c.topics.length;m++){
        if(INV.test(c.topics[m].cond) && kf[c.topics[m].flag] != 1){ nt++; }
      }
      chips += '<div onclick="window.invTalk(\''+(sel?"":c.id)+'\')" style="display:flex;align-items:center;'
        + 'gap:12px;padding:12px 18px;border-radius:8px;cursor:pointer;'
        + 'background:'+(sel?"rgba(40,27,7,0.95)":"rgba(255,255,255,0.03)")+';'
        + 'border:1px solid '+(sel?"#c8a060":(nt?INV.BLUE:"#33230a"))+'">'
        + '<div style="width:46px;height:46px;border-radius:50%;background:'+c.color+';border:2px solid #0a0702;'
          + 'display:flex;align-items:center;justify-content:center;font-size:23px;color:#fff">'+c.initial+'</div>'
        + '<div style="display:flex;flex-direction:column;gap:2px">'
          + '<div style="font-size:23px;color:#f0dca8;white-space:nowrap">'+c.name+'</div>'
          + '<div style="font-size:19px;white-space:nowrap;color:'+(sel?"#c9a24e":(nt?"#8fc3dd":"#5a4218"))+'">'
          + (sel ? "選択中" : (nt ? "新しい話題 "+nt+"件" : "すべて聞いた"))+'</div></div></div>';

      if(sel){
        talkName = c.name;
        for(var n=0;n<c.topics.length;n++){
          var t = c.topics[n];
          // repeat:true の話題は何度でも聞けるので、聞いた後も未読（◆）のまま見せる
          var open = INV.test(t.cond), read = (!t.repeat && kf[t.flag] == 1);
          var col = !open ? "#4e3a14" : (read ? "#8a7444" : INV.GOLD);
          var mark = !open ? "×" : (read ? "✓" : "◆");
          var label = open ? t.label : t.label + "（" + (t.lock || "未解放") + "）";
          topics += '<div onclick="window.invTopic('+n+')" style="display:flex;align-items:center;gap:10px;'
            + 'padding:12px 16px;border-radius:6px;cursor:'+(open?"pointer":"not-allowed")+';color:'+col+';'
            + 'background:'+((read||!open)?"rgba(255,255,255,0.02)":"rgba(200,160,96,0.1)")+';'
            + 'border:1px solid '+((read||!open)?"#2e1f08":"#7a5c28")+'">'
            + '<div style="flex-shrink:0;width:30px;font-size:20px">'+mark+'</div>'
            + '<div style="flex:1;font-size:22px;line-height:1.3;text-wrap:pretty">'+label+'</div></div>';
        }
      }
    }

    panel += '<div class="inv-scroll" style="flex:1;min-height:0;overflow-y:auto;padding:22px 24px;background:rgba(14,10,3,0.94);'
      + 'border:1px solid #5c3e14;border-radius:10px;display:flex;flex-direction:column;gap:16px">'
      + '<div style="font-size:20px;letter-spacing:0.3em;color:#8a6a30;white-space:nowrap">この部屋にいる人</div>'
      + '<div style="display:flex;gap:12px;flex-wrap:wrap">'+chips+'</div>';
    if(topics !== ""){
      panel += '<div style="display:flex;flex-direction:column;gap:10px;padding-top:6px;border-top:1px solid #33230a">'
        + '<div style="display:flex;align-items:center;gap:12px">'
          + '<div style="font-size:20px;color:#c9a24e;letter-spacing:0.1em;white-space:nowrap">'+talkName+'に聞く</div>'
          + '<div style="flex:1"></div>'
          + '<button onclick="window.invTalk(&quot;&quot;)" style="padding:8px 18px;background:rgba(40,27,7,0.95);'
            + 'border:1px solid #c8a060;border-radius:6px;color:#e8c86a;font-size:19px;font-family:inherit;'
            + 'cursor:pointer;white-space:nowrap">← 会話をやめる</button></div>'
        + topics + '</div>';
    }
    panel += '</div>';
  } else {
    panel += '<div style="flex:1"></div>';
  }

  if(talk === ""){
    // 背景の絵に重なるので、地を濃くして文字を明るくしないと読めない
    panel += '<div style="flex-shrink:0;padding:16px 22px;background:rgba(8,5,1,0.94);border:1px solid #6a4a18;'
      + 'border-radius:8px;font-size:19px;color:#cbb17c;line-height:1.5;'
      + 'text-shadow:0 1px 3px rgba(0,0,0,0.9);box-shadow:0 4px 18px rgba(0,0,0,0.55)">'
      + (cfg.stepNote || ('1回の調査で' + (cfg.step || 5) + '分経過します。'))
      + '<span style="color:#e8a860;font-weight:600">オレンジの印</span>がまだ調べていない場所です。</div>';
  }

  var h = '<div id="inv-overlay" style="position:absolute;top:0;left:0;width:100%;height:100%;z-index:999999998;'
    + 'font-family:'+INV.BODY+';color:#e8dcc0;box-sizing:border-box;animation:invfade .3s ease-out">'
    + '<div style="position:absolute;inset:0;background:'+(panelOpen
        ? 'linear-gradient(90deg,rgba(6,4,1,0.05) 40%,rgba(6,4,1,0.86) 78%,rgba(6,4,1,0.96))'
        : 'linear-gradient(180deg,rgba(6,4,1,0.55),rgba(6,4,1,0.12) 22%,rgba(6,4,1,0.12))')+'"></div>'
    + pins
    + '<div style="position:absolute;top:0;left:0;right:0;display:flex;align-items:center;gap:24px;'
      + 'padding:24px 44px;background:linear-gradient(180deg,rgba(8,5,1,0.94),rgba(8,5,1,0))">'
      + '<button onclick="window.invBack()" style="padding:14px 28px;background:rgba(18,12,3,0.92);'
        + 'border:1px solid #6c4c18;border-radius:6px;color:#e8c86a;font-size:22px;font-family:inherit;'
        + 'cursor:pointer;white-space:nowrap">'+(parent ? "← "+parent.name : "← 館マップ")+'</button>'
      + '<div style="font-family:'+INV.TITLE+';font-size:44px;color:#f6e6b4;letter-spacing:0.05em;'
        + 'text-shadow:0 2px 12px rgba(0,0,0,0.9);white-space:nowrap">'+r.name+'</div>'
      + '<div style="font-size:22px;color:#c9a24e;letter-spacing:0.16em">'+(r.floorLabel || (r.floor+'F'))+'</div>'
      + '<div style="flex:1"></div>'
      + '<button onclick="window.invPanel()" style="display:flex;align-items:center;gap:10px;padding:12px 22px;'
        + 'background:'+(panelOpen?"rgba(18,12,3,0.92)":"rgba(40,27,7,0.95)")+';'
        + 'border:1px solid '+(pinsHidden?"#c8a060":"#6c4c18")+';border-radius:6px;color:#e8c86a;'
        + 'font-size:20px;font-family:inherit;cursor:pointer;white-space:nowrap">'
        + (panelOpen ? '調査リストを閉じる' : '調査リストを開く')
        + (pinsHidden ? '<span style="min-width:26px;padding:2px 8px;border-radius:13px;background:'+INV.NEW+';'
            + 'color:#2a1602;font-size:18px;font-weight:700;text-align:center">'+pinsHidden+'</span>' : '')
        + '</button>'
      + '<div style="display:flex;align-items:center;gap:14px;padding:10px 22px;background:rgba(18,12,3,0.9);'
        + 'border:1px solid #4c3410;border-radius:6px">'
        + '<span style="font-size:19px;letter-spacing:0.24em;color:#8a6a30">時刻</span>'
        + '<span style="font-family:'+INV.TITLE+';font-size:34px;line-height:1;color:#f6e6b4">'+INV.fmt(kf.game_time||0)+'</span></div>'
      + INV.sysHTML() + '</div>'
    + (panelOpen ? '<div style="position:absolute;top:118px;right:44px;bottom:44px;width:520px;display:flex;'
      + 'flex-direction:column;gap:18px">'+panel+'</div>' : '') + '</div>';

  INV.mount(h);

  window.invSpot = function(i){
    tf.inv_talk = "";
    f.INV.setWhere(spots[i].label);
    f.INV.go(spots[i].target);
  };
  window.invAction = function(i){
    tf.inv_talk = "";
    f.INV.setWhere(acts[i].label);
    f.INV.go(acts[i].target);
  };
  window.invTalk = function(id){
    tf.inv_talk = id;
    f.INV.go(r.target);
  };
  window.invPanel = function(){
    tf.inv_panel = (tf.inv_panel === "closed") ? "open" : "closed";
    f.INV.go(r.target);
  };
  window.invTopic = function(n){
    var cc = null;
    for(var i=0;i<cs.length;i++){ if(cs[i].id === tf.inv_talk){ cc = cs[i]; } }
    if(!cc){ return; }
    var t = cc.topics[n];
    if(!f.INV.test(t.cond)){ return; }
    f.INV.setWhere(cc.name + "の証言");
    f.INV.go((TG.stat.f[t.flag] == 1 && t.target_r) ? t.target_r : t.target);
  };
  window.invBack = function(){
    tf.inv_talk = "";
    if(parent){ f.INV.go(parent.target); } else { f.INV.toHub(); }
  };
})();
[endscript]
[s]
[endmacro]

[return]
