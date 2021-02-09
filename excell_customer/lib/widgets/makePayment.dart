import 'dart:async';
// import 'dart:html';

import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:ExcellCustomer/topupsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../payments.dart';
// import 'dart:io' show Platform;

void main() => runApp(MakePayment(''));

class MakePayment extends StatefulWidget {
  static const platform = const MethodChannel("test_activity");
  final String msg;
  final String source;
  final String pkgnum;
  MakePayment(this.msg, {this.source, this.pkgnum});

  @override
  _MakePaymentState createState() => _MakePaymentState(this.msg, source: this.source, pkgnum: this.pkgnum);
}

class _MakePaymentState extends State<MakePayment> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  String msg = '';
  double amount = 00.0;
  String source = "not set";
  String pkgnum;
  bool isResumed = false;

  _MakePaymentState(msg, {source, pkgnum}) {
    // print('msg ' + msg);
    this.source = source;
    this.pkgnum = pkgnum;
    if (msg != '') _getNewActivity({"MSG": msg});
  }

  @override
  void initState() {
    //ignore: missing_return
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.resumed.toString()) {
        setState(() {
          isResumed = true;
        });
      }
    });

    super.initState();
  }

  _getNewActivity(pgMsg) async {
    try {
      await MakePayment.platform.invokeMethod('startNewActivity', pgMsg);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("souce " + source);
    if (isResumed) {
      Timer(Duration(milliseconds: 100), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
              backgroundColor: selectedTheme.scaffoldBgColor,
              appBar: AppBar(title: source == "topups" ? Text("Select Topup") : Text("Payment"), backgroundColor: selectedTheme.appBarColor //(0xff112c75),
                  ),
              body: source == "topups" ? TopupsList(pkgnum) : Payment(),
            ),
          ),
        );
      });
      return Scaffold(body: SpinKitCircle(size: 30, color: Colors.grey));
    } else
      return Scaffold(body: SpinKitCircle(size: 30, color: Colors.grey));

    // Scaffold(
    //   body: Stack(
    //     children: <Widget>[
    //       Image.asset('assets/login_bg.png'),
    //       Center(
    //         child: MaterialButton(
    //           child: amount == null
    //               ? SpinKitCircle(size: 30, color: Colors.grey)
    //               : Text(
    //                   '₹ ' + amount.toString(),
    //                   style: TextStyle(fontSize: 20, letterSpacing: 2.0),
    //                 ),
    //           elevation: 5.0,
    //           height: 48.0,
    //           minWidth: 250.0,
    //           color: selectedTheme.appBarColor,
    //           textColor: Colors.white,
    //           onPressed: () {
    //             msg != '' && amount > 0.0 ? _getNewActivity({"MSG": msg}) : doNothing();
    //           },
    //         ),
    //       ),
    //     ],
    //   ),

    // );
  }

  void doNothing() {}
}

//"EXCLMDIPVL|10103153|NA|1.18|NA|NA|NA|INR|NA|R|exclmdipvl|NA|NA|F|20200413|H1586786078|NA|NA|NA|Visakhapatnam|1.18|https://billpay.excellmedia.net/billdsk.pl|CA7E96336ED4DD467A3B1FDE14CCECEBEB99727509CA6774274D04342BE30830"
