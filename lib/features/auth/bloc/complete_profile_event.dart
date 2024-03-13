part of 'complete_profile_bloc.dart';

@immutable
sealed class CompleteProfileEvent {
  const CompleteProfileEvent();
}

final class CompleteProfileSetNameEvent extends CompleteProfileEvent {
  final String name;

  const CompleteProfileSetNameEvent({required this.name});
}
