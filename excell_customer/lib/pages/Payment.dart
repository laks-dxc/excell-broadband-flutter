import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import '../CodeHelpers.dart';

void main() => runApp(Payment(''));

class Payment extends StatefulWidget {
  static const platform = const MethodChannel("test_activity");
  final String msg;
  Payment(this.msg);

  @override
  _PaymentState createState() => _PaymentState(this.msg);
}

class _PaymentState extends State<Payment> {
  CodeHelpers codeHelpers = new CodeHelpers();
  String msg = '';
  var amount;

  _PaymentState(msg) {
    print('msg ' + msg);
    if (msg != '') _getNewActivity({"MSG": msg});
  }

  @override
  void initState() {
    var body = {
      "name": "getCustomerDue",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    codeHelpers.httpPost(body, needAuth: true).then((paymentResponse) {
      paymentResponse
          .transform(convert.utf8.decoder)
          .join()
          .then((paymentsRaw) {
        final paymentDetail = convert.jsonDecode(paymentsRaw);
        setState(() {
          msg = paymentDetail["resonse"]["result"]["msg"];
          amount = paymentDetail["resonse"]["result"]["amount"];
          // print(paymentDetail["resonse"]["result"]);
        });
      });
    });

    super.initState();
  }

  _getNewActivity(pgMsg) async {
    try {
      await Payment.platform.invokeMethod('startNewActivity', pgMsg);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Welcome to Flutter',
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Welcome to Flutters'),
    //     ),
    //     body:
    //   ),
    // );
    return Stack(
      children: <Widget>[
        Image.asset('assets/login_bg.png'),
        Center(
            child: Column(
          children: <Widget>[
            Image.asset(
              'assets/logo_white.png',
              height: 200,
              width: 200,
            ),
            MaterialButton(
              child: amount == null
                  ? Loading(
                      indicator: BallPulseIndicator(),
                      size: 40.0,
                      color: Colors.white60,
                    )
                  : Text(
                      '₹' + amount.toString(),
                      style: TextStyle(fontSize: 20, letterSpacing: 2.0),
                    ),
              elevation: 5.0,
              height: 48.0,
              minWidth: 250.0,
              color: amount == null || amount != 0
                  ? Color.fromRGBO(95, 32, 97, 5)
                  : Color.fromRGBO(0, 32, 97, 5),
              textColor: Colors.white,
              onPressed: () {
                msg != '' && double.parse(amount) > 0
                    ? _getNewActivity({"MSG": msg})
                    : doNothing();
              },
            ),
          ],
        )),
      ],
    );
  }

  void doNothing() {}
}

//"EXCLMDIPVL|10103153|NA|1.18|NA|NA|NA|INR|NA|R|exclmdipvl|NA|NA|F|20200413|H1586786078|NA|NA|NA|Visakhapatnam|1.18|https://billpay.excellmedia.net/billdsk.pl|CA7E96336ED4DD467A3B1FDE14CCECEBEB99727509CA6774274D04342BE30830"
