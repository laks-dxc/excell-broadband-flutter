import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/customer.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  final dynamic conenctionDetail;

  Timeline(this.conenctionDetail);
  @override
  _TimelineState createState() => _TimelineState(conenctionDetail); //
}

class _TimelineState extends State<Timeline> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  dynamic connectionDetail;
  _TimelineState(this.connectionDetail);
  List<dynamic> connectionLogs;
  bool connectionLogsLoaded = false;

  @override
  void initState() {
    Customer.getConnectionLogs(connectionDetail["pkgnum"].toString()).then((value) {
      // print('conn logs ' + value.toString());
      setState(() {
        connectionLogs = value;
        connectionLogs.removeWhere((element) => element["data_pack_type"] == "PostFUP");
        connectionLogsLoaded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String content_data = "";
    return connectionLogsLoaded
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: List.generate(
                connectionLogs.length,
                (index) {
                  if (connectionLogs[index]["data_pack_type"] == "TopUp") {
                    String content = connectionLogs[index]["data_pack_notes"].toString();
                    int openBracketIndex = content.indexOf("[");
                    int closeBracketIndex = content.indexOf("]");
                    content_data = content.substring(openBracketIndex + 1, closeBracketIndex).replaceAll("GB", " GB");
                  }
                  return connectionLogs[index]["data_pack_type"] != "PostFUP"
                      ? FadeIn(
                          TimelineTile(
                            isFirst: index == 0,
                            isLast: index == connectionLogs.length - 1,
                            alignment: TimelineAlign.left,
                            lineX: 0.25,
                            /*

{
  data_pack_type: PostFUP, 
data_pack_name: Post FUP Data, 
data_pack_limit: 211, 
data_new_limit: 511, 
data_pack_date: 2020-08-15 00:40:17, 
data_pack_notes: Post FUP Data
}
                            */

                            indicatorStyle: IndicatorStyle(width: 40, color: selectedTheme.activeBackground, iconStyle: IconStyle(iconData: Icons.add_circle, fontSize: 28, color: selectedTheme.primaryColor)),
                            rightChild: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                                // alignment: Alignment.topLeft,
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Stack(
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                                            child: Text(
                                              connectionLogs[index]["data_pack_type"].toString(),
                                              style: TextStyle(fontSize: 40, color: selectedTheme.primaryColor.withOpacity(0.1)),
                                            ),
                                          )),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(connectionLogs[index]["data_pack_date"].toString().split(" ")[0].toString()),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Consumed : " + content_data),
                                              Text("Added : " + connectionLogs[index]["data_pack_limit"].toString() + " GB"),
                                              Text("Updated : " + connectionLogs[index]["data_new_limit"].toString() + " GB"),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            connectionLogs[index]["data_pack_notes"].toString().replaceAll("[", "").replaceAll("]", ""),
                                            style: TextStyle(color: selectedTheme.primaryText),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          index * 0.2,
                          direction: Direction.y,
                          distance: -10.0,
                        )
                      : SizedBox(
                          height: 0,
                        );
                },
              ),
            ),
          )
        : SizedBox(
            height: 0,
          );
  }
}
