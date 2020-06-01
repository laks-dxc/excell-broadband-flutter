import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/CustomerPages.dart';
import 'package:ExcellCustomer/pages/Enquiry.dart';
import 'package:ExcellCustomer/pages/Login.dart';
import 'package:ExcellCustomer/pages/Packages.dart';
import 'package:ExcellCustomer/pages/QuickPay.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    // codeHelpers.setStorageKey('loggedIn', '0');
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

    logoTopMargin = windowHeight * 0.2;
    logoDimensions = windowHeight * 0.2;

    logoButtonRowGap = windowHeight * 0.1;

    buttonDimension = windowHeight * 0.12;
    // buttonFontSize = buttonDimension * 0.40;
    interButtonVerticalGap = windowHeight * 0.05;

    setState(() {
      myContext = context;
    });

    return Scaffold(body: homeComponents(), backgroundColor: Colors.white);
  }

  homeComponents() {
    return Stack(
      children: [
        WidgetAnimator(Image.asset('assets/bg_bin.png', fit: BoxFit.fill)),
        Column(
          children: <Widget>[
            SizedBox(height: logoTopMargin * 1),
            buttonGroup()
          ],
        ),
      ],
    );
  }

  buttonGroup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        WidgetAnimator(
          Image.asset(
            'assets/logo_white.png',
            height: logoDimensions,
            width: logoDimensions,
          ),
        ),
        SizedBox(height: logoButtonRowGap * 0.8),
        Text(
          "Welcome to Excell Broadband " + loggedInKey,
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(height: logoButtonRowGap * 0.5),
        WidgetAnimator(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              homeScreenButton("Account", "assets/11.svg",
                  onPressed: () => {
                        loggedInKey == '1'
                            ? Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (myContext) => CustomerPages()))
                            : Navigator.push(
                                myContext,
                                MaterialPageRoute(
                                    builder: (myContext) => Login()))
                      }),
              homeScreenButton("Quick Pay", "assets/22.svg",
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
                "Packages",
                "assets/33.svg",
                onPressed: () {
                  Navigator.push(myContext,
                      MaterialPageRoute(builder: (myContext) => Packages()));
                },
              ),
              homeScreenButton(
                "New Connection",
                "assets/44.svg",
                onPressed: () {
                  Navigator.push(myContext,
                      MaterialPageRoute(builder: (myContext) => EnquiryForm()));
                },
              ),
            ],
          ),
        ),
      ],
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
            child: SvgPicture.asset(icon),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.black, fontSize: 16, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}
