import 'dart:io';
import 'dart:math' as Math;

import 'dart:convert' as convert;

import 'package:localstorage/localstorage.dart';

import 'constants.dart';
import 'customerInfo.dart';

class Utilities {
  static LocalStorage storage = new LocalStorage('exbb_app');

  static Future<List<dynamic>> getSmartUtilData(_ipAddr) async {
    List<dynamic> usageReport = [];

    int currentEpoch = DateTime.now().millisecondsSinceEpoch;

    if (storage.getItem(_ipAddr + '_lsUtilization') == null) {
      usageReport = await CustomerInfo.getUtilData(_ipAddr);
      storage.setItem(_ipAddr + '_lsUtilization', usageReport);
      storage.setItem(_ipAddr + '_lsUtilizationlastUpdated', currentEpoch);
    } else {
      List<dynamic> lsUsageReport = storage.getItem(_ipAddr + '_lsUtilization');
      int lastUpdated = storage.getItem(_ipAddr + '_lsUtilizationlastUpdated');
      if (currentEpoch - lastUpdated >= 1800000) {
        usageReport = await CustomerInfo.getUtilData(_ipAddr);

        storage.setItem(_ipAddr + '_lsUtilization', usageReport);
        storage.setItem(_ipAddr + '_lsUtilizationlastUpdated', currentEpoch);
      } else {
        usageReport = lsUsageReport;
      }
    }

    return usageReport;
  }

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

    // print(body.toString());

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

    // print("getUserToken " + response.toString());

    if (getStatus(response) == 200)
      token = response['resonse']['result']['token'];
    else
      token = "-1";

    // print("token " + token);

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

  static String bytesToGBString(String bytesValue) {
    return bytesValue != null
        ? (double.parse(bytesValue) / 1073741824).toStringAsFixed(2) + " GB"
        : "0 GB";
  }

  static double bytesToGBDouble(String bytesValue) {
    return bytesValue != null
        ? double.parse(
            (double.parse(bytesValue) / 1073741824).toStringAsFixed(2))
        : 0.0;
  }

  static double convertToDouble(String stringValue) {
    return stringValue == null ? 0.00 : double.parse(stringValue);
  }

  static String bytesToSize(String bytesString) {
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    String output = '';

    if (bytesString == null) {
      output = '0.00';
    } else {
      double bytesInDouble = double.parse(bytesString);

      if (bytesInDouble == 0) output = '';

      var i = (Math.log(bytesInDouble) / Math.log(1024)).floor();

      if (i == 0) output = bytesInDouble.toString() + ' ' + sizes[i];
      output = (bytesInDouble / Math.pow(1024, i)).toStringAsFixed(2) +
          ' ' +
          sizes[i];
    }

    return output;
  }

  static String mbToSize(String mbString) {
    var sizes = ['MB', 'GB', 'TB'];

    String output = '';

    if (mbString == null) {
      output = '0.00';
    } else {
      double mbDouble = double.parse(mbString);

      if (mbDouble == 0)
        output = '0.00';
      else {
        var i = (Math.log(mbDouble) / Math.log(1024)).floor();

        if (i == 0) output = mbDouble.toString() + ' ' + sizes[i];

        output =
            (mbDouble / Math.pow(1024, i)).toStringAsFixed(2) + ' ' + sizes[i];
      }
    }
    return output;
  }

  static String bytesToUnits(String bytesValue) {
    String bytesToUnitsString = '';
    String unitString = " GB";

    if (bytesValue != null) {
      bytesToUnitsString = '';

      double _value = (double.parse(bytesValue) / 1073741824);
      if (_value < 1) {
        unitString = " MB";
        _value = _value * 1024 * 1024;
      } else if (_value >= 1024) {
        unitString = " TB";
        _value = _value / 1024;
      }

      bytesToUnitsString = _value.toStringAsFixed(2) + unitString;
    } else
      bytesToUnitsString = "0.0 GB";

    return bytesToUnitsString;
  }
}
