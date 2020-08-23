import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/customer.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    print('conn detail ' + connectionDetail.toString());
    Customer.getConnectionLogs(connectionDetail["pkgnum"].toString()).then((value) {
      // print('conn logs ' + value.toString());
      setState(() {
        connectionLogs = value;
        if (connectionLogs.last["data_pack_type"] != "PostFUP") connectionLogs.add({"data_pack_type": "Consumed", "usedData": Utils.bytesToSize(connectionDetail["data"].toString())});

        connectionLogsLoaded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String contentData = "";
    return connectionLogsLoaded
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: List.generate(
                connectionLogs.length,
                (index) {
                  switch (connectionLogs[index]["data_pack_type"].toString()) {
                    case 'BonusData':
                      return bonusTile(index);
                      break;
                    case 'TopUp':
                      return topupTile(index);
                      break;
                    case 'PostFUP':
                      return postFUPTile(index);
                      break;
                    case 'Subscription':
                      return subscriptionTile(index);
                      break;
                    case 'Consumed':
                      return finalTile(index);
                      break;
                    default:
                      return postFUPTile(index);
                      break;
                  }
                },
              ),
            ),
          )
        : Center(child: SpinKitCircle(size: 35, color: Colors.grey));
  }

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

  subscriptionTile(index) {
    print('sub tile ' + connectionLogs[index].toString());
    return FadeIn(
      TimelineTile(
        isFirst: index == 0,
        isLast: index == connectionLogs.length - 1,
        alignment: TimelineAlign.left,
        lineX: 0.25,
        indicatorStyle: IndicatorStyle(width: 40, color: selectedTheme.activeBackground, iconStyle: IconStyle(iconData: Icons.flag, fontSize: 28, color: selectedTheme.primaryColor)),
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
                      Text(Utils.formatDateTimeString(connectionLogs[index]["data_pack_date"].toString())), //.split(" ")[0].toString()),

                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: selectedTheme.primaryText),
                            children: <TextSpan>[
                              TextSpan(text: "Using "),
                              connectionLogs[index]["data_pack_limit"] == 'Unltd' ? TextSpan(text: "a unlimited package ") : TextSpan(text: ""),
                              TextSpan(text: connectionDetail["pkgname"], style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: " with "),
                              TextSpan(text: connectionDetail["pkgdetail"], style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: " plan."),
                            ],
                          ),
                        ),
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
    );
  }

  bonusTile(index) {
    return connectionLogs[index]["data_pack_limit"].toString() == "0"
        ? SizedBox(
            height: 0,
          )
        : FadeIn(
            TimelineTile(
              isFirst: index == 0,
              isLast: index == connectionLogs.length - 1,
              alignment: TimelineAlign.left,
              lineX: 0.25,
              indicatorStyle: IndicatorStyle(width: 40, color: selectedTheme.activeBackground, iconStyle: IconStyle(iconData: Icons.thumb_up, fontSize: 26, color: selectedTheme.primaryColor)),
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
                            Text(Utils.formatDateTimeString(connectionLogs[index]["data_pack_date"].toString())), //.split(" ")[0].toString()),

                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: selectedTheme.primaryText),
                                  children: <TextSpan>[
                                    TextSpan(text: connectionLogs[index]["data_pack_limit"].toString() + " GB", style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: " bonus data added. The new limit is "),
                                    TextSpan(text: connectionLogs[index]["data_new_limit"].toString() + " GB."),
                                  ],
                                ),
                              ),
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
          );
  }

  postFUPTile(index) {
    return FadeIn(
      TimelineTile(
        isFirst: index == 0,
        isLast: index == connectionLogs.length - 1,
        alignment: TimelineAlign.left,
        lineX: 0.25,
        indicatorStyle: IndicatorStyle(width: 40, color: selectedTheme.activeBackground, iconStyle: IconStyle(iconData: Icons.trending_up, fontSize: 28, color: selectedTheme.primaryColor)),
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
                      Text(Utils.formatDateTimeString(connectionLogs[index]["data_pack_date"].toString())), //.split(" ")[0].toString()),

                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: selectedTheme.primaryText),
                            children: <TextSpan>[
                              TextSpan(text: connectionLogs[index]["data_pack_limit"].toString() + " GB", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: " of Post FUP data consumed. Total data consumptiion is "),
                              index == connectionLogs.length - 1 ? TextSpan(text: "about ") : TextSpan(text: ""),
                              TextSpan(text: connectionLogs[index]["data_new_limit"].toString() + " GB"),
                              index == connectionLogs.length - 1 ? TextSpan(text: " till now.") : TextSpan(text: ".")
                            ],
                          ),
                        ),
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
    );
  }

  topupTile(index) {
    // print("topup tile " + connectionLogs[index].toString());
    return FadeIn(
      TimelineTile(
        isFirst: index == 0,
        isLast: index == connectionLogs.length - 1,
        alignment: TimelineAlign.left,
        lineX: 0.25,
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
                      Text(Utils.formatDateTimeString(connectionLogs[index]["data_pack_date"].toString())), //.split(" ")[0].toString()),

                      Text(
                        connectionLogs[index]["data_pack_notes"].toString().replaceAll("[", "").replaceAll("]", ""),
                        style: TextStyle(color: selectedTheme.primaryText),
                      ),

                      // SizedBox(
                      //   height: 5,
                      // ),
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
    );
  }

  finalTile(index) {
    return FadeIn(
      TimelineTile(
        isFirst: index == 0,
        isLast: true,
        alignment: TimelineAlign.left,
        lineX: 0.25,
        indicatorStyle: IndicatorStyle(width: 40, color: selectedTheme.activeBackground, iconStyle: IconStyle(iconData: Icons.wifi, fontSize: 28, color: selectedTheme.primaryColor)),
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
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.formatDateTimeString(DateTime.now().toLocal().toString()),
                        style: TextStyle(color: selectedTheme.primaryText),
                      ),
                      Text(
                        "You have consumed about " + connectionLogs[index]["usedData"] + " data till now.",
                        style: TextStyle(color: selectedTheme.primaryText),
                      )
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
    );
  }
}
