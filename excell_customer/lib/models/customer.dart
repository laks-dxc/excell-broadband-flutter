import 'package:ExcellCustomer/helpers/netUtils.dart';
import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:localstorage/localstorage.dart';

class Customer {
  static LocalStorage storage = new LocalStorage('exbb_app');

  static int customerId;
  static int customerName;

  static Future<int> authenticate(String custId, String mobileNo) async {
    Map<String, dynamic> authenticateResponse = await NetUtils.apiPostWithoutToken({
      "name": "generateToken",
      "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "1"}
    });

    int isAuthenticated = -1;

    if (authenticateResponse["status"] == 200) {
      // String token = authenticateResponse["result"]["token"];

      // Map<StorageKeys, String> storageItems = {
      //   StorageKeys.UserToken: token,
      //   StorageKeys.CustId: custId,
      //   StorageKeys.MobileNo: mobileNo,
      // };

      // StorageUtils.setStorageItems(storageItems);
      isAuthenticated = authenticateResponse['result']['otp'];
    } else {
      isAuthenticated = 0;
    }

    Future<bool> authenticate1(String custId, String mobileNo) async {
      Map<String, dynamic> authenticateResponse = await NetUtils.apiPostWithoutToken({
        "name": "generateToken",
        "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "1"}
      });

      bool isAuthenticated;

      if (authenticateResponse["status"] == 200) {
        // String token = authenticateResponse["result"]["token"];

        // Map<StorageKeys, String> storageItems = {
        //   StorageKeys.UserToken: token,
        //   StorageKeys.CustId: custId,
        //   StorageKeys.MobileNo: mobileNo,
        // };

        // StorageUtils.setStorageItems(storageItems);
        isAuthenticated = authenticateResponse['result']['otp'];
      } else {
        isAuthenticated = false;
      }

      return isAuthenticated;
    }
  }
}
