import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';

import 'helpers/appStyles.dart';
import 'helpers/storageUtils.dart';
import 'home.dart';
import 'models/AppTheme.dart';
import 'models/enum.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Size displaySize;
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  String customerName = "", mobileNos = "", emailAddress = "", fullAddress = "";

  @override
  void initState() {
    getProfileFields();
    super.initState();
  }

  void getProfileFields() {
    StorageUtils.getStorageItems([
      StorageKey.CutomerName,
      StorageKey.MobileNo,
      StorageKey.AltContactNo,
      StorageKey.City,
      StorageKey.Emailid,
      StorageKey.Address,
      StorageKey.City,
      StorageKey.State
    ]).then((storageValues) {
      mobileNos =
          storageValues[StorageKey.MobileNo] + ", " + storageValues[StorageKey.AltContactNo];

      fullAddress = storageValues[StorageKey.Address].replaceAll(",", ", ").trim() +
          ", " +
          storageValues[StorageKey.City] +
          ", " +
          storageValues[StorageKey.State];

      setState(() {
        customerName = storageValues[StorageKey.CutomerName];
        emailAddress = storageValues[StorageKey.Emailid];
      });

      if (mobileNos.trim().endsWith(','))
        setState(() {
          mobileNos = mobileNos.replaceAll(',', '');
        });

      if (fullAddress.trim().endsWith(','))
        setState(() {
          fullAddress = fullAddress.replaceAll(',', '').replaceAll('  ', ' ').replaceAll(' ,', ',');
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: selectedTheme.enabledBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _profileItem(customerName, Icons.account_circle),
                _profileItem(mobileNos, Icons.phone),
                emailAddress != "" ? _profileItem(emailAddress, Icons.email) : Container(height: 0),
                _profileItem(fullAddress, Icons.location_on),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: selectedTheme.enabledBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _profileItem("Rate us", Icons.star),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: selectedTheme.enabledBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
                onTap: () {
                  BotToast.showAttachedWidget(
                      allowClick: true,
                      attachedBuilder: (_) => Center(
                            child: Card(
                              margin: EdgeInsets.all(12.0),
                              color: Colors.black54,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.brightness_medium,
                                      size: 54,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Dark Mode",
                                      style: TextStyle(color: Colors.grey[200], fontSize: 32.0),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Coming Soon..",
                                      style: TextStyle(color: Colors.grey[200], fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      target: Offset(520, 520),
                      duration: Duration(seconds: 3)); //when loading toast is clicked it closes

                  // BotToast.showSimpleNotification(

                  //   align: Alignment.bottomCenter,
                  //   hideCloseButton: true,
                  //   duration: Duration(seconds: 3),
                  //   dismissDirections: [DismissDirection.down],
                  //   onlyOne: true,

                  //   subTitle: "Feature coming soon",
                  //     title: "Dark Mode"); // popup a sample notification toast;
                },
                child: _profileItem("Dark Mode ", Icons.brightness_medium)),
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: RaisedButton(
            textColor: Colors.white,
            color: selectedTheme.primaryGradientColors[1],
            child: Container(
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 24.0),
                ))),
            onPressed: () {
              StorageUtils.clearStorage().then((bool cleared) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => Home()));
              });
            },
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _profileItem(String text, IconData icon) {
    double heightFactor = 1.0;

    // if (text.length > 20)
    heightFactor = text.length / 55;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: selectedTheme.enabledBackground,
          border: Border.all(width: 1.0, color: Colors.transparent),
          borderRadius: BorderRadius.circular(15),
        ),
        width: displaySize.width,
        height: 70 + (displaySize.height * 0.06 * heightFactor),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 22,
                        color: selectedTheme.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    icon,
                    size: 42.0,
                    color: selectedTheme.primaryColor.withOpacity(0.3),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
