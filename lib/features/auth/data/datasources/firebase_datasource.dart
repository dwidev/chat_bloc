import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:matchloves/features/auth/data/failures/cancel_sign_failure.dart';

abstract class AuthFirebaseDataSource {
  Future<UserCredential> signWithGoogle();
}

@LazySingleton(as: AuthFirebaseDataSource)
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth firebaseAuth;

  AuthFirebaseDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserCredential> signWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();

      if (googleUser == null) {
        throw CancelSignFailure('cancel sign with google');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await firebaseAuth.signInWithCredential(credential);
      return result;
    } catch (_) {
      rethrow;
    }
  }
}
