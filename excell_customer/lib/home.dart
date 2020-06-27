import 'package:ExcellCustomer/packageList.dart';
import 'package:ExcellCustomer/widgets/quickPayModel.dart';
import 'package:flutter/material.dart';

import 'animation/fadeIn.dart';

import 'drawer.dart';
import 'models/customer.dart';
import 'models/enum.dart';
import 'widgets/loginModal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Size displaySize;

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(205),
                      bottomRight: Radius.circular(75),
                    ),
                    gradient: RadialGradient(colors: [
                      Color(0xff0e347f),
                      Colors.white38,
                      Colors.white70,
                      Color(0xff20347e)
                    ], stops: [
                      0,
                      0.55,
                      0.75,
                      1
                    ], radius: 20.0),
                    color: Color(0xff0e347f)),
                width: displaySize.width,
                height: displaySize.height * 0.45,
              )),
          Opacity(
              opacity: 0.1,
              child: Image.asset(
                "assets/login_bg.png",
              )),
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
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Center(
                          child: FadeIn(
                            Text(
                              "Welcome to Excell Media",
                              style: TextStyle(fontSize: 30, color: Colors.white70),
                            ),
                            0.8,
                            translate: false,
                          ),
                        ),
                        SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            FadeIn(_homeTile(Image.asset('assets/44.png'), "New Connection"), 1.0,
                                direction: Direction.x, distance: 30),
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
    return Column(
      children: <Widget>[
        Container(
          width: 120.0,
          height: 120.0,
          child: image,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  void showFancyCustomDialog(BuildContext context) {}
}
