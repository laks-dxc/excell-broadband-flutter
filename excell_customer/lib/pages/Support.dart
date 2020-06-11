import 'dart:convert' as convert;

import 'package:ExcellCustomer/models/Tikcet.dart';
import 'package:ExcellCustomer/pages/NewTicket.dart';
import 'package:ExcellCustomer/popup/popup.dart';
import 'package:ExcellCustomer/popup/popup_content.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import '../CodeHelpers.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  // getCustomerTickets();

  @override
  void initState() {
    getCustomerTickets();
    super.initState();
  }

  CodeHelpers codeHelpers = new CodeHelpers();
  List<Ticket> ticketsList = new List<Ticket>();
  List<Ticket> sTiketsList = [];
  getCustomerTickets() {
    var body = {
      "name": "getCustTickets",
      "param": {"customerId": codeHelpers.getStorageKey('custId')}
    };

    codeHelpers.httpPost(body, needAuth: true).then((lTickets) {
      lTickets.transform(convert.utf8.decoder).join().then((ticketsRaw) {
        final lTiketsList = convert.jsonDecode(ticketsRaw);

        print('lTiketsList ' + lTiketsList.toString());

        lTiketsList["resonse"]["result"]["tickets"].forEach((ticket) {
          ticketsList.add(Ticket(
              tickettype: ticket["tickettype"],
              problem: ticket["problem"],
              status: ticket["status"],
              created: ticket["created"]));
          // print(index);
        });
      });

      setState(() {
        sTiketsList = ticketsList;
        print('sTiketsList.length ' + sTiketsList.length.toString());
      });
    });
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 230,
        left: 30,
        right: 30,
        bottom: 500,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(184, 27, 77, 10),
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                height: 3.0,
                color: Colors.white54,
              ),
              itemCount: sTiketsList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return WidgetAnimator(
                  ListTile(
                    contentPadding: EdgeInsets.all(5.0),
                    dense: true,
                    leading: sTiketsList[index].status == 'closed'
                        ? Icon(
                            Icons.error,
                            size: 30,
                            color: Color.fromRGBO(0, 32, 97, 5),
                          )
                        : Icon(
                            Icons.error,
                            size: 30,
                            color: Color.fromRGBO(0, 32, 97, 5),
                          ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 15),
                        Text(
                          sTiketsList[index].problem,
                          style: TextStyle(fontSize: 22, color: Colors.blue),
                        ),//
                      ],
                    ),
                    subtitle: Text(
                      sTiketsList[index]
                          .tickettype, // + " - " + sTiketsList[index].id,
                      style: TextStyle(fontSize: 14, color: Colors.white60),
                    ),
                    trailing: Text(
                      formatDate(DateTime.parse(sTiketsList[index].created),
                          [dd, '-', M, '-', yyyy]),
                      style: TextStyle(
                          color: Color.fromRGBO(0, 32, 97, 5), fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
          FloatingActionButton(
              child: Icon(Icons.add, size: 40),
              elevation: 10.0,
              backgroundColor: Color.fromRGBO(0, 32, 97, 5),
              onPressed: () {
                showPopup(context, newTicketScreen(), 'Create New Ticket');
              })
        ],
      ),
    );
  }

  Widget newTicketScreen() {
    return NewTicket();
  }
}
