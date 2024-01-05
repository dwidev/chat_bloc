import 'package:flutter/material.dart';

import '../nearbypeople/pages/nearby_people_card_view.dart';
import 'lib/cards_animations.dart';
import 'lib/swipe_cards.dart';

class TestSwipePage extends StatefulWidget {
  const TestSwipePage({super.key});

  @override
  State<TestSwipePage> createState() => _TestSwipePageState();
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color});
}

class _TestSwipePageState extends State<TestSwipePage> {
  final dummyUsers = [
    "https://cdn0-production-images-kly.akamaized.net/2sZ7OFhHk62_dwkBylWa1VV9MV0=/1200x1200/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/1266483/original/036388400_1466096813-michelle_ziudith-29.jpg",
    "https://a-cdn.sindonews.net/dyn/620/content/2016/07/01/187/1121326/michelle-ziudith-rizky-nazar-habiskan-libur-lebaran-bersama-muO-thumb.jpg",
    "https://img.inews.co.id/media/1200/files/inews_new/2022/03/16/michelle_ziudith.jpg",
    "https://cdn1-production-images-kly.akamaized.net/hM7iEJntxJBnU_TJYnMXNGN42EU=/469x625/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/4276653/original/017304400_1672324118-WhatsApp_Image_2022-12-29_at_21.27.55.jpeg",
    "https://cdn1-production-images-kly.akamaized.net/gquSZxspScHVCTVcNxk03ertabk=/469x625/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/1237206/original/d2b3ee2e7b6b98f76f0e5691e74a21f0-002850000_1463565146-Untitled-19.jpg",
    "https://cdn0-production-images-kly.akamaized.net/fGERGW_WjF2JoYmosX8SGcFk4ZM=/800x1066/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/2537426/original/015346000_1545027642-20181216144909_IMG_5220-01.jpeg",
    "https://imgsrv2.voi.id/MrsSS3zPxcxhUj29C3xuZVn6YYAXtGTr_HGBWfL57tg/auto/1200/675/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yMjcyMDYvMjAyMjExMTQxMDM4LW1haW4uY3JvcHBlZF8xNjY4Mzk3MTU1LmpwZWc.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/8/85/Michelle_Ziudith_on_Interview_GoGirl_TV.jpg",
    "https://www.wowkeren.com/display/images/photo/2019/09/11/00272551.jpg",
    "https://o-cdn-cas.sirclocdn.com/parenting/images/film-michelle-ziudith.width-800.format-webp.webp",
    "https://cdns.diadona.id/diadona.id/resources/photonews/2022/12/05/74627/664xauto-trending-di-19-negara-ini-10-pesona-michelle-ziudith-saat-perankan-sosok-laura-di-series-kupu-kupu-malam-2212057-002.jpg",
    "https://cdn-brilio-net.akamaized.net/webp/news/2022/02/28/224036/1680308-5-rahasia-kecantikan-michelle-ziudith-pakai-santan-untuk-serum-rambut.jpg",
    "https://img.okezone.com/okz/500/library/images/2020/12/15/v9cwlbsxnlkbwcyrrkho_20210.jpg",
    "https://img.okezone.com/content/2023/01/20/194/2749857/ulang-tahun-ke-28-begini-6-tampilan-awet-muda-michelle-ziudith-3Ll1FpWOVj.jpg",
    "https://file.indonesianfilmcenter.com/uploads/2019-08/michelle-ziudith1.jpg",
  ];

  late final List<SwipeItem> _swipeItems = [];

  late MatchEngine _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    for (int i = 0; i < dummyUsers.length; i++) {
      _swipeItems.add(
        SwipeItem(
          key: "ITEMS-$i",
          content: dummyUsers[i],
          likeAction: () {},
          nopeAction: () {},
          superlikeAction: () {},
          onSlideUpdate: (SlideRegion? region) async {},
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (BuildContext context, int index) {
              return NearbyPeopleCardView(imageUrl: dummyUsers[index]);
            },
            onStackFinished: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Stack Finished"),
                duration: Duration(milliseconds: 500),
              ));
            },
            itemChanged: (SwipeItem item, int index) {
              print(item);
            },
            upSwipeAllowed: true,
            fillSpace: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _matchEngine.currentItem?.nope();
                  },
                  child: const Text("Nope")),
              ElevatedButton(
                  onPressed: () {
                    _matchEngine.currentItem?.superLike();
                  },
                  child: const Text("Superlike")),
              ElevatedButton(
                  onPressed: () {
                    _matchEngine.currentItem?.like();
                  },
                  child: const Text("Like"))
            ],
          )
        ],
      ),
    );
  }
}
