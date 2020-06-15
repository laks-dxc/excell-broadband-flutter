import 'package:flutter/material.dart';

import 'helpers/constants.dart';
import 'helpers/fadeInX.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(1.0, -1.07),
            child: SafeArea(
                child: Icon(
              Icons.list,
              size: 140,
              color: Colors.black12,
            )),
          ),
          Align(
            alignment: Alignment(0.8, -0.97),
            child: SafeArea(
              child: FadeInX(
                  1.0,
                  Text("Support",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 40))),
            ),
          ),
          backButton(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 90),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(height: 100, color: Colors.white)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment(-1.0, -0.9),
      child: FadeInX(
        2.5,
        Container(
          height: 50,
          width: 65,
          // padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(-3.0, 0.0),
                color: Colors.grey[800],
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(90),
              bottomRight: Radius.circular(90),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: Constants.colors['gradient_colors3'],
            ),
          ),
          child: FadeInX(
              2,
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.white),
              distance: 30),
        ),
        distance: -30,
      ),
    );
  }
}
