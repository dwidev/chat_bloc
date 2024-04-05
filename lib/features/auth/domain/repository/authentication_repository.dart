import 'package:matchloves/features/auth/data/model/user_complete_regis_model.dart';

import '../entities/authorize.dart';
import '../entities/user_data.dart';

abstract class AuthenticationRepository {
  Future<AuthorizeResult> authorizedChecking();
  Future<UserData> signWithGoogle();
  Future<UserData> signWithApple();
  Future<UserData> signWithPhoneOrEmail();
  Future<void> clearAuthStorage();
  Future<void> saveAsDraftCompleteRegister({
    required DraftCompleteProfileModel model,
  });
  Future<DraftCompleteProfileModel?> getDraftCompleteRegister();
}
