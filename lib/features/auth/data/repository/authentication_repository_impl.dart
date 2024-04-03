import 'package:injectable/injectable.dart';
import 'package:matchloves/features/auth/data/model/token_model.dart';
import 'package:matchloves/features/auth/domain/entities/authorize.dart';

import '../../domain/entities/user_data.dart';
import '../../domain/repository/authentication_repository.dart';
import '../datasources/auth_localstorage_datasource.dart';
import '../datasources/firebase_datasource.dart';
import '../datasources/http_datasource.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthFirebaseDataSource authFirebaseDataSource;
  final AuthHTTPDataSource authHTTPDataSource;
  final AuthLocalStorageDataSource authLocalStorageDataSource;

  AuthenticationRepositoryImpl({
    required this.authFirebaseDataSource,
    required this.authHTTPDataSource,
    required this.authLocalStorageDataSource,
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

    await Future.wait([
      authLocalStorageDataSource.setToken(sign),
      authLocalStorageDataSource.setCompleteRegis(sign.isRegistered),
    ]);

    return UserData(
      userId: credential.user?.uid ?? "",
      username: credential.user?.displayName ?? "",
      email: credential.user?.email ?? "",
      authToken: sign.toAuth(),
    );
  }

  @override
  Future<UserData> signWithPhoneOrEmail() {
    throw UnimplementedError();
  }

  @override
  Future<AuthorizeResult> authorizedChecking() async {
    final check = await Future.wait([
      authLocalStorageDataSource.getToken(),
      authLocalStorageDataSource.completeRegis(),
    ]);

    final token = check[0] as TokenModel;
    final registered = check[1] as bool;

    if (token.accessToken.isEmpty || token.refreshToken.isEmpty) {
      await authLocalStorageDataSource.clear();
      return AuthorizeResult.logout;
    }

    if (registered) {
      return AuthorizeResult.signInWithComplete;
    } else {
      return AuthorizeResult.signInNotComplete;
    }
  }

  @override
  Future<void> clearAuthStorage() async {
    await authLocalStorageDataSource.clear();
  }
}
