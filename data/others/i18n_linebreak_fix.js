/*
 * English message-line-break compatibility fix.
 *
 * TyranoScript's controlLineBreak() is designed for Japanese kinsoku rules.
 * If an English message starts with a character such as '.', the engine can
 * try to insert a <br> before a non-existent previous character and throw:
 *   Cannot read properties of null (reading 'before')
 *
 * English word wrapping is already handled by data/others/i18n.js, so the
 * Japanese kinsoku pass should simply be skipped while English is active.
 */
(function () {
    "use strict";

    function patchTextTag(textTag) {
        if (!textTag || textTag.__i18n_linebreak_safe) return;
        if (typeof textTag.controlLineBreak !== "function") return;

        var original = textTag.controlLineBreak;
        textTag.controlLineBreak = function (jCharChildren, isVertical) {
            if (window.I18N && typeof window.I18N.isEN === "function" && window.I18N.isEN()) {
                return;
            }
            return original.call(this, jCharChildren, isVertical);
        };
        textTag.__i18n_linebreak_safe = true;
    }

    function install() {
        var tag = window.tyrano && window.tyrano.plugin && window.tyrano.plugin.kag &&
            window.tyrano.plugin.kag.tag && window.tyrano.plugin.kag.tag.text;
        patchTextTag(tag);

        // If KAG has already cloned the tag into master_tag, patch that copy too.
        var master = window.TYRANO && window.TYRANO.kag && window.TYRANO.kag.ftag &&
            window.TYRANO.kag.ftag.master_tag && window.TYRANO.kag.ftag.master_tag.text;
        patchTextTag(master);
    }

    install();
    if (window.jQuery) {
        window.jQuery(function () {
            install();
            setTimeout(install, 300);
        });
    }
})();
