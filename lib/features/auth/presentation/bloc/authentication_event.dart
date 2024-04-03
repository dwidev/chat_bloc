part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthorizedCheckingEvent extends AuthenticationEvent {
  const AuthorizedCheckingEvent();
}

final class ClearAuthLocalStorageEvent extends AuthenticationEvent {
  const ClearAuthLocalStorageEvent();
}

final class SignWithGoogleEvent extends AuthenticationEvent {
  const SignWithGoogleEvent();
}
