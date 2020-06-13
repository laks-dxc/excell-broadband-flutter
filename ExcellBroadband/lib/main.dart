import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    // SystemChrome.setSystemUIOverlayStyle(SystemOverlayStyle(statusbar))
    return MaterialApp(
      // color: Colors.black12,
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'AlegreyaSans'),
      home: Scaffold(
          // backgroundColor: Colors.transparent,
          body: SafeArea(
        child: Home(),
      )),
    );
  }
}
