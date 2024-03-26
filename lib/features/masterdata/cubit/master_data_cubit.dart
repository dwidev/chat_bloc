import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/model/mastedata_model.dart';
import '../data/model/master_interest_model.dart';
import '../data/repository/masterdata_repository.dart';

part 'master_data_state.dart';

@Injectable()
class MasterDataCubit extends Cubit<MasterDataState> {
  final MasterDataRepository masterDataRepository;

  MasterDataCubit({required this.masterDataRepository})
      : super(const MasterDataInitial());

  Future<void> getCompleteProfileMaster() async {
    emit(state.copyWith(isLoading: true));

    await Future.wait([
      getListInterests(),
      getListLookingsFor(),
    ]);

    emit(state.copyWith(isLoading: false));
  }

  Future<void> getListLookingsFor() async {
    final response = await masterDataRepository.getListLookingsFor();
    emit(state.copyWith(lookingFors: response));
  }

  Future<void> getListInterests() async {
    final response = await masterDataRepository.getListInterests();
    emit(state.copyWith(interests: response));
  }

  @override
  Future<void> close() {
    masterDataRepository.dispose();
    return super.close();
  }
}
