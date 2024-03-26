part of 'master_data_cubit.dart';

@immutable
final class MasterDataState extends Equatable {
  final bool isLoading;

  final List<MasterDataModel> lookingFors;
  final List<MasterDataInterestModel> interests;

  const MasterDataState({
    required this.lookingFors,
    required this.interests,
    this.isLoading = false,
  });

  MasterDataState copyWith({
    List<MasterDataModel>? lookingFors,
    List<MasterDataInterestModel>? interests,
    bool? isLoading,
  }) {
    return MasterDataState(
      isLoading: isLoading ?? this.isLoading,
      lookingFors: lookingFors ?? this.lookingFors,
      interests: interests ?? this.interests,
    );
  }

  @override
  List<Object> get props => [lookingFors, interests, isLoading];
}

final class MasterDataInitial extends MasterDataState {
  const MasterDataInitial() : super(lookingFors: const [], interests: const []);
}
