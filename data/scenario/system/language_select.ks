;===============================================================================
; language_select.ks ―― 初回起動時の言語選択
;
; localStorage の maiguro_lang が未設定のときだけ表示する。
; 選択後は言語を保存してページを再読み込みし、
; 選択言語の注意画面 → タイトル画面へ進む。
; タイトル画面側の言語切り替えは別途そのまま利用する。
;===============================================================================

[iscript]
(function(){
    var key = "maiguro_lang";
    var selected = "";

    try {
        selected = window.localStorage.getItem(key) || "";
    } catch (e) {}

    tf.need_language_select = (selected !== "ja" && selected !== "en") ? 1 : 0;
    if (!tf.need_language_select) { return; }

    var base = document.getElementById("tyrano_base") || document.body;
    var old = document.getElementById("maiguro-language-select");
    if (old && old.parentNode) { old.parentNode.removeChild(old); }

    var wrap = document.createElement("div");
    wrap.id = "maiguro-language-select";
    wrap.style.cssText = [
        "position:absolute",
        "left:0",
        "top:0",
        "width:1920px",
        "height:1080px",
        "z-index:2147483000",
        "display:flex",
        "align-items:center",
        "justify-content:center",
        "background:radial-gradient(circle at 50% 42%,#211a16 0%,#120f0d 58%,#090807 100%)",
        "color:#ead7ad",
        "font-family:'Yu Gothic','Hiragino Kaku Gothic ProN',sans-serif"
    ].join(";");

    wrap.innerHTML =
        '<div style="position:absolute;left:0;top:0;width:100%;height:3px;background:#8b1f1f"></div>' +
        '<div style="position:absolute;left:0;bottom:0;width:100%;height:3px;background:#8b1f1f"></div>' +
        '<div style="width:980px;text-align:center">' +
          '<div style="font-family:Georgia,\'Times New Roman\',serif;font-size:26px;letter-spacing:.52em;color:#8e7448;margin-bottom:22px">THE TRAGEDY AT MAICRO HOUSE</div>' +
          '<div style="font-size:56px;letter-spacing:.16em;color:#f0dfb7;margin-bottom:8px">LANGUAGE</div>' +
          '<div style="font-size:25px;letter-spacing:.32em;color:#9c8257;margin-bottom:64px">言語を選択してください</div>' +
          '<div style="display:flex;justify-content:center;gap:34px">' +
            '<button type="button" data-lang="ja" style="width:370px;height:150px;border:1px solid rgba(191,151,82,.55);background:rgba(20,15,12,.84);color:#ead7ad;cursor:pointer;box-shadow:0 18px 42px rgba(0,0,0,.38);font:inherit">' +
              '<div style="font-size:42px;letter-spacing:.16em;margin-bottom:12px">日本語</div>' +
              '<div style="font-family:Georgia,\'Times New Roman\',serif;font-size:20px;letter-spacing:.28em;color:#8f7447">JAPANESE</div>' +
            '</button>' +
            '<button type="button" data-lang="en" style="width:370px;height:150px;border:1px solid rgba(191,151,82,.55);background:rgba(20,15,12,.84);color:#ead7ad;cursor:pointer;box-shadow:0 18px 42px rgba(0,0,0,.38);font:inherit">' +
              '<div style="font-family:Georgia,\'Times New Roman\',serif;font-size:42px;letter-spacing:.08em;margin-bottom:12px">English</div>' +
              '<div style="font-size:20px;letter-spacing:.30em;color:#8f7447">英語</div>' +
            '</button>' +
          '</div>' +
          '<div style="margin-top:52px;font-size:18px;line-height:1.9;letter-spacing:.06em;color:#756447">' +
            '言語はタイトル画面からいつでも変更できます。<br>' +
            'You can change the language at any time from the title screen.' +
          '</div>' +
        '</div>';

    base.appendChild(wrap);

    var buttons = wrap.querySelectorAll("button[data-lang]");
    var choosing = false;

    function choose(lang){
        if (choosing) { return; }
        choosing = true;

        for (var i = 0; i < buttons.length; i++) {
            buttons[i].disabled = true;
            buttons[i].style.cursor = "default";
            buttons[i].style.opacity = "0.55";
        }

        // i18n の初期値も日本語なので、初回に日本語を選んだ場合でも
        // 必ず「選択済み」として残るよう、setLang より先に明示保存する。
        try { window.localStorage.setItem(key, lang); } catch (e) {}

        if (window.I18N && typeof window.I18N.setLang === "function") {
            window.I18N.setLang(lang, function(){
                window.location.reload();
            });
            return;
        }

        // 万一 I18N がまだ利用できない場合も、上で保存した値を使って再起動する。
        window.location.reload();
    }

    function setHover(button, on){
        if (button.disabled) { return; }
        button.style.borderColor = on ? "#d0aa63" : "rgba(191,151,82,.55)";
        button.style.background = on ? "rgba(49,34,22,.94)" : "rgba(20,15,12,.84)";
        button.style.transform = on ? "translateY(-3px)" : "translateY(0)";
    }

    for (var i = 0; i < buttons.length; i++) {
        (function(button){
            button.style.transition = "border-color .18s ease,background .18s ease,transform .18s ease,opacity .18s ease";
            button.onclick = function(){ choose(button.getAttribute("data-lang")); };
            button.onmouseenter = function(){ setHover(button, true); };
            button.onmouseleave = function(){ setHover(button, false); };
            button.onfocus = function(){ setHover(button, true); };
            button.onblur = function(){ setHover(button, false); };
        })(buttons[i]);
    }

    // キーボードでも選択可能。左右で移動、Enter / Space で決定。
    buttons[0].focus();
    wrap.onkeydown = function(e){
        if (choosing) { return; }
        var active = document.activeElement;
        var index = (active === buttons[1]) ? 1 : 0;
        if (e.key === "ArrowLeft" || e.key === "ArrowRight") {
            e.preventDefault();
            buttons[index === 0 ? 1 : 0].focus();
        } else if (e.key === "Enter" || e.key === " ") {
            e.preventDefault();
            var target = document.activeElement;
            if (target && target.getAttribute("data-lang")) {
                choose(target.getAttribute("data-lang"));
            }
        }
    };
})();
[endscript]

; 初回選択中はシナリオをここで止める。選択後はページ再読み込みになるため resume は不要。
[if exp="tf.need_language_select==1"]
[s]
[endif]

[return]
