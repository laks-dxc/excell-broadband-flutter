import 'package:ExcellBroadband/profiles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'helpers/constants.dart';
import 'helpers/fadeInX.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: Container(
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/login_bg.png",
              fit: BoxFit.fill,
            ),
            FadeInX(
              2.0,
              Align(
                alignment: Alignment(1.0, -0.9),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Profile(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          // var curve = Curves.;

                          var tween = Tween(begin: begin, end: end);
                              // .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    )
                  },
                  child: Container(
                    height: 50,
                    width: 60,
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
                    // child: Icon(Icons.account_circle, size: 35,color: Constants.colors['excell_color'],),
                  ),
                ),
              ),
              duration: 2.0,
            ),
            Align(
                alignment: Alignment(-0.85, -0.88),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome",
                        style: TextStyle(color: Colors.black45, fontSize: 24),
                      ),
                      Text(
                        "Lakshman Pilaka",
                        style: TextStyle(color: Colors.black54, fontSize: 36),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
