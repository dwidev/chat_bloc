import '../entities/authorize.dart';
import '../entities/user_data.dart';

abstract class AuthenticationRepository {
  Future<AuthorizeResult> authorizedChecking();
  Future<UserData> signWithGoogle();
  Future<UserData> signWithApple();
  Future<UserData> signWithPhoneOrEmail();
  Future<void> clearAuthStorage();
}
