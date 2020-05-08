import 'dart:async';

import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:ExcellCustomer/widgets/WidgetAnimator.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

// import '../animator.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CodeHelpers codeHelpers = new CodeHelpers();
  var profileData;
  String customerName,
      daytime,
      night,
      mobile,
      address,
      city,
      state,
      email,
      fullAddress;

  final customerNameController = TextEditingController();
  final daytimeController = TextEditingController();
  final nightController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final emailController = TextEditingController();
  final fullAddressController = TextEditingController();

  final focusedBorder = OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(184, 27, 77, 10), width: 1.0));
  final disabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(0, 32, 97, 5), width: 1.0),
  );

  @override
  void initState() {
    var body = {
      "name": "getCustomerDetails",
      "param": {"customerId": codeHelpers.getStorageKey("custId")}
    };

    codeHelpers.httpPost(body, needAuth: true).then((profileValue) {
      profileValue.transform(convert.utf8.decoder).join().then((profileRaw) {
        profileData = convert.jsonDecode(profileRaw)["resonse"]["result"];
        setState(() {
          customerName = profileData["cutomerName"];
          daytime = profileData["contactno"];
          night = profileData["altcontactno"];
          address = profileData["address"];
          city = profileData["city"];
          state = profileData["state"];
          fullAddress = address + ', ' + (city ?? "") + ', ' + (state ?? "");
          email = profileData["emailid"];

          customerNameController.text = customerName;
          daytimeController.text = daytime;
          nightController.text = night;
          mobileController.text = mobile;
          addressController.text = address;
          cityController.text = city;
          stateController.text = state;
          emailController.text = email;
          fullAddressController.text = fullAddress;
        });
      });
    });
    super.initState();
  }

  listTileWidget(lable, value, {showDivider: true}) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text(
            lable,
            style: TextStyle(fontSize: 20, color: Colors.white54),
          ),
          trailing: Text(
            value,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        showDivider
            ? Divider(
                thickness: 2.0,
              )
            : Text("")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> profileTiles = [
      labelField("Name", customerName ?? " ",
          tfController: customerNameController),
      labelField("Contact No.", daytime ?? " ", tfController: daytimeController),
      labelField("Alternate Contact No.", night ?? " ",
          tfController: nightController),
      labelField("Email", email ?? "", tfController: emailController),
      labelField("Address", fullAddress, tfController: fullAddressController),
    ];

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
          itemCount: profileTiles.length,
          itemBuilder: (BuildContext context, int index) {
            return WidgetAnimator(Padding(
              padding: const EdgeInsets.all(8.0),
              child: profileTiles[index],
            ));
          }),
    );
  }

  Timer timer;
  Duration duration = Duration();
  wait() {
    if (timer == null || !timer.isActive) {
      timer = Timer(Duration(microseconds: 120), () {
        duration = Duration();
      });
    }
    duration += Duration(milliseconds: 100);
    return duration;
  }

  labelField(_label, _value, {tfController}) {
    print(_value);
    return TextField(
      controller: tfController,
      enabled: false,
      maxLines: 3,
      minLines: 1,
      // initialValue: _value,
      decoration: InputDecoration(
        disabledBorder: disabledBorder,
        focusedBorder: focusedBorder,
        labelText: _label,
        labelStyle: TextStyle(color: Color.fromRGBO(0, 32, 97, 5)),
      ),
    );
  }

  Card detailsListValue(label, value) {
    return Card(
      elevation: 1.0,
      color: Color.fromRGBO(184, 27, 77, 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(color: Colors.black38, fontSize: 18),
            ),
            Text(
              value,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
