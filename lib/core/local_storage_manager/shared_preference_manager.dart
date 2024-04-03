import 'local_storage_manager.dart';

const sharedPreferenceAdapterKey = 'shared_preference';

class SharedPreferenceManager implements LocalStorageAdapter {
  final SharedPreferences sharedPreferences;

  SharedPreferenceManager({required this.sharedPreferences});

  @override
  Future<Object?> getData(String key) async {
    final res = sharedPreferences.get(key);
    return res;
  }

  @override
  Future<void> storeData(String key, Object value) async {
    if (value is String) {
      await sharedPreferences.setString(key, value);
    }

    if (value is bool) {
      await sharedPreferences.setBool(key, value);
    }
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}
