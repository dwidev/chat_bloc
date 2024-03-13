part of 'complete_profile_bloc.dart';

@immutable
class CompleteProfileState extends Equatable {
  final String name;

  const CompleteProfileState({required this.name});

  @override
  List<Object> get props => [name];

  CompleteProfileState copyWith({
    String? name,
  }) {
    return CompleteProfileState(
      name: name ?? this.name,
    );
  }
}

final class CompleteProfileInitial extends CompleteProfileState {
  const CompleteProfileInitial() : super(name: '');
}
