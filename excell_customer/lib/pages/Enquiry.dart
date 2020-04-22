import 'package:flutter/material.dart';

class Enquiry extends StatefulWidget {
  @override
  EnquiryState createState() {
    return EnquiryState();
  }
}

class EnquiryState extends State<Enquiry> {
  final _formKey = GlobalKey<FormState>();

  final focusedErrorBorder = BorderSide(color: Colors.white, width: 1.0);

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
                "Create New Enquiry",
                style: TextStyle(color: Colors.white,fontSize:25 ),
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
                    labelStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
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
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.reset();
                    }
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
