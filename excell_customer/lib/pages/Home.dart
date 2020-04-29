import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/CustomerPages.dart';
import 'package:ExcellCustomer/pages/Enquiry.dart';
import 'package:ExcellCustomer/pages/Login.dart';
import 'package:ExcellCustomer/pages/Packages.dart';
import 'package:ExcellCustomer/pages/QuickPay.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BuildContext myContext;
  CodeHelpers codeHelpers = new CodeHelpers();

  @override
  Widget build(BuildContext context) {
    setState(() {
      myContext = context;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(184, 27, 77, 10),
        title: Center(child: Text('Welcome to Excell Broadband')),
      ),
      body: homeComponents(),
      backgroundColor: Color.fromRGBO(184, 27, 77, 10),
    );
  }

  homeComponents() {
    return Stack(
      children: [
        Image.asset('assets/login_bg.png', fit: BoxFit.fill),
        Column(
          children: <Widget>[
            SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                WidgetAnimator(
                  Image.asset(
                    'assets/logo_white.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                SizedBox(height: 35),
                WidgetAnimator(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      homeScreenButton(
                        "Enquiry",
                        FontAwesomeIcons.questionCircle,
                        onPressed: () {
                          Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                  builder: (myContext) => EnquiryForm()));
                        },
                      ),
                      homeScreenButton("Quick Pay", FontAwesomeIcons.rupeeSign, onPressed: () => {
                          Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                  builder: (myContext) => QuickPay()))

                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                WidgetAnimator(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      homeScreenButton(
                        "Packages",
                        FontAwesomeIcons.wifi,
                        onPressed: () {
                          Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                  builder: (myContext) => Packages()));
                        },
                      ),
                      homeScreenButton("My Account", FontAwesomeIcons.user,
                          onPressed: () {
                        var loggedInKey = codeHelpers.getStorageKey('loggedIn');
                        if (loggedInKey == null || loggedInKey == '0')
                          Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                  builder: (myContext) => Login()));
                        else
                          Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                  builder: (myContext) => CustomerPages()));
                        // );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
            width: 100.0,
            height: 100.0,
            child: Center(
              child: FaIcon(
                icon,
                color: Colors.white70,
                size: 50,
              ),
            ),
            decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 32, 97, 5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 100, 97, 5),
                  blurRadius: 10.0,
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
                color: Colors.white, fontSize: 20, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}
