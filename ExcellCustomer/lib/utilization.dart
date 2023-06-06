import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/widgets/dataTable.dart';
import 'package:ExcellCustomer/widgets/lineChart.dart';
import 'package:ExcellCustomer/widgets/timeline.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/enum.dart';

class Utilization extends StatefulWidget {
  final dynamic connectionDetailItem;
  Utilization(this.connectionDetailItem);
  @override
  _UtilizationState createState() => _UtilizationState(connectionDetailItem);
}

class _UtilizationState extends State<Utilization> {
  dynamic connectionDetailItem;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  Widget? usedUtilzationContainer;
  Size? displaySize;
  double? textScaleFactor;

  _UtilizationState(this.connectionDetailItem);

  @override
  void initState() {
    usedUtilzationContainer = UtilLineChart(connectionDetailItem["ip_addr"]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;

    displaySize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: selectedTheme.appBarColor,
          title: Text(
            Utils.clipStringTo(connectionDetailItem["pkgname"], 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: selectedTheme.activeBackground.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(12.0 * textScaleFactor!),
                    child: ToggleSwitch(
                        initialLabelIndex: 0,
                        minWidth: displaySize!.width * 0.25,
                        cornerRadius: 20,
                        activeBgColor: [selectedTheme.primaryColor],
                        // activeTextColor: Colors.white,
                        inactiveBgColor: Colors.grey[300],
                        // inactiveTextColor: Colors.black87,
                        labels: [
                          'Trend',
                          'Table',
                          'Timeline',
                        ],
                        icons: [Icons.show_chart, Icons.list, Icons.menu],
                        onToggle: (index) {
                          setState(() {
                            usedUtilzationContainer = index == 0
                                ? UtilLineChart(connectionDetailItem["ip_addr"])
                                : index == 1
                                    ? SingleChildScrollView(
                                        child: UtilDataTable(
                                            connectionDetailItem["ip_addr"]))
                                    : Timeline(connectionDetailItem);
                          });
                        }),
                  ),
                ),
              ),
              usedUtilzationContainer != null
                  ? Expanded(
                      child: usedUtilzationContainer!,
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ));
  }
}
