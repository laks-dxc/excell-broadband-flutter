import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/widgets/makePayment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'animation/fadeIn.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class TopupsList extends StatefulWidget {
  final String pkgnum;

  TopupsList(this.pkgnum);

  @override
  _TopupsListState createState() => _TopupsListState(this.pkgnum);
}

class _TopupsListState extends State<TopupsList> {
  String pkgnum;
  List<dynamic> topups;
  static Size displaySize;
  String selectedTopupName;
  String paymentstring;
  String taxAmount;
  String taxLabel;
  String basePrice;
  String totalPrice;
  double textScaleFactor;

  bool topupsLoaded = false;

  @override
  void initState() {
    Customer.topupList(this.pkgnum).then((value) {
      setState(() {
        this.topups = value;
        this.topupsLoaded = true;
        // print(this.topups.toString());
      });
    });
    super.initState();
  }

  _TopupsListState(this.pkgnum);
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0 ? 1.0 : 0.85 / MediaQuery.of(context).textScaleFactor;

    return topupsLoaded == false
        ? Container(child: Center(child: SpinKitCircle(size: 35, color: Colors.grey)))
        : Container(
            height: this.topups.length * 90.0,
            decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: ListView(
                    children: List.generate(this.topups.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        // padding: EdgeInsets.all(8.0),
                        child: InkWell(
                            child: tileItem(this.topups[index]["pkg"], Utils.showAsMoney(this.topups[index]["baseprice"].toString())),
                            onTap: () {
                              setState(() {
                                selectedTopupName = this.topups[index]["pkg"];
                                paymentstring = this.topups[index]["paymentstring"];
                                taxAmount = (double.parse(this.topups[index]["tax"]) * double.parse(this.topups[index]["baseprice"].toString()) * 0.01).toString();
                                taxLabel = "Tax (" + topups[index]["tax"] + " % )";
                                basePrice = this.topups[index]["baseprice"].toString();
                                totalPrice = this.topups[index]["price"].toString();
                              });
                            }),
                      );
                    }),
                  ),
                ),
                selectedTopupName == null ? disabledButton() : enabledButton(context)
              ],
            ),
          );
  }

  Widget tileItem(label, value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(8.0 * textScaleFactor),
          // decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
          decoration: selectedTopupName == label
              ? BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.4), borderRadius: BorderRadius.circular(15.0), border: Border.all(width: 1, color: selectedTheme.primaryGradientColors[0]))
              : BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.1), borderRadius: BorderRadius.circular(15.0), border: Border.all(width: 1, color: Colors.grey[400])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: selectedTopupName == label
                    ? BoxDecoration(
                        color: selectedTheme.activeBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.0,
                        ))
                    : BoxDecoration(
                        color: selectedTheme.activeBackground.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                width: 40.0,
                height: 40.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: selectedTopupName == label
                        ? FadeIn(
                            Icon(
                              Icons.check,
                              size: 25,
                              color: selectedTheme.primaryColor,
                            ),
                            0.2,
                            translate: false,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: TextStyle(fontSize: 22 * textScaleFactor, color: selectedTheme.primaryColor.withOpacity(0.5), fontWeight: FontWeight.w200)),
                    Text(
                      value,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 22 * textScaleFactor, color: selectedTheme.primaryColor, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget disabledButton() {
    return RaisedButton(
      textColor: Colors.white,
      disabledColor: selectedTheme.disabledBackground,
      child: Container(
          height: 50,
          width: 200,
          child: Center(
              child: Text(
            "Continue",
            style: TextStyle(fontSize: 24.0),
          ))),
      onPressed: null,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }

  Widget enabledButton(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: selectedTheme.primaryGradientColors[1],
      child: Container(
          height: 50,
          width: 200,
          child: Center(
              child: Text(
            "Continue",
            style: TextStyle(fontSize: 24.0),
          ))),
      onPressed: () => showAlert(context),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            selectedTopupName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: displaySize.height * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price",
                    ),
                    Text(
                      Utils.showAsMoney(basePrice.toString()),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      taxLabel,
                    ),
                    Text(
                      Utils.showAsMoney(taxAmount.toString()),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(color: selectedTheme.appBarColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.showAsMoney(totalPrice.toString()),
                      style: TextStyle(color: selectedTheme.appBarColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 25),
                Text(
                  "Are you sure you want to continue?",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MakePayment(paymentstring, pkgnum: this.pkgnum, source: "topups"),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
