import 'package:flutter/services.dart';
import 'package:matchloves/core/local_storage_manager/mock_storage.dart';

import 'local_storage_manager.dart';

enum StorageType {
  sharedPreference,
  mock,
}

class LocalStorageFactory {
  static Future<LocalStorageAdapter> get({required StorageType type}) async {
    switch (type) {
      case StorageType.sharedPreference:
        final pref = await SharedPreferences.getInstance();
        return SharedPreferenceManager(sharedPreferences: pref);
      case StorageType.mock:
        return MockStorageManager();
      default:
        throw MissingPluginException(
          'cannot create prefrence storage with type $type',
        );
    }
  }
}
