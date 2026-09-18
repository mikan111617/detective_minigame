;=========================================
; scene8.ks
; シーン：解決編・犯人指摘とトリック解明
;=========================================

*start
@clearstack
[mask]
[cm]
[clearfix]
[bg storage="living_night.png" time=1000]
[playbgm storage="last_spart.mp3" loop=true]
[chara_hide_all]
[freeimage layer="1"]
[show_menu]

; scene7 末尾 21:30 を引き継ぐ
[set_time hour=21 min=30]
[gage_draw place="舞黒館:リビング"]
[mask_off]

;-----------------------------------------------------------
; 警部の心証（解決編の言い直し回数）
;   零度警部からどれだけ信を得たかで、言い直せる回数が変わる。
;     0=早く放り出された … 1回
;     1=普通             … 2回
;     2=信を得た         … 3回
;   使い切ってから間違えると *miss_over（バッドエンド）。
;   ・証拠品の提示と推理の選択肢が対象。
;   ・犯人の指名だけは対象外（撤回できないことを事前に告知している）。
;   ・調べ足りずに証明できない *proof_not_confirmed も対象外
;     （やり直しても手札が増えないため）。
;   f.s8_phase は捜査手帳の提示モードに心証を出すかどうかの判定に使う。
;-----------------------------------------------------------
[iscript]
if(typeof f.s6_trust_rank !== "number"){ f.s6_trust_rank = 1; }
f.s8_miss_max  = f.s6_trust_rank + 1;
f.s8_miss_left = f.s8_miss_max;
f.s8_retry     = "";
f.s8_phase     = 1;
[endscript]
; 心証は画面左上のプレートにも出す（f.s8_phase を立ててから描き直す）
[hud_draw]
;=========================================
; 1. 真歩流の耳打ち
;=========================================

[charapos name="reido" face="normal" num="0"]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02631"]
警部、報告があります。[p]
[reset_message_chara]

#
真歩流は零度警部に近づき、小声で耳元に何かをささやいた。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02632"]
（……。）[p]
[reset_message_chara]

#
零度警部は目を見開き、すぐに部下たちのほうへと向かった。[p]

[chara_mod name="reido" face="order"]
#reido
[voice id="v02633"]
総員、今すぐ——！[p]

#
警察官たちが一斉に動き出す。[p]

[chara_hide_all]

[jump target="*suiri_time"]

;=========================================
; 2. 全員への報告
;=========================================
*suiri_time
[charapos name="jushika" face="thinking" num="1"]
[charapos name="juri"    face="thinking" num="2"]
[charapos name="kazuto"  face="normal"   num="3"]
[charapos name="mary" face="normal"   num="4"]


#
夜のリビングに、参加者全員が集まっていた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02634"]
皆さん、調査した結果を報告します。[p]

#mahoru
[voice id="v02635"]
今回の事件——小出里亜さんと叡留久さんは同じ毒物で亡くなりました。[p]

#mahoru
[voice id="v02636"]
そして愛理も、同じ毒を摂取してしまっています。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v02637"]
……続けて。[p]

[chara_hide_all]

;=========================================
; 3. 毒の正体を提示
;=========================================

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02638"]
まず——犯行に使われた毒物の正体です。[p]
[reset_message_chara]

*q_poison
[cm]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v02639"]
証拠品を基に、毒物の正体を示してください。[p]

#

[call storage="system/item_list.ks" target="*select_mode"]

; 毒物の正体として認めるもの。'sage' / 'fake_saint' は存在しないIDだったため、
; 実際に手帳へ入る「毒物」「偽聖女」「庭のセージ」を受け付ける。
[if exp="tf.selected_id == 'poison' || tf.selected_id == 'daught_saint' || tf.selected_id == 'garden_sage'"]
[jump target="*correct_poison"]
[else]
[chara_hide_all]
[charapos name="kazuto" face=normal num=0]

#kazuto
[voice id="v02640"]
それは毒物ではないだろう？[p]

#kazuto
[voice id="v02641"]
少なくとも、俺が見た限りでは違うな。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02642"]
あれ、これじゃないの……？[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_poison'"]
[jump target="*miss_common"]
[endif]

*correct_poison
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="jushika" face="thinking" num="1" wait="false"]
[charapos name="juri"    face="thinking" num="2" wait="false"]
[charapos name="kazuto"  face="normal"   num="3" wait="false"]
[charapos name="mary" face="normal"   num="4" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02643"]
毒の正体は——偽聖女（ヴァイス・セージ）と呼ばれるものでした。[p]
[reset_message_chara]

#kazuto
[voice id="v02644"]
偽聖女……セージの品種改良品で、アルコールと混ぜると強い毒性を発揮する。[p]

[chara_mod name="jushika" face="surprised"]

#jushika
[voice id="v02645"]
和人さん……なぜそれを知っているんですか？[p]

[chara_mod name="kazuto" face="thinking"]

#kazuto
[voice id="v02646"]
……[p]

#kazuto
[voice id="v02647"]
俺の母が薬剤師だった。偽聖女を作ったのは母だからだ。[p]


[chara_mod name="mary" face="surprised"]


#mary
[voice id="v02648"]
それだと……和人さんにしか作れないんじゃ……[p]


[chara_mod name="kazuto" face="thinking"]

#kazuto
[voice id="v02649"]
母の研究資料は何者かに奪われているんだ。[p]

#kazuto
[voice id="v02650"]
それに、もっと怪しいのがこの舞黒館じゃないのか？[p]

[chara_mod name="jushika" face="thinking"]

#jushika
[voice id="v02651"]
……[p]

#jushika
[voice id="v02652"]
どういうことでしょうか？[p]

[chara_mod name="kazuto" face="pursue"]

#kazuto
[voice id="v02653"]
母さんが研究していた偽聖女がどうして舞黒館の庭にある？[p]

#kazuto
[voice id="v02654"]
一般に流通していない医学研究用のものだ。[p]

#jushika
[voice id="v02655"]
……だとすると不思議ですね。[p]

; ▼ 要ボイス再録：v02656（旧「メイフェア・ガーデンは専属の庭師の方が横浜市より
;    派遣されてきて植物の選定をしていますが……」）
;    庭園を造り、草花を指定したのは亡くなった富礼知——という scene3 の伏線と
;    食い違っていたため、朱志香は「手入れは市に任せている／植えるものを決めたのは
;    主人」という言い方に改める。彼女自身は詳細を知らない、という立場は変わらない。
#jushika
[voice id="v02656"]
メイフェア・ガーデンの手入れは、横浜市から派遣される庭師の方にお任せしています。[p]

; ▼ 要ボイス再録：v02657（旧「その庭師しか知らないことです。」）
#jushika
[voice id="v02657"]
植えるものを決めたのは亡くなった主人だと聞いていますが……私は詳しくありません。[p]

#kazuto
[voice id="v02658"]
とぼけるな！[p]

#kazuto
[voice id="v02659"]
名前こそ伏せてあるが、富礼知朱志香、あんたが母さんの資料をSNS上で売っていたのは知っている。[p]

#kazuto
[voice id="v02660"]
それで知らないは通せないぞ。[p]

#jushika
[voice id="v02661"]
そういうことですか……[p]

#jushika
[voice id="v02662"]
確かに私はSNS上で夫の遺品を販売しましたが……[p]

#kazuto
[voice id="v02663"]
遺品……？[p]

#jushika
[voice id="v02664"]
ええ、主人が亡くなり遺品を整理するために残っていた品を一式売り払ったのです。[p]

#jushika
[voice id="v02665"]
中身に関しては詳細はわかりませんが、雑多なものがあったと思います。[p]

#jushika
[voice id="v02666"]
出品をご覧になったのであれば、それもご存じでしょう？[p]

[chara_mod name="kazuto" face="thinking"]

#kazuto
[voice id="v02667"]
……ああ。[p]

#kazuto
[voice id="v02668"]
だが、だからと言って、偽聖女を知らない理由にならないはずだ。[p]

#jushika
[voice id="v02669"]
それはそうですね……[p]

[chara_mod name="juri" face="normal"]

#juri
[voice id="v02670"]
ねえ、毒はわかったと言ったけれど……どうやって毒が摂取されたの？[p]

#juri
[voice id="v02671"]
それがわからないんじゃ、どうしようもないわよ。[p]

;=========================================
; 4. 小出里亜の摂取経路
;   経路A：ダイニングのティーカップ
;   経路B：癖を利用した湯沸かしポット
;=========================================

[if exp="f.route_b == 1"]
[jump target="*koderia_route_b"]
[else]
[jump target="*koderia_route_a"]
[endif]

; ── 経路A：最後の足取り → 小出里亜のカップ ─────────────
*koderia_route_a
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02672"]
まず——小出里亜さんについてです。[p]

#mahoru
[voice id="v02673"]
小出里亜さんが倒れたのは、キッチンでした。[p]

#mahoru
[voice id="v02674"]
でも、その直前には一度ダイニングへ来ています。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v02675"]
……つまり、倒れた場所と毒を口にした場所は同じとは限らない、と？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02676"]
はい。[p]
[reset_message_chara]

;-----------------------------------------------------------
; 「毒がどこで体に入ったのか」は、これまで真歩流が言い切っていた。
; ここを設問にして、プレイヤーが出す結論に変える。
; 経路Bは *q_habit → *q_pot で既にこの形になっている。
; 心証の対象（他の推理と同じ扱い）。
;-----------------------------------------------------------
; ▼ 以下、新規会話は要ボイス収録
#reido
[voice id="v03861"]
では——小出里亜さんは、どこで毒を口にしたのですか。[p]

#reido
[voice id="v03862"]
そこから聞かせてください。[p]

*q_where_koderia
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [
{ target:'*koderia_where_ok', text:'お茶会の紅茶',           kind:'talk' },
{ target:'*koderia_where_ng', text:'キッチンの湯沸かしポット', kind:'talk' },
{ target:'*koderia_where_ng', text:'夕食の下ごしらえ',       kind:'talk' },
{ target:'*koderia_where_ng', text:'メイフェア・ガーデン',         kind:'talk' }
];
tf.where_prompt = "――小出里亜さんが毒を口にしたのは、どこ？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.where_prompt"]

*koderia_where_ng
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]

; ▼ 以下、新規会話は要ボイス収録
#reido
[voice id="v03863"]
そこからは、何も検出されていません。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03864"]
あれ……[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_where_koderia'"]
[jump target="*miss_common"]

*koderia_where_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02677"]
私は、小出里亜さんが毒を口にしたのは——お茶会の時だったと考えています。[p]
[reset_message_chara]

#reido
[voice id="v02678"]
その考えを裏付けるものはありますか？[p]

[if exp="f.s7_koderia_cup_test==1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02679"]
鑑識さんに特定してもらったカップがあります。[p]

#mahoru
[voice id="v02680"]
灰音小出里亜さん本人の指紋が残っており、縁から薬物反応が出たんです。[p]

#mahoru
[voice id="v02681"]
メアリーさんのカップから検出されたものと、同種の成分でした。[p]
[reset_message_chara]
[else]
[jump target="*proof_not_confirmed"]
[endif]

@chara_hide_all
[charapos name="kazuto" face="thinking" num="0"]

#kazuto
[voice id="v02684"]
だが、同じカップが並んでいたんだろう。[p]

#kazuto
[voice id="v02685"]
どうやって、小出里亜の一杯だけに毒を？[p]

;-----------------------------------------------------------
; ここで問うのは「誰か」ではなく「何を知っていれば足りたか」。
; 人物の名指しは終盤の二段構えに一本化してある。
;-----------------------------------------------------------
*q_seat_cond
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [
{ target:'*route_a_seat_ok', text:'どのカップが、誰の席へ行くか',   kind:'talk' },
{ target:'*route_a_seat_ng', text:'小出里亜さんが紅茶を飲む時刻',   kind:'talk' },
{ target:'*route_a_seat_ng', text:'毒がどれくらいで効くか',         kind:'talk' }
];
tf.seat_prompt = "――小出里亜さんの一杯だけを狙うには、何を知っていれば足りた？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.seat_prompt"]

*route_a_seat_ng
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]

; ▼ 要ボイス再録：v02687（旧「（違う。その人は、席順とカップの両方を自由に決められない。）」）
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02687"]
（違う。それだけ分かっても、狙った一杯は選べない。）[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_seat_cond'"]
[jump target="*miss_common"]

*route_a_seat_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="kazuto" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03865"]
これは非常にシンプルです。[p]

#mahoru
[voice id="v02688"]
どのカップを誰が飲むのかさえ分かれば、毒を仕掛けることができます。[p]

#mahoru
[voice id="v02693"]
——まだ、これだけでは終わりません。[p]
[reset_message_chara]

[jump target="*explain_eruku"]

; ── 経路B：従来の「癖 → ポット」 ────────────────────────
*koderia_route_b
[if exp="f.s7_koderia_secret != 1"]
[jump target="*proof_not_confirmed"]
[endif]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02694"]
まず——小出里亜さんについてです。[p]

#mahoru
[voice id="v02695"]
亡くなったお二人のうち、ひとりには、ある癖がありました。[p]

#mahoru
[voice id="v02696"]
その癖が、そのまま死因につながったんです。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v02697"]
ある癖、ですか。[p]

*q_habit
[cm]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v02698"]
真白さん。それが誰のことか、はっきりさせてください。[p]

[chara_hide_all]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'chara_04'"]
[jump target="*correct_habit"]
[else]
[charapos name="kazuto" face="thinking" num="0"]

#kazuto
[voice id="v02699"]
その人物に、そんな癖があったか？[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02700"]
あれ……違ったかな……[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_habit'"]
[jump target="*miss_common"]
[endif]


; ── 正解：小出里亜の癖 ────────────────────────
*correct_habit
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="reido" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02701"]
灰音小出里亜さんです。[p]

#mahoru
[voice id="v02702"]
小出里亜さんには、熱いものに触れると反射的に指を舐める癖がありました。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="jushika" face="surprised" num="0"]

#jushika
[voice id="v02703"]
……ええ。確かに、そういう癖のある子でした。[p]

; ▼ 要ボイス再録：v02704（旧「今朝も、そんな話をしていたばかりで……」）
#jushika
[voice id="v02704"]
着いたばかりのころも、そんな話をしていたばかりで……[p]

;-----------------------------------------------------------
; 経路B：小出里亜の癖から、ポットへ繋ぐ。
;-----------------------------------------------------------
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v02705"]
では——その癖が、どうして毒につながるのですか。[p]

#reido
[voice id="v02706"]
小出里亜さんは、何に触れたのです？[p]

*q_pot
[cm]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02707"]
あの時、小出里亜さんが手にしていたものがあります。[p]
[reset_message_chara]

[chara_hide_all]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'pot'"]
[jump target="*correct_pot"]
[else]
[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v02708"]
それに触れて、指を舐めたと？[p]

#reido
[voice id="v02709"]
……小出里亜さんがそれを手にしていた記録はありませんが。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02710"]
え……あれ……？[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_pot'"]
[jump target="*miss_common"]
[endif]


; ── 正解：湯沸かしポット ──────────────────────
*correct_pot
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="jushika" face="thinking" num="1" wait="false"]
[charapos name="juri"    face="thinking" num="2" wait="false"]
[charapos name="kazuto"  face="normal"   num="3" wait="false"]
[charapos name="mary" face="normal"   num="4" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02711"]
湯沸かしポットです。[p]

#mahoru
[voice id="v02712"]
お茶会の準備をしていた時、ポットに触れて指を舐めた——。[p]

#mahoru
[voice id="v02713"]
その時に、毒を摂取してしまったんです。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v02714"]
だが、それだと他の誰かも摂取する恐れがあっただろう？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02715"]
だから、お茶会の準備をする時に細工をしたの。[p]

#mahoru
[voice id="v02716"]
小出里亜さんがポットを持つようにお願いをして。[p]

#mahoru
[voice id="v02717"]
そのポットは持ったら蓋が開いて、中のお湯がこぼれて手にかかるようにしてあったの。[p]

#mahoru
[voice id="v02718"]
ポットの毒はその時に拭き取られて、証拠は消えてしまっていたけど。[p]
[reset_message_chara]

[chara_mod name="juri" face="normal"]
[chara_mod name="jushika" face="thinking"]

; ── 叡留久の摂取経路 ──────────────────────────────
;   導入は共通。摂取の中身は経路で分かれる。
;     経路A … 小出里亜と同じカップで飲み、そのうえで口づけている（口から口へ）
;     経路B … 小出里亜が落とした口紅を拾い、外側を拭った手で茶菓子を摘まんだ
;   経路Bでは小出里亜のカップに叡留久の指紋は残らない。
;-----------------------------------------------------------
*explain_eruku
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02719"]
次に——叡留久さんの摂取経緯です。[p]
[reset_message_chara]

#
真歩流は、一瞬だけ珠璃を見た。[p]
#
珠璃は黙って真歩流を見つめ返した。[p]

[jump cond="f.route_b == 1" target="*eruku_route_b"]

; ── 経路A：同じカップ、そして口づけ ──────────────────
;   毒がどう移ったのかをプレイヤーに答えさせてから、詳細を説明する。
;   物証は流しのカップなので、見つけていなければ証明できない。
*eruku_route_a

[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]
#reido
[voice id="v03866"]
小出里亜さんの毒が、どうして叡留久さんの体に入ったのですか。[p]

*q_eruku_a
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [
{ target:'*eruku_a_ok',      text:'小出里亜さんが使ったカップ', kind:'talk' },
{ target:'*eruku_a_ng_cake', text:'お茶会の茶菓子',             kind:'talk' },
{ target:'*eruku_a_ng_cup',  text:'叡留久さん自身のカップ',     kind:'talk' },
{ target:'*eruku_a_ng_pot',  text:'湯沸かしポット',             kind:'talk' }
];
tf.eruku_a_prompt = "――小出里亜さんから叡留久さんへ、最初に毒を運んだ接点は？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.eruku_a_prompt"]

*eruku_a_ng_cake
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]
#reido
[voice id="v03867"]
菓子も皿も押さえてあります。どちらからも出ていません。[p]
[jump target="*eruku_a_ng"]

*eruku_a_ng_cup
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]
#reido
[voice id="v03868"]
叡留久さんのカップは鑑識に回っています。成分は出ていません。[p]
[jump target="*eruku_a_ng"]

*eruku_a_ng_pot
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="kazuto" face="thinking" num="0" wait="false"]
#kazuto
[voice id="v03869"]
その湯は全員の紅茶に使われている。[p]

#kazuto
[voice id="v03870"]
それなら、卓についていた全員が倒れているはずだ。[p]
[jump target="*eruku_a_ng"]

*eruku_a_ng
[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03871"]
……あ。[p]
[reset_message_chara]
[eval exp="f.s8_retry='*q_eruku_a'"]
[jump target="*miss_common"]

*eruku_a_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="jushika" face="thinking" num="1" wait="false"]
[charapos name="juri"    face="thinking" num="2" wait="false"]
[charapos name="kazuto"  face="thinking" num="3" wait="false"]
[charapos name="mary"    face="normal"   num="4" wait="false"]

[jump cond="f.s7_eruku_cup != 1" target="*proof_not_confirmed"]

[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v03872"]
キッチンの流しに、洗われないまま残っていたティーカップがあります。[p]

#mahoru
[voice id="v03873"]
持ち手と縁から、小出里亜さんと叡留久さんの指紋が両方出ています。[p]

#mahoru
[voice id="v03874"]
昼のうちに、二人は同じカップで紅茶を飲んでいたんです。[p]
[reset_message_chara]

[message_chara name="mahoru" face="pursue"]
[voice id="v02720"]
#mahoru
叡留久さんは——小出里亜さんと同じカップで紅茶を飲み、毒を摂取しました。[p]
[reset_message_chara]

[chara_mod name="mary" face="thinking"]
#mary
[voice id="v03875"]
同じカップで飲んだんですか？[p]

[voice id="v03876"]
お茶会の後に叡留久さんは小出里亜さんのカップで飲んだということですか。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03877"]
はい。だから叡留久さんは、唇の内側にも成分が残っていました。[p]
[reset_message_chara]

[jump target="*eruku_after"]


; ── 経路B：内ポケットの口紅 → 拭った手 → 茶菓子 ──────────
;   口紅を見つけていないと、この筋は立証できない
*eruku_route_b
[jump cond="f.s7_lipstick != 1" target="*proof_not_confirmed"]

; ▼ 以下、新規会話は要ボイス収録
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]
#reido
[voice id="v03878"]
小出里亜さんの毒が、どうして叡留久さんの体に入ったのですか。[p]

*q_eruku_b
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [
{ target:'*eruku_b_ok',      text:'口紅を拭った指',       kind:'talk' },
{ target:'*eruku_b_ng_cup',  text:'小出里亜さんのカップ', kind:'talk' },
{ target:'*eruku_b_ng_cake', text:'毒が仕込まれた茶菓子', kind:'talk' },
{ target:'*eruku_b_ng_tea',  text:'ポットから注がれた紅茶', kind:'talk' }
];
tf.eruku_b_prompt = "――叡留久さんの口へ毒を運んだものは？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.eruku_b_prompt"]

*eruku_b_ng_cup
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]
#reido
[voice id="v03879"]
流しのカップからは、叡留久さんの指紋は出ていません。[p]
[jump target="*eruku_b_ng"]

*eruku_b_ng_cake
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]
#reido
[voice id="v03880"]
菓子も皿も押さえてあります。どちらからも出ていません。[p]
[jump target="*eruku_b_ng"]

*eruku_b_ng_tea
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="kazuto" face="thinking" num="0" wait="false"]
#kazuto
[voice id="v03881"]
それなら、同じポットの紅茶を飲んだ全員が倒れているはずだ。[p]
[jump target="*eruku_b_ng"]

*eruku_b_ng
[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03882"]
……あ。[p]
[reset_message_chara]
[eval exp="f.s8_retry='*q_eruku_b'"]
[jump target="*miss_common"]

*eruku_b_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="jushika" face="thinking" num="1" wait="false"]
[charapos name="juri"    face="thinking" num="2" wait="false"]
[charapos name="kazuto"  face="thinking" num="3" wait="false"]
[charapos name="mary"    face="normal"   num="4" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03883"]
叡留久さんの、指です。[p]

#mahoru
[voice id="v03884"]
小出里亜さんのエプロンに、口紅が一本入っていました。[p]

#mahoru
[voice id="v03885"]
そこから、指紋が二人分出ています。[p]

#mahoru
[voice id="v03886"]
小出里亜さんと——叡留久さんのものです。[p]
[reset_message_chara]

[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v03887"]
どうして、叡留久さんの指紋が……[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03888"]
底に、刻印があります。[p]

#mahoru
[voice id="v03889"]
「To E.」——その下に、「E.H.」。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03890"]
……穂在呂叡留久。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03891"]
叡留久さんは、あの口紅が誰の物か最初から分かっていたんです。[p]

#mahoru
[voice id="v03892"]
自分が小出里亜さんへ贈ったものだったから。[p]
[reset_message_chara]

#kazuto
[voice id="v03893"]
……[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03894"]
お茶会の席で、小出里亜さんが落としました。[p]

#mahoru
[voice id="v03895"]
拾った叡留久さんは、それを確かめてもいません。[p]

#mahoru
[voice id="v03896"]
人前で返せば、二人のことが知れますから。[p]
[reset_message_chara]

;-----------------------------------------------------------
; 返した経緯。
;   scene4 の「キッチンの様子を見る」は任意イベントなので、
;   見ていない周回では真歩流はあの声を聞いていない。
;   聞いていれば証言として、聞いていなければ物の在り処からの推測として述べる。
;-----------------------------------------------------------
[if exp="f.event_kitchen_lip == 1"]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03897"]
返したのは、そのあとです。[p]

#mahoru
[voice id="v03898"]
キッチンで、二人きりになったときに。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]
#reido
[voice id="v03899"]
それを、あなたは見たのですか。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03900"]
……見てはいません。[p]

#mahoru
[voice id="v03901"]
でも、声は聞きました。[p]

#mahoru
[voice id="v03902"]
「ありがとうございます」と。[p]
[reset_message_chara]

#reido
[voice id="v03903"]
何に対しての礼か、その場では分からなかった、と。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03904"]
はい。[p]
[reset_message_chara]
[else]
[chara_hide_all]
[charapos name="reido" face="thinking" num="0"]
#reido
[voice id="v03905"]
ですが、その口紅はご本人のポケットにありました。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03906"]
はい。叡留久さんの指紋を残したまま、戻っています。[p]

#mahoru
[voice id="v03907"]
人のいないところで返したんだと思います。[p]
[reset_message_chara]
[endif]

[chara_hide_all]
[charapos name="jushika" face="thinking" num="1"]
[charapos name="juri"    face="thinking" num="2"]
[charapos name="kazuto"  face="thinking" num="3"]
[charapos name="mary"    face="surprised" num="4"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03908"]
——問題は、その外側です。[p]

#mahoru
[voice id="v03909"]
外側からだけ、偽聖女の成分が出ています。繰り出した紅からは出ていません。[p]
[reset_message_chara]

#kazuto
[voice id="v03910"]
外側だけ、か。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03911"]
毒のついた手で掴まれたからです。[p]

#mahoru
[voice id="v03912"]
お茶会の準備をしていた時、小出里亜さんは火傷したほうの手でこれを押さえています。[p]

#mahoru
[voice id="v03913"]
ポットの毒が、まだ落ちていない手で。[p]
[reset_message_chara]

#kazuto
[voice id="v03914"]
……だが、それでは叡留久が死ぬ理由にならん。[p]

#kazuto
[voice id="v03915"]
拾って、返しただけだろう。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03916"]
拾ったあと、叡留久さんは外側を指先で拭っています。[p]

#mahoru
[voice id="v03917"]
床に落ちたものですから、当たり前のことです。[p]

#mahoru
[voice id="v03918"]
——そして、その手で茶菓子を摘まみました。[p]
[reset_message_chara]

[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v03919"]
あっ……[p]

[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v03920"]
毒がついているなんて、思うはずがありません。[p]

#mahoru
[voice id="v03921"]
お茶会ですから。お菓子は、最初からそこに出ていたんです。[p]
[reset_message_chara]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03922"]
……口からではなく、手から回ったのか。[p]

#kazuto
[voice id="v03923"]
飲むより遅い。だが、口に入れば同じことだ。[p]

[jump target="*eruku_after"]


; ── ここから再び両経路共通 ────────────────────────
*eruku_after
[chara_mod name="jushika" face="surprised"]
#jushika
[voice id="v02721"]
小出里亜と……叡留久さんが？[p]

[chara_mod name="juri" face="anger"]
#juri
[voice id="v02722"]
……[p]

#juri
[voice id="v02723"]
それで？[p]

[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v02724"]
……叡留久さんの唇から偽聖女の成分が検出されました。[p]

#mahoru
[voice id="v02725"]
これだけでは、叡留久さんと小出里亜さんの接点が見えません。[p]

*q_phone
[cm]
[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v02726"]
……それを裏付けるものがあるんです。[p]
[reset_message_chara]

[chara_hide_all]

[call storage="system/item_list.ks" target="*select_mode"]

;叡留久の携帯を持っているかつ小出里亜のスマホを手に入れている
[if exp="tf.selected_id == 'eruku_phone' || tf.selected_id == 'koderia_phone' "]
[jump target="*correct_eruku_phone"]
[else]
[charapos name="juri" face=thinking num=0]

#juri
[voice id="v02727"]
それのどこが叡留久と小出里亜さんを紐づける証拠になるの？[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02728"]
ええと……あれ……。[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_phone'"]
[jump target="*miss_common"]
[endif]

#

; ── 正解 ─────────────────────────────────────────
*correct_eruku_phone
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="jushika" face="surprised" num="1" wait="false"]
[charapos name="juri"    face="thinking" num="2" wait="false"]
[charapos name="kazuto"  face="thinking"   num="3" wait="false"]
[charapos name="mary" face="surprised"   num="4" wait="false"]

[message_chara name="mahoru" face="dispair"]
#mahoru
[voice id="v02729"]
叡留久さんと小出里亜さんのスマートフォンから、二人が交際しているメッセージが見つかっています。[p]

#mahoru
[voice id="v02730"]
二人は数か月前から交際を始めていたそうです。[p]
[reset_message_chara]

#
二台のスマートフォンの画面が参加者たちに示された。[p]

#jushika
[voice id="v02731"]
まさか、本当にそんなことが……！？[p]

#juri
[voice id="v02732"]
……[p]

#mary
[voice id="v02733"]
珠璃さん……[p]

#juri
[voice id="v02734"]
大丈夫……と言うと嘘になるけど、色々ありすぎて私も混乱しているわ。[p]

#juri
[voice id="v02735"]
私のことは気にしなくていい……[p]

#kazuto
[voice id="v02736"]
だが、お前の妹は……どのように摂取したんだ？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02737"]
愛理はメアリーさんから紅茶をもらった時に、摂取してしまったんです。[p]
[reset_message_chara]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v02738"]
紅茶を……もらった？[p]

#jushika
[voice id="v02739"]
メアリーさんは紅茶に手を付けなかったということですか？[p]

;-----------------------------------------------------------
; ② 愛理の摂取経路（正解：ティーカップ）
;   メアリーに交換の理由を聞いていれば、当のカップを押さえてある
;-----------------------------------------------------------
*q_teacup
[cm]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02740"]
そうです。そして、それを裏付けるものが残っています。[p]
[reset_message_chara]

[chara_hide_all]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'tea_cup'"]
[jump target="*correct_tea_cup"]
[else]
[charapos name="jushika" face="thinking" num="0"]

#jushika
[voice id="v02741"]
それが、愛理さんの摂取経路と何の関係が？[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02742"]
……すみません、勘違いでした。[p]
[reset_message_chara]

[eval exp="f.s8_retry='*q_teacup'"]
[jump target="*miss_common"]
[endif]


; ── 正解：ティーカップ ────────────────────────
*correct_tea_cup
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="jushika" face="surprised" num="1" wait="false"]
[charapos name="juri"    face="thinking" num="2" wait="false"]
[charapos name="kazuto"  face="thinking"   num="3" wait="false"]
[charapos name="mary" face="surprised"   num="4" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02743"]
メアリーさんが愛理に譲った、そのカップです。[p]

#mahoru
[voice id="v02744"]
縁から、薬物が検出されています。[p]

#mahoru
[voice id="v02745"]
それに、メアリーさん本人の指紋も残っていました。[p]
[reset_message_chara]

#mary
[voice id="v02746"]
……私が持っていたカップから。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02747"]
愛理から聞いた話で、メアリーさんは香りが苦手だから、紅茶をもらったんだと。[p]
[reset_message_chara]

[chara_mod name="mary" face="normal"]
#mary
[voice id="v02748"]
ええ。あの香り——普通のハーブとは少し違って感じられて。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02749"]
その違和感の正体が、セージの成分を含む薬物だったんです。[p]

#mahoru
[voice id="v02750"]
メアリーさんは香りに敏感だから気づけた。だから飲まなかった。[p]
[reset_message_chara]


[chara_mod name="kazuto" face="thinking"]

#kazuto
[voice id="v02751"]
それはつまり……メアリーから毒を手渡されたということか？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02752"]
そう、愛理はメアリーさんから譲られた紅茶によって毒を摂取してしまったんです。[p]

#mahoru
[voice id="v02753"]
でも、毒を入れたのはメアリーさんじゃありません。[p]
[reset_message_chara]

[chara_mod name="mary" face="surprised"]
#mary
[voice id="v02754"]
では、あの一杯は……[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02755"]
最初から、メアリーさんのぶんにだけ入っていたんです。[p]

#mahoru
[voice id="v02756"]
お茶会が始まる前に。[p]
[reset_message_chara]

[if exp="f.route_b != 1"]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02757"]
そして——これは、小出里亜さんのカップと同じです。[p]

#mahoru
[voice id="v02758"]
毒が出た二つのカップには、共通点があります。[p]

; ▼ 要ボイス再録：v02759（旧「どちらも、誰の席へ置かれるかを珠璃さんが知っていた。」）
;    ここで名前を出すと、この後の指名が答え合わせになってしまう。
#mahoru
[voice id="v02759"]
どちらも、誰の席へ置かれるかを、同じ人が知っていた。[p]

#mahoru
[voice id="v02760"]
いいえ——知っていただけじゃない。[p]

; ▼ 要ボイス再録：v02761（旧「誰のカップになるかを決められたのが、珠璃さんだったんです。」）
#mahoru
[voice id="v02761"]
誰のカップになるかを、決められた人がいるんです。[p]
[reset_message_chara]
[endif]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v02762"]
カップは全員ぶん、同じものが並んでいた。[p]

#kazuto
[voice id="v02763"]
どれが誰のものか、どうやって決めた。[p]

;-----------------------------------------------------------
; 紅茶を淹れた人と、席へ運んだ人が違う
;   Q1 は事実確認（淹れたのは誰か）。ここは心証の対象。
;   Q2 が犯人の指名になる（撤回不可・心証の対象外）。
;-----------------------------------------------------------
; ▼ 以下、新規会話は要ボイス収録
*q_who_poured
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [
{ target:'*s8_who_poured_ok', text:'富礼知 朱志香',   kind:'talk', chara:['jushika'] },
{ target:'*s8_who_poured_ng', text:'灰音 小出里亜',   kind:'talk', chara:['koderia'] },
{ target:'*s8_who_poured_ng', text:'穂在呂 珠璃',     kind:'talk', chara:['juri']    },
{ target:'*s8_who_poured_ng', text:'メアリー・キング', kind:'talk', chara:['mary']   }
];
tf.pour_prompt = "――あのお茶会で、紅茶を淹れたのは誰ですか。" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.pour_prompt"]

*s8_who_poured_ng
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]

#reido
[voice id="v03924"]
その方は、あの日、茶葉に触れていません。[p]

[eval exp="f.s8_retry='*q_who_poured'"]
[jump target="*miss_common"]

*s8_who_poured_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02764"]
紅茶を淹れたのは、朱志香さんです。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]

#jushika
[voice id="v02765"]
ええ。一杯ずつ用意して、それを珠璃さんに渡しました。[p]

#jushika
[voice id="v02766"]
珠璃さんが皆さんのところへ運んでくださいました。[p]

[chara_hide_all]
[charapos name="juri" face="normal" num="0"]

#juri
[voice id="v02767"]
ええ。朱志香さんが紅茶を淹れて、私が受け取ったわ。[p]

#juri
[voice id="v02768"]
それを皆さんの席へ運んだだけよ。[p]

[chara_hide_all]

[if exp="f.route_b == 1"]
;── 経路B：カップを運び、席順のとおりに並べた人がいる ──
; ▼ 要ボイス再録：v02772（旧「それに珠璃さんは、お茶会の前にキッチンからカップを運んでいます。」）
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02772"]
それにその人は、お茶会の前にキッチンからカップを運んでいます。[p]

; ▼ 要ボイス再録：v02773（旧「席順のとおりに並べたのも、珠璃さんです。」）
#mahoru
[voice id="v02773"]
席順のとおりに並べたのも、同じ人です。[p]
[reset_message_chara]

[else]
;── 経路A：二つの毒入りカップの行き先 ──
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02774"]
小出里亜さんの一杯だけじゃありません。[p]

; ▼ 要ボイス再録：v02775（旧「メアリーさんの一杯も、珠璃さんが行き先を選べました。」）
#mahoru
[voice id="v02775"]
メアリーさんの一杯も、同じ人が行き先を選べました。[p]

; ▼ 要ボイス再録：v02776（旧「……届けられたのは——珠璃さんだけです。」）
#mahoru
[voice id="v02776"]
二つの毒入りカップを、狙った相手の席へ届けられた人が——ひとりだけいます。[p]
[reset_message_chara]

[endif]

#
真歩流は一瞬、間を取った。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02777"]
ここまでの推理を総合すると……[p]

#mahoru
[voice id="v02778"]
毒を用いて二つの事件を起こしたのは……[p]
[reset_message_chara]

;=========================================
; 5. 犯人を指名する
;   問いは「毒を入れたのは誰か」ではなく
;   「どのカップを誰の席へ置くかを決めたのは誰か」。
;   淹れた人（朱志香）と配った人が違う、という一点だけで犯人が決まる。
;=========================================

; 指名画面は全面のオーバーレイになるので、メニュー・資料ボタンは一旦片付ける
; （場所名・時刻のプレートは layer1 なので残る／各分岐の先頭で復帰する）
[cm]
[chara_hide_all]
[hidemenubutton]
[clearfix]

;-----------------------------------------------------------
; 容疑者の一覧
;   選択中の人物の立ち絵（fgimage/standing/<名前>.png）が左に表示される
;   ここは撤回できないので、心証は消費しない（外せばそのまま指名の分岐へ）
;-----------------------------------------------------------
[iscript]
tf.choices = [
{ target:'*bad_end_shurika', text:'富礼知 朱志香',   kind:'accuse', chara:['jushika'] },
{ target:'*bad_end_mary',    text:'メアリー・キング', kind:'accuse', chara:['mary']    },
{ target:'*bad_end_kazuto',  text:'徐音 和人',       kind:'accuse', chara:['kazuto']  },
{ target:'*correct_culprit', text:'穂在呂 珠璃',     kind:'accuse', chara:['juri']    }
];
[endscript]

[stand_select storage="scene8.ks" se="decide.mp3" prompt="――カップを配る先を決めたのは、誰ですか。"]

; ── 不正解①：朱志香を指名 ─────────────────────────
*bad_end_shurika
[cm]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
; 指名を外した先では言い直せない。手帳の心証表示も消しておく
[eval exp="f.s8_phase = 0"]
[charapos name="reido"   face="normal"    num="1" wait="false"]
[charapos name="jushika" face="thinking" num="2" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02779"]
朱志香さん、あなたです！[p]
[reset_message_chara]

#jushika
[voice id="v02780"]
私が？　どういう根拠でそう考えたのですか？[p]

#reido
[voice id="v02781"]
富礼知朱志香さんが犯人だと考えた理由は何ですか？[p]

#reido
[voice id="v02782"]
証拠を提示してください。[p]

[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'pendant'"]
[jump target="*bad_anser_jushika"]
[else]
[jump target="*bad_end_evidence"]
[endif]

*bad_anser_jushika
[gage_draw place="舞黒館:リビング"]
[show_menu]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02783"]
メアリーさんのペンダントは執務室にありました。[p]

#mahoru
[voice id="v02784"]
執務室には朱志香さんや小出里亜さんしか入れず、何か意図があってペンダントを持ち込んだ可能性があります。[p]

#mahoru
[voice id="v02785"]
また、朱志香さんは小出里亜の癖を知っていた。[p]
[reset_message_chara]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v02786"]
なら、小出里亜さんとメアリーさんを殺害しようとした動機は何ですか？[p]

#reido
[voice id="v02787"]
メアリーさんに関してはペンダントを盗もうとしたということは言えるでしょうが……[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02788"]
それは……小出里亜さんとは何かトラブルが……あって。[p]
[reset_message_chara]

[chara_mod name="jushika" face="thinking"]
#jushika
[voice id="v02789"]
……私と小出里亜さんの間に、そのようなトラブルはありません。[p]

#jushika
[voice id="v02790"]
それに、私がメアリーさんを殺害する動機に関しても、殺害するつもりならペンダントを盗む必要がないとは思いませんか？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02791"]
えっと……[p]
[reset_message_chara]

#reido
[voice id="v02792"]
……朱志香さんの言う通りですね。[p]

#reido
[voice id="v02793"]
一度洗い直す必要があるようです。考えを整理しましょう……[p]

#
真歩流は言葉に詰まった。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02794"]
（あれ……どうして……よくわからなくなってきた……）[p]

#mahoru
[voice id="v02795"]
（動機も……チャンスも……何ひとつ証明できない……）[p]
[reset_message_chara]

[chara_hide_all]
; 解決編を抜ける。捜査手帳の心証表示もここで終わり
[eval exp="f.s8_phase = 0"]
[jump storage="ending/bad_end.ks"]


; ── 不正解②：メアリーを指名 ─────────────────────────
*bad_end_mary
[cm]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
; 指名を外した先では言い直せない。手帳の心証表示も消しておく
[eval exp="f.s8_phase = 0"]

[charapos name="reido"   face="normal"    num="1" wait="false"]
[charapos name="mary" face="surprised" num="2" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02796"]
メアリーさん、あなたです！[p]
[reset_message_chara]

#mary
[voice id="v02797"]
わ、私が犯人ですか……[p]

#reido
[voice id="v02798"]
真白さん、メアリーさんが犯人だと考えた理由は何ですか？[p]

#reido
[voice id="v02799"]
証拠を提示してください。[p]

[call storage="system/item_list.ks" target="*select_mode"]

[jump target="*bad_anser_mary"]

*bad_anser_mary
[gage_draw place="舞黒館:リビング"]
[show_menu]
[chara_mod name="reido" face="thinking" wait="false"]
#reido
[voice id="v02800"]
証拠との関連がいまいちわかりませんね。[p]

#reido
[voice id="v02801"]
確かにメアリーさんなら、愛理さんに毒を渡すことは簡単でしょう。[p]

#reido
[voice id="v02802"]
なら——小出里亜さんを殺害する動機は何ですか？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v02803"]
それは……えっと……[p]
[reset_message_chara]

#reido
[voice id="v02804"]
状況的に言えば、メアリーさんは小出里亜さんへ接触することは難しくないでしょう。[p]

#reido
[voice id="v02805"]
しかしながら——リスクを冒してまで、殺害する動機が私には見えないですね。[p]

[chara_mod name="mary" face="cry"]
#mary
[voice id="v02806"]
真歩流さん……[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02807"]
ごめんなさい。私……には。[p]
[reset_message_chara]

#reido
[voice id="v02808"]
一度考えを改めましょう。[p]

#
真歩流はパニックに陥った。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02809"]
（違う……？　私の推理は……間違っていたの？）[p]

#mahoru
[voice id="v02810"]
（どこで……どこで間違えたんだろう……）[p]
[reset_message_chara]

[chara_hide_all]
; 解決編を抜ける。捜査手帳の心証表示もここで終わり
[eval exp="f.s8_phase = 0"]
[jump storage="ending/bad_end.ks"]


; ── 不正解③：和人を指名 ─────────────────────────
*bad_end_kazuto
[cm]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
; 指名を外した先では言い直せない。手帳の心証表示も消しておく
[eval exp="f.s8_phase = 0"]
[charapos name="reido"  face="normal"   num="1" wait="false"]
[charapos name="kazuto" face="thinking" num="2" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02811"]
それは……和人……！[p]
[reset_message_chara]

#kazuto
[voice id="v02812"]
俺が犯人か……。毒物にも詳しいからな。[p]

#reido
[voice id="v02813"]
徐音さんが犯人だと考えた理由は何ですか？[p]

#reido
[voice id="v02814"]
証拠を提示してください。[p]

[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'drag_book' || tf.selected_id == 'poison' "]
[jump target="*bad_anser_kazuto"]
[else]
[jump target="*bad_end_evidence"]
[endif]

*bad_anser_kazuto
[gage_draw place="舞黒館:リビング"]
[show_menu]
[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02815"]
和人だけが……和人だけが毒を作れるから。[p]

#mahoru
[voice id="v02816"]
でも、私は……信じてないよ。和人はやっぱり犯人なんかじゃない。[p]
[reset_message_chara]

[chara_mod name="reido" face="order"]
#reido
[voice id="v02817"]
真白さん、感情でものを言ってはいけない。冷静になってください。[p]

#reido
[voice id="v02818"]
なぜ、彼が犯人だと思ったんですか？[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02819"]
毒のことを知っていたから……和人以外に作れる人がいないと思って。[p]
[reset_message_chara]

#reido
[voice id="v02820"]
犯行の動機は？　では、愛理さんを介抱したのは証拠を消すためということですか。[p]

#reido
[voice id="v02821"]
徐音さん、毒物を持っているんですか？[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v02822"]
身体検査はしただろう。それに、仮に毒を作れたとしても——あんたの言った通り、面識のない二人を殺害する動機はない。[p]

#kazuto
[voice id="v02823"]
まあ、怪しいのは事実だからな。警察署に連行するなり、好きにすればいいさ。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v02824"]
ち、違うの……そんなつもりじゃ。[p]
[reset_message_chara]

[chara_mod name="reido" face="order"]
#reido
[voice id="v02825"]
真白さん！　相手の人生を左右するかもしれない状況で、軽はずみな言動はやめてください！[p]

#reido
[voice id="v02826"]
まして、あなたの妹の命が懸かっているんですよ！[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02827"]
ごめんなさい……私は……[p]
[reset_message_chara]

[chara_mod name="reido" face="normal"]
#reido
[voice id="v02828"]
いえ……警察の私こそ、叱責を受けるべきで、あなたに非はありません。[p]

#reido
[voice id="v02829"]
そもそも警察の役回りをあなたに押し付けてしまっていたのは私です。[p]

#reido
[voice id="v02830"]
今の言葉は撤回します。本当に……申し訳ない。[p]

#reido
[voice id="v02831"]
徐音さん、あなたにもお詫びをします。大変申し訳ございません。[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v02832"]
（ああ、どうして……こんなことに……）[p]
[reset_message_chara]

[chara_hide_all]
; 解決編を抜ける。捜査手帳の心証表示もここで終わり
[eval exp="f.s8_phase = 0"]
[jump storage="ending/bad_end.ks"]

;=========================================
; 6. 珠璃への指名・反論
;=========================================

*correct_culprit
[cm]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="juri" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02833"]
珠璃さんです。[p]
[reset_message_chara]

[chara_mod name="juri" face="thinking"]

#juri
[voice id="v02834"]
私が犯人……？[p]

#juri
[voice id="v02835"]
なるほど、叡留久と小出里亜さんの関係が動機とみたのね。[p]

#juri
[voice id="v02836"]
けれど、それだけでは私がやったという証拠にはならないわ。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02837"]
確かにそうです。[p]

#mahoru
[voice id="v02838"]
でも、珠璃さんだけなんです。[p]

#mahoru
[voice id="v02839"]
小出里亜さんとメアリーさんを殺害することができたのも、そのチャンスがあったのも。[p]

[reset_message_chara]

#juri
[voice id="v02840"]
なら、聞かせてもらえるかしら？[p]

#juri
[voice id="v02841"]
私が犯人であるという証拠を……[p]

[chara_hide_all]

;-----------------------------------------------------------
; 犯人の最後の反論。
;   経路Bは、このあとの *s8_pen_q1（ボールペンを取りに寝室へ行った件）が
;   そのままアリバイ崩しになっているので、ここでは何も挟まない。
;   経路Aには同等の手番がないので、ここで珠璃にアリバイを主張させる。
;-----------------------------------------------------------
[jump cond="f.route_b == 1" target="*after_alibi"]

*juri_alibi_a
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]
[charapos name="juri" face="normal" num="0"]

; ▼ 以下、新規会話は要ボイス収録
#juri
[voice id="v03925"]
それに——私、お茶会が始まってからはずっと席にいたわ。[p]

#juri
[voice id="v03926"]
皆さんの目の前で。毒を入れる隙なんて、どこにあったの。[p]

*q_alibi_a
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [
{ target:'*alibi_a_ok',      text:'お茶会が始まってからだけ',     kind:'accuse' },
{ target:'*alibi_a_ng_prep', text:'お茶会の準備中も含む',         kind:'accuse' },
{ target:'*alibi_a_ng_all',  text:'舞黒館へ到着してからずっと',   kind:'accuse' },
{ target:'*alibi_a_ng_pot',  text:'ポットが用意されてからずっと', kind:'accuse' }
];
tf.alibi_prompt = "――珠璃さんのアリバイが証明しているのは、どの時間帯？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.alibi_prompt"]

*alibi_a_ng_prep
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="jushika" face="thinking" num="0" wait="false"]
#jushika
[voice id="v03927"]
準備の間、私と小出里亜はキッチンにおりました。[p]

#jushika
[voice id="v03928"]
ダイニングのことは、存じ上げません。[p]
[jump target="*alibi_a_ng"]

*alibi_a_ng_all
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]
#reido
[voice id="v03929"]
到着から集合までのあいだを証言できる方は、どなたもいません。[p]
[jump target="*alibi_a_ng"]

*alibi_a_ng_pot
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="reido" face="thinking" num="0" wait="false"]
#reido
[voice id="v03930"]
ポットが用意されたのはキッチンです。[p]

#reido
[voice id="v03931"]
珠璃さんは、その場にいらっしゃいません。[p]
[jump target="*alibi_a_ng"]

*alibi_a_ng
[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03932"]
……あ。[p]
[reset_message_chara]
[eval exp="f.s8_retry='*q_alibi_a'"]
[jump target="*miss_common"]

*alibi_a_ok
[cm]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all wait="false"]
[charapos name="juri" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03933"]
お茶会が始まってからだけです。[p]

#mahoru
[voice id="v03934"]
珠璃さんが皆さんの前にいたのは、席についてからのこと。[p]

#mahoru
[voice id="v03935"]
でも、毒が入ったのはそこじゃありません。[p]

#mahoru
[voice id="v03936"]
カップを並べて、席順を決めていた時です。[p]
[reset_message_chara]

[chara_mod name="juri" face="normal"]
#juri
[voice id="v03937"]
……[p]

[chara_hide_all]

*after_alibi
;=========================================
; 7. 証拠①：早く来た証拠（入館記録書）
;=========================================

[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v02842"]
真白さん、珠璃さんの言う通り、断言できるだけの証拠があるのでしょうか？[p]

#reido
[voice id="v02843"]
珠璃さんが犯人だという根拠はどこにあるんですか？[p]

#
真歩流は証拠品を提示するために、参加者たちの前に立った。[p]

[if exp="f.route_b == 1"]
[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v02844"]
まず、小出里亜さんが亡くなった要因の一つは、彼女の癖を事前に知らないと成立しません。[p]

#mahoru
[voice id="v02845"]
少なくとも、お茶会の前には知っていたはずです。[p]

#mahoru
[voice id="v02846"]
それを示す証拠は……。[p]
[reset_message_chara]
[else]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02847"]
重要なのは、毒入りのカップを狙った相手へ割り当てられたことです。[p]

#mahoru
[voice id="v02848"]
そのうえで、珠璃さんが事件前から準備できたことを示します。[p]
[reset_message_chara]
[endif]

*q_records
[cm]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'records'"]
[jump target="*correct_records"]
[else]
[eval exp="f.s8_retry='*q_records'"]
[jump target="*miss_common"]
[endif]

*correct_records
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="juri" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02849"]
入館記録書です。[p]

; ▼ 要ボイス再録：v02850（旧「……9時20分に到着していました。」）
#mahoru
[voice id="v02850"]
珠璃さんと叡留久さんは集合時間の40分以上前——12時20分に到着していました。[p]
[reset_message_chara]

#
真歩流は入館記録書を示した。[p]

[if exp="f.route_b == 1"]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02851"]
早くに来て、朱志香さんと小出里亜さんと団欒をしていた——あの時です。[p]

#mahoru
[voice id="v02852"]
小出里亜さんの癖を知ることができたのは、その場にいた珠璃さんだけだったんです。[p]

; ▼ 要ボイス再録：v02853（旧「朱志香さん。今朝のことを簡単に話してください。」）
#mahoru
[voice id="v02853"]
朱志香さん。集合前のことを簡単に話してください。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="jushika" face="thinking" num="0"]

; ▼ 要ボイス再録：v02854（旧「……今朝は9時20分頃に到着しました。」）
#jushika
[voice id="v02854"]
ええ、確かに穂在呂夫妻は12時20分頃に到着しました。[p]

#jushika
[voice id="v02855"]
早く到着されたので、一緒にお茶をしました。[p]

#jushika
[voice id="v02856"]
その時、小出里亜さんは自分の癖を話していましたね。[p]

[chara_hide_all]
[charapos name="juri" face="thinking" num="0"]

#juri
[voice id="v02857"]
なるほど、確かに小出里亜さんの癖はその時に知ったわ。[p]

#juri
[voice id="v02858"]
でも、それが証拠というのは無理があるんじゃないかしら？[p]

#juri
[voice id="v02859"]
それなら誰でも知るチャンスはあると思うけど。[p]
[else]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02860"]
珠璃さんは、他の参加者より四十分以上早く館へ来ていました。[p]

#mahoru
[voice id="v02861"]
庭を歩き、館の中を見て、誰にも邪魔されず準備できる時間があったんです。[p]

#mahoru
[voice id="v02862"]
そして、お茶会前には小出里亜さんと席順を決め、カップの前に一人で残る時間もあった。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="juri" face="thinking" num="0"]

#juri
[voice id="v02863"]
でも、それが証拠というのは無理があるんじゃないかしら？[p]

#juri
[voice id="v02864"]
それなら、庭園を回る時間でも、誰でも準備はできると思うけど。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02865"]
確かに、そうです。[p]

; ▼ 要ボイス再録：v02866（旧「……摘むには朝一で来るのが確実です。」）
[voice id="v02866"]
けれど、庭にあるセージを見つかることなく摘むには、誰よりも早く来るのが確実です。[p]

[voice id="v02867"]
それから、珠璃さんには明確な動機があります。[p]

[voice id="v02868"]
小出里亜さんが叡留久さんと不倫関係にあったことです。[p]

@jump target="*root_gouryu"

[endif]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02869"]
確かに、そうです。[p]

#mahoru
[voice id="v02870"]
しかし、朱志香さんには小出里亜さんと叡留久さんを殺害する動機がありません。[p]

#mahoru
[voice id="v02871"]
仮にあったとしても、自身が管理する舞黒館で事件を起こすのはリスクが高すぎます。[p]

#mahoru
[voice id="v02872"]
事前に準備ができる分、真っ先に疑われますから。[p]

#mahoru
[voice id="v02873"]
そして、叡留久さんは今回の被害者でもありますが、仮に叡留久さんが犯人だったとしたら、なぜ小出里亜さんに接触したのか？[p]

[chara_mod name="mahoru" face="thinking"]

#mahoru
[voice id="v02874"]
二人は不倫関係にあったため、叡留久さんに小出里亜さんを殺害する動機がありません。[p]

#mahoru
[voice id="v02875"]
もちろん、メアリーさんとは面識もないので動機はないでしょう。[p]

; ▼ 要ボイス再録：v02876（旧「……朝早くに来た珠璃さんだけです。」）
#mahoru
[voice id="v02876"]
さらに言うと、庭園で誰にも見られないようにセージを摘めたのは、一番早く来た珠璃さんだけです。[p]

[reset_message_chara]

*root_gouryu

#juri
[voice id="v02877"]
さっきの話を聞いて、小出里亜さんには思うところがあるわ。[p]

#juri
[voice id="v02878"]
けれど、あなたの推理ではメアリーさんも毒を盛られる立場だったのでしょう？[p]

#juri
[voice id="v02879"]
だとするなら、私にはメアリーさんを殺す動機はないんじゃなくて？[p]

#juri
[voice id="v02880"]
初対面の相手をどうして殺したいと思えるのよ。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02881"]
それはこの証拠が示してくれます。[p]

#mahoru
[voice id="v02882"]
珠璃さんは見てしまったはずです、SNSである人物の投稿を……[p]
[reset_message_chara]


*q_phone2
[cm]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'koderia_phone' || tf.selected_id == 'eruku_phone' "]
[jump target="*correct_koderia_phone"]
[else]
[eval exp="f.s8_retry='*q_phone2'"]
[jump target="*miss_common"]
[endif]

[message_chara name="mahoru" face="pursue"]

*correct_koderia_phone
[cm]
[reset_message_chara]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02883"]
小出里亜さんはエミリーという名前でSNS上で活動していました。[p]

#mahoru
[voice id="v02884"]
そして、小出里亜さんが投稿した写真に叡留久さんが映っているのを見てしまった。[p]

#mahoru
[voice id="v02885"]
殺意が芽生えたのはその時でしょう。[p]

[reset_message_chara]

#juri
[voice id="v02886"]
……。[p]

@message_chara name=mahoru face=pursue

#mahoru
[voice id="v02887"]
けれど、珠璃さんはわからなかったんです。[p]

#mahoru
[voice id="v02888"]
エミリーという人が一体誰なのか。[p]

#mahoru
[voice id="v02889"]
分かっているのは、エミリーという人物が舞黒館の宿泊イベントに参加するということ。[p]

#mahoru
[voice id="v02890"]
叡留久さんと浮気をしていること。[p]

#mahoru
[voice id="v02891"]
学生である私と愛理を除けば、成人している女性は三人です。[p]

@reset_message_chara

@chara_hide_all

@charapos name=kazuto face=thinking num=0

#kazuto
[voice id="v02892"]
確かに成人女性は三人だ。[p]

#kazuto
[voice id="v02893"]
だが、三人のうち誰かなんて分からないだろう？[p]

@message_chara name=mahoru face=thinking

#mahoru
[voice id="v02894"]
うん、だけど、企画者である朱志香さんが自身のイベントに参加するという投稿をするのは不自然でしょ。[p]

; ▼ 要ボイス再録：v02895（旧「実は、朝早く来たもう一つの理由が……」）
#mahoru
[voice id="v02895"]
実は、誰よりも早く来たもう一つの理由が参加者を知るためなの。[p]

#mahoru
[voice id="v02896"]
参加者の中に女性が何人いるかを確認したかった。[p]

#mahoru
[voice id="v02897"]
該当するのは二人、どちらかはわからない。[p]

#mahoru
[voice id="v02898"]
だから、二人に毒を盛ることにした。[p]

[reset_message_chara]

[chara_hide_all]

[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v02899"]
なるほど。[p]

#reido
[voice id="v02900"]
一緒に殺害することで、犯行の動機を見えにくくし、事故や外部犯である可能性を示唆しようとしたのですね。[p]

#reido
[voice id="v02901"]
庭には事件に使われたセージがあります。[p]

#reido
[voice id="v02902"]
仮にそれがばれたとしても、誰にでもできる犯行であることから、捜査がかく乱できますからね。[p]

[chara_hide_all]

[charapos name="juri" face="thinking" num="0"]

#juri
[voice id="v02903"]
……待って。[p]

#juri
[voice id="v02904"]
庭のセージが凶器だなんて、どうして言い切れるの？[p]

#juri
[voice id="v02905"]
草なんて、この庭にはいくらでも生えているわ。[p]

;=========================================
; 7-2. 証拠：庭のセージ（鑑定済み）
;=========================================

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02906"]
なら、実際に見てもらいましょう。[p]

#mahoru
[voice id="v02907"]
さっき、私が庭から採ってきましたから。[p]
[reset_message_chara]

*q_sage
[cm]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v02908"]
真白さん。その品を。[p]

[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'garden_sage'"]
[jump target="*correct_garden_sage"]
[else]
[eval exp="f.s8_retry='*q_sage'"]
[jump target="*miss_common"]
[endif]

*correct_garden_sage
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="juri" face="thinking" num="0" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02909"]
庭のセージです。[p]

#mahoru
[voice id="v02910"]
和人からもらった本を頼りに、花壇から一株だけ採りました。[p]

#mahoru
[voice id="v02911"]
そして——鑑識に照合してもらっています。[p]
[reset_message_chara]

[chara_hide_all]
[charapos name="reido" face="order" num="0"]

#reido
[voice id="v02912"]
現時点で申し上げられることを言います。[p]

#reido
[voice id="v02913"]
庭から採取された株からは、お二人のご遺体、それから真白愛理さんの検出成分と近しいものが出ています。[p]

#reido
[voice id="v02914"]
品種の同定はまだです。ですが——。[p]

#reido
[voice id="v02915"]
花壇には、株がひとつ抜き取られた跡が残っていました。[p]

#reido
[voice id="v02916"]
土の乾き方から、抜かれたのは今日の昼のうちです。[p]

#
ざわり、と空気が動いた。[p]

; ▼ 要ボイス再録：v02917（旧「……その庭から今朝、株がひとつ消えている。」）
#reido
[voice id="v02917"]
同じ成分に近いものが庭にあり、その庭から今日、株がひとつ消えている。[p]

#reido
[voice id="v02918"]
毒が外から持ち込まれたと考えるより、よほど自然です。[p]

[chara_hide_all]
[charapos name="juri" face="thinking" num="0"]

#juri
[voice id="v02919"]
……近しい、というだけでしょう。[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02920"]
はい。まだ「同じ」とは言えません。[p]

#mahoru
[voice id="v02921"]
でも珠璃さんは今、「庭のセージが凶器だと言い切れるのか」と仰いました。[p]

; ▼ 要ボイス再録：v02922（旧「……なぜ、今朝その株が抜かれているんですか。」）
#mahoru
[voice id="v02922"]
言い切れないなら——なぜ、今日その株が抜かれているんですか。[p]
[reset_message_chara]

#
珠璃は答えなかった。[p]

#
珠璃はしばらく黙っていた。[r]
#
それから、まるで話題を変えるように口を開いた。[p]

#juri
[voice id="v02923"]
だけど……どうやって私が毒を用意したと言うの？[p]

#juri
[voice id="v02924"]
庭に毒になるセージがあったって言うけど、毒になるって知らなければ使えないでしょう？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02925"]
それについては——。[p]

#mahoru
[voice id="v02926"]
珠璃さんが叡留久さんのためにやっていた行動によって、知ることができたのです。[p]

#mahoru
[voice id="v03938"]
SNSを活用した。[p]
[reset_message_chara]

;=========================================
; 8. 証拠②：偽聖女を知っていた（薬学研究の本）
;=========================================
*q_book
[cm]
[chara_hide_all]
[charapos name="reido" face="normal" num="0"]

#reido
[voice id="v02927"]
珠璃さんが偽聖女のことを事前に知っていたことを示す証拠品があるんですか？[p]
[reset_message_chara]

[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'drag_book'"]
[jump target="*correct_research_book"]
[else]
[eval exp="f.s8_retry='*q_book'"]
[jump target="*miss_common"]
[endif]

*correct_research_book
[cm]
[reset_message_chara]
[chara_hide_all wait="false"]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[charapos name="juri" face="normal" num="0" wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02928"]
この薬学研究の本です。[p]

#mahoru
[voice id="v02929"]
これは和人からもらった写本で本物じゃないけど。[p]
[reset_message_chara]

#
珠璃が証拠品を見た瞬間——[p]
@chara_hide_all
[playbgm storage="the_path_to_radiance.mp3" loop=true]
@bg storage="event/mahoru_juri_fight.png"

#juri
[voice id="v02930"]
どうして……それがここに……[p]

#jushika
[voice id="v02931"]
そのノート、主人の遺品に似たようなものがあったような……[p]

#mahoru
[voice id="v02932"]
そうです、先ほど和人と話していたSNSに朱志香さんが出品したという研究ノート。[p]

#mahoru
[voice id="v02933"]
つまりは朱志香さんがSNS上で販売していたものを、珠璃さんが購入していたんです。[p]

#mahoru
[voice id="v02934"]
警部、確認できますか？[p]

#
零度警部は珠璃のスマートフォンを確認した。[p]

#reido
[voice id="v02935"]
調べたところ……珠璃さんのアカウントで薬に関する本が複数購入されており、その中に同様のノートがありました。[p]

#reido
[voice id="v02936"]
薬の本は叡留久さんのビジネスのために集めていたと供述していましたね。[p]

#reido
[voice id="v02937"]
その中に徐音さんのお母様の研究ノートがあった——つまり、あなたは毒の存在を知ることができた。[p]

#mahoru
[voice id="v02938"]
そして——浮気を知った時、偽聖女を利用しようと考えた。[p]

#mahoru
[voice id="v02939"]
早くに来れば偽聖女を手に入れつつ、どのように犯行を行うかを練ることもできる。[p]

#juri
[voice id="v02940"]
……だけど、それじゃあ、私にできたというだけで、決定的な証拠じゃないわ！[p]

#juri
[voice id="v02941"]
もし、私が本当にやったというなら、物証を出してみなさい！[p]

;=========================================
; 9. 証拠③：アルコール所持（濡れた瓶）
;=========================================

#reido
[voice id="v02942"]
珠璃さんの言う通りです。[p]
#reido
[voice id="v02943"]
彼女はどうやって毒を調合したのか。[p]
#reido
[voice id="v02944"]
キッチンにあったアルコール類からは珠璃さんの指紋は検出されていませんよ。[p]

*q_bottle
[cm]
#mahoru
[voice id="v02945"]
それは……これを使ったんです。[p]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'bottle'"]
[jump target="*correct_bottle"]
[else]
[eval exp="f.s8_retry='*q_bottle'"]
[jump target="*miss_common"]
[endif]

*correct_bottle
[cm]
[gage_draw place="舞黒館:リビング"]
[show_menu]

#mahoru
[voice id="v02946"]
珠璃さんのスーツケースから見つかった——この濡れた瓶です。[p]

#mahoru
[voice id="v02947"]
瓶の内部からアルコールが検出されています。[p]

#mahoru
[voice id="v02948"]
このアルコールと偽聖女を使って、毒物に変えたんです。[p]

[if exp="f.route_b == 1"]
;===========================================================
; 経路B：和人の部屋 → ボールペン → 二階廊下の仕掛け
;===========================================================
#mahoru
[voice id="v02949"]
ただ、問題は——どこで偽聖女を扱ったのかです。[p]

#mahoru
[voice id="v02950"]
和人の部屋の机から、偽聖女と同じセージの成分が見つかりました。[p]

#kazuto
[voice id="v02951"]
……俺の机か。[p]

#juri
[voice id="v02952"]
それなら、和人がそこで扱ったんじゃないの？[p]

#mahoru
[voice id="v02953"]
私も、最初はそう思いました。[p]

#mahoru
[voice id="v02954"]
でも、あの時のことを思い返すと、一つ気になることがあったんです。[p]

#mahoru
[voice id="v02955"]
二階の仕掛けを見る直前——珠璃さんだけが、ボールペンを取りに寝室へ向かいました。[p]

#juri
[voice id="v02956"]
ええ。自分の部屋へ取りに行っただけよ。[p]

; ▼ 以下、新規会話は要ボイス収録
#juri
[voice id="v03939"]
私は自分の部屋に戻っていたわ。[p]

#juri
[voice id="v03940"]
毒を仕込むことなんて、できるはずがないでしょう。[p]

;-----------------------------------------------------------
; Q1：珠璃が本当に「自分の部屋」に入ったと証明できるか
;      経路Bのアリバイ崩しはこの一連がそのまま担う
;-----------------------------------------------------------
*s8_pen_q1
[cm]
[shinsho_text]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s8_pen_q1_ok', text:'言い切れない',       kind:'accuse' });
tf.choices.push({ target:'*s8_pen_q1_ng', text:'自分の部屋に入った', kind:'accuse' });
tf.choices.push({ target:'*s8_pen_q1_ng', text:'和人の部屋に入った', kind:'accuse' });
tf.pen_prompt = "珠璃さんが『自分の部屋へ入った』と言い切れる？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.pen_prompt"]

*s8_pen_q1_ng
[eval exp="f.s8_retry='*s8_pen_q1'"]
[jump target="*miss_common"]

*s8_pen_q1_ok
[cm]
[gage_draw place="舞黒館:リビング"]
[show_menu]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02957"]
言い切れません。[p]

#mahoru
[voice id="v02958"]
私たちが見ていたのは、珠璃さんがメインルームへ入るところまでです。[p]

#mahoru
[voice id="v02959"]
宿泊部屋は、ひとつのメインルームから四つの個室へ枝分かれしている。[p]

#mahoru
[voice id="v02960"]
廊下から見えるのは、メインルームの扉ひとつだけ。[r]
#mahoru
[voice id="v02961"]
その先でどの扉を開けたかは、中まで入らなければ分からない。[p]

#mahoru
[voice id="v02962"]
だから、珠璃さんが自分の部屋へ入ったところを見た人は誰もいません。[p]
[reset_message_chara]

[mask]
[chara_hide_all]
@bg storage="event/mahoru_juri_fight.png"
[gage_draw place="舞黒館:リビング"]
[mask_off]

#juri
[voice id="v02963"]
だから？[p]

#juri
[voice id="v02964"]
私が和人の部屋へ入った証拠にもならないでしょう？[p]

#mahoru
[voice id="v02965"]
そうです。これだけなら、まだ憶測です。[p]

#mahoru
[voice id="v02966"]
だから、もう一つ調べてもらいました。[p]
[reset_message_chara]

;-----------------------------------------------------------
; 証拠：二階の仕掛けを開けるのに使ったボールペン
;-----------------------------------------------------------
*q_ballpen
[cm]
[chara_hide_all]
[call storage="system/item_list.ks" target="*select_mode"]

[if exp="tf.selected_id == 'ballpen'"]
[jump target="*correct_ballpen"]
[else]
[charapos name="juri" face="normal" num="0"]
#juri
[voice id="v02967"]
……それが、何の関係があるのかしら。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v02968"]
あ……[p]
[reset_message_chara]
[eval exp="f.s8_retry='*q_ballpen'"]
[jump target="*miss_common"]
[endif]

*correct_ballpen
[cm]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[chara_hide_all wait="false"]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v02969"]
珠璃さんが持ってきて、二階の仕掛けを開けるのに使った——あのボールペンです。[p]
[reset_message_chara]

#警察
鑑定しましたが、あのボールペンから有効な指紋は一つも検出されませんでした。[p]

;-----------------------------------------------------------
; Q2：みんなの前で握ったペンに、なぜ指紋がないのか
;-----------------------------------------------------------
*s8_pen_q2
[cm]
[shinsho_text]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s8_pen_q2_ok', text:'拭き取られたから',   kind:'accuse' });
tf.choices.push({ target:'*s8_pen_q2_ng', text:'手袋をしていたから', kind:'accuse' });
tf.choices.push({ target:'*s8_pen_q2_ng', text:'握っていないから',   kind:'accuse' });
tf.pen_prompt = "握ったはずのペンから、どうして指紋が出ないのか。" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.pen_prompt"]

*s8_pen_q2_ng
[eval exp="f.s8_retry='*s8_pen_q2'"]
[jump target="*miss_common"]

*s8_pen_q2_ok
[cm]
[gage_draw place="舞黒館:リビング"]
[show_menu]

#mahoru
[voice id="v02970"]
拭き取られたからです。[p]

#mahoru
[voice id="v02971"]
私たちは全員、珠璃さんが素手でそのペンを握っているところを見ています。[p]

#mahoru
[voice id="v02972"]
なのに、珠璃さんの指紋すら残っていなかった。[p]

#juri
[voice id="v02973"]
……汚れていたから、誰かが拭いただけかもしれないでしょう？[p]

#mahoru
[voice id="v02974"]
私も、そう考えました。[p]

#mahoru
[voice id="v02975"]
ただ綺麗にしただけなら、それで終わりです。[p]

#mahoru
[voice id="v02976"]
でも——一か所だけ、綺麗にできなかった場所があったんです。[p]

;-----------------------------------------------------------
; Q3：ペンに偽聖女が付着していたことを示す決定的証拠
;-----------------------------------------------------------
*s8_pen_q3
[cm]
[chara_hide_all]
[shinsho_text]
[iscript]
tf.choices = [];
tf.choices.push({ target:'*s8_pen_q3_ok', text:'二階の仕掛けの蓋',     kind:'accuse' });
tf.choices.push({ target:'*s8_pen_q3_ng', text:'メインルームの棚',     kind:'accuse' });
tf.choices.push({ target:'*s8_pen_q3_ng', text:'ダイニングのテーブル', kind:'accuse' });
tf.pen_prompt = "あのペンに偽聖女が付着していたことを示す場所は？" + tf.shinsho;
[endscript]
[stand_select storage="scene8.ks" se="decide.mp3" prompt="&tf.pen_prompt"]

*s8_pen_q3_ng
[eval exp="f.s8_retry='*s8_pen_q3'"]
[jump target="*miss_common"]

*s8_pen_q3_ok
[cm]
[gage_draw place="舞黒館:リビング"]
[show_menu]

#mahoru
[voice id="v02977"]
二階の、仕掛けの蓋です。[p]

#mahoru
[voice id="v02978"]
あの仕掛けを開ける時、珠璃さんは持ってきたボールペンを使いました。[p]

#警察
間違いありません。[p]

#警察
ボールペンが接触した仕掛けの内側から、ごく微量ですが偽聖女と同系統の成分が検出されています。[p]

#mahoru
[voice id="v02979"]
つまり、仕掛けを開けた時点では——あのペンに偽聖女が付いていたんです。[p]

#mahoru
[voice id="v02980"]
でも、今のペンからは偽聖女も、珠璃さんの指紋も出ない。[p]

#mahoru
[voice id="v02981"]
仕掛けを開けたあとで、ペンを綺麗に拭いたからです。[p]

#juri
[voice id="v02982"]
……それでも、私が和人の部屋へ入った証拠にはならないわ。[p]

#mahoru
[voice id="v02983"]
寝室へ向かってから、二階の仕掛けを開けるまでの間に——ペンには偽聖女が付着しています。[p]

#mahoru
[voice id="v02984"]
そして、その寝室側で偽聖女の痕跡が見つかった場所は一か所だけです。[p]

#mahoru
[voice id="v02985"]
和人の部屋の、机の上。[p]

[message_chara name="kazuto" face="thinking"]
#kazuto
[voice id="v02986"]
……なるほどな。[p]

#kazuto
[voice id="v02987"]
俺があの場にいた間に、俺の部屋を使ったのか。[p]
[reset_message_chara]

#mahoru
[voice id="v02988"]
珠璃さんが寝室へ向かった時、和人は私たちと一緒にいました。[p]

#mahoru
[voice id="v02989"]
自分の部屋へ入ったところを見た人はいない。[p]

#mahoru
[voice id="v02990"]
その直後、珠璃さんが持ってきたペンが、偽聖女の成分を二階の仕掛けへ移している。[p]

#mahoru
[voice id="v02991"]
この流れを全部つなげられるのは、珠璃さんだけです。[p]

#juri
[voice id="v02992"]
……[p]

#mahoru
[voice id="v02993"]
それに、どうして自分の部屋じゃなくて和人の部屋だったのか——最初は分かりませんでした。[p]

[message_chara name="kazuto" face="thinking"]
#kazuto
[voice id="v02994"]
確かに俺なら、偽聖女を知っていても不思議じゃない。[p]
[reset_message_chara]

#mahoru
[voice id="v02995"]
そう、偽聖女の痕跡が残っても、和人が疑われる。[p]

#mahoru
[voice id="v02996"]
だから、和人の部屋を選んだんですよね。[p]

[jump target="*after_bottle"]

[else]

;── 経路A：サンルームの鉢が調合の跡を残している ──
#mahoru
[voice id="v02997"]
その作業をしていた場所が、サンルームです。[p]

#mahoru
[voice id="v02998"]
サンルームの床にセージのような物質が落ちていたこと。[p]

#mahoru
[voice id="v02999"]
観葉植物の鉢の中から毒性の物質が検出されたこと。[p]

#mahoru
[voice id="v03000"]
そして、観葉植物の鉢に——指紋が残っていました。[p]

#mahoru
[voice id="v03001"]
鑑識さん、そうですよね。[p]

#警察
はい。観葉植物の鉢からは、複数の指紋が検出されました。[p]

#警察
その中から、今日ここにいる富礼知さん、灰音さん、穂在呂夫人の指紋が検出されています。[p]


#mahoru
[voice id="v03002"]
朱志香さんと小出里亜さんは宿泊イベントの準備でついた可能性がありますから、指紋が残っていても不思議じゃありません。[p]

#mahoru
[voice id="v03003"]
ですが、どうして珠璃さんの指紋が残っていたのか——。[p]

#mahoru
[voice id="v03004"]
それは珠璃さんが、サンルームの鉢の上で毒の調合を行っていたからです。[p]

[endif]



[if exp="f.route_b == 1"]
#mahoru
[voice id="v03005"]
そうして作った毒を、珠璃さんはメアリーさんの一杯にだけ落とした。[p]

@else
#mahoru
[voice id="v03006"]
そうして作った毒を、珠璃さんは小出里亜さんとメアリーさんのカップにだけ落とした。[p]

@endif

#mahoru
[voice id="v03007"]
メアリーさんは香りに敏感でしたから、それに気づいてしまった。[p]

#mahoru
[voice id="v03008"]
だから、お茶が進まなかった。[p]

#mahoru
[voice id="v03009"]
違いますか、メアリーさん？[p]

#mary
[voice id="v03010"]
真歩流さんの言う通りです。香りに違和感があって、どうしても飲む気になれなかったんです。[p]

#mary
[voice id="v03011"]
よく飲むイギリス製の紅茶だったので、香りを知っていたから……[p]

#mahoru
[voice id="v03012"]
珠璃さん、私の推理が間違っていたら言ってください。[p]

#mahoru
[voice id="v03013"]
間違っているって言ってください！[p]

[jump target="*after_bottle"]


*after_bottle

;=========================================
; 10. 珠璃の告白・動機
;=========================================

[fadeoutbgm]
[playbgm storage="sad_story.mp3" loop=true]
@bg storage="dining_night.png"

[charapos name="juri" face="haggard" num=0]

#juri
[voice id="v03014"]
……[p]

#juri
[voice id="v03015"]
のんびりした顔して……すごいわね、名推理よ。[p]

#
珠璃はその場に崩れ落ちた。[p]

#juri
[voice id="v03016"]
……許せなかった。自分を捨てようとした叡留久も、叡留久を奪った相手も。[p]

#
珠璃は泣きながら、ゆっくりと語り始めた。[p]

#juri
[voice id="v03017"]
私の父は有名な芸術家で……母はお嬢様を体現したような存在で、生活力の欠片もなかった。[p]

#juri
[voice id="v03018"]
そんな二人を見て育った私は、周りから馬鹿にされて育った。哀れな両親のもとで育った哀れな子供だと。[p]

#juri
[voice id="v03019"]
両親は気にしていなかったけど、周囲からの風当たりは強かったわ。[p]

#juri
[voice id="v03020"]
なんせ、周りのことを気にせずに二人は自由気ままだったからね。[p]

#juri
[voice id="v03021"]
だけど、両親のことを悪く言われることが私は許せなかった……[p]

#juri
[voice id="v03022"]
同時に思ったのよ。両親と同じようにはならない。私は誰からも見下されない人間になると。[p]

#juri
[voice id="v03023"]
そうして私は、両親とは違う実直な女性を目指し、全国有数の進学校に特待生として入学した。[p]

#juri
[voice id="v03024"]
その頃、別の学校に通っていた叡留久と出会った。[p]

[voice id="v03025"]
顔もよくて、能力もあって……自分の株を上げる良い候補だと思って、付き合って結婚した。[p]

[chara_mod name="juri" face="shout"]
#juri
[voice id="v03026"]
でも——彼本人は覚えていないけれど……私の両親を馬鹿にしていたのは叡留久だったの。[p]

#juri
[voice id="v03027"]
そんな叡留久を見返してやりたいという気持ちが強くて……だから、叡留久からアプローチを受けた時は快感だったわ。[p]

#juri
[voice id="v03028"]
ところが……そんな叡留久が浮気しているのを知った。[p]

#juri
[voice id="v03029"]
これまでの自分の全てが無駄になるような、恐れと怒りが湧いてきて……。[p]

#juri
[voice id="v03030"]
浮気相手を叡留久の前で殺せば、叡留久は私を求めるようになると思ったの。[p]

[chara_mod name="juri" face="haggard"]
#juri
[voice id="v03031"]
誰も私を馬鹿にしないで……私だけを見て……私をもっと評価して……！[p]

#juri
[voice id="v03032"]
本当に私の人生は……何だったのかしらね……[p]

#
——真歩流は、静かに口を開いた。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03033"]
周りからどう思われるとか……本当に重要ですか？[p]

#mahoru
[voice id="v03034"]
珠璃さんは、ご両親のことが大切だったんですよね。[p]

#mahoru
[voice id="v03035"]
周りから馬鹿にされて、辛かったんですよね。だから、一生懸命守ろうとしたんじゃないですか。[p]
[reset_message_chara]

[chara_mod name="juri" face="haggard"]
#juri
[voice id="v03036"]
……[p]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03037"]
大事な両親を馬鹿にするなんて、許せるわけない。[p]

#mahoru
[voice id="v03038"]
それに……私は珠璃さんのご両親は、いつも幸せそうにしていたんじゃないかと思うんです。[p]

#mahoru
[voice id="v03039"]
お互いを大切にして、周りからどう見られようと、関係なかったんですよ。[p]
[reset_message_chara]

#juri
[voice id="v03040"]
私は……私……[p]

#juri
[voice id="v03041"]
ああ……[p]

[chara_mod name="juri" face="cry"]
#juri
[voice id="v03042"]
両親は……いつも幸せそうだった。お互いを大切にして……愛し合っていた。[p]

#juri
[voice id="v03043"]
本当はそんな家族の在り方を認めて欲しかった。馬鹿にしないで、私も仲間に入れて欲しかった……[p]

#juri
[voice id="v03044"]
私は……私は……[p]

#
珠璃は泣き崩れたまま、言葉を失った。[p]

[fadeoutbgm]

;=========================================
; 11. 毒の確認・解毒処置
;=========================================

; 推理終了時刻 21:40 に確定
[set_time hour=21 min=40]
[gage_draw place="舞黒館:リビング"]
[chara_hide_all]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03045"]
珠璃さん……使った毒は偽聖女で間違いないですね？[p]
[reset_message_chara]

[charapos name="juri" face="haggard" num="0"]

#juri
[voice id="v03046"]
……ええ。[p]

#
珠璃はうなずいた。[p]

[chara_hide_all]

#警察
鑑識から報告です。サンルームの鉢から採取された植物の種別を特定できました。[p]

#
差し出された証拠品袋の中には、乾いたセージによく似た葉が収められていた。[p]

#警察
『偽聖女』——脳機能の改善を目的に作られたセージの改良品種です。[p]

#警察
単体では無害ですが、強いアルコールと合わせると毒素を出します。[p]

#警察
それと、保留になっていた件の結果も出ました。[p]

#警察
真白さんが庭から採取された株——あちらも、同じ『偽聖女』です。[p]

#reido
[voice id="v03047"]
……一致した、ということですね。[p]

#警察
はい。ご遺体と庭の株。[p]

#警察
すべて同一の品種であると、確認が取れました。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03048"]
（懐中電灯の下で摘んだ、あの一株が……ちゃんと、繋がった。）[p]
[reset_message_chara]

[message_chara name="mahoru" face="cry"]
#mahoru
[voice id="v03049"]
……これが、二人を死に追いやったものなんですね。[p]
[reset_message_chara]

; 発見物の見出しに調査パートの居場所が残っているので、ここで入れ替える
[iscript]
f.inv_cur_room    = "舞黒館:リビング";
f.inv_cur_room_id = "";
f.inv_cur_where   = "鑑識の報告";
[endscript]

[get_item id="daught_saint"]
[iscript]
f.status["daught_saint"].owned = true;
[endscript]

[chara_hide_all]
[charapos name="kazuto" face="pursue" num="0"]

#kazuto
[voice id="v03050"]
分かった。すぐに中和剤を作る——！[p]

#
和人は駆け出していった。[p]

[chara_hide_all]
[charapos name="reido" face="order" num="0"]

#reido
[voice id="v03051"]
穂在呂珠璃さん、殺人及び殺人未遂の容疑で逮捕します。[p]

[chara_hide_all]

;=========================================
; 13. エンディング分岐
;=========================================

; トゥルーエンド条件：メアリーの目的・キング家と結月の記録・床下の鍵穴・設計図・地下への鍵の5つ
; true_flag_mary は scene4 のメアリー会話でも scene7 の手紙の話でも立つ共通フラグ
; s7_king_yuzuki_record は、キング家が舞黒館と関わっていたことを示す記録。
; has_old_key（三色硝子→資料室の棚→執務机裏）は、地下への扉を実際に開くため必須。
[jump cond="f.true_flag_mary == 1 && f.s7_king_yuzuki_record == 1 && f.base_ment_found == 1 && f.has_blueprint == 1 && f.has_old_key == 1" target="*true_route_search"]
[jump target="*normal_end"]

;=========================================
; 12. 愛理の症状の謎・和人の疑問
;=========================================
*true_route_search
[mask time=500]
[bg storage="living_night.png" time=0]
[fadeinbgm storage="veiled_truth.mp3" loop=true]
[chara_hide_all]
[mask_off time=500]

[charapos name="reido" face="normal"   num="2"]
[charapos name="kazuto" face="thinking" num="1"]

#kazuto
[voice id="v03052"]
処置は終わった。あとは病院で対応するしかない。[p]

#reido
[voice id="v03053"]
ご協力感謝します。あとは救急隊員が来たら搬送できるようにするだけです。[p]

[chara_mod name="kazuto" face="thinking"]
#kazuto
[voice id="v03054"]
……[p]

#kazuto
[voice id="v03055"]
考えていたのですが——真白愛理だけ毒の進行が遅い理由が分からない。[p]

#kazuto
[voice id="v03056"]
愛理の症状の進行は、明らかに何かが毒の作用を遅らせているとしか思えない。[p]

#kazuto
[voice id="v03057"]
もちろん体質もあるだろうが、それにしてもここまで症状が遅いのはおかしい。[p]

[chara_hide_all]
[charapos name="reido" face="thinking" num="1"]
[charapos name="juri"  face="haggard"   num="2"]

#reido
[voice id="v03058"]
別の物質……？　珠璃さん、本当に同じ毒を使ったんですか？[p]

#juri
[voice id="v03059"]
ええ。複数の毒を使えば、複数犯による手口だと思われてしまうでしょう？[p]

#juri
[voice id="v03060"]
そうなると、私も疑われてしまうと思ったの。結果的には捕まったけれどね。[p]

[chara_hide_all]
[charapos name="kazuto" face="thinking" num="1"]

#kazuto
[voice id="v03061"]
……病院で調べればわかることか。[p]

[charapos name="juri"  face="haggard"   num="2"]
#juri
[voice id="v03062"]
そのこととは関係ないけど、最後に一つだけ気になることがあるわ。[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03063"]
気になることですか？[p]
[reset_message_chara]

#juri
[voice id="v03064"]
朱志香さん、あなたは旦那さんから舞黒館の管理者の立場を引き継いだのよね？[p]

[charapos name="jushika"  face="thinking" num="3"]

#jushika
[voice id="v03065"]
ええ、それがどうかされました？[p]

#juri
[voice id="v03066"]
和人の話だと、偽聖女は彼の母親のものでしょう？ どうしてそれがここにあるのか、あなたは知っているの？[p]

#jushika
[voice id="v03067"]
……主人が取り仕切っている間は私はほとんど関知していません。[p]

#jushika
[voice id="v03068"]
どういう意図や経緯があったのかは私にはわからないですね。[p]

#juri
[voice id="v03069"]
叡留久が言っていたわ。かつて、舞黒館が売りに出されたとき、大きなトラブルがあったと。[p]

#jushika
[voice id="v03070"]
……[p]

#juri
[voice id="v03071"]
購入を止めさせようとした人たちがいたらしいわ。[p]

#juri
[voice id="v03072"]
理由は諸説あるけど、舞黒邦夢が1930年に地下を増築したことが原因らしいわ。[p]

#kazuto
[voice id="v03073"]
地下の増築が原因？[p]

#kazuto
[voice id="v03074"]
地盤が悪いとかそういうことか？[p]

#juri
[voice id="v03075"]
私に言われてもわからないわ。[p]

#juri
[voice id="v03076"]
ただ、叡留久は仕事仲間から聞いたそうよ。[p]

#juri
[voice id="v03077"]
地下を見つけることができれば、どんなものよりもすごいものが手に入ると。[p]

#juri
[voice id="v03078"]
これまでに地下の存在を見つけた人は誰もいないからって。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03079"]
地下を見つけることができたら……[p]
[reset_message_chara]

[chara_hide_all]

[charapos name="reido"  face="thinking" num="1"]
[charapos name="juri"  face="haggard" num="2"]

#reido
[voice id="v03080"]
それでは珠璃さん、積もる話は署で伺います。[p]


#juri
[voice id="v03081"]
……ごめんなさい。叡留久……[p]

#警察
それでは署の方へ連行します。[p]

[chara_hide_all]

#
珠璃は警察に連れていかれた。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru

#mahoru
[voice id="v03082"]
（さっきの話、もし、地下を見つけることができたとしたら……）[p]

#mahoru
[voice id="v03083"]
（設計図には地下があるって書いてあった……）[p]

#mahoru
[voice id="v03084"]
やっぱり……！[p]

[reset_message_chara]

[charapos name="reido" face="order" num="0"]

#reido
[voice id="v03085"]
どうしました？ 何か気になることでも？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03086"]
私、見つけたんです。舞黒館の設計図を……。[p]

[reset_message_chara]

[chara_hide_all]

[charapos name="reido"  face="thinking" num="1"]
[charapos name="jushika"  face="thinking" num="2"]

#jushika
[voice id="v03087"]
設計図ですか？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03088"]
もし、舞黒館が設計図通りに造られたなら、地下があると思うんです……。[p]

#mahoru
[voice id="v03089"]
資料室には要人が避難できるように地下に通路が用意されていました。[p]

[reset_message_chara]

#reido
[voice id="v03090"]
興味深い話ではありますが、今は殺人事件の現場です。[p]

#reido
[voice id="v03091"]
調べるのはまた後日……。[p]

[charapos name="kazuto"  face="thinking" num="3"]
#kazuto
[voice id="v03092"]
そういえば、メアリーはどこへ行ったんだ？[p]

#kazuto
[voice id="v03093"]
さっきから姿が見えないが。[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03094"]
そういえば、メアリーさん！[p]

[reset_message_chara]

#
周囲を見回すが、メアリーの姿が見当たらない。[p]

#
全員で探すが影も形もない。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03095"]
（メアリーさんは、親戚の手がかりを探すために舞黒館へ来た。）[p]

#mahoru
[voice id="v03096"]
（舞黒邦夢の記録には、外交官のキング家がこの館へ家具を残したと書かれていた。）[p]

#mahoru
[voice id="v03097"]
（キング——メアリー・キング。）[p]

#mahoru
[voice id="v03098"]
（もしメアリーさんが、キング家とこの館のつながりを知っていたなら……。）[p]

#mahoru
[voice id="v03099"]
（この館の中で、私たちとは別の何かを探していた？）[p]
[reset_message_chara]

#reido
[voice id="v03100"]
全警官隊に告げる、屋敷の周辺をくまなく調べろ！[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03101"]
メアリーさん……いったいどこへ？[p]
[reset_message_chara]

[chara_hide_all]

;=========================================
; トゥルーエンドルート：地下室発見
;=========================================

[mask effect="fadeInDown"]
[cm]
[gage_draw place="舞黒館:リビング"]
[show_menu]
[mask_off]
[charapos name="reido" face="thinking" num="0"]

#警察
警部、屋敷の周辺を探しましたが、どこにも見当たりません。[p]

#reido
[voice id="v03102"]
もっとよく探せ。屋敷の中は？[p]

#警察
屋敷の中もくまなく探しているのですが、見当たりません。[p]

#reido
[voice id="v03103"]
馬鹿な……彼女は一体どこへ行った？[p]

#reido
[voice id="v03104"]
空でも飛んで行ったというのか……[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03105"]
もしかして……[p]
[reset_message_chara]

#
サンルームの床下の鍵穴。[r]
#
あの時見つけた、新しく張り替えた床の下に隠された鍵穴。[p]
#
もし、あの鍵穴が地下室への入り口でメアリーさんも見つけていたら……？[p]

[message_chara name="mahoru" face="surprised"]
#mahoru
[voice id="v03106"]
零度警部、さっきの地下室です！[p]
[reset_message_chara]

#reido
[voice id="v03107"]
真白さん？[p]

[message_chara name="mahoru" face="pursue"]
#mahoru
[voice id="v03108"]
サンルームです！ あそこに地下への入り口があるかもしれないです！[p]
[reset_message_chara]

#reido
[voice id="v03109"]
サンルーム……？[p]

[message_chara name="mahoru" face="normal"]
#mahoru
[voice id="v03110"]
行けばわかります。急いで！[p]
[reset_message_chara]

[chara_hide_all]
; 解決編を抜ける。捜査手帳の心証表示もここで終わり
[eval exp="f.s8_phase = 0"]
[jump storage="ending/true_end.ks"]


;=========================================
; ノーマルエンドルート
;=========================================

*normal_end
; 解決編を抜ける。捜査手帳の心証表示もここで終わり
[eval exp="f.s8_phase = 0"]
[jump storage="ending/normal_end.ks"]


;=========================================
; 警部の心証（言い直しの共通処理）
;   各質問の不正解側は
;       [eval exp="f.s8_retry='*戻り先ラベル'"]
;       [jump target="*miss_common"]
;   と書く。残っていればその質問へ戻り、尽きていれば *miss_over へ。
;=========================================
*miss_common
[cm]
[clearfix]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[layopt layer="message0" visible=true]
[chara_hide_all wait="false"]
; ●が一つも残っていない状態で誤ったら、そこで終わり。
; ●の数＝「あと何回まちがえられるか」。先に判定してから減らす。
[jump cond="(f.s8_miss_left||0) <= 0" target="*miss_over"]
[eval exp="f.s8_miss_left = f.s8_miss_left - 1"]
; 減ったことが左上のプレートにすぐ出るように描き直す
[hud_draw]

[charapos name="reido" face="thinking" num="0" wait="false"]

; ▼ 以下、新規会話は要ボイス収録
#reido
[voice id="v03941"]
真白さん。今のは違います。[p]

#reido
[voice id="v03942"]
落ち着いて。もう一度、そこから組み立て直してください。[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03943"]
……はい。[p]
[reset_message_chara]

[chara_hide_all]
; 戻り先が空のまま来ることは無いはずだが、空だと [jump] がシナリオ先頭へ
; 戻ってしまう（target="" は「このファイルの頭から」を意味する）。
; 黙って scene8 が再生され直すのを避けるため、念のため受け止めておく。
[jump cond="f.s8_retry == ''" target="*miss_over"]
[jump target="&f.s8_retry"]


;=========================================
; 心証を使い切った
;=========================================
*miss_over
[cm]
[clearfix]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[layopt layer="message0" visible=true]
[chara_hide_all]
[charapos name="reido" face="order" num="0"]

; 冒頭3行のみ新規。以降は旧 *bad_end_before_pointing の収録済み台詞を流用する。
; ▼ 要ボイス収録（この3行）
#reido
[voice id="v03944"]
真白さん。[p]

#reido
[voice id="v03945"]
あてずっぽうでは、だめです。[p]

#reido
[voice id="v03946"]
一度落ち着いて、調べたことを洗い出す必要がありますね。[p]

[chara_mod name="reido" face="thinking"]
#reido
[voice id="v03120"]
考え方そのものを否定するつもりはありません。[p]

#reido
[voice id="v03121"]
今は、確認できた事実だけで組み立て直しましょう。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03122"]
……考えはある。[p]

#mahoru
[voice id="v03123"]
でも、言い切るには証拠が足りないんだ。[p]

#mahoru
[voice id="v03124"]
（まだ、確かめきれていないことがある。）[p]
[reset_message_chara]

[chara_hide_all]
[jump target="*go_bad_end"]


;=========================================
; バッドエンドルート：証明不足／証拠品ミス
;=========================================
*proof_not_confirmed
[cm]
[chara_hide_all]
[show_menu]
[gage_draw place="舞黒館:リビング"]
[charapos name="reido" face="thinking" num="0"]

#reido
[voice id="v03111"]
その説明を裏付ける確認結果はありますか？[p]

[message_chara name="mahoru" face="thinking"]
#mahoru
[voice id="v03112"]
……いいえ。[p]

#mahoru
[voice id="v03113"]
考えはあります。[p]

#mahoru
[voice id="v03114"]
でも、今ある材料だけでは、みんなの前で事実だと言い切れません。[p]
[reset_message_chara]

#reido
[voice id="v03115"]
分かりました。[p]

#reido
[voice id="v03116"]
推測と、確認できた事実は分けましょう。[p]

#
真歩流は唇を噛んだ。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03117"]
（分かっているつもりでも、証明できなければたどり着けない。）[p]

#mahoru
[voice id="v03118"]
（まだ、確認できていないことがあったんだ。）[p]
[reset_message_chara]

[jump target="go_bad_end"]

; 旧 *bad_end_before_pointing はここにあった。
; 証拠品の提示ミスは「警部の心証」で言い直せるようになったため、
; 一発でバッドエンドへ落とす入口は廃止し、台詞は *miss_over へ移した。
; （v03119 だけは行き場がないので未使用。文言を変えるときの下敷きに残しておく）

*bad_end_evidence
[cm]
[chara_hide_all wait="false"]
[show_menu]
[charapos name="reido" face="thinking" num="0" wait="false"]

#reido
[voice id="v03125"]
その証拠では、今の主張を裏付けることはできません。[p]

#reido
[voice id="v03126"]
推理の方向まで間違っているとは限りません。[p]

#reido
[voice id="v03127"]
確認できている事実と、まだ仮説の部分を分けて考えましょう。[p]

[message_chara name="mahoru" face="panic"]
#mahoru
[voice id="v03128"]
……そうだ。[p]

#mahoru
[voice id="v03129"]
分かっていることと、証明できることは同じじゃない。[p]

#mahoru
[voice id="v03130"]
（もう一度、何を根拠に話していたのか整理しないと。）[p]
[reset_message_chara]

#reido
[voice id="v03131"]
今は落ち着いて情報を整理するのが先決です。[p]

*go_bad_end

[chara_hide_all]
; 解決編を抜ける。捜査手帳の心証表示もここで終わり
[eval exp="f.s8_phase = 0"]
[jump storage="ending/bad_end.ks"]
