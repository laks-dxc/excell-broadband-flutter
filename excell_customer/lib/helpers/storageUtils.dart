import 'package:ExcellCustomer/models/enum.dart';
import 'package:localstorage/localstorage.dart';

class StorageUtils {
  static LocalStorage storage = new LocalStorage("exbb_app");

  // static getToken() {
  //   String token = "token";
  //   return token;
  // }

  static String getStorageItem(StorageKeys key) {
    return storage.getItem(key.toString().split(".").last);
  }

  static void setStorageItem(StorageKeys key, value) {
    storage.setItem(key.toString().split(".").last, value);
  }

  static void setStorageItems(Map<StorageKeys, String> storageItems) {
    storageItems.forEach((key, value) => setStorageItem(key, value));
  }
}
