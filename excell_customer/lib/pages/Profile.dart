import 'package:ExcellCustomer/CodeHelpers.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CodeHelpers codeHelpers = new CodeHelpers();
  var profileData;
  String customerName, daytime, night, mobile, address, city, state;

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
          daytime = profileData["daytime"];
          night = profileData["daytime"];
          mobile = profileData["mobile"];
          address = profileData["address"];
          city = profileData["city"];
          state = profileData["state"];

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
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView(
        // , , , , , ,
        children: <Widget>[
          listTileWidget("Name", customerName ?? "", showDivider: true),
          listTileWidget("Mobile No.", daytime ?? "", showDivider: true),
          listTileWidget("Contact No.", night ?? "", showDivider: true),
          // listTileWidget("mobile", mobile ?? "", showDivider: true),
          // listTileWidget("address", address ?? "", showDivider: true),
          listTileWidget("city", city ?? "", showDivider: true),
          listTileWidget("State", state ?? "", showDivider: true)
        ],
      ),
    );
  }
}
