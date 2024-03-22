part of 'complete_profile_bloc.dart';

@immutable
sealed class CompleteProfileEvent {
  const CompleteProfileEvent();
}

final class CompleteProfileSetNameEvent extends CompleteProfileEvent {
  final String name;

  const CompleteProfileSetNameEvent({required this.name});
}

final class CompleteProfileSetGenderEvent extends CompleteProfileEvent {
  final Gender gender;

  const CompleteProfileSetGenderEvent({required this.gender});
}

final class CompleteProfileSetAgeEvent extends CompleteProfileEvent {
  final int age;

  const CompleteProfileSetAgeEvent({required this.age});
}

final class CompleteProfileSetDistanceEvent extends CompleteProfileEvent {
  final int distance;

  const CompleteProfileSetDistanceEvent({required this.distance});
}

final class CompleteProfileSetLookingEvent extends CompleteProfileEvent {
  final String code;

  const CompleteProfileSetLookingEvent({required this.code});
}

final class CompleteProfileSetInterestEvent extends CompleteProfileEvent {
  final String code;

  const CompleteProfileSetInterestEvent({required this.code});
}
