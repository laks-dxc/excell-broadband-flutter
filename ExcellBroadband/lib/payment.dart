import 'dart:math' as Math;

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'helpers/constants.dart';
import 'helpers/customerInfo.dart';
import 'helpers/fadeInX.dart';
import 'helpers/fadeInY.dart';
import 'helpers/utilities.dart';

class Payment extends StatefulWidget {
  final dynamic customerDue;

  Payment(this.customerDue);

  @override
  _PaymentState createState() => _PaymentState(customerDue);
}

class _PaymentState extends State<Payment> {
  final dynamic customerDueInfo;

  _PaymentState(this.customerDueInfo);

  double cHeight, cWidth;
  double consumptionWidth = 1000;
  final Radius containerBorderRadius = Radius.circular(15);

  String payableAmount = "";
  String dueInDaysText = "";
  String fBillDate = "";
  String fDueDate = "";

  @override
  void initState() {
    CustomerInfo.connectionsList().then((connectionsList) {
      dynamic connection =
          connectionsList["resonse"]["result"]["connections"][0];

      DateTime billDate = DateTime.parse(connection["last_bill_date"]);
      DateTime dueDate = DateTime.parse(connection["due_bill_date"]);

      setState(() {
        fBillDate = formatDate(billDate, [dd, "-", M, "-", yyyy]);
        fDueDate = formatDate(dueDate, [dd, "-", M, "-", yyyy]);
      });

      _getDueInDaysText(dueDate);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cWidth = MediaQuery.of(context).size.width;
    cHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: <Widget>[
        Align(
          alignment: Alignment(1.0, -1.07),
          child: SafeArea(
              child: Icon(
            Icons.calendar_view_day,
            size: 140,
            color: Colors.black12,
          )),
        ),
        backButton(),
        SafeArea(
          child: Align(
            alignment: Alignment(0.8, -0.97),
            child: FadeInX(
              1.0,
              Text(
                "Payments",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
              distance: 160,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            SizedBox(height: 100),
            Expanded(
              child: ListView(
                children: <Widget>[
                  paymentDetailsContainer(),
                  // SizedBox(height: 15),
                  double.parse(customerDueInfo["amount"]) != 0?payNowButton():Container(),
                ],
              ),
            )
          ]),
        ),
      ]),
    );
  }

  Widget payNowButton() {
    int hasDue = 123;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: 55,
          width: 265,
          // padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: hasDue != null ? Offset(-3.0, 0.0) : Offset(-0.0, 0.0),
                color: Colors.grey[800],
                blurRadius: hasDue != null ? 5.0 : 1.0,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.centerRight,
              colors: hasDue != null
                  ? Constants.colors['gradient_danger_colors']
                  : Constants.colors['inactive_colors'],
            ),
          ),
          child: Center(
              child: Text(
            "Pay Now",
            style: TextStyle(
                color: hasDue != null ? Colors.white70 : Colors.grey[400],
                fontWeight: FontWeight.w900,
                fontSize: 25),
          )),
        ),
      ],
    );
  }

  void _getDueInDaysText(DateTime _dueDate) {
    DateTime today = DateTime.now();

    int difference = _dueDate.difference(today).inDays;
    
    setState(() {
      if (difference < -1) {
        dueInDaysText = "Overdue by " + difference.abs().toString() + " days.";
      } else if (difference == 0) {
        dueInDaysText = "Due Today.";
      } else if (difference == -1) {
        dueInDaysText = "Overdue by a day.";
      } else if (difference == 1) {
        dueInDaysText = "Due Tomorrow.";
      } else if (difference > 1) {
        // dueInDaysText = "Due Tomorrow";
        dueInDaysText = "Due in " + difference.abs().toString() + " days.";
      }
    });
  }

  Widget backButton() {
    return Align(
      alignment: Alignment(-1.0, -0.9),
      child: FadeInX(
        2.5,
        Container(
          height: 50,
          width: 65,
          // padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(-3.0, 0.0),
                color: Colors.grey[800],
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(90),
              bottomRight: Radius.circular(90),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: Constants.colors['gradient_colors3'],
            ),
          ),
          child: FadeInX(
              2,
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.white),
              distance: 30),
        ),
        distance: -30,
      ),
    );
  }

  Widget textBoxContainer(String title, String value) {
    return Container(
      height: cHeight * 0.075,
      // width: cWidth * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, color: Colors.black38),
            ),
            FadeInY(
                1.0,
                Text(
                  value,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ))
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          containerBorderRadius,
        ),
      ),
    );
  }

  Widget textBoxContainerWithBar(String title, String value) {
    double _containrHeight = cHeight * 0.075;

    return Container(
      height: _containrHeight,
      // width: cWidth * 0.85,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(seconds: 2),
            height: _containrHeight,
            width: consumptionWidth,
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.all(
                containerBorderRadius,
              ),
            ),
            onEnd: () {
              setState(() {
                // consumedText = "Consumed 45.42 %";

                print(context.size.width.toString());
              });
              //  ;
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          containerBorderRadius,
        ),
      ),
    );
  }

  Widget paymentDetailsContainer() {
    final double containerHeightFactor = cHeight * 0.1015;

    List<Widget> planDataContainerWidgets = [
      textBoxContainer("Bill Date", fBillDate),
      textBoxContainer("Due Date", fDueDate),
      textBoxContainer("Amount", payableAmount),
    ];

    if (double.parse(customerDueInfo["amount"]) != 0) {
      planDataContainerWidgets
          .add(textBoxContainerWithBar(dueInDaysText, fBillDate));
    }

    setState(() {
      payableAmount = "Rs." +
          " " +
          double.parse(customerDueInfo["amount"]).toStringAsFixed(2);
    });

    return Container(
      height: containerHeightFactor * planDataContainerWidgets.length,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: planDataContainerWidgets,
      ),
    );
  }



}
