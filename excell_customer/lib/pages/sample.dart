import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const platform = const MethodChannel("test_activity");

  _getNewActivity(pgMsg) async {
    try {
      await platform.invokeMethod('startNewActivity', pgMsg);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutters'),
        ),
        body: Center(
          child: new MaterialButton(
              child: const Text('Payments'),
              elevation: 5.0,
              height: 48.0,
              minWidth: 250.0,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                _getNewActivity({"MSG": "EXCLMDIPVL|10103153|NA|1.18|NA|NA|NA|INR|NA|R|exclmdipvl|NA|NA|F|20200413|H1586786078|NA|NA|NA|Visakhapatnam|1.18|https://billpay.excellmedia.net/billdsk.pl|CA7E96336ED4DD467A3B1FDE14CCECEBEB99727509CA6774274D04342BE30830"});
              }),
        ),
      ),
    );
  }
}
