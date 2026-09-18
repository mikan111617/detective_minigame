;===============================================================================
; clue_board.ks  手がかりボード（部屋ごとにグルーピング／scene4・scene7 共通）
; 呼び出し：館マップの「手がかりボード」ボタンから [jump storage="clue_board.ks"]
;===============================================================================

[cm]
[clearfix]
[freeimage layer="1"]
[hidemenubutton]
[layopt layer="message0" visible=false]

[iscript]
window.INV_READY();
(function(){
  var kf = TG.stat.f, INV = f.INV, cfg = INV.cfg();
  var log = kf.clue_log || [];

  function entry(e){
    var isP = (e.kind === "clue");
    var tag = isP ? "毒物の手がかり" : (e.kind === "item" ? "証拠品" : "情報");
    var tagCol = isP ? "#e89070" : (e.kind === "item" ? INV.GOLD : "#8fc3dd");
    var art = e.image
      ? '<img src="'+(e.dir||"./data/image/item/")+e.image+'" style="width:100%;height:100%;object-fit:contain">'
      : '<div style="font-size:30px;color:#f2d882">◎</div>';
    return '<div style="display:flex;gap:14px;padding:14px;border-radius:8px;'
      + 'background:rgba(255,255,255,0.02);border:1px solid '+(isP?"#7a3a1e":"#33230a")+'">'
      + '<div style="flex-shrink:0;width:70px;height:70px;border-radius:6px;display:flex;align-items:center;'
        + 'justify-content:center;background:rgba(40,26,8,0.9);border:1px solid '+(isP?"#8e4425":"#5c3e14")+'">'
        + art + '</div>'
      + '<div style="flex:1;min-width:0;display:flex;flex-direction:column;gap:5px">'
        + '<div style="font-size:18px;letter-spacing:0.2em;color:'+tagCol+'">'+tag+'</div>'
        + '<div style="font-size:23px;color:#f0dca8;line-height:1.25">'+e.name+'</div>'
        + (e.where ? '<div style="font-size:18px;color:#7f6432;line-height:1.35">'+e.where+'</div>' : '')
        + '</div></div>';
  }

  function group(title, entries){
    var items = "";
    for(var i=0;i<entries.length;i++){ items += entry(entries[i]); }
    if(items === ""){
      items = '<div style="padding:18px 0;font-size:20px;color:#4e3a14">まだ何も見つかっていない</div>';
    }
    return '<div style="display:flex;flex-direction:column;gap:14px;padding:20px;background:rgba(14,10,3,0.9);'
      + 'border:1px solid #3c2a0c;border-radius:10px">'
      + '<div style="display:flex;align-items:center;gap:10px;padding-bottom:12px;border-bottom:1px solid #33230a">'
        + '<div style="font-family:'+INV.TITLE+';font-size:30px;color:#f0dca8;white-space:nowrap">'+title+'</div>'
        + '<div style="flex:1"></div>'
        + '<div style="font-size:20px;color:#7f6432;white-space:nowrap">'
        + (entries.length ? entries.length+"件" : "—")+'</div></div>'
      + items + '</div>';
  }

  var rooms = INV.rooms(), cards = "", used = {};
  for(var i=0;i<rooms.length;i++){
    var r = rooms[i];
    // 通路と、子部屋をまとめるだけのハブ（宿泊部屋など）は発見物を持たない
    if(r.passage || r.hub){ continue; }
    var entries = [];
    for(var j=0;j<log.length;j++){
      if(used[j]){ continue; }
      // 部屋名は 1F/2F のサンルームで重複するので id で突き合わせる。
      // id を持たない古い記録は名前で拾い、最初に一致した部屋にだけ入れる。
      var hit = log[j].roomId ? (log[j].roomId === r.id) : (log[j].room === r.name);
      if(hit){ entries.push(log[j]); used[j] = true; }
    }
    // 子部屋は数が多いので、何か見つかっている部屋だけを並べる
    if(r.parent && entries.length === 0){ continue; }
    cards += group(r.name + "（" + r.floor + "F）", entries);
  }
  var others = [];
  for(var k=0;k<log.length;k++){ if(!used[k]){ others.push(log[k]); } }
  if(others.length){ cards += group("その他", others); }

  var h = '<div id="inv-overlay" style="position:absolute;top:0;left:0;width:100%;height:100%;z-index:999999998;'
    + 'background:#080502;display:flex;flex-direction:column;font-family:'+INV.BODY+';color:#e8dcc0;'
    + 'box-sizing:border-box;animation:invfade .3s ease-out">'
    + '<div style="display:flex;align-items:center;gap:24px;padding:26px 48px;border-bottom:1px solid #5c3e14;'
      + 'background:linear-gradient(180deg,rgba(16,11,3,0.98),rgba(10,7,2,0.9))">'
      + '<button onclick="window.invBoardClose()" style="padding:14px 28px;background:rgba(18,12,3,0.92);'
        + 'border:1px solid #6c4c18;border-radius:6px;color:#e8c86a;font-size:22px;font-family:inherit;'
        + 'cursor:pointer;white-space:nowrap">← 館マップ</button>'
      + '<div style="font-family:'+INV.TITLE+';font-size:42px;color:#f6e6b4;letter-spacing:0.06em;white-space:nowrap">手がかりボード</div>'
      + '<div style="font-size:20px;color:#7a5c28;letter-spacing:0.1em">'+cfg.title+'</div>'
      + '<div style="flex:1"></div>'
      + INV.counterHTML() + '</div>'
    + '<div style="flex:1;min-height:0;padding:34px 48px;overflow-y:auto">'
      + '<div style="display:grid;grid-template-columns:repeat(4,1fr);gap:22px;align-content:start">'+cards+'</div>'
    + '</div></div>';

  INV.mount(h);

  window.invBoardClose = function(){
    var c = f.INV.cfg();
    f.INV.clear();
    TG.ftag.startTag("jump", { storage:c.storage, target:c.hubTarget });
  };
})();
[endscript]
[s]
