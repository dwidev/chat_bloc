import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchEngineCubit extends Cubit<MatchEngineState> {
  MatchEngineCubit({required List<String> swipeItems})
      : super(MatchEngineInitial(swipeItems));

  void cycleCard() {
    final newState = state.copyWith(
      currentCardIndex: state.nextCardIndex,
      nextCardIndex: state.nextCardIndex + 1,
    );

    emit(newState);
  }
}

@immutable
class MatchEngineState extends Equatable {
  final List<String> swipeItems;
  final int currentCardIndex;
  final int nextCardIndex;

  const MatchEngineState({
    required this.swipeItems,
    required this.currentCardIndex,
    required this.nextCardIndex,
  });

  String? get currentItem => currentCardIndex < swipeItems.length
      ? swipeItems[currentCardIndex]
      : null;

  String? get nextItem =>
      nextCardIndex < swipeItems.length ? swipeItems[nextCardIndex] : null;

  @override
  List<Object> get props => [swipeItems, currentCardIndex, nextCardIndex];

  MatchEngineState copyWith({
    List<String>? swipeItems,
    int? currentCardIndex,
    int? nextCardIndex,
  }) {
    return MatchEngineState(
      swipeItems: swipeItems ?? this.swipeItems,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      nextCardIndex: nextCardIndex ?? this.nextCardIndex,
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
        );
}
