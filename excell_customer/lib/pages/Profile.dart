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
    final List<Card> profileTiles = [
      detailsListValue("Name", customerName ?? ""),
      detailsListValue("Contact No.", daytime ?? ""),
      detailsListValue("Alt. Contact No.", night ?? ""),
      detailsListValue("Email", email ?? ""),
      detailsListValue("Address", fullAddress),
      // detailsListValue("State", state ?? ""),
      // detailsListValue("Address", state ?? ""),
    ];

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
          itemCount: profileTiles.length,
          itemBuilder: (BuildContext context, int index) {
            return WidgetAnimator(profileTiles[index]);
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
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
