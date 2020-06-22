import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/customer.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class QuickPayModal extends StatefulWidget {
  @override
  __QuickPayModalState createState() => __QuickPayModalState();
}

class __QuickPayModalState extends State<QuickPayModal> {
  Size screenSize;
  FooterState currentFooterState = FooterState.Default;
  TextEditingController customerIdController =
      TextEditingController(); //text: '46888'); //text: '46888'
  TextEditingController mobileNoController =
      TextEditingController(); //text: '830903863'); //text: '830903863'
  TextEditingController mobileOTPController = TextEditingController();

  bool mobileNoTextFieldEnabled = true;
  bool customerIdTextFieldEnabled = true;

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
    FooterState.DueExist: {
      "child": Text(
        "Pay Now",
        style: TextStyle(color: selectedTheme.textColor, fontSize: 20, fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.activeBackground,
    },
    FooterState.DueNotExist: {
      "child": Text(
        "Close",
        style: TextStyle(color: selectedTheme.textColor, fontSize: 20, fontWeight: FontWeight.w100),
      ),
      "color": selectedTheme.activeBackground,
    }
  };

  final focusCustomerId = new FocusNode();
  final focusMobileNo = new FocusNode();

  String activeContainerBody = 'login';
  int otpDuration = 60;
  bool showAnimation = true;
  String amountDue = "--";
  double doubleAmoutDue;

  String custId, mobileNo;

  Color footerColor;
  dynamic footerText;

  bool loginFormIsValid;

  final _quickPayFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _setFooterState(FooterState.Default);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    final double dialogWidth = screenSize.width * 0.8;
    final double dialogHeight = screenSize.height * 0.35;

    Dialog quickPayDialog = Dialog(
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

    return quickPayDialog;
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

                Customer.authenticateWithoutOTP(customerIdController.text, mobileNoController.text)
                    .then((authResponse) async {
                  print(authResponse.toString());
                  if (authResponse["status"] == 200) {
                    Customer.paymentDueWithToken(authResponse["token"], customerIdController.text)
                        .then((paymentDueResponse) {
                      // print(paymentDueResponse.toString());
                      setState(() {
                        activeContainerBody = "QuickPay";
                        doubleAmoutDue = double.parse(paymentDueResponse["amount"]);
                        amountDue = Utils.showAsMoney(paymentDueResponse["amount"]);
                      });
                      doubleAmoutDue > 0
                          ? _setFooterState(FooterState.DueExist)
                          : _setFooterState(FooterState.DueNotExist);
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
            case FooterState.DueExist:
              {
                break;
              }

            case FooterState.DueNotExist:
              {
                Navigator.pop(context);
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

  Align _titleCloseButton() {
    return Align(
      alignment: Alignment(0.95, -0.93),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
    );
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
          "Quick Pay",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _containerBody(String _activeContainerName) {
    final double dialogWidth = screenSize.width * 0.8;
    final double dialogHeight = screenSize.height * 0.50;
    Widget container;

    container = _activeContainerName == 'login'
        ? Container(
            key: ValueKey(1),
            width: dialogWidth,
            height: dialogHeight,
            child: Center(
              child: Form(
                key: _quickPayFormKey,
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
            Center(
              child: Container(
                  child: doubleAmoutDue > 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              Text(
                                "Payable Amount",
                                style: TextStyle(fontSize: 24.0),
                              ),
                              Text(
                                amountDue,
                                style: TextStyle(fontSize: 30.0),
                              )
                            ])
                      : Text(
                          "No Dues",
                          style: TextStyle(fontSize: 30.0),
                        )),
            ),
            1.0,
            direction: Direction.y,
            distance: -10.0,
          );

    return container;
  }

  Container _customerIdTextField() {
    return Container(
      height: screenSize.height * 0.06,
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
            height: 1.0, letterSpacing: 7.0, fontSize: 20.0, color: selectedTheme.primaryColor),
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
      height: screenSize.height * 0.06,
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
            height: 1.0, letterSpacing: 7.0, fontSize: 20.0, color: selectedTheme.primaryColor),
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

  void _setFooterState(FooterState state) {
    setState(() {
      currentFooterState = state;
      footerColor = modelFooterProps[state]["color"];
      footerText = modelFooterProps[state]["child"];
    });
  }
}
