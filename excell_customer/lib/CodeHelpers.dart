import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:localstorage/localstorage.dart';

final _baseUrl = "http://app.excellbroadband.com/api/index.php";

class CodeHelpers {
  final LocalStorage storage = new LocalStorage('excell_customer_app');

  Future<HttpClientResponse> httpPost(body, {needAuth: false}) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_baseUrl));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', "Excell " + this.getStorageKey("token"));
    request.add(utf8.encode(convert.jsonEncode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  setStorageKey(key, value) {
    storage.setItem(key, value);
  }

  String getStorageKey(key) {

    return storage.getItem(key);
  
  
  }

  
}
