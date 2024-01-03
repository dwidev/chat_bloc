// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_bloc/nearbypeople/cubit/control_card_enum.dart';

import 'control_card_cubit.dart';

class MatchEngineCubit extends Cubit<MatchEngineState>
    implements ControlCardCubitDelegate {
  MatchEngineCubit({required List<String> swipeItems})
      : super(MatchEngineInitial(swipeItems));

  void cycleCard() {
    final newState = state.copyWith(
      currentCardIndex: state.nextCardIndex,
      nextCardIndex: state.nextCardIndex + 1,
      onActionTap: () => null,
    );

    emit(newState);
  }

  void onActionSkip() {
    emit(state.copyWith(onActionTap: () => CardSwipeType.skip));
  }

  void onActionLove() {
    emit(state.copyWith(onActionTap: () => CardSwipeType.love));
  }

  @override
  void onSwipeUpdate(double distance) {
    final cardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    emit(state.copyWith(nextCardScale: cardScale));
  }
}

@immutable
class MatchEngineState extends Equatable {
  final List<String> swipeItems;
  final int currentCardIndex;
  final int nextCardIndex;

  final double nextCardScale;

  final CardSwipeType? onActionTap;

  const MatchEngineState({
    required this.swipeItems,
    required this.currentCardIndex,
    required this.nextCardIndex,
    required this.nextCardScale,
    this.onActionTap,
  });

  String? get currentItem => currentCardIndex < swipeItems.length
      ? swipeItems[currentCardIndex]
      : null;

  String? get nextItem =>
      nextCardIndex < swipeItems.length ? swipeItems[nextCardIndex] : null;

  @override
  List<Object?> get props {
    return [
      swipeItems,
      currentCardIndex,
      nextCardIndex,
      nextCardScale,
      onActionTap,
    ];
  }

  MatchEngineState copyWith({
    List<String>? swipeItems,
    int? currentCardIndex,
    int? nextCardIndex,
    double? nextCardScale,
    ValueGetter<CardSwipeType?>? onActionTap,
  }) {
    return MatchEngineState(
      swipeItems: swipeItems ?? this.swipeItems,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      nextCardIndex: nextCardIndex ?? this.nextCardIndex,
      nextCardScale: nextCardScale ?? this.nextCardScale,
      onActionTap: onActionTap != null ? onActionTap() : this.onActionTap,
    );
  }

  @override
  bool get stringify => true;
}

final class MatchEngineInitial extends MatchEngineState {
  const MatchEngineInitial(List<String> swipeItems)
      : super(
          currentCardIndex: 0,
          nextCardIndex: 1,
          swipeItems: swipeItems,
          nextCardScale: 0.9,
        );
}
