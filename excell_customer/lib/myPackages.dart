import 'package:ExcellCustomer/helpers/storageUtils.dart';
import 'package:ExcellCustomer/widgets/connectionDetail.dart';
import 'package:flutter/material.dart';

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

    return connections != null ? ConnectionDetail(connections[0]) : Container();
  }

  connectiosnListScreen() {}
}
