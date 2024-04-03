import 'package:injectable/injectable.dart';
import 'package:matchloves/features/auth/domain/entities/auth_token.dart';

import '../../../../core/local_storage_manager/local_storage_adapter.dart';

const completeRegisKey = 'complete_regis_key';
const accessTokenKey = 'access_token';
const refreshTokenKey = 'refresh_token';

abstract class AuthLocalStorageDataSource {
  Future<void> setCompleteRegis(bool value);
  Future<bool> completeRegis();
  Future<void> setToken(AuthToken authToken);
  Future<void> clear();
}

@LazySingleton(as: AuthLocalStorageDataSource)
class AuthLocalStorageDataSourceImpl implements AuthLocalStorageDataSource {
  final LocalStorageAdapter adapter;

  AuthLocalStorageDataSourceImpl({@mockStorage required this.adapter});

  @override
  Future<void> setCompleteRegis(bool value) async {
    await adapter.storeData(completeRegisKey, value);
  }

  @override
  Future<bool> completeRegis() async {
    final result = await adapter.getData(completeRegisKey);
    return (result as bool?) ?? false;
  }

  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> setToken() {}
}
