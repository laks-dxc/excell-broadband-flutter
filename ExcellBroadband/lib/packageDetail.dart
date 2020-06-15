import 'dart:async';

import 'package:ExcellBroadband/helpers/customerInfo.dart';
import 'package:ExcellBroadband/widgets/dataTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'helpers/constants.dart';
import 'helpers/fadeInX.dart';
import 'helpers/utilities.dart';
import 'widgets/lineChart.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PackageDetail extends StatefulWidget {
  final dynamic connectionListItem;

  PackageDetail(this.connectionListItem);

  @override
  _PackageDetailState createState() => _PackageDetailState(connectionListItem);
}

class _PackageDetailState extends State<PackageDetail> {
  final dynamic connectionListItem;
  double cHeight, cWidth;
  double consumptionWidth = 0.0;
  static String ipAddr ;

  // static List<DataRow> dataTableRows = [
  //   DataRow(cells: [
  //     DataCell(Text("")),
  //     DataCell(Text("")),
  //     DataCell(Text("")),
  //     DataCell(Text("")),
  //   ])
  // ];

  String consumedText = "Consumed";

  List<dynamic> usageReport;
  Widget usedUtilzationContainer = Container();//chartContainer(connectionListItem["ip_addr"]);
  _PackageDetailState(this.connectionListItem);

  final Radius containerBorderRadius = Radius.circular(15);

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        consumptionWidth = 300.0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(connectionListItem["ip_addr"]);
    // ipAddr = connectionListItem["ip_addr"];

    cWidth = MediaQuery.of(context).size.width;
    cHeight = MediaQuery.of(context).size.height;

    final List<Color> gradientColors = Constants.colors['gradient_colors3'];
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(1.0, -1.07),
          child: SafeArea(
              child: Icon(
            Icons.calendar_view_day,
            size: 140,
            color: Colors.black12,
          )),
        ),
        backButton(),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              SizedBox(height: 100),
              Expanded(
                  child: ListView(
                children: <Widget>[
                  planDataContainer(),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(90),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-0.0, 0.0),
                              color: Colors.grey[800],
                              blurRadius: 6.0,
                            ),
                          ]),
                      child: ToggleSwitch(
                          initialLabelIndex: 0,
                          minWidth: 100.0,
                          cornerRadius: 20,
                          activeBgColor: gradientColors[0], // Colors.green,
                          activeTextColor: Colors.white,
                          inactiveBgColor:
                              Colors.grey[300], //gradientColors[1],
                          inactiveTextColor: Colors.black87,
                          labels: ['Trend', 'Table'],
                          icons: [Icons.show_chart, Icons.list],
                          onToggle: (index) {
                            setState(() {
                              usedUtilzationContainer = index == 1
                                  ? tableContainer(
                                      connectionListItem["ip_addr"])
                                  : chartContainer(connectionListItem["ip_addr"]);
                            });

                            // print('switched to: $index');
                          }),
                    ),
                  ),
                  SizedBox(height: 15),
                  AnimatedSwitcher(
                    // switchInCurve: Curves.easeInOutExpo,
                    duration: Duration(seconds: 1),
                    child: SafeArea(child: usedUtilzationContainer),
                  )

                  // plainText(
                  //   "data consumed",
                  //   Utilities.bytesToGBString(connectionListItem["data"]),
                  // ),
                  // plainText(
                  //   "datalimit",
                  //   Utilities.bytesToGBString(connectionListItem["datalimit"])
                  //       .toString(),
                  // ),
                  // plainText(
                  //   "topup",
                  //   Utilities.bytesToGBString(connectionListItem["topup"]),
                  // ),
                  // plainText(
                  //   "new_limit",
                  //   Utilities.bytesToGBString(connectionListItem["new_limit"]),
                  // ),
                  // plainText(
                  //   "paybonus",
                  //   Utilities.bytesToGBString(connectionListItem["paybonus"]),
                  // ),
                ],
              ))
            ])),
        SafeArea(
          child: Align(
            alignment: Alignment(0.8, -0.97),
            child: FadeInX(
              1.0,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    connectionListItem["pkgname"],
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    connectionListItem["pkgdetail"],
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              distance: 160,
            ),
          ),
        ),
      ],
    ));
  }

  Widget plainText(label, text, {style: 20}) {
    String _returnRext;
    if (text == null)
      _returnRext = 'null_val';
    else
      _returnRext = text;
    return ListTile(
        leading: Text(label,
            style: TextStyle(fontSize: double.parse((style * 0.8).toString()))),
        trailing: Text(_returnRext,
            style: TextStyle(fontSize: double.parse(style.toString()))));
  }

  static Widget tableContainer(ipAddr) {
    return Container(
      key: ValueKey(1),
      child: Center(
        child: UtilDataTable(ipAddr),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
    );
  }

  static Widget chartContainer(_ipAddr) {

    
    return Container(
      key: ValueKey(0),
      child: UtilLineChart(_ipAddr),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment(-1.0, -0.9),
      child: Container(
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
        child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white),
      ),
    );
  }

  Widget textBoxContainer(String title, String value) {
    return Container(
      height: cHeight * 0.075,
      // width: cWidth * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, color: Colors.black38),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 22, color: Colors.black),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          containerBorderRadius,
        ),
      ),
    );
  }

  Widget textBoxContainerWithBar(String title, String value) {
    double _containrHeight = cHeight * 0.075;
    return Container(
      height: _containrHeight,
      // width: cWidth * 0.85,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(seconds: 2),
            height: _containrHeight,
            width: consumptionWidth,
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.all(
                containerBorderRadius,
              ),
            ),
            onEnd: () {
              setState(() {
                // consumedText = "Consumed 45.42 %";
              });
              //  ;
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutBack,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 22, color: Colors.black38),
                      )),
                  Text(
                    value,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          containerBorderRadius,
        ),
      ),
    );
  }

  Widget planDataContainer() {
    final double containerHeightFactor = cHeight * 0.1015;

    final double _dataLimit =
        Utilities.convertToDouble(connectionListItem["datalimit"]);
    final double _payBonus =
        Utilities.convertToDouble(connectionListItem["paybonus"]);
    final double _topUp =
        Utilities.convertToDouble(connectionListItem["topup"]);
    final double _data = Utilities.convertToDouble(connectionListItem["data"]);
    final double _newLimit =
        Utilities.convertToDouble(connectionListItem["newlimit"]);

    List<Widget> planDataContainerWidgets = [
      textBoxContainer(
          "Plan Data", Utilities.bytesToUnits(connectionListItem["datalimit"])),
    ];

    if (_payBonus > 0)
      planDataContainerWidgets.add(
        textBoxContainer("Pay Bonus",
            Utilities.bytesToGBString(connectionListItem["paybonus"])),
      );

    if (_topUp > 0)
      planDataContainerWidgets.add(textBoxContainer(
          "Top Up", Utilities.bytesToGBString(connectionListItem["topup"])));

    planDataContainerWidgets.add(textBoxContainerWithBar(
        consumedText, Utilities.bytesToUnits(connectionListItem["data"])));

    return Container(
      height: containerHeightFactor * planDataContainerWidgets.length,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: planDataContainerWidgets,
      ),
    );
  }
}
