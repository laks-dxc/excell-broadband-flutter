import 'dart:convert';

import 'package:ExcellCustomer/CodeHelpers.dart';
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
    color: Color.fromRGBO(0, 32, 97, 5),
  );
  final errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );
  final focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );
  final enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(0, 32, 97, 5), width: 1.0),
  );

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
          "purpose": enquiryData.purpose
        }
      };

      codeHelpers.httpPost(body).then((onValue) {
        Fluttertoast.showToast(
            msg: "Enquiry Saved Succesfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Color.fromRGBO(0, 32, 97, 5),
            textColor: Colors.white,
            fontSize: 16.0);
        _formKey.currentState.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(184, 27, 77, 10),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // padding: EdgeInsets.all(10.0),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "New Enquiry",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.white,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  focusedErrorBorder: focusedBorder,
                  errorStyle: errorStyle,
                  errorBorder: errorBorder,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledBorder,
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.white),
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
              SizedBox(height: 10),
              TextFormField(
                onSaved: (value) {
                  setState(() {
                    enquiryData.email = value;
                  });
                },
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    focusedErrorBorder: focusedBorder,
                    errorStyle: errorStyle,
                    errorBorder: errorBorder,
                    focusedBorder: focusedBorder,
                    enabledBorder: enabledBorder,
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  setState(() {
                    enquiryData.mobile = value;
                  });
                },
                keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    focusedErrorBorder: focusedBorder,
                    errorStyle: errorStyle,
                    errorBorder: errorBorder,
                    focusedBorder: focusedBorder,
                    enabledBorder: enabledBorder,
                    labelText: 'Mobile',
                    labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please enter your mobile no.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  setState(() {
                    enquiryData.address = value;
                  });
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    focusedErrorBorder: focusedBorder,
                    errorStyle: errorStyle,
                    errorBorder: errorBorder,
                    focusedBorder: focusedBorder,
                    enabledBorder: enabledBorder,
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  setState(() {
                    enquiryData.city = value;
                  });
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusedErrorBorder: focusedBorder,
                  errorStyle: errorStyle,
                  errorBorder: errorBorder,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledBorder,
                  labelText: 'City',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  setState(() {
                    enquiryData.purpose = value;
                  });
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    focusedErrorBorder: focusedBorder,
                    errorStyle: errorStyle,
                    errorBorder: errorBorder,
                    focusedBorder: focusedBorder,
                    enabledBorder: enabledBorder,
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Purpose'),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please enter purpose ';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  color: Color.fromRGBO(0, 32, 97, 5),
                  onPressed: () {
                    submit();
                  },
                  child: Text(
                    'Create Enquiry',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
