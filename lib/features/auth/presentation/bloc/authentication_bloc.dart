import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user_data.dart';
import '../../domain/usecase/sign_with_google.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@Injectable()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignWithGoogle signWithGoogle;

  AuthenticationBloc({required this.signWithGoogle})
      : super(AuthenticationInitial()) {
    on<SignWithGoogleEvent>(_doSignWithGoogle);
  }

  Future<void> _doSignWithGoogle(
    SignWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await signWithGoogle(null);

    response.fold(
      (error) {
        emit(AuthenticationSignError(error: error));
      },
      (data) {
        if (data.authToken.isRegistered) {
          emit(AuthenticationSignSuccess(userData: data));
        } else {
          emit(AuthenticationSignSuccessNotRegistered(userData: data));
        }
      },
    );
  }
}
