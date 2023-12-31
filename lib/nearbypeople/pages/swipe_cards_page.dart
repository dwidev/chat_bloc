import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/colors.dart';
import '../../homepage/pages/home_page.dart';
import '../cubit/control_card_cubit.dart';
import '../cubit/details_card_cubit.dart';
import '../cubit/match_engine_cubit.dart';
import 'nearby_people_card_view.dart';
import 'nearby_people_card_view_animation.dart';

class SwipeCardsPage extends StatefulWidget {
  const SwipeCardsPage({super.key});

  @override
  State<SwipeCardsPage> createState() => _SwipeCardsPageState();
}

class _SwipeCardsPageState extends State<SwipeCardsPage>
    with AutomaticKeepAliveClientMixin<SwipeCardsPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final size = MediaQuery.of(context).size;
    final detailsCardCubit = context.read<DetailsCardCubit>();
    final textTheme = Theme.of(context).textTheme;

    final matchEngine = MatchEngineCubit(swipeItems: dummyUsers);
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
      // appBar: appBar,
      body: Stack(
        children: [
          appBar,
          BlocProvider<MatchEngineCubit>(
            create: (context) => matchEngine,
            child: BlocBuilder<MatchEngineCubit, MatchEngineState>(
              builder: (context, state) {
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
                              create: (context) =>
                                  ControlCardCubit(matchEngine),
                              child: NearbyPeopleCardViewAnimation(
                                onActionTapType: state.onActionTap,
                                imageUrl: state.currentItem ?? "",
                                onTap: () {
                                  // detailsCardCubit.onClickCardToDetail(
                                  //   screnSize: size,
                                  // );
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
