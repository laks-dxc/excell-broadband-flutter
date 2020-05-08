import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/CustomerPages.dart';
import 'package:ExcellCustomer/pages/Enquiry.dart';
import 'package:ExcellCustomer/pages/Login.dart';
import 'package:ExcellCustomer/pages/Packages.dart';
import 'package:ExcellCustomer/pages/QuickPay.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BuildContext myContext;
  CodeHelpers codeHelpers = new CodeHelpers();

  double logoDimensions,
      windowHeight,
      windowWidth,
      logoTopMargin,
      logoButtonRowGap,
      buttonDimension,
      buttonFontSize,
      interButtonVerticalGap;
  var loggedInKey;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // codeHelpers.getStorageKey('loggedIn');

    if (codeHelpers.getStorageKey('loggedIn') == null ||
        codeHelpers.getStorageKey('loggedIn') == '0') {
      loggedInKey = '0';
    } else {
      loggedInKey = '1';
    }

    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    logoTopMargin = windowHeight * 0.1;
    logoDimensions = windowHeight * 0.2;

    logoButtonRowGap = windowHeight * 0.1;

    buttonDimension = windowHeight * 0.08;
    buttonFontSize = buttonDimension * 0.45;
    interButtonVerticalGap = windowHeight * 0.05;

    setState(() {
      myContext = context;
    });

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color.fromRGBO(184, 27, 77, 10),
        //   title: Center(child: Text('Welcome to Excell Broadband')),
        // ),

        body: homeComponents(),
        backgroundColor: Colors.white
        // Color.fromRGBO(184, 27, 77, 10), //Colors.white, //Color.fromRGBO(184, 27, 77, 10),
        );
  }

  homeComponents() {
    return SafeArea(
      child: Stack(
        children: [
          Image.asset('assets/login_bg.png', fit: BoxFit.fill),
          Column(
            children: <Widget>[
              SizedBox(height: logoTopMargin),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  WidgetAnimator(
                    Image.asset(
                      'assets/logo_pink.png',
                      height: logoDimensions,
                      width: logoDimensions,
                    ),
                  ),
                  SizedBox(height: logoButtonRowGap),
                  WidgetAnimator(
                    Container(
                        child: Center(
                            child: Text(
                      'Welcome to Excell Broadband',
                      style: TextStyle(
                          fontSize: windowWidth * 0.05,
                          color: Color.fromRGBO(0, 32, 97, 10)),
                    ))),
                  ),
                  SizedBox(height: logoButtonRowGap),
                  WidgetAnimator(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        homeScreenButton("MY ACCOUNT", FontAwesomeIcons.user,
                            onPressed: () {
                          var nextActivity =
                              loggedInKey == '0' ? Login() : CustomerPages();
                          Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                  builder: (myContext) => nextActivity));
                        }),
                        homeScreenButton(
                            "QUICK PAY", FontAwesomeIcons.rupeeSign,
                            onPressed: () => {
                                  Navigator.push(
                                      myContext,
                                      MaterialPageRoute(
                                          builder: (myContext) => QuickPay()))
                                }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: interButtonVerticalGap,
                  ),
                  WidgetAnimator(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        homeScreenButton(
                          "PACKAGES",
                          FontAwesomeIcons.wifi,
                          onPressed: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (myContext) => Packages()));
                          },
                        ),
                        homeScreenButton(
                          "ENQUIRY",
                          FontAwesomeIcons.questionCircle,
                          onPressed: () {
                            Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (myContext) => EnquiryForm()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  homeScreenButton(String label, icon, {onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: buttonDimension,
            height: buttonDimension,
            child: Center(
              child: FaIcon(
                icon,
                color: Colors.white70,
                size: buttonFontSize,
              ),
            ),
            decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 32, 97, 5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 100, 97, 5),
                  blurRadius: 5.0,
                  // offset: Offset(5, 5)
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            label,
            style: TextStyle(
                
                color: Colors.black,
                fontSize: 16,
                letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}
