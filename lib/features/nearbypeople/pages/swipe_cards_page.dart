import 'package:matchloves/core/depedency_injection/injection.dart';
import 'package:matchloves/features/auth/presentation/pages/login/login_page.dart';
import 'package:matchloves/features/nearbypeople/pages/nearby_people_card_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../main/pages/main_page.dart';
import '../cubit/control_card_cubit.dart';
import '../cubit/details_card_cubit.dart';
import '../cubit/match_engine_cubit.dart';
import 'nearby_people_card_view.dart';
import 'nearby_people_card_view_animation.dart';

class SwipeCardsPage extends StatefulWidget {
  const SwipeCardsPage({super.key});

  @override
  State<SwipeCardsPage> createState() => _SwipeCardsPageState();

  static const path = '/swipe-cards';
}

class _SwipeCardsPageState extends State<SwipeCardsPage> {
  // @override
  // bool get wantKeepAlive => true;
  late MatchEngineCubit matchEngine;

  @override
  void initState() {
    matchEngine = getIt<MatchEngineCubit>();
    Future.microtask(() {
      matchEngine.loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    print("DISPOSE");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      titleTextStyle: textTheme.labelLarge,
      title: const Text("Hallo Dear"),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
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
              onPressed: () {
                context.go(LoginPage.path);
              },
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
      // appBar: appBar,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          appBar,
          BlocProvider<MatchEngineCubit>(
            create: (context) => matchEngine,
            child: BlocBuilder<MatchEngineCubit, MatchEngineState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return SpinKitRipple(
                    size: 150,
                    duration: const Duration(seconds: 2),
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(dummyUsers[2]),
                        radius: 45,
                      );
                    },
                  );
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: size.height / 7,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          if (state.nextItem != null) ...{
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(
                                  state.nextCardScale,
                                  state.nextCardScale,
                                ),
                              child: NearbyPeopleCardView(
                                  imageUrl: state.nextItem!),
                            )
                          },
                          if (state.currentItem != null) ...{
                            BlocProvider<ControlCardCubit>(
                              create: (context) => getIt<ControlCardCubit>(),
                              child: NearbyPeopleCardViewAnimation(
                                onActionTapType: state.onActionTap,
                                imageUrl: state.currentItem ?? "",
                                onTap: () {
                                  context.pushNamed(
                                    NearbyPeopleCardDetailPage.path,
                                    extra: state.currentItem ?? "",
                                  );
                                },
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: CardActionsWidget(
                        onSkipPressed: () {
                          context.read<MatchEngineCubit>().onActionSkip();
                        },
                        onLovePressed: () {
                          context.read<MatchEngineCubit>().onActionLove();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
