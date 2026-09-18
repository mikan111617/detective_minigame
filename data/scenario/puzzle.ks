;=========================================
; 保安錠パズル（黒地・金の細罫・深紅の三色でタイトル画面と統一）
;
;   tf.puzzle_mode == 'story' … ストーリーモード（3x3固定・制限時間つき）
;   それ以外                   … ミニゲームモード（難易度3〜6・経過時間表示）
;
; 戻り先：*end_puzzle（ミニゲーム終了）
;         *puzzle_success / *puzzle_failed（ストーリー、tf.puzzle_result に結果）
;=========================================

; メッセージウィンドウを消す
[cm]
[clearfix]
[freeimage layer="0"]
[layopt layer=message visible=false]
[hidemenubutton]
[if exp="tf.puzzle_mode != 'story'"]
[playbgm storage="puzzle.mp3"]
[endif]

;=========================================
; JavaScriptセクション
;=========================================
[iscript]

/* ------------------------------------------------
   設定とモード判定
   tf.puzzle_mode が 'story' ならストーリーモード
   それ以外（undefined含む）ならミニゲームモード
------------------------------------------------ */
var mode = tyrano.plugin.kag.variable.tf.puzzle_mode || 'mini';

window.puzzleConfig = {
    // 画像パス（プロジェクトフォルダからの相対パス。洋館の紋章などを指定）
    imageSrc: "data/image/puzzle.png",
    gridSize: 3,            // ストーリーモードは3固定
    limit: 300              // ストーリーモードの制限時間（秒）
};

/* ------------------------------------------------
   CSS定義
   角丸パネルと原色ボタンを廃し、タイトル画面と同じ
   「黒地・金の細罫・深紅」に統一する
------------------------------------------------ */
var FONT_TITLE = "'Waosagi',serif";                    // <style> 内で使う
var FONT_TITLE_I = "Waosagi,serif";                      // style='...' 属性内で使う（引用符を含めない）
var FONT_BODY  = "'Hiragino Kaku Gothic ProN','Yu Gothic',sans-serif";
var ACCENT     = "#a8231d";

var css = "";
css += "<style id='puzzle-css'>";
css += "@font-face{font-family:'Waosagi';src:url('./data/font/YDWaosagi.otf') format('opentype');font-display:block}";
css += "@keyframes pzWin{0%{opacity:0;transform:translate(-50%,-50%) scale(1.14);filter:blur(10px)}"
     + "100%{opacity:1;transform:translate(-50%,-50%) scale(1);filter:blur(0)}}";
css += "@keyframes pzRule{from{transform:scaleX(0)}to{transform:scaleX(1)}}";
css += "@keyframes pzPulse{0%,100%{opacity:1}50%{opacity:0.45}}";

css += "#puzzle-container{position:absolute;top:0;left:0;width:1920px;height:1080px;overflow:hidden;"
     + "background:#05040a;font-family:" + FONT_BODY + ";color:#e0c07a;z-index:999999997;box-sizing:border-box}";
css += "#puzzle-container .pz-veil{position:absolute;inset:0}";

// ── 見出し（和文＋英字ラベル） ──
css += "#puzzle-container .pz-h{display:flex;align-items:center;gap:18px}";
css += "#puzzle-container .pz-h-ja{font-family:" + FONT_TITLE + ";font-size:32px;letter-spacing:0.18em;"
     + "color:#d9c391;white-space:nowrap}";
css += "#puzzle-container .pz-h-en{font-size:16px;letter-spacing:0.34em;color:#6d5a34;white-space:nowrap}";
css += "#puzzle-container .pz-h-rule{flex:1;height:1px;"
     + "background:linear-gradient(90deg,rgba(168,130,58,0.4),rgba(168,130,58,0.05))}";

// ── 盤（真鍮の額縁に納めた札） ──
css += "#puzzle-board{position:absolute;inset:0;display:grid;gap:3px;padding:3px;background:#07060c;"
     + "border:1px solid rgba(168,130,58,0.5);box-sizing:border-box;"
     + "box-shadow:inset 0 0 40px rgba(0,0,0,0.95),0 24px 60px rgba(0,0,0,0.8)}";
css += "#puzzle-container .tile{position:relative;background-repeat:no-repeat;cursor:default;"
     + "box-shadow:inset 0 0 0 1px rgba(120,96,44,0.22),0 2px 8px rgba(0,0,0,0.6);"
     + "transition:box-shadow .18s ease}";
css += "#puzzle-container .tile.movable{cursor:pointer;"
     + "box-shadow:inset 0 0 0 1px rgba(196,158,80,0.55),0 2px 10px rgba(0,0,0,0.7)}";
// 空きは彫り込んだ窪みに見せる
css += "#puzzle-container .tile.empty{background:rgba(2,2,5,0.92);cursor:default;"
     + "box-shadow:inset 0 3px 14px rgba(0,0,0,0.95),inset 0 -1px 0 rgba(168,130,58,0.18)}";
css += "#puzzle-container .tile-num{position:absolute;left:8px;top:6px;font-family:" + FONT_TITLE + ";"
     + "font-size:22px;letter-spacing:0.04em;color:rgba(240,222,182,0.62);"
     + "text-shadow:0 1px 4px rgba(0,0,0,0.95)}";
css += "#puzzle-container .tile.empty .tile-num{display:none}";

// ── 難易度（数字の行組み） ──
css += "#puzzle-container .pz-grid{width:62px;height:62px;display:flex;align-items:center;"
     + "justify-content:center;cursor:pointer;font-family:" + FONT_TITLE + ";font-size:32px;"
     + "letter-spacing:0.04em;color:#7d6a44;background:transparent;"
     + "border-bottom:1px solid rgba(168,130,58,0.2);transition:all .2s ease}";
css += "#puzzle-container .pz-grid.active{color:#f4e3c3;background:rgba(46,31,8,0.7);border-bottom-color:#a8823a}";

// ── 操作（タイトル画面と同じ行組み） ──
css += "#puzzle-container .pz-row{display:flex;align-items:center;gap:20px;padding:13px 10px;cursor:pointer;"
     + "border-bottom:1px solid rgba(168,130,58,0.14);transition:border-color .2s ease}";
css += "#puzzle-container .pz-row:hover{border-bottom-color:rgba(168,130,58,0.5)}";
css += "#puzzle-container .pz-mark{flex-shrink:0;width:18px;font-size:17px;"
     + "color:rgba(168,130,58,0.28);transition:color .2s ease}";
css += "#puzzle-container .pz-row:hover .pz-mark{color:#e0c07a}";
css += "#puzzle-container .pz-row.danger:hover .pz-mark{color:" + ACCENT + "}";
css += "#puzzle-container .pz-label{font-family:" + FONT_TITLE + ";font-size:40px;line-height:1.1;"
     + "letter-spacing:0.12em;white-space:nowrap;color:#b9a578;transition:color .2s ease}";
css += "#puzzle-container .pz-row:hover .pz-label{color:#f7e6c2;text-shadow:0 0 22px rgba(200,160,90,0.4)}";
css += "#puzzle-container .pz-en{font-size:17px;letter-spacing:0.28em;white-space:nowrap;"
     + "color:#5f5031;transition:color .2s ease}";
css += "#puzzle-container .pz-row:hover .pz-en{color:#9c8047}";
css += "#puzzle-container .pz-line{width:30px;height:1px;background:rgba(168,130,58,0.25);"
     + "transition:width .24s ease,background .2s ease}";
css += "#puzzle-container .pz-row:hover .pz-line{width:86px;background:#a8823a}";
css += "#puzzle-container .pz-row.danger:hover .pz-line{background:" + ACCENT + "}";

// ── 解錠演出 ──
css += "#win-modal{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);display:none;"
     + "flex-direction:column;align-items:center;gap:22px;padding:54px 96px;background:rgba(4,3,9,0.9);"
     + "border:1px solid rgba(168,130,58,0.6);box-shadow:0 0 90px rgba(0,0,0,0.9);z-index:5}";
css += "#win-modal.show{display:flex;animation:pzWin .7s ease both}";
css += "#puzzle-container .pz-win-rule{width:280px;height:1px;"
     + "background:linear-gradient(90deg,transparent,#a8823a,transparent);animation:pzRule .8s .1s ease both}";
css += "</style>";

$('#puzzle-css').remove();
$('head').append(css);

/* ------------------------------------------------
   HTML構造
------------------------------------------------ */
var story = (mode === 'story');
var h = "";
h += "<div id='puzzle-container'>";

// 背景（書斎を暗く沈めた上に金と深紅を重ねる）
h += "  <img src='data/bgimage/office_night.png' alt='' style='position:absolute;inset:0;width:100%;"
   + "height:100%;object-fit:cover;opacity:0.2;filter:grayscale(0.5) brightness(0.55)'>";
h += "  <div class='pz-veil' style='background:linear-gradient(100deg,rgba(6,5,12,0.96) 0%,"
   + "rgba(9,7,15,0.86) 46%,rgba(12,9,17,0.72) 100%)'></div>";
h += "  <div class='pz-veil' style='background:radial-gradient(74% 64% at 40% 44%,"
   + "rgba(96,44,14,0.18) 0%,rgba(3,2,8,0.9) 100%)'></div>";
h += "  <div class='pz-veil' style='opacity:0.05;background-image:repeating-linear-gradient(0deg,"
   + "rgba(255,255,255,0.9) 0px,rgba(255,255,255,0.9) 1px,transparent 1px,transparent 4px)'></div>";

// 表題
h += "  <div style='position:absolute;left:96px;top:56px;display:flex;align-items:center;gap:22px'>";
h += "    <div style='width:56px;height:1px;background:linear-gradient(90deg,transparent,#a8823a)'></div>";
h += "    <div style='font-family:" + FONT_TITLE_I + ";font-size:52px;letter-spacing:0.16em;color:#f0dfbe;"
   + "text-shadow:0 6px 26px rgba(0,0,0,0.9)'>保安錠</div>";
h += "    <div style='font-size:19px;letter-spacing:0.42em;color:#8f7540;padding-bottom:6px'>SECURITY LOCK</div>";
h += "  </div>";

// 盤（真鍮の二重額縁と四隅の飾り）
h += "  <div style='position:absolute;left:96px;top:150px;width:820px;height:820px'>";
h += "    <div style='position:absolute;inset:-18px;border:1px solid rgba(168,130,58,0.34)'></div>";
h += "    <div style='position:absolute;inset:-9px;border:1px solid rgba(168,130,58,0.14)'></div>";
h += "    <div style='position:absolute;left:-24px;top:-24px;width:22px;height:22px;"
   + "border-left:2px solid #a8823a;border-top:2px solid #a8823a'></div>";
h += "    <div style='position:absolute;right:-24px;top:-24px;width:22px;height:22px;"
   + "border-right:2px solid #a8823a;border-top:2px solid #a8823a'></div>";
h += "    <div style='position:absolute;left:-24px;bottom:-24px;width:22px;height:22px;"
   + "border-left:2px solid #a8823a;border-bottom:2px solid #a8823a'></div>";
h += "    <div style='position:absolute;right:-24px;bottom:-24px;width:22px;height:22px;"
   + "border-right:2px solid #a8823a;border-bottom:2px solid #a8823a'></div>";
h += "    <div id='puzzle-board'></div>";
h += "    <div id='win-modal'>";
h += "      <div class='pz-win-rule'></div>";
h += "      <div style='font-family:" + FONT_TITLE_I + ";font-size:104px;letter-spacing:0.2em;color:#f4e3c3;white-space:nowrap;"
   + "text-shadow:0 0 34px rgba(178,32,26,0.75),0 8px 40px rgba(0,0,0,0.95)'>解錠</div>";
h += "      <div style='font-size:20px;letter-spacing:0.5em;color:#a08a56;white-space:nowrap'>ACCESS GRANTED</div>";
h += "      <div class='pz-win-rule'></div>";
h += "    </div>";
h += "  </div>";

// 右の柱
// おまけモードは難易度の行が増えるぶん縦に長くなるので、位置と間隔を詰める
h += "  <div style='position:absolute;left:1024px;top:" + (story ? 150 : 108) + "px;width:800px;"
   + "max-height:" + (story ? 880 : 940) + "px;display:flex;"
   + "flex-direction:column;gap:" + (story ? 44 : 26) + "px'>";

// 錠の意匠
h += "    <div style='display:flex;flex-direction:column;gap:18px'>";
h += "      <div class='pz-h'><div class='pz-h-ja'>錠の意匠</div>"
   + "<div class='pz-h-en'>TARGET</div><div class='pz-h-rule'></div></div>";
h += "      <div style='display:flex;align-items:flex-end;gap:34px'>";
h += "        <div style='position:relative;width:250px;height:250px;flex-shrink:0;"
   + "border:1px solid rgba(168,130,58,0.45);background:#0a0810;box-shadow:inset 0 0 30px rgba(0,0,0,0.9)'>";
h += "          <img id='preview-img' src='' alt='' style='position:absolute;inset:6px;"
   + "width:calc(100% - 12px);height:calc(100% - 12px);object-fit:cover;"
   + "filter:sepia(0.42) contrast(1.1) brightness(0.86)'>";
h += "          <div style='position:absolute;inset:6px;"
   + "background:radial-gradient(closest-side,transparent 50%,rgba(4,3,9,0.6))'></div>";
h += "        </div>";
h += "        <div style='display:flex;flex-direction:column;gap:14px;padding-bottom:6px'>";
h += "          <div style='font-size:23px;line-height:1.8;color:#9c8763;letter-spacing:0.08em'>"
   + "書斎の錠は九つの札に分かれている。<br>札を滑らせ、元の意匠に戻すこと。</div>";
h += "          <div style='font-size:19px;letter-spacing:0.2em;color:#6d5a34'>隣接する札のみ動かせる</div>";
h += "        </div>";
h += "      </div>";
h += "    </div>";

// 難易度（ストーリーでは隠す）
h += "    <div id='pz-difficulty' style='display:" + (story ? "none" : "flex")
   + ";flex-direction:column;gap:18px'>";
h += "      <div class='pz-h'><div class='pz-h-ja'>難易度</div>"
   + "<div class='pz-h-en'>GRID</div><div class='pz-h-rule'></div></div>";
h += "      <div id='grid-selector' style='display:flex;gap:14px'></div>";
h += "    </div>";

// 記録
h += "    <div style='display:flex;flex-direction:column;gap:18px'>";
h += "      <div class='pz-h'><div class='pz-h-ja'>記録</div>"
   + "<div class='pz-h-en'>STATUS</div><div class='pz-h-rule'></div></div>";
h += "      <div style='display:flex;gap:70px;align-items:flex-end'>";
h += "        <div style='display:flex;flex-direction:column;gap:6px'>";
h += "          <div style='font-size:18px;letter-spacing:0.3em;color:#6d5a34'>手数</div>";
h += "          <div id='stat-moves' style='font-family:" + FONT_TITLE_I + ";font-size:66px;line-height:1;"
   + "color:#e8d5ab;letter-spacing:0.06em'>0</div>";
h += "        </div>";
h += "        <div style='width:1px;height:64px;background:rgba(168,130,58,0.22)'></div>";
h += "        <div style='display:flex;flex-direction:column;gap:6px'>";
h += "          <div id='stat-time-label' style='font-size:18px;letter-spacing:0.3em;color:#6d5a34'>"
   + (story ? "残り時間" : "経過時間") + "</div>";
h += "          <div id='stat-time' style='font-family:" + FONT_TITLE_I + ";font-size:66px;line-height:1;"
   + "letter-spacing:0.06em;color:" + (story ? "#e0b49a" : "#e8d5ab") + ";transition:color .3s ease'>0:00</div>";
h += "        </div>";
h += "      </div>";
// 砂時計ゲージ（ストーリーのみ）
h += "      <div id='pz-gauge-wrap' style='display:" + (story ? "block" : "none")
   + ";width:560px;height:2px;background:rgba(168,130,58,0.16);margin-top:6px'>";
h += "        <div id='pz-gauge' style='width:100%;height:100%;"
   + "background:linear-gradient(90deg,rgba(168,130,58,0.5),#a8823a);transition:width 1s linear'></div>";
h += "      </div>";
h += "    </div>";

// 操作
h += "    <div id='pz-actions' style='display:flex;flex-direction:column;gap:2px;width:560px;"
   + "margin-top:6px'></div>";

h += "  </div>";

h += "  <div style='position:absolute;right:64px;bottom:44px;font-size:19px;letter-spacing:0.3em;"
   + "color:#5c4c2c'>舞黒館の惨劇</div>";
h += "</div>";

$('#puzzle-container').remove();
$('#tyrano_base').append(h);

/* ------------------------------------------------
   ゲームロジック
------------------------------------------------ */
window.pGame = {
    tiles: [],
    moves: 0,
    time: 0,
    timerId: null,
    isPlaying: false,
    isSolved: false,
    mode: mode
};

// 難易度の数字（ミニゲームのみ使用）
var gridSelector = $('#grid-selector');
for(var i=3; i<=6; i++){
    gridSelector.append("<div class='pz-grid' onclick='window.changeGrid(" + i + ")'>" + i + "</div>");
}

// 操作の行組み。ストーリーとミニゲームで内容を差し替える
function renderActions(){
    var rows = (window.pGame.mode === 'story')
        ? [ { label:'開始',   en:'ENGAGE', fn:'window.shufflePuzzle()' },
            { label:'手を引く', en:'ABORT',  fn:'window.confirmAbort()', danger:true } ]
        : [ { label:'開始',         en:'START',      fn:'window.shufflePuzzle()' },
            { label:'図版差し替え', en:'LOAD IMAGE', fn:'window.pickImage()' },
            { label:'表題へ戻る',   en:'QUIT',       fn:'window.quitPuzzle()', danger:true } ];
    var out = "";
    for(var k=0; k<rows.length; k++){
        out += "<div class='pz-row" + (rows[k].danger ? " danger" : "") + "' onclick=\"" + rows[k].fn + "\">"
             + "<div class='pz-mark'>◆</div>"
             + "<div style='display:flex;align-items:baseline;gap:16px;flex-shrink:0'>"
             + "<div class='pz-label'>" + rows[k].label + "</div>"
             + "<div class='pz-en'>" + rows[k].en + "</div></div>"
             + "<div style='flex:1;min-width:20px'></div>"
             + "<div class='pz-line'></div></div>";
    }
    $('#pz-actions').html(out);
}

window.initPuzzle = function(size) {
    if(window.pGame.mode === 'story') size = 3;

    window.puzzleConfig.gridSize = size;
    window.pGame.moves = 0;
    window.pGame.time = 0;
    window.pGame.isPlaying = false;
    window.pGame.isSolved = false;
    window.pGame.tiles = [];

    $('#preview-img').attr('src', window.puzzleConfig.imageSrc);
    for(var k=0; k < size*size; k++) {
        window.pGame.tiles.push(k);
    }

    clearInterval(window.pGame.timerId);
    updateDisplay();
    renderBoard();
    renderActions();
    $('#win-modal').removeClass('show');

    $('.pz-grid').removeClass('active');
    $('.pz-grid').each(function(){
        if($(this).text() == size) $(this).addClass('active');
    });
};

window.shufflePuzzle = function() {
    var size = window.puzzleConfig.gridSize;
    var arr = window.pGame.tiles.slice();
    var emptyPos = size * size - 1;
    var steps = size * size * 20;

    for(var i=0; i<steps; i++){
        var neighbors = [];
        var r = Math.floor(emptyPos / size);
        var c = emptyPos % size;

        if(r > 0) neighbors.push(emptyPos - size);
        if(r < size-1) neighbors.push(emptyPos + size);
        if(c > 0) neighbors.push(emptyPos - 1);
        if(c < size-1) neighbors.push(emptyPos + 1);

        if(neighbors.length > 0){
            var next = neighbors[Math.floor(Math.random() * neighbors.length)];
            var temp = arr[emptyPos];
            arr[emptyPos] = arr[next];
            arr[next] = temp;
            emptyPos = next;
        }
    }

    window.pGame.tiles = arr;
    window.pGame.moves = 0;
    window.pGame.time = 0;
    window.pGame.isPlaying = true;
    window.pGame.isSolved = false;

    renderBoard();
    startTimer();
    updateDisplay();
    $('#win-modal').removeClass('show');
};

window.moveTile = function(index) {
    if(!window.pGame.isPlaying || window.pGame.isSolved) return;

    var size = window.puzzleConfig.gridSize;
    var tiles = window.pGame.tiles;
    var emptyVal = size * size - 1;
    var emptyIdx = tiles.indexOf(emptyVal);
    var r = Math.floor(index / size);
    var c = index % size;
    var er = Math.floor(emptyIdx / size);
    var ec = emptyIdx % size;

    if(Math.abs(r - er) + Math.abs(c - ec) === 1){
        var temp = tiles[index];
        tiles[index] = tiles[emptyIdx];
        tiles[emptyIdx] = temp;

        window.pGame.moves++;

        var isWin = checkWinCondition();
        if(isWin) {
            window.pGame.isSolved = true;
            window.pGame.isPlaying = false;
            clearInterval(window.pGame.timerId);
            renderBoard();
            $('#win-modal').addClass('show');

            // 称号：攻略と、30秒以内での解錠
            if(window.ACH){
                window.ACH.grant('puzzle_clear');
                if(window.pGame.time <= 30){ window.ACH.grant('puzzle_speed'); }
            }

            if(window.pGame.mode === 'story'){
                 setTimeout(function(){
                    window.closePuzzle();
                    tyrano.plugin.kag.ftag.startTag("jump", {target:"*puzzle_success"});
                 }, 2400);
            }
        } else {
            renderBoard();
        }
        updateDisplay();
    }
};

function checkWinCondition(){
    var tiles = window.pGame.tiles;
    for(var i=0; i<tiles.length; i++){
        if(tiles[i] !== i) return false;
    }
    return true;
}

function renderBoard() {
    var size = window.puzzleConfig.gridSize;
    var board = $('#puzzle-board');
    var tiles = window.pGame.tiles;
    var emptyVal = size * size - 1;
    var img = window.puzzleConfig.imageSrc;
    var emptyIdx = tiles.indexOf(emptyVal);

    board.empty();
    board.css({
        'grid-template-columns': 'repeat(' + size + ', 1fr)',
        'grid-template-rows': 'repeat(' + size + ', 1fr)'
    });

    for(var i=0; i<tiles.length; i++){
        (function(index){
            var val = tiles[index];
            var div = document.createElement('div');
            div.className = 'tile';

            if(val === emptyVal && !window.pGame.isSolved){
                 div.className += ' empty';
            } else {
                var orgR = Math.floor(val / size);
                var orgC = val % size;
                var bgX = (size > 1) ? (orgC / (size - 1)) * 100 : 0;
                var bgY = (size > 1) ? (orgR / (size - 1)) * 100 : 0;

                div.style.backgroundImage = 'url(' + img + ')';
                div.style.backgroundSize = (size * 100) + '% ' + (size * 100) + '%';
                div.style.backgroundPosition = bgX + '% ' + bgY + '%';
                // 札はセピアに寄せる
                div.style.filter = 'sepia(0.42) contrast(1.12) brightness(0.9)';

                // 動かせる札だけ縁を明るくして手がかりにする
                var er = Math.floor(emptyIdx / size), ec = emptyIdx % size;
                var can = window.pGame.isPlaying && !window.pGame.isSolved
                    && Math.abs(Math.floor(index/size) - er) + Math.abs(index%size - ec) === 1;
                if(can){ div.className += ' movable'; }

                var num = document.createElement('div');
                num.className = 'tile-num';
                num.innerText = (val + 1);
                div.appendChild(num);

                div.onclick = function(){ window.moveTile(index); };
            }
            board.append(div);
        })(i);
    }
}

function updateDisplay(){
    $('#stat-moves').text(window.pGame.moves);

    var story = (window.pGame.mode === 'story');
    var limit = window.puzzleConfig.limit;
    var displayTime = story ? Math.max(0, limit - window.pGame.time) : window.pGame.time;

    var m = Math.floor(displayTime / 60);
    var s = (displayTime % 60);
    if(s < 10) s = '0' + s;
    $('#stat-time').text(m + ':' + s);

    if(story){
        // 残り一分を切ったら深紅で脈打たせる
        var urgent = displayTime <= 60;
        $('#stat-time-label').css('color', urgent ? ACCENT : '#6d5a34');
        $('#stat-time').css({
            'color': urgent ? '#f0b9b0' : '#e0b49a',
            'text-shadow': urgent ? '0 0 26px ' + ACCENT : 'none'
        });
        $('#pz-gauge').css({
            'width': (displayTime / limit * 100) + '%',
            'background': urgent ? ACCENT : 'linear-gradient(90deg,rgba(168,130,58,0.5),#a8823a)',
            'animation': urgent ? 'pzPulse 1.2s ease-in-out infinite' : 'none'
        });

        if(window.pGame.time >= limit && window.pGame.isPlaying){
            window.failPuzzle();
        }
    }
}

function startTimer(){
    clearInterval(window.pGame.timerId);
    window.pGame.timerId = setInterval(function(){
        window.pGame.time++;
        updateDisplay();
    }, 1000);
}

// 画面とタイマーの後片付け
window.closePuzzle = function(){
    if(window.pGame) clearInterval(window.pGame.timerId);
    $('#puzzle-container').remove();
};

// 失敗・時間切れ処理
window.failPuzzle = function(){
    clearInterval(window.pGame.timerId);
    window.pGame.isPlaying = false;
    window.closePuzzle();
    tyrano.plugin.kag.ftag.startTag("jump", {target:"*puzzle_failed"});
};

// ストーリー：手を引く
window.confirmAbort = function(){
    if(confirm("本当に手を引きますか？")){ window.failPuzzle(); }
};

// ミニゲーム：表題へ戻る
window.quitPuzzle = function(){
    window.closePuzzle();
    tyrano.plugin.kag.ftag.startTag("jump", {target:"*end_puzzle"});
};

// ミニゲーム：図版差し替え
window.pickImage = function(){
    var inp = document.getElementById('pz-file');
    if(!inp){
        inp = document.createElement('input');
        inp.type = 'file';
        inp.id = 'pz-file';
        inp.accept = 'image/*';
        inp.style.display = 'none';
        document.body.appendChild(inp);
        inp.addEventListener('change', function(e){
            var file = e.target.files[0];
            if(!file) return;
            var reader = new FileReader();
            reader.onload = function(ev){
                window.puzzleConfig.imageSrc = ev.target.result;
                window.initPuzzle(window.puzzleConfig.gridSize);
            };
            reader.readAsDataURL(file);
        });
    }
    inp.click();
};

window.changeGrid = function(n){ window.initPuzzle(n); };

window.initPuzzle(window.puzzleConfig.gridSize);

[endscript]

[s]

;------------------------------------------------
; ジャンプ先定義
;------------------------------------------------

; ミニゲームモード終了時（タイトルへ戻る等）
*end_puzzle
[cm]
[iscript]
if(window.closePuzzle) window.closePuzzle();
[endscript]
[jump storage="title.ks"]

; ストーリーモード：成功時（呼び出し元へ戻る）
*puzzle_success
[cm]
[iscript]
if(window.closePuzzle) window.closePuzzle();
[endscript]
; 成功フラグを立ててリターン
[eval exp="tf.puzzle_result = 'success'"]
[return]

; ストーリーモード：失敗・時間切れ時（呼び出し元へ戻る）
*puzzle_failed
[cm]
[iscript]
if(window.closePuzzle) window.closePuzzle();
[endscript]
; 失敗フラグを立ててリターン
[eval exp="tf.puzzle_result = 'fail'"]
[return]
