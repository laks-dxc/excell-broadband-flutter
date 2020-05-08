import 'dart:convert';

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/models/Location.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:fluttertoast/fluttertoast.dart';

class EnquiryForm extends StatefulWidget {
  @override
  EnquiryFormState createState() {
    return EnquiryFormState();
  }
}

class Enquiry {
  String name;
  String email;
  String mobile;
  String address;
  String city;
  String purpose;
}

class EnquiryFormState extends State<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final focusedErrorBorder = BorderSide(color: Colors.white, width: 1.0);
  Enquiry enquiryData = new Enquiry();
  CodeHelpers codeHelpers = new CodeHelpers();
  final errorStyle = TextStyle(
    // color: Colors.fromRGBO(0, 32, 97, 5),
    color: Colors.red,
  );
  final errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
  );
  final focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(184, 27, 77, 10), width: 1.0),
  );
  final enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(0, 32, 97, 5), width: 1.0),
  );
  var currentCityId = 0;
  String currentCityName = "Select City";
  String hasSubArea = 'N';

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      var body = {
        "name": "addEnquiry",
        "param": {
          "name": enquiryData.name,
          "email": enquiryData.email,
          "mobile": enquiryData.mobile,
          "address": enquiryData.address,
          "city": enquiryData.city,
          "area_id": currentCityId,
          "sub_area_id": currentSubAreaId,
          "purpose": enquiryData.purpose
        }
      };

      // print(body.toString());

      codeHelpers.httpPost(body).then((onValue) {
        Fluttertoast.showToast(
            msg: "Enquiry Saved Succesfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Color.fromRGBO(0, 32, 97, 5),
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          currentSubAreaId = null;
          currentCityId = null;
          currentCityName = "Select City";
          hasSubArea = "N";
        });

        _formKey.currentState.reset();
      });
    }
  }

  final List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> locationItems = [];
  List<DropdownMenuItem> subAreaItems = [];

  List<Location> locationList = new List<Location>();

  @override
  void initState() {
    codeHelpers.httpPost({
      "name": "getLocations",
      "param": {"locationId": "all"}
    }).then((locations) {
      locations.transform(convert.utf8.decoder).join().then((locationsRaw) {
        final locationsList = convert.jsonDecode(locationsRaw);
        locationsList["resonse"]["result"]["locations"].forEach((location) {
          // print(location.toString());
          items.add(DropdownMenuItem(
            child: Text(location["location"]),
            value: location["location_id"],
          ));

          location["sub_area"] == "Y"
              ? locationList.add(Location(
                  location_id: location["location_id"],
                  location: location["location"],
                  sub_area: location["sub_area"],
                  sub_areas_list: location["sub_areas_list"]))
              : locationList.add(Location(
                  location_id: location["location_id"],
                  location: location["location"],
                  sub_area: location["sub_area"],
                  sub_areas_list: []));
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
    return Scaffold(
      backgroundColor: Colors.white, // Color.fromRGBO(184, 27, 77, 10),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(184, 27, 77, 10),
        title: Text('Excell Broadband - Enquiry'),
      ),
      body: Card(
        // color: Color.fromRGBO(184, 27, 77, 10),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              // padding: EdgeInsets.all(10.0),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                WidgetAnimator(
                  TextFormField(
                    cursorColor: Color.fromRGBO(184, 27, 77, 10),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedErrorBorder: focusedBorder,
                      errorStyle: errorStyle,
                      errorBorder: errorBorder,
                      focusedBorder: focusedBorder,
                      enabledBorder: enabledBorder,
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onSaved: (value) {
                      setState(() {
                        enquiryData.name = value;
                      });
                    },
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                WidgetAnimator(
                  TextFormField(
                    onSaved: (value) {
                      setState(() {
                        enquiryData.email = value;
                      });
                    },
                   cursorColor: Color.fromRGBO(184, 27, 77, 10),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedErrorBorder: focusedBorder,
                      errorStyle: errorStyle,
                      errorBorder: errorBorder,
                      focusedBorder: focusedBorder,
                      enabledBorder: enabledBorder,
                      labelText: 'Email Address',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                WidgetAnimator(
                  TextFormField(
                    onSaved: (value) {
                      setState(() {
                        enquiryData.mobile = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    cursorColor: Color.fromRGBO(184, 27, 77, 10),
                    decoration: InputDecoration(
                      focusedErrorBorder: focusedBorder,
                      errorStyle: errorStyle,
                      errorBorder: errorBorder,
                      focusedBorder: focusedBorder,
                      enabledBorder: enabledBorder,
                      labelText: 'Mobile',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter your mobile no.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                WidgetAnimator(
                  TextFormField(
                    onSaved: (value) {
                      setState(() {
                        enquiryData.address = value;
                      });
                    },
                    cursorColor: Color.fromRGBO(184, 27, 77, 10),
                    decoration: InputDecoration(
                      focusedErrorBorder: focusedBorder,
                      errorStyle: errorStyle,
                      errorBorder: errorBorder,
                      focusedBorder: focusedBorder,
                      enabledBorder: enabledBorder,
                      labelText: 'Address',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                WidgetAnimator(
                  TextFormField(
                    onSaved: (value) {
                      setState(() {
                        enquiryData.purpose = value;
                      });
                    },
                    cursorColor: Color.fromRGBO(184, 27, 77, 10),
                    decoration: InputDecoration(
                        focusedErrorBorder: focusedBorder,
                        errorStyle: errorStyle,
                        errorBorder: errorBorder,
                        focusedBorder: focusedBorder,
                        enabledBorder: enabledBorder,
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Purpose'),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Please enter purpose ';
                      }
                      return null;
                    },
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // WidgetAnimator(
                //   TextFormField(
                //     onSaved: (value) {
                //       setState(() {
                //         enquiryData.city = value;
                //       });
                //     },
                //     cursorColor: Color.fromRGBO(184, 27, 77, 10),
                //     decoration: InputDecoration(
                //       focusedErrorBorder: focusedBorder,
                //       errorStyle: errorStyle,
                //       errorBorder: errorBorder,
                //       focusedBorder: focusedBorder,
                //       enabledBorder: enabledBorder,
                //       labelText: 'City',
                //       labelStyle: TextStyle(color: Colors.white),
                //     ),
                //     validator: (value) {
                //       if (value.trim().isEmpty) {
                //         return 'Please enter your city';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                WidgetAnimator(
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Color.fromRGBO(0, 32, 97, 5),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        focusColor: Colors.black,
                        isExpanded: true,
                        style: TextStyle(
                            // fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 16),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                          size: 36,
                        ),
                        items: locationItems,
                        elevation: 5,
                        hint: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            currentCityName,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 32, 97, 5),
                            ),
                          ),
                        ),
                        value: null,
                        onChanged: (value) {
                          setState(() {
                            currentCityId = int.parse(value);
                            Location selectedLocation = locationList.firstWhere(
                                (Location location) =>
                                    location.location_id == value);

                            currentCityName =
                                selectedLocation.location.toString();
                            hasSubArea = selectedLocation.sub_area
                                .toString()
                                .toUpperCase();
                            getSubAreas(selectedLocation);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                subAreaWidget(hasSubArea),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: WidgetAnimator(RaisedButton(
                    color: Color.fromRGBO(0, 32, 97, 5),
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      'Create Enquiry',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<SubArea> subAreaList = [];

  subAreaWidget(lHasSubArea) {
    if (lHasSubArea == "Y") {
      return WidgetAnimator(subAreaDropdown());
    } else {
      currentSubAreaId = null;
      currentSubAreaName = "Select Sub Area";
      return Text("");
    }
  }

  getSubAreas(_location) {
    dynamic subAreasRaw = _location.sub_areas_list;
    List<DropdownMenuItem> items = [];
    subAreasRaw.forEach((subArea) {
      items.add(
        DropdownMenuItem(
          child: Text(subArea["subarea_name"]),
          value: subArea["subarea_id"],
        ),
      );
      subAreaList.add(SubArea(subArea["subarea_id"], subArea["subarea_name"],
          subArea["area_id"], subArea["crm_id"]));
    });

    setState(() {
      subAreaItems = items;
    });

    // return print();
  }

  var subAreaId = 0;
  String currentSubAreaName = "Select Sub Area";
  int currentSubAreaId;

  subAreaDropdown() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: Color.fromRGBO(0, 32, 97, 5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              style: TextStyle(color: Colors.black54, fontSize: 16),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 36,
              ),
              items: subAreaItems,
              elevation: 5,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  currentSubAreaName,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              value: null,
              onChanged: (value) {
                setState(() {
                  currentSubAreaId = int.parse(value);
                  SubArea selectedSubArea = subAreaList.firstWhere(
                      (SubArea subArea) => subArea.subarea_id == value);

                  currentSubAreaName = selectedSubArea.subarea_name.toString();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
