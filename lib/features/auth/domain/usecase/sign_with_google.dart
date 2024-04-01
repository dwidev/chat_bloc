import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:matchloves/core/failures/failure.dart';
import 'package:matchloves/core/usecase/base_usecase.dart';
import 'package:matchloves/features/auth/domain/entities/user_data.dart';
import 'package:matchloves/features/auth/domain/repository/authentication_repository.dart';

@lazySingleton
class SignWithGoogle extends BaseUsecase<UserData, void> {
  final AuthenticationRepository authenticationRepository;

  SignWithGoogle({required this.authenticationRepository});

  @override
  Future<Either<Failure, UserData>> calling(void paramsType) async {
    final response = await authenticationRepository.signWithGoogle();
    return Right(response);
  }
}
