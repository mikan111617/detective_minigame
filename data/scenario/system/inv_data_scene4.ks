;===============================================================================
; inv_data_scene4.ks  ―― scene4（館内調査）の章データ
; [call storage="inv_data_scene4.ks"] で読み込み、scene4 の頭で [inv_set chapter="s4"]
;===============================================================================

[iscript]
f.INV_DATA.s4 = {
  title:      "舞黒館 ― 父の足取り",
  startMin:   990,          // 16:30
  endMin:     1080,         // 18:00（90分 ÷ 3分 = 30回）
  endLabel:   "夕食まで残り",
  exitLabel:  "探索を終える",
  hint:       "半年前に舞黒館を訪れた父の記録を追いながら、館そのものも調べてみましょう。",
  mapBg:      "hallway.png",      // 館マップの背景
  step:       3,
  // 空振り（調べ直し・仕掛けの失敗・部屋の移動）では時間が進まないので、その旨を出す
  stepNote:   "新しいことがわかると3分経過します。調べ直しや移動では進みません。",
  storage:        "scene4.ks",
  hubTarget:      "*investigation_start",
  dispatchTarget: "*dispatch_from_map",
  destVar:    "map_dest",
  floorVar:   "active_floor",
  counter:    { label:"見つけた手がかり" },
  // 館の仕掛けの進行表示。何を指すかは伏せ、進んだ数だけを見せる。
  // 見出しは reveal を満たす（＝作中で二人がそれを知る）まで "???" のまま。
  // 「設計図」「地下への鍵」を最初から出すと、この時点では先の展開のネタバレになる。
  evidence:[
    // 父の足取り：「来館（記帳台）」「館について調べていた」
    //   「模型で地下の増築を知る（資料室の模型を鍵で調べる）」「地下書斎の入口を見つける」の四段階。
    { label:"父の足取り", reveal:"true",
      flags:["father_visit_found","father_research_found","event_arc_route","hidden_study_entrance_found"] },
    // ラジオで四桁を聞く → サンルーム2Fの暖炉のダイヤル錠 → 設計図
    { label:"四桁の数字", reveal:"f.radio_code_known==1",
      flags:["radio_code_known","has_blueprint"] },
    // 三色の硝子を集める → 資料室で重ねる → 執務机から古びた鍵
    { label:"三色の硝子",
      reveal:"f.event_arc_shelf==1 || f.glass_blue==1 || f.glass_red==1 || f.glass_green==1",
      flags:["glass_blue","glass_red","glass_green","glass_solved","has_old_key"] }
  ],

  rooms:[
    { id:"genkan", name:"玄関", floor:1, bg:"entrance.png", target:"*scene_genkan",
      spots:[
        { label:"記帳台", note:"宿泊者全員の入館記録", x:87, y:51,
          flag:"event_genkan", target:"*evt_genkan_record", get:true }
      ], chars:[] },

    { id:"living", name:"リビング", floor:1, bg:"living.png", target:"*scene_living",
      spots:[
        // 経路Bでは、口紅はお茶会で叡留久が拾っている。ここには落ちていない
        { label:"ソファ", note:"クッションの隙間が気になる", x:20, y:66,
          flag:"event_sofa", target:"*evt_sofa", cond:"f.route_b!=1", get:true },
        { label:"暖炉", note:"作りをよく見てみる", x:67, y:54,
          flag:"event_fireplace", target:"*evt_fireplace" }
      ],
      chars:[
        { id:"eruku", name:"叡留久", color:"#BA7517", initial:"叡",
          present:"f.event_hercule_1==0 || f.event_kitchen_lip==1",
          topics:[
            { label:"仕事のことを聞く",     flag:"event_hercule_1", target:"*evt_hercule", cond:"true" },
            { label:"散策の後の様子を聞く", flag:"event_hercule_2", target:"*evt_hercule",
              cond:"f.event_hercule_1==1 && f.event_kitchen_lip==1", lock:"口紅を渡した後に解放" }
          ] },
        { id:"mary", name:"メアリー", color:"#378ADD", initial:"メ",
          topics:[
            { label:"ペンダントと親戚のこと", flag:"event_mary_1", target:"*evt_mary", cond:"true" },
            { label:"参加した本当の理由",     flag:"event_mary_2", target:"*evt_mary",
              cond:"f.event_mary_1==1 && (f.event_arc_record==1 || f.event_dishes==1)",
              lock:"館の記録を調べると解放" },
            { label:"手作りの香水のこと",     flag:"event_mary_perfume", target:"*evt_mary_perfume",
              cond:"f.event_bd_mary==1",
              lock:"メアリーのスーツケースを調べると解放" }
          ] }
      ] },

    { id:"dining", name:"ダイニング", floor:1, bg:"dining.png", target:"*scene_dining",
      spots:[
        { label:"食器棚",   note:"当時の食器が並んでいる", x:62, y:33,
          flag:"event_dishes", target:"*evt_dishes" },
        { label:"テーブル", note:"朱志香が拭いていた",     x:38, y:68,
          flag:"evt_dining_table", target:"*evt_dining_table" },
        { label:"壁の絵",   note:"額の位置が少しずれている", x:46, y:35,
          flag:"event_dining_picture", target:"*evt_dining_picture", get:true }
      ],
      chars:[
        { id:"jushika", name:"朱志香", color:"#1D9E75", initial:"朱",
          topics:[
            { label:"半年前の父について聞く", flag:"event_shurika_father", target:"*evt_shurika_father", cond:"true" },
            { label:"執務室でのことを話す",   flag:"event_shurika", target:"*evt_shurika", cond:"true" },
            { label:"舞黒邦夢さんについて",   flag:"event_kunimu",  target:"*evt_shurika_kunimu",
              cond:"f.event_shurika==1", lock:"一度話した後に解放" },
            // 模型を見せてもらう会話は、地下へ通じる導線そのもの。
            // 設計図と古びた鍵の両方を手にしてから解放する
            //（模型 → 談話室のずれ → 地下書斎、という順路の入口になるため）
            { label:"資料室の模型について", note:"館を示す図と古い鍵を手に入れると解放" ,  flag:"study_model",   target:"*evt_shurika_model",
              cond:"f.event_kunimu==1 && f.event_arc_record==1 && f.has_blueprint==1 && f.has_old_key==1",
              lock:"館の仕掛けをどちらも解き明かすと解放" }
          ] }
      ] },

    { id:"kitchen", name:"キッチン", floor:1, bg:"kitchen.png", target:"*scene_kitchen",
      spots:[
        { label:"テーブル", note:"夕食の準備が進んでいる", x:75, y:75,
          flag:"event_kitchen_island", target:"*evt_kitchen_island" },
        { label:"コンロと棚",         note:"年代物の鋳鉄コンロ",     x:15, y:75,
          flag:"event_kitchen_stove", target:"*evt_kitchen_stove" }
      ],
      chars:[
        { id:"koderia", name:"小出里亜", color:"#D4537E", initial:"里",
          topics:[
            { label:"手に取っていた小瓶のこと", flag:"event_ria_1", target:"*evt_ria", cond:"true" },
            { label:"メイドになった経緯",       flag:"event_ria_2", target:"*evt_ria",
              cond:"f.event_ria_1==1", lock:"一度話した後に解放" }
          ] }
      ],
      actions:[
        { label:"口紅を渡す", flag:"event_kitchen_lip", target:"*evt_kitchen_lip",
          cond:"f.route_b!=1 && f.has_lipstick==1 && f.event_kitchen_lip==0" },
        // 経路B。渡す口紅を持っていないので、リビングを出た叡留久を追う形で入る
        { label:"キッチンの様子を見る", flag:"event_kitchen_lip", target:"*evt_kitchen_lip",
          cond:"f.route_b==1 && f.event_hercule_1==1 && f.event_kitchen_lip==0",
          lock:"叡留久がリビングを離れた後に解放" }
      ] },

    { id:"sunroom1", name:"サンルーム", floor:1, bg:"sunroom.png", target:"*scene_sunroom1",
      spots:[
        { label:"テーブル",     note:"陽当たりのいい席",       x:50, y:67,
          flag:"event_sun1_table", target:"*evt_sun1_table" },
        { label:"観葉植物",     note:"かなり大きい鉢",         x:15, y:76,
          flag:"event_sun1_plant", target:"*evt_sun1_plant" }
      ],
      chars:[
        { id:"juri", name:"珠璃", color:"#D85A30", initial:"珠",
          topics:[
            { label:"サンルームのことを聞く", flag:"event_juri", target:"*evt_juri", cond:"true" }
          ] }
      ] },

    // 通路だが、階段脇の飾り棚に青い硝子がはまっている。
    // 「調査対象なし」だと足を運ばれないので visitFlag 表示にしておく
    { id:"rouka1", name:"廊下", floor:1, bg:"hallway.png", target:"*scene_rouka1",
      visitFlag:"event_airi_hall",
      spots:[], chars:[ { id:"airi", name:"愛理", color:"#7F77DD", initial:"愛", topics:[] } ] },

    // 宿泊部屋は「扉を選んで一部屋ずつ調べる」形にする。
    // hub:true の親カードを館マップに出し、subs の各室を扉選択画面に並べる
    { id:"bedroom", name:"宿泊部屋", floor:2, bg:"bedroom.png", target:"*scene_bedroom",
      hub:true, subs:["bd_hozairo","bd_kazuto","bd_mary","bd_mashiro"],
      wingHint:"扉を選ぶと、その部屋に入って調査できます。",
      spots:[], chars:[] },

    { id:"bd_hozairo", parent:"bedroom", name:"穂在呂夫妻の部屋", floor:2, bg:"room_hoaro.png",
      occupant:"穂在呂 叡留久・珠璃", door:"A", target:"*scene_bd_hozairo",
      spots:[
        { label:"珠璃のスーツケース", note:"持ち手だけが濡れている", x:61, y:86,
          flag:"event_bd_juri", target:"*evt_bd_juri" }
      ], chars:[] },

    { id:"bd_kazuto", parent:"bedroom", name:"和人の部屋", floor:2, bg:"room_kazuto.png",
      occupant:"徐音 和人", door:"B", target:"*scene_bd_kazuto",
      spots:[
        { label:"和人のリュック", note:"几帳面に置かれている", x:70, y:84,
          flag:"event_bd_kazuto", target:"*evt_bd_kazuto" },
        { label:"和人の書棚",     note:"背表紙の並びが妙だ",   x:10, y:35,
          flag:"event_bd_kazuto_shelf", target:"*evt_bd_kazuto_shelf", get:true }
      ], chars:[] },

    { id:"bd_mary", parent:"bedroom", name:"メアリーの部屋", floor:2, bg:"room_mary.png",
      occupant:"メアリー", door:"C", target:"*scene_bd_mary",
      spots:[
        { label:"メアリーのスーツケース", note:"花の香りが漂う", x:74, y:90,
          flag:"event_bd_mary", target:"*evt_bd_mary" },
        { label:"机",                     note:"窓際の書き物机", x:17, y:57,
          flag:"event_bd_mary_desk", target:"*evt_bd_mary_desk", get:true }
      ], chars:[] },

    { id:"bd_mashiro", parent:"bedroom", name:"真白姉妹の部屋", floor:2, bg:"room_mashiro.png",
      occupant:"真歩流・愛理", door:"D", target:"*scene_bd_mashiro",
      spots:[
        { label:"自分たちの荷物", note:"朝に置いたままのバッグ", x:59, y:89,
          flag:"event_bd_mashiro", target:"*evt_bd_mashiro" },
        { label:"本棚",           note:"古い蔵書が並んでいる",   x:50, y:30,
          flag:"event_bd_mashiro_shelf", target:"*evt_bd_mashiro_shelf", get:true }
      ], chars:[] },

    { id:"sunroom2", name:"サンルーム", floor:2, bg:"sunroom_second.png", target:"*scene_sunroom2",
      spots:[
        { label:"暖炉",           note:"立派な造りの暖炉",   x:70, y:55,
          flag:"event_sun2_fireplace", target:"*evt_sun2_fireplace", get:true },
        { label:"ふかふかの椅子", note:"座るとふわっとする", x:47, y:72,
          flag:"event_sun2_check", target:"*evt_sun2_chair" }
      ], chars:[] },

    { id:"lounge", name:"談話室", floor:2, bg:"talk_room.png", target:"*scene_lounge",
      spots:[
        { label:"模型と部屋のずれを確かめる", note:"窓側の奥行きが模型と合わない", x:36, y:50,
          flag:"event_lounge_hidden_search", target:"*evt_lounge_hidden_search",
          cond:"f.has_blueprint==1 && f.has_old_key==1 && f.event_arc_route==1 && f.hidden_study_entered!=1", get:true },
        { label:"飾り棚", note:"扉つきの戸棚がある", x:75, y:54,
          flag:"event_lounge_shelf", target:"*evt_lounge_shelf", get:true }
      ], chars:[] },

    { id:"archive", name:"資料室", floor:2, bg:"reference_room.png", target:"*scene_archive",
      spots:[
        { label:"出資者リスト", note:"「地下増築工事 出資者一覧」", x:7, y:38,
          flag:"event_arc_plate",  target:"*evt_arc_plate" },
        { label:"資料閲覧簿", note:"誰がどの資料を閲覧したかの記録", x:66, y:45,
          flag:"event_arc_access", target:"*evt_arc_access",
          cond:"f.father_visit_found==1", get:true },
        { label:"記録表",         note:"「戦前の訪問者記録」",       x:36, y:45,
          flag:"event_arc_record", target:"*evt_arc_record" },
        { label:"舞黒館の模型", note:"改築時の館を再現した古い模型", x:50, y:63,
          flag:"event_arc_route",  target:"*evt_arc_route", cond:"f.study_model==1" },
        { label:"上段の本棚",     note:"はめ込むための窪みがある", x:42, y:16,
          flag:"event_arc_shelf",  target:"*evt_arc_shelf" }
      ],
      chars:[
        { id:"kazuto", name:"和人", color:"#5F5E5A", initial:"和",
          topics:[
            { label:"参加した理由を聞く", flag:"event_arc_kazuto", target:"*evt_arc_kazuto", cond:"true" }
          ] }
      ] },

    { id:"study", name:"執務室", floor:2, bg:"office.png", target:"*scene_study",
      lock:"f.study_unlocked==1", lockNote:"朱志香の許可が必要",
      spots:[
        { label:"建築図面一式", note:"舞黒館の正式な建築図面", x:40, y:48,
          flag:"event_study_drawings", target:"*evt_study_drawings",
          cond:"f.study_unlocked==1", get:true },
        { label:"古い資料", note:"大量の資料が詰まっている", x:60, y:35,
          flag:"event_study_cabinet", target:"*evt_study_cabinet" },
        { label:"執務机",       note:"引き出しに鍵穴がある",     x:58, y:66,
          flag:"event_study_desk",  target:"*evt_study_desk", get:true },
        { label:"執務椅子",     note:"立派な椅子",       x:75, y:52,
          flag:"event_study_chair", target:"*evt_study_chair" }
      ], chars:[] },

    { id:"rouka2", name:"廊下", floor:2, bg:"hallway_second.png", target:"*scene_rouka2",
      passage:true, spots:[], chars:[] }
  ]
};
[endscript]
[return]
