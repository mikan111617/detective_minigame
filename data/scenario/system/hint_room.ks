;===============================================================================
; hint_room.ks ―― 舞黒相談所
; 話題選択は本編共通の [stand_select]。決定後の会話画面だけが低確率で変化する。
;===============================================================================

*start
[cm]
[clearfix]
[free_layer_image]
[freeimage layer="0"]
[freeimage layer="1"]
[hidemenubutton]
[chara_hide_all]
[layopt layer="message0" page=fore visible=false]
[bg storage="reference_room.png" time=500]
[fadeoutbgm time=700]
[playbgm storage="Gazing_into_the_Truth.mp3" loop=true]

[iscript]
if(window.TL){ window.TL.clear("tl-title"); }
if(window.MSGUI){ window.MSGUI.clear(); }
if(window.HR && window.HR.clear){ window.HR.clear(); }
[endscript]
[loadjs storage="hint_room.js"]
[jump target="*hint_menu"]


;-------------------------------------------------------------------------------
; 固定の話題選択画面。本編のお茶会・自由行動と同じUIを使う。
;-------------------------------------------------------------------------------
*hint_menu
[cm]
[chara_hide_all]
[layopt layer="message0" page=fore visible=false]
[bg storage="reference_room.png" time=300]

[iscript]
if(window.HR){ window.HR.clear(); }
if(window.MSGUI){ window.MSGUI.clear(); }
var hintChara = [{ id:'maicro', name:'舞黒邦夢', src:'./data/fgimage/chara/maicro/normal.png' }];
tf.choices = [
  { target:'*hint_ending', text:'まだ見ぬ結末について',       kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_true_end', text:'真エンディングへのぶっちゃけ話', kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_route',  text:'話の分かれ道について',       kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_stop',   text:'最後の犯行を止めるには',     kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_scene7', text:'夜の探索を有利に進めたい',   kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_chat',   text:'舞黒邦夢と雑談する',         kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_dev',    text:'舞台袖の記録を読む',         kind:'look', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_unstable', text:'画面が時々安定しないことについて', kind:'talk', chara:hintChara, name:'舞黒邦夢' },
  { target:'*hint_leave',  text:'相談を終える',               kind:'move', chara:[] }
];
[endscript]

[stand_select storage="system/hint_room.ks" se="decide.mp3" prompt="舞黒『さて、何に困っている？　茶は出ないが、話なら出せるよ』"]
[s]


;-------------------------------------------------------------------------------
; 話題決定時にだけ演出を抽選する。
;-------------------------------------------------------------------------------
*hint_ending
[iscript]
window.HR.begin('ending');
[endscript]
[s]

*hint_true_end
[iscript]
window.HR.begin('true_end');
[endscript]
[s]

*hint_route
[iscript]
window.HR.begin('route');
[endscript]
[s]

*hint_stop
[iscript]
window.HR.begin('stop');
[endscript]
[s]

*hint_scene7
[iscript]
window.HR.begin('scene7');
[endscript]
[s]

*hint_chat
[iscript]
window.HR.begin('chat');
[endscript]
[s]

*hint_dev
[iscript]
window.HR.begin('dev');
[endscript]
[s]

*hint_unstable
[iscript]
window.HR.begin('unstable');
[endscript]
[s]


;-------------------------------------------------------------------------------
; 退出
;-------------------------------------------------------------------------------
*hint_leave
[mask time=500]
[cm]
[clearfix]
[free_layer_image]
[chara_hide_all]
[layopt layer="message0" page=fore visible=false]
[iscript]
if(window.HR){ window.HR.clear(); }
[endscript]
[jump storage="title.ks" target="*start"]
