import 'dart:async';

import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:ExcellCustomer/topupsList.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dataTable.dart';
import 'lineChart.dart';

class ConnectionDetail extends StatefulWidget {
  final dynamic connectionDetailItem;

  ConnectionDetail(this.connectionDetailItem);

  @override
  _ConnectionDetailState createState() => _ConnectionDetailState(connectionDetailItem);
}

class _ConnectionDetailState extends State<ConnectionDetail> {
  final dynamic connectionDetailItem;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  Widget usedUtilzationContainer;

  _ConnectionDetailState(this.connectionDetailItem);
  double consumedFactor = 0.0001;
  bool showUtilization = false;

/*
[{pkgnum: 300208, pkgname: Smart, ip_addr: 172.16.100.197, speed_down: 50, mac_addr: 1c:5f:2b:9f:3e:a1, data: null, datalimit: 429496729600, topup: null, new_limit: null, paybonus: null, freq: 1, pkgdetail: 50Mbps-400GB, last_bill_date: 2020-06-01, due_bill_date: 2020-06-06}]
*/

  Size displaySize;
  double textScaleFactor;
  @override
  Widget build(BuildContext context) {
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0 ? 1.0 : 0.85 / MediaQuery.of(context).textScaleFactor;

    displaySize = MediaQuery.of(context).size;
    return ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: EdgeInsets.all(8.0 * textScaleFactor),
            child: Column(
              children: <Widget>[
                tileItem("Package", Utils.clipStringTo(connectionDetailItem["pkgname"], 20)),
                tileItem("Plan", connectionDetailItem["pkgdetail"]),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                tileItem("Plan Data", Utils.bytesToSize(connectionDetailItem["datalimit"])),
                connectionDetailItem["paybonus"] != null
                    ? tileItem("Pay Bonus", Utils.bytesToSize(connectionDetailItem["paybonus"]))
                    : SizedBox(
                        width: 0,
                      ),
                connectionDetailItem["topup"] != null
                    ? tileItem("Top Up", Utils.bytesToSize(connectionDetailItem["topup"]))
                    : SizedBox(
                        width: 0,
                      ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: utilizationTile(),
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(12.0 * textScaleFactor),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: selectedTheme.primaryGradientColors[1],
                  child: Container(
                      height: 40,
                      width: displaySize.width * 0.45,
                      child: Center(
                          child: Text(
                        "Buy Topup",
                        style: TextStyle(fontSize: 18.0 * textScaleFactor),
                      ))),
                  onPressed: () {
                    if (connectionDetailItem["topup_eligibility"] == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Scaffold(
                            backgroundColor: selectedTheme.scaffoldBgColor,
                            appBar: AppBar(title: Text("Select Topup"), backgroundColor: selectedTheme.appBarColor //(0xff112c75),
                                ),
                            body: TopupsList(connectionDetailItem["pkgnum"].toString()),
                          ),
                        ),
                      );
                    } else if (connectionDetailItem["topup_eligibility"] == 0) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => new Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(connectionDetailItem["topupeligibility_note"]),
                                ),
                              ));
                    }
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Center(
            child: Padding(
                padding: EdgeInsets.all(12.0 * textScaleFactor),
                child: !showUtilization
                    ? RaisedButton(
                        textColor: Colors.white,
                        color: selectedTheme.primaryGradientColors[1],
                        child: Container(
                            height: 40,
                            width: displaySize.width * 0.45,
                            child: Center(
                                child: Text(
                              "Utilization Analysis",
                              style: TextStyle(fontSize: 18.0 * textScaleFactor),
                            ))),
                        onPressed: () {
                          setState(() {
                            showUtilization = true;
                            usedUtilzationContainer = UtilLineChart(connectionDetailItem["ip_addr"]);
                          });
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      )
                    : FadeIn(
                        ToggleSwitch(
                            initialLabelIndex: 0,
                            minWidth: displaySize.width * 0.25,
                            cornerRadius: 20,
                            activeBgColor: selectedTheme.primaryColor,
                            activeTextColor: Colors.white,
                            inactiveBgColor: Colors.grey[300], //gradientColors[1],
                            inactiveTextColor: Colors.black87,
                            labels: ['Trend', 'Table'],
                            icons: [Icons.show_chart, Icons.list],
                            onToggle: (index) {
                              setState(() {
                                usedUtilzationContainer = index == 1 ? UtilDataTable(connectionDetailItem["ip_addr"]) : UtilLineChart(connectionDetailItem["ip_addr"]);
                              });

                              // print('switched to: $index');
                            }),
                        0.5,
                        translate: false)),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: usedUtilzationContainer != null
            ? Container(
                height: 500,
                decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: usedUtilzationContainer,
                ),
              )
            : null,
      ),
    ]);
  }

  Widget utilizationTile() {
    double planData = Utils.convertToDouble(connectionDetailItem["datalimit"]);
    double consumedData = Utils.convertToDouble(connectionDetailItem["data"]);
    double payBonus = Utils.convertToDouble(connectionDetailItem["paybonus"]);
    double topup = Utils.convertToDouble(connectionDetailItem["topup"]);

    double totalDataLimit = planData + payBonus + topup;

    if (totalDataLimit != 0.0 && consumedData > totalDataLimit) consumedData = totalDataLimit;

    if (consumedFactor == 0.0001 && totalDataLimit > 0)
      Timer(Duration(seconds: 1), () {
        setState(() {
          consumedFactor = (consumedData / totalDataLimit);
        });
      });
    String consumedString = '';

    if (consumedData == null)
      consumedString = "0.00 of " + Utils.bytesToSize(totalDataLimit.toString()) + " consumed ";
    else
      consumedString = Utils.bytesToSize(consumedData.toString()) + " of " + Utils.bytesToSize(totalDataLimit.toString()) + " used ";

    if (totalDataLimit == 0.0 && consumedData != null) consumedString = Utils.bytesToSize(consumedData.toString()) + " consumed ";
    double containerHeight = displaySize.height * 0.065;
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: displaySize.width,
            height: containerHeight,
            decoration: BoxDecoration(color: selectedTheme.enabledBackground, borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: consumedFactor * displaySize.width,
            height: containerHeight,
            decoration: BoxDecoration(
                color: selectedTheme.primaryColor.withOpacity(0.3), //Colors.green[100],
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Center(
                child: Text(consumedString, style: TextStyle(fontSize: 20 * textScaleFactor, color: selectedTheme.primaryColor, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          height: containerHeight,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      ],
    );
  }

  Widget tileItem(label, value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(16.0 * textScaleFactor),
          decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label, style: TextStyle(fontSize: 22 * textScaleFactor, color: selectedTheme.primaryColor.withOpacity(0.5), fontWeight: FontWeight.w200)),
              Text(
                value,
                style: TextStyle(fontSize: 22 * textScaleFactor, color: selectedTheme.primaryColor, fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }
}
