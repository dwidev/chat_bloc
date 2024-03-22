part of 'complete_profile_bloc.dart';

@immutable
class CompleteProfileState extends Equatable {
  final String name;
  final Gender? gender;
  final int age;
  final int distance;
  final String lookingForCode;
  final InterestState interests;

  const CompleteProfileState({
    required this.name,
    this.gender,
    this.age = 25,
    this.distance = 10,
    required this.lookingForCode,
    required this.interests,
  });

  @override
  List<Object?> get props {
    return [
      name,
      gender,
      age,
      distance,
      lookingForCode,
      interests,
    ];
  }

  CompleteProfileState copyWith({
    String? name,
    Gender? gender,
    int? age,
    int? distance,
    String? lookingForCode,
    InterestState? interests,
  }) {
    return CompleteProfileState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      lookingForCode: lookingForCode ?? this.lookingForCode,
      interests: interests ?? this.interests,
    );
  }

  @override
  bool get stringify => true;
}

final class CompleteProfileInitial extends CompleteProfileState {
  const CompleteProfileInitial()
      : super(
          name: '',
          lookingForCode: '',
          interests: const InterestState(),
        );
}

class InterestState extends Equatable {
  final List<String> codes;

  bool selected(String code) => codes.where((e) => e == code).isNotEmpty;

  const InterestState({this.codes = const []});

  @override
  List<Object?> get props => [codes];
}
