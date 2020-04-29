import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/pages/CustomerPages.dart';
import 'package:ExcellCustomer/pages/Home.dart';
// import 'package:ExcellCustomer/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'pages/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var text = 'Clicked';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final CodeHelpers codeHelpers = new CodeHelpers();

  //  _firebaseMessaging.

  // _firebaseMessaging.getToken().then((String token) {
  //     assert(token != null);
  //     setState(() {
  //       _homeScreenText = "Push Messaging token: $token";
  //     });
  //     print(_homeScreenText);
  //   });

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Future _showNotificationWithSound() async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       // sound: 'slow_spring_board',
  //       importance: Importance.Max,
  //       priority: Priority.High);
  //   var iOSPlatformChannelSpecifics =
  //       new IOSNotificationDetails(sound: "slow_spring_board.aiff");
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'New Post',
  //     'How to Show Notification in Flutter',
  //     platformChannelSpecifics,
  //     payload: 'Custom_Sound',
  //   );
  // }

  @override
  void initState() {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage news: $message");
      // await CustomerPages();
    });

    _firebaseMessaging.getToken().then((token) {
      print('Token ' + token);

      // codeHelpers.setStorageKey('FCM_Token', token);
    });

    super.initState();
  }

  // Future<void> _showNotification() async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'plain title', 'plain body', platformChannelSpecifics,
  //       payload: 'item x');
  // }

//  Future<void> onSelectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//     }
//  }

  // Future onSelectNotification(String payload) async {
  //   showDialog(
  //     context: context,
  //     builder: (_) {
  //       return new AlertDialog(
  //         title: Text("PayLoad"),
  //         content: Text("Payload : $payload"),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    //       'your channel id', 'your channel name', 'your channel description',
    //       importance: Importance.Max, priority: Priority.High);

    //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    //   var platformChannelSpecifics = new NotificationDetails(
    //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    //   await flutterLocalNotificationsPlugin.show(
    //     0,
    //     'New Post',
    //     'How to Show Notification in Flutter',
    //     platformChannelSpecifics,
    //     payload: 'Default_Sound',
    //   );
    // }

    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/login': (BuildContext context) => Login(),
          '/customerPages': (BuildContext context) => new CustomerPages(),
        },
        home: Home());
  }
}
