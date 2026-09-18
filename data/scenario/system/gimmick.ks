;===============================================================================
; gimmick.ks ―― 舞黒館に仕掛けられたギミック
;
;   *gm_radio … ストリームライン・ラジオ（耳で探す選局）
;               開いている間ずっと data/sound/radio_noise.mp3 の雑音が鳴り、
;               特定の周波数に合わせると data/sound/radio.wav の声が聞こえる
;   *gm_dial  … 四桁のダイヤル錠（サンルーム2Fの暖炉）
;   *gm_glass … 三色硝子の重ね絵（資料室の上段本棚）
;
; 読み込み（first.ks）：
;   [call storage="system/gimmick.ks"]
;
; 呼び出し：
;   [call storage="system/gimmick.ks" target="*gm_radio"]
;   → 戻ってきたとき tf.gm_result に "solved" / "quit" が入っている
;
; 注意：
;   ・HTML は全て JavaScript の文字列から組み立てて DOM に挿入する。
;     .ks に生の HTML を書くと、行頭の # や [ をタグ・話者名と誤認されるため。
;   ・ゲーム画面は 1920x1080 の座標系を実サイズに縮小表示している。
;     ドラッグ量は GM.scale() で実ピクセル→ゲーム座標に換算すること。
;===============================================================================

[iscript]
window.GM = {
  // ラジオが読み上げる4桁＝ダイヤル錠の解答。ここだけ直せば両方に反映される
  CODE: "9427",
  // 三色硝子を正しく重ねたときに浮かび上がる四文字
  PHRASE: "執務机裏",

  // ── ラジオの受信帯 ──
  // BAND      … 目盛りの下限／上限（MHz）
  // FREQ      … 声が入っている周波数。TOL_F 以内に留まると受信が確定する
  // WIDTH     … その局の気配が届く幅。ここに入ると雑音が薄れはじめる
  // DECOYS    … 声の入っていないダミー局。雑音は薄れるが信号音が鳴るだけ
  //             （耳で探す手応えを出すための「空振り」。f は BAND 内に置くこと）
  BAND_LO: 85, BAND_HI: 110,
  FREQ: 96.40, TOL_F: 0.24, WIDTH: 1.5,
  DECOYS: [{ f: 89.30, w: 1.10, hz: 520, pulse: 0 },
           { f: 104.10, w: 1.00, hz: 780, pulse: 1 }],

  GOLD:"#C6A460", LIGHT:"#EFDCB6", DARK:"#996736", SUB:"#998E82", FIRE:"#CC7A29",
  TITLE: "'Waosagi',serif",

  base: function(){ return document.getElementById("tyrano_base") || document.body; },

  // 実表示サイズ → 1920x1080 座標系への換算倍率
  scale: function(){
    var r = window.GM.base().getBoundingClientRect();
    return r.width ? (1920 / r.width) : 1;
  },

  css: function(){
    if(document.getElementById("gm-css")){ return; }
    var st = document.createElement("style");
    st.id = "gm-css";
    st.textContent =
        "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:swap}"
      + "@keyframes gmflicker{0%,100%{filter:brightness(1)}47%{filter:brightness(.8)}62%{filter:brightness(.95)}}"
      + "@keyframes gmfade{from{opacity:0}to{opacity:1}}"
      + ".gm-btn{padding:14px 34px;border-radius:6px;border:1px solid #996736;background:rgba(30,20,5,.95);"
      + "color:#EFDCB6;font-size:22px;font-family:inherit;cursor:pointer;letter-spacing:.12em;white-space:nowrap}"
      + ".gm-btn:hover{background:rgba(60,40,10,.95);border-color:#C6A460}"
      + ".gm-btn.gm-on{background:#C6A460;color:#0a0702;border-color:#EFDCB6;font-weight:700}";
    document.head.appendChild(st);
  },

  clear: function(){
    var g = window.GM;
    if(g.raf){ cancelAnimationFrame(g.raf); g.raf = null; }
    if(g.onMove){ window.removeEventListener("pointermove", g.onMove); g.onMove = null; }
    if(g.onUp){ window.removeEventListener("pointerup", g.onUp); g.onUp = null; }
    if(g.onKey){ window.removeEventListener("keydown", g.onKey, true); g.onKey = null; }
    if(g.audio){ try{ g.audio.pause(); }catch(e){} g.audio = null; }
    if(g.holdT){ clearTimeout(g.holdT); g.holdT = null; }
    // ギミック側が登録した後始末（音声の停止など）を実行する
    var jobs = g.cleanup || [];
    g.cleanup = [];
    for(var i=0;i<jobs.length;i++){ try{ jobs[i](); }catch(e){} }
    g.restoreBgm();
    var el = document.getElementById("gm-overlay");
    if(el){ el.remove(); }
  },

  // 画面を閉じるときに必ず呼びたい処理を積んでおく
  onClear: function(fn){
    var g = window.GM;
    if(!g.cleanup){ g.cleanup = []; }
    g.cleanup.push(fn);
  },

  // コンフィグの効果音音量（0〜1）。音で解かせるギミックの基準にする
  seLevel: function(){
    try {
      var v = tyrano.plugin.kag.config.defaultSeVolume;
      if(v === undefined || v === null || v === ""){ return 1; }
      return Math.min(1, Math.max(0, parseInt(v, 10) / 100));
    } catch(e){ return 1; }
  },

  // 音を聴かせるギミックの間だけ BGM を絞る。clear() で必ず戻す
  duckBgm: function(level){
    var g = window.GM;
    if(g.bgmSaved){ return; }
    var saved = {};
    try {
      var map = tyrano.plugin.kag.tmp.map_bgm || {};
      for(var k in map){
        if(map[k] && typeof map[k].volume === "function"){
          saved[k] = map[k].volume();
          map[k].volume(saved[k] * level);
        }
      }
    } catch(e){ return; }
    g.bgmSaved = saved;
  },

  restoreBgm: function(){
    var g = window.GM;
    if(!g.bgmSaved){ return; }
    try {
      var map = tyrano.plugin.kag.tmp.map_bgm || {};
      for(var k in g.bgmSaved){
        if(map[k] && typeof map[k].volume === "function"){ map[k].volume(g.bgmSaved[k]); }
      }
    } catch(e){}
    g.bgmSaved = null;
  },

  // 画面の骨組み。title/lead は左上の見出し、body は中身、foot は下部の操作説明
  shell: function(no, title, lead, body, foot){
    return '<div id="gm-overlay" style="position:absolute;top:0;left:0;width:1920px;height:1080px;'
      + 'overflow:hidden;z-index:999999998;animation:gmfade .3s ease-out;'
      + 'background:radial-gradient(120% 90% at 50% 34%,#241a15 0%,#150f0c 46%,#0a0706 100%);'
      + 'font-family:' + window.GM.TITLE + ';color:' + window.GM.GOLD + '">'
      + '<div style="position:absolute;inset:0;background:repeating-linear-gradient(90deg,'
        + 'rgba(0,0,0,.28) 0 2px,rgba(255,255,255,0) 2px 90px);opacity:.5"></div>'
      + '<div style="position:absolute;inset:0;background:radial-gradient(70% 60% at 50% 42%,'
        + 'rgba(0,0,0,0) 40%,rgba(0,0,0,.72) 100%);pointer-events:none"></div>'
      + '<div style="position:absolute;top:54px;left:76px;display:flex;flex-direction:column;gap:10px">'
        + '<div style="font-size:20px;letter-spacing:.38em;color:' + window.GM.DARK + '">舞黒館の惨劇 ／ GIMMICK ' + no + '</div>'
        + '<div style="font-size:40px;letter-spacing:.12em">' + title + '</div>'
        + '<div style="width:260px;height:1px;background:linear-gradient(90deg,#996736,rgba(153,103,54,0))"></div>'
        + '<div style="font-size:18px;line-height:1.9;color:' + window.GM.SUB + ';letter-spacing:.06em">' + lead + '</div></div>'
      + body
      + '<div style="position:absolute;left:50%;bottom:52px;transform:translateX(-50%);display:flex;'
        + 'align-items:center;gap:26px;font-size:18px;letter-spacing:.12em;white-space:nowrap;'
        + 'color:' + window.GM.SUB + '">' + foot + '</div>'
      + '</div>';
  },

  mount: function(html){
    var g = window.GM;
    g.css(); g.clear();
    var tmp = document.createElement("div");
    tmp.innerHTML = html;
    g.base().appendChild(tmp.firstElementChild);
  },

  el: function(sel){ return document.querySelector("#gm-overlay " + sel); },

  // 「離れる」ボタンなど、画面を閉じて呼び出し元へ戻る共通処理
  finish: function(solved){
    TG.stat.f.tmp_dummy = TG.stat.f.tmp_dummy;   // no-op（式評価の保険）
    tyrano.plugin.kag.variable.tf.gm_result = solved ? "solved" : "quit";
    window.GM.clear();
    tyrano.plugin.kag.ftag.startTag("jump", { target: "*gm_done" });
  },

  // 右下の退出ボタン。解けていれば金色になる
  exitBtn: function(label){
    return '<div style="position:absolute;right:76px;bottom:120px">'
      + '<button class="gm-btn" data-exit="1" style="font-family:' + window.GM.TITLE + '">' + label + '</button></div>';
  },

  bindExit: function(getSolved, label){
    var b = window.GM.el("[data-exit]");
    if(!b){ return; }
    b.onclick = function(){ window.GM.finish(getSolved()); };
    window.GM.exitLabel = label;
  },

  setExit: function(text, on){
    var b = window.GM.el("[data-exit]");
    if(!b){ return; }
    b.textContent = text;
    if(on){ b.className = "gm-btn gm-on"; } else { b.className = "gm-btn"; }
  }
};
[endscript]
[return]


;===============================================================================
; 共通の戻り先
;===============================================================================
*gm_done
[iscript]
if(window.GM){ window.GM.clear(); }
[endscript]
[cm]
[return]


;===============================================================================
; GIMMICK 01 ── ストリームライン・ラジオ
;   画面を開いている間、data/sound/radio_noise.mp3 の雑音がずっと鳴っている。
;   選局つまみで周波数を動かし、雑音が薄れて人の声が浮かぶ一点を耳で探す。
;   合わせきると data/sound/radio.wav が流れ、4桁の数字が読み上げられる。
;
;   ・帯には声の入らないダミー局（GM.DECOYS）が置いてある。
;     そこでも雑音は薄れるが、聞こえるのは信号音だけで声は出ない。
;   ・音を鳴らせない環境（SEを0にしている／自動再生を止められている）でも
;     マジックアイと受信強度計だけで解けるようにしてある。
;===============================================================================
*gm_radio
[cm]
[clearfix]
[hidemenubutton]
[layopt layer="message0" visible=false]
[iscript]
(function(){
var G = window.GM;
var LO = G.BAND_LO, HI = G.BAND_HI, SPAN = HI - LO;
var S = { freq:87.00, solved:false, heard:false, shown:false };

// 声の局とダミー局をひとつの表にまとめる。voice:true が本命
var STATIONS = [{ f:G.FREQ, w:G.WIDTH, voice:true, hz:0, pulse:0 }];
for(var di=0; di<G.DECOYS.length; di++){
  var d = G.DECOYS[di];
  STATIONS.push({ f:d.f, w:d.w, voice:false, hz:d.hz, pulse:d.pulse });
}

// ── 目盛り（1MHz ごとの罫、5MHz ごとに数字） ──
var ticks = "", labels = "";
for(var t=LO; t<=HI; t++){
  var tp = (t - LO) / SPAN * 100;
  var big = (t % 5 === 0);
  ticks += '<div style="position:absolute;left:' + tp.toFixed(3) + '%;bottom:26px;width:1px;'
    + 'height:' + (big ? 26 : 13) + 'px;background:rgba(198,164,96,' + (big ? '.75' : '.34') + ')"></div>';
  if(big){
    labels += '<div style="position:absolute;left:' + tp.toFixed(3) + '%;bottom:4px;transform:translateX(-50%);'
      + 'font-size:16px;color:#996736;letter-spacing:.06em">' + t + '</div>';
  }
}

var body = ""
  + '<div style="position:absolute;left:50%;top:566px;transform:translate(-50%,-50%)">'
  + '<div style="position:relative;width:1300px;height:800px;border-radius:320px 320px 44px 44px;'
    + 'background:linear-gradient(160deg,#4a382c 0%,#33251c 34%,#241a14 68%,#191110 100%);'
    + 'box-shadow:0 60px 90px rgba(0,0,0,.7),inset 0 3px 0 rgba(239,220,182,.18),inset 0 -30px 60px rgba(0,0,0,.6)">'
  + '<div style="position:absolute;left:40px;right:40px;top:26px;height:220px;border-radius:300px 300px 0 0;'
    + 'background:linear-gradient(180deg,rgba(239,220,182,.13),rgba(239,220,182,0));pointer-events:none"></div>'
  + '<div style="position:absolute;inset:0;display:flex;padding:96px 56px 30px 56px;gap:44px;box-sizing:border-box">'

  // 左：スピーカーグリル（受信中は布が細かく震える）
  + '<div style="position:relative;width:420px;border-radius:210px 24px 24px 210px;'
    + 'background:linear-gradient(150deg,#3f2f24,#241a14 60%,#1b1310);'
    + 'box-shadow:0 0 0 2px rgba(0,0,0,.55),inset 0 2px 0 rgba(239,220,182,.14)">'
    + '<div data-cloth="1" style="position:absolute;inset:26px;border-radius:190px 12px 12px 190px;'
      + 'background:repeating-linear-gradient(180deg,#0d0907 0 10px,#6b4a2a 10px 13px,#a87c46 13px 16px,#0d0907 16px 26px);'
      + 'box-shadow:inset 0 0 40px rgba(0,0,0,.85)"></div>'
    + '<div style="position:absolute;left:34px;top:50%;transform:translateY(-50%);display:flex;flex-direction:column;gap:14px">'
      + '<div style="width:96px;height:7px;border-radius:4px;background:linear-gradient(90deg,#d9bd85,#8a6535)"></div>'
      + '<div style="width:128px;height:7px;border-radius:4px;background:linear-gradient(90deg,#d9bd85,#8a6535)"></div>'
      + '<div style="width:160px;height:7px;border-radius:4px;background:linear-gradient(90deg,#d9bd85,#8a6535)"></div>'
    + '</div></div>'

  // 中：真空管と「音声」ランプ。ランプは声を捉えたときだけ灯る
  + '<div style="position:relative;width:92px;display:flex;flex-direction:column;align-items:center;'
    + 'justify-content:center;gap:26px;border-radius:18px;background:linear-gradient(180deg,#15100c,#0d0908);'
    + 'box-shadow:inset 0 0 26px rgba(0,0,0,.9)">'
    + '<div style="position:relative;width:52px;height:118px;border-radius:26px 26px 12px 12px;'
      + 'background:linear-gradient(180deg,rgba(215,226,232,.16),rgba(120,140,150,.08))">'
      + '<div data-tube="1" style="position:absolute;inset:0;border-radius:26px 26px 12px 12px;opacity:.22;'
        + 'background:radial-gradient(60% 46% at 50% 42%,rgba(255,163,64,.95),rgba(204,60,20,.35) 60%,rgba(0,0,0,0) 78%);'
        + 'transition:opacity .9s ease;animation:gmflicker 2.6s infinite"></div></div>'
    + '<div style="position:relative;width:52px;height:118px;border-radius:26px 26px 12px 12px;'
      + 'background:linear-gradient(180deg,rgba(215,226,232,.16),rgba(120,140,150,.08))">'
      + '<div data-tube="2" style="position:absolute;inset:0;border-radius:26px 26px 12px 12px;opacity:.22;'
        + 'background:radial-gradient(60% 46% at 50% 42%,rgba(255,163,64,.95),rgba(204,60,20,.35) 60%,rgba(0,0,0,0) 78%);'
        + 'transition:opacity .9s ease;animation:gmflicker 3.4s infinite"></div></div>'
    + '<div style="display:flex;flex-direction:column;align-items:center;gap:8px">'
      + '<div style="position:relative;width:34px;height:34px;border-radius:50%;'
        + 'background:radial-gradient(circle at 38% 34%,rgba(255,255,255,.2),rgba(0,0,0,.55));'
        + 'box-shadow:inset 0 0 9px rgba(0,0,0,.9),0 0 0 3px rgba(153,103,54,.35)">'
        + '<div data-vlamp="1" style="position:absolute;inset:4px;border-radius:50%;filter:brightness(.1);'
          + 'background:radial-gradient(circle at 50% 45%,#ffd08a,#cc4a14 62%,rgba(0,0,0,0) 80%);'
          + 'transition:filter .5s ease"></div></div>'
      + '<div data-vtext="1" style="font-size:12px;letter-spacing:.16em;color:#5d4c3a;writing-mode:vertical-rl">音声</div>'
    + '</div></div>'

  // 右：周波数目盛り・マジックアイ・受信強度計・つまみ
  + '<div style="flex:1;display:flex;flex-direction:column;align-items:center;gap:12px">'
    + '<div style="display:flex;width:100%;gap:12px;align-items:stretch">'
      + '<div data-scale="1" style="position:relative;flex:1;height:92px;border-radius:12px;overflow:hidden;'
        + 'cursor:ew-resize;touch-action:none;'
        + 'background:linear-gradient(180deg,#17110d,#0e0a08);box-shadow:inset 0 0 22px rgba(0,0,0,.9),0 0 0 2px rgba(153,103,54,.28)">'
        + '<div data-lit="1" style="position:absolute;inset:0;opacity:.12;pointer-events:none;'
          + 'background:radial-gradient(60% 120% at 50% 40%,rgba(255,196,120,.6),rgba(0,0,0,0) 74%);'
          + 'transition:opacity .35s ease"></div>'
        + ticks + labels
        + '<div data-needle="1" style="position:absolute;top:0;bottom:0;left:0;width:3px;margin-left:-1.5px;'
          + 'pointer-events:none;background:linear-gradient(180deg,#EFDCB6,#CC7A29);'
          + 'box-shadow:0 0 14px rgba(204,122,41,.9)"></div></div>'
      + '<div style="width:210px;height:92px;border-radius:12px;display:flex;flex-direction:column;'
        + 'align-items:center;justify-content:center;gap:4px;background:linear-gradient(180deg,#17110d,#0e0a08);'
        + 'box-shadow:inset 0 0 22px rgba(0,0,0,.9),0 0 0 2px rgba(153,103,54,.28)">'
        + '<div data-freq="1" style="font-size:26px;white-space:nowrap;color:#EFDCB6">87.00 MHz</div>'
        + '<div data-band="1" style="font-size:12px;letter-spacing:.28em;color:#6b5946">FM BAND</div></div></div>'

    // マジックアイ（同調指示管）。緑の扇が閉じるほど電波を捉えている
    + '<div style="position:relative;width:250px;height:250px;border-radius:50%;padding:12px;'
      + 'background:linear-gradient(150deg,#e2c68c,#8a6535 45%,#4a3520 70%,#c6a460 100%);'
      + 'box-shadow:0 18px 34px rgba(0,0,0,.7)">'
      + '<div style="position:relative;width:250px;height:250px;border-radius:50%;overflow:hidden;background:#050c07">'
        + '<canvas data-eye="1" width="560" height="560" style="display:block;width:250px;height:250px"></canvas>'
        + '<div style="position:absolute;inset:0;border-radius:50%;pointer-events:none;'
          + 'box-shadow:inset 0 0 54px rgba(0,0,0,.75)"></div></div></div>'

    // 受信強度計
    + '<div style="display:flex;align-items:center;gap:14px;width:560px">'
      + '<div style="font-size:14px;letter-spacing:.22em;color:#6b5946;white-space:nowrap">受信強度</div>'
      + '<div style="position:relative;flex:1;height:14px;border-radius:7px;overflow:hidden;'
        + 'background:#0e0a08;box-shadow:inset 0 0 12px rgba(0,0,0,.9),0 0 0 2px rgba(153,103,54,.24)">'
        + '<div data-meter="1" style="position:absolute;left:0;top:0;bottom:0;width:0%;'
          + 'background:linear-gradient(90deg,#7d5c30,#d9bd85);transition:width .12s linear"></div></div></div>'

    + '<div style="display:flex;align-items:center;gap:40px;margin-top:2px">'
      + '<div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px;width:140px">'
        + '<div style="font-size:17px;letter-spacing:.28em;color:#EFDCB6">選局</div>'
        + '<div style="font-size:13px;letter-spacing:.1em;color:#6b5946">TUNING</div></div>'
      + '<div data-knobf="1" style="position:relative;width:170px;height:170px;border-radius:50%;cursor:ew-resize;'
        + 'touch-action:none;background:conic-gradient(#8a6535 0 2deg,#d9bd85 2deg 4deg,#6b4a2a 4deg 6deg);'
        + 'box-shadow:0 14px 26px rgba(0,0,0,.7)">'
        + '<div style="position:absolute;inset:0;border-radius:50%;pointer-events:none;'
          + 'background:linear-gradient(140deg,rgba(255,255,255,.35),rgba(0,0,0,.45) 62%)"></div>'
        + '<div data-rotf="1" style="position:absolute;inset:0">'
          + '<div style="position:absolute;left:50%;top:10px;width:5px;height:26px;margin-left:-2.5px;'
            + 'border-radius:3px;background:#EFDCB6"></div></div>'
        + '<div data-knobt="1" style="position:absolute;left:50%;top:50%;width:98px;height:98px;margin:-49px 0 0 -49px;'
          + 'border-radius:50%;cursor:ew-resize;touch-action:none;'
          + 'background:conic-gradient(#7d5c30 0 3deg,#e2c68c 3deg 6deg,#5e421f 6deg 9deg);box-shadow:0 8px 16px rgba(0,0,0,.75)">'
          + '<div style="position:absolute;inset:0;border-radius:50%;pointer-events:none;'
            + 'background:linear-gradient(140deg,rgba(255,255,255,.4),rgba(0,0,0,.5) 66%)"></div>'
          + '<div data-rott="1" style="position:absolute;inset:0">'
            + '<div style="position:absolute;left:50%;top:8px;width:4px;height:18px;margin-left:-2px;'
              + 'border-radius:2px;background:#201409"></div></div></div></div>'
      + '<div style="display:flex;flex-direction:column;align-items:flex-start;gap:6px;width:140px">'
        + '<div style="font-size:17px;letter-spacing:.28em;color:#996736">微調整</div>'
        + '<div style="font-size:13px;letter-spacing:.1em;color:#6b5946">FINE</div></div></div>'
  + '</div></div>'
  + '<div style="position:absolute;left:50%;bottom:14px;transform:translateX(-50%);font-size:13px;'
    + 'letter-spacing:.5em;color:rgba(153,103,54,.75)">MAKURO RADIO WORKS · MODEL 1936</div>'
  + '</div></div>'
  + G.exitBtn("ラジオから離れる");

G.mount(G.shell("01", "ストリームライン・ラジオ",
  "雑音の海に、ひとつだけ人の声が紛れている。<br>つまみをゆっくり回し、声の立つ一点を耳で探し当てよ。",
  body,
  '<span>つまみ・目盛りを左右にドラッグ</span>'
  + '<span style="width:1px;height:18px;background:#4a3a2c"></span>'
  + '<span>← → で微調整 ／ ↑ ↓ で大きく動かす</span>'
  + '<span style="width:1px;height:18px;background:#4a3a2c"></span>'
  + '<span data-status="1" style="color:#998E82">雑音しか聞こえない</span>'));

// ────────────────────────────────────────
// 音まわり
//   雑音と声は <audio> の音量で混ぜる（WebAudio に通すと file:// で無音になる
//   環境があるため）。ダミー局の信号音だけ、資源の要らない発振器で鳴らす。
// ────────────────────────────────────────
var AU = { noise:null, voice:null, ctx:null, osc:null, gain:null, started:false, ready:false };

function makeLoop(src){
  var a = new Audio(src);
  a.loop = true;
  a.preload = "auto";
  a.volume = 0;
  return a;
}

// 耳で探させてよいかの判定はここ一箇所に集める。
// 自動再生を止められていても操作をきっかけに鳴りだすことがあるので、状態は行き来する
function audible(){
  return AU.ready && G.seLevel() > 0;
}

function tryPlay(el){
  if(!el){ return; }
  try {
    var p = el.play();
    if(p && p.then){ p.then(playOk, playNg); } else { playOk(); }
  } catch(e){ playNg(); }
}
function playOk(){
  if(AU.noise && !AU.noise.paused){ AU.ready = true; }
}
function playNg(){ AU.ready = false; }

// 耳が使えないときだけ、それを頼らなくてよいと画面で伝える
function syncNotice(){
  var box = G.el("[data-silent]");
  if(audible()){
    if(box){ box.remove(); }
    return;
  }
  if(box){ return; }
  var ov = document.getElementById("gm-overlay");
  if(!ov){ return; }
  box = document.createElement("div");
  box.setAttribute("data-silent", "1");
  box.style.cssText = "position:absolute;top:250px;left:76px;max-width:430px;font-size:16px;line-height:1.8;"
    + "color:#996736;letter-spacing:.04em";
  box.innerHTML = "（音が出ない設定のようだ。<br>受信強度計とマジックアイを頼りに合わせられる）";
  ov.appendChild(box);
}

function startAudio(){
  if(AU.started){ return; }
  AU.started = true;
  AU.ready = true;
  AU.noise = makeLoop("./data/sound/radio_noise.mp3");
  var voiceFile = (window.I18N && window.I18N.isEN()) ? "radio_en.wav" : "radio.wav";
  AU.voice = makeLoop("./data/sound/" + voiceFile);
  AU.noise.onerror = playNg;
  tryPlay(AU.noise);
  tryPlay(AU.voice);

  // ダミー局の信号音。音源を持たせず発振器でまかなう
  try {
    var AC = window.AudioContext || window.webkitAudioContext;
    if(AC){
      AU.ctx = new AC();
      AU.gain = AU.ctx.createGain();
      AU.gain.gain.value = 0;
      AU.gain.connect(AU.ctx.destination);
      AU.osc = AU.ctx.createOscillator();
      AU.osc.type = "sine";
      AU.osc.frequency.value = 520;
      AU.osc.connect(AU.gain);
      AU.osc.start();
    }
  } catch(e){ AU.ctx = null; }
  applyAudio();
}

// 自動再生を止められていても、最初の操作で鳴りはじめるようにしておく
function resumeAudio(){
  if(AU.ctx && AU.ctx.state === "suspended"){ try{ AU.ctx.resume(); }catch(e){} }
  if(AU.noise && AU.noise.paused){ tryPlay(AU.noise); }
  if(AU.voice && AU.voice.paused){ tryPlay(AU.voice); }
}

G.onClear(function(){
  if(AU.noise){ try{ AU.noise.pause(); }catch(e){} AU.noise.src = ""; AU.noise = null; }
  if(AU.voice){ try{ AU.voice.pause(); }catch(e){} AU.voice.src = ""; AU.voice = null; }
  if(AU.osc){ try{ AU.osc.stop(); }catch(e){} AU.osc = null; }
  if(AU.ctx){ try{ AU.ctx.close(); }catch(e){} AU.ctx = null; }
});

// ────────────────────────────────────────
// 受信の計算
// ────────────────────────────────────────
// その局にどれだけ寄れているか（0＝圏外／1＝ぴたり）
function prox(st){
  var d = Math.abs(S.freq - st.f);
  if(d >= st.w){ return 0; }
  var r = 1 - d / st.w;
  return r * r;
}

// いま一番強く捉えている局
function best(){
  var top = null, tp = 0;
  for(var i=0;i<STATIONS.length;i++){
    var p = prox(STATIONS[i]);
    if(p > tp){ tp = p; top = STATIONS[i]; }
  }
  return { st:top, p:tp };
}

function onTarget(){
  return Math.abs(S.freq - G.FREQ) <= G.TOL_F;
}

function applyAudio(){
  if(!AU.started){ return; }
  syncNotice();
  var lv = G.seLevel();
  var b = best();
  if(AU.noise){
    // 局に寄るほど雑音が引く。合わせきると囁く程度まで落ちる
    AU.noise.volume = Math.min(1, Math.max(0, lv * (0.12 + 0.88 * (1 - b.p))));
  }
  if(AU.voice){
    var vp = (b.st && b.st.voice) ? b.p : 0;
    // 合わせきる前は雑音に埋もれた聞こえ方にとどめ、確定してはじめて前に出す
    AU.voice.volume = Math.min(1, Math.max(0, lv * (S.solved ? 1 : 0.34 * vp * vp)));
  }
  if(AU.gain && AU.ctx){
    var tone = 0, hz = 520;
    if(b.st && !b.st.voice){
      hz = b.st.hz;
      tone = 0.16 * b.p * lv;
      // 明滅する信号音のダミー局は、音量そのものを脈打たせる
      if(b.st.pulse){ tone *= 0.55 + 0.45 * Math.sin(Date.now() / 260); }
    }
    try {
      AU.osc.frequency.value = hz;
      AU.gain.gain.value = Math.max(0, tone);
    } catch(e){}
  }
}

// ── 受信確定。声が最初から聞こえるよう頭出しし直す ──
function lockOn(){
  S.solved = true;
  S.heard = true;
  TG.stat.f.radio_code_known = 1;
  if(AU.voice){
    try { AU.voice.currentTime = 0; } catch(e){}
    tryPlay(AU.voice);
  }
  // 声を鳴らせない環境では、詰まないように文字盤へ数字を出す。
  // 一度出したら合わせ直しても消さない（ここでしか数字を読めないため）
  if(!audible()){
    var b = G.el("[data-band]");
    if(b){
      S.shown = true;
      b.textContent = "受信 " + G.CODE;
      b.style.color = "#EFDCB6";
      b.style.letterSpacing = ".2em";
    }
  }
  applyAudio();
  render();
}

function setFreq(v){
  S.freq = Math.min(HI, Math.max(LO, v));
  if(onTarget()){
    if(!S.solved && !G.holdT){
      // ふらついて通り過ぎただけでは確定させない。踏みとどまってはじめて繋がる
      G.holdT = setTimeout(function(){
        G.holdT = null;
        if(onTarget()){ lockOn(); }
      }, 480);
    }
  } else {
    if(G.holdT){ clearTimeout(G.holdT); G.holdT = null; }
    if(S.solved){
      S.solved = false;
      var bd = G.el("[data-band]");
      if(bd && !S.shown){ bd.textContent = "FM BAND"; bd.style.color = "#6b5946"; bd.style.letterSpacing = ".28em"; }
    }
  }
  applyAudio();
  render();
}

// ────────────────────────────────────────
// 描画
// ────────────────────────────────────────
function render(){
  var b = best();
  var q = function(sel){ return G.el(sel); };
  q("[data-freq]").textContent = S.freq.toFixed(2) + " MHz";
  q("[data-rotf]").style.transform = "rotate(" + ((S.freq - LO) / SPAN * 300 - 150) + "deg)";
  q("[data-rott]").style.transform = "rotate(" + ((S.freq - LO) / SPAN * 1440) + "deg)";
  q("[data-needle]").style.left = ((S.freq - LO) / SPAN * 100) + "%";
  q("[data-meter]").style.width = Math.round(b.p * 100) + "%";
  q("[data-lit]").style.opacity = (0.12 + 0.5 * b.p).toFixed(3);
  q("[data-tube='1']").style.opacity = S.solved ? 1 : (0.22 + 0.5 * b.p).toFixed(3);
  q("[data-tube='2']").style.opacity = S.solved ? 1 : (0.22 + 0.5 * b.p).toFixed(3);
  q("[data-vlamp]").style.filter = "brightness(" + (S.solved ? 1 : 0.1) + ")";
  q("[data-vtext]").style.color = S.solved ? "#EFDCB6" : "#5d4c3a";

  var voiceNear = (b.st && b.st.voice) ? b.p : 0;
  var st = q("[data-status]");
  if(S.solved){ st.textContent = "女性の声が、数字を読み上げている"; }
  else if(voiceNear > 0.45){ st.textContent = "雑音の奥に――人の声だ。もう少し"; }
  else if(b.p > 0.45){ st.textContent = "何か拾っている。ただの信号音だ"; }
  else if(b.p > 0.08){ st.textContent = "雑音が薄れた。近くに何かある"; }
  else { st.textContent = "雑音しか聞こえない"; }
  st.style.color = S.solved ? G.FIRE : (voiceNear > 0.45 ? G.LIGHT : "#998E82");

  G.setExit(S.solved ? "数字を書き留めて離れる" : "ラジオから離れる", S.solved);
}

// ── マジックアイ。緑の扇が閉じるほど強く捉えている ──
function frame(){
  var cv = G.el("[data-eye]");
  if(!cv){ return; }
  var x = cv.getContext("2d"), Sz = 560, c = Sz / 2, R = c * 0.9;
  var b = best();
  var p = b.p;
  var lit = 0.34 + 0.66 * p;

  x.clearRect(0, 0, Sz, Sz);
  x.fillStyle = "#050c07";
  x.fillRect(0, 0, Sz, Sz);

  // 蛍光面
  var gr = x.createRadialGradient(c, c, R * 0.1, c, c, R);
  gr.addColorStop(0, "rgba(" + Math.round(150 * lit) + "," + Math.round(255 * lit) + "," + Math.round(160 * lit) + ",1)");
  gr.addColorStop(0.72, "rgba(" + Math.round(40 * lit) + "," + Math.round(190 * lit) + "," + Math.round(90 * lit) + ",1)");
  gr.addColorStop(1, "rgba(6,40,18,1)");
  x.save();
  x.beginPath(); x.arc(c, c, R, 0, Math.PI * 2); x.clip();
  x.fillStyle = gr; x.fillRect(0, 0, Sz, Sz);

  // 放射状の目盛り
  x.strokeStyle = "rgba(6,30,14,.5)";
  x.lineWidth = 2;
  for(var i=0;i<48;i++){
    var a = i / 48 * Math.PI * 2;
    x.beginPath();
    x.moveTo(c + Math.cos(a) * R * 0.24, c + Math.sin(a) * R * 0.24);
    x.lineTo(c + Math.cos(a) * R, c + Math.sin(a) * R);
    x.stroke();
  }

  // 影の扇。捉えていないほど大きく開く
  var half = (4 + 68 * (1 - p)) * Math.PI / 180;
  var jit = S.solved ? 0 : (1 - p) * 0.02 * Math.sin(Date.now() / 47);
  x.fillStyle = "rgba(3,14,7,.93)";
  x.beginPath();
  x.moveTo(c, c);
  x.arc(c, c, R, Math.PI / 2 - half + jit, Math.PI / 2 + half + jit);
  x.closePath();
  x.fill();

  // 雑音まじりのときは粒が走る
  if(p < 0.9){
    var grains = Math.round(90 * (1 - p));
    x.fillStyle = "rgba(200,255,210,.16)";
    for(var k=0;k<grains;k++){
      var ra = Math.random() * Math.PI * 2, rr = Math.sqrt(Math.random()) * R;
      x.fillRect(c + Math.cos(ra) * rr, c + Math.sin(ra) * rr, 3, 3);
    }
  }

  // 中心の遮蔽
  x.fillStyle = "#07130a";
  x.beginPath(); x.arc(c, c, R * 0.2, 0, Math.PI * 2); x.fill();
  x.restore();

  // 針の震え。電波が澄むと止まる
  var nd = G.el("[data-needle]");
  if(nd){
    var amp = S.solved ? 0 : 2.6 * (1 - p);
    var j = amp ? (Math.sin(performance.now() / 26) * amp + Math.sin(performance.now() / 9.3) * amp * 0.5) : 0;
    nd.style.transform = "translateX(" + j.toFixed(2) + "px)";
  }
  var cloth = G.el("[data-cloth]");
  if(cloth){
    var cj = S.solved ? Math.sin(performance.now() / 70) * 0.6 : 0;
    cloth.style.transform = "translateY(" + cj.toFixed(2) + "px)";
  }

  applyAudio();
}

// ────────────────────────────────────────
// 操作
// ────────────────────────────────────────
var drag = null;

G.el("[data-knobf]").onpointerdown = function(ev){
  ev.preventDefault();
  resumeAudio();
  drag = { mode:"knob", k:0.022, x:ev.clientX, v:S.freq };
};
G.el("[data-knobt]").onpointerdown = function(ev){
  ev.stopPropagation(); ev.preventDefault();
  resumeAudio();
  drag = { mode:"knob", k:0.0035, x:ev.clientX, v:S.freq };
};
// 目盛りは直接つまんで動かせる。押した位置に飛ばず、そこからの相対で動く
G.el("[data-scale]").onpointerdown = function(ev){
  ev.preventDefault();
  resumeAudio();
  var w = G.el("[data-scale]").getBoundingClientRect().width;
  drag = { mode:"scale", k:(w ? SPAN / (w * G.scale()) : 0.02), x:ev.clientX, v:S.freq };
};

G.onMove = function(ev){
  if(!drag){ return; }
  var d = (ev.clientX - drag.x) * G.scale();
  setFreq(drag.v + d * drag.k);
};
G.onUp = function(){ drag = null; };
G.onKey = function(ev){
  var k = ev.key, step = 0;
  if(k === "ArrowRight"){ step = 0.04; }
  else if(k === "ArrowLeft"){ step = -0.04; }
  else if(k === "ArrowUp"){ step = 0.5; }
  else if(k === "ArrowDown"){ step = -0.5; }
  else { return; }
  resumeAudio();
  setFreq(S.freq + step);
  ev.preventDefault(); ev.stopPropagation();
};
window.addEventListener("pointermove", G.onMove);
window.addEventListener("pointerup", G.onUp);
window.addEventListener("keydown", G.onKey, true);

G.bindExit(function(){ return S.heard; });

// 雑音を聴き取らせたいので、開いている間だけ BGM を絞る（clear() で戻る）
G.duckBgm(0.22);
startAudio();
render();
G.raf = requestAnimationFrame(function loop(){ frame(); G.raf = requestAnimationFrame(loop); });
})();
[endscript]
[s]


;===============================================================================
; GIMMICK 02 ── 四桁のダイヤル錠
;===============================================================================
*gm_dial
[cm]
[clearfix]
[hidemenubutton]
[layopt layer="message0" visible=false]
[iscript]
(function(){
var G = window.GM;
var code = G.CODE.split("").map(Number);
var S = { digits:[0,0,0,0], turns:[0,0,0,0], focus:0, unlocked:false };

var drums = "";
for(var i=0;i<4;i++){
  var faces = "";
  for(var n=0;n<10;n++){
    faces += '<div style="position:absolute;left:0;right:0;top:50%;height:84px;margin-top:-42px;'
      + 'display:flex;align-items:center;justify-content:center;backface-visibility:hidden;'
      + 'transform:rotateX(' + (-n*36) + 'deg) translateZ(129px);'
      + 'background:linear-gradient(180deg,#3a2a1c,#241a12);'
      + 'box-shadow:inset 0 1px 0 rgba(239,220,182,.16),inset 0 -1px 0 rgba(0,0,0,.7)">'
      + '<span style="font-size:62px;color:#EFDCB6">' + n + '</span></div>';
  }
  drums += '<div data-ring="' + i + '" style="position:relative;width:208px;height:288px;border-radius:22px;'
    + 'cursor:ns-resize;touch-action:none;outline-offset:7px;'
    + 'background:linear-gradient(155deg,#e2c68c 0%,#8a6535 26%,#3e2c1c 62%,#c6a460 100%);'
    + 'box-shadow:0 18px 34px rgba(0,0,0,.7),inset 0 2px 3px rgba(255,255,255,.35)">'
    + '<div style="position:absolute;inset:12px;border-radius:14px;background:#100b07;overflow:hidden;'
      + 'perspective:620px;box-shadow:inset 0 0 34px rgba(0,0,0,.95)">'
      + '<div data-drum="' + i + '" style="position:absolute;inset:0;transform-style:preserve-3d;'
        + 'transition:transform .34s cubic-bezier(.22,.9,.28,1)">' + faces + '</div>'
      + '<div style="position:absolute;inset:0;pointer-events:none;background:linear-gradient(180deg,'
        + 'rgba(6,4,2,.95) 0%,rgba(6,4,2,.35) 26%,rgba(0,0,0,0) 42%,rgba(0,0,0,0) 58%,'
        + 'rgba(6,4,2,.35) 74%,rgba(6,4,2,.95) 100%)"></div>'
      + '<div data-win="' + i + '" style="position:absolute;left:0;right:0;top:50%;height:92px;margin-top:-46px;'
        + 'pointer-events:none;border-top:1px solid rgba(198,164,96,.42);border-bottom:1px solid rgba(198,164,96,.42);'
        + 'background:radial-gradient(70% 100% at 50% 50%,rgba(255,190,110,.05),rgba(0,0,0,0) 76%)"></div></div>'
    + '<div style="position:absolute;left:-9px;top:50%;margin-top:-11px;width:0;height:0;'
      + 'border-top:11px solid transparent;border-bottom:11px solid transparent;border-left:14px solid #d9bd85"></div>'
    + '<div style="position:absolute;right:-9px;top:50%;margin-top:-11px;width:0;height:0;'
      + 'border-top:11px solid transparent;border-bottom:11px solid transparent;border-right:14px solid #d9bd85"></div>'
    + '<div data-pin="' + i + '" style="position:absolute;left:0;right:0;bottom:-34px;text-align:center;'
      + 'font-size:14px;letter-spacing:.34em;color:#5d4c3a">◇</div></div>';
}

var body = ""
  + '<div style="position:absolute;left:50%;top:556px;transform:translate(-50%,-50%)">'
  + '<div style="position:relative;width:1240px;height:700px;border-radius:40px;'
    + 'background:linear-gradient(160deg,#4a382c 0%,#33251c 34%,#241a14 68%,#191110 100%);'
    + 'box-shadow:0 60px 90px rgba(0,0,0,.7),inset 0 3px 0 rgba(239,220,182,.18),inset 0 -30px 60px rgba(0,0,0,.6)">'
  + '<div style="position:absolute;inset:22px;border-radius:26px;border:2px solid rgba(198,164,96,.18);pointer-events:none"></div>'
  + '<div style="position:absolute;left:60px;top:58px;display:flex;align-items:center;gap:18px">'
    + '<div style="width:26px;height:26px;transform:rotate(45deg);background:linear-gradient(140deg,#d9bd85,#7d5c30)"></div>'
    + '<div style="font-size:17px;letter-spacing:.42em;color:#996736">MAKURO SAFE CO. · SERIES IV</div></div>'
  + '<div style="position:absolute;right:60px;top:52px;display:flex;align-items:center;gap:20px">'
    + '<div style="font-size:15px;letter-spacing:.3em;color:#6b5946">LATCH</div>'
    + '<div style="position:relative;width:40px;height:40px;border-radius:50%;'
      + 'background:radial-gradient(circle at 38% 34%,rgba(255,255,255,.22),rgba(0,0,0,.5));'
      + 'box-shadow:inset 0 0 10px rgba(0,0,0,.9),0 0 0 3px rgba(153,103,54,.35)">'
      + '<div data-lamp="1" style="position:absolute;inset:5px;border-radius:50%;filter:brightness(.1);'
        + 'background:radial-gradient(circle at 50% 45%,#ffd08a,#cc4a14 62%,rgba(0,0,0,0) 80%);'
        + 'transition:filter .8s ease;animation:gmflicker 3.1s infinite"></div></div></div>'
  + '<div style="position:absolute;left:50%;top:336px;transform:translate(-50%,-50%);display:flex;'
    + 'align-items:center;gap:26px">' + drums + '</div>'
  + '<div style="position:absolute;left:50%;top:528px;transform:translateX(-50%);width:940px;height:40px;'
    + 'border-radius:8px;overflow:hidden;background:linear-gradient(180deg,#15100c,#0d0908);'
    + 'box-shadow:inset 0 0 22px rgba(0,0,0,.9)">'
    + '<div data-bolt="1" style="position:absolute;left:6px;top:6px;bottom:6px;width:300px;border-radius:5px;'
      + 'background:linear-gradient(180deg,#d9bd85,#6b4a2a);transform:translateX(0);'
      + 'transition:transform 1.1s cubic-bezier(.3,.8,.2,1)"></div></div>'
  + '<div data-statusrow="1" style="position:absolute;left:50%;bottom:44px;transform:translateX(-50%);display:flex;'
    + 'align-items:center;gap:18px;opacity:0;transition:opacity .6s ease">'
    + '<div style="width:8px;height:8px;transform:rotate(45deg);background:rgba(198,164,96,.6)"></div>'
    + '<div data-status="1" style="font-size:20px;letter-spacing:.18em;color:#998E82"></div>'
    + '<div style="width:8px;height:8px;transform:rotate(45deg);background:rgba(198,164,96,.6)"></div></div>'
  + '</div></div>'
  + G.exitBtn("錠から離れる");

G.mount(G.shell("02", "四桁のダイヤル錠",
  "四つの真鍮環をまわし、<br>耳にした四桁の数字を揃えよ。",
  body,
  '<span>環を上下にドラッグ</span>'
  + '<span style="width:1px;height:18px;background:#4a3a2c"></span>'
  + '<span>← → で桁を選び ↑ ↓ で数字を送る／数字キーも可</span>'));

function render(){
  // どの桁が合っているかは見せない。開くまでは全ての環を同じ見た目にしておく
  for(var i=0;i<4;i++){
    G.el("[data-drum='" + i + "']").style.transform = "rotateX(" + (S.turns[i]*36) + "deg)";
    G.el("[data-ring='" + i + "']").style.outline = (S.focus === i) ? "2px solid rgba(239,220,182,.55)" : "none";
    G.el("[data-win='" + i + "']").style.background = "radial-gradient(70% 100% at 50% 50%,rgba(255,190,110,"
      + (S.unlocked ? 0.34 : 0.05) + "),rgba(0,0,0,0) 76%)";
    var pin = G.el("[data-pin='" + i + "']");
    pin.textContent = S.unlocked ? "◆" : "◇";
    pin.style.color = S.unlocked ? "#CC7A29" : "#5d4c3a";
  }
  var st = G.el("[data-status]");
  st.textContent = S.unlocked ? "閂が外れた" : "";
  st.style.color = G.FIRE;
  G.el("[data-statusrow]").style.opacity = S.unlocked ? 1 : 0;
  G.el("[data-lamp]").style.filter = "brightness(" + (S.unlocked ? 1 : 0.1) + ")";
  G.el("[data-bolt]").style.transform = S.unlocked ? "translateX(620px)" : "translateX(0)";
  G.setExit(S.unlocked ? "扉を開ける" : "錠から離れる", S.unlocked);
}

function setDigit(i, turns){
  S.turns[i] = turns;
  S.digits[i] = ((turns % 10) + 10) % 10;
  var ok = true;
  for(var k=0;k<4;k++){ if(S.digits[k] !== code[k]){ ok = false; } }
  clearTimeout(G.holdT);
  if(ok && !S.unlocked){
    G.holdT = setTimeout(function(){
      S.unlocked = true;
      try{ TG.ftag.startTag("playse", { storage:"door_open.mp3", volume:80, buf:3 }); }catch(e){}
      render();
    }, 500);
  } else if(!ok && S.unlocked){
    S.unlocked = false;
  }
  render();
}

var drag = null;
for(var r=0;r<4;r++){
  (function(idx){
    G.el("[data-ring='" + idx + "']").onpointerdown = function(ev){
      ev.preventDefault();
      drag = { i:idx, y:ev.clientY, v:S.turns[idx], last:0 };
      S.focus = idx; render();
    };
  })(r);
}
G.onMove = function(ev){
  if(!drag){ return; }
  var step = Math.round((drag.y - ev.clientY) * G.scale() / 34);
  if(step !== drag.last){ drag.last = step; setDigit(drag.i, drag.v + step); }
};
G.onUp = function(){ drag = null; };
G.onKey = function(ev){
  var k = ev.key;
  if(k === "ArrowLeft" || k === "ArrowRight"){
    S.focus = (S.focus + (k === "ArrowRight" ? 1 : 3)) % 4; render();
    ev.preventDefault(); ev.stopPropagation(); return;
  }
  if(k === "ArrowUp" || k === "ArrowDown"){
    setDigit(S.focus, S.turns[S.focus] + (k === "ArrowUp" ? 1 : -1));
    ev.preventDefault(); ev.stopPropagation(); return;
  }
  if(/^[0-9]$/.test(k)){
    var i = S.focus, cur = S.digits[i], want = Number(k), diff = want - cur;
    if(diff > 5){ diff -= 10; } else if(diff < -5){ diff += 10; }
    setDigit(i, S.turns[i] + diff);
    S.focus = (i + 1) % 4; render();
    ev.preventDefault(); ev.stopPropagation();
  }
};
window.addEventListener("pointermove", G.onMove);
window.addEventListener("pointerup", G.onUp);
window.addEventListener("keydown", G.onKey, true);

G.bindExit(function(){ return S.unlocked; });
render();
})();
[endscript]
[s]


;===============================================================================
; GIMMICK 03 ── 三色硝子の重ね絵
;   青・赤・緑の硝子板を灯火の板の上で重ねると四文字が浮かび上がる
;===============================================================================
*gm_glass
[cm]
[clearfix]
[hidemenubutton]
[layopt layer="message0" visible=false]
[iscript]
(function(){
var G = window.GM;
var defs = [
  { key:"blue",  color:[40,78,190],  start:[22,12],   target:[160,60]  },
  { key:"red",   color:[198,40,44],  start:[372,214], target:[200,200] },
  { key:"green", color:[34,140,74],  start:[30,206],  target:[215,140] }
];
var S = { pos:{ blue:[22,12], red:[372,214], green:[30,206] }, top:"blue", focus:"blue", solved:false };
var PW = 620, PH = 420, MAXX = 380, MAXY = 220, TOL = 40;

var panes = "";
for(var i=0;i<defs.length;i++){
  var d = defs[i];
  panes += '<div data-pane="' + d.key + '" style="position:absolute;left:0;top:0;width:620px;height:420px;'
    + 'cursor:grab;touch-action:none;mix-blend-mode:multiply;z-index:1;'
    + 'transform:translate(' + d.start[0] + 'px,' + d.start[1] + 'px)">'
    + '<canvas data-glass="' + d.key + '" width="1240" height="840" style="display:block;width:620px;height:420px"></canvas>'
    + '<div style="position:absolute;inset:0;pointer-events:none;border:9px solid rgba(126,92,48,.62);'
      + 'box-shadow:inset 0 0 0 2px rgba(60,40,18,.4)"></div>'
    + '<div style="position:absolute;left:9px;top:9px;width:44px;height:44px;pointer-events:none;'
      + 'border-left:4px solid rgba(126,92,48,.5);border-top:4px solid rgba(126,92,48,.5)"></div>'
    + '<div style="position:absolute;right:9px;bottom:9px;width:44px;height:44px;pointer-events:none;'
      + 'border-right:4px solid rgba(126,92,48,.5);border-bottom:4px solid rgba(126,92,48,.5)"></div></div>';
}

var body = ""
  + '<div style="position:absolute;right:96px;top:64px;display:flex;align-items:center;gap:20px">'
    + '<div style="font-size:15px;letter-spacing:.3em;color:#6b5946">LAMP</div>'
    + '<div style="position:relative;width:40px;height:40px;border-radius:50%;'
      + 'background:radial-gradient(circle at 38% 34%,rgba(255,255,255,.22),rgba(0,0,0,.5));'
      + 'box-shadow:inset 0 0 10px rgba(0,0,0,.9),0 0 0 3px rgba(153,103,54,.35)">'
      + '<div data-lamp="1" style="position:absolute;inset:5px;border-radius:50%;filter:brightness(.12);'
        + 'background:radial-gradient(circle at 50% 45%,#ffd08a,#cc4a14 62%,rgba(0,0,0,0) 80%);'
        + 'transition:filter .8s ease;animation:gmflicker 3.1s infinite"></div></div></div>'
  + '<div style="position:absolute;left:50%;top:570px;transform:translate(-50%,-50%)">'
  + '<div style="position:relative;width:1120px;height:760px;border-radius:26px;display:flex;'
    + 'align-items:center;justify-content:center;'
    + 'background:linear-gradient(160deg,#4a382c 0%,#33251c 34%,#241a14 68%,#191110 100%);'
    + 'box-shadow:0 60px 90px rgba(0,0,0,.7),inset 0 3px 0 rgba(239,220,182,.18),inset 0 -30px 60px rgba(0,0,0,.6)">'
    + '<div style="position:absolute;inset:18px;border-radius:16px;pointer-events:none;'
      + 'border:2px solid rgba(198,164,96,.16)"></div>'
    + '<div style="position:relative;width:1000px;height:640px;border-radius:8px;overflow:hidden;isolation:isolate;'
      + 'background:radial-gradient(72% 80% at 50% 46%,#fdf3df 0%,#f0dfbf 52%,#cbb18a 100%);'
      + 'box-shadow:inset 0 0 0 3px rgba(120,84,44,.7),0 0 70px rgba(255,206,132,.18)">'
      + '<div style="position:absolute;inset:0;pointer-events:none;background:'
        + 'repeating-linear-gradient(90deg,rgba(120,84,44,.12) 0 1px,rgba(0,0,0,0) 1px 46px),'
        + 'repeating-linear-gradient(180deg,rgba(120,84,44,.12) 0 1px,rgba(0,0,0,0) 1px 46px)"></div>'
      + panes
      + '<div data-glow="1" style="position:absolute;inset:0;pointer-events:none;opacity:0;'
        + 'transition:opacity 1.1s ease;mix-blend-mode:screen;'
        + 'background:radial-gradient(60% 60% at 50% 50%,rgba(255,214,150,.55),rgba(255,180,90,0) 72%)"></div>'
    + '</div></div></div>'
  + G.exitBtn("硝子から離れる");

G.mount(G.shell("03", "三色硝子の重ね絵",
  "屋敷に散らばる、青・赤・緑の硝子。<br>灯火の板に重ねよ。",
  body,
  '<span>硝子をドラッグして重ねる</span>'
  + '<span style="width:1px;height:18px;background:#4a3a2c"></span>'
  + '<span>Tab で持ち替え ／ 矢印キーで微動</span>'
  + '<span style="width:1px;height:18px;background:#4a3a2c"></span>'
  + '<span data-status="1" style="color:#998E82">ただの色硝子</span>'));

// ── 四文字を細かいセルに割り、三枚へ均等に配る ──
// 一枚だけ見ても模様にしか見えず、正しく重ねたときだけ字が結ばれる
function paint(){
  var W = 1120, H = 440;
  var cv = document.createElement("canvas");
  cv.width = W; cv.height = H;
  var m = cv.getContext("2d");
  m.fillStyle = "#000"; m.textAlign = "center"; m.textBaseline = "middle";
  m.font = "600 300px 'Yu Mincho',YuMincho,'Hiragino Mincho ProN',serif";
  var chars = G.PHRASE.split("");
  for(var ci=0;ci<chars.length;ci++){
    m.fillText(chars[ci], W/chars.length*(ci+0.5), H/2 + 8);
  }
  var src = m.getImageData(0,0,W,H).data;

  var seed = 20260812;
  var rnd = function(){ seed = (seed*1664525 + 1013904223) % 4294967296; return seed/4294967296; };
  var seeds = [];
  for(var s=0;s<96;s++){ seeds.push({ x:rnd()*W, y:rnd()*H, g:s%3 }); }

  // 最近傍セルは全ペイン共通なので一度だけ求める
  var owner = new Int8Array(W*H);
  for(var py=0;py<H;py++){
    for(var px=0;px<W;px++){
      var idx = py*W + px;
      if(src[idx*4+3] < 40){ owner[idx] = -1; continue; }
      var best = 0, bd = Infinity;
      for(var k=0;k<seeds.length;k++){
        var dx = seeds[k].x - px, dy = seeds[k].y - py, dd = dx*dx + dy*dy;
        if(dd < bd){ bd = dd; best = k; }
      }
      owner[idx] = seeds[best].g;
    }
  }

  var TX = 440, TY = 420;
  for(var gi=0;gi<defs.length;gi++){
    var d = defs[gi];
    var el = G.el("[data-glass='" + d.key + "']");
    if(!el){ continue; }
    var x = el.getContext("2d");
    x.clearRect(0,0,PW*2,PH*2);

    // 一枚だけでは装飾に見えるよう、同じ色の飾り罫を散らす
    x.save();
    x.strokeStyle = "rgba(" + d.color.join(",") + ",0.30)";
    x.lineWidth = 7;
    var s2 = 900 + gi*77;
    var r2 = function(){ s2 = (s2*1664525 + 1013904223) % 4294967296; return s2/4294967296; };
    for(var i2=0;i2<26;i2++){
      var ax = r2()*PW*2, ay = r2()*PH*2, len = 60 + r2()*190;
      var ang = (Math.floor(r2()*4)*45 + 22) * Math.PI/180;
      x.beginPath(); x.moveTo(ax, ay); x.lineTo(ax + Math.cos(ang)*len, ay + Math.sin(ang)*len); x.stroke();
    }
    x.restore();

    var off = document.createElement("canvas");
    off.width = W; off.height = H;
    var ox = off.getContext("2d");
    var out = ox.createImageData(W, H);
    for(var p=0;p<W*H;p++){
      if(owner[p] !== gi){ continue; }
      out.data[p*4]   = d.color[0];
      out.data[p*4+1] = d.color[1];
      out.data[p*4+2] = d.color[2];
      out.data[p*4+3] = 255;
    }
    ox.putImageData(out, 0, 0);
    x.drawImage(off, TX - d.target[0]*2, TY - d.target[1]*2);

    x.fillStyle = "rgba(" + d.color.join(",") + ",0.17)";
    x.fillRect(0, 0, PW*2, PH*2);
  }
}

function def(key){
  for(var i=0;i<defs.length;i++){ if(defs[i].key === key){ return defs[i]; } }
  return defs[0];
}

function render(){
  var near = 0;
  for(var i=0;i<defs.length;i++){
    var d = defs[i], p = S.pos[d.key];
    var dist = Math.max(Math.abs(p[0]-d.target[0]), Math.abs(p[1]-d.target[1]));
    if(dist <= TOL){ near++; }
    var el = G.el("[data-pane='" + d.key + "']");
    el.style.transform = "translate(" + p[0] + "px," + p[1] + "px)";
    el.style.zIndex = (S.top === d.key) ? 3 : 1;
  }
  G.el("[data-glow]").style.opacity = S.solved ? 1 : 0;
  G.el("[data-lamp]").style.filter = "brightness(" + (S.solved ? 1 : 0.12) + ")";
  var st = G.el("[data-status]");
  st.textContent = S.solved ? "四文字が結ばれた"
    : near === 2 ? "文字の形が見え始めた" : near === 1 ? "色が噛み合いはじめる" : "ただの色硝子";
  st.style.color = S.solved ? G.FIRE : "#998E82";
  G.setExit(S.solved ? "文字を読み取って離れる" : "硝子から離れる", S.solved);
}

function check(){
  var ok = true;
  for(var i=0;i<defs.length;i++){
    var d = defs[i], p = S.pos[d.key];
    if(Math.abs(p[0]-d.target[0]) > TOL || Math.abs(p[1]-d.target[1]) > TOL){ ok = false; }
  }
  clearTimeout(G.holdT);
  if(ok && !S.solved){
    G.holdT = setTimeout(function(){ S.solved = true; render(); }, 450);
  } else if(!ok && S.solved){
    S.solved = false;
  }
  render();
}

function move(key, nx, ny){
  S.pos[key] = [Math.max(0, Math.min(MAXX, nx)), Math.max(0, Math.min(MAXY, ny))];
  S.top = key;
  check();
}

function snap(key){
  var d = def(key), p = S.pos[key], t = TOL + 14;
  if(Math.abs(p[0]-d.target[0]) <= t && Math.abs(p[1]-d.target[1]) <= t){
    move(key, d.target[0], d.target[1]);
  }
}

var drag = null;
for(var q=0;q<defs.length;q++){
  (function(key){
    G.el("[data-pane='" + key + "']").onpointerdown = function(ev){
      ev.preventDefault();
      drag = { key:key, x:ev.clientX, y:ev.clientY, v:S.pos[key].slice() };
      S.top = key; S.focus = key; render();
    };
  })(defs[q].key);
}
G.onMove = function(ev){
  if(!drag){ return; }
  var sc = G.scale();
  move(drag.key, drag.v[0] + (ev.clientX - drag.x)*sc, drag.v[1] + (ev.clientY - drag.y)*sc);
};
G.onUp = function(){ if(drag){ snap(drag.key); drag = null; } };
G.onKey = function(ev){
  if(ev.key === "Tab"){
    var i = 0;
    for(var k=0;k<defs.length;k++){ if(defs[k].key === S.focus){ i = k; } }
    S.focus = defs[(i+1)%3].key; S.top = S.focus; render();
    ev.preventDefault(); ev.stopPropagation(); return;
  }
  var map = { ArrowLeft:[-2,0], ArrowRight:[2,0], ArrowUp:[0,-2], ArrowDown:[0,2] };
  var mv = map[ev.key];
  if(!mv){ return; }
  var p = S.pos[S.focus];
  move(S.focus, p[0] + mv[0], p[1] + mv[1]);
  ev.preventDefault(); ev.stopPropagation();
};
window.addEventListener("pointermove", G.onMove);
window.addEventListener("pointerup", G.onUp);
window.addEventListener("keydown", G.onKey, true);

G.bindExit(function(){ return S.solved; });
paint();
render();
})();
[endscript]
[s]
