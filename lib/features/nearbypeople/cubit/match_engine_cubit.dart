import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../main/pages/main_page.dart';
import 'control_card_enum.dart';

@Injectable()
class MatchEngineCubit extends Cubit<MatchEngineState> {
  MatchEngineCubit() : super(const MatchEngineInitial([]));

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(swipeItems: dummyUsers, isLoading: false));
    });
  }

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

  void onSwipeUpdate(double distance) {
    final cardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    emit(state.copyWith(nextCardScale: cardScale));
  }
}

@immutable
class MatchEngineState extends Equatable {
  final bool isLoading;
  final List<String> swipeItems;
  final int currentCardIndex;
  final int nextCardIndex;

  final double nextCardScale;

  final CardSwipeType? onActionTap;

  const MatchEngineState({
    required this.isLoading,
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
      isLoading,
      swipeItems,
      currentCardIndex,
      nextCardIndex,
      nextCardScale,
      onActionTap,
    ];
  }

  MatchEngineState copyWith({
    bool? isLoading,
    List<String>? swipeItems,
    int? currentCardIndex,
    int? nextCardIndex,
    double? nextCardScale,
    ValueGetter<CardSwipeType?>? onActionTap,
  }) {
    return MatchEngineState(
      isLoading: isLoading ?? this.isLoading,
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
          isLoading: false,
          onActionTap: CardSwipeType.initial,
        );
}
