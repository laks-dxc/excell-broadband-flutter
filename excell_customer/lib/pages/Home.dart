import 'package:ExcellCustomer/pages/Login.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ConnectionsCarousel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    // BasicDemo(),
    ConnectionsCarousel(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Packages',
      style: optionStyle,
    ),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
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
              icon: Icon(Icons.question_answer),
              title: Text('FAQ'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        backgroundColor: Color.fromRGBO(184, 27, 77, 10),
      ),
    );
  }
}
