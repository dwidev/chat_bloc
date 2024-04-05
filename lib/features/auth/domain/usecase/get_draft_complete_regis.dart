import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/enums/gender_enum.dart';
import '../../../../core/failures/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../presentation/bloc/complete_profile_bloc.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class GetAsDraftCompleteRegis extends BaseUsecase<CompleteProfileState?, void> {
  final AuthenticationRepository authenticationRepository;

  GetAsDraftCompleteRegis({required this.authenticationRepository});

  @override
  Future<Either<Failure, CompleteProfileState?>> calling(void params) async {
    final response = await authenticationRepository.getDraftCompleteRegister();
    if (response == null) return const Right(null);

    final photos =
        response.photosBytes.map((e) => MemoryImage(base64Decode(e))).toList();

    final result = CompleteProfileState(
      name: response.name,
      gender: Gender.fromCode(response.genderCode),
      age: response.age,
      distance: response.distance,
      lookingForCode: response.lookingForCode,
      interests: InterestState(codes: response.interestsCodes),
      photoProfiles: photos,
    );

    return Right(result);
  }
}
