;==== init_item_data.ks ====
; ゲーム起動時（first.ksなど）に [call storage="init_item_data.ks"] で呼び出してください

[iscript]
// マスタデータ定義
// ruby: 名前の上に表示するフリガナを追加

f.master_data = [
    {
        id: "bottle",
        type: "item",
        name: "空き瓶",
        ruby: "", 
        image: "bottle.png", 
        text_default: "珠璃のカバンに入っていた瓶。内部は濡れていて、濡れてからそれほど時間が経っていない。中身はアルコール消毒液。",
        text_secret: ""
    },
    {
        id: "ballpen",
        type: "item",
        route: "b",
        name: "ボールペン",
        ruby: "",
        image: "ballpen.png",
        text_default: "宿泊部屋のメインルームの棚に置き忘れられていたボールペン。二階の仕掛けを開けるのに使われた。",
        text_secret: "きれいに拭き取られていて、指紋がひとつも残っていない。握るところは皆が見ていたはずなのに。"
    },
    {
        id: "glass_blue",
        type: "item",
        name: "青い硝子",
        ruby: "あおいがらす",
        image: "blue_grass.png",
        text_default: "1階廊下の飾り棚にあった、真鍮縁の青い硝子板。舞黒邦夢が館に仕込んだ仕掛けの部品らしい。",
        text_secret: ""
    },
    {
        id: "glass_red",
        type: "item",
        name: "赤い硝子",
        ruby: "あかいがらす",
        image: "red_grass.png",
        text_default: "ダイニングの壁の絵の裏に隠されていた、真鍮縁の赤い硝子板。舞黒邦夢が館に仕込んだ仕掛けの部品らしい。",
        text_secret: ""
    },
    {
        id: "glass_green",
        type: "item",
        name: "緑の硝子",
        ruby: "みどりのがらす",
        image: "green_grass.png",
        text_default: "和人の部屋の書棚の奥に隠されていた、真鍮縁の緑の硝子板。舞黒邦夢が館に仕込んだ仕掛けの部品らしい。",
        text_secret: ""
    },
    {
        id: "perfume",
        type: "item",
        name: "香水の瓶",
        ruby: "こうすいのびん",
        image: "perfume.png",
        text_default: "メアリーの手作り香水。素材からこだわっている一品。香水はイギリスで作られたものらしい。",
        text_secret: ""
    },
    {
        id: "records",
        type: "item",
        name: "入館記録書",
        ruby: "",
        image: "admission_record.png", 
        text_default: "舞黒館の入館記録を記載するノート。穂在呂夫妻が12:20、真白姉妹が12:55、全員そろったのが13:03。",
        text_secret: ""
    },
    {
        id: "pot",
        type: "item",
        name: "湯沸かしポット",
        ruby: "",
        image: "pot.png", 
        text_default: "お茶を入れるために使った湯沸かしポット。",
        text_secret: ""
    },
    {
        id: "tea_cup",
        type: "item",
        name: "ティーカップ",
        ruby: "",
        image: "tea_cup.png",
        text_default: "メアリーが愛理に譲った紅茶のカップ。メアリーは香りが好みではないと言って口をつけなかった。",
        text_secret: "メアリーが手にした後、そのまま愛理へ渡っている。"
    },
    {
        id: "letter",
        type: "item",
        name: "手紙",
        ruby: "",
        image: "letter.png", 
        text_default: "洋風の便せん。宛名が不明の手紙。",
        text_secret: "「親戚のことが知りたければ、宿泊イベントに参加せよ」と書かれている。"
    },
    {
        id: "eruku_phone",
        type: "item",
        name: "叡留久のスマホ",
        ruby: "",
        image: "eruku_phone.png", 
        text_default: "叡留久のスマホ。",
        text_secret: "リビングで見つかった一台は中身が初期化されており、スーツケースからもう一台が見つかった。エミリーという女性とのやり取りだけが残されている。"
    },
    {
        id: "koderia_phone",
        type: "item",
        name: "小出里亜のスマホ",
        ruby: "",
        image: "koderia_phone.png", 
        text_default: "小出里亜のスマホ。",
        text_secret: "SNSのアカウントを確認するとエミリーという名前で叡留久とやり取りをしている。"
    },
    {
        id: "key",
        type: "item",
        name: "鍵",
        ruby: "",
        image: "old_key.png", 
        text_default: "舞黒館にあった古い鍵。",
        text_secret: "地下へと続く扉を開ける鍵だった。"
    },
    {
        id: "statue",
        type: "item",
        name: "石碑",
        ruby: "",
        image: "statue.png", 
        text_default: "メイフェア・ガーデンの奥にあった石碑。「海の向こうのかの地から　感じているのはあなたのぬくもり」「決して消えることのない想いを　静かに載せる」",
        text_secret: ""
    },
    {
        id: "photo",
        type: "item",
        name: "富礼知夫妻の写真",
        ruby: "",
        image: "photo.png", 
        text_default: "朱志香と夫の写真。朱志香の夫が亡くなる半年前に撮影された。",
        text_secret: "夫の富礼知は不動産業を営んでおり、その一族はかつて舞黒館の地下増築工事に関わっていた。"
    },
    {
        id: "lip",
        type: "item",
        name: "口紅",
        ruby: "",
        image: "lipstick.png", 
        text_default: "ピンク色の可愛らしい口紅。",
        text_secret: "小出里亜のもの。叡留久のことが好きで、彼からプレゼントされたものらしい。"
    },
    {
        id: "blueprint",
        type: "item",
        name: "設計図",
        ruby: "",
        image: "blueprint.png", 
        text_default: "古い設計図。舞黒館の地下について記述がある。「交流を拒むものは立ち入ること叶わず。交流を望む者には道が示される。示された道で根源的欲求を満たさんと動けば、後は望みを得るのみ」",
        text_secret: ""
    },
    {
        id: "pendant",
        type: "item",
        name: "ペンダント",
        ruby: "",
        image: "pendant.png", 
        text_default: "真歩流がメアリーからもらったペンダント。メアリーが祖母から受け継いだもの。80年以上前の代物。真歩流が持つと何かが起きる……。",
        text_secret: "真歩流がペンダントを持っていると、誰かの声が聞こえることがある。"
    },
    {
        id: "poison",
        type: "item",
        name: "毒物",
        ruby: "",
        image: "poison.png", 
        text_default: "小出里亜と叡留久を死に追いやった毒物。特殊なセージに強いアルコールを合わせることで毒性が発生する。",
        text_secret: ""
    },
    {
        id: "daught_saint",
        type: "item",
        name: "偽聖女",
        ruby: "",
        image: "daught_saint.png", 
        text_default: "偽聖女と呼ばれるセージの改良品種。脳機能改善のために開発されたが、アルコールと混ぜると呼吸器官及び消化器官に異常が現れる毒素を出す。",
        text_secret: ""
    },
    {
        id: "garden_sage",
        type: "item",
        name: "庭のセージ",
        ruby: "",
        image: "sage.png",
        text_default: "メイフェア・ガーデンの花壇から採った一株。薬学研究の本にある偽聖女の記述と、葉の形も匂いも一致している。",
        text_secret: "簡易分析では、二人の遺体とポットから検出された成分に近しいものが出ている。品種の同定は鑑識が持ち帰って調査中。花壇には株がひとつ抜き取られた跡が残っていた。"
    },
    {
        id: "drag_book",
        type: "item",
        name: "薬学研究の本",
        ruby: "",
        image: "drag_book.png", 
        text_default: "薬の研究について書かれている本。徐音和人の母親の資料を書き写した写本。薬学の専門書で、難しい内容が書かれている。偽聖女は弱い酸性と混ぜることで少しずつ中和されていくと書いてある。",
        text_secret: ""
    },
    {
        id: "old_photo",
        type: "item",
        name: "古い写真",
        ruby: "ふるいしゃしん",
        image: "old_photo.png",
        text_default: "1935年に撮られた写真のようだ。写真の裏に文字が書いてある。舞黒邦夢と親交のあった人たちのようだ。",
        text_secret: ""
    },
    {
        id: "picture",
        type: "item",
        name: "絵画",
        ruby: "かいが",
        image: "picture.png",
        text_default: "縁に「舞黒邦夢肖像」と書いてある。どうやら舞黒邦夢さんのようだ。湖が美しい。絵の裏に何かが書いてある。\n青き光は真っすぐな道の中に……。",
        text_secret: ""
    },
    {
        id: "news_paper",
        type: "item",
        name: "新聞記事",
        ruby: "",
        image: "news_paper.png", 
        text_default: "20年近く前の新聞記事。「舞黒館を購入した家の娘が失踪」",
        text_secret: ""
    },
    {
        id: "chara_01",
        type: "chara",
        name: "真白 真歩流",
        ruby: "ましろ まほる",
        image: "mahoru/normal.png",
        text_default: "明るくて社交的な大学3年生。何事も形から入る私服ダサい系女子。金魚が大好きで、マスコットを持っている。英語はネイティブと遜色なく話せるが、全く読めないし書けない。妹のような綺麗さとスタイルの良さに憧れている。",
        text_secret: ""
    },
    {
        id: "chara_02",
        type: "chara",
        name: "真白 愛理",
        ruby: "ましろ あいり",
        image: "airi/normal.png",
        text_default: "お洒落でスタイル抜群の大学1年生の真歩流の妹。恋愛脳で理性的。論文をすべて英語で書けるくらいのレベルで、難解な表現も読み解くことができる。しかし、幼児とすらまともに英語で会話できない。真歩流の人を信じる強さを羨ましいと思っている。",
        text_secret: ""
    },
    {
        id: "chara_03",
        type: "chara",
        name: "富礼知 朱志香",
        ruby: "ふれち じゅしか",
        image: "jushika/normal.png",
        text_default: "舞黒館を管理する女性46歳。半年前に夫が亡くなり、舞黒館を引き継ぐ。今回の宿泊イベントを企画した。",
        text_secret: "実の娘が行方不明で、生きていればメアリーや小出里亜くらいの年齢になるらしい。"
    },
    {
        id: "chara_04",
        type: "chara",
        name: "灰音 小出里亜",
        ruby: "はいね こでりあ",
        image: "koderia/normal.png",
        text_default: "料理、洗濯、掃除、家計簿管理まで何でもできるスペシャルなメイドさん。",
        text_secret: "熱いものに触れると咄嗟に指をなめる癖がある。"
    },
    {
        id: "chara_05",
        type: "chara",
        name: "穂在呂 叡留久",
        ruby: "ほあろ えるく",
        image: "eruku/normal.png",
        text_default: "結婚して1年の夫婦の旦那でナイスガイの28歳。健康食品会社を起業し、順風満帆に事業が進んでいる。新しい事業プランを考え中。",
        text_secret: "妻の珠璃には頭が上がらない。休暇中でも仕事の連絡だけは手放せない性分らしい。"
    },
    {
        id: "chara_06",
        type: "chara",
        name: "穂在呂 珠璃",
        ruby: "ほあろ じゅり",
        image: "juri/normal.png",
        text_default: "結婚して1年の夫婦の美人妻の27歳。アパレルの個人ブランドを出しており、ヨーロッパを中心に高い評価を受けている。",
        text_secret: "SNSが好きでよく発信をしているらしい。"
    },
    {
        id: "chara_07",
        type: "chara",
        name: "メアリー・キング",
        ruby: "",
        image: "mary/normal.png",
        text_default: "イギリスから来た24歳の女性。香水を作るのが趣味。",
        text_secret: "宛名が不明の手紙で舞黒館に呼び出された。"
    },
    {
        id: "chara_08",
        type: "chara",
        name: "徐音 和人",
        ruby: "じょおん かずと",
        image: "kazuto/normal.png",
        text_default: "医学部の学生。21歳。冷静で落ち着いており、興味のあること以外には無頓着。",
        text_secret: "母親が亡くなったことがきっかけで医者を志す。"
    },
    {
        id: "chara_09",
        type: "chara",
        name: "零度 警部",
        ruby: "れいど けいぶ",
        image: "reido/normal.png",
        text_default: "横浜中央署で勤務をしている警部。冷静沈着で勘が鋭い。インテリ風に見えるが情に厚い。非番であったために、舞黒館へと来ることになった。お酒に弱く、カクテル一杯で急性アルコール中毒になる。",
        text_secret: ""
    },
    {
        id: "chara_10",
        type: "chara",
        name: "真白 奢禄",
        ruby: "ましろ しゃろく",
        image: "sharoku/normal.png",
        text_default: "真歩流と愛理の父親。コンサルティング会社を経営しており、半年前から行方不明になっている。",
        text_secret: ""
    },
     {
        id: "chara_11",
        type: "chara",
        name: "舞黒 邦夢",
        ruby: "まいくろ ほうむ",
        image: "maicro/normal.png",
        text_default: "政治家かつ、戦争に反対していた資産家。1975年没。イギリスとフランスに留学をしており、そこで西洋の文化を学び、西欧の文化を取り入れて、日本の文化を発展させることに思いを馳せる。留学から帰ってきた後は、政治家として海外との交渉を行っていた。しかし、政治が腐敗していたこともあり、政治家を辞めて資産家として商業にも携わりながら、海外の要人たちと戦争を回避し、各国の連携を強めることに尽力する。海外の友人と会うのに便利なため、横浜山手に洋館を建てて暮らしていた。",
        text_secret: "1930年に舞黒館に地下室を作る。"
    }
];

// 所持フラグ初期化
// f.status が未定義なら作成し、master_data の全アイテムのうち
// まだ登録されていないものだけを初期化する。
// これにより、アイテムを追加・変更して再callしても
// 既存フラグを壊さず新規アイテムだけ安全に追加できる。
if(typeof f.status === 'undefined'){
    f.status = {};
}
for(var i=0; i<f.master_data.length; i++){
    var id = f.master_data[i].id;
    if(typeof f.status[id] === 'undefined'){
        f.status[id] = { owned: false, secret: false };
    }
}

//---------------------------------------------------------------
// 図鑑の記録
//   経路A・経路Bで手に入るものが違うので、一周では全部そろわない。
//   一度でも手にしたものを sf.seen_items に残しておき、
//   タイトル画面の「記録」から読み返せるようにする。
//     1 … 手に入れた   2 … 隠された内容まで見た
//---------------------------------------------------------------
window.SEEN = {
    kag: function(){ return window.TYRANO ? window.TYRANO.kag : tyrano.plugin.kag; },
    store: function(){
        var sfv = window.SEEN.kag().variable.sf;
        if(!sfv.seen_items || typeof sfv.seen_items !== "object"){ sfv.seen_items = {}; }
        return sfv.seen_items;
    },
    // f.status の内容を図鑑へ写す。増えたときだけ保存する
    sync: function(){
        try {
            var kag = window.SEEN.kag();
            var st = kag.stat.f.status || {};
            var seen = window.SEEN.store();
            var changed = false;
            for(var k in st){
                if(!st[k]) { continue; }
                var lv = st[k].secret ? 2 : (st[k].owned ? 1 : 0);
                if(lv > (seen[k] || 0)){ seen[k] = lv; changed = true; }
            }
            if(changed){ kag.saveSystemVariable(); }
        } catch(e){}
    },
    level: function(id){ return window.SEEN.store()[id] || 0; },
    count: function(){
        var seen = window.SEEN.store(), n = 0;
        for(var k in seen){ if(seen[k] > 0){ n++; } }
        return n;
    }
};
[endscript]
[return]
