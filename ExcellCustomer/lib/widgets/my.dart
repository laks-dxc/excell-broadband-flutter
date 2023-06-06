import 'package:flutter/material.dart';

class MyNewPage extends StatefulWidget {
  @override
  _MyNewPageState createState() => _MyNewPageState();
}

class _MyNewPageState extends State<MyNewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My New Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to my new page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
