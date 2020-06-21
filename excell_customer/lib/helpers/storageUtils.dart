import 'package:ExcellCustomer/models/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<void> setStorageItem(StorageKey key, value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key.toString().split(".").last, value);
  }

    static Future<void> setStorageRawItem(String key, dynamic value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key, value.toString());
  }

  static Future<String> getStorageItem(StorageKey key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key.toString().split(".").last);
  }

  static void setStorageItems(Map<StorageKey, String> storageItems) async {
    storageItems.forEach((key, value) => setStorageItem(key, value));
  }

  static Future<bool> hasKey(StorageKey key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key.toString().split(".").last);
  }

  static Future<Map<StorageKey, String>> getStorageItems(List<StorageKey> keys) async {
    Map<StorageKey, String> storageItems = {};

    Future futureStorageValuss = Future.wait(List.generate(keys.length, (index) {
      return getStorageItem(keys[index]);
    }));

    List<String> storageValuss = await futureStorageValuss;
    storageValuss.asMap().forEach((index, _val) {
      _val = _val ?? "";
      storageItems[keys[index]] = _val;
    });

    return storageItems;
  }

  static Future<bool> clearStorage() async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.clear();
  }
}
