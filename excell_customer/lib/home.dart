import 'package:ExcellCustomer/enquiry.dart';
import 'package:ExcellCustomer/packageList.dart';
import 'package:ExcellCustomer/widgets/quickPayModel.dart';
import 'package:flutter/material.dart';

import 'animation/fadeIn.dart';

import 'drawer.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';
import 'widgets/loginModal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Size displaySize;
  double textScaleFactor;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = (1 / MediaQuery.of(context).textScaleFactor);

    return Scaffold(
      backgroundColor: selectedTheme.scaffoldBgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Align(alignment: Alignment.topCenter, child: Image.asset('assets/blue_bg.png')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: displaySize.height * 0.1),
                  FadeIn(
                    Image.asset(
                      "assets/logo_white.png",
                      width: displaySize.height * 0.1522,
                      height: displaySize.height * 0.1522,
                    ),
                    0.5,
                    direction: Direction.y,
                    distance: -10,
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Center(
                          child: FadeIn(
                            Text(
                              "Welcome to Excell Media ", // + (1/textScaleFactor).toString(),
                              style:
                                  TextStyle(fontSize: 25 * textScaleFactor, color: Colors.white70),
                            ),
                            0.8,
                            translate: false,
                          ),
                        ),
                        SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FadeIn(
                                GestureDetector(
                                  onTap: () async {
                                    bool isCustomerLoggedIn = await Customer.isLoggedIn();
                                    isCustomerLoggedIn
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => DrawerPage()))
                                        : showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) => LoginModal());
                                  },
                                  child: _homeTile(Image.asset('assets/11.png'), "Account"),
                                ),
                                1.0,
                                direction: Direction.x,
                                distance: -30),
                            FadeIn(
                                GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) => QuickPayModal());
                                    },
                                    child: _homeTile(Image.asset('assets/22.png'), "Quick Pay")),
                                1.0,
                                direction: Direction.x,
                                distance: 30),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FadeIn(
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => PackageList()));
                                    },
                                    child: _homeTile(Image.asset('assets/33.png'), "Packages")),
                                1.0,
                                direction: Direction.x,
                                distance: -30),
                            FadeIn(
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => Enquiry()));
                                    },
                                    child: _homeTile(Image.asset('assets/44.png'), "Enquiry")),
                                1.0,
                                direction: Direction.x,
                                distance: 30),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _homeTile(
    Widget image,
    String title,
  ) {
    double imageDimension = displaySize.width * 0.25;
    return Column(
      children: <Widget>[
        Container(
          width: imageDimension, // 120.0,
          height: imageDimension,
          child: image,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20 * textScaleFactor),
        )
      ],
    );
  }

  void showFancyCustomDialog(BuildContext context) {}
}
