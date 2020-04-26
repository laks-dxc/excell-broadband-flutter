import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/CustomerPages.dart';
import 'package:ExcellCustomer/pages/Enquiry.dart';
import 'package:ExcellCustomer/pages/Login.dart';
import 'package:ExcellCustomer/pages/Packages.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ConnectionsCarousel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  
  int _selectedIndex = 0;
  CodeHelpers codeHelpers = new CodeHelpers();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    // BasicDemo(),
    ConnectionsCarousel(),
    Packages(),
    EnquiryForm(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
      },
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Builder(
              builder: (context) => Center(
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.signInAlt),
                  onPressed: () {
                    // print("codeHelpers.getStorageKey('loggedIn')" + " " + codeHelpers.getStorageKey('loggedIn').toString());
                    var loggedInKey = codeHelpers.getStorageKey('loggedIn');
                    if (loggedInKey == null || loggedInKey == '0')
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    else
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerPages()));
                  },
                ),
              ),
            ),
          ],
          backgroundColor: Color.fromRGBO(184, 27, 77, 10),
          title: Text('Excell Broadband'),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              title: Text('Packages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              title: Text('Enquiry'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:
              Color.fromRGBO(184, 27, 77, 10), //Colors.amber[800],
          onTap: _onItemTapped,
        ),
        backgroundColor: Color.fromRGBO(184, 27, 77, 10),
      ),
    );
  }
}
