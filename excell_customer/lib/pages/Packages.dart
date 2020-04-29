import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'dart:convert' as convert;

import '../models/Location.dart';
import '../models/BbPlan.dart';

class Packages extends StatefulWidget {
  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  bool asTabs = false;
  String selectedValue;
  String preselectedValue = "dolor sit";
  // ExampleNumber selectedNumber;
  List<int> selectedItems = [];

  final List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> locationItems = [];

  CodeHelpers codeHelpers = new CodeHelpers();
  var locationsList;
  var currentCity = 0;
  String currentCityName = "Select City";
  List<Location> locationList = new List<Location>();
  List<BBPlan> bbPlansList = new List<BBPlan>();
  List<BBPlan> bbPlans = [];
  bool plansLoading = false;

  getBBPlans() {
    var body = {
      "name": "getBbplanDetails",
      "param": {"locationId": currentCity}
    };

    setState(() {
      plansLoading = true;
    });
    codeHelpers.httpPost(body).then((lbbPlans) {
      lbbPlans.transform(convert.utf8.decoder).join().then((bbPlansRaw) {
        final lBbPlans = convert.jsonDecode(bbPlansRaw);
        setState(() {
          plansLoading = false;
        });

        bbPlansList.clear();

        lBbPlans["resonse"]["result"]["plans"].forEach((plan) {
          bbPlansList.add(BBPlan(
              plan_name: plan["plan_name"],
              plan_type: plan["plan_type"],
              plantype_name: plan["plantype_name"],
              plan_speed: plan["plan_speed"],
              data_limit: plan["data_limit"],
              plan_postfup: plan["plan_postfup"],
              plan_amount: plan["plan_amount"]));
        });
      });
    });
    setState(() {
      bbPlans = bbPlansList;
    });
  }

  @override
  void initState() {
    codeHelpers.httpPost({
      "name": "getLocations",
      "param": {"locationId": "all"}
    }).then((locations) {
      locations.transform(convert.utf8.decoder).join().then((locationsRaw) {
        final locationsList = convert.jsonDecode(locationsRaw);
        locationsList["resonse"]["result"]["locations"].forEach((location) {
          items.add(DropdownMenuItem(
            child: Text(location["location"]),
            value: location["location_id"],
          ));

          locationList.add(Location(
              location_id: location["location_id"],
              location: location["location"]));
        });

        setState(() {
          locationItems = items;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[locationDropdown(), showPackages(plansLoading)],
    );
  }

  showPackages(_plansLoading) {
    if (_plansLoading)
      return Center(
        child: Loading(
          indicator: BallPulseIndicator(),
          size: 50.0,
          color: Colors.white60,
        ),
      );
    else {
      if (currentCity == 0) {
        return Center(
          child: Text(
            'Select a city!!',
            style: TextStyle(color: Colors.white70),
          ),
        );
      } else {
        if (bbPlans.length == 0) {
          return Center(
            child: Text(
              'No Packages Found',
              style: TextStyle(color: Colors.white70),
            ),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: bbPlans.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return WidgetAnimator(
                  Card(
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                bbPlans[index].plan_name,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                "₹ " + bbPlans[index].plan_amount,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2.0,
                          color: Colors.white30,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Speed",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white60),
                              ),
                              Text(
                                bbPlans[index].plan_speed,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "FUP Limit",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white60),
                              ),
                              Text(
                                bbPlans[index].data_limit,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Speed - Post FUP",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white60),
                              ),
                              Text(
                                bbPlans[index].plan_postfup,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ); //buildBody(ctxt, index)
              },
            ),
          );
        }
      }
    }
  }

  locationDropdown() {
    return Card(
      // elevation: 3.0,
      color: Color.fromRGBO(0, 32, 97, 5), //Color.fromRGBO(184, 27, 77, 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Select your city",
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
              items: locationItems,
              elevation: 5,
              hint: Text(
                currentCityName,
                style: TextStyle(color: Colors.white),
              ),
              value: null,
              onChanged: (value) {
                setState(() {
                  currentCity = int.parse(value);
                  currentCityName = locationList
                      .firstWhere(
                          (Location location) => location.location_id == value)
                      .location
                      .toString();
                  getBBPlans();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
