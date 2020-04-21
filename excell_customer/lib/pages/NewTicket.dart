import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/models/IssueTypes.dart';
import 'package:flutter/material.dart';

import 'dart:convert' as convert;

import 'package:fluttertoast/fluttertoast.dart';

class NewTicket extends StatefulWidget {
  @override
  _NewTicketState createState() => _NewTicketState();
}

class _NewTicketState extends State<NewTicket> {
  CodeHelpers codeHelpers = new CodeHelpers();
  var locationsList;
  int currentIssueType = 0;
  String currentIssueTypeName = "Select Issue Type";
  List<IssueType> issueTypesList = new List<IssueType>();
  List<IssueType> issueTypes = [];
  bool plansLoading = false;

  final List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> issueTypeItems = [];

  @override
  void initState() {
    var body = {
      "name": "getIssueTypes",
      "param": {"issues": "all"}
    };

    codeHelpers.httpPost(body, needAuth: true).then((issueTypes) {
      issueTypes.transform(convert.utf8.decoder).join().then((issueTypesRaw) {
        final lissueTypesList = convert.jsonDecode(issueTypesRaw);
        lissueTypesList["resonse"]["result"]["issuetypes"].forEach((issueType) {
          items.add(DropdownMenuItem(
            child: Text(issueType["messages"]),
            value: issueType["id"],
          ));

          issueTypesList.add(
              IssueType(id: issueType["id"], messages: issueType["messages"]));
        });

        setState(() {
          issueTypeItems = items;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(184, 27, 77, 10),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Issue Type",
                  style: TextStyle(color: Colors.white60, fontSize: 18),
                ),
                DropdownButton(
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 18),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  items: issueTypeItems,
                  elevation: 5,
                  hint: Text(
                    currentIssueTypeName,
                    style: TextStyle(color: Colors.white),
                  ),
                  value: null,
                  onChanged: (value) {
                    setState(
                      () {
                        currentIssueType = value; //int.parse(value);
                        // print('issue type ' + value.toString());
                        currentIssueTypeName = issueTypesList
                            .firstWhere(
                                (IssueType issueType) => issueType.id == value)
                            .messages
                            .toString();
                        // print('issue type name ' + currentIssueTypeName);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Color.fromRGBO(0, 32, 97, 5),
              onPressed: () {
                if (currentIssueType != 0) {
                  var ticketBody = {
                    "name": "addCustTicket",
                    "param": {
                      "customerId": codeHelpers.getStorageKey('custId'),
                      "messageId": currentIssueType,
                      "message": currentIssueTypeName
                    }
                  };

                  codeHelpers
                      .httpPost(ticketBody, needAuth: true)
                      .then((ticketCreationResponse) {
                    ticketCreationResponse
                        .transform(convert.utf8.decoder)
                        .join()
                        .then((responseBodyRaw) {
                      final ticketCreation =
                          convert.jsonDecode(responseBodyRaw);

                      Fluttertoast.showToast(
                          msg: ticketCreation["resonse"]["result"],
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Color.fromRGBO(0, 32, 97, 5),
                          textColor: Colors.white,
                          fontSize: 16.0);
                          Navigator.pop(context);
                      // new Future.delayed(const Duration(seconds: 100),
                      //     () => Navigator.pop(context));
                    });
                  });
                }

                else {
                  Fluttertoast.showToast(
                          msg: "Select Issue Type",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Color.fromRGBO(0, 32, 97, 5),
                          textColor: Colors.white,
                          fontSize: 16.0);
                }

              },
              child: Text(
                "Create Ticket",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
