import 'package:ExcellCustomer/helpers/netUtils.dart';
import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';

class Customer {
  static Future<Map<String, dynamic>> authenticate(String custId, String mobileNo) async {
    Map<String, dynamic> authenticatedResponse = await NetUtils.apiPostWithoutToken({
      "name": "generateToken",
      "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "1"}
    });

    Map<String, dynamic> authResponse = {"status": -1, "token": "", "otp": "otp"};

    if (authenticatedResponse["status"] == 200) {
      String token = authenticatedResponse["result"]["token"];

      authResponse = {"status": 200, "token": token, "otp": authenticatedResponse['result']['otp']};
      StorageUtils.setStorageItem(StorageKey.UserToken, token);
    } else {}

    return authResponse;
  }

  static Future<bool> isLoggedIn() async {
    return await StorageUtils.hasKey(StorageKey.UserToken);
  }

  static Future<bool> details(String custId, String mobileNo) async {
    Map<String, dynamic> customerDetailsResponse = await NetUtils.apiPostWithToken({
      "name": "getCustomerDetails",
      "param": {"customerId": custId}
    });

    bool detailsReceived;

    if (customerDetailsResponse["status"] == 200) {
      Map<String, dynamic> custDetails = customerDetailsResponse["result"];

      Map<StorageKey, String> storageItems = {
        StorageKey.CustId: custId,
        StorageKey.MobileNo: mobileNo,
        StorageKey.CutomerName: custDetails['cutomerName'],
        StorageKey.ContactNo: custDetails['contactno'],
        StorageKey.AltContactNo: custDetails['altcontactno'],
        StorageKey.Address: custDetails['address'],
        StorageKey.City: custDetails['city'],
        StorageKey.State: custDetails['state'],
        StorageKey.Emailid: custDetails['emailid'],
      };

      StorageUtils.setStorageItems(storageItems);

      detailsReceived = true;
    } else {
      detailsReceived = false;
    }

    return detailsReceived;
  }
}
