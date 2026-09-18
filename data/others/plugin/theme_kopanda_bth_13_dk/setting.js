
// メニュー画面にコンフィグへの遷移ボタンを設置
// スクリプト参照元「りまねどっとねっと」さま（https://rimane.net/）

const myobj = {

  // コンフィグ画面遷移用のオブジェクト
  config: function() {
    if (tyrano.plugin.kag.tmp.sleep_game != null) {
      return false;
    }
    TYRANO.kag.ftag.startTag("sleepgame", {
      storage: "../others/plugin/theme_kopanda_bth_13_dk/config.ks",
      next: false
    });
    setTimeout(function() {
      $('.layer.layer_menu').css({
        'display': 'none'
      });
    }, 100);
  },
};

//----------------------------------------------------------------------------

// 近似値を取得する関数
replaceCurrentValue = function(value, array){

  var value = value;
  var array = array;
  var diff  = [];
  var index = 0;

  $(array).each(function(i, val){
    diff[i] = Math.abs(value - val);
    index   = (diff[index] < diff[i] ? index : i);
  });

    return array[index];
}
