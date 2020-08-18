import 'package:ExcellCustomer/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  final String pkgnum;

  Timeline(this.pkgnum);
  @override
  _TimelineState createState() => _TimelineState(pkgnum);
}

class _TimelineState extends State<Timeline> {
  String pkgnum;
  _TimelineState(this.pkgnum);
  List<dynamic> connectionLogs;
  bool connectionLogsLoaded = false;

  @override
  void initState() {
    Customer.getConnectionLogs(pkgnum).then((value) {
      print('conn logs ' + value.toString());
      setState(() {
        connectionLogs = value;
        connectionLogsLoaded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return connectionLogsLoaded
        ? ListView(
            children: List.generate(
              connectionLogs.length,
              (index) {
                return TimelineTile(
                  isFirst: index == 0,
                  isLast: index == connectionLogs.length - 1,
                  alignment: TimelineAlign.manual,
                  lineX: 0.25,
                  leftChild: Container(
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(connectionLogs[index]["data_pack_date"].toString().split(' ')[0]),
                      ),
                    ),
                  ),
                  indicatorStyle: IndicatorStyle(width: 40, iconStyle: IconStyle(iconData: Icons.flag, color: Colors.blue[50])),
                  rightChild: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(connectionLogs[index]["data_pack_notes"]),
                      )),
                );
              },
            ),
          )
        : SizedBox(
            height: 0,
          );
  }
}
