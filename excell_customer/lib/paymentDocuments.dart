import 'package:ExcellCustomer/widgets/invoicesList.dart';
import 'package:ExcellCustomer/widgets/receiptsList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toggle_switch/toggle_switch.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// import 'animation/fadeIn.dart';
// import 'helpers/Utils.dart';
import 'animation/fadeIn.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class PaymentDocuments extends StatefulWidget {
  @override
  _PaymentDocumentsState createState() => _PaymentDocumentsState();
}

class _PaymentDocumentsState extends State<PaymentDocuments> {
  String showDocs = 'Invoices';
  Size displaySize;
  double textScaleFactor;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  List<dynamic> invoicesList;
  List<dynamic> recepitsList;

  bool invoicesDataLoaded = false;
  bool receiptsDataLoaded = false;

  @override
  void initState() {
    Customer.getInvoices().then((invoices) {
      setState(() {
        invoicesDataLoaded = true;
        invoicesList = invoices['result']['invoices'];
      });
    });
    Customer.getReceipts().then((receipts) {
      setState(() {
        receiptsDataLoaded = true;
        recepitsList = receipts['result']['paymentreceipts'];
        // print('receipts  ' + receipts.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0 ? 1.0 : 0.85 / MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Invoices"),
        backgroundColor: selectedTheme.appBarColor,
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: FadeIn(
                    ToggleSwitch(
                        initialLabelIndex: 1,
                        minWidth: displaySize.width * 0.25,
                        cornerRadius: 20,
                        activeBgColor: selectedTheme.primaryColor,
                        activeTextColor: Colors.white,
                        inactiveBgColor: Colors.grey[300], //gradientColors[1],
                        inactiveTextColor: Colors.black87,
                        labels: ['Invoices', 'Receipts'],
                        icons: [Icons.list, Icons.list],
                        onToggle: (index) {
                          setState(() {
                            // print(index.toString() + " is index");
                            showDocs = index == 0 ? 'Invoice' : 'receipts';
                          });

                          // print('switched to: $index');
                        }),
                    0.5,
                    translate: false),
              ),
              showDocs == 'Invoice' ? invoicesDataLoaded ? Expanded(child: InvoicesList(invoicesList)) : showLoader() : receiptsDataLoaded ? Expanded(child: ReceiptsList(recepitsList)) : showLoader(),
            ],
          )),
    );

    // Column(
    //   children: <Widget>[

    //     // Container(child: )
    //   ],
    // ));
  }

  // showInvoiceData() {
  //   return InvoicesList(invoicesList);

  //   // ListView(
  //   //   children: <Widget>[
  //   //     Padding(
  //   //       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
  //   //       child: Container(
  //   //         decoration: BoxDecoration(color: selectedTheme.activeBackground.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //   //         child: Padding(
  //   //           padding: const EdgeInsets.all(8.0),
  //   //           child: InvoicesList(invoicesList),
  //   //         ),
  //   //       ),
  //   //     ),
  //   //   ],
  //   // );
  // }

  showLoader() {
    return Center(
      child: SpinKitCircle(size: 40, color: Colors.grey),
    );
  }
}
