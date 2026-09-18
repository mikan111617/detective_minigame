;===============================================================================
; get_item.ks（[get_item] 差し替え版）
; macro.ks の旧 [get_item] は削除済み。定義はこのファイルのみ。
; 引数は従来どおり（id / name / type / icon / se / memo / hold）。
;   id    … f.master_data から name / image / text_default を補完
;   name  … 表示名（id 指定時は省略可）
;   type  … item / clue / info（既定 item）
;   icon  … 画像名を直接指定（id より優先）
;   se    … 同時に鳴らすSE
;   memo  … 説明文（省略時は master_data の text_default）
;   hold  … "false" を渡すと確認待ちをせず自動で閉じる
;
; 追加点：
;   ・全画面モーダルで発見物を提示し、「確認」を押すまで待つ
;   ・type="clue" のとき、毒物の手がかり進捗（章データの counter）を併記
;   ・発見物を f.clue_log に記録（手がかりボードで部屋ごとに表示するため）
;===============================================================================

[macro name="get_item"]
    [if exp="mp.se !== undefined"]
        [playse storage="%se" volume=80 buf=3]
    [endif]
    [iscript]
    if(window.INV_READY){ window.INV_READY(); }
    (function(){
        var TITLE = (f.INV && f.INV.TITLE) ? f.INV.TITLE : "'Waosagi',serif";
        var BODY  = (f.INV && f.INV.BODY)  ? f.INV.BODY  : "sans-serif";
        if(f.INV && f.INV.css){ f.INV.css(); }

        var type = (mp.type !== undefined) ? mp.type : 'item';

        var name    = (mp.name !== undefined) ? mp.name : '';
        var imgFile = (mp.icon !== undefined) ? mp.icon : '';
        var memo    = (mp.memo !== undefined) ? mp.memo : '';
        var isChara = false;

        if(mp.id !== undefined && f.master_data){
            for(var i=0; i<f.master_data.length; i++){
                if(f.master_data[i].id === mp.id){
                    if(name === '')    { name    = f.master_data[i].name; }
                    if(imgFile === '') { imgFile = f.master_data[i].image || ''; }
                    if(memo === '')    { memo    = f.master_data[i].text_default || ''; }
                    isChara = (f.master_data[i].type === 'chara');
                    break;
                }
            }
        }

        var IMG_DIR = isChara ? './data/fgimage/chara/' : './data/image/item/';

        var conf = {
            item: { tag:'ITEM',        accent:'#f6e6b4', bd:'#a07828', bar:'linear-gradient(90deg,#6e5219,#2e2208)' },
            clue: { tag:'POISON CLUE', accent:'#ffd9b0', bd:'#d07a4a', bar:'linear-gradient(90deg,#8e3d1e,#4e2010)' },
            info: { tag:'INFO',        accent:'#f6e6b4', bd:'#a07828', bar:'linear-gradient(90deg,#6e5219,#2e2208)' }
        };
        var c = conf[type] || conf.item;

        var room   = f.inv_cur_room    || '';
        var roomId = f.inv_cur_room_id || '';
        var where  = f.inv_cur_where   || '';
        var whereLabel = room ? (where ? room + ' / ' + where : room) : where;

        // ── 発見ログに記録（手がかりボード用） ──
        if(typeof f.clue_log === 'undefined'){ f.clue_log = []; }
        var already = false;
        for(var q=0; q<f.clue_log.length; q++){
            if(f.clue_log[q].name === name){ already = true; break; }
        }
        if(!already && name !== ''){
            f.clue_log.push({
                name:   name,
                kind:   type,
                room:   room || 'その他',
                roomId: roomId,
                where:  where,
                memo:  memo,
                image: imgFile,
                dir:   IMG_DIR
            });
        }

        // ── 毒物の手がかり進捗（章データの counter 設定を使用） ──
        var cnt = (f.INV && f.INV.counter) ? f.INV.counter() : { label:'手がかり', n:0, max:0, dots:false };
        var progress = '';
        if(type === 'clue' && cnt.dots){
            var seg = '';
            for(var d=0; d<cnt.max; d++){
                var on = d < cnt.n;
                seg += '<div style="flex:1;height:12px;border-radius:6px;'
                     + 'background:' + (on ? 'linear-gradient(90deg,#e08050,#b04a26)' : '#2a1a06') + ';'
                     + 'border:1px solid ' + (on ? '#e8a070' : '#4c3410') + '"></div>';
            }
            progress =
                '<div style="display:flex;flex-direction:column;gap:12px;padding:22px 26px;'
                + 'background:rgba(120,40,22,0.22);border:1px solid #8e4425;border-radius:8px">'
                + '<div style="display:flex;align-items:center;gap:14px">'
                    + '<div style="font-size:24px;letter-spacing:0.2em;color:#e0956a;white-space:nowrap">' + cnt.label + '</div>'
                    + '<div style="flex:1"></div>'
                    + '<div style="font-family:' + TITLE + ';font-size:40px;line-height:1;color:#ffd9b0;white-space:nowrap">'
                        + cnt.n + ' / ' + cnt.max + '</div>'
                + '</div>'
                + '<div style="display:flex;gap:10px">' + seg + '</div>'
                + '<div style="font-size:21px;color:#c08a60">'
                    + (cnt.n >= cnt.max ? cnt.max + 'つ揃った。和人に報告しよう。'
                                        : (cnt.max - cnt.n) + 'か所そろえば、死因の特定に近づく。')
                + '</div></div>';
        }

        // ── アイコン（画像が無い／読めないときは記号にフォールバック） ──
        // onerror をインライン属性に書くと、フォールバックHTMLの引用符が
        // 属性の解釈時に復元されて JS 文字列を閉じてしまう（構文エラーになる）。
        // 差し込んだ後に JS 側でハンドラを付ける。
        var fallbackArt = '<div style="font-family:' + TITLE + ';font-size:110px;color:#f2d882">◎</div>';
        var artHTML;
        if(imgFile){
            artHTML = '<img class="get-notify-art" src="' + IMG_DIR + imgFile + '" '
                    + 'style="width:100%;height:100%;object-fit:contain"/>';
        } else {
            artHTML = fallbackArt;
        }

        var ct = document.getElementById('tyrano_base') || document.body;
        var old = document.getElementById('get-notify');
        if(old){ old.remove(); }

        var ov = document.createElement('div');
        ov.id = 'get-notify';
        ov.style.cssText =
            'position:absolute;top:0;left:0;width:100%;height:100%;z-index:999999999;'
            + 'display:flex;align-items:center;justify-content:center;font-family:' + BODY + ';'
            + 'background:radial-gradient(70% 70% at 50% 45%,rgba(20,12,3,0.86),rgba(4,2,0,0.97))';

        ov.innerHTML =
            '<div style="width:1180px;display:flex;flex-direction:column;'
                + 'animation:invrise .45s cubic-bezier(.2,.9,.3,1.15)">'
            + '<div style="display:flex;align-items:center;padding:18px 48px;border-radius:12px 12px 0 0;'
                + 'background:' + c.bar + ';border:1px solid ' + c.bd + ';color:' + c.accent + '">'
                + '<div style="font-size:22px;letter-spacing:0.5em">' + c.tag + '</div>'
                + '<div style="flex:1"></div>'
                + '<div style="font-size:22px;letter-spacing:0.2em">' + whereLabel + '</div>'
            + '</div>'
            + '<div style="display:flex;gap:38px;padding:44px 48px;'
                + 'background:linear-gradient(180deg,rgba(22,15,4,0.98),rgba(9,6,1,0.99));'
                + 'border:1px solid ' + c.bd + ';border-top:none;border-radius:0 0 12px 12px;'
                + 'box-shadow:0 24px 80px rgba(0,0,0,0.75)">'
                + '<div style="flex-shrink:0;width:300px;height:300px;border-radius:10px;display:flex;'
                    + 'align-items:center;justify-content:center;background:rgba(40,26,8,0.85);'
                    + 'border:1px solid ' + c.bd + '">' + artHTML + '</div>'
                + '<div style="flex:1;min-width:0;display:flex;flex-direction:column;gap:22px">'
                    + '<div style="font-family:' + TITLE + ';font-size:58px;line-height:1.15;color:#fdf1c8">' + name + '</div>'
                    + (memo ? '<div style="font-size:26px;line-height:1.6;color:#cbb684;text-wrap:pretty">' + memo + '</div>' : '')
                    + progress
                    + '<div style="flex:1"></div>'
                    + '<div style="display:flex;align-items:center;gap:18px">'
                        + '<div style="font-size:21px;color:#7a5c28">手がかりボードに記録しました</div>'
                        + '<div style="flex:1"></div>'
                        + '<button id="get-notify-ok" style="padding:16px 46px;background:#c8a060;border:none;'
                            + 'border-radius:6px;color:#0a0702;font-size:26px;font-weight:700;font-family:inherit;'
                            + 'cursor:pointer;letter-spacing:0.14em;white-space:nowrap">確認</button>'
                    + '</div>'
                + '</div>'
            + '</div></div>';

        ct.appendChild(ov);

        // 画像が読めなかったときは記号に差し替える
        (function(){
            var art = ov.querySelector('img.get-notify-art');
            if(!art){ return; }
            art.onerror = function(){ this.outerHTML = fallbackArt; };
            // すでに読み込みに失敗している場合も拾う
            if(art.complete && art.naturalWidth === 0){ art.onerror(); }
        })();

        // 「確認」で閉じて本編を再開する。hold="false" のときは待たずに自動で閉じる
        var wait = (mp.hold != 'false');
        // 称号の対象アイテムなら、この画面を閉じてから報せを出す（重ならないように）
        var achItem = (mp.id !== undefined) ? mp.id : '';
        window.getNotifyClose = function(){
            var el = document.getElementById('get-notify');
            if(!el){ return; }
            el.remove();
            if(window.ACH){
                if(achItem){ window.ACH.grantByItem(achItem); }
                window.ACH.checkAllItems();
            }
            // [s] による停止を解除してから本編を再開する
            if(wait){ TG.cancelStrongStop(); TG.cancelWeakStop(); TG.ftag.nextOrder(); }
        };
        var btn = document.getElementById('get-notify-ok');
        if(btn){ btn.onclick = window.getNotifyClose; }
        if(!wait){ setTimeout(window.getNotifyClose, 2600); }
    })();
    [endscript]

    ; 既定は「確認」待ち。hold="false" のときだけ止めずに進む
    [if exp="mp.hold != 'false'"]
        [s]
    [endif]
[endmacro]

[return]
