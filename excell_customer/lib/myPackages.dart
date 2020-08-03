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
        } else if (connections.length > 1) {
          myPackagesScreenMode = MyPackagesScreenMode.List;
        } else {
          myPackagesScreenMode = MyPackagesScreenMode.NoPackages;
        }
      });
    });

    super.initState();
  }

  double textScaleFactor;
  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0 ? 1.0 : 0.85 / MediaQuery.of(context).textScaleFactor;

    return connections != null ? showData() : showLoader();
  }

  showLoader() {
    return Center(
      child: SpinKitCircle(size: 40, color: Colors.grey),
    );
  }

  showData() {
    return connections.length > 1 ? connectionsListScreen() : connections.length == 0 ? noConnectionsPage() : ConnectionDetail(connections[0]);
  }

  Widget noConnectionsPage() {
    return Container(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: displaySize.width,
            height: 80.0,
            child: Stack(children: [
              Center(
                child: Text(
                  "No active packages found",
                  style: TextStyle(fontSize: 20, color: selectedTheme.primaryText),
                ),
              ),
              Align(alignment: Alignment(1.1, 1.0), child: Icon(Icons.cancel, size: 90, color: Colors.red.withOpacity(0.5))),
            ]),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.red[200], //selectedTheme.activeBackground.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1, color: selectedTheme.primaryGradientColors[0])),
          ),
        ),
        // SizedBox(height: 50),
        // RaisedButton(
        //   textColor: Colors.grey,
        //   color: Colors.grey[500],
        //   child: Container(
        //       height: 50,
        //       width: 250,
        //       child: Center(
        //           child: Text(
        //         "Request Activation",
        //         style: TextStyle(fontSize: 18.0),
        //       ))),
        //   onPressed: () {},
        //   shape: new RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(30.0),
        //   ),
        // )
      ]),
    );
  }

  connectionsListScreen() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                              appBar: AppBar(title: Text(connections[index]["pkgname"]), backgroundColor: selectedTheme.appBarColor //(0xff112c75),
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
      padding: EdgeInsets.all(8.0 * textScaleFactor),
      child: Container(
          decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
              padding: EdgeInsets.all(16.0 * textScaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(Utils.clipStringTo(connectionListItem["pkgname"], 18), overflow: TextOverflow.clip, style: TextStyle(color: selectedTheme.primaryColor, fontSize: 21 * textScaleFactor, fontWeight: FontWeight.w600)),
                      Text(connectionListItem["ip_addr"], style: TextStyle(color: selectedTheme.primaryColor.withOpacity(0.8), fontSize: 20 * textScaleFactor)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(connectionListItem["pkgdetail"], style: TextStyle(color: selectedTheme.primaryColor.withOpacity(0.8), fontSize: 20 * textScaleFactor))
                ],
              ))),
    );
  }
}
