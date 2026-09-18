; 2025/03/09 @ko10panda edit

;=====================================================
;	コンフィグ画面作成
;=====================================================
[mask time="250"]


[layopt layer="message0" visible="false"]
[clearfix]
[stop_keyconfig]
[free_layermode time="10" wait="true"]
[reset_camera time="10" wait="true"]
[hidemenubutton]

[iscript]

$(".layer_camera").empty();
$("#bgmovie").remove();

TG.config.autoRecordLabel = "true";

/*
 * コンフィグで使用する変数
 *
 * tf.img_path				    共通：画像類のパス
 * tf.img_btn		          共通：ボタン画像のファイル名（透明なので見えません）

 * tf.img_mute            BGM・SEミュート：画像ファイル名
 * tf.img_mute_hover      BGM・SEミュート：ホバー時の画像ファイル名
 * tf.img_pos_mute_bgm    BGMミュート：ボタンの配置座標 [X, Y]
 * tf.img_pos_mute_se     SEミュート：ボタンの配置座標 [X, Y]
 * tf.img_mute_width      BGM・SEミュート：ボタンの幅
 * tf.img_mute_height     BGM・SEミュート：ボタンの高さ
 *
 * tf.img_skip_off        未読スキップ：Offの画像ファイル名
 * tf.img_skip_on         未読スキップ：Onの画像ファイル名
 * tf.img_skip_hover      未読スキップ：ホバー時の画像ファイル名
 * tf.img_pos_skip        未読スキップ：ボタンの配置座標 [skipoff_posx, skipoff_posy, skipon_posx, skipon_posy]
 * tf.img_skip_width      未読スキップ：ボタンの幅
 * tf.img_skip_height     未読スキップ：ボタンの高さ
 *
 * tf.img_fullscreen      画像サイズ：フルスクリーンの画像ファイル名
 * tf.img_windowed        画像サイズ：ウィンドウの画像ファイル名
 * tf.img_screen_hover    画面サイズ：ホバー時の画像ファイル名
 * tf.img_pos_screen      画面サイズ：ボタンの配置座標 [fullscreen_posx, fullscreen_posy, windowed_posx, windowed_posy]
 * tf.img_screen_width    画面サイズ：ボタンの幅
 * tf.img_screen_height   画面サイズ：ボタンの高さ
 *
 * tf.current_bgm_vol		  BGM音量：現在のBGM音量
 * tf.current_se_vol		  SE音量：現在のSE音量
 * tf.current_ch_speed		テキスト速度：現在のテキスト速度
 * tf.current_auto_speed	オートウェイト：現在のオートウェイト
 *
 * tf.text_skip				    未読スキップ：現在の未読スキップの状態
 * tf.screen_size			    画面サイズ：現在の画面サイズ
 *
 * f.prev_vol_list			  BGM、SE：BGMとSEの音量とインデックスを保存する配列
 *
*/

tf.img_path 		      = '../others/plugin/theme_kopanda_bth_13_dk/image/config/';
tf.img_btn 	          = tf.img_path + 'c_btn.gif';

tf.img_mute           = tf.img_path + 'mute.png';
tf.img_mute_hover     = tf.img_path + 'mute_hover.png';
tf.img_pos_mute_bgm   = [1557, 227];
tf.img_pos_mute_se    = [1557, 323];
tf.img_mute_width     =  78;
tf.img_mute_height    =  78;

tf.img_skip_off       = tf.img_path + 'skip_off.png';
tf.img_skip_on        = tf.img_path + 'skip_on.png';
tf.img_skip_hover     = tf.img_path + 'hover.png';
tf.img_pos_skip       = [868, 766, 1192, 766]; // skip_off_posx, skip_off_posy, skip_on_posx, skip_on_posy
tf.img_skip_width     = 308;
tf.img_skip_height    =  56;

tf.img_fullscreen     = tf.img_path + 'fullscreen.png';
tf.img_windowed       = tf.img_path + 'windowed.png';
tf.img_screen_hover   = tf.img_path + 'hover.png';
tf.img_pos_screen     = [868, 862, 1192, 862]; // fullscreen_posx, fullscreen_posy, windowed_posx, windowed_posy
tf.img_screen_width   = 308;
tf.img_screen_height  =  56;

tf.current_bgm_vol    = parseInt(TG.config.defaultBgmVolume);
tf.current_se_vol     = parseInt(TG.config.defaultSeVolume);
tf.current_ch_speed   = parseInt(TG.config.chSpeed);
tf.current_auto_speed = parseInt(TG.config.autoSpeed);

// test
/*
const default_bgm_vol    = 80;
const default_se_vol     = 80;
const default_ch_speed   = 25;
const default_auto_speed = 2000;
*/

tf.text_skip ="ON";
	if(TG.config.unReadTextSkip != "true") {
		tf.text_skip ="OFF";
	}

tf.screen_size = (function() {
	if ((document.FullscreenElement !== undefined && document.FullscreenElement !== null) ||
    	(document.webkitFullscreenElement !== undefined && document.webkitFullscreenElement !== null) ||
      	(document.msFullscreenElement !== undefined && document.msFullscreenElement !== null)) {
    	return 'full';
 	} else {
  		return 'window';
	}
})();

// ミュート解除時はここからミュート直前の音量設定を取得する
if(typeof f.prev_vol_list === 'undefined') {
	f.prev_vol_list = [tf.current_bgm_vol, tf.current_se_vol];
}

[endscript]

[cm]

; 背景・見出し
[bg storage="&tf.img_path +'config_bg.png'" time="10" wait="false"]

[image name="label_config anim_label_slide_nlp" storage="&tf.img_path +'label_config.png'" layer="0" x="0" y="0" visible="true" time="350" wait="false"]

; 閉じるボタン
[button name="back_btn" fix="true" graphic="&tf.img_path + 'btn_back.png'" enterimg="&tf.img_path + 'btn_back2.png'" target="*backtitle" x="1756" y="56"]

[jump target="*config_page"]

*config_page

[clearstack]

;-------------------------------------------------------------------------------

; スライダー配置

;-------------------------------------------------------------------------------
[iscript]

/* tooltips format */
const format = {
	to: function (value) {
		return Math.round(value).toLocaleString();
	},
	from: function (value) {
		return Number(value.replace(/,/g, ''));
	}
};

/* -----------------------------------------------------------------------------

 BGM Vol

----------------------------------------------------------------------------- */

	$(".layer_free").append('<div id="bgm_volume" class="slider"></div>');

	const bgm_vol_slider = document.getElementById('bgm_volume');

				// style
				bgm_vol_slider.style.top = '264px';
				bgm_vol_slider.style.left = '924px';
				bgm_vol_slider.style.width = '480px';

	// slider setting
	noUiSlider.create(bgm_vol_slider,{
		start: tf.current_bgm_vol,
		connect: 'lower',
		behaviour: 'tap-drag',
		step: 1,
		range:{
			'min': 0,
			'max': 100
		},
		tooltips: true,
		format: format
	});

// update
bgm_vol_slider.noUiSlider.on('update', function(values, handle){
	tf.current_bgm_vol = values[handle];
	TG.ftag.startTag("bgmopt", {volume: values[handle]});
	if(tf.current_bgm_vol == 0){
		$('.mute_bgm').show();
	} else {
		$('.mute_bgm').hide();
	};
});


/* -----------------------------------------------------------------------------

 SE Vol

----------------------------------------------------------------------------- */

	$(".layer_free").append('<div id="se_volume" class="slider"></div>');

	const se_vol_slider = document.getElementById('se_volume');

				// style
				se_vol_slider.style.top = '361px';
				se_vol_slider.style.left = '924px';
				se_vol_slider.style.width = '480px';

	// slider setting
	noUiSlider.create(se_vol_slider,{
		start: tf.current_se_vol,
		connect: 'lower',
		behaviour: 'tap-drag',
		step: 1,
		range:{
			'min': 0,
			'max': 100
		},
		tooltips: true,
		format: format
	});

	// update
	se_vol_slider.noUiSlider.on('update', function(values, handle){
		tf.current_se_vol = values[handle];
		TG.ftag.startTag("seopt", {volume: values[handle]});
		if(tf.current_se_vol == 0){
			$('.mute_se').show();
		} else {
			$('.mute_se').hide();
		};
	});

/* -----------------------------------------------------------------------------

 TextSpeed

----------------------------------------------------------------------------- */

	$(".layer_free").append('<div id="ch_speed" class="slider"></div>');

	const ch_speed_slider = document.getElementById('ch_speed');

				// style
				ch_speed_slider.style.top = '456px';
				ch_speed_slider.style.left = '924px';
				ch_speed_slider.style.width = '480px';

  // slider setting
	noUiSlider.create(ch_speed_slider,{
		start: tf.current_ch_speed,
		connect: 'upper',
		direction: 'rtl',
		behaviour: 'tap-drag',
		step: 1,
		range:{
			'min': 5,
			'max': 100
		},
		tooltips: true,
		format: format
	});

// update
ch_speed_slider.noUiSlider.on('change', function(values, handle){
	TG.ftag.startTag("configdelay", {speed: values[handle]});
	gMessageTester.currentTextNumber = 0;
	gMessageTester.next(true);
});

/* -----------------------------------------------------------------------------

 AutoTextSpeed

----------------------------------------------------------------------------- */

	$(".layer_free").append('<div id="auto_speed" class="slider"></div>');

	const auto_speed_slider = document.getElementById('auto_speed');

				// style
				auto_speed_slider.style.top = '553px';
				auto_speed_slider.style.left = '924px';
				auto_speed_slider.style.width = '480px';

  // slider setting
	noUiSlider.create(auto_speed_slider,{
		start: tf.current_auto_speed,
		connect: 'upper',
		direction: 'rtl',
		behaviour: 'tap-drag',
		step: 1,
		range:{
			'min': 500,
			'max': 5000
		},
		tooltips: true,
		format: format
	});

// update
auto_speed_slider.noUiSlider.on('update', function(values, handle){
	TG.ftag.startTag("autoconfig", {speed: values[handle]});
});

[endscript]

;===============================================================================

 Button

;===============================================================================

; Mute BGM
[button fix="true" target="*vol_bgm_mute" graphic="&tf.img_btn" enterimg="&tf.img_mute_hover" width="&tf.img_mute_width" height="&tf.img_mute_height" x="&tf.img_pos_mute_bgm[0]" y="&tf.img_pos_mute_bgm[1]"]

; Mute SE
[button fix="true" target="*vol_se_mute" graphic="&tf.img_btn" enterimg="&tf.img_mute_hover" width="&tf.img_mute_width" height="&tf.img_mute_height" x="&tf.img_pos_mute_se[0]" y="&tf.img_pos_mute_se[1]"]

; Unread Text Skip -- Skip Off
[button name="unread_off" fix="true" target="*skip_off" graphic="&tf.img_btn" enterimg="&tf.img_skip_hover" width="&tf.img_skip_width" height="&tf.img_skip_height" x="&tf.img_pos_skip[0]" y="&tf.img_pos_skip[1]"]

; Unread Text Skip -- Skip On
[button name="unread_on" fix="true" target="*skip_on" graphic="&tf.img_btn" enterimg="&tf.img_skip_hover" width="&tf.img_skip_width" height="&tf.img_skip_height" x="&tf.img_pos_skip[2]" y="&tf.img_pos_skip[3]"]

; Screen Size -- FullScreen
[button name="screen_full" fix="true" target="*screen_full" graphic="&tf.img_btn" enterimg="&tf.img_screen_hover" width="&tf.img_screen_width" height="&tf.img_screen_height" x="&tf.img_pos_screen[0]" y="&tf.img_pos_screen[1]"]

; Screen Size -- Windowed
[button name="screen_window" fix="true" target="*screen_window" graphic="&tf.img_btn" enterimg="&tf.img_screen_hover" width="&tf.img_screen_width" height="&tf.img_screen_height" x="&tf.img_pos_screen[2]" y="&tf.img_pos_screen[3]"]

;-------------------------------------------------------------------------------
; コンフィグ起動時に読み込み
;-------------------------------------------------------------------------------
[layopt layer="0" visible="true"]

[call target="*load_bgm_img"]
[call target="*load_se_img"]
[call target="*load_skip_img"]
[call target="*load_screen_img"]

[test_message_start]

[mask_off time="250"]

[s]

;-------------------------------------------------------------------------------
; コンフィグモード終了
;-------------------------------------------------------------------------------
*backtitle
[cm]
[layopt layer="message1" visible="false"]
[clearfix]
[start_keyconfig]
[clearstack]

[awakegame]

;===============================================================================

; ボタンクリック時の処理

;===============================================================================
;-------------------------------------------------------------------------------
; Mute BGM
;-------------------------------------------------------------------------------
*vol_bgm_mute
[iscript]

const bgm_vol_slider = document.getElementById('bgm_volume');

// mute
if(tf.current_bgm_vol != 0){
	f.prev_vol_list[0] = tf.current_bgm_vol;
	tf.current_bgm_vol = 0;
	bgm_vol_slider.noUiSlider.set(0);
} else {
	tf.current_bgm_vol = f.prev_vol_list[0];
	bgm_vol_slider.noUiSlider.set(tf.current_bgm_vol);
}

// setting
TG.ftag.startTag("bgmopt", {volume: tf.current_bgm_vol});

[endscript]

; reload img
[call target="*load_bgm_img"]

[return]

;-------------------------------------------------------------------------------
; Mute SE
;-------------------------------------------------------------------------------
*vol_se_mute
[iscript]

const se_vol_slider = document.getElementById('se_volume');

// mute
if(tf.current_se_vol != 0){
	f.prev_vol_list[1] = tf.current_se_vol;
	tf.current_se_vol = 0;
	se_vol_slider.noUiSlider.set(0);
} else {
	tf.current_se_vol = f.prev_vol_list[1];
	se_vol_slider.noUiSlider.set(tf.current_se_vol);
}

// setting
TG.ftag.startTag("seopt", {volume: tf.current_se_vol});

[endscript]

; reload img
[call target="*load_se_img"]

[endscript]

[return]

;-------------------------------------------------------------------------------
; スキップ処理-OFF
;-------------------------------------------------------------------------------
*skip_off
[free layer="0" name="unread_on" time="10"]
[image layer="0" name="unread_off" storage="&tf.img_skip_off" x="&tf.img_pos_skip[0]" y="&tf.img_pos_skip[1]"]
[config_record_label skip="false"]

[return]

;-------------------------------------------------------------------------------
; スキップ処理-ON
;-------------------------------------------------------------------------------
*skip_on
[free layer="0" name="unread_off" time="10"]
[image layer="0" name="unread_on" storage="&tf.img_skip_on" x="&tf.img_pos_skip[2]" y="&tf.img_pos_skip[3]"]
[config_record_label skip="true"]

[return]

;-------------------------------------------------------------------------------
; 画面サイズ-フルスクリーン
;-------------------------------------------------------------------------------
*screen_full
[if exp="tf.screen_size == 'window'"]
	[screen_full]
	[free layer="0" name="screen_window" time="10"]
	[image layer="0" name="screen_full" storage="&tf.img_fullscreen" x="&tf.img_pos_screen[0]" y="&tf.img_pos_screen[1]"]
	[eval exp="tf.screen_size = 'full'"]
[endif]

[return]


;-------------------------------------------------------------------------------
; 画面サイズ-ウィンドウサイズ
;-------------------------------------------------------------------------------
*screen_window
[if exp="tf.screen_size == 'full'"]
	[screen_full]
	[free layer="0" name="screen_full" time="10"]
	[image layer="0" name="screen_window" storage="&tf.img_windowed" x="&tf.img_pos_screen[2]" y="&tf.img_pos_screen[3]"]
	[eval exp="tf.screen_size = 'window'"]
[endif]

[return]

;===============================================================================

; reload img

;===============================================================================
*load_bgm_img
[image layer="0" name="mute_bgm" storage="&tf.img_mute" x="&tf.img_pos_mute_bgm[0]" y="&tf.img_pos_mute_bgm[1]" time="10" visible="false"]

[iscript]
// 音量が0のときはミュートにチェックを入れる
if(tf.current_bgm_vol == 0){
	$('.mute_bgm').show();
} else {
	$('.mute_bgm').hide();
}
[endscript]

[return]

;-------------------------------------------------------------------------------
*load_se_img
[image layer="0" name="mute_se" storage="&tf.img_mute" x="&tf.img_pos_mute_se[0]" y="&tf.img_pos_mute_se[1]" time="10" visible="false"]

[iscript]
// 音量が0のときはミュートにチェックを入れる
if(tf.current_se_vol == 0){
	$('.mute_se').show();
} else {
	$('.mute_se').hide();
}
[endscript]

[return]
;-------------------------------------------------------------------------------
*load_skip_img
[if exp="tf.text_skip == 'ON'"]
	[image layer="0" name="unread_on" storage="&tf.img_skip_on" x="&tf.img_pos_skip[2]" y="&tf.img_pos_skip[3]"]
[else]
	[image layer="0" name="unread_off" storage="&tf.img_skip_off" x="&tf.img_pos_skip[0]" y="&tf.img_pos_skip[1]"]
[endif]

[return]
;-------------------------------------------------------------------------------
*load_screen_img
[if exp="tf.screen_size == 'full'"]
	[image layer="0" name="screen_full" storage="&tf.img_fullscreen" x="&tf.img_pos_screen[0]" y="&tf.img_pos_screen[1]"]
[else]
	[image layer="0" name="screen_window" storage="&tf.img_windowed" x="&tf.img_pos_screen[2]" y="&tf.img_pos_screen[3]"]
[endif]

[return]

*messagetest
[test_message_reset]
[return]
