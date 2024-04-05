import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/failures/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../data/model/user_complete_regis_model.dart';
import '../../presentation/bloc/complete_profile_bloc.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class SaveAsDraftCompleteRegis extends BaseUsecase<void, CompleteProfileState> {
  final AuthenticationRepository authenticationRepository;

  SaveAsDraftCompleteRegis({required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> calling(CompleteProfileState params) async {
    final photoBytes =
        params.photoProfiles.map((e) => base64Encode(e.bytes)).toList();

    final model = DraftCompleteProfileModel(
      name: params.name,
      genderCode: params.gender?.code ?? "",
      age: params.age,
      distance: params.distance,
      lookingForCode: params.lookingForCode,
      interestsCodes: params.interests.codes,
      photosBytes: photoBytes,
    );
    await authenticationRepository.saveAsDraftCompleteRegister(model: model);
    return const Right(null);
  }
}
