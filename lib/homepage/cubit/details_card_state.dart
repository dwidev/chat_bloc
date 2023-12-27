part of 'details_card_cubit.dart';

@immutable
class DetailsCardState extends Equatable {
  /// for flaging is page detail or not
  final bool isDetail;

  const DetailsCardState({required this.isDetail});

  @override
  List<Object?> get props => [isDetail];

  DetailsCardState copyWith({
    bool? isDetail,
  }) {
    return DetailsCardState(isDetail: isDetail ?? this.isDetail);
  }

  @override
  bool get stringify => true;
}

final class DetailsCardInitial extends DetailsCardState {
  const DetailsCardInitial() : super(isDetail: false);
}
