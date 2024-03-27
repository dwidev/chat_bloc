import 'package:chat_bloc/core/enums/gender_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

@Injectable()
class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc() : super(const CompleteProfileInitial()) {
    on<CompleteProfileSetNameEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<CompleteProfileSetGenderEvent>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });

    on<CompleteProfileSetAgeEvent>((event, emit) {
      emit(state.copyWith(age: event.age));
    });

    on<CompleteProfileSetDistanceEvent>((event, emit) {
      emit(state.copyWith(distance: event.distance));
    });

    on<CompleteProfileSetLookingEvent>((event, emit) {
      emit(state.copyWith(lookingForCode: event.code));
    });

    on<CompleteProfileSetInterestEvent>((event, emit) {
      final code = event.code;
      final interestsCode = state.interests.codes.toList();

      if (state.interests.selected(code)) {
        interestsCode.removeWhere((c) => c == code);
      } else {
        interestsCode.add(code);
      }

      final interest = InterestState(codes: interestsCode);
      emit(state.copyWith(interests: interest));
    });

    on<CompleteProfileSetPhotoEvent>((event, emit) {
      final newState = state.copyWith(photoProfiles: event.imagesPicked);
      emit(newState);
    });
  }

  @override
  Future<void> close() {
    debugPrint("ONCLOSING CompleteProfileBloc");
    return super.close();
  }
}
