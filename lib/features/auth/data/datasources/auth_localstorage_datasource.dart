import 'package:injectable/injectable.dart';
import '../../../../core/encryption/aes_encryption.dart';
import '../model/user_complete_regis_model.dart';

import '../../../../core/environtments/env_constant.dart';
import '../../../../core/local_storage_manager/local_storage_adapter.dart';
import '../model/token_model.dart';

enum AuthStorageKey {
  complete,
  draftCompleteProfile,
  accessToken,
  refreshtoken;
}

abstract class AuthLocalStorageDataSource {
  Future<void> setCompleteRegisStatus(bool value);
  Future<bool> completeRegis();
  Future<void> setToken(TokenModel authToken);
  Future<TokenModel> getToken();
  Future<void> clear();
  Future<void> saveDraftCompleteRegis(DraftCompleteProfileModel model);
  Future<DraftCompleteProfileModel?> getDraftCompleteRegis();
}

@LazySingleton(as: AuthLocalStorageDataSource)
class AuthLocalStorageDataSourceImpl implements AuthLocalStorageDataSource {
  final LocalStorageAdapter adapter;

  AuthLocalStorageDataSourceImpl({@sharedPref required this.adapter});

  @override
  Future<void> setCompleteRegisStatus(bool value) async {
    await adapter.storeData(AuthStorageKey.complete.name, value);
  }

  @override
  Future<bool> completeRegis() async {
    final result = await adapter.getData(AuthStorageKey.complete.name);
    return (result as bool?) ?? false;
  }

  @override
  Future<void> clear() async {
    final req = AuthStorageKey.values.map((e) => adapter.remove(e.name));
    await Future.wait(req);
  }

  @override
  Future<void> setToken(TokenModel authToken) async {
    final accessToken = authToken.accessToken;
    final refreshToken = authToken.refreshToken;
    await Future.wait([
      adapter.storeData(AuthStorageKey.accessToken.name, accessToken),
      adapter.storeData(AuthStorageKey.refreshtoken.name, refreshToken),
    ]);
  }

  @override
  Future<TokenModel> getToken() async {
    final req = await Future.wait([
      adapter.getData(AuthStorageKey.accessToken.name),
      adapter.getData(AuthStorageKey.refreshtoken.name),
    ]);

    final accessToken = (req[0] as String?) ?? "";
    final refreshToken = (req[1] as String?) ?? "";

    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> saveDraftCompleteRegis(DraftCompleteProfileModel model) async {
    final key = AuthStorageKey.draftCompleteProfile.name;
    final aesKey = completeRegisAesKey;

    final json = model.toJson();
    final enrcyptedData = encryptToAes64(key: aesKey, value: json);

    await adapter.storeData(key, enrcyptedData);
  }

  @override
  Future<DraftCompleteProfileModel?> getDraftCompleteRegis() async {
    final key = AuthStorageKey.draftCompleteProfile.name;
    final data = await adapter.getData(key) as String?;
    if (data == null) return null;

    final aesKey = completeRegisAesKey;
    final decryptData = decryptFromAes64(key: aesKey, encrypted64: data);

    final model = DraftCompleteProfileModel.fromJson(decryptData);
    return model;
  }
}
