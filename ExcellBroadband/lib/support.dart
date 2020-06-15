import 'package:ExcellBroadband/helpers/customerInfo.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:date_format/date_format.dart';
import 'helpers/constants.dart';
import 'helpers/fadeInX.dart';
import 'helpers/fadeInY.dart';
import 'helpers/utilities.dart';
// import 'helpers/utilities.dart';

class Support extends StatefulWidget {
  final List<dynamic> supportTicketsList;

  Support(this.supportTicketsList);

  @override
  _SupportState createState() => _SupportState(this.supportTicketsList);
}

class _SupportState extends State<Support> {
  List<dynamic> issueTypes;
  List<dynamic> ticketsList;
  dynamic supportTicketsResponse;
  int selectedIssueTypeId;
  dynamic selectedIssueType;
  bool ticketExists;
  _SupportState(this.supportTicketsResponse);

  final List<bool> trueFalseArray = [true, false];
  @override
  Widget build(BuildContext context) {
    CustomerInfo.issueTypes().then((response) {
      setState(() {
        issueTypes = response;
      });
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(1.0, -1.07),
            child: SafeArea(
                child: Icon(
              Icons.list,
              size: 140,
              color: Colors.black12,
            )),
          ),
          Align(
            alignment: Alignment(0.8, -0.97),
            child: SafeArea(
              child: FadeInX(
                  1.0,
                  Text("Support",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 40))),
            ),
          ),
          backButton(),
          supportTicketsResponse.length == 0
              ? newTicketWIdget()
              : viewTicketWidget(),
          if (supportTicketsResponse.length > 0)
            Align(
              alignment: Alignment(1.5, -0.7),
              child: Icon(
                Icons.check_circle,
                size: 240,
                color: Color.fromRGBO(34, 23, 156, 0.25),
              ),
            ),
        ],
      ),
    );
  }

  Widget viewTicketWidget() {
    print(supportTicketsResponse.toString());
    dynamic ticket = supportTicketsResponse[0];
    String supportText = '';

    supportText += "Your ticket ";
    supportText +=
        ticket["problem"] != null ? "for " + ticket["problem"] + " \n" : "";
    supportText += "created on ";
    supportText += formatDate(
        DateTime.parse(ticket["created"]).subtract(Duration(minutes: 0)),
        [dd, '-', M, ', ']);
    supportText +=
        "is registred with us. \n\nOur support team will get in touch with you shortly.\n\nThank You.";

    return Align(
      alignment: Alignment(-0.8, -0.3),
      child: Container(
        color: Colors.white,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                supportText,
                maxLines: 12,
                style: TextStyle(fontSize: 30, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newTicketWIdget() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Select your issue",
              style: TextStyle(fontSize: 30, color: Colors.black87),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 210,
                  // color: Colors.white,
                  child: issueTypes != null
                      ? ListView(
                          children: List.generate(
                            issueTypes.length,
                            (index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIssueType = issueTypes[index];
                                    selectedIssueTypeId =
                                        issueTypes[index]['id'];
                                  });
                                },
                                child: FadeInY(
                                  index * 0.5,
                                  issueTypeContainer(
                                    issueTypes[index]['messages'],
                                    selectedIssueTypeId ==
                                        issueTypes[index]['id'],
                                  ),
                                  distance: -15.0,
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                ),
                issueTypes != null
                    ? FadeInY(
                        issueTypes.length * 0.5,
                        createTicketButton(),
                        distance: -15.0,
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment(-1.0, -0.9),
      child: FadeInX(
        2.5,
        Container(
          height: 50,
          width: 65,
          // padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(-3.0, 0.0),
                color: Colors.grey[800],
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(90),
              bottomRight: Radius.circular(90),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: Constants.colors['gradient_colors3'],
            ),
          ),
          child: FadeInX(
              2,
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.white),
              distance: 30),
        ),
        distance: -30,
      ),
    );
  }

  Widget radioContainer(bool selected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: 50.0,
      height: 50.0,
      child: selected
          ? Center(
              child: FadeInX(
                1.0,
                Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.white54,
                ),
                translate: false,
              ),
            )
          : Container(),
      decoration: BoxDecoration(
        color: selected ? Colors.indigo[700] : Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget issueTypeContainer(_issueTypeDescription, selected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: 80,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              radioContainer(selected),
              SizedBox(
                width: 20,
              ),
              Text(_issueTypeDescription,
                  style: TextStyle(
                      fontSize: 24.0,
                      color: selected ? Colors.black : Colors.black54)),
            ]),
          )),
          decoration: containerDecoration(selected)),
    );
  }

  BoxDecoration containerDecoration(bool selected) {
    return selected
        ? BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 0.0),
                  color: Colors.grey[800],
                  blurRadius: 5.0)
            ],
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: Constants.colors['gradient_colors3'],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          )
        : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.grey[300], Colors.grey[300]],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          );
  }

  Widget createTicketButton() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (selectedIssueType != null) {
            CustomerInfo.createTicket(
                    selectedIssueTypeId, selectedIssueType["messages"])
                .then((ticketCreatedResponse) {
              if (Utilities.getStatus(ticketCreatedResponse) == 200) {
                CustomerInfo.supportTickets().then((supportTikectResponse) {
                  dynamic ticket =
                      supportTikectResponse["resonse"]["result"]["issuetypes"];

                  setState(() {
                    supportTicketsResponse.add(ticket);
                  });
                });
              }
            });
          }

          // print(selectedIssueTypeId);

          // Navigator.of(context).pushReplacement(PageTransition(
          //     type: PageTransitionType.leftToRight,
          //     duration: Duration(milliseconds: 500),
          //     child: Home()));
        },
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: 55,
              width: 265,
              // padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: selectedIssueType != null
                        ? Offset(-3.0, 0.0)
                        : Offset(-0.0, 0.0),
                    color: Colors.grey[800],
                    blurRadius: selectedIssueType != null ? 5.0 : 1.0,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(25)),
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                  colors: selectedIssueType != null
                      ? Constants.colors['gradient_danger_colors']
                      : Constants.colors['inactive_colors'],
                ),
              ),
              child: Center(
                  child: Text(
                "Create Ticket",
                style: TextStyle(
                    color: selectedIssueType != null
                        ? Colors.white70
                        : Colors.grey[400],
                    fontWeight: FontWeight.w900,
                    fontSize: 25),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
