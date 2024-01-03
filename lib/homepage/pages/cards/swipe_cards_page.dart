import 'package:chat_bloc/homepage/cubit/details_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/control_card_cubit.dart';
import '../../cubit/match_engine_cubit.dart';
import '../home_page.dart';
import 'nearby_people_card_view.dart';
import 'nearby_people_card_view_animation.dart';

class SwipeCardsPage extends StatelessWidget {
  const SwipeCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final detailsCardCubit = context.read<DetailsCardCubit>();

    final matchEngine = MatchEngineCubit(swipeItems: dummyUsers);

    return BlocProvider<MatchEngineCubit>(
      create: (context) => matchEngine,
      child: BlocBuilder<MatchEngineCubit, MatchEngineState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: detailsCardCubit.topCardAnimation.value ?? size.height / 7,
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
                        child: NearbyPeopleCardView(imageUrl: state.nextItem!),
                      )
                    },
                    if (state.currentItem != null) ...{
                      BlocProvider<ControlCardCubit>(
                        create: (context) => ControlCardCubit(matchEngine),
                        child: NearbyPeopleCardViewAnimation(
                          onActionTapType: state.onActionTap,
                          imageUrl: state.currentItem ?? "",
                          onTap: () {
                            detailsCardCubit.onClickCardToDetail(
                              screnSize: size,
                            );
                          },
                        ),
                      ),
                    },
                  ],
                ),
              ),
              Positioned(
                bottom: detailsCardCubit.bottomActionAnimation.value ??
                    size.height / 11,
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
    );
  }
}
