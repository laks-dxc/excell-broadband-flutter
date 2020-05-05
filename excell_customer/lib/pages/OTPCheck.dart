import 'dart:convert' as convert;
import 'dart:async';

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/CustomerPages.dart';
import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class OTPCheck extends StatefulWidget {
  @override
  _OTPCheckState createState() => _OTPCheckState();
}

class _OTPCheckState extends State<OTPCheck> {
  var currentText = '';
  var globalContext, mobileNum;
  CodeHelpers codeHelpers = new CodeHelpers();

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  checkOTP(String enteredOTP) {
    String otpFromStorage = codeHelpers.getStorageKey('otp').toString();

    if (otpFromStorage == enteredOTP) {
      {
        
        codeHelpers.setStorageKey('otp', '');
        codeHelpers.setStorageKey('loggedIn', '1');

        var body = {
          "name": "saveFBToken",
          "param": {
            "customerId": codeHelpers.getStorageKey('custId'),
            "fbToken": codeHelpers.getStorageKey('fbToken'),
            "appVersion": "1.0",
            "mobileNo": codeHelpers.getStorageKey('mobileNumber'),
            "mobileOs": "Android"
          }
        };

        print("fbTokenBody" + " " + body.toString());

        codeHelpers.httpPost(body, needAuth: true).then((onValue) {
          onValue
              .transform(convert.utf8.decoder)
              .join()
              .then((tokenSavedResponse) {
                
            // Map<String, dynamic> fbTokenSaved =
            //     convert.jsonDecode(tokenSavedResponse);

            // print("fbTokenSaved " + " " + fbTokenSaved.toString());
            
            Navigator.pushReplacement(globalContext,
                MaterialPageRoute(builder: (context) => CustomerPages()));
          });
        });
      }
    } else
      print("OTP Not Matched");
  }

  Timer timer;
  int _start = 60;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer _timer) => setState(
        () {
          if (_start < 1) {
            _timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    mobileNum = codeHelpers.getStorageKey("mobileNumber");

    print("OTP is " + codeHelpers.getStorageKey('otp').toString());
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color.fromRGBO(184, 27, 77, 10),
          body: Stack(
            children: <Widget>[
              Image.asset('assets/login_bg.png', fit: BoxFit.fill),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo_white.png',
                    width: 180,
                    height: 180,
                  ),
                  Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  PinCodeTextField(
                    backgroundColor: Color.fromRGBO(0, 27, 77, 0),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    enableActiveFill: true,
                    inactiveFillColor: Color.fromRGBO(0, 32, 97, 5),
                    activeFillColor: Color.fromRGBO(0, 32, 97, 5),
                    selectedFillColor: Color.fromRGBO(0, 32, 97, 5),
                    borderWidth: 0.0,
                    activeColor: Colors.transparent,
                    textInputType: TextInputType.number,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 24.0),
                    autoFocus: true,
                    length: 4,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.circle,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    // checkOTP(otpValue)
                    // onSubmitted: (otpValue) => checkOTP(otpValue),

                    onChanged: (value) {
                      if (value.toString().length == 4)
                        checkOTP(value.toString());
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "OTP sent to " + mobileNum,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  _start > 0
                      ? Text(
                          "Resend in " + _start.toString() + " seconds",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      : Text(""),
                ],
              ),
            ],
          )),
    );
  }
}
