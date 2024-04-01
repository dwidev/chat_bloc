part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class SignWithGoogleEvent extends AuthenticationEvent {
  const SignWithGoogleEvent();

  @override
  List<Object> get props => [];
}
