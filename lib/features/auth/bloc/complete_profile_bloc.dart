import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

@Injectable()
class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc() : super(const CompleteProfileInitial()) {
    on<CompleteProfileSetNameEvent>((event, emit) {
      print(event.name);
      emit(state.copyWith(name: event.name));
    });
  }
}
