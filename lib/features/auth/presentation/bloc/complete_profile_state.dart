// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'complete_profile_bloc.dart';

@immutable
class CompleteProfileState extends Equatable {
  final bool isLoading;

  final String name;
  final Gender? gender;
  final int age;
  final int distance;
  final String lookingForCode;
  final InterestState interests;
  final List<MemoryImage> photoProfiles;

  const CompleteProfileState({
    required this.name,
    this.gender,
    this.age = 25,
    this.distance = 10,
    this.lookingForCode = '',
    this.interests = const InterestState(),
    this.photoProfiles = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props {
    return [
      isLoading,
      name,
      gender,
      age,
      distance,
      lookingForCode,
      interests,
      photoProfiles,
    ];
  }

  CompleteProfileState copyWith({
    bool? isLoading,
    String? name,
    Gender? gender,
    int? age,
    int? distance,
    String? lookingForCode,
    InterestState? interests,
    List<MemoryImage>? photoProfiles,
  }) {
    return CompleteProfileState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      lookingForCode: lookingForCode ?? this.lookingForCode,
      interests: interests ?? this.interests,
      photoProfiles: photoProfiles ?? this.photoProfiles,
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
