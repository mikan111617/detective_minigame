;=========================================
; シーン：ノーマルエンド「霧の中の明日」
;=========================================
*normal_end
@clearstack
;----------------------------------------------------------
; 既に見たことのあるエンディングなら、スタッフロールまで飛ばせる
;----------------------------------------------------------
[iscript]
tf.ending_seen = (window.ACH && window.ACH.has("end_normal")) ? 1 : 0;
[endscript]
[if exp="tf.ending_seen == 1"]
[cm]
[clearfix]
[free_layer_image]
[position layer="message0" page=fore visible=true]
[bg storage="dark.png" time=600]
#
このエンディングは一度見ています。[p]
#
スタッフロールまで飛ばしますか？[p]

[glink color="bth13_dk" text="このまま読む"           target="*normal_end_read"]
[glink color="bth13_dk" text="スタッフロールまで飛ばす" target="*normal_end_skip"]
[s]
[endif]

*normal_end_read

; 背景：共同寝室（または客室）
[mask time=1000]
[cm]
[clearfix]
[showmenubutton]
; 後日譚なので場所名と時刻は出さない
[hud_hide]
[free_layer_image]
[bg storage="room_mashiro_night.png" time=0]
[position layer="message0" page=fore visible=true]
[playbgm storage="seeking_warmth.mp3"]
[mask_off time=1000]

; 和人の登場（一人なので num=0）
[charapos name="kazuto" face="thinking" num="0"]

#
和人は、珠璃から聞いた植物の特徴をもとに毒物を特定した。[r]
#
共同寝室では、和人が慎重に薬を調合していた。[p]

#kazuto
[voice id="v03230"]
これで、すぐに命を落とすということはないだろう。[p]

#
和人が愛理に薬を飲ませると愛理の様子が先ほどよりも落ち着き、呼吸が安定してきた。[p]

#kazuto
[voice id="v03231"]
ただし、できたのは応急処置だ。[p]
#kazuto
[voice id="v03232"]
すぐに病院へ運んだほうがいい。解毒剤の投与が必要だ。[p]

*return_normal

; true_end の推理に失敗してここへ飛んできた場合も、後日譚なので出さない
[hud_hide]

; 警部へ切り替え
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v03233"]
救急車の到着はどうか？[p]

#警察
まだのようです。[p]

#reido
[voice id="v03234"]
救急車が到着し次第、被害者を搬送できるように1階にお連れするんだ。[p]
#reido
[voice id="v03235"]
誘導班も外で待機するように伝えろ。[p]

#警察
了解です。[p]

[chara_hide_all]

[bg storage="event/airi_painful.png"]

; 真歩流と愛理の会話（画面にはキャラを表示せずメッセージのみ）
[message_chara name="mahoru" face="cry"]

#mahoru
[voice id="v03236"]
愛理……もう少しの辛抱だよ。[p]

[reset_message_chara]

#airi
[voice id="v03237"]
ハア……ハア……。[p]

#airi
[voice id="v03238"]
ありがとう……。[p]

[message_chara name="mahoru" face="normal"]

#mahoru
[voice id="v03239"]
うん。[p]

#mahoru
[voice id="v03240"]
何があってもお姉ちゃんがついているからね！[p]

[reset_message_chara]
#
その後、救急車が到着し、愛理はストレッチャーに乗せられて病院へ搬送された。[r]
#
私も付き添い、愛理の震える手を必死に握りしめていた。[p]

; 暗転
[mask time=1000]
[bg storage="dark.png" time=0]
[chara_hide_all]
[reset_message_chara]
[mask_off time=1000]

#
病院での治療は――ぎりぎりで間に合った。[r]
#
和人の応急処置と、珠璃から得た情報が愛理の命を救ったのだった。[p]

#医師
毒の影響でしばらく入院が必要になります。[p]

#医師
安心してください。後遺症などもなく元の状態に戻れますから。[p]

; ==== 映画字幕風テキスト ====
[keyframe name="cine_in"]
[frame p=0 opacity=0 y=20]
[frame p=100 opacity=255 y=0]
[endkeyframe]
[ptext layer="1" page="fore" name="cine_txt" text="それから、三か月後。" x=0 y=350 width=1920 align="center" size=36 color="0xECE3D1" face="serif"]
[kanim name="cine_txt" keyframe="cine_in" time=1400 easing="ease-out" count=1 mode="forwards"]
[wait time=1600]

; --- 消去する場合 ---
[free layer="1" name="cine_txt"]

; 背景：病院の病室
[bg storage="hospital.png" time=1000]

#
真歩流は毎日病院へ通い続けた。[r]
#
愛理はすぐに元気になったが、入院生活は長かった。[p]

#
長い間毒が体を回っていたので、体の機能が回復するのに時間がかかってしまったのだ。[p]
#
真歩流は一日たりとも愛理の傍を離れなかった。[p]
#
その間、零度警部からは事件の後日談が届いた。[p]

#
珠璃は逮捕後、長い事情聴取を受けていた。[p]
#
夫を――意図的ではないにしろ――死なせてしまった事実は、彼女に重くのしかかっていたという。[p]
#
真歩流が最後に放った言葉は、珠璃の心を冷静に戻したらしい。[p]

#
和人は毒物の知識を理由に任意同行を求められた。[r]
大学でも、緊急事態とはいえ医師免許のない学生が処置にあたったことを問題視されたという。[p]
#
彼は別の医療大学へ籍を移して、その後の動向は誰も知らない。[p]

#
メアリーは事件のあと、ふっと霞のように姿を消した。[r]
#
それ以来、一度も消息は掴めていないという。[p]
#
日本から出国したという記録はないため、未だに親戚を探しているのだろうか。[p]

#
朱志香は事件の後、舞黒館の管理を他人に任せ、人知れず姿を消したという。[p]
#
今はどこで何をしているのか、誰も知らない。[p]

#
そして――。[p]
父・真白奢禄は、まだ見つかっていなかった。[r]
#
零度警部が捜索を続けてくれていたが、有力な情報は一つとして得られなかった。[p]

#
そして、事件から三か月後の今日。[r]
#
愛理はようやく回復し、医師から「完治」と言われた。[p]
退院の日。[r]
#
病院の玄関で、愛理はそっと微笑んだ。[p]

; 愛理のみ表示（真歩流はメッセージウィンドウ）
[charapos name="airi" face="smile" num="0"]

#airi
[voice id="v03241"]
お姉ちゃん、ありがとう。毎日来てくれて。[p]

[message_chara name="mahoru" face="shihuku"]
#mahoru
[voice id="v03242"]
当たり前でしょ。愛理は、私の大切な妹なんだから。[p]

#mahoru
[voice id="v03243"]
一緒にお父さんをまた探そう！[p]

[chara_mod name="airi" face="normal"]

#airi
[voice id="v03244"]
うん！[p]

#
二人はゆっくりと歩き出した。[p]

; モノローグ調
[chara_hide_all]
[reset_message_chara]
[layopt layer=message0 visible=true]

#
真歩流と愛理は、今日も歩き続ける。[p]
#
父は、どこかで生きている。[p]
#
二人はそう信じている――。[p]

; エンディングクレジットへ
*normal_end_skip
[eval exp="f.badend = 0"]
[eval exp="f.trueend = 0"]
[eval exp="f.normalend = 1"]
[cm]
[clearfix]
[free_layer_image]
[jump storage="system/ending_credit.ks" target="*ending_credits"]
