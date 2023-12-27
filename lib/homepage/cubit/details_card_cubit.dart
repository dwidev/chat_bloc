import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_card_state.dart';

class DetailsCardCubit extends Cubit<DetailsCardState> {
  DetailsCardCubit() : super(const DetailsCardInitial());

  late AnimationController detailCardAnimationController;

  // animation property for width and hight card
  late Tween<double?> tweenCardWidth, tweenCardHeight;
  late Animation<double?> widthCardAnimation, heightCardAnimation;

  // animation property for appbar offset
  late Tween<Offset> tweenOffsetAppBar = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  );
  late Animation<Offset> offsetAppbarAnimation;

  // animation property for card postion offset
  late Tween<double?> tweenTopCard = Tween<double?>(
    begin: null,
    end: null,
  );
  late Animation<double?> topCardAnimation;

  // animation property for card postion offset
  late Tween<double?> tweenBottomAction = Tween<double?>(
    begin: null,
    end: null,
  );
  late Animation<double?> bottomActionAnimation;

  void initializeDetailAnimations({
    required TickerProvider sync,
  }) {
    detailCardAnimationController = AnimationController(
      vsync: sync,
      duration: const Duration(milliseconds: 500),
    );
    final parent = CurvedAnimation(
      parent: detailCardAnimationController,
      curve: Curves.easeIn,
    );

    tweenCardWidth = Tween<double?>(begin: null, end: null);
    tweenCardHeight = Tween<double?>(begin: null, end: null);
    widthCardAnimation = tweenCardWidth.animate(parent);
    heightCardAnimation = tweenCardHeight.animate(parent);

    offsetAppbarAnimation = tweenOffsetAppBar.animate(parent);
    topCardAnimation = tweenTopCard.animate(parent);
    bottomActionAnimation = tweenBottomAction.animate(parent);
  }

  void onClickCardToDetail({required Size screnSize}) {
    if (state.isDetail) {
      detailCardAnimationController.reverse().whenComplete(() {
        emit(state.copyWith(isDetail: !state.isDetail));
      });
      return;
    }

    final curve = CurvedAnimation(
      parent: detailCardAnimationController,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    tweenCardWidth.begin = screnSize.width / 1.2;
    tweenCardWidth.end = screnSize.width;

    tweenCardHeight.begin = screnSize.height / 1.5;
    tweenCardHeight.end = screnSize.height / 2.5;

    widthCardAnimation = tweenCardWidth.animate(curve);
    heightCardAnimation = tweenCardHeight.animate(curve);

    offsetAppbarAnimation = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(0.0, -screnSize.height / 5),
    ).animate(curve);

    topCardAnimation = Tween(
      begin: screnSize.height / 7,
      end: 0.0,
    ).animate(curve);

    bottomActionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: screnSize.height / 11,
          end: -(screnSize.height / 15),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -(screnSize.height / 15),
          end: 30.0,
        ),
        weight: 0.5,
      ),
    ]).animate(curve);

    detailCardAnimationController.forward().whenComplete(() {
      emit(state.copyWith(isDetail: !state.isDetail));
    });
  }

  dispose() {
    detailCardAnimationController.dispose();
  }
}
