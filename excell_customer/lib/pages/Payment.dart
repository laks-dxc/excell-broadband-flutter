import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:ExcellCustomer/widgets/custom_expansiontile.dart' as custom;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CodeHelpers.dart';

void main() => runApp(Payment());

class Payment extends StatefulWidget {
  static const platform = const MethodChannel("test_activity");

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  CodeHelpers codeHelpers = new CodeHelpers();
  String msg = '';
  var amount;

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
              child: Text(
                'Pay ' + (amount == null ? '...' : '₹' + amount.toString()),
                style: TextStyle(fontSize: 20, letterSpacing: 2.0),
              ),
              elevation: 5.0,
              height: 48.0,
              minWidth: 250.0,
              color: Color.fromRGBO(0, 32, 97, 5),
              textColor: Colors.white,
              onPressed: () {
                msg != '' ? _getNewActivity({"MSG": msg}) : doNothing();
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
