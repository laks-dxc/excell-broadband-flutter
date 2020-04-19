import 'package:ExcellCustomer/pages/Home.dart';
// import 'package:ExcellCustomer/pages/Login.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var text = 'Clicked';

  @override
  Widget build(BuildContext context) {
     return Home();

     //MaterialApp(
    //   home: Scaffold(
    //     // appBar: AppBar(
    //     //   backgroundColor: Color.fromRGBO(184, 27, 77, 10),
    //     //   title: Center(
    //     //     child: Text('Excell Broadband - Login'),
    //     //   ),
    //     // ),
    //     body: Login(),
    //     // Text('This is my default text'),
    //     backgroundColor: Color.fromRGBO(184, 27, 77, 10),
    //   ),
    // );
  }
}
