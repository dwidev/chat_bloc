import 'package:chat_bloc/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../chat/bloc/conversations_bloc/conversations_bloc.dart';
import '../../chat/bloc/ws_connection_bloc/ws_connection_bloc.dart';
import '../../chat/data/repository/chat_repository.dart';
import '../../chat/pages/converstaions_page.dart';
import '../cubit/bottom_navigation_menu/bottom_navigation_menu_cubit.dart';

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

class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>("MainPage"));

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          top: 10,
          bottom: bottom * 1.1,
          right: 20,
          left: 20,
        ),
        width: context.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: BottomNavigationMenuType.values.map((e) {
            return IconButton(
              onPressed: () {
                navigationShell.goBranch(
                  e.menuIndex,
                  initialLocation: e.menuIndex == navigationShell.currentIndex,
                );
              },
              icon: Icon(
                e.icon,
                size: e.menuIndex == navigationShell.currentIndex ? 32 : 28,
              ),
              color: e.menuIndex == navigationShell.currentIndex
                  ? primaryColor
                  : darkColor,
            );
          }).toList(),
        ),
      ),
    );
  }

  static const path = '/main-page';
}

class CardActionsWidget extends StatelessWidget {
  const CardActionsWidget({
    Key? key,
    this.onSkipPressed,
    this.onLovePressed,
  }) : super(key: key);

  final VoidCallback? onSkipPressed;
  final VoidCallback? onLovePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: onSkipPressed != null
                ? softblueColor
                : darkColor.withOpacity(0.3),
          ),
          child: Icon(
            CupertinoIcons.refresh_bold,
            color: onSkipPressed != null ? blackColor : whiteColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onSkipPressed,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: onSkipPressed != null
                  ? secondaryColor
                  : darkColor.withOpacity(0.3),
            ),
            child: Icon(
              CupertinoIcons.clear,
              color: onSkipPressed != null ? primaryColor : whiteColor,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onLovePressed,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: onSkipPressed != null
                  ? primaryColor
                  : darkColor.withOpacity(0.3),
            ),
            child: const Icon(
              CupertinoIcons.heart_fill,
              color: whiteColor,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: onSkipPressed != null
                ? softyellowColor
                : darkColor.withOpacity(0.3),
          ),
          child: Icon(
            CupertinoIcons.gift_fill,
            color: onSkipPressed != null ? blackColor : whiteColor,
            size: 20,
          ),
        ),
      ],
    );
  }
}
