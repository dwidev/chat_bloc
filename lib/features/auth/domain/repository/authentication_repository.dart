import 'package:matchloves/features/auth/domain/entities/user_data.dart';

abstract class AuthenticationRepository {
  Future<UserData> signWithGoogle();
  Future<UserData> signWithApple();
  Future<UserData> signWithPhoneOrEmail();
}
