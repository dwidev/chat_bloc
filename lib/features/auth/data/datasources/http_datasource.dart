import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_token.dart';

abstract class AuthHTTPDataSource {
  Future<AuthToken> signWithEmail({required String email});
}

@LazySingleton(as: AuthHTTPDataSource)
class AuthHTTPDataSourceImpl implements AuthHTTPDataSource {
  final Dio dio;

  AuthHTTPDataSourceImpl({required this.dio});

  @override
  Future<AuthToken> signWithEmail({required String email}) async {
    await Future.delayed(500.ms);
    final rand = Random().nextInt(1000);
    final result = AuthToken(
      isRegistered: rand % 2 == 0,
      accessToken: "accessToken",
      refreshToken: "refreshToken",
    );
    return result;
  }
}
