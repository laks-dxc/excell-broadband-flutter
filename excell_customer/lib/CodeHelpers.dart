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

    if (needAuth == true)
      request.headers
          .set('Authorization', "Excell " + this.getStorageKey("token"));

    request.add(utf8.encode(convert.jsonEncode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    return response;
  }

  setStorageKey(key, value) {
    storage.setItem(key, value);
  }

  String getStorageKey(key) {
    // storage.getItem(key)

    return storage.getItem(key);
  }

  double bytesToGB(double bytes) {
    return bytes / 1073741824;
  }

  List<String> getURLs() {
    // return new Future.delayed(const Duration(seconds: 10), () {

    // });

    return [
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      // 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      // 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    ];
  }
}
