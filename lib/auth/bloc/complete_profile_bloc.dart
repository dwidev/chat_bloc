import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc() : super(const CompleteProfileInitial()) {
    on<CompleteProfileSetNameEvent>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
  }
}
