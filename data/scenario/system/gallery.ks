;===============================================================================
; gallery.ks ―― 記録（称号／図鑑）
;
;   タイトル画面の「記録」から入る。中で称号と図鑑に分かれる。
;   図鑑は sf.seen_items を見るので、経路A・経路Bをまたいで残る。
;
;   呼び出し：[jump storage="system/gallery.ks" target="*start"]
;===============================================================================

*start
[cm]
[clearfix]
[free_layer_image]
[freeimage layer="1"]
[hidemenubutton]
[chara_hide_all]
[hud_hide]
[layopt layer="message0" page=fore visible=false]

[iscript]
if(window.TL){ window.TL.clear("tl-title"); }
// 直近の周回ぶんを取りこぼさないよう、開くたびに写しておく
if(window.SEEN){ window.SEEN.sync(); }
[endscript]


;----------------------------------------------------------
; 記録のメニュー
;----------------------------------------------------------
*gallery_menu
[cm]
[layopt layer="message0" page=fore visible=false]

[iscript]
(function(){
  var kag = window.TYRANO ? window.TYRANO.kag : tyrano.plugin.kag;
  var f = kag.stat.f;

  // 図鑑の進み具合（経路をまたいだ記録）
  var master = f.master_data || [];
  var item_n = 0, item_max = 0, chara_n = 0, chara_max = 0;
  for(var i=0;i<master.length;i++){
    var lv = window.SEEN ? window.SEEN.level(master[i].id) : 0;
    if(master[i].type === "chara"){ chara_max++; if(lv>0){ chara_n++; } }
    else                          { item_max++;  if(lv>0){ item_n++;  } }
  }

  // 称号の進み具合
  var ach_n = 0, ach_max = 0;
  if(window.ACH && window.ACH.LIST){
    ach_max = window.ACH.LIST.length;
    for(var a=0;a<ach_max;a++){ if(window.ACH.has(window.ACH.LIST[a].id)){ ach_n++; } }
  }

  var TITLE = "'Waosagi',serif";
  function row(fn, ja, en, note){
    return '<div class="gl-row" onclick="window.' + fn + '()">'
      + '<div class="gl-mark">◆</div>'
      + '<div style="display:flex;align-items:baseline;gap:18px;flex-shrink:0">'
        + '<div class="gl-label">' + ja + '</div>'
        + '<div class="gl-en">' + en + '</div></div>'
      + '<div style="flex:1;min-width:20px"></div>'
      + '<div class="gl-note">' + note + '</div>'
      + '<div class="gl-line"></div></div>';
  }

  var css = '<style id="gl-css">'
    + '@font-face{font-family:"Waosagi";src:url("./data/font/YDWaosagi.otf") format("opentype");font-display:swap}'
    + '#gl-root{position:absolute;top:0;left:0;width:1920px;height:1080px;z-index:999999997;'
      + 'box-sizing:border-box;color:#e8dcc0;font-family:"Noto Serif JP",serif;'
      + 'background:radial-gradient(120% 90% at 50% 30%,#241a15 0%,#150f0c 48%,#0a0706 100%)}'
    + '#gl-root .gl-veil{position:absolute;inset:0;'
      + 'background:repeating-linear-gradient(90deg,rgba(0,0,0,.26) 0 2px,rgba(255,255,255,0) 2px 92px);opacity:.5}'
    + '.gl-row{display:flex;align-items:center;gap:20px;padding:20px 12px;cursor:pointer;'
      + 'border-bottom:1px solid rgba(168,130,58,0.16);transition:border-color .2s ease}'
    + '.gl-row:hover{border-bottom-color:rgba(168,130,58,0.6)}'
    + '.gl-mark{flex-shrink:0;width:22px;font-size:22px;color:rgba(168,130,58,0.3);transition:color .2s}'
    + '.gl-row:hover .gl-mark{color:#e0c07a}'
    + '.gl-label{font-family:' + TITLE + ';font-size:44px;letter-spacing:0.14em;color:#f2d882;white-space:nowrap}'
    + '.gl-en{font-size:18px;letter-spacing:0.34em;color:#8f7540;white-space:nowrap}'
    + '.gl-note{font-size:24px;letter-spacing:0.1em;color:#a08a56;white-space:nowrap}'
    + '.gl-line{flex-shrink:0;width:120px;height:1px;background:linear-gradient(90deg,rgba(168,130,58,0.5),rgba(168,130,58,0))}'
    + '</style>';

  var h = css + '<div id="gl-root"><div class="gl-veil"></div>'
    + '<div style="position:absolute;left:120px;top:110px;display:flex;flex-direction:column;gap:14px">'
      + '<div style="font-size:20px;letter-spacing:0.42em;color:#8f7540">RECORDS</div>'
      + '<div style="font-family:' + TITLE + ';font-size:78px;letter-spacing:0.1em;color:#f3dcc4">記録</div>'
      + '<div style="width:320px;height:1px;background:linear-gradient(90deg,#a8823a,rgba(168,130,58,0.1))"></div>'
      + '<div style="font-size:22px;line-height:1.9;color:#9c8763;letter-spacing:0.06em">'
        + '周回をまたいで残ります。<br>経路によって手に入るものが違うので、両方を歩くと埋まります。</div>'
    + '</div>'
    + '<div style="position:absolute;left:120px;right:120px;bottom:130px;display:flex;flex-direction:column;gap:4px">'
      + row("glAchievement", "称号", "ACHIEVEMENTS", ach_n + " / " + ach_max)
      + row("glItems",       "図鑑：証拠品", "EVIDENCE",  item_n + " / " + item_max)
      + row("glCharas",      "図鑑：人物",   "CHARACTERS", chara_n + " / " + chara_max)
      + row("glBack",        "タイトルへ戻る", "BACK", "")
    + '</div></div>';

  // タイトル画面と同じく、素の DOM を #tyrano_base に重ねる
  var base = document.getElementById("tyrano_base") || document.body;
  var old = document.getElementById("gl-root");
  if(old){ old.remove(); }
  var oldcss = document.getElementById("gl-css");
  if(oldcss){ oldcss.remove(); }
  var tmp = document.createElement("div");
  tmp.innerHTML = h;
  while(tmp.firstElementChild){ base.appendChild(tmp.firstElementChild); }

  window.glClear = function(){
    var el = document.getElementById("gl-root");
    if(el){ el.remove(); }
  };
  // クリックの中でそのまま飛ぶと、押したクリックが飛んだ先まで届いてしまう。
  // 伝播が終わってから飛ぶようにし、直後の数百ミリ秒はクリックを吸い取る。
  window.glGo = function(pm){
    window.glClear();
    var sh = document.createElement("div");
    sh.style.cssText = "position:absolute;inset:0;z-index:999999999;background:transparent";
    sh.addEventListener("click", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    sh.addEventListener("pointerdown", function(e){ e.preventDefault(); e.stopPropagation(); }, true);
    base.appendChild(sh);
    setTimeout(function(){ if(sh.parentNode){ sh.parentNode.removeChild(sh); } }, 260);
    setTimeout(function(){ kag.ftag.startTag("jump", pm); }, 0);
  };
  window.glAchievement = function(){ window.glGo({ storage:"system/gallery.ks", target:"*gallery_ach" }); };
  window.glItems   = function(){ kag.variable.tf.current_tab_memory = "item";
                                 window.glGo({ storage:"system/gallery.ks", target:"*gallery_book" }); };
  window.glCharas  = function(){ kag.variable.tf.current_tab_memory = "chara";
                                 window.glGo({ storage:"system/gallery.ks", target:"*gallery_book" }); };
  window.glBack    = function(){ window.glGo({ storage:"title.ks", target:"*start" }); };
})();
[endscript]
[s]


;----------------------------------------------------------
; 称号
;----------------------------------------------------------
*gallery_ach
[cm]
[iscript]
if(window.glClear){ window.glClear(); }
[endscript]
[clearfix]
[layopt layer="message0" visible="false"]
[hidemenubutton]
[eval exp="tf.ach_from_gallery = 1"]
[achievement_screen]
[s]


;----------------------------------------------------------
; 図鑑（手帳の画面を図鑑モードで開く）
;----------------------------------------------------------
*gallery_book
[cm]
[iscript]
if(window.glClear){ window.glClear(); }
[endscript]
[jump storage="system/item_list.ks" target="*gallery_mode"]
