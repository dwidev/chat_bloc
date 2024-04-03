import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:injectable/injectable.dart';

import '../model/token_model.dart';

abstract class AuthHTTPDataSource {
  Future<TokenModel> signWithEmail({required String email});
}

@LazySingleton(as: AuthHTTPDataSource)
class AuthHTTPDataSourceImpl implements AuthHTTPDataSource {
  final Dio dio;

  AuthHTTPDataSourceImpl({required this.dio});

  @override
  Future<TokenModel> signWithEmail({required String email}) async {
    await Future.delayed(500.ms);

    final result = TokenModel(
      isRegistered: false,
      accessToken: "accessToken",
      refreshToken: "refreshToken",
    );
    return result;
  }
}
