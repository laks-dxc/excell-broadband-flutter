import 'dart:convert' as convert;

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CodeHelpers codeHelpers = new CodeHelpers();

  bool dataLoaded = false;

  getConnectionsList() async {
    var body = {
      "name": "getConnectionsList",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    var customerDetails = await codeHelpers.httpPost(body, needAuth: true);
    var customerConnectionsRaw =
        await customerDetails.transform(convert.utf8.decoder).join();

    // print(convert.jsonDecode(customerConnectionsRaw));

    setState(() {
      dataLoaded = true;
    });

    return convert.jsonDecode(customerConnectionsRaw);
  }

  @override
  Widget build(BuildContext context) {
    final connectionsList = getConnectionsList();

    dataLoaded ? dashboardContent() : loader();
  }

  showData(loaded) {}

  loader() {
    return Center(
      child: Loading(
        indicator: BallPulseIndicator(),
        size: 60.0,
        color: Colors.white60,
      ),
    );
  }

  dashboardContent() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5.0,
            color: Color.fromRGBO(95, 32, 97, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "VJWNEW2017-Smart",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Card(
            // elevation: 5.0,
            color: Color.fromRGBO(184, 27, 77, 10),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 200.0,
                  lineWidth: 25.0,
                  arcType: ArcType.FULL,
                  animation: true,
                  percent: 0.63,
                  arcBackgroundColor: Colors.white38,
                  center: Text(
                    "63%",
                    style: TextStyle(
                        fontSize: 38,
                        letterSpacing: 2.0,
                        color: Color.fromRGBO(0, 32, 97, 5),
                        fontWeight: FontWeight.w600),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Color.fromRGBO(184, 27, 77, 0),
                  maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                  linearGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange, Colors.yellow],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
