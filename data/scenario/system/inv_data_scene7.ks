;===============================================================================
; inv_data_scene7.ks  ―― scene7（毒物捜査）の章データ
; [call storage="inv_data_scene7.ks"] で読み込み、scene7 の頭で [inv_set chapter="s7"]
;===============================================================================

[iscript]
f.INV_DATA.s7 = {
  title:      "舞黒館 ― 毒物捜査",
  startMin:   1230,         // 20:30
  endMin:     1290,         // 21:30
  endLabel:   "タイムリミットまで",
  exitLabel:  "捜査を終える",
  hint:       "部屋を選ぶと、その部屋の調査対象と話せる人がまとめて表示されます。",
  // 答えや部屋名を直接示さず、現在つなぐべき考え方だけを一件表示する。
  // まず三人の共通点、その後は経路ごとの毒物カウンター未取得分を優先する。
  memo:[
    { cond:"!(f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1)",
      title:"三人の共通点",
      text:"倒れた場所も行動も違う三人。まずは推測より先に、三人の身体に同じ痕跡が残っていないか確かめたい。",
      question:"それぞれを同じ観点から調べれば、共通するものが見えてくるかもしれない。" },

    // ── 経路A：カップ → サンルームの床 → 本を入手後に鉢 ──
    { cond:"f.route_b!=1 && f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf6!=1",
      title:"口にした場所へ戻る",
      text:"倒れた場所と、毒を口にした場所は同じとは限らない。二人の間をつなぐ、洗われずに残った器がないだろうか。",
      question:"調理に使ったものだけでなく、キッチンの流しに置かれたままのものも確かめてみよう。" },
    { cond:"f.route_b!=1 && f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf6==1 && f.s7_pf4!=1",
      title:"乾いた跡",
      text:"液体が運ばれたなら、器だけでなく、途中でこぼれた場所にも痕跡が残る。昼の出来事を思い返したい。",
      question:"一階で飲み物がこぼれた場所を、もう一度調べてみよう。" },
    { cond:"f.route_b!=1 && f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf4==1 && f.s7_pf5!=1 && f.s7_poison_complete==1 && f.s7_drag_book!=1",
      title:"実験の続き",
      text:"毒の正体は確かめられたが、館に残った痕跡を見分ける知識がまだ足りない。実験は結果を聞いて終わりではない。",
      question:"仮説を立てた人物へ結果を伝えれば、植物を調べる手がかりを借りられるかもしれない。" },
    { cond:"f.route_b!=1 && f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf4==1 && f.s7_pf5!=1 && f.s7_drag_book==1",
      title:"本と植物",
      text:"手元の本には、毒に使われた植物の性質が記されている。知識を得た今なら、以前は見分けられなかった痕跡に気づける。",
      question:"一階の、植物が置かれた明るい部屋へ戻り、鉢を詳しく調べてみよう。" },

    // ── 経路B：机 → 持ち出された道具 → 二階の仕掛け ──
    { cond:"f.route_b==1 && f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf6!=1",
      title:"遺体のそばに残ったもの",
      text:"本人の身体だけでなく、身につけていたものにも毒が移っている可能性がある。小さな持ち物ほど見落としやすい。",
      question:"キッチンのご遺体を、所持品まで含めて確認してみよう。" },
    { cond:"f.route_b==1 && f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf6==1 && f.s7_pf4!=1",
      title:"拭き取られた作業場所",
      text:"毒を用意したなら、液体を扱った場所に痕跡が残る。きれいすぎる場所も、何もないとは限らない。",
      question:"二階の個室で、天板だけ不自然に拭かれている机がないだろうか。" },
    { cond:"f.route_b==1 && f.s7_pf4==1 && f.s7_pf5!=1 && f.s7_pen_logic!=1",
      title:"机から持ち出されたもの",
      text:"拭かれた机で使われたものが、その後べつの場所へ運ばれた可能性がある。まず、その道具を特定したい。",
      question:"個室だけでなく、宿泊部屋の共用スペースに置き忘れられたものを確かめよう。" },
    { cond:"f.route_b==1 && f.s7_pf4==1 && f.s7_pf5!=1 && f.s7_pen_logic==1",
      title:"道具が触れた場所",
      text:"拭かれた道具が見つかった。その道具が昼間に触れた場所なら、消し切れなかった毒が移っているかもしれない。",
      question:"二階の廊下で、昼にその道具を使って開けた仕掛けを調べてみよう。" },

    // ── 両経路共通：本で庭の株を見分け、零度警部へ鑑定を依頼する ──
    { cond:"f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf4==1 && f.s7_pf5==1 && f.s7_pf6==1 && f.s7_drag_book==1 && f.s7_garden_sage!=1",
      title:"本に描かれた株",
      text:"館内に残った毒の痕跡は集まった。次は、手元の本に描かれた植物が、この館のどこかにないか確かめたい。",
      question:"昼に歩いた庭へ戻り、ハーブが植えられていた一角を本の図と見比べてみよう。" },
    { cond:"f.s7_pf1==1 && f.s7_pf2==1 && f.s7_pf3==1 && f.s7_pf4==1 && f.s7_pf5==1 && f.s7_pf6==1 && f.s7_garden_sage==1 && f.s7_sage_match!=1",
      title:"採取した株を照合する",
      text:"庭の株を見つけただけでは、被害者から出た成分と同じものかは断定できない。比較するには鑑識の力が必要になる。",
      question:"採取した株を、検査を手配できる人物へ見せてみよう。リビングにいる警察関係者なら頼めるはずだ。" },

    // ── 毒物の手がかりを集める途中で必要になる推理と実験 ──
    { cond:"f.s7_poison_complete==1 && f.route_b==1 && (f.s7_gimmick_lid!=1 || !f.status || !f.status['ballpen'] || f.status['ballpen'].owned!=true)",
      title:"毒が運ばれた跡",
      text:"毒の正体は見えてきた。次は、調合された場所から被害者のもとまで、何を介して運ばれたのかを考えたい。",
      question:"拭き取られた場所と、そこから持ち出されて別の場所でも使われた道具を、順番につないでみよう。" },
    { cond:"f.s7_poison_complete==1 && f.route_b!=1 && f.s7_koderia_cup_test!=1",
      title:"倒れた場所と口にした場所",
      text:"三人が倒れた場所は一致しない。倒れた場所ではなく、それ以前に口にしたものへ視点を戻したい。",
      question:"お茶会で、誰の飲み物が誰へ渡ったのか。使われた器から確かめられないだろうか。" },
    { cond:"f.s7_sage_request==1 && f.s7_poison_complete!=1",
      title:"仮説を確かめる",
      text:"セージに似た成分と、容器に残ったもの。この二つを組み合わせたとき何が起きるのか、まだ確かめていない。",
      question:"個人ではできない検査を、手配できる人物へ相談してみよう。" },
    { cond:"f.s7_wet_bottle==1 && f.s7_sage_request!=1",
      title:"見つけた容器の意味",
      text:"不自然に洗われた容器が見つかった。中身が消えていても、残った反応から用途を考えられるかもしれない。",
      question:"セージの性質について仮説を話した人物に、この容器を見せてみよう。" },
    { cond:"f.s7_kazuto_3_intro==1 && f.s7_wet_bottle!=1",
      title:"混ぜたものがあるなら",
      text:"何かを混ぜて性質を変えたのなら、調合や持ち運びに使ったものが残るはずだ。",
      question:"液体を入れられるもの、あるいは不自然に洗われているものが、誰かの荷物にないだろうか。" },
    { cond:"f.s7_sage_hypothesis==1 && f.s7_kazuto_3_intro!=1",
      title:"無害なものが害を持つ条件",
      text:"普通のセージは無害。それでも三人から似た成分が出たなら、品種か、加えられた何かに違いがある。",
      question:"植物や薬の性質に詳しい人物なら、この矛盾から仮説を立てられないだろうか。" },
    { cond:"true",
      title:"集めた情報をつなぐ",
      text:"手がかりは単独では答えにならない。新しく聞けるようになった話と、まだ説明できていない痕跡を結び直そう。",
      question:"部屋カードの「新規会話」と、未確認の証拠品をもう一度見直してみよう。" }
  ],
  mapBg:      "hallway_night.png",      // 館マップの背景
  step:       2,
  stepNote:   "場所を調べると1分、人と話すと2分が経過します。",
  // 探索UIからは差し替え層を経由し、変更しないイベントは scene7.ks へ委譲する
  storage:        "scene7.ks",
  hubTarget:      "*investigation_hub",
  dispatchTarget: "*s7_dispatch",
  destVar:    "s7_map_dest",
  floorVar:   "s7_active_floor",
  // 毒物の手がかり
  //   ① 小出里亜の遺体 ② 叡留久の遺体 ③ 愛理の体
  //   ④ 経路A：サンルームの床／経路B：和人の机
  //   ⑤ 経路A：観葉植物の鉢／経路B：二階廊下の仕掛け
  //   ⑥ 叡留久の摂取経路の物証（どちらも「二人の指紋が残った一つの物」）
  //      経路A：流しに残った小出里亜のカップ
  //      経路B：小出里亜のエプロンの口紅（外側だけに毒／底に刻印）
  //      どちらの経路でも6つ揃うので、経路別の flagsB は置かない
  counter:    { label:"毒物の手がかり",
                flags: ["s7_pf1","s7_pf2","s7_pf3","s7_pf4","s7_pf5","s7_pf6"] },
  // 事件解決（scene8 の追及）で提示することになる証拠品。
  // 画面には所持数だけを出し、何が該当するかは伏せる。
  evidence:[
    // 解決編を通すのに要る品だけを数える。
    // ・犯人を取り違えた分岐でしか出てこないもの（ペンダント）は入れない
    // ・叡留久と小出里亜のスマホは、どちらの場面でも一方を出せば通るので
    //   一枚ぶんだけ数える（小出里亜のスマホは叡留久のスマホより後に入る）
    // 経路Aはポットをミスリードとして扱うため、解決必須の証拠品には数えない。
    // 経路A：毒物／小出里亜のスマホ／ティーカップ／入館記録書／研究ノート／濡れた瓶／庭のセージ
    // 経路B：上記に湯沸かしポットとボールペンを加える。
    { label:"証拠品",
      ids: ["poison","koderia_phone","tea_cup","records","drag_book","bottle","garden_sage"],
      idsB:["poison","pot","koderia_phone","tea_cup","records","drag_book","bottle","garden_sage","ballpen"] },
    // 品物として手帳に並ばないもの。
    // 経路A
    //   s7_koderia_cup_test … 小出里亜のカップを指紋照合し、薬物反応を確認
    //   s7_fingerprint      … 観葉植物の鉢
    // 経路B
    //   s7_koderia_secret   … 小出里亜の癖（朱志香から聞く）
    //   s7_fingerprint      … キッチンのポット
    // 共通
    //   s7_jushika_tea      … 朱志香「お茶会の紅茶について」
    //   s7_juri_3           … 珠璃「紅茶を運んだことについて」
    //   s7_gimmick_lid      … 経路Bのみ：二階廊下の仕掛けの蓋
    { label:"証言・鑑識",
      flags: ["s7_koderia_cup_test","s7_fingerprint","s7_jushika_tea","s7_juri_3"],
      flagsB:["s7_koderia_secret","s7_fingerprint","s7_jushika_tea","s7_juri_3","s7_gimmick_lid"],
      flagInfo:{
        s7_koderia_cup_test:{ name:"小出里亜のカップの鑑定結果", text:"小出里亜の指紋が残るカップの縁から、薬物反応が確認された。" },
        s7_fingerprint:{ name:"観葉植物の鉢の鑑識結果", text:"鉢から毒性物質と指紋が検出された。" },
        s7_jushika_tea:{ name:"朱志香の証言：お茶会の紅茶", text:"お茶会で紅茶を淹れた人物と、そのときの手順についての証言。" },
        s7_juri_3:{ name:"珠璃の証言：紅茶を運んだこと", text:"淹れられた紅茶をダイニングへ運んだときの証言。" }
      },
      flagInfoB:{
        s7_koderia_secret:{ name:"小出里亜の癖に関する証言", text:"小出里亜が物を扱うときに見せる、特徴的な癖についての証言。" },
        s7_fingerprint:{ name:"ポットの鑑識結果", text:"お茶会で使われたポットから得られた鑑識情報。" },
        s7_jushika_tea:{ name:"朱志香の証言：お茶会の紅茶", text:"お茶会で紅茶を淹れた人物と、そのときの手順についての証言。" },
        s7_juri_3:{ name:"珠璃の証言：紅茶を運んだこと", text:"淹れられた紅茶をダイニングへ運んだときの証言。" },
        s7_gimmick_lid:{ name:"仕掛けの蓋の鑑識結果", text:"二階廊下の仕掛けの蓋から、微量の毒性成分が検出された。" }
      } },
    // 真エンド分岐に必要な5つ。何を指すかは伏せたいので見出しは「???」のまま。
    // （scene8 の条件は true_flag_mary && s7_king_yuzuki_record
    //   && base_ment_found && has_blueprint && has_old_key）
    // 設計図と地下への鍵は scene4（昼）でしか手に入らない。取り逃した周回ではバツ印で消し、
    // 押すと解放条件だけを出す。
    { label:"???", kind:"hidden", flags:["true_flag_mary","s7_king_yuzuki_record","base_ment_found","has_blueprint","has_old_key"],
      unlock:"f.has_blueprint==1 && f.has_old_key==1",
      lockNote:"昼間に条件達成の場合に解放",
      flagInfo:{
        true_flag_mary:{ name:"メアリーから聞いた過去", text:"メアリーが自分の過去について語った内容。" },
        s7_king_yuzuki_record:{ name:"舞黒邦夢の1936年の記録", text:"キング家が残した家具と、館で働き始めた結月について記された記録。" },
        base_ment_found:{ name:"サンルーム床下の空間", text:"サンルームの床板の下に、別の空間へ続くと思われる鍵穴が見つかった。" },
        has_blueprint:{ name:"舞黒館の設計図", text:"館の構造と、通常は見えない区画を確認できる設計図。" },
        has_old_key:{ name:"地下への鍵", text:"執務机の裏から見つかった古びた鍵。地下へと続く扉を開けるためのもの。" }
      } }
  ],

  rooms:[
    { id:"genkan", name:"玄関", floor:1, bg:"entrance_night.png", target:"*scene_genkan",
      spots:[
        { label:"記帳台", note:"宿泊者全員の入館記録", x:87, y:51,
          flag:"event_genkan", target:"*evt_genkan_record", get:true }
      ], chars:[] },

    // 館の外。夜の庭。薬学研究の本を手に入れてから来ると、偽聖女を見分けられる
    { id:"garden", name:"庭", floor:1, floorLabel:"屋外", bg:"garden_night.png", target:"*s7_garden",
      spots:[
        { label:"ハーブの花壇", note:"昼にセージが咲いていた一角", x:80, y:58,
          flag:"s7_garden_sage", target:"*s7_evt_garden_sage", get:true },
        { label:"花壇のふち",   note:"土に何かの跡がある",         x:22, y:72,
          flag:"s7_garden_soil", target:"*s7_evt_garden_soil" }
      ], chars:[] },

    { id:"living", name:"リビング", floor:1, bg:"living_night.png", target:"*s7_living",
      spots:[
        { label:"ソファのクッション", note:"隙間に何か挟まっている", x:33, y:59,
          flag:"s7_sofa", target:"*s7_evt_sofa", get:true },
        { label:"暖炉", note:"火は落ちている", x:67, y:54,
          flag:"s7_fireplace", target:"*s7_evt_fireplace" }
      ],
      chars:[
        { id:"reido", name:"零度警部", color:"#2f4f9e", initial:"零", topics:[
          { label:"死因について",           flag:"s7_reido_1", target:"*s7_reido_t1", target_r:"*s7_reido_t1r", cond:"true" },
          { label:"SNS情報について",         flag:"s7_reido_2", target:"*s7_reido_t2", target_r:"*s7_reido_t2r",
            cond:"f.s7_eruku_phone2==1", lock:"2台目のスマホを見つけると解放" },
          { label:"ポット調査について",       flag:"s7_reido_3", target:"*s7_reido_t3", target_r:"*s7_reido_t3r",
            cond:"f.s7_jushika_morning==1", lock:"朱志香に到着したころのことを聞くと解放" },
          { label:"アルコール実験を依頼する", flag:"s7_sage_done", target:"*s7_reido_t4", target_r:"*s7_reido_t4r",
            cond:"f.s7_sage_request==1", lock:"和人の助言後に解放" },
          { label:"庭のセージの鑑定を頼む",   flag:"s7_sage_match", target:"*s7_reido_t5", target_r:"*s7_reido_t5r",
            cond:"f.s7_garden_sage==1", lock:"庭で採取すると解放" },
          { label:"小出里亜さんのカップを調べる", flag:"s7_koderia_cup_test",
            target:"*s7_reido_t6", target_r:"*s7_reido_t6r",
            cond:"f.route_b!=1 && f.s7_koderia_cup_clue==1",
            lock:"メアリーさんのカップを鑑定すると解放" },
          // 信を得た回だけ。何度でも相談できるので、聞いた後も未調査の表示のまま（repeat）
          { label:"毒の摂取経路について相談する（時間を使いません）", flag:"s7_reido_hint_used",
            target:"*s7_reido_hint", target_r:"*s7_reido_hint", repeat:true,
            cond:"f.s6_trust_rank==2", lock:"零度警部の信を得ていると解放" }
        ] },
        { id:"jushika", name:"朱志香", color:"#1D9E75", initial:"朱", topics:[
          { label:"事件へのショック・小出里亜さんのこと", flag:"s7_jushika_1", target:"*s7_jushika_t1", target_r:"*s7_jushika_t1r", cond:"true" },
          { label:"到着したころの状況について",       flag:"s7_jushika_2", target:"*s7_jushika_t2", target_r:"*s7_jushika_t2r",
            cond:"f.has_entrance_record==1", lock:"入館記録書の入手後に解放" },
          { label:"お茶会の紅茶について",             flag:"s7_jushika_tea", target:"*s7_jushika_t4", target_r:"*s7_jushika_t4r", cond:"true" },
          { label:"新聞記事について",     flag:"s7_jushika_3", target:"*s7_jushika_t3", target_r:"*s7_jushika_t3r",
            cond:"f.s7_newspaper==1 && f.s7_arc_plate==1", lock:"新聞記事とプレートの確認後に解放" },
          { label:"「薬学研究」の書類について", flag:"s7_jushika_book", target:"*s7_jushika_t5", target_r:"*s7_jushika_t5r",
            cond:"f.s7_arc_inventory==1", lock:"資料室の整理リストを見つけると解放" }
        ] },
        { id:"juri", name:"珠璃", color:"#D85A30", initial:"珠", topics:[
          { label:"今の気持ち・和人について",   flag:"s7_juri_1", target:"*s7_juri_t1", target_r:"*s7_juri_t1r", cond:"true" },
          { label:"叡留久さんのスマホについて", flag:"s7_juri_2", target:"*s7_juri_t2", target_r:"*s7_juri_t2r",
            cond:"f.s7_eruku_phone==1", lock:"スマホの発見後に解放" },
          { label:"紅茶を運んだことについて",   flag:"s7_juri_3", target:"*s7_juri_t3", target_r:"*s7_juri_t3r",
            cond:"f.s7_jushika_tea==1", lock:"朱志香の証言の後に解放" }
        ] },
        { id:"mary", name:"メアリー", color:"#378ADD", initial:"メ", topics:[
          { label:"二人が亡くなったことについて",   flag:"s7_mary_1", target:"*s7_mary_t1", target_r:"*s7_mary_t1r", cond:"true" },
          { label:"紅茶を愛理にあげた理由",         flag:"s7_mary_2", target:"*s7_mary_t2", target_r:"*s7_mary_t2r",
            cond:"f.s7_exchange_topic==1", lock:"愛理の話を聞くと解放" },
          { label:"スーツケースの中の手紙について", flag:"s7_mary_3", target:"*s7_mary_t3", target_r:"*s7_mary_t3r",
            cond:"f.s7_bd_mary==1", lock:"手紙の発見後に解放" }
        ] }
      ] },

    { id:"dining", name:"ダイニング", floor:1, bg:"dining_night.png", target:"*s7_dining",
      spots:[
        { label:"食器棚",   note:"食器の裏に刻印", x:62, y:33,
          flag:"s7_dishes",       target:"*s7_evt_dishes" },
        { label:"テーブル", note:"お茶会の跡",     x:38, y:68,
          flag:"s7_dining_table", target:"*s7_evt_dining_table" }
      ], chars:[] },

    { id:"kitchen", name:"キッチン", floor:1, bg:"kitchen_night_after_incident.png", target:"*s7_kitchen",
      spots:[
        { label:"小出里亜さんのご遺体", note:"鑑識のシートが掛けられている", x:45, y:65,
          flag:"s7_koderia_body", target:"*s7_evt_koderia_body", poison:true, poisonFlag:"s7_pf1", get:true },
        { label:"コンロ",   note:"鑑識が入った跡",             x:15, y:68,
          flag:"s7_kitchen_stove",  target:"*s7_evt_kitchen_stove" },
        // 経路Aのみ。昼、叡留久が小出里亜のカップで紅茶を飲んでいる。指紋が残る。
        // 経路Bでは叡留久はカップに触れていないので、この手がかりは存在しない
        // （代わりに小出里亜のご遺体から、エプロンの口紅が出る）
        { label:"流しのカップ", note:"洗われずに置かれている",   x:52, y:30,
          flag:"s7_kitchen_cup", target:"*s7_evt_kitchen_cup",
          cond:"f.route_b!=1", poison:true, poisonFlag:"s7_pf6", get:true },
        // 経路Bのみ。珠璃が蓋を触っているので、ここに手がかりが残る
        { label:"ポット",   note:"お茶会で使われたもの",       x:84, y:34,
          flag:"s7_carpet", target:"*s7_evt_carpet", cond:"f.route_b==1", get:true }
      ], chars:[] },

    { id:"sunroom1", name:"サンルーム", floor:1, bg:"sunroom_night.png", target:"*s7_sunroom1",
      spots:[
        // 経路Bでは珠璃はサンルームを使えていないので、この跡は残らない
        { label:"床の乾いた跡", note:"何かをこぼした跡", x:58, y:89,
          flag:"s7_sun1_floor",  target:"*s7_evt_sun1_floor", cond:"f.route_b!=1", poison:true, poisonFlag:"s7_pf4", get:true },
        { label:"観葉植物の鉢", note:"薬学研究の本をもとに詳しく調べる", x:15, y:76,
          flag:"s7_sun1_plant", target:"*s7_evt_sun1_plant", cond:"f.s7_drag_book==1", poison:true, poisonFlag:"s7_pf5", get:true },
        { label:"床板の継ぎ目", note:"毒の痕跡を追って床を精査する", x:30, y:90,
          flag:"s7_sun1_floor2", target:"*s7_evt_sun1_floor2",
          cond:"f.s7_sun1_floor2_open==1",
          lock:"昼の探索で地下書斎を調べ、サンルームで事件の痕跡を詳しく調べると解放", get:true }
      ], chars:[] },

    { id:"rouka1", name:"廊下", floor:1, bg:"hallway_night_after_incident.png", target:"*s7_rouka1",
      spots:[
        { label:"叡留久さんのご遺体", note:"鑑識のシートが掛けられている", x:30, y:80,
          flag:"s7_eruku_body", target:"*s7_evt_eruku_body", poison:true, poisonFlag:"s7_pf2", get:true }
      ], chars:[] },

    // 宿泊部屋は「扉を選んで一部屋ずつ調べる」形にする。
    // hub:true の親カードを館マップに出し、subs の各室を扉選択画面に並べる
    { id:"bedroom", name:"宿泊部屋", floor:2, bg:"bedroom_night.png", target:"*s7_bedroom",
      hub:true, subs:["bd_main","bd_hozairo","bd_kazuto","bd_mary","bd_mashiro"],
      wingHint:"扉を選ぶと、その部屋に入って調査できます。愛理は真白姉妹の部屋で休んでいる。",
      spots:[], chars:[] },

    // 宿泊部屋のメインルーム。ここから各室の扉がつながっている
    { id:"bd_main", parent:"bedroom", name:"メインルーム", floor:2, bg:"bedroom_night.png",
      occupant:"共用スペース", door:"中", target:"*s7_bd_main",
      spots:[
        // 経路Bのみ。珠璃が「ボールペンを取りに」立った先がここ
        { label:"棚", note:"何か置き忘れられている", x:90, y:47,
          flag:"s7_main_shelf", target:"*s7_evt_main_shelf",
          cond:"f.route_b==1 && f.s7_kazuto_desk==1", get:true }
      ], chars:[] },

    { id:"bd_hozairo", parent:"bedroom", name:"穂在呂夫妻の部屋", floor:2, bg:"room_hoaro_night.png",
      occupant:"穂在呂 叡留久・珠璃", door:"A", target:"*s7_bd_hozairo",
      spots:[
        { label:"珠璃のスーツケース", note:"持ち手が濡れている", x:61, y:86,
          flag:"s7_bd_juri", target:"*s7_evt_bd_juri", get:true },
        { label:"叡留久のスーツケース", note:"まだ荷解きもされていない", x:38, y:84,
          flag:"s7_bd_eruku", target:"*s7_evt_bd_eruku",
          cond:"f.s7_phone_wiped==1", get:true }
      ], chars:[] },

    { id:"bd_kazuto", parent:"bedroom", name:"和人の部屋", floor:2, bg:"room_kazuto_night.png",
      occupant:"徐音 和人", door:"B", target:"*s7_bd_kazuto",
      spots:[
        { label:"和人のリュックサック", note:"薬と瓶と医学書", x:70, y:84,
          flag:"s7_bd_kazuto", target:"*s7_evt_bd_kazuto" },
        // 経路Bのみ。珠璃はここで偽聖女を扱っている
        { label:"和人の机",           note:"天板に拭き跡がある", x:80, y:60,
          flag:"s7_kazuto_desk", target:"*s7_evt_kazuto_desk",
          cond:"f.route_b==1", poison:true, poisonFlag:"s7_pf4", get:true }
      ], chars:[] },

    { id:"bd_mary", parent:"bedroom", name:"メアリーの部屋", floor:2, bg:"room_mary_night.png",
      occupant:"メアリー", door:"C", target:"*s7_bd_mary",
      spots:[
        { label:"メアリーのスーツケース", note:"強い香水の匂い", x:74, y:90,
          flag:"s7_bd_mary", target:"*s7_evt_bd_mary", get:true }
      ], chars:[] },

    // 愛理が寝かされている部屋。和人が付き添っているので二人ともここで話せる
    { id:"bd_mashiro", parent:"bedroom", name:"真白姉妹の部屋", floor:2, bg:"room_mashiro_night.png",
      occupant:"真歩流・愛理（和人が付き添い）", door:"D", target:"*s7_bd_mashiro",
      spots:[
        { label:"愛理のベッドサイド", note:"枕元に飲みかけのカップ", x:70, y:53,
          flag:"s7_bd_airi", target:"*s7_evt_bd_airi" }
      ],
      chars:[
        { id:"kazuto", name:"和人", color:"#5F5E5A", initial:"和", topics:[
          { label:"捜査について",               flag:"s7_kazuto_1", target:"*s7_kazuto_t1", target_r:"*s7_kazuto_t1r", cond:"true" },
          { label:"珠璃さんから聞いたこと",     flag:"s7_kazuto_2", target:"*s7_kazuto_t2", target_r:"*s7_kazuto_t2r",
            cond:"f.s7_kazuto_secret==1", lock:"珠璃の話を聞くと解放" },
          { label:"セージについての仮説", flag:"s7_kazuto_3_intro", target:"*s7_kazuto_t3_intro", target_r:"*s7_kazuto_t3_intror",
            cond:"f.s7_sage_hypothesis==1", lock:"三人の成分を考察すると解放" },
          { label:"不自然な液体・容器について", flag:"s7_kazuto_3", target:"*s7_kazuto_t3", target_r:"*s7_kazuto_t3r",
            cond:"f.s7_kazuto_3_intro==1 && f.s7_sage_request==0", lock:"セージの仮説を和人に相談すると解放" },
          { label:"実験結果について",           flag:"s7_kazuto_4", target:"*s7_kazuto_t4", target_r:"*s7_kazuto_t4r",
            cond:"f.s7_sage_done==1", lock:"アルコール実験の後に解放" }
        ] },
        { id:"airi", name:"愛理", color:"#c0699a", initial:"愛", bg:"event/airi_painful.png", topics:[
          { label:"お茶会の飲み物について", flag:"s7_airi_1", target:"*s7_airi_t1", target_r:"*s7_airi_t1r", cond:"true" },
          { label:"体を調べてもらう",       flag:"s7_airi_2", target:"*s7_airi_t2", target_r:"*s7_airi_t2r",
            cond:"f.s7_exchange_topic==1", lock:"愛理の話を聞くと解放", poison:true, poisonFlag:"s7_pf3" }
        ] }
      ] },

    { id:"sunroom2", name:"サンルーム", floor:2, bg:"sunroom_second_night.png", target:"*s7_sunroom2",
      spots:[
        { label:"古びた椅子",     note:"座るとキコキコ軋む", x:47, y:72,
          flag:"s7_sun2_chair", target:"*s7_evt_sun2_chair" }
      ], chars:[] },

    { id:"lounge", name:"談話室", floor:2, bg:"talk_room_night.png", target:"*s7_lounge",
      spots:[
        { label:"テーブル", note:"昼と変わらず整然と並んでいる", x:47, y:76,
          flag:"s7_lounge_table", target:"*s7_evt_lounge_table" },
        { label:"窓", note:"夜風が吹いている", x:25, y:27,
          flag:"s7_lounge_window", target:"*s7_evt_lounge_window" }
      ], chars:[] },

    { id:"archive", name:"資料室", floor:2, bg:"reference_room_night.png", target:"*s7_archive",
      spots:[
        { label:"出資者リスト", note:"地下増築工事の出資者一覧",   x:7, y:38,
          flag:"s7_arc_plate",  target:"*s7_evt_arc_plate" },
        { label:"訪問者記録",     note:"戦前の訪問者記録",           x:66, y:42,
          flag:"s7_arc_record", target:"*s7_evt_arc_record" },
        { label:"増築の冊子",     note:"「地下増築工事について」", x:45, y:60,
          flag:"s7_arc_route",  target:"*s7_evt_arc_route" },
        { label:"整理リスト",     note:"遺品整理のときの控えらしい", x:24, y:66,
          flag:"s7_arc_inventory", target:"*s7_evt_arc_inventory" }
      ], chars:[] },

    { id:"study", name:"執務室", floor:2, bg:"office_night.png", target:"*s7_study",
      spots:[
        { label:"本棚", note:"奥に古い紙束",           x:40, y:35,
          flag:"s7_study_cabinet", target:"*s7_evt_study_cabinet", get:true },
        { label:"執務椅子",     note:"昼に転んだ椅子",         x:75, y:52,
          flag:"s7_study_chair",   target:"*s7_evt_study_chair" }
      ], chars:[] },

    { id:"rouka2", name:"廊下", floor:2, bg:"hallway_second_night.png", target:"*s7_rouka2",
      spots:[
        { label:"ステンドグラス", note:"夜は色が沈んで見える", x:30, y:38,
          flag:"s7_rouka2_glass", target:"*s7_evt_rouka2_glass" },
        // 経路Bのみ。昼に皆で開けた仕掛け
        { label:"壁の真鍮の蓋", note:"昼に開けた仕掛け", x:38, y:60,
          flag:"s7_gimmick_lid", target:"*s7_evt_gimmick_lid",
          cond:"f.route_b==1 && f.s7_pen_logic==1", poison:true, poisonFlag:"s7_pf5", get:true }
      ], chars:[] }
  ]
};
[endscript]
[return]
