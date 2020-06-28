import 'package:ExcellCustomer/widgets/connectionDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'animation/fadeIn.dart';
import 'helpers/Utils.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class MyPackages extends StatefulWidget {
  @override
  _MyPackagesState createState() => _MyPackagesState();
}

class _MyPackagesState extends State<MyPackages> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  Size displaySize;

  List<dynamic> connections;
  String activeIP;
  MyPackagesScreenMode myPackagesScreenMode;

  @override
  void initState() {
    Customer.connectionsList().then((_connections) {
      setState(() {
        connections = _connections;

        if (connections.length == 1) {
          myPackagesScreenMode = MyPackagesScreenMode.Detail;
          activeIP = connections[0]["ip_addr"];
          print("activeIP " + activeIP);
        } else {
          myPackagesScreenMode = MyPackagesScreenMode.List;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;

    return connections != null ? showData() : showLoader();
  }

  showLoader() {
    return Center(
      child: SpinKitCircle(size: 40, color: Colors.grey),
    );
  }

  showData() {
    return connections.length > 1 ? connectionsListScreen() : ConnectionDetail(connections[0]);
  }

  connectionsListScreen() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
                color: selectedTheme.activeBackground.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(connections.length, (index) {
                  return FadeIn(
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Scaffold(
                              backgroundColor: selectedTheme.scaffoldBgColor,
                              appBar: AppBar(
                                  title: Text(connections[index]["pkgname"]),
                                  backgroundColor: selectedTheme.appBarColor //(0xff112c75),
                                  ),
                              body: ConnectionDetail(
                                connections[index],
                              ),
                            ),
                          ),
                        );
                      },
                      child: connectionListItemContainer(connections[index]),
                    ),
                    index * 0.5,
                    direction: Direction.y,
                    distance: -15.0,
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  connectionListItemContainer(connectionListItem) {
    return Container(
      width: displaySize.width,
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(Utils.clipStringTo(connectionListItem["pkgname"], 18),
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: selectedTheme.primaryColor,
                              fontSize: 21,
                              fontWeight: FontWeight.w600)),
                      Text(connectionListItem["ip_addr"],
                          style: TextStyle(
                              color: selectedTheme.primaryColor.withOpacity(0.8), fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(connectionListItem["pkgdetail"],
                      style: TextStyle(
                          color: selectedTheme.primaryColor.withOpacity(0.8), fontSize: 20))
                ],
              ))),
    );
  }
}
