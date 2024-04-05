import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/enums/gender_enum.dart';
import '../../../masterdata/cubit/master_data_cubit.dart';
import '../../domain/entities/user_data.dart';
import '../../domain/usecase/clear_auth_storage.dart';
import '../../domain/usecase/get_draft_complete_regis.dart';
import '../../domain/usecase/save_draft_complete_regis.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

@Injectable()
class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final ClearAuthStorage clearAuthStorage;
  final MasterDataCubit masterDataCubit;
  final GetAsDraftCompleteRegis getAsDraftCompleteRegis;
  final SaveAsDraftCompleteRegis saveAsDraftCompleteRegis;

  CompleteProfileBloc({
    required this.clearAuthStorage,
    required this.getAsDraftCompleteRegis,
    required this.saveAsDraftCompleteRegis,
    required this.masterDataCubit,
  }) : super(const CompleteProfileInitial()) {
    on<FirstGetDataCompleteRegisEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final request = await Future.wait([
        getAsDraftCompleteRegis(null),
        // another request
      ]);

      final response = request[0];

      late CompleteProfileState newState;

      await response.fold((left) {
        newState = state;
      }, (data) async {
        if (data != null) {
          newState = data;
        } else {
          newState = state;
        }
      });

      emit(newState.copyWith(isLoading: false));
    });

    on<SetDraftCompleteRegisEvent>((event, emit) async {
      await saveAsDraftCompleteRegis(state);
    });

    on<CompleteProfileAutopopulated>((event, emit) {
      emit(event.userData.toCompleteProfileData);
    });

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

    on<DeleteDraftCompleteRegisEvent>((event, emit) async {
      /// draft data complete profile at regis page this include
      /// deleted with this usecase
      await clearAuthStorage(null);
    });
  }

  @override
  Future<void> close() {
    debugPrint("ONCLOSING CompleteProfileBloc");
    return super.close();
  }
}
