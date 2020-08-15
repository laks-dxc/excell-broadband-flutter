import 'package:ExcellCustomer/widgets/makePayment.dart';
import 'package:flutter/material.dart';

import 'models/customer.dart';

class TopupsList extends StatefulWidget {
  final String pkgnum;

  TopupsList(this.pkgnum);

  @override
  _TopupsListState createState() => _TopupsListState(this.pkgnum);
}

class _TopupsListState extends State<TopupsList> {
  String pkgnum;
  List<dynamic> topups;
  bool topupsLoaded = false;

  @override
  void initState() {
    Customer.topupList(this.pkgnum).then((value) {
      setState(() {
        this.topups = value;
        this.topupsLoaded = true;
      });
    });
    super.initState();
  }

  _TopupsListState(this.pkgnum);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Topup"),
        ),
        body: topupsLoaded == false
            ? Container(child: Text("Loading.."))
            : Container(
                child: ListView(
                  children: List.generate(this.topups.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
                      child: RaisedButton(
                          child: Text(this.topups[index]["pkg"] + " - Rs. " + this.topups[index]["price"].toString()),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MakePayment(this.topups[index]["paymentstring"])));
                          }),
                    );
                  }),
                ),
              ));
  }
}
