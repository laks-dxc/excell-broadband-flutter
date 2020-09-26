import 'dart:io';

import 'package:ExcellCustomer/enquiry.dart';
import 'package:ExcellCustomer/packageList.dart';
import 'package:ExcellCustomer/widgets/quickPayModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'animation/fadeIn.dart';
import 'drawer.dart';
import 'helpers/appStyles.dart';
import 'helpers/storageUtils.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';
import 'widgets/loginModal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Size displaySize;
  double textScaleFactor;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iosPermission();

    _firebaseMessaging.getToken().then((token) {
      StorageUtils.setStorageItem(StorageKey.FBToken, token);
      print('FBToken ' + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    super.initState();
    // firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = (1 / MediaQuery.of(context).textScaleFactor);

    return Scaffold(
      backgroundColor: selectedTheme.scaffoldBgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          FadeIn(
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/blue_bg_full.png',
                // height: displaySize.height * 0.5,
                // width: displaySize.width,
              ),
            ),
            0.5,
            direction: Direction.y,
            distance: -10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: displaySize.height * 0.37),
                  // SizedBox(height: displaySize.height * 0.23),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: displaySize.height * 0.1322),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FadeIn(
                                GestureDetector(
                                  onTap: () async {
                                    bool isCustomerLoggedIn = await Customer.isLoggedIn();
                                    isCustomerLoggedIn ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawerPage())) : showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => LoginModal());
                                  },
                                  child: _homeTile(Image.asset('assets/11.png'), "Account"),
                                ),
                                1.0,
                                direction: Direction.x,
                                distance: -30),
                            FadeIn(
                                GestureDetector(
                                    onTap: () {
                                      showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => QuickPayModal());
                                    },
                                    child: _homeTile(Image.asset('assets/22.png'), "Quick Pay")),
                                1.0,
                                direction: Direction.x,
                                distance: 30),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FadeIn(
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PackageList()));
                                    },
                                    child: _homeTile(Image.asset('assets/33.png'), "Packages")),
                                1.0,
                                direction: Direction.x,
                                distance: -30),
                            FadeIn(
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Enquiry()));
                                    },
                                    child: _homeTile(Image.asset('assets/44.png'), "Enquiry")),
                                1.0,
                                direction: Direction.x,
                                distance: 30),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _homeTile(
    Widget image,
    String title,
  ) {
    double imageDimension = displaySize.width * 0.25;
    return Column(
      children: <Widget>[
        Container(
          width: imageDimension, // 120.0,
          height: imageDimension,
          child: image,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20 * textScaleFactor),
        )
      ],
    );
  }
}
