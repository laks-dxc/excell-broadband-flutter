// import 'dart:io';

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

class InvoicesList extends StatefulWidget {
  final List<dynamic> invoicesList;

  InvoicesList(this.invoicesList);

  static Size? displaySize;
  static double? textScaleFactor;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  @override
  _InvoicesListState createState() => _InvoicesListState();
}

class _InvoicesListState extends State<InvoicesList> {
  String activeContainerText = "Click below to download the invoice";

  String readyToDownloadContainerText = "Click below to download the invoice";

  String downloadingContainerText = 'Downloading... Please Wait..!';

  String downloadCompleteContainerText = 'Click below to open';

  List<Widget>? activefooterText; // = Icon(Icons.file_download);
  Widget? thisActiveFooter;

  Widget downloadingFooter = SpinKitCircle(
    size: 25,
    color: Colors.black45,
  );

  Widget openInvoiceFooterText = Text("Open Invoice");
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  bool fileDownloading = false;

  @override
  Widget build(BuildContext context) {
    InvoicesList.displaySize = MediaQuery.of(context).size;
    InvoicesList.textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;

    return Container(
      decoration: BoxDecoration(
          color: selectedTheme.activeBackground.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: ListView(
        children: List.generate(widget.invoicesList.length, (index) {
          return FadeIn(
            Container(
              // decoration: BoxDecoration(color: selectedTheme.activeBackground, borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
              child: invoiceItem(widget.invoicesList[index]),
            ),
            0.5,
            direction: Direction.y,
            distance: -15.0,
          );
        }),
      ),
    );
  }

  invoiceItem(invoiceListItem) {
    // print("invoiceListItem " + invoiceListItem.toString());
    return Container(
      width: InvoicesList.displaySize?.width,
      // padding: EdgeInsets.all(8.0 * InvoicesList.textScaleFactor),
      decoration: BoxDecoration(
          color: selectedTheme.activeBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15)),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Padding(
              padding: EdgeInsets.all(16.0 * InvoicesList.textScaleFactor!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          Utils.formatDateTimeString(
                              invoiceListItem["invoicedate"].toString()),
                          style: TextStyle(
                              color: InvoicesList.selectedTheme.primaryColor
                                  .withOpacity(0.8),
                              fontSize: 20 * InvoicesList.textScaleFactor!)),
                      Text(
                          Utils.showAsMoney(
                              invoiceListItem["invoiceamount"].toString()),
                          style: TextStyle(
                              color: InvoicesList.selectedTheme.primaryColor,
                              fontSize: 21 * InvoicesList.textScaleFactor!,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          "Reference No: " +
                              invoiceListItem["invoiceno"].toString(),
                          style: TextStyle(
                              color: InvoicesList.selectedTheme.primaryColor
                                  .withOpacity(0.5),
                              fontSize: 15 * InvoicesList.textScaleFactor!)),
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
                              await Customer.getInvoice(
                                      invoiceListItem["invoiceno"].toString())
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
                ],
              ))),
    );
  }
}
