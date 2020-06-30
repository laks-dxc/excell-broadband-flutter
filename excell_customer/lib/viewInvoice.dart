// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/enum.dart';
import 'models/customer.dart';

class ViewInvoice extends StatefulWidget {
  final String invoceNo;

  ViewInvoice(this.invoceNo);

  @override
  _ViewInvoiceState createState() => _ViewInvoiceState(invoceNo);
}

class _ViewInvoiceState extends State<ViewInvoice> {
  final String invoiceNo;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  _ViewInvoiceState(this.invoiceNo);
  String pdfDataBytes;
  @override
  void initState() {
    super.initState();
    Customer.invoice(invoiceNo).then((pdfBase64) {
      setState(() {
        pdfDataBytes = pdfBase64.toString();
      });

      // String decodedFile = utf8.decode(base64.decode(pdfBase64));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: selectedTheme.appBarColor,
          title: Text("Invoice No. " + invoiceNo),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: pdfDataBytes != null
              ? Container(
                  child: Text(""),
                )
              : SpinKitCircle(size: 30, color: Colors.grey),
        ));
  }
}
