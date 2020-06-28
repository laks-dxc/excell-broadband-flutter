import 'dart:io';
import 'dart:convert' as convert;

import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';

class NetUtils {
  static String _url = 'http://app.excellbroadband.com/api/index.php';

  static Future<Map<String, dynamic>> apiPostWithToken(body,
      {String resultField = 'result', String token}) async {
    Map<String, dynamic> apiResponse = {};
    Map<String, dynamic> response = {};

    HttpClient httpClient = new HttpClient();
    int status;
    String exception;
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_url));
    request.headers.set('content-type', 'application/json');

    String _token = await StorageUtils.hasKey(StorageKey.UserToken)
        ? await StorageUtils.getStorageItem(StorageKey.UserToken)
        : token;

    try {
      request.headers.set('Authorization', 'Excell ' + _token);
      request.add(convert.utf8.encode(convert.jsonEncode(body)));
      HttpClientResponse httpCientResponse = await request.close();
      String transformedValue = await httpCientResponse.transform(convert.utf8.decoder).join();

      apiResponse = await convert.jsonDecode(transformedValue);

      status = apiResponse['resonse']['status'];
      response = {"status": status, "result": apiResponse['resonse']['result']};
    } catch (ex) {
      print(ex.toString());
      status = -1;
      exception = ex.toString();
      response = {"status": status, "result": "", "exception": exception};
    }

    return response;
  }

  static Future<Map<String, dynamic>> apiPostWithoutToken(body) async {
    Map<String, dynamic> apiResponse = {};
    Map<String, dynamic> response = {};

    HttpClient httpClient = new HttpClient();
    int status;
    String exception;

    try {
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(_url));
      request.headers.set('content-type', 'application/json');
      request.add(convert.utf8.encode(convert.jsonEncode(body)));
      HttpClientResponse httpCientResponse = await request.close();
      String transformedValue = await httpCientResponse.transform(convert.utf8.decoder).join();
      apiResponse = await convert.jsonDecode(transformedValue);
    

      if (apiResponse['resonse'] == null) {
        status = apiResponse['error']['status'];
        response = {"status": status, "result": null};
      } else {
        status = apiResponse['resonse']['status'];
        response = {"status": status, "result": apiResponse['resonse']['result']};
      }
    } catch (ex) {
      status = -1;
      exception = ex.toString();
      response = {"status": status, "result": "", "exception": exception};
    }

    return response;
  }
}
