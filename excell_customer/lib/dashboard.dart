import 'package:flutter/material.dart';

import 'animation/fadeIn.dart';
import 'helpers/storageUtils.dart';
import 'models/enum.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String customerName = "";
  Size displaySize;

  @override
  void initState() {
    StorageUtils.getStorageItem(StorageKey.CutomerName).then((_customerName)  {
          setState(() {
            customerName = _customerName;
          });
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        FadeIn(
          Text(
            "Welcome,",
            style: Theme.of(context).textTheme.headline5,
          ),
          0.5,
          direction: Direction.y,
          distance: 10.0,
        ),
        FadeIn(
          Text(
            customerName,
            style: Theme.of(context).textTheme.headline4,
          ),
          0.7,
          direction: Direction.y,
          distance: -10.0,
        ),
        SizedBox(height: 20),
        FadeIn(Image.asset("assets/slide1.png"), 1.2, translate: false),
        SizedBox(height: 20),
        FadeIn(
          Card(
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.teal,
                    width: displaySize.width,
                    height: displaySize.height * 0.2,
                    child: Text("Hello Buddy"),
                  ),
                ],
              ),
            ),
          ),
          2.0,
          translate: false,
        ),
      ],
    );
  }
}
