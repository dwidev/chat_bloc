import 'dart:math';
import 'dart:ui';

import 'package:chat_bloc/chat/pages/login_dummy_page.dart';
import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/homepage/cubit/control_card_cubit.dart';
import 'package:chat_bloc/homepage/cubit/details_card_cubit.dart';
import 'package:chat_bloc/homepage/pages/cards/nearby_people_card_view_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/bloc/conversations_bloc/conversations_bloc.dart';
import '../../chat/bloc/ws_connection_bloc/ws_connection_bloc.dart';
import '../../chat/data/repository/chat_repository.dart';
import '../../chat/pages/converstaions_page.dart';
import 'cards/nearby_people_card_view.dart';

/// To navigate to next page (Scaffold)
Future<void> push({
  required BuildContext context,
  required Widget page,
}) async {
  final route = MaterialPageRoute(
    builder: (_) => page,
  );

  return Navigator.push<void>(context, route);
}

final dummyUsers = [
  "https://a-cdn.sindonews.net/dyn/620/content/2016/07/01/187/1121326/michelle-ziudith-rizky-nazar-habiskan-libur-lebaran-bersama-muO-thumb.jpg",
  "https://img.inews.co.id/media/1200/files/inews_new/2022/03/16/michelle_ziudith.jpg",
  "https://cdn1-production-images-kly.akamaized.net/hM7iEJntxJBnU_TJYnMXNGN42EU=/469x625/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/4276653/original/017304400_1672324118-WhatsApp_Image_2022-12-29_at_21.27.55.jpeg",
  "https://cdn1-production-images-kly.akamaized.net/gquSZxspScHVCTVcNxk03ertabk=/469x625/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/1237206/original/d2b3ee2e7b6b98f76f0e5691e74a21f0-002850000_1463565146-Untitled-19.jpg",
  "https://cdn0-production-images-kly.akamaized.net/fGERGW_WjF2JoYmosX8SGcFk4ZM=/800x1066/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/2537426/original/015346000_1545027642-20181216144909_IMG_5220-01.jpeg",
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> users = [];

  bool menuOpen = false;

  late AnimationController menuAnimationController;
  late Tween<double> tweenScaleCard = Tween<double>(begin: 1, end: 1);
  late Animation<double> animationScale;

  late Tween<double> tweenBlurCard = Tween<double>(
    begin: 0.0,
    end: 0.0,
  );
  late Animation<double> animationBlur;

  late Tween<double> tweenShowMenu = Tween<double>(
    begin: -100.0,
    end: -100.0,
  );
  late Animation<double> animationShowMenu;

  late DetailsCardCubit detailsCardCubit;

  @override
  void initState() {
    detailsCardCubit = context.read<DetailsCardCubit>();

    detailsCardCubit.initializeDetailAnimations(sync: this);
    menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animationScale = tweenScaleCard.animate(
      CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    animationBlur = tweenBlurCard.animate(
      CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    animationShowMenu = tweenShowMenu.animate(
      CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    users = dummyUsers;
    super.initState();
  }

  void menuOnPressed() {
    if (menuOpen == false) {
      onOpenMenu();
    } else {
      onCloseMenu();
    }

    setState(() {
      menuOpen = !menuOpen;
    });
  }

  void onOpenMenu() {
    final curve = CurvedAnimation(
      parent: menuAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    );
    tweenScaleCard = Tween(begin: 1.0, end: 0.85);
    animationScale = tweenScaleCard.animate(curve);

    tweenBlurCard = Tween(
      begin: 0,
      end: 5,
    );
    animationBlur = tweenBlurCard.animate(curve);

    tweenShowMenu = Tween(begin: -100, end: 50);
    animationShowMenu = tweenShowMenu.animate(
      CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );

    menuAnimationController
      ..reset()
      ..forward();
  }

  void onCloseMenu() {
    final curve = CurvedAnimation(
      parent: menuAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    );
    tweenScaleCard = Tween(
      begin: 0.85,
      end: 1.0,
    );
    animationScale = tweenScaleCard.animate(curve);
    tweenBlurCard = Tween(
      begin: 5,
      end: 0,
    );
    animationBlur = tweenBlurCard.animate(curve);
    tweenShowMenu = Tween(begin: 50, end: -100);
    animationShowMenu = tweenShowMenu.animate(
      CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );

    menuAnimationController
      ..reset()
      ..forward().whenComplete(() {
        setState(() {
          menuOpen = false;
        });
      });
  }

  Future<void> callback() async {
    var users = this.users.toList();
    users.removeLast();

    if (users.isEmpty) {
      users = dummyUsers.reversed.toList();
      await Future.delayed(const Duration(seconds: 1)).whenComplete(() {
        setState(() {
          this.users = users;
        });
      });
      return;
    }

    setState(() {
      this.users = users;
    });
  }

  @override
  void dispose() {
    menuAnimationController.dispose();
    detailsCardCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final detailsCardCubit = context.read<DetailsCardCubit>();

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      titleTextStyle: textTheme.labelLarge,
      title: const Text("Hallo Dear"),
      centerTitle: true,
      leading: IconButton(
        onPressed: menuOnPressed,
        icon: const Icon(
          CupertinoIcons.rectangle_grid_2x2_fill,
          color: secondaryColor,
          size: 25,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.bell,
                color: primaryColor,
                size: 30,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "9+",
                  style: textTheme.bodySmall?.copyWith(
                    color: whiteColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          menuAnimationController,
          detailsCardCubit.detailCardAnimationController
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              Transform.translate(
                offset: detailsCardCubit.offsetAppbarAnimation.value,
                child: appBar,
              ),
              Transform.scale(
                scale: animationScale.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: detailsCardCubit.topCardAnimation.value ??
                          size.height / 7,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: users
                            .map(
                              (e) => BlocProvider(
                                create: (context) => ControlCardCubit(),
                                child: (e == users.last || users.length == 1) &&
                                        true
                                    ? NearbyPeopleCardViewAnimation(
                                        imageUrl: e,
                                        callback: callback,
                                        onClickDetail: () {
                                          detailsCardCubit.onClickCardToDetail(
                                            screnSize: size,
                                          );
                                        },
                                      )
                                    : Visibility(
                                        visible: !detailsCardCubit
                                                .detailCardAnimationController
                                                .isAnimating &&
                                            !detailsCardCubit
                                                .detailCardAnimationController
                                                .isCompleted,
                                        child: NearbyPeopleCardView(
                                          imageUrl: e,
                                        ),
                                      ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Positioned(
                      bottom: detailsCardCubit.bottomActionAnimation.value ??
                          size.height / 11,
                      child: const CardActionsWidget(),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (menuOpen) {
                    onCloseMenu();
                  }
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: animationBlur.value,
                    sigmaY: animationBlur.value,
                  ),
                  child: Visibility(
                    visible: menuOpen,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              MainNavigationMenuWidget(
                bottom: animationShowMenu.value,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CardActionsWidget extends StatelessWidget {
  const CardActionsWidget({
    super.key,
  });

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
            color: softblueColor,
          ),
          child: const Icon(
            CupertinoIcons.refresh_bold,
            color: blackColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: secondaryColor,
          ),
          child: const Icon(
            CupertinoIcons.clear,
            color: primaryColor,
            size: 40,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: primaryColor,
          ),
          child: const Icon(
            CupertinoIcons.heart_fill,
            color: whiteColor,
            size: 40,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: softyellowColor,
          ),
          child: const Icon(
            CupertinoIcons.gift_fill,
            color: blackColor,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class MainNavigationMenuWidget extends StatelessWidget {
  const MainNavigationMenuWidget({
    super.key,
    required this.bottom,
  });

  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: 50,
      left: 50,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: secondaryColor,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, -5),
                color: darkLightColor,
                spreadRadius: -1,
                blurRadius: 5,
              )
            ]),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoIcons.heart_fill,
            CupertinoIcons.sparkles,
            CupertinoIcons.chat_bubble_2_fill,
            CupertinoIcons.profile_circled
          ]
              .map((e) => InkWell(
                    onTap: () {
                      if (e == CupertinoIcons.chat_bubble_2_fill) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => WsConnectionBloc(
                                      chatRepository:
                                          context.read<ChatRepository>(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => ConversationsBloc(
                                      chatRepository:
                                          context.read<ChatRepository>(),
                                    ),
                                  ),
                                ],
                                child: const ConversationsPage(me: "fahmi"),
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: e == CupertinoIcons.heart_fill
                            ? primaryColor
                            : primaryColor.withOpacity(0.2),
                      ),
                      child: Icon(
                        e,
                        color: e == CupertinoIcons.heart_fill
                            ? whiteColor
                            : darkLightColor,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
//  TextButton(
//             onPressed: () {
//               push(context: context, page: const LoginDummyPage());
//             },
//             child: const Text("Go login"),
//           )