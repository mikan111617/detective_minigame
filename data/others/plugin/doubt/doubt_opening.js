/*
 * ダウト ミニゲーム オープニングムービー
 *
 * [doubt_opening]  注意書きの後、タイトル画面の前に一度だけ流す（title.ks から呼ぶ）
 *
 *   1. 煉瓦書架 PRESENTS … 煉瓦と本の背表紙が一段ずつ積み上がって壁になり、
 *                           その前にロゴが降りてきて光が走る
 *   2. タイトルロゴ落下   … タイトル画面の背景が暗く浮かび、金属質の
 *                           「舞黒館の惨劇」が落ちてきて閃光とともに着地
 *
 *   クリック／キーで、途中ならタイトルロゴの完成形まで飛ばし、
 *   完成後ならムービーを閉じる。触らなければ T.end で自然に閉じる。
 *
 *   BGM は data/bgm/opening.mp3（約5秒）。T.bgm の時刻に鳴らし始める。
 *   ファイルが無い・音声がまだ解禁されていない時は、無音のまま進む。
 *   煉瓦の音・着地の音は WebAudio で合成している（録音素材は使っていない）。
 */
(function () {
  "use strict";

  var W = 384, H = 216;   // 煉瓦の壁を描く低解像度キャンバス（5 倍で表示）
  var LOGO = "./data/image/doubt/opening/renga_logo.png";
  var BGM = "./data/bgm/opening.mp3";
  var TITLE_BG = "./data/image/doubt/bg/bg-title.png";   // タイトル画面と同じ背景

  // ── 時刻表（秒）──────────────────────────────────────────
  var T = {
    bricks:   0.15,  // 煉瓦が降り始める
    logoIn:   1.55,  // 煉瓦書架ロゴ
    shine:    2.15,
    presents: 2.70,
    logoOut:  4.10,
    scene:    4.50,  // タイトルの背景が浮かぶ
    bgm:      4.50,  // opening.mp3 を鳴らし始める
    slam:     5.20,  // タイトルが落ち始める
    land:     5.75,  // 着地（閃光）
    sub:      6.10,
    copy:     6.70,
    start:    7.30,  // PRESS START
    end:     12.00,  // 触らなければここで閉じる
  };

  var clamp = function (v, a, b) { return v < a ? a : v > b ? b : v; };
  var lerp = function (a, b, p) { return a + (b - a) * p; };
  var ease = function (p) { return 1 - Math.pow(1 - p, 3); };
  // 行ごとに固定の擬似乱数。波頭や窓の明かりがフレームごとにちらつかないように
  var hash = function (n) { var s = Math.sin(n * 127.1) * 43758.5453; return s - Math.floor(s); };

  function h(tag, cls, html) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html != null) e.innerHTML = html;
    return e;
  }

  function volumeOf(v) {
    try {
      var n = $.parseVolume(v);
      return isNaN(n) ? 1 : clamp(n, 0, 1);
    } catch (e) { return 1; }
  }

  // ── 煉瓦の壁 ──────────────────────────────────────────────
  //   一段 8px、煉瓦 16px の馬踏み目地。下の段から順に降ってくる。
  //   ところどころは本棚の区画で、背表紙が並んでいる（煉瓦書架）。
  var BRICK_W = 16, BRICK_H = 8, WALL_TOP = 36, WALL_ROWS = 17;
  var BRICK_COL = ["#8e3b22", "#a4482a", "#7a3019", "#b25630", "#6b2a17", "#9a4026"];
  var BOOK_COL = ["#8f2a22", "#2f5a3a", "#2c3f6b", "#d9c9a0", "#6b3f1f", "#7d6a2a"];

  var bricks = (function () {
    var list = [];
    for (var r = 0; r < WALL_ROWS; r++) {
      var y = WALL_TOP + r * BRICK_H;
      var off = r % 2 ? -BRICK_W / 2 : 0;
      var fromBottom = WALL_ROWS - 1 - r;
      for (var x = off; x < W; x += BRICK_W) {
        var seed = r * 97 + x;
        // 本棚の区画は真ん中あたりの段だけ、まばらに
        var book = r > 2 && r < WALL_ROWS - 3 && hash(seed + 0.5) < 0.09;
        list.push({
          x: x, y: y, book: book,
          col: BRICK_COL[(hash(seed) * BRICK_COL.length) | 0],
          t0: T.bricks + fromBottom * 0.062 + hash(seed + 3) * 0.26,
          seed: seed,
        });
      }
    }
    return list;
  })();
  var BRICK_FALL = 0.30;

  function drawBrick(ctx, b, y) {
    if (b.book) {
      ctx.fillStyle = "#1a0f0a";
      ctx.fillRect(b.x, y, BRICK_W - 1, BRICK_H - 1);
      var bx = b.x + 1;
      for (var k = 0; k < 5 && bx < b.x + BRICK_W - 2; k++) {
        var w = 2 + ((hash(b.seed + k * 7) * 2) | 0);
        var top = 1 + ((hash(b.seed + k * 11) * 2) | 0);
        ctx.fillStyle = BOOK_COL[(hash(b.seed + k) * BOOK_COL.length) | 0];
        ctx.fillRect(bx, y + top, w, BRICK_H - 1 - top);
        ctx.fillStyle = "rgba(247,208,70,.55)";   // 背表紙の金の帯
        ctx.fillRect(bx, y + top + 2, w, 1);
        bx += w + 0;
      }
      return;
    }
    ctx.fillStyle = b.col;
    ctx.fillRect(b.x, y, BRICK_W - 1, BRICK_H - 1);
    ctx.fillStyle = "rgba(255,200,150,.18)";   // 上の縁の光
    ctx.fillRect(b.x, y, BRICK_W - 1, 1);
    ctx.fillStyle = "rgba(0,0,0,.28)";         // 下の縁の影
    ctx.fillRect(b.x, y + BRICK_H - 2, BRICK_W - 1, 1);
    if (hash(b.seed + 9) < 0.35) {             // ざらつき
      ctx.fillStyle = "rgba(40,12,6,.35)";
      ctx.fillRect(b.x + 2 + ((hash(b.seed + 4) * 10) | 0), y + 2 + ((hash(b.seed + 5) * 3) | 0), 2, 1);
    }
  }

  // ── タグ ──────────────────────────────────────────────────
  function play() {
    return new Promise(function (resolve) {
      var base = document.querySelector(".tyrano_base") || document.body;
      bricks.forEach(function (b) { b.down = false; });
      var root = h("div", "dbt-root dbt-opening");
      base.appendChild(root);

      var stage = h("div", "op-stage");
      root.appendChild(stage);
      var cv = h("canvas", "op-canvas");
      cv.width = W; cv.height = H;
      stage.appendChild(cv);
      var ctx = cv.getContext("2d", { alpha: false });
      ctx.imageSmoothingEnabled = false;
      // タイトルロゴの後ろに敷く背景（キャンバスの上、ロゴの下）
      var titleBg = h("div", "op-titlebg");
      titleBg.style.backgroundImage = "url('" + TITLE_BG + "')";
      stage.appendChild(titleBg);

      // 煉瓦書架 PRESENTS
      var pub = h("div", "op-pub");
      var logo = h("img", "op-logo");
      logo.src = LOGO;
      logo.alt = "煉瓦書架";
      var shineEl = h("div", "op-logo-shine");
      shineEl.style.webkitMaskImage = shineEl.style.maskImage = "url('" + LOGO + "')";
      var logoBox = h("div", "op-logobox");
      logoBox.appendChild(logo);
      logoBox.appendChild(shineEl);
      pub.appendChild(logoBox);
      var presents = h("div", "op-presents", "PRESENTS");
      pub.appendChild(presents);
      stage.appendChild(pub);

      // タイトル
      var titleWrap = h("div", "op-titlewrap");
      var title = h("div", "op-title",
        '<span class="back">舞黒館の惨劇</span><span class="front">舞黒館の惨劇</span>');
      var titleFront = title.querySelector(".front");
      var sub = h("div", "op-sub",
        '<span class="back">探偵少女はダウトで勝ちの目を見るか</span><span class="front">探偵少女はダウトで勝ちの目を見るか</span>');
      titleWrap.appendChild(title);
      titleWrap.appendChild(sub);
      stage.appendChild(titleWrap);
      var press = h("div", "op-press", "PRESS START");
      stage.appendChild(press);
      var copy = h("div", "op-copy", "© " + new Date().getFullYear() + " 煉瓦書架");
      stage.appendChild(copy);

      var flashEl = h("div", "op-flash");
      root.appendChild(flashEl);
      root.appendChild(h("div", "op-scan"));

      // ── 状態 ──
      var t = 0, last = 0, flash = 0, shake = 0;
      var landed = false, done = false, closing = false, raf = 0, hold = false;
      var bgmStarted = false, bgm = null;
      var nextThud = 0;

      // ── 音 ──
      var kag = TYRANO.kag;
      var bgmVol = kag.stat.play_bgm === false ? 0 : volumeOf(kag.config.defaultBgmVolume);
      var seVol = kag.stat.play_se === false ? 0 : volumeOf(kag.config.defaultSeVolume);
      var AC = null;

      function noiseBuffer(secs) {
        var b = AC.createBuffer(1, AC.sampleRate * secs, AC.sampleRate);
        var d = b.getChannelData(0), v = 0;
        for (var k = 0; k < d.length; k++) { v = (v + (Math.random() * 2 - 1) * 0.06) * 0.985; d[k] = v * 3.2; }
        return b;
      }

      function initAudio() {
        if (AC || !(seVol > 0)) return;
        try {
          AC = new (window.AudioContext || window.webkitAudioContext)();
          if (AC.state === "suspended" && AC.resume) AC.resume().catch(function () {});
        } catch (e) { AC = null; }
      }

      function boom(level, tone) {
        if (!AC) return;
        try {
          var now = AC.currentTime;
          var src = AC.createBufferSource(); src.buffer = noiseBuffer(2);
          var lp = AC.createBiquadFilter(); lp.type = "lowpass";
          lp.frequency.setValueAtTime(tone, now);
          lp.frequency.exponentialRampToValueAtTime(70, now + 1.5);
          var g = AC.createGain();
          g.gain.setValueAtTime(0.0001, now);
          g.gain.exponentialRampToValueAtTime(level * seVol + 0.0001, now + 0.05);
          g.gain.exponentialRampToValueAtTime(0.0001, now + 1.7);
          src.connect(lp).connect(g).connect(AC.destination);
          src.start(now); src.stop(now + 1.8);
        } catch (e) {}
      }

      // 煉瓦が積まれる「ごとっ」
      function thud() {
        if (!AC) return;
        try {
          var now = AC.currentTime;
          var o = AC.createOscillator(); o.type = "triangle";
          o.frequency.setValueAtTime(150 + Math.random() * 40, now);
          o.frequency.exponentialRampToValueAtTime(55, now + 0.09);
          var g = AC.createGain();
          g.gain.setValueAtTime(0.16 * seVol + 0.0001, now);
          g.gain.exponentialRampToValueAtTime(0.0001, now + 0.12);
          o.connect(g).connect(AC.destination);
          o.start(now); o.stop(now + 0.14);
        } catch (e) {}
      }

      function startBgm() {
        if (bgmStarted) return;
        bgmStarted = true;
        if (!(bgmVol > 0)) return;
        try {
          bgm = new Audio(BGM);
          bgm.volume = bgmVol;
          var pr = bgm.play();
          if (pr && pr.catch) pr.catch(function () { bgm = null; });
        } catch (e) { bgm = null; }
      }

      function stopSound(fadeMs) {
        var a = bgm;
        bgm = null;
        if (a) {
          var v0 = a.volume, t0 = performance.now();
          var fade = function () {
            var p = clamp((performance.now() - t0) / fadeMs, 0, 1);
            try { a.volume = v0 * (1 - p); } catch (e) {}
            if (p < 1) setTimeout(fade, 30);
            else { try { a.pause(); } catch (e) {} }
          };
          fade();
        }
        if (AC) {
          var ac = AC;
          AC = null;
          setTimeout(function () { try { ac.close(); } catch (e) {} }, fadeMs + 200);
        }
      }

      // 煉瓦書架のカード
      function drawWall(alpha) {
        ctx.save();
        ctx.globalAlpha = alpha;
        ctx.fillStyle = "#140c08";
        ctx.fillRect(0, WALL_TOP, W, WALL_ROWS * BRICK_H);
        var landedNow = 0;
        for (var i = 0; i < bricks.length; i++) {
          var b = bricks[i];
          var p = (t - b.t0) / BRICK_FALL;
          if (p <= 0) continue;
          if (p >= 1) {
            if (!b.down) { b.down = true; landedNow++; }
            drawBrick(ctx, b, b.y);
          } else {
            drawBrick(ctx, b, lerp(-BRICK_H - 4, b.y, p * p));  // 重力で落ちる
          }
        }
        if (landedNow && t >= nextThud) { thud(); nextThud = t + 0.075; }

        // ロゴの後ろのランプの灯り
        var glow = clamp((t - T.logoIn + 0.3) / 0.8, 0, 1);
        if (glow > 0) {
          // ロゴが来たら壁を一段沈めて、ロゴを浮かせる
          ctx.fillStyle = "rgba(8,4,2," + (0.45 * glow) + ")";
          ctx.fillRect(0, WALL_TOP, W, WALL_ROWS * BRICK_H);
          var flick = 0.92 + Math.sin(t * 13) * 0.04 + Math.sin(t * 29) * 0.03;
          var g = ctx.createRadialGradient(W / 2, H / 2 - 4, 4, W / 2, H / 2 - 4, 190);
          g.addColorStop(0, "rgba(255,190,110," + (0.30 * glow * flick) + ")");
          g.addColorStop(1, "rgba(255,190,110,0)");
          ctx.fillStyle = g;
          ctx.fillRect(0, 0, W, H);
        }
        // 上下と左右を闇に沈める
        var v = ctx.createLinearGradient(0, WALL_TOP, 0, WALL_TOP + WALL_ROWS * BRICK_H);
        v.addColorStop(0, "rgba(0,0,0,.95)");
        v.addColorStop(0.2, "rgba(0,0,0,.2)");
        v.addColorStop(0.8, "rgba(0,0,0,.2)");
        v.addColorStop(1, "rgba(0,0,0,.95)");
        ctx.fillStyle = v;
        ctx.fillRect(0, WALL_TOP, W, WALL_ROWS * BRICK_H);
        var hv = ctx.createRadialGradient(W / 2, H / 2, 90, W / 2, H / 2, 230);
        hv.addColorStop(0, "rgba(0,0,0,0)");
        hv.addColorStop(1, "rgba(0,0,0,.9)");
        ctx.fillStyle = hv;
        ctx.fillRect(0, 0, W, H);
        ctx.restore();
      }

      // ── 1コマ ──
      function draw() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);

        var pubA = 1 - clamp((t - T.logoOut) / 0.45, 0, 1);
        if (pubA > 0.01) drawWall(pubA);

        // タイトルの背景。着地の閃光の時だけ明るくなる
        var sceneA = clamp((t - T.scene) / 0.6, 0, 1);
        titleBg.style.opacity = sceneA;
        titleBg.style.filter = "brightness(" + (0.42 + flash * 0.5) + ")";
        titleBg.style.transform = "scale(" + lerp(1.08, 1, ease(sceneA)) + ")";

        // 煉瓦書架ロゴ
        var logoA = clamp((t - T.logoIn) / 0.5, 0, 1) * pubA;
        pub.style.opacity = logoA;
        if (logoA > 0) {
          var lp = ease(clamp((t - T.logoIn) / 0.7, 0, 1));
          logoBox.style.transform = "translateY(" + ((1 - lp) * -40) + "px) scale(" + (1 + (1 - lp) * 0.14) + ")";
          var sp = (t - T.shine) / 0.9;
          shineEl.style.backgroundPosition = (lerp(130, -30, clamp(sp, 0, 1))) + "% 0";
          shineEl.style.opacity = sp > 0 && sp < 1 ? 1 : 0;
          var pa = clamp((t - T.presents) / 0.5, 0, 1);
          presents.style.opacity = pa;
          presents.style.letterSpacing = lerp(1.2, 0.62, ease(pa)) + "em";
        }

        // タイトル
        if (t >= T.slam) {
          var p = ease(clamp((t - T.slam) / (T.land - T.slam), 0, 1));
          var settle = clamp((t - T.land) / 0.34, 0, 1);
          var y = lerp(-420, 0, p) + (1 - settle) * Math.sin(settle * Math.PI * 2) * 22;
          titleWrap.style.opacity = 1;
          title.style.transform = "translateY(" + y + "px) scale(" + lerp(1.3, 1, p) + ")";
          var subA = clamp((t - T.sub) / 0.45, 0, 1);
          sub.style.opacity = subA;
          sub.style.transform = "scale(" + lerp(1.5, 1, ease(subA)) + ")";
          // 着地のあと、金の面に光が一度走る
          var tp = clamp((t - T.land - 0.25) / 1.0, 0, 1);
          titleFront.style.backgroundPosition = lerp(120, -20, tp) + "% 0, 0 0";
        } else {
          titleWrap.style.opacity = 0;
        }
        copy.style.opacity = clamp((t - T.copy) / 0.6, 0, 1) * 0.9;
        press.style.opacity = t >= T.start && (t * 1.55) % 1 < 0.64 ? 1 : 0;

        flashEl.style.opacity = flash * 0.5;
        stage.style.transform = shake > 0.05
          ? "translate(" + ((Math.random() - 0.5) * shake * 10) + "px," + ((Math.random() - 0.5) * shake * 10) + "px)"
          : "";
        var fadeOut = clamp((t - (T.end - 0.6)) / 0.6, 0, 1);
        if (!closing) root.style.opacity = 1 - fadeOut;
      }

      function frame(now) {
        if (done) return;
        var dt = Math.min(0.05, (now - last) / 1000 || 0);
        last = now;
        if (!hold) t += dt;

        if (t >= T.bricks && !AC) initAudio();
        if (t >= T.bgm) startBgm();

        if (!landed && t >= T.land) { landed = true; flash = 1; shake = 3.2; boom(0.5, 520); }
        flash = Math.max(0, flash - dt * 3.1);
        shake = Math.max(0, shake - dt * 11);

        draw();
        if (t >= T.end) { finish(0); return; }
        raf = requestAnimationFrame(frame);
      }

      // 途中ならタイトル完成まで飛ばす。完成していれば閉じる
      function skipOrClose() {
        if (done || closing) return;
        if (t < T.start) {
          t = T.start;
          landed = true; flash = 0.8; shake = 0;
          if (!AC) initAudio();
          startBgm();
          bricks.forEach(function (b) { b.down = true; });
          return;
        }
        finish(450);
      }

      function finish(fadeMs) {
        if (closing) return;
        closing = true;
        document.removeEventListener("keydown", onKey, true);
        stopSound(Math.max(300, fadeMs));
        var end = function () {
          done = true;
          cancelAnimationFrame(raf);
          if (root.parentNode) root.parentNode.removeChild(root);
          resolve();
        };
        if (fadeMs > 0) {
          root.style.transition = "opacity " + fadeMs + "ms ease-in";
          root.style.opacity = 0;
          setTimeout(end, fadeMs);
        } else {
          end();
        }
      }

      // この画面のクリックとキーは、本体側に渡さない（シナリオが余計に進まないように）
      root.addEventListener("click", function (ev) { ev.stopPropagation(); skipOrClose(); });
      function onKey(ev) {
        ev.stopPropagation();
        if (ev.preventDefault) ev.preventDefault();
        if (ev.repeat) return;
        skipOrClose();
      }
      document.addEventListener("keydown", onKey, true);

      // 調整・確認用：コンソールから今の時刻を見たり、好きな時刻へ飛んだりできる
      window.__doubtOpening = {
        get t() { return t; },
        seek: function (v) { t = v; },
        hold: function (v) { hold = !!v; },
        T: T,
      };

      draw();
      raf = requestAnimationFrame(function (now) { last = now; frame(now); });
    });
  }

  function defineTag(name, pm, fn) {
    var tag = {
      vital: [],
      pm: pm || {},
      start: function (p) {
        var kag = this.kag;
        kag.layer.hideEventLayer();
        Promise.resolve()
          .then(function () { return fn(p); })
          .catch(function (e) { console.error("[doubt] " + name, e); })
          .then(function () { kag.ftag.nextOrder(); });
      },
    };
    tyrano.plugin.kag.tag[name] = tag;
    TYRANO.kag.ftag.master_tag[name] = tag;
    tag.kag = TYRANO.kag;
  }

  defineTag("doubt_opening", {}, play);
})();
