import 'dart:convert' as convert;

import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import '../CodeHelpers.dart';
import 'Payment.dart';

class QuickPay extends StatefulWidget {
  @override
  _QuickPayState createState() => _QuickPayState();
}

class _QuickPayState extends State<QuickPay> {
  final customerIdController = TextEditingController();
  final mobileNoController = TextEditingController();
  final dueAmountController = TextEditingController();
  var getDuesButtonState = 'a';
  bool getDuesLoaded = false;
  var globalContext;

  String amount, pgMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          title: Text("Quick Pay"),
          backgroundColor: Color.fromRGBO(184, 27, 77, 10)),
      backgroundColor: Colors.white, //Color.fromRGBO(184, 27, 77, 10),
      body: loginWidget(),
    );
  }

  Widget loginWidget() {
    return Stack(
      children: [
        Image.asset('assets/login_bg.png', fit: BoxFit.fill),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_pink.png',
              height: 150,
              width: 150,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: customerIdController,
                      // autofocus: true,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(184, 27, 77, 10),
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          size: 40.0,
                          color: Color.fromRGBO(184, 27, 77, 10),
                        ),
                        border: OutlineInputBorder(
                          // borderSide: BorderSide(width: 32.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: "Customer Id.",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      controller: mobileNoController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(184, 27, 77, 10),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        prefixIcon: Icon(
                          Icons.check_circle,
                          size: 40.0,
                          color: Color.fromRGBO(184, 27, 77, 10),
                        ),
                        hintText: "Registered Mobile No.",
                        // filled: true,
                        // fillColor: Color(0xB1FFFFFF),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
                  ),
                  // WidgetAnimator(
                  getDuesLoaded == true ? getDuesLabelContainer() : Text(""),
                  getDuesLoaded == false
                      ? getDuesButtonTheme()
                      : amount == "0" ? goBackButton() : payNowButton(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  ButtonTheme getDuesButtonTheme() {
    return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
      child: getDuesButton(getDuesButtonState),
    );
  }

// controller: ,
  WidgetAnimator getDuesLabelContainer() {
    return WidgetAnimator(Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        enabled: false,
        controller: dueAmountController,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Color.fromRGBO(184, 27, 77, 10),
            ),
          ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(25.0),
          // ),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          prefixIcon: Icon(
            Icons.note,
            size: 40.0,
            color: Color.fromRGBO(184, 27, 77, 10),
          ),
          hintText: "Registered Mobile No.",
          // filled: true,
          // fillColor: Color(0xB1FFFFFF),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    ));
  }

  Widget goBackButton() {
    return WidgetAnimator(
      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        child: RaisedButton(
          textColor: Colors.white,
          color: Color.fromRGBO(95, 32, 97, 10),
          child: Text(
            "Go Back",
            style: TextStyle(fontSize: 20, letterSpacing: 2.0),
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          }, //getDuesButtonPressed,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Widget payNowButton() {
    return WidgetAnimator(
      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        child: RaisedButton(
          textColor: Colors.white,
          color: Color.fromRGBO(95, 32, 97, 10),
          child: Text(
            "Pay Now",
            style: TextStyle(fontSize: 20, letterSpacing: 2.0),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Payment(pgMsg)));
          }, //getDuesButtonPressed,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Widget getDuesButton(state) {
    Widget getDuesButton;

    switch (state) {
      case 'd':
        getDuesButton = RaisedButton(
          textColor: Colors.white,
          color: Color.fromRGBO(95, 32, 97, 5),
          child: Loading(
            indicator: BallPulseIndicator(),
            size: 40.0,
            color: Colors.white60,
          ),
          onPressed: getDuesButtonPressed,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        );
        break;
      case 'a':
        getDuesButton = RaisedButton(
          textColor: Colors.white,
          color: Color.fromRGBO(0, 32, 97, 5),
          child: Text(
            "Get Dues",
            style: TextStyle(fontSize: 20, letterSpacing: 2.0),
          ),
          onPressed: getDuesButtonPressed,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        );
        break;
    }
    return getDuesButton;
  }

  getDuesButtonPressed() async {
    var customerId = customerIdController.text.trim();
    var mobileNumber = mobileNoController.text.trim();

    // customerId = "78104";
    // mobileNumber = "9115625853";

    CodeHelpers codeHelpers = new CodeHelpers();

    if (customerId.toString().isNotEmpty &&
        mobileNoController.toString().isNotEmpty) {
      String otpNeeded = "0";

      Map<String, dynamic> body = {
        "name": "generateToken",
        "param": {
          "custId": customerId,
          "mobileNum": mobileNumber,
          "mobilOTP": otpNeeded
        }
      };
      setState(() {
        getDuesButtonState = 'd';
      });

      codeHelpers.httpPost(body).then((response) {
        response.transform(convert.utf8.decoder).join().then((onValue) {
          Map<String, dynamic> response = convert.jsonDecode(onValue);

          final int status = response["resonse"]["status"];

          print(status);

          if (status == 200) {
            final qpToken = response["resonse"]["result"]["token"];

            Map<String, dynamic> customerDueBody = {
              "name": "getCustomerDue",
              "param": {"customerId": customerId}
            };

            codeHelpers
                .httpPost(customerDueBody,
                    tempToken: qpToken, useTempToken: true)
                .then((onValue) {
              onValue.transform(convert.utf8.decoder).join().then((payments) {
                Map<String, dynamic> paymentDetail =
                    convert.jsonDecode(payments);

                setState(() {
                  amount = paymentDetail["resonse"]["result"]["amount"];
                  pgMsg = paymentDetail["resonse"]["result"]["msg"];

                  amount.startsWith('ID Phone Mismatch')
                      ? dueAmountController.text = ' ID Phone Mismatch'
                      : amount == "0"
                          ? dueAmountController.text = "No Dues"
                          : dueAmountController.text = '₹ ' + amount;

                  getDuesButtonState = 'a';
                  getDuesLoaded = true;

                  // print(amount + " " + pgMsg);
                });
              });
            });
          } else {
            Fluttertoast.showToast(
                msg: response["resonse"]["result"]["message"],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Color.fromRGBO(0, 32, 97, 5),
                textColor: Colors.white,
                fontSize: 16.0);

            setState(() {
              getDuesButtonState = 'a';
            });
          }
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please enter Customer Id & Mobile No.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Color.fromRGBO(0, 32, 97, 5),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
