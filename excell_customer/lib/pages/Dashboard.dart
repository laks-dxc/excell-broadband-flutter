import 'dart:convert' as convert;

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CodeHelpers codeHelpers = new CodeHelpers();

  _DashboardState() {
    getConnectionsList();
  }

  bool dataLoaded = false;
  int currentConnectionIndex = 0;

  var connectionsList, noOfConnections;

  var currentPackageName, currentPackageDetail, currentIPAddr;

  var currentConnection;
  String currentTopup,
      currentDataLimit,
      currentNewLimit,
      currentData,
      currentLimit,
      currentDataNewLimit,
      currentPayBonus,
      currentConsumedInGB,
      currentFinalDataLimitInGB;
  // String consumedPercent = "0";

  double dCurrentConsumed,
      dCurrentFinalDataLimit,
      dCurrentDataNewLimit,
      dCurrentConsumedInGB,
      dCurrentFinalDataLimitInGB;

  double dCurrentData;
  double dCurrentDataLimit;
  double dCurrentTopup;
  double dCurrentNewLimit;
  double dCurrentPayBonus;
  double dConsumedPercent;

  @override
  Widget build(BuildContext context) {
    if (dataLoaded) {
      if (noOfConnections >= 0)
        return dashboardContent();
      else
        return noDataView();
    } else {
      return loader();
    }
  }

  populateCurrentConnectionVariables(index) {
    // lCurrentConnection = {
    //   "pkgnum": 300208,
    //   "pkgname": "Smart",
    //   // "pkgname": null,
    //   "ip_addr": "172.16.100.197",
    //   "speed_down": "50",
    //   "mac_addr": "1c:5f:2b:9f:3e:a1",
    //   "data": null,
    //   "datalimit": 429496729600,
    //   "topup": null,
    //   "new_limit": null,
    //   "paybonus": null,
    //   "freq": 1,
    //   "pkgdetail": "50Mbps-400GB",
    //   "last_bill_date": "2020-04-01",
    //   "due_bill_date": "2020-04-06"
    // };

    var lCurrentConnection =
        connectionsList["resonse"]["result"]["connections"][index];

    currentPackageName = lCurrentConnection["pkgname"] ?? "Error";
    currentIPAddr = lCurrentConnection["ip_addr"] ?? "Error";
    currentPackageDetail = lCurrentConnection["pkgdetail"] ?? "Error";

    currentDataLimit = lCurrentConnection["datalimit"];
    currentData = lCurrentConnection["data"];
    currentNewLimit = lCurrentConnection["new_limit"];

    if (currentData == null) {
      dCurrentData = 0;
    } else {
      dCurrentData = double.parse(currentData);
    }

    dCurrentDataLimit = double.parse(currentDataLimit);

    dCurrentFinalDataLimit = dCurrentDataLimit;

    if (dCurrentData > dCurrentDataLimit) {
      if (currentNewLimit != null) {
        dCurrentFinalDataLimit = double.parse(currentNewLimit);
      } else {
        dCurrentData = dCurrentDataLimit;
      }
    }

    dCurrentConsumed = dCurrentData;

    dCurrentConsumedInGB = codeHelpers.bytesToGB(dCurrentConsumed);
    dCurrentFinalDataLimitInGB = codeHelpers.bytesToGB(dCurrentFinalDataLimit);

    currentConsumedInGB = dCurrentConsumedInGB.toStringAsFixed(2) + " GB";
    currentFinalDataLimitInGB =
        dCurrentFinalDataLimitInGB.toStringAsFixed(2) + " GB";

    dConsumedPercent = dCurrentConsumed / dCurrentFinalDataLimit;
  }

  getConnectionsList() {
    var body = {
      "name": "getConnectionsList",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    codeHelpers.httpPost(body, needAuth: true).then((customerDetails) {
      customerDetails
          .transform(convert.utf8.decoder)
          .join()
          .then((customerConnectionsRaw) {
        setState(() {
          connectionsList = convert.jsonDecode(customerConnectionsRaw);

          noOfConnections =
              connectionsList["resonse"]["result"]["connections"].length;

          if (noOfConnections >= 0) {
            currentConnection = connectionsList["resonse"]["result"]
                ["connections"][currentConnectionIndex];

            populateCurrentConnectionVariables(0);
          }

          dataLoaded = true;
          // new Future.delayed(
          //     const Duration(seconds: 100), () => dataLoaded = true);
        });
      });
    });
  }

  noDataView() {
    return Stack(
      children: <Widget>[
        Image.asset('assets/login_bg.png'),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.mehBlank,
                size: 100,
                color: Colors.white,
              ),
              Text(
                "No Connections Found",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  loader() {
    return Center(
      child: Loading(
        indicator: BallPulseIndicator(),
        size: 50.0,
        color: Colors.white60,
      ),
    );
  }

  connectioDetail() {
    return Column(
      children: <Widget>[
        Card(
          elevation: 2.0,
          color: Color.fromRGBO(95, 32, 97, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Details",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("",
                    style: TextStyle(color: Colors.white70, fontSize: 20)),
              ),
            ],
          ),
        ),
        Card(
          elevation: 2.0,
          color: Color.fromRGBO(184, 27, 77, 10),
          child: Column(
            children: <Widget>[
              listTileWidget("Package", currentPackageName),
              listTileWidget("Details", currentPackageDetail),
              listTileWidget("IP Address", currentIPAddr, showDivider: false),
            ],
          ),
        ),
      ],
    );
  }

  listTileWidget(lable, value, {showDivider: true}) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text(
            lable,
            style: TextStyle(fontSize: 20, color: Colors.white54),
          ),
          trailing: Text(
            value,
            // currentConnection["pkgname"].toString(),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        showDivider
            ? Divider(
                thickness: 2.0,
              )
            : Text("")
      ],
    );
  }

  consumptionDetail() {
    return Column(
      children: <Widget>[
        Card(
          elevation: 2.0,
          color: Color.fromRGBO(95, 32, 97, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Consumption",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ),
              Text(""),
            ],
          ),
        ),
        Card(
          elevation: 2.0,
          color: Color.fromRGBO(184, 27, 77, 10),
          child: Center(
            child: CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 25.0,
              arcType: ArcType.FULL,
              animation: true,
              percent: dConsumedPercent,
              arcBackgroundColor: Colors.white38,
              footer: Text(
                currentConsumedInGB + " / " + currentFinalDataLimitInGB,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              center: Text(
                (dConsumedPercent * 100).toStringAsFixed(0) + "%",
                style: TextStyle(
                    fontSize: 38,
                    letterSpacing: 2.0,
                    color: Color.fromRGBO(0, 32, 97, 5),
                    fontWeight: FontWeight.w500),
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
          ),
        ),
      ],
    );
  }

  dashboardContent() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView(
        children: <Widget>[
          consumptionDetail(),
          connectioDetail(),
        ],
      ),
    );
  }
}
