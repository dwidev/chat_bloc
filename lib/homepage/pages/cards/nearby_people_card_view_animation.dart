import 'dart:math';

import 'package:chat_bloc/homepage/pages/cards/nearby_people_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/control_card_cubit.dart';
import '../../cubit/details_card_cubit.dart';
import 'nearby_people_card_detail_view.dart';

class NearbyPeopleCardViewAnimation extends StatefulWidget {
  const NearbyPeopleCardViewAnimation({
    super.key,
    required this.imageUrl,
    required this.callback,
    required this.onClickDetail,
  });

  final String imageUrl;
  final VoidCallback callback;
  final VoidCallback onClickDetail;

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

  double angle = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDetail = context.select<DetailsCardCubit, bool>(
      (p) => p.state.isDetail,
    );
    final detailsCardCubit = context.read<DetailsCardCubit>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onClickDetail,
      onPanUpdate: (details) {
        if (isDetail) {
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
            widget.callback();
          }
        },
        builder: (context, state) {
          return Container(
            transform: Matrix4.identity()
              ..translate(state.position.dx, state.position.dy)
              ..rotateZ(state.angle * pi / 180),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                const NearbyPeopleCardDetailView(),
                NearbyPeopleCardView(
                  imageUrl: widget.imageUrl,
                  options: NearbyPeopleCardViewOptions(
                    imageHeight: detailsCardCubit.heightCardAnimation.value,
                    imageWidth: detailsCardCubit.widthCardAnimation.value,
                    isDetail: isDetail,
                    radiusSize: detailsCardCubit.radiusCardAnimation.value,
                  ),
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
