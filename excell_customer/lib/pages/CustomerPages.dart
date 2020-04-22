import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/Dashboard.dart';
import 'package:ExcellCustomer/pages/Home.dart';
import 'package:ExcellCustomer/pages/Packages.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Enquiry.dart';
import 'Payment.dart';
import 'Support.dart';

class CustomerPages extends StatefulWidget {
  @override
  _CustomerPagesState createState() => _CustomerPagesState();
}

class _CustomerPagesState extends State<CustomerPages> {
  final CodeHelpers codeHelpers = new CodeHelpers();
  var customerConnections;
  var contentId = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final appTitles = ['Dashboard', 'Packages', 'Support', 'Payment', 'Enquiry'];

  toggleDrawer() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      _scaffoldKey.currentState.openEndDrawer();
    } else {
      _scaffoldKey.currentState.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(184, 27, 77, 10),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(184, 27, 77, 10),
                    backgroundBlendMode: BlendMode.darken,
                    image: DecorationImage(
                        image: AssetImage("assets/menu_bg.jpg"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartBar,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  toggleDrawer();
                  setState(() {
                    contentId = 0;
                  });
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.userCircle,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.coins,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  'Payment',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  toggleDrawer();
                  setState(() {
                    contentId = 3;
                  });
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.headset,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  'Support',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  toggleDrawer();
                  setState(() {
                    contentId = 2;
                  });
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.gift,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  'Packages',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  toggleDrawer();
                  setState(() {
                    contentId = 1;
                  });
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.questionCircle,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  'Enquiry',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  toggleDrawer();
                  setContentId(4);
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  size: 24,
                  color: Color.fromRGBO(0, 32, 97, 5),
                ),
                dense: false,
                title: Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  codeHelpers.setStorageKey('loggedIn', '0');
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(184, 27, 77, 10),
            title: Text(getAppTitle(contentId))),
        body: setContent(contentId),
      ),
    );
  }

  setContentId(lContentId) {
    setState(() {
      contentId = lContentId;
    });
  }

  String getAppTitle(_contentId) {
    return appTitles[_contentId];
  }

  setContent(_contentId) {
    var content;
    switch (_contentId) {
      case 0:
        content = Dashboard();
        break;
      case 1:
        content = Packages();
        break;
      case 2:
        content = Support();
        break;
      case 3:
        content = Payment();
        break;
      case 4:
        content = Enquiry();
        break;
    }

    return content;
  }

  getCustomerDetails() {
    var body = {
      "name": "getCustomerDetails",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    codeHelpers.httpPost(body, needAuth: true).then((customerDetails) {
      customerDetails.transform(convert.utf8.decoder).join().then((onValue) {
        Map<String, dynamic> response = convert.jsonDecode(onValue);
        print(response.toString());
      });
    });
  }
}
