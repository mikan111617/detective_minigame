;===============================================================================
; achievement.ks ―― 称号システム
;
;   [achieve id="..."]        … 称号を獲得する（獲得済みなら何もしない）
;   [achievement_screen]      … 称号一覧画面を描画する
;   *achievement_start        … タイトルから飛んでくる入口（[return] より下）
;
; 獲得状況はシステム変数 sf.achievements に { id: 1 } の形で持たせる。
; セーブデータではなく sf なので、周回してもプレイし直しても消えない。
;
; 見た目はタイトル画面／保安錠パズルと同じ「黒地・金の細罫・深紅」で統一。
; first.ks から [call storage="system/achievement.ks"] で読み込む。
;===============================================================================

[iscript]
window.ACH = {
  TITLE:   "'Waosagi',serif",
  TITLE_I: "Waosagi,serif",
  BODY:    "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif",
  GOLD:    "#a8823a",
  CRIMSON: "#a8231d",

  // ── 称号の定義（並び順がそのまま一覧の並び順） ──
  //   id   … sf.achievements のキー
  //   name … 称号名（未獲得のうちは伏せる）
  //   en   … 英字ラベル
  //   cond … 獲得条件（未獲得でも表示して目標にしてもらう）
  LIST: [
    { id:"puzzle_clear", name:"解錠者",           en:"ACCESS GRANTED",
      cond:"絵合わせパズルを攻略した" },
    { id:"puzzle_speed", name:"疾風の指先",       en:"SWIFT FINGERS",
      cond:"絵合わせパズルを30秒以内でクリアした" },
    { id:"basement_key", name:"地下への鍵",       en:"THE OLD KEY",
      cond:"地下の鍵を手に入れた" },
    { id:"blueprint",    name:"館の図面",         en:"BLUEPRINT",
      cond:"設計図を手に入れた" },
    { id:"all_items",    name:"満たされた手帳",   en:"FULL NOTEBOOK",
      cond:"証拠品をすべて手に入れた" },
    { id:"s56_hands",    name:"動いた手",         en:"NEVER FROZE",
      cond:"事件の夜、一度も立ち尽くさなかった" },
    { id:"s56_alibi",    name:"十分前の空白",     en:"THE MISSING TEN",
      cond:"小出里亜さんの足取りから、迷わず核心を突いた" },
    { id:"s56_plea",     name:"譲れない一歩",     en:"THE PLEA",
      cond:"零度警部の信頼を勝ち取って捜査に加わった" },
    { id:"old_photo_ev", name:"八十年越しの忘れ物", en:"THE LAST PHOTOGRAPH",
      cond:"古い写真をクロエに見せた" },
    { id:"end_normal",   name:"舞黒館の惨劇",     en:"ENDING 1 / NORMAL",
      cond:"ノーマルエンドを見た" },
    { id:"end_true",     name:"過去の縁は今の絆", en:"ENDING 2 / TRUE",
      cond:"トゥルーエンドを見た" },
    { id:"end_bad",      name:"全ては闇に散って……", en:"ENDING 3 / BAD",
      cond:"バッドエンドを見た" },
    { id:"both_routes",  name:"二つの筋書き",     en:"BOTH METHODS",
      cond:"二通りの手口を、どちらも見破った" }
  ],

  // [get_item] のアイテムIDと称号IDの対応。ここに載せておくと
  // 取得箇所を書き換えなくても称号が付く（get_item.ks から呼ばれる）
  ITEM_MAP: { key:"basement_key", blueprint:"blueprint" },

  // 実際に動いているエンジンは window.TYRANO.kag のほう。
  // tyrano.plugin.kag は雛形で kag プロパティが null のままなので、
  // そちらで saveSystemVariable() を呼ぶと例外になり保存されない。
  // （variable / sf は両者で同じ実体を共有しているので読み書きはどちらでも同じ）
  kag: function(){
    return (window.TYRANO && window.TYRANO.kag) ? window.TYRANO.kag : tyrano.plugin.kag;
  },

  base: function(){ return document.getElementById("tyrano_base") || document.body; },

  // sf.achievements を必ず用意してから返す
  store: function(){
    var sf = window.ACH.kag().variable.sf;
    if(!sf.achievements || typeof sf.achievements !== "object"){ sf.achievements = {}; }
    return sf.achievements;
  },

  find: function(id){
    var L = window.ACH.LIST;
    for(var i=0; i<L.length; i++){ if(L[i].id === id){ return L[i]; } }
    return null;
  },

  has: function(id){ return window.ACH.store()[id] == 1; },

  count: function(){
    var L = window.ACH.LIST, n = 0;
    for(var i=0; i<L.length; i++){ if(window.ACH.has(L[i].id)){ n++; } }
    return n;
  },

  // sf はブラウザのストレージに保存して初めて残る。
  // スクリプトブロックの閉じタグを通れば自動で保存されるが、
  // ボタンのコールバックなどからも呼ばれるのでここで明示的に保存する。
  save: function(){
    try { window.ACH.kag().saveSystemVariable(); }
    catch(e){ console.error("称号の保存に失敗しました", e); }
  },

  // ── 称号の付与。新しく獲得したときだけ true を返す ──
  grant: function(id){
    var a = window.ACH.find(id);
    if(!a){ return false; }
    if(window.ACH.has(id)){ return false; }
    window.ACH.store()[id] = 1;
    window.ACH.save();
    window.ACH.toast(a);
    return true;
  },

  // [get_item] のアイテムIDから引く
  grantByItem: function(itemId){
    var M = window.ACH.ITEM_MAP;
    if(!itemId || !Object.prototype.hasOwnProperty.call(M, itemId)){ return false; }
    return window.ACH.grant(M[itemId]);
  },

  // ── 証拠品の収集状況（捜査手帳の「◯ / ◯」と同じ数え方） ──
  // f.master_data の type:"item" だけを見る（type:"chara" の人物名鑑は数えない）
  itemProgress: function(){
    var kf = window.ACH.kag().stat.f;
    var master = kf.master_data || [], status = kf.status || {};
    // route 付きの証拠品は、その周回で辿れる経路のものだけを数える
    var route = kf.route_b ? "b" : "a";
    var n = 0, max = 0;
    for(var i=0; i<master.length; i++){
      if(master[i].type !== "item"){ continue; }
      if(master[i].route && master[i].route !== route){ continue; }
      max++;
      var st = status[master[i].id];
      if(st && st.owned){ n++; }
    }
    return { n:n, max:max };
  },

  // 証拠品を取り終えていれば称号を付ける。
  // アイテムの入手経路が [get_item] だけではないので、
  // 取得まわりの各所から呼んで取りこぼさないようにしている。
  //
  // ※ master_data に証拠品を足すときは入手箇所も必ず用意すること。
  //    どこでも owned にならない証拠品が1つでもあると、捜査手帳が
  //    最大値に届かなくなり、この称号が永久に成立しなくなる。
  checkAllItems: function(){
    var p = window.ACH.itemProgress();
    if(p.max > 0 && p.n >= p.max){ return window.ACH.grant("all_items"); }
    return false;
  },

  css: function(){
    if(document.getElementById("ach-css")){ return; }
    var A = window.ACH;
    var st = document.createElement("style");
    st.id = "ach-css";
    st.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:block}"
      + "@keyframes achFade{from{opacity:0}to{opacity:1}}"
      + "@keyframes achRise{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:none}}"
      + "@keyframes achIn{from{opacity:0;transform:translateX(60px)}to{opacity:1;transform:none}}"
      + "@keyframes achOut{from{opacity:1;transform:none}to{opacity:0;transform:translateX(60px)}}"
      // ── 一覧の札 ──
      + ".ach-card{display:flex;align-items:center;gap:24px;height:126px;padding:0 30px;box-sizing:border-box;"
        + "background:linear-gradient(100deg,rgba(14,11,20,0.86),rgba(8,6,13,0.7));"
        + "border:1px solid rgba(168,130,58,0.16);transition:border-color .2s ease}"
      + ".ach-card.got{border-color:rgba(168,130,58,0.48);"
        + "background:linear-gradient(100deg,rgba(28,20,10,0.9),rgba(10,7,14,0.72));"
        + "box-shadow:inset 0 0 34px rgba(90,60,16,0.28)}"
      + ".ach-mark{flex-shrink:0;width:26px;font-size:24px;line-height:1;color:rgba(168,130,58,0.2)}"
      + ".ach-card.got .ach-mark{color:" + A.GOLD + ";text-shadow:0 0 16px rgba(200,160,90,0.55)}"
      + ".ach-body{flex:1;min-width:0;display:flex;flex-direction:column;gap:10px}"
      + ".ach-name{font-family:" + A.TITLE + ";font-size:42px;line-height:1.05;letter-spacing:0.1em;"
        + "white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:#3f3726}"
      + ".ach-card.got .ach-name{color:#f7e6c2;text-shadow:0 0 22px rgba(200,160,90,0.4)}"
      + ".ach-en{font-size:16px;letter-spacing:0.28em;white-space:nowrap;color:#463c26}"
      + ".ach-card.got .ach-en{color:#9c8047}"
      + ".ach-cond{font-size:21px;letter-spacing:0.06em;color:#6a5c40}"
      + ".ach-card.got .ach-cond{color:#a89572}"
      + ".ach-seal{flex-shrink:0;width:104px;text-align:center;font-family:" + A.TITLE + ";font-size:30px;"
        + "letter-spacing:0.14em;color:rgba(120,100,64,0.28)}"
      + ".ach-card.got .ach-seal{color:#d9b6a2;text-shadow:0 0 20px rgba(178,32,26,0.7)}"
      // ── 戻りの行組み（タイトル画面と同じ） ──
      + ".ach-row{display:flex;align-items:center;gap:20px;padding:13px 10px;cursor:pointer;width:560px;"
        + "border-bottom:1px solid rgba(168,130,58,0.14);transition:border-color .2s ease}"
      + ".ach-row:hover{border-bottom-color:rgba(168,130,58,0.5)}"
      + "#ach-scroll::-webkit-scrollbar{width:8px}"
      + "#ach-scroll::-webkit-scrollbar-track{background:rgba(255,255,255,0.04);border-radius:4px}"
      + "#ach-scroll::-webkit-scrollbar-thumb{background:rgba(168,130,58,0.5);border-radius:4px}"
      + ".ach-row .ach-rmark{flex-shrink:0;width:18px;font-size:17px;color:rgba(168,130,58,0.28);"
        + "transition:color .2s ease}"
      + ".ach-row:hover .ach-rmark{color:" + A.CRIMSON + "}"
      + ".ach-label{font-family:" + A.TITLE + ";font-size:40px;line-height:1.1;letter-spacing:0.12em;"
        + "white-space:nowrap;color:#b9a578;transition:color .2s ease}"
      + ".ach-row:hover .ach-label{color:#f7e6c2;text-shadow:0 0 22px rgba(200,160,90,0.4)}"
      + ".ach-ren{font-size:17px;letter-spacing:0.28em;white-space:nowrap;color:#5f5031;transition:color .2s ease}"
      + ".ach-row:hover .ach-ren{color:#9c8047}"
      + ".ach-line{width:30px;height:1px;background:rgba(168,130,58,0.25);"
        + "transition:width .24s ease,background .2s ease}"
      + ".ach-row:hover .ach-line{width:86px;background:" + A.CRIMSON + "}"
      // ── 獲得の報せ ──
      + ".ach-toast{width:620px;padding:22px 30px;box-sizing:border-box;"
        + "background:linear-gradient(100deg,rgba(26,18,8,0.97),rgba(7,5,11,0.97));"
        + "border:1px solid " + A.GOLD + ";border-right:none;"
        + "box-shadow:-8px 12px 44px rgba(0,0,0,0.8),inset 0 0 30px rgba(90,60,16,0.3);"
        + "animation:achIn .5s cubic-bezier(.2,.9,.3,1.1) both}"
      + ".ach-toast.out{animation:achOut .6s ease forwards}";
    document.head.appendChild(st);
  },

  // ── 称号を獲得したときに右上から差し込む報せ ──
  toast: function(a){
    var ACH = window.ACH;
    ACH.css();

    var wrap = document.getElementById("ach-toast-wrap");
    if(wrap && !wrap.parentNode){ wrap = null; }
    if(!wrap){
      wrap = document.createElement("div");
      wrap.id = "ach-toast-wrap";
      wrap.style.cssText = "position:absolute;right:0;top:64px;z-index:1000000001;display:flex;"
        + "flex-direction:column;align-items:flex-end;gap:16px;pointer-events:none;"
        + "font-family:" + ACH.BODY;
      ACH.base().appendChild(wrap);
    }

    var el = document.createElement("div");
    el.className = "ach-toast";
    el.innerHTML =
        '<div style="display:flex;align-items:center;gap:16px">'
        + '<div style="font-size:24px;line-height:1;color:' + ACH.GOLD + '">◆</div>'
        + '<div style="font-size:18px;letter-spacing:0.42em;color:#a08a56">称号を獲得</div>'
        + '<div style="flex:1;height:1px;background:linear-gradient(90deg,rgba(168,130,58,0.45),transparent)"></div>'
      + '</div>'
      + '<div style="font-family:' + ACH.TITLE_I + ';font-size:46px;line-height:1.15;letter-spacing:0.08em;'
        + 'color:#f7e6c2;margin-top:12px;text-shadow:0 0 26px rgba(178,32,26,0.55)">' + a.name + '</div>'
      + '<div style="font-size:19px;letter-spacing:0.06em;color:#9c8763;margin-top:8px">' + a.cond + '</div>';
    wrap.appendChild(el);

    // SEは [playse] を使わずに直接鳴らす。
    // [playse] は内部で nextOrder() を呼ぶため、シナリオ進行中の
    // コールバックから叩くと本編が一段勝手に進んでしまう。
    try {
      var vol = ACH.kag().variable.sf.current_se_vol;
      var se = new Audio("./data/sound/switch_on.mp3");
      se.volume = (vol === undefined || vol === "" || isNaN(vol)) ? 0.6 : (Number(vol) / 100) * 0.6;
      var pr = se.play();
      if(pr && pr.catch){ pr.catch(function(){}); }
    } catch(e){}

    setTimeout(function(){ el.className = "ach-toast out"; }, 4600);
    setTimeout(function(){
      if(el.parentNode){ el.parentNode.removeChild(el); }
      if(wrap.parentNode && wrap.children.length === 0){ wrap.parentNode.removeChild(wrap); }
    }, 5400);
  },

  clear: function(){
    var el = document.getElementById("ach-container");
    if(el && el.parentNode){ el.parentNode.removeChild(el); }
  },

  // ── 称号一覧画面 ──
  render: function(){
    var ACH = window.ACH;
    ACH.css();
    ACH.clear();

    var L = ACH.LIST, got = ACH.count(), total = L.length;

    var h = '<div id="ach-container" style="position:absolute;top:0;left:0;width:1920px;height:1080px;'
      + 'overflow:hidden;background:#05040a;font-family:' + ACH.BODY + ';color:#e0c07a;'
      + 'z-index:999999997;box-sizing:border-box;animation:achFade .5s ease both">';

    // 背景（タイトルと同じ絵を深く沈める）
    h += '<img src="./data/bgimage/title.png" alt="" style="position:absolute;inset:0;width:100%;height:100%;'
      + 'object-fit:cover;opacity:0.18;filter:grayscale(0.55) brightness(0.6)">'
      + '<div style="position:absolute;inset:0;background:linear-gradient(100deg,rgba(6,5,12,0.96) 0%,'
        + 'rgba(9,7,15,0.88) 48%,rgba(12,9,17,0.74) 100%)"></div>'
      + '<div style="position:absolute;inset:0;background:radial-gradient(76% 66% at 42% 42%,'
        + 'rgba(96,44,14,0.16) 0%,rgba(3,2,8,0.92) 100%)"></div>'
      + '<div style="position:absolute;inset:0;opacity:0.05;background-image:repeating-linear-gradient(0deg,'
        + 'rgba(255,255,255,0.9) 0px,rgba(255,255,255,0.9) 1px,transparent 1px,transparent 4px)"></div>';

    // 表題
    h += '<div style="position:absolute;left:96px;top:52px;display:flex;align-items:center;gap:22px">'
      + '<div style="width:56px;height:1px;background:linear-gradient(90deg,transparent,' + ACH.GOLD + ')"></div>'
      + '<div style="font-family:' + ACH.TITLE_I + ';font-size:52px;letter-spacing:0.16em;color:#f0dfbe;'
        + 'text-shadow:0 6px 26px rgba(0,0,0,0.9)">称号</div>'
      + '<div style="font-size:19px;letter-spacing:0.42em;color:#8f7540;padding-bottom:6px">ACHIEVEMENTS</div>'
      + '</div>';

    // 達成数
    h += '<div style="position:absolute;right:96px;top:52px;display:flex;align-items:flex-end;gap:20px">'
      + '<div style="font-size:18px;letter-spacing:0.3em;color:#6d5a34;padding-bottom:12px">達成</div>'
      + '<div style="font-family:' + ACH.TITLE_I + ';font-size:60px;line-height:1;letter-spacing:0.06em;'
        + 'color:' + (got >= total ? "#f4e3c3" : "#e8d5ab") + ';'
        + (got >= total ? 'text-shadow:0 0 30px rgba(178,32,26,0.7)' : '') + '">'
        + got + ' / ' + total + '</div></div>';

    // 達成率の細罫
    h += '<div style="position:absolute;left:96px;right:96px;top:150px;height:1px;'
      + 'background:rgba(168,130,58,0.14)">'
      + '<div style="width:' + Math.round(got / total * 100) + '%;height:1px;'
        + 'background:linear-gradient(90deg,rgba(168,130,58,0.35),' + ACH.GOLD + ')"></div></div>';

    // 札の並び（2列）。件数が増えても収まるよう、この領域だけをスクロールさせる。
    // 下端は「表題へ戻る」の行に被らない位置で止める。
    h += '<div id="ach-scroll" style="position:absolute;left:96px;right:96px;top:196px;bottom:132px;'
      + 'overflow-y:auto;overflow-x:hidden;padding-right:10px;'
      + 'touch-action:pan-y;-webkit-overflow-scrolling:touch">'
      + '<div style="display:grid;grid-template-columns:repeat(2,1fr);gap:16px;align-content:start">';
    for(var i=0; i<L.length; i++){
      var a = L[i], on = ACH.has(a.id);
      h += '<div class="ach-card' + (on ? ' got' : '') + '" style="animation:achRise .5s '
          + (0.05 + i * 0.05).toFixed(2) + 's ease both">'
        + '<div class="ach-mark">' + (on ? '◆' : '◇') + '</div>'
        + '<div class="ach-body">'
          + '<div style="display:flex;align-items:baseline;gap:18px;min-width:0">'
            + '<div class="ach-name">' + (on ? a.name : '？？？') + '</div>'
            + '<div class="ach-en">' + (on ? a.en : 'LOCKED') + '</div></div>'
          + '<div class="ach-cond">' + a.cond + '</div>'
        + '</div>'
        + '<div class="ach-seal">' + (on ? '達成' : '―') + '</div></div>';
    }
    h += '</div></div>';

    // 表題へ戻る
    h += '<div style="position:absolute;left:96px;bottom:52px">'
      + '<div class="ach-row" onclick="window.achClose()">'
        + '<div class="ach-rmark">◆</div>'
        + '<div style="display:flex;align-items:baseline;gap:16px;flex-shrink:0">'
          + '<div class="ach-label">表題へ戻る</div>'
          + '<div class="ach-ren">BACK</div></div>'
        + '<div style="flex:1;min-width:20px"></div>'
        + '<div class="ach-line"></div></div></div>';

    h += '<div style="position:absolute;right:64px;bottom:44px;font-size:19px;letter-spacing:0.3em;'
      + 'color:#5c4c2c">舞黒館の惨劇</div>';

    h += '</div>';

    var tmp = document.createElement("div");
    tmp.innerHTML = h;
    ACH.base().appendChild(tmp.firstElementChild);

    // index.html が touchmove を止めているので、指の動きから自前でスクロールさせる
    ACH.bindSwipe("ach-scroll");
  },

  // 画面は 1920x1080 を縮小表示しているので、指の移動量を実寸に直して送る
  bindSwipe: function(id){
    var el = document.getElementById(id);
    if(!el){ return; }
    var startY = 0, startTop = 0, scale = 1, dragging = false;
    el.addEventListener("touchstart", function(e){
      if(!e.touches || e.touches.length !== 1){ return; }
      startY = e.touches[0].clientY;
      startTop = el.scrollTop;
      var r = el.getBoundingClientRect();
      scale = (el.offsetHeight > 0 && r.height > 0) ? (r.height / el.offsetHeight) : 1;
      dragging = true;
    }, { passive:true });
    el.addEventListener("touchmove", function(e){
      if(!dragging){ return; }
      var d = startY - e.touches[0].clientY;
      if(el.scrollHeight > el.clientHeight){
        el.scrollTop = startTop + d / scale;
        if(e.cancelable){ e.preventDefault(); }
      }
    }, { passive:false });
    el.addEventListener("touchend",    function(){ dragging = false; }, { passive:true });
    el.addEventListener("touchcancel", function(){ dragging = false; }, { passive:true });
  }
};

window.achClose = function(){
  var kag = window.ACH.kag();
  var fromGallery = (kag.variable.tf.ach_from_gallery == 1);
  kag.variable.tf.ach_from_gallery = 0;
  window.ACH.clear();
  if(fromGallery){
    kag.ftag.startTag("jump", { storage:"system/gallery.ks", target:"*gallery_menu" });
  } else {
    kag.ftag.startTag("jump", { storage:"title.ks", target:"*show_menu" });
  }
};
[endscript]


;===============================================================================
; [achieve id="..."]  称号を獲得する
;   獲得済みなら何も起きない。進行は止めず、右上に報せだけ出す。
;===============================================================================
[macro name="achieve"]
[iscript]
if(window.ACH && mp.id !== undefined){ window.ACH.grant(mp.id); }
[endscript]
[endmacro]


;===============================================================================
; [achievement_screen]  称号一覧を描画する
;===============================================================================
[macro name="achievement_screen"]
[iscript]
window.ACH.render();
[endscript]
[endmacro]

[return]


;===============================================================================
; タイトルの「称号」から飛んでくる入口
;   [return] より下に置いているので、[call] での読み込み時には通らない。
;===============================================================================
*achievement_start
[cm]
[clearfix]
[layopt layer="message0" visible="false"]
[hidemenubutton]
[achievement_screen]
[s]
