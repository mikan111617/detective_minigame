;===========================================================
; CGモード画面作成
;===========================================================

; このファイルはscenarioフォルダ内に配置、
; image フォルダ内に append_theme フォルダを配置して使用します
; 必要に応じて枚数やページの増減をおこなってください

;-----------------------------------------------------------
*start
;-----------------------------------------------------------
; 初期化
[freeimage layer="0" ]
[layopt layer=message0 visible=false]
[layopt layer=0 visible=true]
[layopt layer=1 visible=true]
[hidemenubutton]
[playbgm storage="Mysterious_Warehouse_District.mp3"]
[clearfix]
[cm]

[iscript]

tf.page              = 0   // ページ番号
tf.selected_cg_image = []  // 選択したCGの差分を格納した配列変数
tf.cg_index          = 0   // 上の配列の要素番号

tf.cg_posx = [228, 720, 1212]; // サムネイルのX座標
tf.cg_posy = [280, 562];      // サムネイルのY座標
tf.cg_thumbnail_width  = 480; // サムネイルの幅
tf.cg_thumbnail_height = 270; // サムネイルの高さ

// 前ページボタン
tf.btn_prev_pos    = [96, 498]; // x, y
tf.btn_prev_width  = 90;
tf.btn_prev_height = 120;
tf.btn_prev_img    = ["append_theme/gallery_prev.png", "append_theme/gallery_prev2.png"];

// 次ページボタン
tf.btn_next_pos    = [1734, 498]; // x, y
tf.btn_next_width  = 90;
tf.btn_next_height = 120;
tf.btn_next_img    = ["append_theme/gallery_next.png", "append_theme/gallery_next2.png"];

[endscript]

; ページネーション（ページ数が変わるときはtextの中身を修正してね）
[macro name="pagination"]
  [layopt layer="0" visible="true"]
  [free layer="0" name="pagination" time="1"]
  [ptext layer="0" name="pagination" text="&tf.page + 1 + '/5'" x="660" y="900" size="28" color="0xCC7A29" width="600" align="center"]
  [endmacro]

; 背景読込
[bg storage="../image/append_theme/bg.png" time="350" wait="false"]

; 左上の見出し（アニメーションさせたくないときは「anim_label_slide_nlp」を削除
[image name="label_gallery anim_label_slide_nlp" storage="../image/append_theme/label_gallery.png" layer="0" x="0" y="0" visible="true" time="350" wait="false"]


[jump target=*cgpage]

;-----------------------------------------------------------
*cgpage
;-----------------------------------------------------------
[cm]

; ギャラリーモード終了（ホバーアニメーションさせたくないときは「name="back_btn"」を削除）
[button name="back_btn" graphic="append_theme/gallery_close.png" enterimg="append_theme/gallery_close2.png" target="*backtitle" x="1756" y="56"]

; tf.page変数を利用して個別閲覧ボタン作成ラベルにジャンプします
[jump target="& 'page_' + tf.page "]

;-------------------------------------------------------
*page_0
;-------------------------------------------------------

; CG閲覧モード画面1ページ目

; graphic には表示する画像のファイル名
; thumb にはサムネイルとして表示する画像のファイル名（記述がなければgraphicのファイルを指定）

; 一段目
[cg_image_button graphic="house_front.png" thumb="house_front.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="dining.png" thumb="dining.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="living.png" thumb="living.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 二段目
[cg_image_button graphic="house.png" thumb="house.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="rainy_day.png" thumb="rainy_day.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="myroom.png" thumb="myroom.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 次ページへ（アニメーションさせたくないときは「name="anim_arrow_right_lp"」を削除）
[button name="anim_arrow_right_lp" graphic="&tf.btn_next_img[0]" enterimg="&tf.btn_next_img[1]" target="*nextpage" x="&tf.btn_next_pos[0]" y="&tf.btn_next_pos[1]"]

; ページネーション
[pagination]

; 共通処理にジャンプ
[jump target=*common]

;-------------------------------------------------------
*page_1
;-------------------------------------------------------
; CG閲覧モード画面2ページ目

; 一段目
[cg_image_button graphic="living.png" thumb="living.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="book_open.png" thumb="book_open.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="iseki.png" thumb="iseki.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 二段目
[cg_image_button graphic="magic_town.png" thumb="magic_town.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="myroom2.png" thumb="myroom2.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="office_room.png" thumb="office_room.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]


; 前のページへ（アニメーションさせたくないときは「name="anim_arrow_left_lp"」を削除）
[button name="anim_arrow_left_lp" graphic="&tf.btn_prev_img[0]" enterimg="&tf.btn_prev_img[1]" target="*backpage" x="&tf.btn_prev_pos[0]" y="&tf.btn_prev_pos[1]"]

; 次ページへ（アニメーションさせたくないときは「name="anim_arrow_right_lp"」を削除）
[button name="anim_arrow_right_lp" graphic="&tf.btn_next_img[0]" enterimg="&tf.btn_next_img[1]" target="*nextpage" x="&tf.btn_next_pos[0]" y="&tf.btn_next_pos[1]"]

[pagination]

; 共通処理にジャンプ
[jump target=*common]

;-------------------------------------------------------
*page_2
;-------------------------------------------------------
; CG閲覧モード画面3ページ目

; 一段目
[cg_image_button graphic="world_map.png" thumb="world_map.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="alone_town.png" thumb="alone_town.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="trable.png" thumb="trable.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 二段目
[cg_image_button graphic="value_town.png" thumb="value_town.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="book_store.png" thumb="book_store.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="atorie_a.png" thumb="atorie_a.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 前のページへ（アニメーションさせたくないときは「name="anim_arrow_left_lp"」を削除）
[button name="anim_arrow_left_lp" graphic="&tf.btn_prev_img[0]" enterimg="&tf.btn_prev_img[1]" target="*backpage" x="&tf.btn_prev_pos[0]" y="&tf.btn_prev_pos[1]"]

; 次ページへ（アニメーションさせたくないときは「name="anim_arrow_right_lp"」を削除）
[button name="anim_arrow_right_lp" graphic="&tf.btn_next_img[0]" enterimg="&tf.btn_next_img[1]" target="*nextpage" x="&tf.btn_next_pos[0]" y="&tf.btn_next_pos[1]"]

[pagination]

; 共通処理にジャンプ
[jump target=*common]

;-------------------------------------------------------
*page_3
;-------------------------------------------------------
; CG閲覧モード画面3ページ目

; 一段目
[cg_image_button graphic="koubou.png" thumb="koubou.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="musium.png" thumb="musium.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="kokoro_kairou.png" thumb="kokoro_kairou.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 二段目
[cg_image_button graphic="memory_child.png" thumb="memory_child.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="memory_child2.png" thumb="memory_child2.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="artist_memory.png" thumb="artist_memory.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 前のページへ（アニメーションさせたくないときは「name="anim_arrow_left_lp"」を削除）
[button name="anim_arrow_left_lp" graphic="&tf.btn_prev_img[0]" enterimg="&tf.btn_prev_img[1]" target="*backpage" x="&tf.btn_prev_pos[0]" y="&tf.btn_prev_pos[1]"]

; 次ページへ（アニメーションさせたくないときは「name="anim_arrow_right_lp"」を削除）
[button name="anim_arrow_right_lp" graphic="&tf.btn_next_img[0]" enterimg="&tf.btn_next_img[1]" target="*nextpage" x="&tf.btn_next_pos[0]" y="&tf.btn_next_pos[1]"]

[pagination]

; 共通処理にジャンプ
[jump target=*common]

;-------------------------------------------------------
*page_4
;-------------------------------------------------------
; CG閲覧モード画面3ページ目

; 一段目
[cg_image_button graphic="garden.png" thumb="garden.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="extra1.png" thumb="extra1.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="extra2.png" thumb="extra3.png" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[0]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 二段目
[cg_image_button graphic="" thumb="" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[0]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="" thumb="" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[1]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]
[cg_image_button graphic="" thumb="" no_graphic="../image/append_theme/lock.png" x="&tf.cg_posx[2]" y="&tf.cg_posy[1]" width="&tf.cg_thumbnail_width" height="&tf.cg_thumbnail_height"]

; 前のページへ（アニメーションさせたくないときは「name="anim_arrow_left_lp"」を削除）
[button name="anim_arrow_left_lp" graphic="&tf.btn_prev_img[0]" enterimg="&tf.btn_prev_img[1]" target="*backpage" x="&tf.btn_prev_pos[0]" y="&tf.btn_prev_pos[1]"]

[pagination]

; 共通処理にジャンプ
[jump target=*common]

;-------------------------------------------------------
*common
;-------------------------------------------------------

; 停止
[s]


;-----------------------------------------------------------
*backtitle
;-----------------------------------------------------------
; タイトルに戻る処理

; 使用したレイヤーをすべて消去
[cm]
[freeimage layer=0]
[freeimage layer=1]

; 別のシナリオにジャンプする場合はここを変更
[jump storage=title.ks]


;-----------------------------------------------------------
*nextpage
;-----------------------------------------------------------
; 次のページに移る処理

; 一時変数 tf.page を増加させたうえで *cgpage へ
[eval exp=tf.page++]
[jump target=*cgpage]

;-----------------------------------------------------------
*backpage
;-----------------------------------------------------------
; 前のページに移る処理

; 一時変数 tf.page を減少させたうえで *cgpage へ
[eval exp=tf.page--]
[jump target=*cgpage]

;-----------------------------------------------------------
*no_image
;-----------------------------------------------------------
; 未解放のCGをクリックしたときの処理
[jump target=*cgpage]

;-----------------------------------------------------------
*clickcg
;-----------------------------------------------------------
; 解放済みのCGをクリックしたときの処理

; フリーレイヤーとレイヤー１(back)を解放します
[cm]
[freeimage layer=1 page=back]

; 一時変数 tf.cg_index に 0 をぶち込みます
[eval exp="tf.cg_index = 0"]

;-------------------------------------------------------
*cg_next_image
;-------------------------------------------------------
; CGを見ていきます。
; 見るべきCGがひとつしかない場合は、それだけ見たあと *cgpage に戻ります。
; 見るべきCGが複数ある場合(差分がある場合)は、
; 再帰的にこのラベルに飛び直して次のCGを見ていきます。

; 一時変数 tf.storage に表示すべきCGのstorageを代入します
[iscript]
tf.storage = tf.selected_cg_image[tf.cg_index];
[endscript]

; CGを表示してクリックを待ちます。
[freeimage layer=1 page=back]
[image     layer=1 page=back storage=&tf.storage folder=bgimage width=1280 height=720 top="170" left="350" ]
[trans     layer=1 time=700]
[wt]
[l]

; クリックされたら
; 一時変数 tf.cg_index (差分画像がある場合の画像番号)を1増加させます。
[eval exp=tf.cg_index++]

; まだ表示すべき差分画像が残っているなら、このラベルに飛びなおします。
[if exp=" tf.selected_cg_image.length > tf.cg_index "]
  [jump target=cg_next_image]

[else]
  [freeimage layer=1 page=back]
  [freeimage layer=1 page=fore time=700]
  [jump target=*cgpage]

[endif]
