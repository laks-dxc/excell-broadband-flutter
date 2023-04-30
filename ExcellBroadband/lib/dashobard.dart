// import 'dart:math';

import 'package:ExcellBroadband/helpers/fadeInY.dart';
import 'package:ExcellBroadband/helpers/utilities.dart';
import 'package:ExcellBroadband/packageDetail.dart';
import 'package:ExcellBroadband/packageList.dart';
import 'package:ExcellBroadband/payment.dart';
// import 'package:ExcellBroadband/packageList.dart';
import 'package:ExcellBroadband/profiles.dart';
import 'package:ExcellBroadband/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'helpers/constants.dart';
import 'helpers/customerInfo.dart';
import 'helpers/fadeInX.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double cWidth, cHeight;

  final supportImageWidget = Image.asset(
    'assets/support.png',
    width: 90,
    height: 90,
    color: Color.fromRGBO(0, 0, 0, 0.2),
  );
  final Widget rupeeImageWidget = Image.asset(
    'assets/rupee.png',
    width: 75,
    height: 75,
    color: Color.fromRGBO(0, 0, 0, 0.2),
  );

  final Widget lineChartIconWidget =
      Icon(Icons.show_chart, size: 100, color: Color.fromRGBO(0, 0, 0, 0.2));

  bool showSupportSpinner = false;
  bool showPackageSpinner = false;
  bool showPaymentsSpinner = false;

  @override
  Widget build(BuildContext context) {
    cWidth = MediaQuery.of(context).size.width;
    cHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/login_bg.png",
            fit: BoxFit.fill,
          ),
          welcomeHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 90),
                FadeInY(3.0, Image.asset('assets/slide1.png'), distance: -10.0),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FadeInX(
                      3.5,
                      dashboardTile(
                          paymentsTileOnTapped, rupeeImageWidget, "Payments",
                          showSpinner: showPaymentsSpinner),
                      distance: -10.0,
                    ),
                    FadeInX(
                      3.5,
                      dashboardTile(
                          packagesTileOnTapped, lineChartIconWidget, "Packages",
                          showSpinner: showPackageSpinner),
                      distance: 10.0,
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FadeInY(
                      3.5,
                      dashboardTile(
                          supportTileOnTapped, supportImageWidget, "Support",
                          showSpinner: showSupportSpinner),
                      distance: 10.0,
                    ),
                    Container(
                      width: cWidth * 0.45,
                      height: cWidth * 0.55,
                    )
                  ],
                )
              ],
            ),
          ),
          FadeInX(
            4.0,
            myAccountButton(),
            duration: 2.0,
          ),
        ],
      ),
    );
  }

  supportTileOnTapped() {
    setState(() {
      showSupportSpinner = true;
    });

    CustomerInfo.supportTickets().then((supportTikcetsListResponse) {
      if (Utilities.getStatus(supportTikcetsListResponse) == 200) {
        List<dynamic> supportTikcetsList =
            supportTikcetsListResponse['resonse']['result']['tickets'];
        setState(() {
          showSupportSpinner = false;
        });

        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
                child: Support(supportTikcetsList)));
      } else {}
    });
  }

  paymentsTileOnTapped() {
    setState(() {
      showPaymentsSpinner = true;
    });
    CustomerInfo.getCustomerDue().then((getCustomerDueResponse) {


      // if (Utilities.getStatus(getCustomerDueResponse) == 200) {
        dynamic customerDue = getCustomerDueResponse;

        setState(() {
          showPaymentsSpinner = false;
        });

        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 500),
            child: Payment(customerDue)));

        // print("connectionsList " + connectionsList.toString());
      // }
      // else {
      //   print(getCustomerDueResponse.toString());
      // }
      // print("connectionsList " + connectionsListResponse.toString());
    });
  }

  packagesTileOnTapped() {
    setState(() {
      showPackageSpinner = true;
    });
    CustomerInfo.connectionsList().then((connectionsListResponse) {
      if (Utilities.getStatus(connectionsListResponse) == 200) {
        List<dynamic> connectionsList =
            connectionsListResponse['resonse']['result']['connections'];

        // print("connectionsList length  " + connectionsList.length.toString());

        setState(() {
          showPackageSpinner = false;
        });

        if (connectionsList.length > 1)
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: PackageList(connectionsList)));
        else if (connectionsList.length == 1)
          Navigator.of(context).push(PageTransition(
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 500),
              child: PackageDetail(connectionsList[0])));

        // print("connectionsList " + connectionsList.toString());
      }
      // print("connectionsList " + connectionsListResponse.toString());
    });
  }

  Widget dashboardTile(onTapFn, Widget backgroundWidget, String title,
      {bool showSpinner: false}) {
    List<Alignment> alignmentArray = [
      Alignment.bottomCenter,
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Alignment.center,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.topCenter,
      Alignment.topLeft,
      Alignment.topRight
    ];
    // var rng = new Random();

    // final alinmentIndexArray = [
    //   [6, 4],
    //   [3, 2],
    //   [1, 6],
    //   [0, 7],
    //   [5, 6],
    //   [2, 7]
    // ];

    // int rndIndex = rng.nextInt(6);
    // int firstNo = alinmentIndexArray[rndIndex][0];
    // int secondNo = alinmentIndexArray[rndIndex][1];

    int firstNo = 0;
    int secondNo = 7;

    // print("rands: " + firstNo.toString() + " " + secondNo.toString());
    // print("tileHeight  " + (cWidth * 0.55).toString());
    return InkWell(
      onTap: () {
        onTapFn();
      },
      child: Container(
        width: cWidth * 0.45,
        height: cWidth * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(2.5, 2.5),
              color: Colors.grey[800],
              blurRadius: 5.0,
              // blurStyle: BlurStyle.outer
            )
          ],
          gradient: LinearGradient(
            begin: alignmentArray[firstNo],
            end: alignmentArray[secondNo],
            // stops: [0.5, 1],

            colors: Constants.colors['gradient_colors3'],
          ),
        ),
        child: Stack(
          children: [
            Align(alignment: Alignment(-0.75, -0.65), child: backgroundWidget),
            Align(
              alignment: Alignment(0.55, 0.75),
              child: Text(
                title, //"Payments",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 24),
              ),
            ),
            showSpinner
                ? Positioned(
                    top: 15.0,
                    left: 160.0,
                    // alignment: Alignment(0.95, -0.95),
                    child: SpinKitFadingCircle(
                      size: 25.0,
                      color: Colors.black54,
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  Widget myAccountButton() {
    return Align(
      alignment: Alignment(1.0, -0.9),
      child: Container(
        height: 50,
        width: 65,
        padding: EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(-3.0, 0.0),
              color: Colors.grey[800],
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(90),
            bottomLeft: Radius.circular(90),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: Constants.colors['gradient_colors3'],
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
                child: Profile()));
          },
          child: Icon(
            Icons.account_circle,
            size: 35,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget welcomeHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInY(
              1.0,
              Text(
                "Welcome",
                style: TextStyle(color: Colors.black45, fontSize: 24),
              ),
              distance: -15.0,
              translate: true,
            ),
            FadeInY(
              2.0,
              Text(
                Utilities.getStorageItem('cutomerName'),
                style: TextStyle(color: Colors.black87, fontSize: 32),
              ),
              distance: 15.0,
              translate: true,
            )
          ],
        ),
      ),
    );
  }
}
