import 'dart:math';
import 'dart:ui';

import 'package:chat_bloc/chat/pages/login_dummy_page.dart';
import 'package:chat_bloc/core/theme/colors.dart';
import 'package:chat_bloc/homepage/cubit/control_card_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat/bloc/conversations_bloc/conversations_bloc.dart';
import '../chat/bloc/ws_connection_bloc/ws_connection_bloc.dart';
import '../chat/data/repository/chat_repository.dart';
import '../chat/pages/converstaions_page.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
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

    users = [
      "https://a-cdn.sindonews.net/dyn/620/content/2016/07/01/187/1121326/michelle-ziudith-rizky-nazar-habiskan-libur-lebaran-bersama-muO-thumb.jpg",
      "https://img.inews.co.id/media/1200/files/inews_new/2022/03/16/michelle_ziudith.jpg",
      "https://cdn1-production-images-kly.akamaized.net/hM7iEJntxJBnU_TJYnMXNGN42EU=/469x625/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/4276653/original/017304400_1672324118-WhatsApp_Image_2022-12-29_at_21.27.55.jpeg",
      "https://cdn1-production-images-kly.akamaized.net/gquSZxspScHVCTVcNxk03ertabk=/469x625/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/1237206/original/d2b3ee2e7b6b98f76f0e5691e74a21f0-002850000_1463565146-Untitled-19.jpg",
      "https://cdn0-production-images-kly.akamaized.net/fGERGW_WjF2JoYmosX8SGcFk4ZM=/800x1066/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/2537426/original/015346000_1545027642-20181216144909_IMG_5220-01.jpeg",
    ];
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
      ..forward();
  }

  void callback() {
    final users = this.users.toList();
    users.removeLast();
    setState(() {
      this.users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

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
      appBar: appBar,
      body: Stack(
        children: [
          AnimatedBuilder(
              animation: menuAnimationController,
              builder: (context, _) {
                return Transform.scale(
                  scale: animationScale.value,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: users
                                .map((e) => BlocProvider(
                                    create: (context) => ControlCardCubit(),
                                    child: LoversCardWidget(
                                      imageUrl: e,
                                      callback: callback,
                                    )))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
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
                          ),
                          // SizedBox(height: size.height / 5),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          AnimatedBuilder(
            animation: menuAnimationController,
            builder: (context, child) {
              return GestureDetector(
                onTap: () {
                  print("ANJAY");
                  onCloseMenu();
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: animationBlur.value,
                    sigmaY: animationBlur.value,
                  ),
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: menuAnimationController,
            builder: (context, _) {
              return MainNavigationMenuWidget(
                bottom: animationShowMenu.value,
              );
            },
          ),
        ],
      ),
    );
  }
}

class LoversCardWidget extends StatefulWidget {
  const LoversCardWidget({
    super.key,
    required this.imageUrl,
    required this.callback,
  });

  final String imageUrl;
  final VoidCallback callback;

  @override
  State<LoversCardWidget> createState() => _LoversCardWidgetState();
}

class _LoversCardWidgetState extends State<LoversCardWidget>
    with SingleTickerProviderStateMixin {
  late ControlCardCubit controlCardCubit;

  @override
  void initState() {
    controlCardCubit = context.read<ControlCardCubit>();
    controlCardCubit.initializeSwipeAnimation(sync: this);
    super.initState();
  }

  @override
  void dispose() {
    print("DISPOSE INI GA");
    controlCardCubit.dispose();
    super.dispose();
  }

  double angle = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanUpdate: (details) {
        controlCardCubit.onDragCard(details, size);
        // setState(() {
        //   posision += details.delta;
        //   angle = 45 * posision.dx / size.width;
        // });
      },
      onPanStart: (details) {},
      onPanEnd: (details) {
        controlCardCubit.onEndDrag(details, size);
        // setState(() {
        //   posision = Offset.zero;
        //   angle = 0;
        // });
      },
      child: BlocConsumer<ControlCardCubit, ControlCardState>(
        listener: (context, state) {
          if (state is ControlCardLovedState ||
              state is ControlCardSkipedState) {
            widget.callback();
          }
        },
        builder: (context, state) {
          return Container(
            transform: Matrix4.identity()
              ..translate(state.position.dx, state.position.dy)
              ..rotateZ(state.angle * pi / 180),
            child: Stack(
              children: [
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: size.width / 1.2,
                      height: size.height / 1.5,
                    ),
                    Positioned(
                      bottom: 15,
                      right: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 5,
                                sigmaY: 5,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Michelle Ziudith, 23",
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.location_solid,
                                          size: 10,
                                          color: whiteColor,
                                        ),
                                        Text(
                                          "2km - Jakarta, DKI Jakarta",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            children: [
                              [CupertinoIcons.person, '173cm'],
                              [CupertinoIcons.hare, 'Pisces'],
                              [CupertinoIcons.bag, 'Artis'],
                              [CupertinoIcons.clock, 'Online']
                            ]
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5, top: 7),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  (e as List)[0],
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  (e as List)[1],
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: whiteColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: state.swipeOverlayType.swipeOverlay.overlayColor
                          .withOpacity(
                        state.overlay > 0 ? state.overlay : 0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state.swipeOverlayType.swipeOverlay.icon,
                          color: state.swipeOverlayType.swipeOverlay.iconColor
                              .withOpacity(
                            state.overlay > 0 ? state.overlay : 0,
                          ),
                          size: size.width / 2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
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
            CupertinoIcons.suit_diamond_fill,
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