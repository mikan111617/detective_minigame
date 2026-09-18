;=========================================
; scene2.ks 庭園での歓談とお茶会準備
;=========================================

*start

;========================================
; 庭園での歓談（導入）
;========================================
@clearstack
[freeimage layer="1"]
[clearfix]
[cm]
[show_menu]
[bg storage="garden.png" time=1000]
[playbgm storage="Lovely_Garden.mp3"]

; UI表示（現在地・時刻）
; ※ f.game_time は scene1 の末尾で 14:00（840分）になっている
[gage_draw place="メイフェア・ガーデン"]

; --- 変数初期化 ---
[iscript]
f.talked_couple    = 0;
f.talked_jushika   = 0;
f.talked_kazuto    = 0;
f.talked_koderia   = 0;
f.talked_mary      = 0;
f.checked_monument = 0;
f.walked_around    = 0;
f.group_photo      = 0;   // 庭園での記念撮影を撮ったか

// 経路フラグ。「周辺を散策する」を早い順番（1〜2番目）で選ぶと 1 になる。
// 叡留久と和人がその場で散歩へ出てしまい、和人がサンルームへ戻る時刻が早まる。
// 結果として珠璃は鉢を使えず、犯行の手口が変わる（scene3 / scene6 / scene8）。
f.route_b = 0;
[endscript]

;========================================
; 記念撮影
;   全員が庭に出そろった、この一度きりの時間。
;   ここで撮る一枚が、真エンドのクレジットで戻ってくる。
;   時間は進めない（庭園の自由行動は 14:00 から 5 回ぶん確保する）。
;========================================
; ▼ 以下、新規会話は要ボイス収録
[chara_hide_all]
[charapos name="koderia" face="smile" num="0"]

#
館の裏手にある美しい西洋式庭園に出ると、参加者が思い思いに散らばりはじめた。[p]

#koderia
[voice id="v03766"]
皆様。お茶会の前に、よろしければ一枚いかがでしょうか。[p]

#koderia
[voice id="v03767"]
このお庭で撮った写真を、館の記録として残しているのです。[p]

[chara_hide_all]
[charapos name="jushika" face="smile" num="1"]
[charapos name="koderia" face="smile" num="2"]

#jushika
[voice id="v03768"]
ええ、ぜひ。皆さん、こちらへどうぞ。[p]

#
小出里亜が芝の上に三脚を立て、慣れた手つきでタイマーを合わせる。[p]

[chara_hide_all]
[charapos name="airi" face="stunned" num="0"]

#airi
[voice id="v03769"]
……お姉ちゃん。その帽子、脱いだら？[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03770"]
脱がないわよ。これは正装なんだから。[p]
[reset_message_chara]

#airi
[voice id="v03771"]
一生残るのに。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03772"]
一生残るからよ。[p]
[reset_message_chara]

#
愛理は諦めたように笑って、私の隣に並んだ。[p]

[chara_hide_all]

#
八人が肩を寄せ合う。[r]
#
小出里亜が焼いたばかりのクッキーの皿を抱え、真ん中で笑っている。[p]

#koderia
[voice id="v03773"]
それでは——参ります。[p]

[playse storage="decide.mp3" volume=70]
[wait time=300]

[mask time=200 effect="fadeIn" color="0xFFFFFF"]
[gage_draw place="メイフェア・ガーデン"]
[mask_off time=900]

#
——秋の午後の光が、そこにいた全員を等しく照らしていた。[p]

[mask time=600]
[bg storage="garden.png" time=0]
[gage_draw place="メイフェア・ガーデン"]
[mask_off time=600]

#
撮り終えると、参加者たちはまた思い思いに庭へ散っていった。[p]

[eval exp="f.group_photo = 1"]

;========================================
; 和人と小出里亜
;========================================
[chara_hide_all]
[charapos name="kazuto" face="normal" num="1"]
[charapos name="koderia" face="normal" num="2"]

#
少し離れた場所で、二人の人物が話し込んでいるのが見えた。[p]
#
医大生の和人と、メイドの小出里亜だ。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v00001"]
#koderia
あの……徐音様。私たち、以前どこかでお会いしたことはありませんか？[p]
[voice id="v00002"]
#koderia
なんだか、とても懐かしい気がして……。[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v00003"]
#kazuto
……いや。人違いだろう。[p]
[voice id="v00004"]
#kazuto
俺は、会った覚えはない。[p]

#
和人はぶっきら棒に言った。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00005"]
#mahoru
ちょっと和人、そんなに冷たくしなくても。[p]
[voice id="v00006"]
#mahoru
小出里亜さんのこと、もっと、よく思い出してみたらどう？[p]
[reset_message_chara]

[chara_mod name="kazuto" face="look_away"]
#kazuto
[voice id="v00007"]
#kazuto
思い出すも何もない。俺は物心ついてから家族以外と一緒にいたことがない。[p]
[voice id="v00008"]
#kazuto
……その家族すら、もういないがな。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00009"]
#mahoru
え……？ それって、どういう……。[p]
[reset_message_chara]

#kazuto
[voice id="v00010"]
#kazuto
お前に話す筋合いはない。[p]

#
和人はそれだけ言い捨てて、足早に花壇の方へと歩き去ってしまった。[p]

[chara_hide name="kazuto"]

; ※koderiaにthinkingが定義されていないためnormalを使用
[chara_mod name="koderia" face="normal"]

#koderia
[voice id="v00011"]
#koderia
ありがとうございます、真白様。[p]
[voice id="v00012"]
#koderia
やっぱり私の気のせいだったのかもしれません。[p]
[voice id="v00013"]
#koderia
徐音様に謝ってまいりますね。[p]

[chara_hide name="koderia"]

#
小出里亜も和人を追うようにしてその場を離れた。[p]

[charapos name="airi" face="thinking" num="0"]

#airi
[voice id="v00014"]
#airi
なんだか、ピリピリしてるね……。[p]
[voice id="v00015"]
#airi
私たちも、お茶会の準備ができるまで少し庭を見て回ろうか。[p]

[chara_hide_all]

;========================================
; 庭園・自由行動パート開始
;========================================

*garden_explore_loop
[clearfix]
[chara_hide_all]
[reset_message_chara]
[hidemenubutton]
[cm]

; 時刻表示を更新
[gage_draw place="メイフェア・ガーデン"]

; 選択画面は全面のオーバーレイになるので、資料ボタンは一旦片付ける
; （場所名・時刻のプレートは layer1 なので残る）
[clearfix]

; 14:55（895分）に到達したら庭園フェーズ終了
[jump cond="f.game_time >= 895" target="*garden_end"]

;-----------------------------------------------------------
; 選択肢の生成
;   chara に指定した名前の立ち絵（fgimage/standing/<名前>.png）が
;   選択中の項目に合わせて左側に表示される
;-----------------------------------------------------------
[iscript]
tf.choices = [];
if(f.talked_couple    == 0){ tf.choices.push({target:'*talk_couple',    text:'景色を見ている叡留久夫妻',   kind:'talk', chara:['eruku','juri']}); }
if(f.talked_jushika   == 0){ tf.choices.push({target:'*talk_jushika',   text:'サンルームの壁を見る朱志香', kind:'talk', chara:['jushika']}); }
if(f.talked_kazuto    == 0){ tf.choices.push({target:'*talk_kazuto',    text:'花壇を見つめる和人',         kind:'talk', chara:['kazuto']}); }
if(f.talked_koderia   == 0){ tf.choices.push({target:'*talk_koderia',   text:'戻ってきた小出里亜',         kind:'talk', chara:['koderia']}); }
if(f.talked_mary      == 0){ tf.choices.push({target:'*talk_mary',      text:'庭を散策するメアリー',       kind:'talk', chara:['mary']}); }
if(f.checked_monument == 0){ tf.choices.push({target:'*check_monument', text:'庭の隅を調べる',             kind:'look', name:'庭の隅'}); }
if(f.walked_around    == 0){ tf.choices.push({target:'*walk_around',    text:'周辺を散策する',             kind:'move', name:'舞黒館 周辺'}); }
[endscript]

; 全選択肢が消えていたら強制終了
[jump cond="tf.choices.length == 0" target="*garden_end"]

; 全選択肢を1画面に表示（ページ送りなし）
[stand_select storage="scene2.ks" se="decide.mp3" prompt="さて、どこを見て回ろうか……。<br>（お茶会は15時半の予定。まだ少し時間がありそうだ）"]


;========================================
; 若夫婦との会話（薬の事業とSNS）
;========================================
*talk_couple
; この会話で 11分 経過（14:00開始なら累積時刻が進む）
[advance_time min=11]
[eval exp="f.talked_couple = 1"]
[gage_draw place="メイフェア・ガーデン"]
[show_menu]

[charapos name="eruku" face="normal" num="1" wait="false"]
[charapos name="juri" face="smile" num="2" wait="false"]

#
穂在呂夫妻は庭の景色を眺めながら、楽しそうに談笑していた。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00016"]
#mahoru
こんにちは。すごく楽しそうですね！[p]
[reset_message_chara]

#eruku
[voice id="v00017"]
#eruku
やあ、君たちも楽しんでいるかい？[p]

#eruku
[voice id="v00018"]
#eruku
仕事の良いリフレッシュになるよ！[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00019"]
#mahoru
仕事って何をしているんですか？[p]
[reset_message_chara]

#eruku
[voice id="v00020"]
#eruku
今は健康食品を扱った事業をしているんだ。[p]

#eruku
[voice id="v00021"]
#eruku
しかも、独立してから仕事が順調でね。最近、新しく薬の事業も始めたんだ。[p]

[message_chara name="airi" face="normal"]
#airi
[voice id="v00022"]
#airi
薬の事業、ですか？[p]
#airi
[voice id="v00023"]
#airi
なんか難しそう。[p]
[reset_message_chara]

#
いつ頃から始めたのかを尋ねると、叡留久は指を折って数える仕草をした。[p]

#eruku
[voice id="v00024"]
#eruku
2か月ほど前かな。知り合いからアドバイスをもらってね。[p]

[voice id="v00025"]
#eruku
それに、妻の珠璃がサポートしてくれているおかげで喜ばしい限りだよ。[p]

[chara_mod name="juri" face="smile"]
#juri
[voice id="v00026"]
#juri
ふふ、大したことはしていないわ。[p]
[voice id="v00027"]
#juri
私がSNSを通じて、特殊な薬学の書籍を集めたの。[p]
[voice id="v00028"]
#juri
そこから得た知識やトレンドを分析して、事業で扱うものを決めたのよ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00029"]
#mahoru
SNSで本を集めるって、凄いですね！[p]
[reset_message_chara]

#juri
[voice id="v00030"]
#juri
私も個人でデザインしたブランド商品を販売するために、SNSでマーケティングをしているの。[p]
[voice id="v00031"]
#juri
だから、事業以外でも普段からよくSNSを活用してるわ。[p]

#
珠璃がそう言った瞬間、叡留久の顔が一瞬だけサッと曇った。[p]

[chara_mod name="eruku" face="thinking"]
#eruku
[voice id="v00032"]
#eruku
あ、ああ……そうだな。SNSは便利だからな……。[p]

[message_chara name="airi" face="thinking"]
#airi
[voice id="v00033"]
#airi
（……？ 顔合わせの時も驚いていたし、SNSに何か思うところがあるのかな？）[p]
[reset_message_chara]

; 珠璃が普段からSNSをよく使うと分かった
[set_item_status id="chara_06" secret="true"]
[get_item id="chara_06" type="info"]

[chara_hide_all]
[jump target="*garden_explore_loop"]


;========================================
; 管理者との会話（買収とバブル）
;========================================
*talk_jushika
; この会話で 11分 経過
[advance_time min=11]
[eval exp="f.talked_jushika = 1"]
[gage_draw place="メイフェア・ガーデン"]
[show_menu]
[charapos name="jushika" face="normal" num="0" wait="false"]

#
朱志香はサンルームの外壁の補修跡を、じっと見つめていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00034"]
#mahoru
朱志香さん、どうかしたんですか？[p]
[reset_message_chara]

#jushika
[voice id="v00035"]
#jushika
いえ、補修跡を見て、少し昔を思い出しましてね。[p]
[voice id="v00036"]
#jushika
私の夫である富礼知が突然この洋館を購入すると言ってきたときは驚きました。[p]

[message_chara name="airi" face="normal"]
#airi
[voice id="v00037"]
#airi
旦那さんはよほど好きだったんですね。[p]
[reset_message_chara]

#jushika
[voice id="v00038"]
#jushika
それもありますが、夫の家は元々資産家だったのです。[p]
[voice id="v00039"]
#jushika
けれど、バブル崩壊により、財産のほとんどを失ってしまって。[p]
[voice id="v00040"]
#jushika
挽回のために地価が上がりそうな土地を買い上げていて、ここもその一つです。[p]

[chara_mod name="jushika" face="thinking"]
#
淡々と語る朱志香の表情は少し暗かった。[p]

[message_chara name="airi" face="thinking"]
#airi
[voice id="v00041"]
#airi
あの……何か、辛いことでもあったんですか？[p]
[reset_message_chara]

[chara_mod name="jushika" face="normal"]

#jushika
[voice id="v00042"]
#jushika
……いえ。[p]
[voice id="v00043"]
#jushika
亡き夫のことを思い出しただけです。お気になさらず。[p]

[chara_hide_all]
[jump target="*garden_explore_loop"]


;========================================
; 和人との会話（植物と毒）
;========================================
*talk_kazuto
; この会話で 11分 経過
[advance_time min=11]
[eval exp="f.talked_kazuto = 1"]
[gage_draw place="メイフェア・ガーデン"]
[show_menu]
[charapos name="kazuto" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00044"]
#mahoru
和人。[p]
[voice id="v00045"]
#mahoru
さっきの「家族がもういない」って、どういう……。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="look_away"]
#kazuto
[voice id="v00046"]
#kazuto
……お前に話す気はないと言ったはずだ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00047"]
#mahoru
うっ……。[p]
[voice id="v00048"]
#mahoru
あ、あのさ、この庭の植物すごく綺麗だよね！[p]
[voice id="v00049"]
#mahoru
香りもいいし。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v00050"]
#kazuto
綺麗か。[p]
[voice id="v00051"]
#kazuto
見かけはそうかもしれないが、ここにある植物も使い方次第で毒になるものもある。[p]

[message_chara name="airi" face="normal"]
#airi
[voice id="v00052"]
#airi
毒のある植物が植えてあるんですか？[p]
[reset_message_chara]

#kazuto
[voice id="v00053"]
#kazuto
有毒というわけじゃないがな。[p]
[voice id="v00054"]
#kazuto
使い方次第で毒にもなるってことさ。[p]
[voice id="v00055"]
#kazuto
薬の原料になるものも多いが、扱いを間違えれば最悪命に関わる。[p]
[voice id="v00056"]
#kazuto
例えば、あそこにある……。[p]

#
和人は何かを指さそうとしたが、すぐに口をつぐんだ。[p]

#kazuto
[voice id="v00057"]
#kazuto
……いや、なんでもない。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00058"]
#mahoru
和人って、本当に植物に詳しいんだね！[p]
[reset_message_chara]

#kazuto
[voice id="v00059"]
#kazuto
……医大生なら当然の知識だ。[p]
[voice id="v00060"]
#kazuto
用がないならもういいだろう。[p]

[chara_hide_all]
[jump target="*garden_explore_loop"]


;========================================
; メイドとの会話（二面性と恋愛）
;========================================
*talk_koderia
; この会話で 11分 経過
[advance_time min=11]
[eval exp="f.talked_koderia = 1"]
[gage_draw place="メイフェア・ガーデン"]
[show_menu]
[charapos name="koderia" face="smile" num="0" wait="false"]

#
小出里亜がホッとした様子で戻ってきた。[p]

#koderia
[voice id="v00061"]
#koderia
徐音様に謝罪できて、安心しました……。[p]

[message_chara name="airi" face="normal"]
#airi
[voice id="v00062"]
#airi
小出里亜さんは、どうしてメイドさんになったんですか？[p]
[reset_message_chara]

#koderia
[voice id="v00063"]
#koderia
私、家事が得意なんです。掃除も料理もなんでもこなせますから。[p]
[voice id="v00064"]
#koderia
それに、この横浜山手の雰囲気が大好きなのも理由の一つですね。[p]

[chara_mod name="koderia" face="normal"]
#koderia
[voice id="v00065"]
#koderia
実は私、両親は義理の親で、本当の両親がどこにいるのか分からないんです。[p]

[voice id="v00066"]
#koderia
けど、この街にいると懐かしい感じがして。[p]

[voice id="v00067"]
#koderia
もしかしたら、昔住んでいたことがあるんじゃないかって。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00068"]
#mahoru
そうだったんですね……。[p]

[voice id="v00069"]
#mahoru
今でも、本当のご両親に、会いたいですか？[p]
[reset_message_chara]

[chara_mod name="koderia" face="smile"]
#koderia
[voice id="v00070"]
#koderia
……ええ、もちろん会いたいです。[p]

#koderia
[voice id="v00071"]
#koderia
……ところで！ お二人は恋愛とかしているんですか？[p]

[message_chara name="airi" face="smile"]
#airi
[voice id="v00072"]
#airi
恋愛はまだなんですけど、すごく憧れるんです……。[p]

[voice id="v00073"]
#airi
早くしてみたいんです！[p]

[reset_message_chara]

#koderia
[voice id="v00074"]
#koderia
恋愛はいいですよ！[p]
[voice id="v00075"]
#koderia
胸が熱くなって、頭の中はいつも相手のことでいっぱいになって。[p]
[voice id="v00076"]
#koderia
私も恋愛が大好きで、これまで数え切れないくらいの人に想いを馳せてきました。[p]
[voice id="v00077"]
#koderia
今もね、気になっている人がいて……その人を本気にさせるために、色々と手を尽くしているところなんです。[p]

[message_chara name="airi" face="smile"]
#airi
[voice id="v00078"]
#airi
いいなあ……。[p]

[voice id="v00079"]
#airi
私たちも早く恋愛したいね、お姉ちゃん！[p]

[reset_message_chara]

[message_chara name="mahoru" face="aho"]
#mahoru

[voice id="v00080"]
#mahoru
ウンソウダネ。[p]

[reset_message_chara]

[chara_hide_all]
[jump target="*garden_explore_loop"]


;========================================
; メアリーとの会話（悲恋の伝承）
;========================================
*talk_mary
; この会話で 11分 経過
[advance_time min=11]
[eval exp="f.talked_mary = 1"]
[gage_draw place="メイフェア・ガーデン"]
[show_menu]

[charapos name="mary" face="normal" num="0" wait="false"]

#
メアリーは庭の景色を懐かしむように眺めていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00081"]
#mahoru
メアリーさんは、どうしてこの宿泊イベントに参加したんですか？[p]
[reset_message_chara]

#mary
[voice id="v00082"]
#mary
私の祖母が舞黒館に行ったことがあると話していて……ずっと気になっていたんです。[p]

[message_chara name="mahoru" face="smile"]

#mahoru
[voice id="v00083"]
#mahoru
へえ！ そうなんですね！[p]
[reset_message_chara]

[chara_mod name="mary" face="smile"]
#mary
[voice id="v00084"]
#mary
実は先ほど拾ってくれたペンダントは祖母からもらったものなんですよ。[p]
[voice id="v00085"]
#mary
約80年前のものだそうです。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v00086"]
#mahoru
80年前のペンダント！[p]
[voice id="v00087"]
#mahoru
すごいねえ、歴史があるねえ！[p]
[reset_message_chara]

#mary
[voice id="v00088"]
#mary
ふふ、そうですね。[p]
[voice id="v00089"]
#mary
祖母からは、舞黒館であった恋の話も聞いています。[p]

[message_chara name="airi" face="smile"]
#airi
[voice id="v00090"]
#airi
え、恋ですか……！[p]
[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v00091"]
#mary
昔、この舞黒館で働いていた日本人女性と、イギリス人の男性が恋に落ちました。[p]
[voice id="v00092"]
#mary
二人は深く愛し合っていましたが……第二次世界大戦が始まり、引き裂かれてしまったのです。[p]

[message_chara name="airi" face="cry"]
#airi
[voice id="v00094"]
#airi
うう、悲しい恋……。[p]

[voice id="v00095"]
#airi
でも、たとえ会えなくても二人の想いは通じていたよね。[p]

[voice id="v00096"]
#airi
そうだよね、お姉ちゃん！[p]

[reset_message_chara]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00097"]
#mahoru
うん。[p]

[voice id="v00098"]
#mahoru
だって、地球は繋がっているんだから！[p]

[reset_message_chara]

[message_chara name="airi" face="anger"]
#airi
[voice id="v00099"]
#airi
そういうことじゃない！！[p]

@reset_message_chara

#mary
[voice id="v00100"]
#mary
……。[p]

[chara_hide_all]
[jump target="*garden_explore_loop"]


;========================================
; 庭の隅を調べる（石碑）
;========================================
*check_monument
; 石碑の調査で 11分 経過
[advance_time min=11]
[eval exp="f.checked_monument = 1"]
[gage_draw place="メイフェア・ガーデン"]
[show_menu]
[charapos name="airi" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00101"]
#mahoru
わあ、ここの庭園、本当にきれいだね！[p]

[voice id="v03774"]
ハーブのいい香りもするし！[p]

[reset_message_chara]

#airi
[voice id="v00102"]
#airi
うん、綺麗……。ん？ お姉ちゃん、あそこ見て。[p]

#
愛理が指さした庭の隅に、古びた石碑のようなものがあった。[p]
#
表面には、薄く詩の一節が刻まれている。[p]

#airi
[voice id="v00103"]
#airi
『海の向こうのかの地から　感じているのはあなたのぬくもり』[p]
[voice id="v00104"]
#airi
『決して消えることのない想いを　静かに載せる』[p]

[if exp="f.talked_mary == 1"]
[chara_mod name="airi" face="thinking"]
#airi
[voice id="v00105"]
#airi
（……さっきメアリーさんが言っていた、日本人女性とイギリス人の恋……あれと関係があるのかな？）[p]
[voice id="v00106"]
#airi
（でも、どうしてこんな石碑が置かれているんだろう……？）[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00107"]
#mahoru
愛理、どうしたの？ 難しい顔して。[p]
[reset_message_chara]

#airi
[voice id="v00108"]
#airi
ううん。何でもないよ。[p]

#
[endif]

[get_item id="statue"]
[iscript]
// 石碑解放
f.status["statue"].owned  = true;
[endscript]
[eval exp="f.item_monument = 1"]

[jump target="*garden_explore_loop"]


;========================================
; 周辺を散策する
;========================================
*walk_around
; ここへ来た時点の時刻で経路が決まる。
;   14:11（1番目）／14:22（2番目）に散策した＝まだ日が高いうちに戻ってくるので、
;   叡留久と和人は「後で」ではなくその場で散歩へ出る＝経路B。
;   14:33 以降なら現行どおり、二人は庭園パートの終わりに出発する＝経路A。
[eval exp="f.route_b = (f.game_time <= 851) ? 1 : 0"]

; 散策で 11分 経過
[advance_time min=11]
[eval exp="f.walked_around = 1"]
[gage_draw place="舞黒館 周辺"]
[show_menu]
[charapos name="airi" face="normal" num="0" wait="false"]

#
私たちは庭園を抜け、少し周辺を散策してみることにした。[p]

@bg storage="park.png"

#airi
[voice id="v00109"]
#airi
すごく気持ちの良い公園だね。[p]

[voice id="v00110"]
#airi
さすがは有名な観光スポット。[p]

[voice id="v00111"]
#airi
推すだけのことはあるわ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00112"]
#mahoru
本当にきれい！[p]
[voice id="v00113"]
#mahoru
ねえ、あっちからなら港の方が見えるんじゃないかな。[p]
[reset_message_chara]

@bg storage="park_view.png"

@chara_mod name="airi" face="smile"

#airi
[voice id="v00114"]
#airi
うわあ、本当に良い景色だね。[p]

[voice id="v00115"]
#airi
マリンタワーも見えるし、山下公園も見えるね！[p]

#
横浜の港を一望しながら、ふと気になったものがあった。[p]

#
大さん橋に大型の船が入港していた。[p]

#
客船だが、初めて見るタイプだった。[p]


[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v00116"]
#mahoru
ねえ、愛理、あの船って知ってる？[p]

[voice id="v00117"]
#mahoru
大さん橋に停泊している。[p]
[reset_message_chara]

#airi
[voice id="v00118"]
#airi
あれは、最近話題の豪華客船だよ。[p]

[voice id="v00119"]
#airi
なんでも、世界で初めて船の中が公開されるんだって。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00120"]
#mahoru
そうなんだ！[p]

[voice id="v00121"]
#mahoru
機会があったら行ってみたいなあ。[p]
[reset_message_chara]

#
その後も軽く散歩を楽しんだ。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v00122"]
#mahoru
すっごく楽しかったね！ 横浜って本当にいいところ！[p]
[reset_message_chara]

#airi
[voice id="v00123"]
#airi
うん。そろそろ庭園に戻ろうか。[p]

[chara_hide_all]

#
庭園に戻ると、ちょうど叡留久が和人に声をかけているところだった。[p]

@bg storage="garden.png"

[charapos name="eruku" face="smile" num="1"]
[charapos name="kazuto" face="normal" num="2"]

#eruku
[voice id="v00124"]
#eruku
おかえり、外に出ていたのかい？[p]

#mahoru
@message_chara name=mahoru face=smile
[voice id="v00125"]
#mahoru
はい。外、面白かったですよ！[p]

[voice id="v00126"]
#mahoru
港の見える丘公園まで行ってきました。[p]

[voice id="v00127"]
#mahoru
船も見えました。大さん橋に、大きな客船が停まっていて。[p]

[voice id="v00128"]
#mahoru
叡留久さんたちも見たらきっと面白いですよ！[p]

@reset_message_chara

#eruku
[voice id="v00129"]
おお、いいねえ。[p]
[voice id="v00130"]
#eruku
和人君、僕たちも散歩に行かないか？[p]
[voice id="v00131"]
#eruku
ついでに話しながら君の知識、少し聞かせてもらいたくてね。[p]

#kazuto
[voice id="v00132"]
#kazuto
……構わないが。[p]

[if exp="f.route_b == 1"]
; ── 経路B：まだ時間があるので、二人はその場で出かけてしまう ──
;    ここで叡留久が告げる「戻る時刻」が、経路Aとの分かれ目そのものになる。
;    早く出るぶん早く戻るので、和人はお茶会の準備が始まる前に館へ帰り着く。
#eruku
[voice id="v00133"]
#eruku
善は急げだ。お茶会までまだ間があるし、今から行こう。[p]

[chara_mod name="kazuto" face="normal"]
#kazuto
[voice id="v00134"]
#kazuto
……せっかちだな、あんたは。[p]

; ▼ 以下、新規会話は要ボイス収録
[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03775"]
お茶会には間に合いますか？[p]
[reset_message_chara]

[chara_mod name="eruku" face="smile"]
#eruku
[voice id="v03776"]
今から出れば余裕だよ。[p]

#eruku
[voice id="v03777"]
珠璃にもそう伝えておいてくれるかい。[p]

[message_chara name="mahoru" face="smile"]
#mahoru
[voice id="v03778"]
はい、伝えておきますね。[p]
[reset_message_chara]

#
叡留久は和人の背を押すようにして、二人並んで庭の奥へと歩いていった。[p]

; 二人は庭園からいなくなるので、以降は話しかけられない
[eval exp="f.talked_kazuto = 1"]
[eval exp="f.talked_couple  = 1"]
[else]
; ── 経路A：現行どおり。二人は「後で」と言って庭園に残る ──
#eruku
[voice id="v00135"]
#eruku
そうしたら、もう少し庭園を見たいから、また後で声をかけるよ。[p]
[endif]

[chara_hide_all]
[jump target="*garden_explore_loop"]


;========================================
; 行動終了後（散歩イベント）
;========================================
*garden_end
[cm]
[gage_draw place="メイフェア・ガーデン"]
[charapos name="jushika" face="normal" num="0"]
[show_menu]

#jushika
[voice id="v00136"]
#jushika
皆様、お茶会を行いますので、どうぞ、屋敷の中へお戻りください。[p]

[chara_hide_all]

[if exp="f.route_b == 1"]
; ── 経路B：二人はとうに出かけている。その道中で交わされていた会話 ──
#
私たちは朱志香に促され、屋敷へと戻った。[p]
#
和人と叡留久はまだ戻っていなかった。[p]
[else]
; ── 経路A：ここで二人が出かける ──
;    出発が遅いぶん戻りも遅く、和人がサンルームへ帰り着くのはお茶会の直前になる。
;    経路Bとの違いは、叡留久が告げる「戻る時刻」に出ている。
; ▼ 以下、新規会話は要ボイス収録
[charapos name="eruku" face="smile" num="0"]

#eruku
[voice id="v03779"]
真白さん。僕たちはこれから少し散歩をしてくるよ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03780"]
えっ、今からですか？　お茶会、始まっちゃいますよ。[p]
[reset_message_chara]

#eruku
[voice id="v03781"]
直ぐに戻るから大丈夫さ。珠璃にそう伝えておいてくれるかい。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03782"]
……はい。伝えておきますね。[p]
[reset_message_chara]

[chara_hide_all]

#
和人と叡留久の二人は、そのまま庭の奥へと向かっていった。[r]
#
私たちは朱志香に促され、屋敷へと戻った。[p]
[endif]


; --- 自動進行：叡留久と和人の散歩 ---
[fadeoutbgm time="1000"]
[bg storage="street.png" time="1000"]
[charapos name="eruku" face="smile" num="1"]
[charapos name="kazuto" face="normal" num="2"]

#eruku
[voice id="v00137"]
#eruku
いやあ、付き合ってくれてありがとう。[p]
[voice id="v00138"]
#eruku
実は、新しい薬のビジネスを考えていてね。[p]
[voice id="v00139"]
#eruku
抗体ができにくい薬とか、体が丈夫になる薬とか……作れないものかな？[p]

[chara_mod name="kazuto" face="pursue"]
#kazuto
[voice id="v00140"]
#kazuto
……薬は魔法の道具じゃない。[p]
[voice id="v00141"]
#kazuto
そんな都合のいい効果などあるわけないだろう。[p]

#eruku
[voice id="v00142"]
#eruku
はは、厳しいな。[p]
[voice id="v00143"]
#eruku
けれど、薬は人の命を救ったり、健康を補助してくれるのも確かだろう？[p]
[voice id="v00144"]
#eruku
庭に咲いているセージなんかは殺菌効果で有名だと聞いたけどな。[p]

#kazuto
[voice id="v00145"]
#kazuto
それは一面に過ぎない。[p]
[voice id="v00146"]
#kazuto
植物の中には通常なら全く無害だが特定の条件下で毒になるものもある。[p]

#eruku
[voice id="v00147"]
#eruku
へえ、そんなものがあるのかい？[p]

#kazuto
[voice id="v00148"]
#kazuto
ああ。[p]
[voice id="v00149"]
#kazuto
例えば……一定の度数を超えるアルコールと混ぜると、強烈な毒物に変わるものとかな。[p]

#eruku
[voice id="v00150"]
#eruku
なるほど。それは確かに知らないと危険だね。[p]
[voice id="v00151"]
#eruku
だが、毒になるか薬になるかは使い方次第だろう？[p]

#kazuto
[voice id="v00152"]
#kazuto
確かに……薬は人を救うこともできるが、人を殺すこともできる。[p]
[voice id="v00153"]
#kazuto
ビジネスにするなら、常に危険と隣り合わせだってことを徹底して気をつけるべきだな。[p]

[chara_mod name="eruku" face="thinking"]
#eruku
[voice id="v00154"]
#eruku
（随分と薬に関してはむきになるんだな……）[p]

[voice id="v00155"]
#eruku
（思うことでもあるとみた……）[p]

#
会話を終えると、叡留久は和人と共に屋敷へと戻っていった。[p]

[chara_hide_all]
[bg storage="dark.png" time="1000"]
[chapter_end]
[jump storage="scene3.ks" target="*start"]

; マクロ内のセーブ分岐用ラベル
*save_check_yes
[showsave]
[jump target="*save_check_no"]
*save_check_no
[cm]
[return]
