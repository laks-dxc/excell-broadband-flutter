import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData lightTheme = ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity, fontFamily: 'Lato');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(debugShowCheckedModeBanner: false, theme: lightTheme, home: Home());
  }
}
