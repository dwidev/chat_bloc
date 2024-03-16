part of 'control_card_cubit.dart';

@immutable
class ControlCardState extends Equatable {
  /// card swipe angel
  final double angle;

  /// card swipe position
  final Offset position;
  final Offset positionStart;

  double get distance => position.distance;

  /// anchor
  final Rect anchorBounds;

  /// card overlay swipe type
  final double overlay;

  final CardListenerType cardListenerType;

  const ControlCardState({
    required this.angle,
    required this.position,
    required this.positionStart,

    // TODO(fahmi): change to real value anchorBounds by context UI
    this.anchorBounds = const Rect.fromLTRB(
      34.5,
      128.0,
      379.5,
      725.3,
    ),
    required this.overlay,
    this.cardListenerType = CardListenerType.outCard,
  });

  Offset get dragVector => position / position.distance;

  CardSwipeType get swipeOverlayType {
    const delta = 50;
    final x = position.dx;
    final y = position.dy;

    if (x > delta) {
      return CardSwipeType.love;
    }

    if (x < -delta) {
      return CardSwipeType.skip;
    }

    if (y < -delta) {
      return CardSwipeType.gift;
    }

    return CardSwipeType.initial;
  }

  CardSwipeType get swipeFinishType {
    const delta = 100;
    final x = position.dx;
    final y = position.dy;

    if (x > delta) {
      return CardSwipeType.love;
    }

    if (x < -delta) {
      return CardSwipeType.skip;
    }

    if (y < -delta) {
      return CardSwipeType.gift;
    }

    return CardSwipeType.initial;
  }

  ControlCardState copyWith({
    double? angle,
    Offset? position,
    Offset? positionStart,
    Rect? anchorBounds,
    double? overlay,
    CardListenerType? cardListenerType,
  }) {
    return ControlCardState(
      angle: angle ?? this.angle,
      position: position ?? this.position,
      positionStart: positionStart ?? this.positionStart,
      anchorBounds: anchorBounds ?? this.anchorBounds,
      overlay: overlay ?? this.overlay,
      cardListenerType: cardListenerType ?? this.cardListenerType,
    );
  }

  @override
  List<Object> get props {
    return [
      angle,
      position,
      positionStart,
      anchorBounds,
      overlay,
      cardListenerType,
    ];
  }

  @override
  bool get stringify => true;
}

final class ControlCardInitial extends ControlCardState {
  const ControlCardInitial()
      : super(
            positionStart: Offset.zero,
            position: Offset.zero,
            angle: 0,
            overlay: 0);
}

final class ControlCardLovedState extends ControlCardState {
  const ControlCardLovedState()
      : super(
            positionStart: Offset.zero,
            position: Offset.zero,
            angle: 0,
            overlay: 0);
}

final class ControlCardSkipedState extends ControlCardState {
  const ControlCardSkipedState()
      : super(
            positionStart: Offset.zero,
            position: Offset.zero,
            angle: 0,
            overlay: 0);
}
