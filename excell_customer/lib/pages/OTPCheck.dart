import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OTPCheck extends StatefulWidget {
  @override
  _OTPCheckState createState() => _OTPCheckState();
}

class _OTPCheckState extends State<OTPCheck> {
  var currentText = '';
  var globalContext, mobileNum;
  CodeHelpers codeHelpers = new CodeHelpers();

  checkOTP(String enteredOTP) {
    String otpFromStorage = codeHelpers.getStorageKey('otp').toString();

    if (otpFromStorage == enteredOTP) {
      {
        codeHelpers.setStorageKey('otp', '');

        Navigator.push(globalContext,
            MaterialPageRoute(builder: (context) => GaugeChart(_createSampleData())));
      }
    } else
      print("OTP Not Matched");
  }


  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Low', 599931181121),
      new GaugeSegment('Acceptable', 707305363521),
      new GaugeSegment('High', 50),
      // new GaugeSegment('Highly Unusual', 5),
    ];


    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    mobileNum = codeHelpers.getStorageKey("mobileNumber");

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
              Image.asset('assets/logo_white.png', width: 180, height: 180,),

                  Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "OTP sent to " + mobileNum,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
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
                ],
              ),
            ],
          )),
    );
  }

  
}
