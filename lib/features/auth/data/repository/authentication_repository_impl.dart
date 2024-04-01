import 'package:injectable/injectable.dart';

import '../../domain/entities/user_data.dart';
import '../../domain/repository/authentication_repository.dart';
import '../datasources/firebase_datasource.dart';
import '../datasources/http_datasource.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthFirebaseDataSource authFirebaseDataSource;
  final AuthHTTPDataSource authHTTPDataSource;

  AuthenticationRepositoryImpl({
    required this.authFirebaseDataSource,
    required this.authHTTPDataSource,
  });

  @override
  Future<UserData> signWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<UserData> signWithGoogle() async {
    final credential = await authFirebaseDataSource.signWithGoogle();

    final email = credential.user?.email ?? "";
    final sign = await authHTTPDataSource.signWithEmail(email: email);

    return UserData(
      userId: credential.user?.uid ?? "",
      username: credential.user?.displayName ?? "",
      email: credential.user?.email ?? "",
      authToken: sign,
    );
  }

  @override
  Future<UserData> signWithPhoneOrEmail() {
    throw UnimplementedError();
  }
}
