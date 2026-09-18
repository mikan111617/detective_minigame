/*
 * voice_runtime.js
 *
 * voice_pipeline_v12.py が生成する scene 単位の voice map を使って、
 * TyranoScript の [voice id="v00001"] を [playse] に解決する軽量ランタイム。
 *
 * 配置例:
 *   data/others/voice_runtime.js
 *   data/others/voice_maps/scene1.json
 *   data/others/voice_maps/scene2.json
 *
 * 起動時に1度だけ:
 *   [loadjs storage="voice_runtime.js"]
 *
 * シナリオ側:
 *   [voice id="v00001"]
 *   セリフ[p]
 */
(function () {
    "use strict";

    const MAP_BASE = "./data/others/voice_maps/";
    // SE で使っている buf=1 と分離し、音声専用バッファを使う。
    const DEFAULT_BUF = "2";
    const cache = Object.create(null);
    const loading = Object.create(null);

    function currentSceneKey(kag) {
        const current = String((kag.stat && kag.stat.current_scenario) || "");
        const file = current.split(/[\\/]/).pop() || current;
        return file.replace(/\.ks$/i, "");
    }

    function mapUrl(sceneKey) {
        return MAP_BASE + encodeURIComponent(sceneKey) + ".json";
    }

    function registerVoiceBuffer(kag, buf) {
        // TyranoScript のオート待機は、再生中の SE 全般ではなく
        // map_vo.vobuf に登録されたバッファだけを「音声」として待つ。
        kag.stat.map_vo = kag.stat.map_vo || {};
        kag.stat.map_vo.vobuf = kag.stat.map_vo.vobuf || {};
        kag.stat.map_vo.vochara = kag.stat.map_vo.vochara || {};
        kag.stat.map_vo.vobuf[buf] = 1;
    }

    function loadSceneMap(sceneKey, onSuccess, onError) {
        if (cache[sceneKey]) {
            onSuccess(cache[sceneKey]);
            return;
        }

        // 同じsceneの最初の複数要求が重なった場合も、JSON取得は1回だけにする。
        if (loading[sceneKey]) {
            loading[sceneKey].push({ onSuccess, onError });
            return;
        }

        loading[sceneKey] = [{ onSuccess, onError }];

        $.getJSON(mapUrl(sceneKey))
            .done(function (map) {
                cache[sceneKey] = map || {};
                const waiters = loading[sceneKey] || [];
                delete loading[sceneKey];
                waiters.forEach(function (w) {
                    w.onSuccess(cache[sceneKey]);
                });
            })
            .fail(function (_xhr, status, error) {
                const waiters = loading[sceneKey] || [];
                delete loading[sceneKey];
                const message =
                    "voice map load failed: scene=" + sceneKey +
                    " url=" + mapUrl(sceneKey) +
                    " status=" + status +
                    " error=" + error;
                waiters.forEach(function (w) {
                    w.onError(message);
                });
            });
    }

    const voiceTag = {
        vital: ["id"],
        pm: {
            id: "",
            buf: DEFAULT_BUF,
        },

        start: function (pm) {
            const kag = this.kag;
            const voiceId = String(pm.id || "").trim();
            const sceneKey = currentSceneKey(kag);

            // タイトル画面のボイス設定がOFFなら、マップ取得も再生もせず次へ進む。
            // 共通 [voice] マクロを経由しない直接呼び出しに対してもここで抑止する。
            const sf = (kag.variable && kag.variable.sf) || {};
            if (sf.voice_enabled == 0) {
                kag.ftag.nextOrder();
                return;
            }

            const failAndContinue = function (message) {
                console.error("[voice] " + message);
                kag.ftag.nextOrder();
            };

            if (!voiceId) {
                failAndContinue("id is empty");
                return;
            }
            if (!sceneKey) {
                failAndContinue("current scenario is unknown: id=" + voiceId);
                return;
            }

            loadSceneMap(
                sceneKey,
                function (map) {
                    const storage = map[voiceId];
                    if (!storage) {
                        failAndContinue(
                            "voice id not found: scene=" + sceneKey + " id=" + voiceId
                        );
                        return;
                    }

                    const buf = String(pm.buf || DEFAULT_BUF);
                    registerVoiceBuffer(kag, buf);

                    // この custom tag 自身では nextOrder しない。
                    // playse(stop=false) に次の命令への進行を委ねることで二重進行を防ぐ。
                    kag.ftag.startTag("playse", {
                        storage: storage,
                        buf: buf,
                        stop: "false",
                    });
                },
                failAndContinue
            );
        },
    };

    // [loadjs] はKAG初期化後に実行されるため [voice] タグとして直接登録する。
    // マクロを経由すると current_scenario が macro.ks になり、音声マップを特定できない。
    voiceTag.kag = TYRANO.kag;
    TYRANO.kag.ftag.master_tag.voice = voiceTag;

    // デバッグ用途。通常シナリオから触る必要はない。
    window.__voiceRuntime = {
        cache: cache,
        currentSceneKey: function () {
            return currentSceneKey(TYRANO.kag);
        },
    };

    console.log("[voice] voice_runtime.js loaded");
})();
