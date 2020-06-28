import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'animation/fadeIn.dart';
import 'helpers/Utils.dart';
import 'helpers/appStyles.dart';
import 'models/cities.dart';
import 'models/AppTheme.dart';
import 'models/customer.dart';
import 'models/enum.dart';

class PackageList extends StatefulWidget {
  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);
  final TextEditingController _typeAheadController = TextEditingController();

  List<dynamic> excellLocationsList;
  CitiesService excellCitites;
  bool citiesLoaded = false;
  List<dynamic> planDetails = [];

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

  // String _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Excell Packages"), backgroundColor: selectedTheme.appBarColor //(0xff112c75),
          ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: citiesLoaded
                ? TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      style: TextStyle(fontSize: 22),
                      controller: this._typeAheadController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                        contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                        filled: true,
                        fillColor: Color(0xffd9d8e7),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Select City",
                        labelStyle: TextStyle(
                            height: 1.0,
                            fontSize: 22,
                            letterSpacing: 1.0,
                            color: Color(0xff112c75)),
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
                      this._typeAheadController.text = suggestion;

                      dynamic location = excellLocationsList.where((element) {
                        return element["location"] == suggestion;
                      }).toList()[0];
                      setState(() {
                        planDetails = [];
                      });

                      Customer.getBBPlans(location["location_id"]).then((value) {
                        setState(() {
                          planDetails = value;
                        });
                      });
                    })
                : Center(
                    child: Center(child: SpinKitCircle(size: 30, color: Colors.grey)),
                  ),
          ),
          planDetails.length > 0
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: packageListWithAddress()),
                  ),
                )
              : Text("")
        ],
      ),
    );
  }

  List<Widget> packageListWithAddress() {
    Widget iAddressWidget = addressWidget();

    List<Widget> packagesList = packageList();

    packagesList.insert(0, iAddressWidget);
    return packagesList;
  }

  Widget addressWidget() {
    return Container(
      height: 0,
    );

    // Container(
    //   child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
    //     Text(
    //       planDetails[0]["address"]
    //           .toString()
    //           .replaceAll("<br />", ", ")
    //           .replaceAll("<br/>", ", ")
    //           .replaceAll("<br>", ", ")
    //           .replaceAll(",,", ", ")
    //           .replaceAll(", ,", ", "),
    //       style: TextStyle(fontSize: 20),
    //     ),
    //     Text(
    //       planDetails[0]["contactnumber"],
    //       style: TextStyle(fontSize: 20),
    //     ),
    //     Text(
    //       planDetails[0]["emailid"],
    //       style: TextStyle(fontSize: 20),
    //     )
    //   ]),
    // );
  }

  List<Widget> packageList() {
    return List.generate(planDetails.length, (index) {
      return FadeIn(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
                color: selectedTheme.activeBackground.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10)),
            child: planBox(index),
          ),
        ),
        index + 0.3,
        direction: Direction.y,
        distance: 10,
      );
    });
  }

  planBox(index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          planItem("Plan Name", planDetails[index]["plan_name"]),
          Divider(
            thickness: 1.5,
          ),
          planItem("Speed", planDetails[index]["plan_speed"]),
          Divider(),
          planItem("Data Limit", planDetails[index]["data_limit"]),
          Divider(),
          planItem("Post FUP", planDetails[index]["plan_postfup"]),
          Divider(),
          planItem("Amount", Utils.showAsMoney(planDetails[index]["plan_amount"], precision: 0)),
        ],
      ),
    );
  }

  planItem(label, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        )
      ],
    );
  }
}


