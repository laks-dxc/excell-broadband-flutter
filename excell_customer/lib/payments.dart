import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'helpers/Utils.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  Size displaySize;
  dynamic paymentDetail;
  String amountDue = "";
  String pgMsg = "";
  bool dataLoaded = false;
  String billDueInDaysString = "";

  List<dynamic> connections;

  @override
  void initState() {
    Customer.connectionsList().then((_connections) {
      setState(() {
        connections = _connections;

        if (connections.length > 0) {
          setState(() {
            paymentDetail = connections[0];
          });

          Customer.paymentDue().then((_amountDueResponse) {
            print(_amountDueResponse.toString());
            if (_amountDueResponse != null) {
              setState(() {
                amountDue = _amountDueResponse["amount"];
                pgMsg = _amountDueResponse["msg"];

                if (double.parse(amountDue) > 0) {
                  billDueInDaysString = Utils.getDueInDaysText(paymentDetail["due_bill_date"]);
                }

                dataLoaded = true;
              });
            }
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: dataLoaded ? showData() : showLoader(),
    );
  }

  showData() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ListView(children: [
        Container(
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                tileItem("Bill Date", Utils.formatDateString(paymentDetail["last_bill_date"])),
                tileItem("Due in ", Utils.formatDateString(paymentDetail["due_bill_date"])),
                tileItem("Amount", Utils.showAsMoney(amountDue)),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        double.parse(amountDue) > 0
            ? Container(
                decoration: BoxDecoration(
                    color: selectedTheme.activeBackground.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      centerTextTile(billDueInDaysString),
                    ],
                  ),
                ),
              )
            : SizedBox(height: 0),
        SizedBox(
          height: 30,
        ),

        Padding(
            padding: EdgeInsets.only(left:100,right:100), child: paymentButton(double.parse(amountDue) > 0)),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Widget tileItem(label, value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              color: selectedTheme.enabledBackground, borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label,
                  style: TextStyle(
                      fontSize: 22,
                      color: selectedTheme.primaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w200)),
              Text(
                value,
                style: TextStyle(
                    fontSize: 22, color: selectedTheme.primaryColor, fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }

  Widget paymentButton(bool enabled) {
    return !enabled
        ? RaisedButton(
            textColor: Colors.white,
            disabledColor: selectedTheme.disabledBackground,
            child: Container(
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 18.0),
                ))),
            onPressed: null,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          )
        : RaisedButton(
            textColor: Colors.white,
            color: selectedTheme.primaryGradientColors[1],
            child: Container(
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 24.0),
                ))),
            onPressed: () {},
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          );
  }

  Widget centerTextTile(value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    fontSize: 22, color: selectedTheme.primaryColor, fontWeight: FontWeight.w600)),
          )),
    );
  }

  showLoader() {
    return Center(
      child: SpinKitCircle(size: 40, color: Colors.grey),
    );
  }
}
