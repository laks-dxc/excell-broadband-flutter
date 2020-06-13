import 'dart:io';
import 'dart:convert' as convert;

import 'package:localstorage/localstorage.dart';

import 'constants.dart';

class Utilities {
  static LocalStorage storage = new LocalStorage('exbb_app');

  static String getStorageItem(item) {
    String storageItemValue;

    if (storage.getItem('exbb_lsitems') != null)
      storageItemValue = storage.getItem('exbb_lsitems')[0][item] ?? '';
    else
      storageItemValue = '';

    return storageItemValue;
  }

  static Future<Map<String, dynamic>> apiPost(body,
      {needAuth: true, token}) async {
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(Constants.baseURL));

    request.headers.set('content-type', 'application/json');

    print(body.toString());

    if (token != null)
      request.headers.set('Authorization', 'Excell ' + token);
    else if (needAuth)
      request.headers.set('Authorization',
          'Excell ' + storage.getItem('exbb_lsitems')[0]['token']);

    request.add(convert.utf8.encode(convert.jsonEncode(body)));

    HttpClientResponse response = await request.close();

    String transformedValue =
        await response.transform(convert.utf8.decoder).join();

    Map<String, dynamic> finalResponse =
        await convert.jsonDecode(transformedValue);

    return finalResponse;
  }

  static Future<String> getUserToken(custId, mobileNo) async {
    String token;

    Map<String, dynamic> response = await apiPost({
      "name": "generateToken",
      "param": {"custId": custId, "mobileNum": mobileNo, "mobilOTP": "0"}
    }, needAuth: false);

    print("getUserToken " + response.toString());


    if (getStatus(response) == 200)
      token = response['resonse']['result']['token'];
    else 
      token = "-1";

    print("token " + token);

    return token;
  }

  //   String getTokenFromStorage() {
  //   // return ;
  // }

  static int getStatus(response) {
    int status = -1;
    try {
      status = response['resonse']['status'];
    } catch (ex) {}
    return status;
  }

  static void clearStorage() {
    storage.clear();
  }
}