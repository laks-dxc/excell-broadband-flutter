import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:launch_review/launch_review.dart';

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
  Size? displaySize;
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
      mobileNos = (storageValues[StorageKey.MobileNo])! +
          ", " +
          (storageValues[StorageKey.AltContactNo])!;

      fullAddress =
          (storageValues[StorageKey.Address]?.replaceAll(",", ", ").trim())! +
              ", " +
              storageValues[StorageKey.City]! +
              ", " +
              storageValues[StorageKey.State]!;

      setState(() {
        customerName = storageValues[StorageKey.CutomerName]!;
        emailAddress = storageValues[StorageKey.Emailid]!;
      });

      if (mobileNos.trim().endsWith(','))
        setState(() {
          mobileNos = mobileNos.replaceAll(',', '');
        });

      if (fullAddress.trim().endsWith(','))
        setState(() {
          fullAddress = fullAddress
              .replaceAll(',', '')
              .replaceAll('  ', ' ')
              .replaceAll(' ,', ',');
        });
    });
  }

  double? textScaleFactor;
  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    textScaleFactor = MediaQuery.of(context).textScaleFactor == 1.0
        ? 1.0
        : 0.85 / MediaQuery.of(context).textScaleFactor;

    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: selectedTheme.enabledBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(16.0 * textScaleFactor!),
            child: Column(
              children: <Widget>[
                _profileItem(customerName, Icons.account_circle),
                _profileItem(mobileNos, Icons.phone),
                emailAddress != ""
                    ? _profileItem(emailAddress, Icons.email)
                    : Container(height: 0),
                _profileItem(fullAddress, Icons.location_on),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            print("tapped launch");
            LaunchReview.launch();
          },
          child: Container(
            decoration: BoxDecoration(
                color: selectedTheme.enabledBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _profileItem("Rate us", Icons.star),
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
                                style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 32.0 * textScaleFactor!),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Coming Soon..",
                                style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 20.0 * textScaleFactor!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    target: Offset(520, 520),
                    duration: Duration(seconds: 3),
                  );
                },
                child: _profileItem("Dark Mode ", Icons.brightness_medium)),
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: selectedTheme.primaryGradientColors![1],
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
            child: Container(
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  "Log Out",
                  style: TextStyle(fontSize: 18.0 * textScaleFactor!),
                ))),
            onPressed: () {
              StorageUtils.clearStorage().then((bool cleared) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
              });
            },
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _profileItem(String text, IconData icon) {
    double heightFactor = 1.0;

    // if (text.length > 20)
    heightFactor = (text.length * textScaleFactor!) / 55;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: selectedTheme.activeBackground.withOpacity(0.5),
          border: Border.all(width: 1.0, color: Colors.transparent),
          borderRadius: BorderRadius.circular(15),
        ),
        width: displaySize!.width,
        height:
            70 + (displaySize!.height * 0.06 * heightFactor * textScaleFactor!),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 22 * textScaleFactor!,
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
                    size: 42.0 * textScaleFactor!,
                    color: selectedTheme.primaryColor.withOpacity(0.3),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
