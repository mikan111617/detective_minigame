;--------------------------------------------------------------------------------
; ティラノスクリプト テーマ一括変換プラグイン theme_kopanda_bth_13_dk_dk
; 作者:こ・ぱんだ
; https://kopacurve.blog.fc2.com/
;--------------------------------------------------------------------------------

[iscript]

mp.font_color    = mp.font_color    || "0xE5DFD6";
mp.name_color    = mp.name_color    || "0xE5CA95";
mp.frame_opacity = mp.frame_opacity || "255";
mp.font_color2   = mp.font_color2   || "0xE5DFD6";
mp.glyph         = mp.glyph         || "on";

if(TG.config.alreadyReadTextColor != "default") {
	TG.config.alreadyReadTextColor = mp.font_color2;
}

[endscript]

; 名前部分のメッセージレイヤ削除
[free name="chara_name_area" layer="message0"]

; メッセージウィンドウの設定
[position layer="message0" width="1800" height="246" top="814" left="60"]
[position layer="message0" frame="../others/plugin/theme_kopanda_bth_13_dk/image/frame_message.png" margint="60" marginl="260" marginr="260" marginb="80" opacity="&mp.frame_opacity" page="fore"]

; 名前枠の設定
[ptext name="chara_name_area" layer="message0" color="&mp.name_color" size="34" x="207" y="818" width="480" align="center"]
[chara_config ptext="chara_name_area"]

; デフォルトのフォントカラー指定
[font color="&mp.font_color"]
[deffont color="&mp.font_color"]

; デフォルトのフォントサイズ指定
[font size="38"]
[deffont size="38"]

; クリック待ちグリフの設定（on設定時のみ有効、デフォルトはon）
[if exp="mp.glyph == 'on'"]
[glyph line="../../../data/others/plugin/theme_kopanda_bth_13_dk/image/system/nextpage.png"]
[endif]

;=================================================================================

; 機能ボタンを表示するマクロ

;=================================================================================

; 機能ボタンを表示したいシーンで[add_theme_button]と記述してください（消去は[clearfix name="role_button"]）
[macro name="add_theme_button"]

; デフォルトのメニューボタンを消す
[hidemenubutton]

[iscript]

	tf.sysbtn_img_path = '../others/plugin/theme_kopanda_bth_13_dk/image/button/'; // 画像のパス
	tf.sysbtn_posx     = [980, 1124, 1268, 1412, 1556, 1700, 1844]; // 配置するX座標
	tf.sysbtn_posy     = 1028; // 配置するY座標

[endscript]

; システムボタンは50%に縮小表示しています。お好みに合わせてサイズを調整してください
; Q.Save
[button name="role_button" role="quicksave" width="135" height="45" graphic="&tf.sysbtn_img_path + 'qsave.png'" enterimg="&tf.sysbtn_img_path + 'qsave2.png'" x="&tf.sysbtn_posx[0]" y="&tf.sysbtn_posy"]

; Q.Load
[button name="role_button" role="quickload" width="135" height="45" graphic="&tf.sysbtn_img_path + 'qload.png'" enterimg="&tf.sysbtn_img_path + 'qload2.png'" x="&tf.sysbtn_posx[1]" y="&tf.sysbtn_posy"]

; Auto
[button name="role_button" role="auto" width="135" height="45" graphic="&tf.sysbtn_img_path + 'auto.png'" enterimg="&tf.sysbtn_img_path + 'auto2.png'" x="&tf.sysbtn_posx[2]" y="&tf.sysbtn_posy"]

; Skip
[button name="role_button" role="skip" width="135" height="45" graphic="&tf.sysbtn_img_path + 'skip.png'" enterimg="&tf.sysbtn_img_path + 'skip2.png'" x="&tf.sysbtn_posx[3]" y="&tf.sysbtn_posy"]

; Backlog
[button name="role_button" role="backlog" width="135" height="45" graphic="&tf.sysbtn_img_path + 'log.png'" enterimg="&tf.sysbtn_img_path + 'log2.png'" x="&tf.sysbtn_posx[4]" y="&tf.sysbtn_posy"]

; Screen
[button name="role_button" role="fullscreen" width="135" height="45" graphic="&tf.sysbtn_img_path + 'screen.png'" enterimg="&tf.sysbtn_img_path + 'screen2.png'" x="&tf.sysbtn_posx[5]" y="&tf.sysbtn_posy"]

; Title
[button name="role_button" role="title" width="135" height="45" graphic="&tf.sysbtn_img_path + 'title.png'" enterimg="&tf.sysbtn_img_path + 'title2.png'" x="&tf.sysbtn_posx[5]" y="&tf.sysbtn_posy"]


; Close
[button name="role_button" role="window" graphic="&tf.sysbtn_img_path + 'close.png'" enterimg="&tf.sysbtn_img_path + 'close2.png'" x="1804" y="868"]

; Menu
[button name="role_button" role="menu" graphic="&tf.sysbtn_img_path + 'menu.png'" enterimg="&tf.sysbtn_img_path + 'menu2.png'" x="1746" y="46"]

[endmacro]


;=================================================================================

; システムで利用するHTML,CSSの設定

;=================================================================================
; セーブ画面
[sysview type="save" storage="./data/others/plugin/theme_kopanda_bth_13_dk/html/save.html"]

; ロード画面
[sysview type="load" storage="./data/others/plugin/theme_kopanda_bth_13_dk/html/load.html"]

; バックログ画面
[sysview type="backlog" storage="./data/others/plugin/theme_kopanda_bth_13_dk/html/backlog.html"]

; メニュー画面
[sysview type="menu" storage="./data/others/plugin/theme_kopanda_bth_13_dk/html/menu.html"]

; メニュー画面からコンフィグを呼び出す
[loadjs storage="plugin/theme_kopanda_bth_13_dk/setting.js"]

; CSS
[loadcss file="./data/others/plugin/theme_kopanda_bth_13_dk/tyrano.css"]
[loadcss file="./data/others/plugin/theme_kopanda_bth_13_dk/bth13_dk.css"]

;=================================================================================
; noUiSliderライブラリの読み込み
;=================================================================================
[loadcss file="./data/others/plugin/theme_kopanda_bth_13_dk/noUiSlider/nouislider.min.css"]
[loadjs storage="plugin/theme_kopanda_bth_13_dk/noUiSlider/noUiSlider.min.js"]
[loadjs storage="plugin/theme_kopanda_bth_13_dk/noUiSlider/wNumb.js"]

;=================================================================================
; テストメッセージ出力プラグインの読み込み
;=================================================================================
[loadjs storage="plugin/theme_kopanda_bth_13_dk/testMessagePlus/gMessageTester.js"]
[loadcss file="./data/others/plugin/theme_kopanda_bth_13_dk/testMessagePlus/style.css"]

[macro name="test_message_start"]
[eval exp="gMessageTester.create()"]
[endmacro]

[macro name="test_message_end"]
[eval exp="gMessageTester.destroy()"]
[endmacro]

[macro name="test_message_reset"]
[eval exp="gMessageTester.currentTextNumber=0;gMessageTester.next(true)"]
[endmacro]


[return]
