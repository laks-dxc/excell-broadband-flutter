import 'dart:js_interop';

import 'package:ExcellCustomer/animation/fadeIn.dart';
import 'package:ExcellCustomer/helpers/Utils.dart';
import 'package:ExcellCustomer/helpers/appStyles.dart';
import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/customer.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceiptsList extends StatelessWidget {
  final List<dynamic> receiptsList;

  ReceiptsList(this.receiptsList);

  static Size? displaySize;
  static double? textScaleFactor;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;

    return Container(
      decoration: BoxDecoration(
          color: selectedTheme.activeBackground.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: ListView(
        children: List.generate(receiptsList.length, (index) {
          return FadeIn(
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => Scaffold(
                //       backgroundColor: selectedTheme.scaffoldBgColor,
                //       appBar: AppBar(title: Text(receiptsList[index]["pkgname"]), backgroundColor: selectedTheme.appBarColor //(0xff112c75),
                //           ),
                //       body: ConnectionDetail(
                //         receiptsList[index],
                //       ),
                //     ),
                //   ),
                // );
              },
              child: receiptItem(receiptsList[index], context),
            ),
            0.5,
            direction: Direction.y,
            distance: -15.0,
          );
        }),
      ),
    );
  }

  receiptItem(receiptListItem, context) {
    print("receiptListItem " + receiptListItem.toString());
    return Container(
      width: displaySize?.width,
      padding: EdgeInsets.all(8.0 * textScaleFactor!),
      child: Container(
          decoration: BoxDecoration(
              color: selectedTheme.activeBackground.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Padding(
              padding: EdgeInsets.all(16.0 * textScaleFactor!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          Utils.formatDateTimeString(
                              receiptListItem["paymentdate"]),
                          style: TextStyle(
                              color:
                                  selectedTheme.primaryColor.withOpacity(0.8),
                              fontSize: 20 * textScaleFactor!)),
                      Text(Utils.showAsMoney(receiptListItem["amount"]),
                          style: TextStyle(
                              color: selectedTheme.primaryColor,
                              fontSize: 21 * textScaleFactor!,
                              fontWeight: FontWeight.w600)),
                      InkWell(
                          onTap: () async {
                            var status = await Permission.storage.status;
                            if (status.isGranted) {
                              Dialog notEligibleDialog = Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0)), //this right here
                                child: Container(
                                  color: Colors.transparent,
                                  height: 50.0,
                                  width: 50.0,
                                  child: Center(
                                    child: SpinKitCircle(
                                        color: Colors.black, size: 35),
                                  ),
                                ),
                              );

                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      notEligibleDialog);

                              //
                              await Customer.getReceipt(
                                      receiptListItem["payreceiptno"]
                                          .toString())
                                  .then((filePath) async {
                                Navigator.pop(context);
                                await OpenFile.open(filePath);
                              });
                            } else {
                              if (status.isUndefinedOrNull || status.isDenied) {
                                await Permission.storage
                                    .request()
                                    .then((value) {
                                  if (value.isGranted) {}
                                });
                              }
                            }
                          },
                          child: Icon(
                            Icons.file_download,
                            color: Colors.black45,
                          ))
                    ],
                  ),
                  SizedBox(height: 10),
                  receiptListItem["paymentinfo"] == null
                      ? Text("Payment By: " + receiptListItem["paymentby"],
                          style: TextStyle(
                              color:
                                  selectedTheme.primaryColor.withOpacity(0.5),
                              fontSize: 15 * textScaleFactor!))
                      : Text("Reference No: " + receiptListItem["paymentinfo"],
                          style: TextStyle(
                              color:
                                  selectedTheme.primaryColor.withOpacity(0.5),
                              fontSize: 15 * textScaleFactor!)),
                ],
              ))),
    );
  }
}
