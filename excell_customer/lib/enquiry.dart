import 'package:ExcellCustomer/models/subAreas.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'animation/fadeIn.dart';
import 'helpers/appStyles.dart';
import 'models/cities.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

// import 'models/extensions.dart';

class Enquiry extends StatefulWidget {
  @override
  _EnquiryState createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  EnquiryScreenMode currentScreen = EnquiryScreenMode.WelcomeScreen;

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _subAreaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  double logoOpacity = 0.3;

  List<dynamic> excellLocationsList;

  CitiesService excellCitites;
  SubAreaService _subAreaService;
  bool citiesLoaded = false;
  List<dynamic> planDetails = [];
  int areaId, subAreaId;
  List<dynamic> subAreasList = [];

  @override
  void initState() {
    Customer.getLocations().then((value) {
      setState(() {
        excellLocationsList = value;
        excellCitites = CitiesService(value);
        citiesLoaded = true;
      });
    });

    super.initState();
  }

  Size displaySize;
  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: selectedTheme.scaffoldBgColor,
        appBar: AppBar(
            title: Text("New Enquiry"), backgroundColor: selectedTheme.appBarColor //(0xff112c75),
            ),
        body: Stack(children: [
          Align(
            child: Image.asset(
              'assets/login_bg.png',
              width: 200,
              height: 200,
            ),
            alignment: Alignment.topCenter,
          ),
          Positioned(
              child: Opacity(
                  opacity: currentScreen == EnquiryScreenMode.ThankYou ? 1.0 : 0.3, // logoOpacity,
                  child: Image.asset(
                    'assets/logo_pink.png',
                    width: 200,
                    height: 200,
                  )),
              top: displaySize.height * 0.05,
              left: displaySize.width * 0.25),
          getCurrentScreen()
        ]));
  }

  getCurrentScreen() {
    switch (currentScreen) {
      case EnquiryScreenMode.WelcomeScreen:
        return FadeIn(
          welcomeText(),
          1.0,
          distance: 20,
          direction: Direction.y,
        );
        break;

      case EnquiryScreenMode.BasicDetail:
        return FadeIn(
          basicInfoForm(),
          1.0,
          distance: 20,
          direction: Direction.y,
        );
        break;

      case EnquiryScreenMode.AddressDetail:
        return FadeIn(
          addressInfoForm(),
          1.0,
          distance: 20,
          direction: Direction.y,
        );
        break;
      case EnquiryScreenMode.ThankYou:
        return FadeIn(
          thankYouScreen(),
          1.0,
          distance: 20,
          direction: Direction.y,
        );
        break;
      default:
        return Container();
        break;
    }
  }

  thankYouScreen() {
    setState(() {
      logoOpacity = 1.0;
    });
    double height = displaySize.height;
    return Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: height * 0.3),
        child: FadeIn(
          Container(
            width: displaySize.width,
            height: 80.0,
            child: Stack(children: [
              Center(
                child: Text(
                  "Your enquiry is registered. Thank you!!",
                  style: TextStyle(fontSize: 20, color: selectedTheme.primaryText),
                ),
              ),
              Align(
                  alignment: Alignment(1.1, 1.0),
                  child: Icon(Icons.check_circle,
                      size: 90, color: selectedTheme.activeBackground.withOpacity(0.3))),
            ]),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.green[50], //selectedTheme.activeBackground.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1, color: selectedTheme.primaryGradientColors[0])),
          ),
          1.0,
          direction: Direction.y,
          distance: 20,
        ));
  }

  bool mobileValid(mobileNo) {
    if (mobileNo.toString().length != 10) return false;
    return true;
  }

  bool emailValid(email) {
    if (email == null || email == "")
      return true;
    else {
      List<String> emailAtSplit = email.toString().split("@");
      if (emailAtSplit.length != 2) return false;
      if (emailAtSplit[1].split(".").length < 2) return false;
    }
    return true;
  }

  addressInfoForm() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Address :",
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
            keyboardType: TextInputType.multiline,
            controller: _addressController,
            inputFormatters: [],
            style: TextStyle(fontSize: 22),
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              filled: true,
              fillColor: selectedTheme.enabledBackground.withOpacity(0.6),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: "Complete Address",
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.edit_location,
                  color: selectedTheme.primaryColor.withOpacity(0.2),
                  size: 30,
                ),
              ),
              labelStyle:
                  TextStyle(fontSize: 22, letterSpacing: 1.0, color: selectedTheme.primaryColor),
            )),
        SizedBox(
          height: 15,
        ),
        TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              style: TextStyle(fontSize: 22),
              controller: this._cityController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                filled: true,
                fillColor: selectedTheme.activeBackground.withOpacity(0.2),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: "City",
                labelStyle: TextStyle(
                    height: 1.0, fontSize: 22, letterSpacing: 1.0, color: Color(0xff112c75)),
              ),
            ),
            suggestionsCallback: (pattern) {
              return excellCitites.getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  suggestion,
                  style: TextStyle(fontSize: 20, color: Colors.grey[400]),
                ),
              );
            },
            onSuggestionSelected: (suggestion) {
              this._cityController.text = suggestion;

              dynamic location = excellLocationsList.where((element) {
                return element["location"] == suggestion;
              }).toList()[0];

              setState(() {
                _subAreaService = null;
                subAreasList = location['sub_areas_list'];
                _subAreaService = SubAreaService(subAreasList);
                areaId = int.parse(location['location_id'].toString());
              });
            }),
        //subArea["subarea_id"], subArea["subarea_name"],
        subAreasList.length > 0
            ? TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  style: TextStyle(fontSize: 22),
                  controller: this._cityController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    filled: true,
                    fillColor: selectedTheme.activeBackground.withOpacity(0.2),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: "Sub Area",
                    labelStyle: TextStyle(
                        height: 1.0, fontSize: 22, letterSpacing: 1.0, color: Color(0xff112c75)),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _subAreaService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      suggestion,
                      style: TextStyle(fontSize: 20, color: Colors.grey[400]),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  this._subAreaController.text = suggestion;

                  String _subAreaId = subAreasList
                      .where((element) {
                        return element["subarea_name"] == suggestion;
                      })
                      .toList()[0]["subarea_id"]
                      .toString();
                  setState(() {
                    subAreaId = int.parse(_subAreaId);
                  });
                })
            : Text(""),

        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            raisedButton("Back", () {
              setState(() {
                currentScreen = EnquiryScreenMode.BasicDetail;
              });
            }),
            raisedButton("Continue", () {
              Customer.createEnquiry(
                name: _nameController.text.trim(),
                mobile: _mobileController.text.trim(),
                email: _emailController.text.trim(),
                address: _addressController.text.trim(),
                city: _cityController.text.trim(),
                areaId: areaId,
                subAreaId: subAreaId,
              ).then((value) {
                if (value == 200)
                  setState(() {
                    currentScreen = EnquiryScreenMode.ThankYou;
                  });
                else {
                  print(value);
                }
              });
            })
          ],
        )
      ]),
    );
  }

  basicInfoForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Enquiry Purpose:",//.capitalize(),
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
              keyboardType: TextInputType.text,
              controller: _purposeController,
              inputFormatters: [],
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                filled: true,
                fillColor: selectedTheme.enabledBackground.withOpacity(0.6),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: "Purpose",
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.speaker_notes,
                    color: selectedTheme.primaryColor.withOpacity(0.2),
                    size: 30,
                  ),
                ),
                labelStyle:
                    TextStyle(fontSize: 22, letterSpacing: 1.0, color: selectedTheme.primaryColor),
              )),
          SizedBox(
            height: 15,
          ),
          Text(
            "Contact Info:",
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
              keyboardType: TextInputType.text,
              controller: _nameController,
              inputFormatters: [],
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                filled: true,
                fillColor: selectedTheme.enabledBackground.withOpacity(0.6),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: "Name",
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.account_box,
                    color: selectedTheme.primaryColor.withOpacity(0.2),
                    size: 30,
                  ),
                ),
                labelStyle:
                    TextStyle(fontSize: 22, letterSpacing: 1.0, color: selectedTheme.primaryColor),
              )),
          SizedBox(
            height: 15,
          ),
          TextFormField(
              style: TextStyle(fontSize: 22),
              keyboardType: TextInputType.number,
              controller: _mobileController,
              maxLength: 10,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.phone_in_talk,
                    color: selectedTheme.primaryColor.withOpacity(0.2),
                    size: 30,
                  ),
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                filled: true,
                fillColor: selectedTheme.enabledBackground.withOpacity(0.6),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: "Mobile No.",
                counterText: "",
                labelStyle:
                    TextStyle(fontSize: 22, letterSpacing: 1.0, color: selectedTheme.primaryColor),
              )),
          SizedBox(
            height: 15,
          ),
          TextFormField(
              style: TextStyle(fontSize: 22),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.email,
                    color: selectedTheme.primaryColor.withOpacity(0.2),
                    size: 30,
                  ),
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                filled: true,
                fillColor: selectedTheme.enabledBackground.withOpacity(0.6),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: "Email",
                labelStyle:
                    TextStyle(fontSize: 22, letterSpacing: 1.0, color: selectedTheme.primaryColor),
              )),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              raisedButton("Back", () {
                setState(() {
                  currentScreen = EnquiryScreenMode.WelcomeScreen;
                });
              }),
              raisedButton("Continue", () {
                String _name = _nameController.text.trim();
                String _email = _emailController.text.trim();
                String _mobile = _mobileController.text.trim();
                String _purpose = _purposeController.text.trim();

                if (_purpose == "") {
                  showErrorMessage("Please enter the purpose of your enquiry");
                  return;
                }

                if (_name == "") {
                  showErrorMessage("Please enter your name");
                  return;
                }

                if (mobileValid(_mobile) == false) {
                  showErrorMessage("Please a valid mobile number");
                  return;
                }
                if (emailValid(_email) == false) {
                  showErrorMessage("Please a valid email address");
                  return;
                }

                setState(() {
                  currentScreen = EnquiryScreenMode.AddressDetail;
                });
              })
            ],
          )
        ],
      ),
    );
  }

  welcomeText() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Welcome.",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 25),
          Text(
            "Thank you for your interest in Excell Broadband.",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 25),
          Text(
            "The enquiry form has been created to provide the best customer assistance possible.",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Please provide as much of this information as you can.",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(""),
              raisedButton("Continue", () {
                setState(() {
                  currentScreen = EnquiryScreenMode.BasicDetail;
                });
              })
            ],
          )
        ],
      ),
    );
  }

  raisedButton(String title, action) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 16.0),
      child: RaisedButton(
        textColor: Colors.white,
        color: selectedTheme.primaryColor,
        child: Container(
            height: 35,
            width: 120,
            child: Center(
                child: Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ))),
        onPressed: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  showErrorMessage(text) {
    BotToast.showAttachedWidget(
        allowClick: true,
        enableSafeArea: true,
        attachedBuilder: (_) => Align(
              alignment: Alignment(0.0, 0.9),
              child: Container(
                width: displaySize.width,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  border: Border(
                    top: BorderSide(width: 5.0, color: Colors.red[500]),
                    bottom: BorderSide(width: 1.0, color: Colors.red[500]),
                    left: BorderSide(width: 1.0, color: Colors.red[500]),
                    right: BorderSide(width: 1.0, color: Colors.red[500]),
                  ),
                ),
                margin: EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 15, color: selectedTheme.primaryColor),
                  ),
                ),
              ),
            ),
        target: Offset(520, 520),
        duration: Duration(seconds: 3));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
