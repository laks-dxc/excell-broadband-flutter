import 'dart:io';
import 'dart:convert' as convert;

import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/models/enum.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart';

class NetUtils {
  static String platform = Platform.isIOS ? "IOS" : "Android";
  static String _url = 'https://app.excellbroadband.com/api/index.php';
  // static String _url =
  // 'http://development.excellbroadband.com/api/beta/index.php';

  // static Future<Map<String, dynamic>> apiPostWithTokenv1(body, {String resultField = 'result', String token}) async {
  //   Map<String, dynamic> apiResponse = {};
  //   Map<String, dynamic> response = {};

  //   HttpClient httpClient = new HttpClient();
  //   int status;
  //   String exception;
  //   HttpClientRequest request = await httpClient.postUrl(Uri.parse(_url));
  //   request.headers.set('content-type', 'application/json');
  //   request.headers.set('Source', platform);
  //   request.headers.set('Android_Version', '3');
  //   request.headers.set('Ios_Version', '1');

  //   String _token = await StorageUtils.hasKey(StorageKey.UserToken) ? await StorageUtils.getStorageItem(StorageKey.UserToken) : token;

  //   try {
  //     request.headers.set('Authorization', 'Excell ' + _token);

  //     request.add(convert.utf8.encode(convert.jsonEncode(body)));
  //     HttpClientResponse httpCientResponse = await request.close();
  //     String transformedValue = await httpCientResponse.transform(convert.utf8.decoder).join();

  //     apiResponse = await convert.jsonDecode(transformedValue);

  //     // print("apiResponse " + apiResponse.toString());

  //     status = apiResponse['resonse']['status'];
  //     response = {"status": status, "result": apiResponse['resonse']['result']};
  //   } catch (ex) {
  //     print(ex.toString());
  //     status = -1;
  //     exception = ex.toString();
  //     response = {"status": status, "result": "", "exception": exception};
  //   }

  //   return response;
  // }

  // static Future<Map<String, dynamic>> apiPostWithoutTokenv1(body) async {
  //   Map<String, dynamic> apiResponse = {};
  //   Map<String, dynamic> response = {};

  //   HttpClient httpClient = new HttpClient();
  //   int status;
  //   String exception;

  //   try {
  //     HttpClientRequest request = await httpClient.postUrl(Uri.parse(_url));
  //     request.headers.set('content-type', 'application/json');
  //     request.headers.set('Source', 'Android');
  //     request.add(convert.utf8.encode(convert.jsonEncode(body)));
  //     HttpClientResponse httpCientResponse = await request.close();
  //     String transformedValue = await httpCientResponse.transform(convert.utf8.decoder).join();
  //     apiResponse = await convert.jsonDecode(transformedValue);

  //     if (apiResponse['resonse'] == null) {
  //       status = apiResponse['error']['status'];
  //       response = {"status": status, "result": null};
  //     } else {
  //       status = apiResponse['resonse']['status'];
  //       response = {"status": status, "result": apiResponse['resonse']['result']};
  //     }
  //   } catch (ex) {
  //     status = -1;
  //     exception = ex.toString();
  //     response = {"status": status, "result": "", "exception": exception};
  //   }

  //   return response;
  // }

  static Future<Map<String, dynamic>> apiPostWithToken(body,
      {String resultField = 'result', String token}) async {
    Map<String, dynamic> apiResponse = {};
    Map<String, dynamic> response = {};

    HttpClient httpClient = new HttpClient();
    int status;
    String exception;
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Source', platform);

    String _token = await StorageUtils.hasKey(StorageKey.UserToken)
        ? await StorageUtils.getStorageItem(StorageKey.UserToken)
        : token;

    try {
      request.headers.set('Authorization', 'Excell ' + _token);

      request.add(convert.utf8.encode(convert.jsonEncode(body)));
      HttpClientResponse httpCientResponse = await request.close();
      String transformedValue =
          await httpCientResponse.transform(convert.utf8.decoder).join();

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

  static Future<String> apiPostWithTokenReturnPDF(body,
      {String resultField = 'result', String token}) async {
    var uri = Uri.parse(_url);

    String _token = await StorageUtils.hasKey(StorageKey.UserToken)
        ? await StorageUtils.getStorageItem(StorageKey.UserToken)
        : token;

    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          'Source': platform,
          'Authorization': 'Excell ' + _token
        },
        body: convert.utf8.encode(json.encode(body)));

    Directory appsDir = await getApplicationDocumentsDirectory();
    String appsDirPath = appsDir.path;
    File file = new File('$appsDirPath/invoice.pdf');
    await file.writeAsBytes(response.bodyBytes);
    String filePath = file.path;
    return filePath;
    // await OpenFile.open(filePath);

    // File myFile = await new File(filePath).create();
    // print(filePath + " is the old file path");
    // print(myFile.path + " is the new file path");
    // await FlutterShareFile.share(myFile.path, '.toString()', ShareFileType.pdf);
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
      request.headers.set('Source', platform);
      request.headers.set('content-type', 'application/json');

      request.headers.set('Android_Version', '3');
      request.headers.set('Ios_Version', '1');
      request.add(convert.utf8.encode(convert.jsonEncode(body)));
      HttpClientResponse httpCientResponse = await request.close();
      String transformedValue =
          await httpCientResponse.transform(convert.utf8.decoder).join();
      apiResponse = await convert.jsonDecode(transformedValue);

      if (apiResponse['resonse'] == null) {
        status = apiResponse['error']['status'];
        response = {"status": status, "result": null};
      } else {
        status = apiResponse['resonse']['status'];
        response = {
          "status": status,
          "result": apiResponse['resonse']['result']
        };
      }
    } catch (ex) {
      status = -1;
      exception = ex.toString();
      response = {"status": status, "result": "", "exception": exception};
    }

    return response;
  }
}
