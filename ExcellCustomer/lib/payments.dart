import 'package:ExcellCustomer/widgets/makePayment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'helpers/Utils.dart';
import 'helpers/appStyles.dart';
import 'paymentDocuments.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  Size? displaySize;
  dynamic paymentDetail;
  String amountDue = "";
  String pgMsg = "";
  bool dataLoaded = false;
  String billDueInDaysString = "";

  List<dynamic>? connections;

  @override
  void initState() {
    //ignore: missing_return
    SystemChannels.lifecycle.setMessageHandler((msg) {
      // debugPrint('SystemChannels> $msg');

      if (msg == AppLifecycleState.resumed.toString()) {
        // print("in resumed of payments");
        setState(() {
          dataLoaded = false;
        });
        customerPayments();
      } else {
        throw Exception("In Else");
      }

      return new Future<String>.value("");
    });
    super.initState();
  }

  void customerPayments() {
    Customer.connectionsList()?.then((_connections) {
      setState(() {
        connections = _connections;

        if (connections!.length >= 1) {
          paymentDetail = connections?[0];
          Customer.paymentDue().then((_amountDueResponse) {
            if (_amountDueResponse != null) {
              amountDue = _amountDueResponse["amount"];
              pgMsg = _amountDueResponse["msg"];

              if (double.parse(amountDue) > 0) {
                billDueInDaysString =
                    Utils.getDueInDaysText(paymentDetail["due_bill_date"]);
              }
            }
            setState(() {
              dataLoaded = true;
            });
          });
        } else {
          Customer.paymentDue().then((_amountDueResponse) {
            print(_amountDueResponse.toString());
            if (_amountDueResponse != null) {
              setState(() {
                amountDue = _amountDueResponse["amount"];
                pgMsg = _amountDueResponse["msg"];
                dataLoaded = true;
              });
            }
          });
        }
      });
    });
  }

  double? textScaleFactor;
  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;

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
                paymentDetail == null
                    ? tileItem("Bill Date", "")
                    : tileItem(
                        "Bill Date",
                        Utils.formatDateString(
                            paymentDetail["last_bill_date"])),
                paymentDetail == null
                    ? tileItem("Due Date ", "")
                    : tileItem("Due Date ",
                        Utils.formatDateString(paymentDetail["due_bill_date"])),
                tileItem("Amount", Utils.showAsMoney(amountDue)),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                paymentDetail == null
                    ? tileItem("Next Bill Date ", "")
                    : tileItem(
                        "Next Bill Date ",
                        Utils.formatDateString(
                            paymentDetail["next_bill_date"])),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        double.parse(amountDue) > 0 && paymentDetail != null
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
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              paymentButton(double.parse(amountDue) > 0),
              invoiceButton()
            ],
          ),
          // Center(child:
          // )
        ),
      ]),
    );
  }

  Widget tileItem(label, value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(16.0 * textScaleFactor!),
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label,
                  style: TextStyle(
                      fontSize: 22 * textScaleFactor!,
                      color: selectedTheme.primaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w200)),
              Text(
                value,
                style: TextStyle(
                    fontSize: 22 * textScaleFactor!,
                    color: selectedTheme.primaryColor,
                    fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }

  Widget paymentButton(bool enabled) {
    return !enabled
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledBackgroundColor: selectedTheme.disabledBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                )
                // backgroundColor: selectedTheme.primaryColor,
                ),
            // textColor: Colors.white,
            // disabledColor: selectedTheme.disabledBackground,
            child: Container(
                height: 50,
                width: displaySize!.width * 0.3,
                child: Center(
                    child: Text(
                  "Pay Now",
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: 22.0 * textScaleFactor!),
                ))),
            onPressed: () {},
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: selectedTheme.primaryGradientColors![1],
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                )),
            child: Container(
                height: 50,
                width: displaySize!.width * 0.3,
                child: Center(
                    child: Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 22.0 * textScaleFactor!),
                ))),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MakePayment(pgMsg)));
            },
          );
  }

  Widget invoiceButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: selectedTheme.primaryGradientColors![1],
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          )),
      child: Container(
          height: 50,
          width: displaySize!.width * 0.3,
          child: Center(
              child: Text(
            "Invoices",
            style: TextStyle(fontSize: 22.0 * textScaleFactor!),
          ))),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PaymentDocuments()));
      },
    );
  }

  Widget centerTextTile(value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    fontSize: 22 * textScaleFactor!,
                    color: selectedTheme.primaryColor,
                    fontWeight: FontWeight.w600)),
          )),
    );
  }

  showLoader() {
    return Center(
      child: SpinKitCircle(size: 40, color: Colors.grey),
    );
  }
}
