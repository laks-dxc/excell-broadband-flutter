import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'animation/fadeIn.dart';
import 'helpers/Utils.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  Size? displaySize;
  double? textScaleFactor;
  bool isProcessing = false;

  TicketsScreenMode screenMode = TicketsScreenMode.Loading;
  Map<String, dynamic> ticket = {};
  String supportText = "";
  List<dynamic> issueTypes = [];
  int? selectedIssueTypeId;

  bool showNewSupportRequestScreen = false;

  TextEditingController issueDescriptionController = TextEditingController();
  String issueDescription = "Issue Description";

  @override
  void initState() {
    getSupportState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor;
    print(textScaleFactor.toString() + " is the textscalfactor");

    Widget ticketScreen;
    // if (screenMode != null)
    switch (screenMode) {
      case TicketsScreenMode.CreateTicket:
        {
          ticketScreen = createTicketScreen();
          break;
        }
      case TicketsScreenMode.ViewTickets:
        {
          // ticketScreen = createTicketScreen();
          ticketScreen = viewTicketScreen();

          break;
        }
      case TicketsScreenMode.Loading:
        {
          ticketScreen = Center(
            child: SpinKitCircle(size: 30.0, color: Colors.grey),
          );
        }
    }
    // else {
    // ticketScreen = Container(
    //   child: Center(
    //     child: Text("Error "),
    //   ),
    // );
    // }
    return ticketScreen;
  }

  getSupportState() {
    Customer.ticketsList().then((ticketsList) {
      setState(() {
        if (ticketsList["ticketCount"] > 0) {
          screenMode = TicketsScreenMode.ViewTickets;

          ticket = ticketsList["ticketsList"][0];
          supportText += "Your ticket Id. " + ticket["id"].toString() + " ";
          supportText +=
              ticket["problem"] != null ? " for " + ticket["problem"] : "";
          supportText += ticket["problem"] != null ? "" : "\n";

          supportText += " created on ";
          supportText += Utils.formatDateString(ticket["created"]);
          supportText +=
              ", is registered with us. \n\nOur support team will get in touch with you shortly.\n\nThank You.";
          getIssueTypes();
        } else if (ticketsList["ticketCount"] == 0) {
          screenMode = TicketsScreenMode.CreateTicket;
          getIssueTypes();
        }
      });
    });
  }

  getIssueTypes() {
    Customer.issueTypes().then((_issueTypes) {
      setState(() {
        issueTypes = _issueTypes["issueTypes"];
        // print(issueTypes.toString());
      });
    });
  }

  createTicketScreen() {
    return showNewSupportRequestScreen ? newTicketScreen() : noTicketsScreen();
  }

  Widget newTicketScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: selectedTheme.enabledBackground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Create new support request for ",
              style: TextStyle(fontSize: 20, color: selectedTheme.primaryText),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(issueTypes.length, (index) {
                return FadeIn(
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIssueTypeId = issueTypes[index]["id"];
                        // print(selectedIssueTypeId.toString() + " is the issue type id");
                        issueDescription = issueTypes[index]["ticket_desc"];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                        decoration:
                            selectedIssueTypeId == issueTypes[index]["id"]
                                ? BoxDecoration(
                                    color: selectedTheme.activeBackground
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        width: 1,
                                        color: selectedTheme
                                            .primaryGradientColors![0]))
                                : BoxDecoration(
                                    color: selectedTheme.activeBackground
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        width: 1, color: Colors.grey[400]!)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              decoration:
                                  selectedIssueTypeId == issueTypes[index]["id"]
                                      ? BoxDecoration(
                                          color: selectedTheme.activeBackground,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 1.0,
                                          ))
                                      : BoxDecoration(
                                          color: selectedTheme.activeBackground
                                              .withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                              width: 26.0,
                              height: 26.0,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: selectedIssueTypeId ==
                                          issueTypes[index]["id"]
                                      ? FadeIn(
                                          Icon(
                                            Icons.check,
                                            size: 18,
                                            color: selectedTheme.primaryColor,
                                          ),
                                          0.2,
                                          translate: false,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Container(
                              width: displaySize!.width * .70,
                              child: Text(issueTypes[index]["ticket_type"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: selectedTheme.primaryText)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  index * 0.2,
                  direction: Direction.y,
                  distance: -20,
                );
              }),
            ),
            SizedBox(height: 10),
            // Text("Yo Buddy"),

            TextFormField(
              onChanged: (_customerId) {},
              minLines: 5,
              maxLines: 10,
              // focusNode: focusCustomerId,
              keyboardType: TextInputType.multiline,
              controller: issueDescriptionController,
              maxLength: 100,
              autocorrect: false,
              onSaved: (a) {
                // _loginFormKey.
              },
              style: TextStyle(
                  height: 1.0,

                  // letterSpacing: 7.0,
                  fontSize: 20.0,
                  color: selectedTheme.primaryColor),
              cursorColor: Colors.black38,
              decoration: InputDecoration(
                counterText: "",
                // counterStyle: TextStyle(fontSize: 0),
                // contentPadding:
                //     new EdgeInsets.symmetric(vertical: 45.0, horizontal: 8.0),
                filled: true,
                fillColor: selectedTheme.activeBackground.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue[50]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: issueDescription,
                labelStyle: TextStyle(
                    height: 1.0,
                    letterSpacing: 1.0,
                    color: selectedTheme.primaryColor),
              ),
              enableInteractiveSelection: true,
              onFieldSubmitted: (v) {
                // FocusScope.of(context).requestFocus(focusMobileNo);
              },
            ),
            SizedBox(height: 30),
            FadeIn(
                Center(
                  child: selectedIssueTypeId == null || isProcessing == true
                      ? disabledButton()
                      : enabledButton(),
                ),
                (issueTypes.length + 0.1),
                direction: Direction.y,
                distance: 10.0)
          ],
        ),
      ),
    );
  }

  Widget disabledButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledBackgroundColor: selectedTheme.disabledBackground,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      child: Container(
          height: 50,
          width: 200,
          child: Center(
              child: Text(
            "Create Ticket",
            style: TextStyle(fontSize: 24.0),
          ))),
      onPressed: null,
    );
  }

  Widget enabledButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: selectedTheme.primaryGradientColors![1],
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      child: Container(
          height: 50,
          width: 200,
          child: Center(
              child: Text(
            "Create Ticket",
            style: TextStyle(fontSize: 24.0),
          ))),
      onPressed: createNewTicket,
    );
  }

  Widget noTicketsScreen() {
    return Container(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: displaySize!.width,
            height: 85 * textScaleFactor!,
            child: Stack(children: [
              Center(
                child: Text(
                  "No active support requests found",
                  style:
                      TextStyle(fontSize: 20, color: selectedTheme.primaryText),
                ),
              ),
              Align(
                  alignment: Alignment(1.1, 1.0),
                  child: Icon(Icons.check_circle,
                      size: 90,
                      color: selectedTheme.activeBackground.withOpacity(0.3))),
            ]),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.green[
                    50], //selectedTheme.activeBackground.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    width: 1, color: selectedTheme.primaryGradientColors![0])),
          ),
        ),
        SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: selectedTheme.primaryGradientColors![1],
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
          child: Container(
              height: 50,
              width: 250,
              child: Center(
                  child: Text(
                "New Support Request",
                style: TextStyle(fontSize: 18.0),
              ))),
          onPressed: () {
            setState(() {
              showNewSupportRequestScreen = true;
            });
          },
        )
      ]),
    );
  }

  createNewTicket() {
    setState(() {
      isProcessing = true;
    });

    print(issueTypes
        .firstWhere((element) => element["id"] == selectedIssueTypeId)
        .toString());

    Customer.createTicket(
            selectedIssueTypeId!,
            issueTypes.firstWhere((element) =>
                element["id"] == selectedIssueTypeId)["ticket_type"],
            issueDescriptionController.text)
        .then((int ticketCreationStatus) {
      if (ticketCreationStatus == 200 || ticketCreationStatus == 108)
        getSupportState();
      else
        getSupportState();
    });
  }

  showError() {}

  Widget viewTicketScreen() {
    return Container(
      child: Stack(
        children: [
          FadeIn(
            Align(
              alignment: Alignment(0.0, -0.85),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  supportText,
                  style:
                      TextStyle(color: selectedTheme.primaryText, fontSize: 25),
                ),
              ),
            ),
            2.0,
            direction: Direction.y,
            duration: 1.5,
            distance: 10.0,
          ),
          FadeIn(
              Align(
                  alignment: Alignment(1.0, -0.9),
                  child: Icon(Icons.check_circle,
                      size: 200,
                      color: selectedTheme.primaryText.withOpacity(0.1))),
              1.0,
              translate: false,
              duration: 1.5)
        ],
      ),
    );
  }
}
