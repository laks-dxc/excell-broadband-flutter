import 'dart:convert' as convert;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/widgets/TimeSeriesBar.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class MyPackages extends StatefulWidget {
  @override
  _MyPackagesState createState() => _MyPackagesState();
}

class _MyPackagesState extends State<MyPackages> {
  final CodeHelpers codeHelpers = new CodeHelpers();

  @override
  void initState() {
    getConnectionsList();

    super.initState();
  }

  bool dataLoaded = false;
  int currentConnectionIndex = 0;

  var connectionsList, noOfConnections;

  var currentPackageName, currentPackageDetail, currentIPAddr;

  var currentConnection;
  String currentDataLimit,
      currentNewLimit,
      currentData,
      currentLimit,
      currentDataNewLimit,
      currentConsumedInGB,
      currentFinalDataLimitInGB,
      dueDate,
      currentDataLimitInGB,
      invoiceDate,
      pgMsg,
      currentTopup,
      currentPayBonus,
      currentPlanData;

  String amount;
  String currentTopupInGB, currentPayBonusInGB, currentPlanDataInGB;

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
  double dCurrentPlanData;

  int selectedConnectionIndex = 0;
  SolidController _controller = SolidController();

  Color headerColor = Color.fromRGBO(255, 255, 255, 0);

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
    setState(() {
      barChartContainer = loader(size: 20.0);
    });

    selectedConnectionIndex = index;

    var lCurrentConnection =
        connectionsList["resonse"]["result"]["connections"][index];

    // print(lCurrentConnection);

    currentPackageName = lCurrentConnection["pkgname"] ?? "Error";
    currentIPAddr = lCurrentConnection["ip_addr"] ?? "Error";
    currentPackageDetail = lCurrentConnection["pkgdetail"] ?? "Error";
    currentPlanData = lCurrentConnection["datalimit"] ?? "Error";
    currentPayBonus = lCurrentConnection["paybonus"];
    currentTopup = lCurrentConnection["topup"];

    currentDataLimit = lCurrentConnection["datalimit"];

    currentData = lCurrentConnection["data"];
    currentNewLimit = lCurrentConnection["new_limit"];
    dueDate = lCurrentConnection["due_bill_date"] == null
        ? ""
        : formatDate(DateTime.parse(lCurrentConnection["due_bill_date"]),
            [dd, '-', M, '-', yyyy]);

    invoiceDate = lCurrentConnection["last_bill_date"] == null
        ? ""
        : formatDate(DateTime.parse(lCurrentConnection["last_bill_date"]),
            [dd, '-', M, '-', yyyy]);

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

    var utilzationBody = {
      "name": "getUsageReport",
      "param": {
        "customerId": codeHelpers.getStorageKey('custId'),
        "ip": currentIPAddr
      }
    };

    codeHelpers
        .httpPost(utilzationBody, needAuth: true)
        .then((utilzationDetails) {
      utilzationDetails
          .transform(convert.utf8.decoder)
          .join()
          .then((utilizationRaw) {
        var usageList = convert.jsonDecode(utilizationRaw)["resonse"]["result"]
            ["usagereport"];
        // print("usageList " + usageList.toString());
//         usageList = [
//   {
//     "date": "2020-06-01",
//     "ip": "172.16.154.88",
//     "download": "36756.97",
//     "upload": "1025.42",
//     "total": "37782.39"
//   },
//   {
//     "date": "2020-06-02",
//     "ip": "172.16.154.88",
//     "download": "19181.32",
//     "upload": "1003.23",
//     "total": "20184.55"
//   },
//   {
//     "date": "2020-06-03",
//     "ip": "172.16.154.88",
//     "download": "23938",
//     "upload": "1017",
//     "total": "24955"
//   },
//   {
//     "date": "2020-06-04",
//     "ip": "172.16.154.88",
//     "download": "20367",
//     "upload": "1023",
//     "total": "21390"
//   },
//   {
//     "date": "2020-06-05",
//     "ip": "172.16.154.88",
//     "download": "32046",
//     "upload": "1004",
//     "total": "33050"
//   },
//   {
//     "date": "2020-06-06",
//     "ip": "172.16.154.88",
//     "download": "32839",
//     "upload": "1016",
//     "total": "33855"
//   },
//   {
//     "date": "2020-06-07",
//     "ip": "172.16.154.88",
//     "download": "35382",
//     "upload": "1024",
//     "total": "36406"
//   },
//   {
//     "date": "2020-06-08",
//     "ip": "172.16.154.88",
//     "download": "23091",
//     "upload": "1006",
//     "total": "24097"
//   }
// ];

        var i = 0;
        var j = 0;
        final List<MonthlyUtilization> usageUpload = new List(usageList.length);
        final List<MonthlyUtilization> usageDownload =
            new List(usageList.length);

        if (usageList.length == 0) {
          setState(() {
            barChartContainer = Center(
              child: Text(
                "No Data",
                style: TextStyle(fontSize: 25),
              ),
            );
          });
        } else {
          usageList.forEach((usageDay) {
            // print(usageDay);
            setState(() {
              usageUpload[i] = new MonthlyUtilization(
                  formatDate(DateTime.parse(usageDay["date"]), [dd]),
                  double.parse(usageDay["upload"]) / 1024);
              usageDownload[j] = new MonthlyUtilization(
                  formatDate(DateTime.parse(usageDay["date"]), [dd]),
                  double.parse(usageDay["download"]) / 1024);
              i++;
              j++;
            });

            var seriesList = [
              new charts.Series<MonthlyUtilization, String>(
                id: 'Download',
                displayName: "Download in GB",
                seriesColor: charts.MaterialPalette.indigo.shadeDefault,
                domainFn: (MonthlyUtilization utilization, _) =>
                    utilization.day,
                measureFn: (MonthlyUtilization utilization, _) =>
                    utilization.dataInMB,
                colorFn: (_, __) => charts.ColorUtil.fromDartColor(
                    Color.fromRGBO(0, 185, 251, 10)),
                data: usageDownload,
              ),
              new charts.Series<MonthlyUtilization, String>(
                id: 'Upload',
                displayName: "Upload in GB",
                seriesColor: charts.MaterialPalette.pink.shadeDefault,
                domainFn: (MonthlyUtilization utilization, _) =>
                    utilization.day,
                measureFn: (MonthlyUtilization utilization, _) =>
                    utilization.dataInMB, //* 15.3,
                data: usageUpload,
                colorFn: (_, __) => charts.ColorUtil.fromDartColor(
                    Color.fromRGBO(255, 67, 30, 10)),
              ),
            ];

            setState(() {
              barChartContainer = charts.BarChart(
                seriesList,
                // defaultRenderer: new charts.BarRendererConfig<String>( strokeWidthPx: 0.3, barRendererDecorator: CustomBarLabelDecorator<String>(labelAnchor: CustomBarLabelAnchor.middle), ),
                selectionModels: [
                  new charts.SelectionModelConfig(
                    type: charts.SelectionModelType.info,
                    changedListener: chartSelectionChanged,
                    // listener: ,
                  )
                ],

                defaultInteractions: true,
                animate: true,
                barGroupingType: charts.BarGroupingType.groupedStacked,
                behaviors: [
                  new charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom),
                ],
              );
            });
          });
        }

        // noOfConnections =
        // connectionsList["resonse"]["result"]["connections"].length;
      });
    });

    setState(() {
      dCurrentConsumed = dCurrentData;
      currentPlanDataInGB = codeHelpers
              .bytesToGB(double.parse(currentPlanData))
              .toStringAsFixed(2) +
          " GB";
      dCurrentConsumedInGB = codeHelpers.bytesToGB(dCurrentConsumed);
      dCurrentFinalDataLimitInGB =
          codeHelpers.bytesToGB(dCurrentFinalDataLimit);

      currentConsumedInGB = dCurrentConsumedInGB.toStringAsFixed(2) + " GB";
      currentFinalDataLimitInGB =
          dCurrentFinalDataLimitInGB.toStringAsFixed(2) + " GB";

      // dConsumedPercent = dCurrentConsumed / dCurrentFinalDataLimit;

      dConsumedPercent = dCurrentConsumed / dCurrentFinalDataLimit;

      // dConsumedPercent = 0.72;
    });
  }

  bool chartSelected = false;

  void chartSelectionChanged(charts.SelectionModel selectionModel) {
    // MonthlyUtilization monthlyUtilization =
    //     selectionModel.selectedDatum[0].datum;

    setState(() {
      chartInfo = Text("");

      if (selectionModel.selectedSeries.length == 1 &&
          selectionModel.selectedSeries[0].displayName == 'Download in GB') {
        chartSelected = true;

        gDate = selectionModel.selectedDatum[0].datum.day.toString();

        gUpload = double.parse(
                selectionModel.selectedDatum[1].datum.dataInMB.toString())
            .toStringAsPrecision(2);
        gDownload = double.parse(
                selectionModel.selectedDatum[0].datum.dataInMB.toString())
            .toStringAsPrecision(2);

        chartInfo = WidgetAnimator(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                child: Text(
                  gDate + " " + formatDate(DateTime.now(), [MM, " ", yyyy]),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                width: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.cloud_download),
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                    child: Text(gDownload + " GB"),
                    width: 60,
                  ),
                  Icon(Icons.cloud_upload),
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 4.0, 0.0, 0.0),
                    child: Text(gUpload + " GB"),
                    width: 60,
                  ),
                ],
              )
            ],
          ),
        ));
      }
    });

    // print(gDate);
    // print('Download');
    // print(gDownload);
    // print('Upload');
    // print();
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
          dataLoaded = true;
          connectionsList = convert.jsonDecode(customerConnectionsRaw);

          noOfConnections =
              connectionsList["resonse"]["result"]["connections"].length;

          if (noOfConnections >= 0) {
            currentConnection = connectionsList["resonse"]["result"]
                ["connections"][currentConnectionIndex];
            selectedConnectionIndex = 0;
            populateCurrentConnectionVariables(0);
          }

          // new Future.delayed(
          //     const Duration(milliseconds: 2000), () => dataLoaded = true);
        });
      });
    });
  }

  static Widget loader({size: 50.0}) {
    return Center(
      child: Loading(
        indicator: BallPulseIndicator(),
        size: size,
        color: Colors.black45,
      ),
    );
  }

  detailsListValue(label, value) {
    return WidgetAnimator(
      Card(
        elevation: 1.0,
        color: Colors.white, //Color.fromRGBO(184, 27, 77, 10),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(color: Colors.black87, fontSize: 18),
              ),
              Text(
                value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  headerView(label, {showValue: false, value}) {
    return WidgetAnimator(
      Card(
        elevation: 1.0,
        color:
            Color.fromRGBO(184, 27, 77, 10), //Color.fromRGBO(184, 27, 77, 10),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              showValue == true
                  ? GestureDetector(
                      onTap: () {
                         chartInfo = Text("");
                        _controller.isOpened
                            ? _controller.hide()
                            : _controller.show();
                      },
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  packageDetails() {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      floatingActionButton: noOfConnections > 1000
          ? Container(
              // padding: EdgeInsets.only(bottom: 100.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(Icons.more_horiz),
                  backgroundColor: Color.fromRGBO(0, 32, 97, 5),
                  onPressed: () {
                    _controller.isOpened
                        ? _controller.hide()
                        : _controller.show();
                  },
                ),
              ),
            )
          : null,
      backgroundColor: Colors.white, //Color.fromRGBO(184, 27, 77, 10),
      bottomSheet: noOfConnections > 1 ? bottomSheet() : null,
      body: ListView(
        children: [
          headerView(currentPackageName ?? "",
              showValue: noOfConnections > 1, value: "View More"),
          // detailsListValue("Name", currentPackageName ?? ""),
          detailsListValue("Details", currentPackageDetail ?? ""),
          detailsListValue("IP Address", currentIPAddr ?? ""),
          // detailsListValue("Data Limit", currentDataLimit ?? ""),
          detailsListValue("Plan Data", currentPlanDataInGB ?? ""),

          currentPayBonus == null
              ? SizedBox(height: 0.0)
              : detailsListValue(
                  "Pay Bonus",
                  codeHelpers
                          .bytesToGB(double.parse(currentPayBonus))
                          .toStringAsFixed(2) +
                      " GB"),

          currentTopup == null
              ? SizedBox(height: 0.0)
              : detailsListValue(
                  "Top Up",
                  codeHelpers
                          .bytesToGB(double.parse(currentTopup))
                          .toStringAsFixed(2) +
                      " GB"),

          detailsListValue("Current Limit", currentFinalDataLimitInGB ?? ""),
          detailsListValue("Consumed Data", currentConsumedInGB ?? ""),
          // detailsListValue(, ""),
          headerView("Daily Utlization - " +
              formatDate(DateTime.now(), [MM, " ", yyyy])),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blueGrey, width: 1.0),
                ),
              ),
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: barChartContainer,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: chartInfo,
          ), //selectedChartDetail(gDate, gUpload, gDownload)),
        ],
      ),
    );
  }

  String gDate;
  String gUpload;
  String gDownload;
  Widget chartInfo = Text("");

  selectedChartDetail(lDate, lUpload, lDownload) {
    // return
    return !chartSelected
        ? Text("Nothing selected")
        : Row(
            children: <Widget>[
              Text(lDate),
              Text("Upload"),
              Text(lUpload),
              Text("Downlaod"),
              Text(lDownload),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          );
  }

  Widget barChartContainer = loader(size: 20.0);

  void setHeaderColor(Color _headerColor) {
    setState(() {
      headerColor = _headerColor;
    });
  }

  bottomSheet() {
    return SolidBottomSheet(
      controller: _controller,
      maxHeight: noOfConnections * 75.0,
      headerBar: Container(
        color: Color.fromRGBO(184, 27, 77, 10),
        height: 10,
      ),
      body: Container(
        color: Color.fromRGBO(229, 255, 255, 10),
        height: 30,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: noOfConnections,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                populateCurrentConnectionVariables(index);
              },
              leading: selectedConnectionIndex == index
                  ? Icon(
                      Icons.check_circle,
                      color: Color.fromRGBO(184, 27, 77, 10),
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                    ),
              title: Text(connectionsList["resonse"]["result"]["connections"]
                  [index]["pkgname"]),
              trailing: Text(connectionsList["resonse"]["result"]["connections"]
                  [index]["ip_addr"]),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dataLoaded ? packageDetails() : loader();
  }
}
