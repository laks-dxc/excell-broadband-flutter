import 'dart:async';

// import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:ExcellCustomer/topupsList.dart';
import 'package:ExcellCustomer/utilization.dart';
import 'package:flutter/material.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// import 'dataTable.dart';
// import 'lineChart.dart';

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
  num consumedFactor = 0.0001;
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
    return connectionDetailItem["status"].toString() == 'Suspend'
        ? ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: selectedTheme.inActiveBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Padding(
                    padding: EdgeInsets.all(8.0 * textScaleFactor),
                    child: Column(
                      children: <Widget>[
                        tileItem("Package", Utils.clipStringTo(connectionDetailItem["pkgname"], 20), inactive: true),
                        tileItem("Plan", connectionDetailItem["pkgdetail"], inactive: true),
                        tileItem("IP Address", connectionDetailItem["ip_addr"], inactive: true),
                        tileItem("Status", connectionDetailItem["status"], inactive: true),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: selectedTheme.inActiveBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Padding(
                    padding: EdgeInsets.all(8.0 * textScaleFactor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[tileItem("Suspended Date", Utils.formatDateString(connectionDetailItem["suspend_date"]), inactive: true), tileText("Reason:  " + connectionDetailItem["suspend_reason"].toString(), inactive: true)],
                    ),
                  ),
                ),
              ),
            ],
          )
        : ListView(
            children: <Widget>[
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
                        tileItem(
                          "IP Address",
                          connectionDetailItem["ip_addr"],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              connectionDetailItem["datalimit"] != null
                  ? Padding(
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
                              connectionDetailItem["topup_total_gb"] != "0"
                                  ? tileItem("Total Top Ups", double.parse(connectionDetailItem["topup_total_gb"].toString()).toStringAsFixed(2) + " GB")
                                  : SizedBox(
                                      width: 0,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              tileItem("Plan Type", "Unlimited"),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            textColor: Colors.white,
                            color: selectedTheme.primaryGradientColors[1],
                            child: Container(
                                height: 40,
                                width: displaySize.width * 0.35,
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
                                // print("topupeligibility_note " + connectionDetailItem["topupeligibility_note"]);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => new Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(connectionDetailItem["topupeligibility_note"].toString().replaceAll("|", "\n")),
                                          ),
                                        ));
                              }
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          RaisedButton(
                            textColor: Colors.white,
                            color: selectedTheme.primaryGradientColors[1],
                            child: Container(
                                height: 40,
                                width: displaySize.width * 0.35,
                                child: Center(
                                    child: Text(
                                  "Utilization",
                                  style: TextStyle(fontSize: 18.0 * textScaleFactor),
                                ))),
                            onPressed: () {
                              setState(() {
                                // showUtilization = true;
                                // usedUtilzationContainer = UtilLineChart(connectionDetailItem["ip_addr"]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Utilization(connectionDetailItem),
                                  ),
                                );
                              });
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget utilizationTile() {
    num consumedData;
    num totalDataLimit;

    bool isUnlimited = connectionDetailItem["datalimit"] == null;
    String consumedString = '';

    consumedData = connectionDetailItem["data"] == null ? 0 : int.parse(connectionDetailItem["data"]);

    if (consumedFactor == 0.0001 && !isUnlimited) {
      totalDataLimit = connectionDetailItem["grand_total"];

      totalDataLimit = totalDataLimit == 0 ? 1 : totalDataLimit;
      consumedData = consumedData == 0 ? 1 : consumedData;

      Timer(Duration(seconds: 1), () {
        setState(() {
          consumedFactor = (consumedData / totalDataLimit);
        });
      });
    }
    if (isUnlimited)
      consumedString = "Total " + Utils.bytesToSize(consumedData.toString()) + " consumed ";
    else {
      totalDataLimit = connectionDetailItem["grand_total"];

      if (consumedData == 0)
        consumedString = "0.00 GB of " + Utils.bytesToSize(totalDataLimit.toString()) + " consumed ";
      else {
        consumedString = "Total " + Utils.bytesToSize(consumedData.toString()) + " of " + Utils.bytesToSize(totalDataLimit.toString()) + " used ";
      }
    }

    double containerHeight = displaySize.height * 0.080;

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
              SizedBox(height: 5),
              connectionDetailItem["postfup_total"].toString() != "0"
                  ? Text("* Includes " + Utils.bytesToSize(connectionDetailItem["postfup_total"].toString()) + " of post FUP utilization", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: selectedTheme.appBarColor))
                  : SizedBox(
                      height: 0,
                    )
            ],
          ),
          height: containerHeight,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        )
      ],
    );
  }

  Widget tileItem(label, value, {inactive: false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(16.0 * textScaleFactor),
          decoration: BoxDecoration(color: inactive ? selectedTheme.inActiveBackground.withOpacity(0.5) : selectedTheme.activeBackground.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
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

  Widget tileText(text, {inactive: false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          // height: text.toString().length * 2.0 * textScaleFactor,
          padding: EdgeInsets.all(16.0 * textScaleFactor),
          decoration: BoxDecoration(color: inactive ? selectedTheme.inActiveBackground.withOpacity(0.5) : selectedTheme.activeBackground.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Text(label, style: TextStyle(fontSize: 22 * textScaleFactor, color: selectedTheme.primaryColor.withOpacity(0.5), fontWeight: FontWeight.w200)),
              Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 22 * textScaleFactor, color: selectedTheme.primaryColor.withOpacity(0.5), fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }
}
