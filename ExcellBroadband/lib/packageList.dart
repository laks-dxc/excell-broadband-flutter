import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

import 'helpers/constants.dart';
import 'helpers/fadeInX.dart';
import 'helpers/fadeInY.dart';

class PackageList extends StatefulWidget {
  final List<dynamic> connectionsList;
  PackageList(this.connectionsList);

  @override
  _PackageListState createState() => _PackageListState(connectionsList);
}

class _PackageListState extends State<PackageList> {
  final List<dynamic> connectionsList;
  _PackageListState(this.connectionsList);
  double cWidth, cHeight;

  @override
  Widget build(BuildContext context) {
    cWidth = MediaQuery.of(context).size.width;
    cHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[300],
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
                    Text("My Packages",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 40))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 90),
                  Expanded(
                    child: ListView.builder(
                        itemCount: connectionsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FadeInY(
                              double.parse((index + 3).toString()),
                              packageDetailTile(
                                  () => print('tapped Payments'),
                                  connectionsList[index]['pkgname'],
                                  "Payment level description"),
                              distance: -30.0,
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            backButton(),
          ],
        ));
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

  Widget packageDetailTile(onTapFn, String title, String description) {
    double containerWidth = cWidth * 0.45;
    return InkWell(
      onTap: () {
        onTapFn();
      },
      child: Container(
        width: containerWidth,
        height: cHeight * 0.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(2.0, 2.0),
              color: Colors.grey[800],
              blurRadius: 3.0,
            )
          ],
        ),
        child: Stack(
          children: [
            
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: cHeight * 0.05,
                // width: containerWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: Constants.colors['gradient_colors3'],

                      // stops: [0.5, 1],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
