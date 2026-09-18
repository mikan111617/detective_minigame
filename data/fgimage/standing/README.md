# standing（選択肢画面用の立ち絵）

`[stand_select]`（`data/scenario/choice_ui.ks`）が選択肢画面の左側に出す立ち絵を置く場所です。

## ファイル名

`data/fgimage/standing/<キャラクター名>.png`

`<キャラクター名>` は選択肢データの `chara` に書いた名前です。
`chara.ks` の `[chara_new name="..."]` と同じ英字名（例：`kazuto.png`, `eruku.png`）を推奨します。

読み込みは次の順で試し、見つかったものを使います。

1. `standing/<英字名>.png` … 例：`kazuto.png`
2. `standing/<日本語名>.png` … `[chara_new]` の `jname`。例：`和人.png`
3. `chara/<英字名>/normal.png` … 立ち絵が未用意のときの代替

## 画像について

- 縦 990px（2人並ぶときは 900px）に合わせて表示されます。横幅は縦横比のまま、最大 760px。
- 画面下端に接地するので、足元まで入った縦長の絵が向いています。
- 背景は透過（PNG）にしてください。
