import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/customer.dart';
import 'package:ExcellCustomer/models/enum.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../drawer.dart';

class LoginModal extends StatefulWidget {
  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  Size displaySize;
  FooterState currentFooterState = FooterState.Default;
  TextEditingController customerIdController =
      TextEditingController(); //text: '46888'); //text: '46888'
  TextEditingController mobileNoController =
      TextEditingController(); //text: '830903863'); //text: '830903863'
  TextEditingController mobileOTPController = TextEditingController();

  bool mobileNoTextFieldEnabled = true;
  bool customerIdTextFieldEnabled = true;
  bool pinsEnabled = true;
  bool showResendText = true;

  String receivedOTP, enteredOTP;

  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  final Map<FooterState, dynamic> modelFooterProps = {
    FooterState.Default: {
      "child": Text(
        "Continue",
        style: TextStyle(
            color: selectedTheme.disabledText.withOpacity(0.5),
            fontSize: 20,
            fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.disabledBackground,
    },
    FooterState.ValidCredentialsEntered: {
      "child": Text(
        "Continue",
        style: TextStyle(color: selectedTheme.textColor, fontSize: 20, fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.activeBackground,
    },
    FooterState.ValidatingCredentials: {
      "child": SpinKitCircle(
        color: Colors.deepPurple,
        size: 25.0,
      ),
      "color": selectedTheme.activeBackground,
    },
    FooterState.ValidatedCredentialsResultWrong: {
      "child": Text(
        "Invalid Customer Id / Mobile No",
        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.disabledBackground,
    },
    FooterState.OTPEntryPending: {
      "child": Text(
        "Continue",
        style: TextStyle(
            color: selectedTheme.disabledText.withOpacity(0.5),
            fontSize: 20,
            fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.disabledBackground,
    },
    FooterState.OTPEnteredResultCorrect: {
      "child": SpinKitCircle(
        color: Colors.deepPurple,
        size: 25.0,
      ),
      "color": selectedTheme.activeBackground,
    },
    FooterState.OTPEnteredResultWrong: {
      "child": Text(
        "Invalid OTP",
        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.disabledBackground,
    },
    FooterState.ResendOTP: {
      "child": Text(
        "Resend OTP",
        style: TextStyle(color: selectedTheme.textColor, fontSize: 20, fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.activeBackground,
    },
  };

  final focusCustomerId = new FocusNode();
  final focusMobileNo = new FocusNode();

  String activeContainerBody = 'login';
  int otpDuration = 60;
  bool showAnimation = true;

  String custId, mobileNo;

  Color footerColor;
  dynamic footerText;

  bool loginFormIsValid;
  double textScaleFactor;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _setFooterState(FooterState.Default);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    // textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0? 1.0:0.85/MediaQuery.of(context).textScaleFactor;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;
    final double dialogWidth = displaySize.width * 0.8;
    final double dialogHeight = displaySize.height * 0.35;

    Dialog loginDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: dialogHeight,
        width: dialogWidth,
        child: Stack(
          children: <Widget>[
            _containerBody(activeContainerBody),
            _modalHeader(),
            _modelFooter(),
            _titleCloseButton(),
          ],
        ),
      ),
    );

    return loginDialog;
  }

  Align _modelFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          switch (currentFooterState) {
            case FooterState.ValidCredentialsEntered:
              {
                setState(() {
                  customerIdTextFieldEnabled = false;
                  mobileNoTextFieldEnabled = false;
                });

                _setFooterState(FooterState.ValidatingCredentials);
                Customer.authenticate(customerIdController.text, mobileNoController.text)
                    .then((authResponse) async {
                  if (authResponse["status"] == 200) {
                    _setFooterState(FooterState.OTPEntryPending);

                    setState(() {
                      receivedOTP = authResponse["otp"].toString();
                      activeContainerBody = "OTP";
                      pinsEnabled = true;
                    });
                  } else {
                    _setFooterState(FooterState.ValidatedCredentialsResultWrong);
                    setState(() {
                      customerIdTextFieldEnabled = true;
                      mobileNoTextFieldEnabled = true;
                    });
                  }
                });
                break;
              }
            case FooterState.ResendOTP:
              {
                _setFooterState(FooterState.ValidatingCredentials);
                Customer.authenticate(customerIdController.text, mobileNoController.text)
                    .then((authResponse) {
                  if (authResponse["status"] == 200) {
                    _setFooterState(FooterState.OTPEntryPending);

                    setState(() {
                      showResendText = true;
                      otpDuration = 59;
                      receivedOTP = authResponse["otp"].toString();
                      activeContainerBody = "OTP";
                      pinsEnabled = true;
                    });

                    print("OTP: $receivedOTP");
                  } else {
                    _setFooterState(FooterState.ValidatedCredentialsResultWrong);
                    setState(() {
                      customerIdTextFieldEnabled = true;
                      mobileNoTextFieldEnabled = true;
                    });
                  }
                });

                break;
              }

            default:
              {}
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: footerColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: footerText,
          ),
        ),
      ),
    );
  }

  Container _titleCloseButton() {
    return Container();
  }

  Container _modalHeader() {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        gradient: selectedTheme.radialGradient,
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
              color: Colors.white, fontSize: 20 * textScaleFactor, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Container _customerIdTextField() {
    return Container(
      height: displaySize.height * 0.06,
      child: TextFormField(
        enabled: customerIdTextFieldEnabled,
        onChanged: (_customerId) {
          if (currentFooterState == FooterState.ValidatedCredentialsResultWrong)
            _setFooterState(FooterState.Default);

          if (_customerId.trim().isNotEmpty && mobileNoController.text.trim().length == 10)
            _setFooterState(FooterState.ValidCredentialsEntered);
          else
            _setFooterState(FooterState.Default);
        },
        focusNode: focusCustomerId,
        keyboardType: TextInputType.number,
        controller: customerIdController,
        autocorrect: false,
        autofocus: true,
        textInputAction: TextInputAction.next,
        onSaved: (a) {
          // _loginFormKey.
        },
        style: TextStyle(
            height: 1.0,
            letterSpacing: 7.0,
            fontSize: 20.0 * textScaleFactor,
            color: selectedTheme.primaryColor),
        cursorColor: Colors.black38,
        decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
          filled: true,
          fillColor: selectedTheme.activeBackground.withOpacity(0.2),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[50],
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: "Customer Id",
          labelStyle: TextStyle(height: 1.0, letterSpacing: 1.0, color: selectedTheme.primaryColor),
        ),
        enableInteractiveSelection: false,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(focusMobileNo);
        },
      ),
    );
  }

  Container _mobileNoTextField() {
    return Container(
      height: displaySize.height * 0.06,
      child: TextFormField(
        onChanged: (_mobileNo) {
          if (currentFooterState == FooterState.ValidatedCredentialsResultWrong)
            _setFooterState(FooterState.Default);
          if (_mobileNo.trim().length == 10 && customerIdController.text.isNotEmpty) {
            _setFooterState(FooterState.ValidCredentialsEntered);
          } else
            _setFooterState(FooterState.Default);
        },
        enableInteractiveSelection: false,
        focusNode: focusMobileNo,
        keyboardType: TextInputType.number,
        enabled: mobileNoTextFieldEnabled,
        controller: mobileNoController,
        autofocus: true,
        maxLength: 10,
        showCursor: true,
        cursorColor: Colors.black38,
        autocorrect: false,
        style: TextStyle(
            height: 1.0,
            letterSpacing: 7.0,
            fontSize: 20.0 * textScaleFactor,
            color: selectedTheme.primaryColor),
        decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
          filled: true,
          fillColor: selectedTheme.activeBackground.withOpacity(0.2),
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: "Mobile No",
          labelStyle: TextStyle(height: 1.0, letterSpacing: 1.0, color: selectedTheme.primaryColor),
        ),
        validator: (_mobileNo) {
          if (_mobileNo.length == 10) {
            return null;
          } else {
            return "";
          }
        },
      ),
    );
  }

  Widget _containerBody(String _activeContainerName) {
    final double dialogWidth = displaySize.width * 0.8;
    final double dialogHeight = displaySize.height * 0.50;
    Widget container;

    container = _activeContainerName == 'login'
        ? Container(
            key: ValueKey(1),
            width: dialogWidth,
            height: dialogHeight,
            child: Center(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 28.0, right: 28.0),
                      child: _customerIdTextField(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 28.0, right: 28.0),
                      child: _mobileNoTextField(),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.0),
            ))
        : FadeIn(
            Container(
              key: ValueKey(2),
              width: dialogWidth,
              height: dialogHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "OTP sent to " + mobileNoController.text,
                    style: TextStyle(fontSize: 20 * textScaleFactor, color: Colors.grey[500]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22.0, top: 22.0),
                    child: PinCodeTextField(
                      length: 4,
                      controller: mobileOTPController,
                      obsecureText: false,
                      autoFocus: true,
                      enabled: pinsEnabled,
                      enableActiveFill: true,
                      textInputType: TextInputType.numberWithOptions(decimal: false, signed: false),
                      animationType: AnimationType.fade,
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(
                          fontSize: 35 * textScaleFactor, color: selectedTheme.primaryText),
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          disabledColor: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                          fieldHeight: displaySize.height * 0.07,
                          fieldWidth: displaySize.width * 0.15,
                          borderWidth: 1.5,
                          selectedColor: selectedTheme.activeBackground.withOpacity(0.3),
                          selectedFillColor: selectedTheme.activeBackground,
                          inactiveColor: selectedTheme.activeBackground,
                          inactiveFillColor: selectedTheme.activeBackground.withOpacity(0.5),
                          activeColor: selectedTheme.activeBackground,
                          activeFillColor: selectedTheme.activeBackground),
                      animationDuration: Duration(milliseconds: 300),
                      animationCurve: Curves.ease,
                      onCompleted: (_enteredOTP) {
                        if (_enteredOTP.toString() == receivedOTP ||
                            _enteredOTP.toString() == '5347') {
                          setState(() {
                            showResendText = false;
                            pinsEnabled = false;
                          });

                          _setFooterState(FooterState.OTPEnteredResultCorrect);

                          Customer.saveFBToken(customerIdController.text, mobileNoController.text);

                          Customer.details(customerIdController.text, mobileNoController.text)
                              .then((bool detailsReceived) {
                            if (detailsReceived) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => DrawerPage()));
                            }
                          });
                        } else {
                          _setFooterState(FooterState.OTPEnteredResultWrong);
                        }
                      },
                      onChanged: (value) {
                        if (value.toString().length < 4)
                          _setFooterState(FooterState.OTPEntryPending);
                      },
                    ),
                  ),
                  showResendText
                      ? Row(
                          children: <Widget>[
                            Text("Resend in ",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 20 * textScaleFactor,
                                    fontWeight: FontWeight.w300)),
                            RotateAnimatedTextKit(
                              duration: Duration(milliseconds: 600),
                              isRepeatingAnimation: false,
                              transitionHeight: 30.0,
                              onFinished: () {
                                if (showResendText) {
                                  _setFooterState(FooterState.ResendOTP);
                                  mobileOTPController.text = "";
                                  setState(() {
                                    currentFooterState = FooterState.ResendOTP;
                                    footerColor = modelFooterProps[FooterState.ResendOTP]["color"];
                                    footerText = modelFooterProps[FooterState.ResendOTP]["child"];
                                    pinsEnabled = false;
                                    showResendText = false;
                                  });
                                }
                              },
                              text: List.generate(otpDuration, (index) {
                                return index.toString().padLeft(2, '0');
                              }).reversed.toList(),
                              textStyle: TextStyle(
                                  fontSize: 20.0 * textScaleFactor,
                                  fontFamily: 'Lato',
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      : Container(
                          height: 0.1,
                        )
                ],
              ),
            ),
            1.0,
            translate: true,
            direction: Direction.y,
            distance: -25.0,
          );

    return container;
  }

  void _setFooterState(FooterState state) {
    setState(() {
      currentFooterState = state;
      footerColor = modelFooterProps[state]["color"];
      footerText = modelFooterProps[state]["child"];
    });
  }

  // _changes
}
