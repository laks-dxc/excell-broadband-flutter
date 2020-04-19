import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/Dashboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerPages extends StatefulWidget {
  @override
  _CustomerPagesState createState() => _CustomerPagesState();
}

class _CustomerPagesState extends State<CustomerPages> {
  final CodeHelpers codeHelpers = new CodeHelpers();
  var customerConnections;
  var contentId = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  'Dasbhoard',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...

                  // Navigator.pop(context); // close the drawer
                  // setContentId(1);
                  Dashboard();
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
                  // Update the state of the app.
                  // ...
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
                  // Update the state of the app.
                  // ...
                  // Navigator.pop(context);
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
                  // Update the state of the app.
                  // ...
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
                  'FAQs',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(184, 27, 77, 10),
                  ),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
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
                  setContentId(2);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(184, 27, 77, 10),
            title: Text("Connections")),
        body: Dashboard(),
      ),
    );
  }

  setContentId(lContentId) {
    setState(() {
      contentId = lContentId;
    });
  }

  setContent(int pageId) async {
    var content;
   

    switch (pageId) {
      case 1:
        content = Dashboard();
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
