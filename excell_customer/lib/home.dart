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
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.asset("assets/login_bg.png"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100),
                  FadeIn(
                    Image.asset(
                      "assets/logo.png",
                      width: 150,
                      height: 150,
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
                              style: TextStyle(fontSize: 30),
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
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    DrawerPage()))
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
                            FadeIn(_homeTile(Image.asset('assets/22.png'), "Quick Pay"), 1.0,
                                direction: Direction.x, distance: 30),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FadeIn(_homeTile(Image.asset('assets/33.png'), "Packages"), 1.0,
                                direction: Direction.x, distance: -30),
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
