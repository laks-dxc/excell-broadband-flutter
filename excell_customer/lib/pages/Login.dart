import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ExcellCustomer/pages/OTPCheck.dart';
import '../CodeHelpers.dart';

var loginButtonState = 'a';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var globalContext;
  final customerIdController = TextEditingController();
  final mobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      home: Scaffold(
        backgroundColor:Colors.white,// Color.fromRGBO(184, 27, 77, 10),
        body: loginWidget(),
      ),
    );
  }

  loginButtonPressed() async {
    var customerId = customerIdController.text.trim();
    var mobileNumber = mobileNoController.text.trim();

    // customerId = "78104";
    // mobileNumber = "9115625853";

    CodeHelpers codeHelpers = new CodeHelpers();

    if (customerId.toString().isNotEmpty &&
        mobileNoController.toString().isNotEmpty) {
      setState(() {
        loginButtonState = 'd';
      });

      String otpNeeded = "1";

      Map<String, dynamic> body = {
        "name": "generateToken",
        "param": {
          "custId": customerId,
          "mobileNum": mobileNumber,
          "mobilOTP": otpNeeded
        }
      };

      codeHelpers.httpPost(body).then((response) {
        response.transform(convert.utf8.decoder).join().then((onValue) {
          Map<String, dynamic> response = convert.jsonDecode(onValue);

          var token;

          final int status = response["resonse"]["status"];
          print(status);
          if (status == 200) {
            token = response["resonse"]["result"]["token"];
            print('authToken ' + token);
            codeHelpers.setStorageKey('token', token);
            codeHelpers.setStorageKey('custId', customerId);
            codeHelpers.setStorageKey('mobileNumber', mobileNumber);
            var now = new DateTime.now();
            codeHelpers.setStorageKey('loggedInTime', now.toIso8601String());

            var otp = response["resonse"]["result"]["otp"];

            if (otpNeeded == "1") {
              codeHelpers.setStorageKey('otp', otp.toString());
            }

            Navigator.pushReplacement(globalContext,
                MaterialPageRoute(builder: (context) => OTPCheck()));

          } else {
            Fluttertoast.showToast(
                msg: response["resonse"]["result"]["message"],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Color.fromRGBO(0, 32, 97, 5),
                textColor: Colors.white,
                fontSize: 16.0);
          }

          setState(() {
            loginButtonState = 'a';
          });
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

  Widget loginButton(state) {
    Widget loginButton;

    switch (state) {
      case 'd':
        loginButton = RaisedButton(
          textColor: Colors.white,
          color: Color.fromRGBO(95, 32, 97, 5),
          child: Loading(
            indicator: BallPulseIndicator(),
            size: 40.0,
            color: Colors.white60,
          ),
          onPressed: loginButtonPressed,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        );
        break;
      case 'a':
        loginButton = RaisedButton(
          textColor: Colors.white,
          color: Color.fromRGBO(0, 32, 97, 5),
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 20, letterSpacing: 2.0),
          ),
          onPressed: loginButtonPressed,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        );
        break;
    }
    return loginButton;
  }

  Widget loginWidget() {
    return Stack(
      children: [
        Image.asset('assets/login_bg.png', fit: BoxFit.fill),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_pink.png',

              height: 180,
              width: 180,
            ),
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
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  prefixIcon: Icon(
                    Icons.account_circle,
                    size: 40.0,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),

                  hintText: "Customer Id.",
                  filled: true,
                  // fillColor: Colors.white24,
                  fillColor: Color(0xB1FFFFFF),
                  border: OutlineInputBorder(
                    // borderSide: BorderSide(width: 32.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
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
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  prefixIcon: Icon(
                    Icons.check_circle,
                    size: 40.0,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                  hintText: "Registered Mobile No.",
                  filled: true,
                  fillColor: Color(0xB1FFFFFF),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ),
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 50.0,
              child: loginButton(loginButtonState),
            ),
          ],
        ),
      ],
    );
  }


}
