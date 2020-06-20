import 'dart:io';
import 'dart:convert' as convert;

import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';

class NetUtils {
  static String _url = 'http://app.excellbroadband.com/api/index.php';

  // static String _url = 'http://localhost:3000/sample/post';

  static Future<Map<String, dynamic>> apiPostWithToken(body, {String token}) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_url));
    request.headers.set('content-type', 'application/json');
    String userToken = token == null ?? StorageUtils.getStorageItem(StorageKeys.UserToken);
    request.headers.set('Authorization', 'Excell ' + userToken);
    request.add(convert.utf8.encode(convert.jsonEncode(body)));
    HttpClientResponse response = await request.close();

    String transformedValue = await response.transform(convert.utf8.decoder).join();
    Map<String, dynamic> apiResponse = await convert.jsonDecode(transformedValue);

    return apiResponse;
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
      status = apiResponse['resonse']['status'];
      response = {"status": status, "result": apiResponse['resonse']['result']};
    } catch (ex) {
      status = -1;
      exception = ex.toString();
      response = {"status": status, "result": "", "exception": exception};
    }

    return response;
  }
}
