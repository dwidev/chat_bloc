// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bloc/features/nearbypeople/cubit/control_card_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/control_card_cubit.dart';
import '../cubit/details_card_cubit.dart';
import '../cubit/match_engine_cubit.dart';
import 'nearby_people_card_detail_view.dart';
import 'nearby_people_card_view.dart';

class NearbyPeopleCardViewAnimation extends StatefulWidget {
  const NearbyPeopleCardViewAnimation({
    Key? key,
    required this.imageUrl,
    required this.onTap,
    this.onActionTapType,
  }) : super(key: key);

  final String imageUrl;
  final VoidCallback onTap;
  final CardSwipeType? onActionTapType;

  @override
  State<NearbyPeopleCardViewAnimation> createState() =>
      _NearbyPeopleCardViewAnimationState();
}

class _NearbyPeopleCardViewAnimationState
    extends State<NearbyPeopleCardViewAnimation> with TickerProviderStateMixin {
  late ControlCardCubit controlCardCubit;

  @override
  void initState() {
    controlCardCubit = context.read<ControlCardCubit>();
    controlCardCubit.initializeSwipeAnimation(sync: this);

    super.initState();
  }

  @override
  void dispose() {
    debugPrint("disposing NearbyPeopleCardViewAnimation");
    controlCardCubit.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NearbyPeopleCardViewAnimation oldWidget) {
    final size = MediaQuery.of(context).size;

    super.didUpdateWidget(oldWidget);

    if (oldWidget.onActionTapType == null && widget.onActionTapType != null) {
      print("widget.onActionTapType ${widget.onActionTapType}");
      switch (widget.onActionTapType) {
        case CardSwipeType.skip:
          controlCardCubit.onActionSkip(size);
          break;
        case CardSwipeType.love:
          controlCardCubit.onActionLove(size);
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDetail = context.select<DetailsCardCubit, bool>(
      (p) => p.state.isDetail,
    );
    final detailsCardCubit = context.read<DetailsCardCubit>();

    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (details) {
        if (controlCardCubit.swipeAnimationController.isAnimating) {
          controlCardCubit.onResetPosition();
          return;
        }

        controlCardCubit.onDragStart(details);
      },
      onPanUpdate: (details) {
        if (isDetail || controlCardCubit.swipeAnimationController.isAnimating) {
          controlCardCubit.onResetPosition();
          return;
        }

        controlCardCubit.onDragCard(details, size);
      },
      onPanEnd: (details) {
        controlCardCubit.onEndDrag(details, size);
      },
      child: BlocConsumer<ControlCardCubit, ControlCardState>(
        listener: (context, state) {
          if (state is ControlCardLovedState ||
              state is ControlCardSkipedState) {
            context.read<MatchEngineCubit>().cycleCard();
          }
        },
        builder: (context, state) {
          Offset rotationOrigin(Rect dragBounds) {
            return state.positionStart - dragBounds.topLeft;
          }

          return Transform(
            transform: Matrix4.translationValues(
              state.position.dx,
              state.position.dy,
              0.0,
            )..rotateZ(state.angle),
            origin: rotationOrigin(state.anchorBounds),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // const NearbyPeopleCardDetailView(),
                NearbyPeopleCardView(
                  imageUrl: widget.imageUrl,
                  // options: NearbyPeopleCardViewOptions(
                  //   imageHeight: detailsCardCubit.heightCardAnimation.value,
                  //   imageWidth: detailsCardCubit.widthCardAnimation.value,
                  //   isDetail: isDetail,
                  //   radiusSize: detailsCardCubit.radiusCardAnimation.value,
                  // ),
                ),
                Visibility(
                  visible: !isDetail,
                  child: Positioned(
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
