import 'dart:math';

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:charts_flutter/flutter.dart' as charts;

// class Dashboard extends StatefulWidget {
//   @override
//   GaugeChart createState() => GaugeChart();
// }

// class _DashboardState extends State<Dashboard> {

class GaugeChart extends StatelessWidget {

  CodeHelpers codeHelpers = new CodeHelpers();
  var bytesToGBFactor = 1073741824;

  final List<charts.Series> seriesList;
  final bool animate;

  GaugeChart(this.seriesList, {this.animate});

  factory GaugeChart.withSampleData() {
    return new GaugeChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Low', 75),
      new GaugeSegment('Acceptable', 100),
      new GaugeSegment('High', 50),
      new GaugeSegment('Highly Unusual', 5),
    ];


    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    getCustomerDue();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(184, 27, 77, 10),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(184, 27, 77, 10),
                    backgroundBlendMode: BlendMode.darken,
                    image: DecorationImage(
                        image: AssetImage("assets/menu_bg.jpg"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(184, 27, 77, 10),
            title: Text("Dashboard")),
        body: 
        
        charts.PieChart(
          seriesList,
          animate: animate,
          // Configure the width of the pie slices to 30px. The remaining space in
          // the chart will be left as a hole in the center. Adjust the start
          // angle and the arc length of the pie so it resembles a gauge.
          defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 30,
            startAngle: 4 / 5 * pi,
            arcLength: 7 / 5 * pi,
          ),
        ),
      ),
    );
  }

  getCustomerDetails() {
    var body = {
      "name": "getCustomerDetails",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    codeHelpers.httpPost(body, needAuth: true).then((customerDetails) => {
          customerDetails
              .transform(convert.utf8.decoder)
              .join()
              .then((onValue) {
            Map<String, dynamic> response = convert.jsonDecode(onValue);
            print(response.toString());
          })
        });
  }

  getCustomerDue() {
    var body = {
      "name": "getConnectionsList",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    codeHelpers.httpPost(body, needAuth: true).then((customerDetails) => {
          customerDetails
              .transform(convert.utf8.decoder)
              .join()
              .then((onValue) {
            Map<String, dynamic> response = convert.jsonDecode(onValue);
            print(response.toString());
            final connection = response["resonse"]["result"]["connections"][0];

            final topup = connection["topup"];
            final dataLimit = connection["datalimit"];
            final data = connection["data"];
            final newLimit = connection["new_limit"];

            print(topup);
            print(dataLimit);
            print(data);
            print(newLimit);
          })
        });
  }
}

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}



