// import 'dart:io';

import 'package:ExcellBroadband/dashobard.dart';
import 'package:ExcellBroadband/models/lsItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';

import 'helpers/fadeInX.dart';
import 'helpers/constants.dart';
import 'helpers/fadeInY.dart';
import 'helpers/taost_utils.dart';
import 'helpers/utilities.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool formValid = false;
  bool otpCorrect = false;
  bool quickPayLoading = false;
  String quickPayFooter = 'initial';
  String loginFooter = 'initial';
  bool loginLoading = false;
  int originalOTP;
  String token, custId, mobileNo;
  bool dashboardDataLoading = false;

  final LocalStorage storage = new LocalStorage('exbb_app');

  double quickPayPayableAmount = -1;

  final textEditingController = TextEditingController();

  _saveToStorage(LSItemList list) {
    storage.setItem('exbb_lsitems', list.toJSONEncodable());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Image.asset(
              "assets/login_bg.png",
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FadeInX(
                  2,
                  Image.asset(
                    "assets/logo_pink.png",
                    height: 190,
                    width: 190,
                  ),
                  translate: false,
                  duration: 3.0,
                ),
              ),
              SizedBox(height: 20),
              FadeInX(
                  3.0,
                  Text(
                    "Welcome to Excell Broadband",
                    style: TextStyle(fontSize: 26),
                  ),
                  translate: false,
                  duration: 3),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              mainScreenOption(
                "Account",
                subText: "Your package, consumption & payment information",
                sequence: 4.0,
                imageURI: 'assets/11.png',
                onTap: () {
                  storage.getItem('exbb_lsitems') == null
                      ? loginDialog(context)
                      : Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                              child: Dashboard()));
                },
              ),
              SizedBox(height: 20),
              mainScreenOption("Quick Pay",
                  subText: "Make payment for your broadband subscription",
                  sequence: 5.0,
                  imageURI: 'assets/22.png',
                  onTap: () => quickPayDialog(context)),
              SizedBox(height: 20),
              mainScreenOption("New Connection",
                  subText: "Raise enquiry for a new broadband connection ",
                  sequence: 6.0,
                  imageURI: 'assets/44.png'),
            ],
          )
        ],
      ),
    );
  }

  mainScreenOption(mainText, {sequence: 1.0, subText, imageURI, onTap}) {
    double cWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FadeInX(
            sequence,
            Container(
              height: 80,
              width: cWidth * 0.80,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-3.0, 0.0),
                    color: Colors.grey[800],
                    blurRadius: 5.0,
                    // blurStyle: BlurStyle.outer
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    bottomLeft: Radius.circular(90)),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: Constants.colors['gradient_colors3'],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(imageURI),
                  SizedBox(
                    width: 25,
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        mainText,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 25,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void loginDialog(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width;

    final customerIdController = TextEditingController();
    final mobileNoController = TextEditingController();

    customerIdController.text = '46888';
    mobileNoController.text = '830903863';

    StatefulBuilder loginDialog =
        StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: cWidth * 0.7,
          width: cWidth * 0.8,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: cWidth * 0.8,
                child: loginFooter == 'initial'
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 60),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    formValid =
                                        mobileNoController.text.trim().length ==
                                                10 &&
                                            value.trim().length > 0;
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: customerIdController,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: "Customer Id",
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16.0, left: 16.0, top: 8.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    formValid = customerIdController.text
                                                .trim()
                                                .length >
                                            0 &&
                                        value.trim().length == 10;
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                controller: mobileNoController,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: "Mobile No.",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : FadeInY(
                        1.0,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 65),
                            Text(
                              "OTP sent to " + mobileNoController.text,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 20),
                            // otpContainer('1234'),
                            Container(
                              width: cWidth * 0.6,
                              child: PinCodeTextField(
                                length: 4,
                                obsecureText: false,
                                autoFocus: true,
                                textInputType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                                animationType: AnimationType.fade,
                                backgroundColor: Colors.transparent,
                                textStyle: TextStyle(fontSize: 35),
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(15),
                                  fieldHeight: 60,
                                  fieldWidth: 60,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                onCompleted: (v) {
                                  if (v.toString() == originalOTP.toString()) {
                                    setState(() {
                                      // loginFooter = 'initial';
                                      otpCorrect = true;
                                    });
                                    print("Completed");
                                  } else {
                                    ToastUtils.showCustomToast(
                                        context, "Wrong OTP entered");
                                  }
                                },
                                onChanged: (value) {
                                  // print(value);
                                  // setState(() {
                                  //   currentText = value;
                                  // });
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              // "Resend in 58 seconds",
                              "",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        distance: -10.0,
                      ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: Constants.colors['gradient_colors3'],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    if (otpCorrect && !dashboardDataLoading) {
                      LSItemList lsItemList = new LSItemList();
                      setState(() {
                        dashboardDataLoading = true;
                      });

                      Utilities.apiPost({
                        "name": "getCustomerDetails",
                        "param": {"customerId": custId}
                      }, token: token)
                          .then((response) {
                        dynamic custDetails = response['resonse']['result'];

                        final LSItem lsItem = new LSItem(
                          token: token,
                          custId: custId,
                          mobileNo: mobileNo,
                          cutomerName: custDetails['cutomerName'],
                          contactno: custDetails['contactno'],
                          altcontactno: custDetails['altcontactno'],
                          address: custDetails['address'],
                          city: custDetails['city'],
                          state: custDetails['state'],
                          emailid: custDetails['emailid'],
                        );

                        lsItemList.items.add(lsItem);
                        _saveToStorage(lsItemList);
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                                child: Dashboard()));
                        setState(() {
                          // dashboardDataLoading = false;
                        });
                      });
                    } else if (formValid &&
                        !loginLoading &&
                        loginFooter == 'initial') {
                      setState(() {
                        loginLoading = true;
                      });

                      Utilities.apiPost({
                        "name": "generateToken",
                        "param": {
                          "custId": customerIdController.text.trim(),
                          "mobileNum": mobileNoController.text.trim(),
                          "mobilOTP": "1"
                        }
                      }, needAuth: false)
                          .then((response) {
                        int status = Utilities.getStatus(response);
                        if (status == 200) {
                          setState(() {
                            mobileNo = mobileNoController.text.trim();
                            custId = customerIdController.text.trim();
                            token = response['resonse']['result']['token'];
                            originalOTP = response['resonse']['result']['otp'];
                          });
                          print("OTP: " + originalOTP.toString());
                          setState(() {
                            // loginLoading = false;
                            loginFooter = 'otp';
                          });
                        } else {
                          ToastUtils.showCustomToast(context,
                              response['resonse']['result']['message']);
                          setState(() {
                            loginLoading = false;
                          });

                          //"This is a toast message");

                        }
                      });
                    }
                  },
                  child: loginFooter == 'initial'
                      ? AnimatedContainer(
                          decoration: BoxDecoration(
                            color: formValid == true
                                ? Colors.blue[300]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: loginLoading
                                  ? SpinKitCircle(
                                      color: Colors.deepPurple,
                                      size: 25.0,
                                    )
                                  : Text(
                                      "Continue",
                                      style: TextStyle(
                                          color: formValid == true
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                          duration: Duration(milliseconds: 300),
                        )
                      : AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: otpCorrect == true
                                ? Colors.blue[300]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: dashboardDataLoading
                                  ? SpinKitCircle(
                                      color: Colors.deepPurple,
                                      size: 25.0,
                                    )
                                  : Text(
                                      "Continue",
                                      style: TextStyle(
                                          color: otpCorrect == true
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                        ),
                ),
              ),
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.95, -0.93),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FadeInY(
              0.0,
              loginDialog,
              distance: -40.0,
            )).then((value) => {
          setState(() {
            formValid = false;
            loginFooter = 'initial';
            loginLoading = false;
            otpCorrect = false;
            dashboardDataLoading = false;
          })
        });
  }

  void quickPayDialog(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width;

    final customerIdController = TextEditingController();
    final mobileNoController = TextEditingController();

    customerIdController.text = '46888';
    mobileNoController.text = '830903863';

    StatefulBuilder quickpayDialog =
        StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: cWidth * 0.7,
          width: cWidth * 0.8,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: cWidth * 0.8,
                child: quickPayFooter == 'initial'
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 60),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    formValid =
                                        mobileNoController.text.trim().length ==
                                                10 &&
                                            value.trim().length > 0;
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: customerIdController,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: "Customer Id",
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16.0, left: 16.0, top: 8.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    formValid = customerIdController.text
                                                .trim()
                                                .length >
                                            0 &&
                                        value.trim().length == 10;
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                controller: mobileNoController,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(184, 27, 77, 10),
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  labelText: "Mobile No.",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : quickPayPayableAmount == 0.0
                        ? FadeInY(
                            1.0,
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "No Dues",
                                style: TextStyle(fontSize: 40.0),
                              ),
                            ),
                            distance: -10.0,
                          )
                        : quickPayPayableAmount == -1.0
                            ? Text("Unkown Error",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.red,
                                ))
                            : FadeInY(
                                1.0,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Payable Amount",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    Text(
                                      "Rs. " +
                                          quickPayPayableAmount
                                              .toStringAsFixed(2),
                                      style: TextStyle(fontSize: 40.0),
                                    ),
                                  ],
                                ),
                                distance: -10.0,
                              ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: Constants.colors['gradient_colors3'],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Quick Pay",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    if (formValid &&
                        !quickPayLoading &&
                        quickPayFooter == 'initial') {
                      setState(() {
                        quickPayLoading = true;
                      });

                      Utilities.getUserToken(customerIdController.text.trim(),
                              mobileNoController.text.trim())
                          .then((_token) {
                        if (_token == "-1") {
                          ToastUtils.showCustomToast(
                              context, "Incorrect Customer Id or Mobile No ");
                          setState(() {
                            quickPayLoading = false;
                          });
                        } else
                          Utilities.apiPost({
                            "name": "getCustomerDue",
                            "param": {
                              "customerId": customerIdController.text.trim(),
                              "mobileNum": mobileNoController.text.trim()
                            }
                          }, token: _token)
                              .then((response) {
                            setState(() {
                              quickPayLoading = false;
                              quickPayFooter = 'pay';
                            });

                            int status = Utilities.getStatus(response);
                            if (status == 200) {
                              setState(() {
                                quickPayPayableAmount = double.parse(
                                    response['resonse']['result']['amount']);
                              });
                            } else {}
                          });
                      });
                    }
                  },
                  child: quickPayFooter == 'initial'
                      ? AnimatedContainer(
                          decoration: BoxDecoration(
                            color: formValid == true
                                ? Colors.blue[300]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: quickPayLoading
                                  ? SpinKitCircle(
                                      color: Colors.deepPurple,
                                      size: 25.0,
                                    )
                                  : Text(
                                      "Continue",
                                      style: TextStyle(
                                          color: formValid == true
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                          duration: Duration(milliseconds: 300),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: formValid == true
                                ? Colors.blue[300]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: quickPayPayableAmount == 0.0
                                  ? Text(
                                      "Close",
                                      style: TextStyle(
                                          color: formValid == true
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "Pay Now",
                                      style: TextStyle(
                                          color: formValid == true
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                        ),
                ),
              ),
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.95, -0.93),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FadeInY(
              0.0,
              quickpayDialog,
              distance: -40.0,
            )).then((value) => {
          setState(() {
            formValid = false;
            quickPayFooter = 'initial';
            quickPayLoading = false;
          })
        });
  }
}
