// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    const delta = 150;
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
    double? overlay,
  }) {
    return ControlCardState(
      angle: angle ?? this.angle,
      position: position ?? this.position,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  List<Object> get props => [angle, position, overlay];
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
