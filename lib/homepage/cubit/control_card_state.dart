part of 'control_card_cubit.dart';

@immutable
class ControlCardState extends Equatable {
  /// card swipe angel
  final double angle;

  /// card swipe position
  final Offset position;

  /// card overlay swipe type
  final double overlay;

  const ControlCardState({
    required this.position,
    required this.angle,
    required this.overlay,
  });

  CardSwipeType get swipeOverlayType {
    const delta = 50;
    final x = position.dx;

    if (x > delta) {
      return CardSwipeType.love;
    }

    if (x < -delta) {
      return CardSwipeType.skip;
    }

    return CardSwipeType.initial;
  }

  CardSwipeType get swipeFinishType {
    const delta = 150;
    final x = position.dx;

    if (x > delta) {
      return CardSwipeType.love;
    }

    if (x < -delta) {
      return CardSwipeType.skip;
    }

    return CardSwipeType.initial;
  }

  ControlCardState copyWith(
          {Offset? position, double? angle, double? overlay}) =>
      ControlCardState(
        position: position ?? this.position,
        angle: angle ?? this.angle,
        overlay: overlay ?? this.overlay,
      );

  @override
  List<Object> get props => [position];
}

final class ControlCardInitial extends ControlCardState {
  const ControlCardInitial()
      : super(position: Offset.zero, angle: 0, overlay: 0);
}

final class ControlCardLovedState extends ControlCardState {
  const ControlCardLovedState()
      : super(position: Offset.zero, angle: 0, overlay: 0);
}

final class ControlCardSkipedState extends ControlCardState {
  const ControlCardSkipedState()
      : super(position: Offset.zero, angle: 0, overlay: 0);
}
