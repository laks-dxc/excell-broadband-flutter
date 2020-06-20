import 'package:ExcellBroadband/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'helpers/constants.dart';
import 'helpers/fadeInX.dart';
import 'helpers/fadeInY.dart';
import 'helpers/utilities.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double cWidth, cHeight;
  final Radius containerBorderRadius = Radius.circular(15);

  String customerName = Utilities.getStorageItem('cutomerName');
  String mobileNos = Utilities.getStorageItem('mobileNo') +
      ", " +
      Utilities.getStorageItem('altcontactno');
  String emailAddress = Utilities.getStorageItem('emailid');
  String fullAddress =
      Utilities.getStorageItem('address').replaceAll(",", ", ").trim() +
          ", " +
          Utilities.getStorageItem('city') +
          ", " +
          Utilities.getStorageItem('state');

  sanitizeTextElements() {
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
  }

  @override
  Widget build(BuildContext context) {
    sanitizeTextElements();

    cWidth = MediaQuery.of(context).size.width;
    cHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(1.0, -1.0),
            child: SafeArea(
              child: Icon(
                Icons.settings,
                size: 150,
                color: Colors.grey[300],
              ),
            ),
          ),
          Image.asset(
            "assets/login_bg.png",
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment(0.8, -0.97),
              child: FadeInX(
                1.0,
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                distance: 160,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80),
                paymentDetailsContainer(),
                SizedBox(height: 10),
                darkModeContainer(),
                SizedBox(height: 10),
                rateOurAppContainer(),
                SizedBox(height: 30),
                signoutButtion(),
                SizedBox(height: 15),
              ],
            ),
          ),
          backButton(),
        ],
      ),
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment(-1.0, -0.9),
      child: Container(
        height: 50,
        width: 65,
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(-3.0, 0.0),
              color: Colors.grey[800],
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(90),
            bottomRight: Radius.circular(90),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: Constants.colors['gradient_colors3'],
          ),
        ),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white70),
      ),
    );
  }

  Widget signoutButtion() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Utilities.clearStorage();
          Navigator.of(context).pushReplacement(PageTransition(
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 500),
              child: Home()));
        },
        child: Container(
          height: 55,
          width: 265,
          // padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(-3.0, 0.0),
                color: Colors.grey[800],
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.centerRight,
              colors: Constants.colors['gradient_danger_colors'],
            ),
          ),
          child: Center(
              child: Text(
            "Log Out",
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w900,
                fontSize: 25),
          )),
        ),
      ),
    );
  }

  Widget textBoxContainer(String title, IconData icon,
      {heightFactor: 1.0, rightText: ""}) {
    return Container(
      height: cHeight * 0.075 * heightFactor,
      // width: cWidth * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: rightText == ""
                  ? ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: Constants.colors['gradient_colors3'],
                          ).createShader(bounds),
                      child: Icon(
                        icon,
                        size: 40,
                        color: Colors.purple.shade100,
                      ))
                  : ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: Constants.colors['gradient_colors3'],
                          ).createShader(bounds),
                      child: Text(rightText,style: TextStyle(fontSize: 16),)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 12,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    height: heightFactor / 1.1),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          containerBorderRadius,
        ),
      ),
    );
  }

  // Widget textBoxContainer(String textItem, {heightFactor: 1}) {
  //   return Container(
  //     height: cHeight * 0.1 * heightFactor,
  //     width: cWidth * 0.85,
  //     child: Align(
  //       alignment: Alignment.centerLeft,
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Text(
  //           textItem,
  //           style: TextStyle(fontSize: 22, color: Colors.black87),
  //         ),
  //       ),
  //     ),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[200],
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(15),
  //       ),
  //     ),
  //   );
  // }

  Widget paymentDetailsContainer() {
    final double containerHeightFactor = cHeight * 0.1015;

    List<Widget> profileDataContainerWidgets = [
      textBoxContainer(customerName, Icons.account_circle),
      textBoxContainer(
        mobileNos,
        Icons.phone_in_talk,
      )
    ];
    if (emailAddress != '')
      profileDataContainerWidgets
          .add(textBoxContainer(emailAddress, Icons.email));

    int fullAddresLength = fullAddress.length;

    profileDataContainerWidgets.add(textBoxContainer(
        fullAddress, Icons.location_on,
        heightFactor: fullAddresLength * 0.03));

    //  textBoxContainer(customerName, ""),
    //         textBoxContainer(mobileNos, ""),
    //         ,
    //         textBoxContainer(fullAddress, ""),

    return Container(
      height: containerHeightFactor * profileDataContainerWidgets.length +
          (containerHeightFactor * 1),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: profileDataContainerWidgets,
      ),
    );
  }

  Widget rateOurAppContainer() {
    final double containerHeightFactor = cHeight * 0.055;

    List<Widget> rateOurAppWidgets = [
      textBoxContainer("Rate our App", Icons.star),
    ];

    return Container(
      height: containerHeightFactor * rateOurAppWidgets.length +
          (containerHeightFactor * 1),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rateOurAppWidgets,
      ),
    );
  }

  Widget darkModeContainer() {
    final double containerHeightFactor = cHeight * 0.055;

    List<Widget> rateOurAppWidgets = [
      textBoxContainer("Dark Mode", null, rightText: "Coming Soon"),
    ];

    return Container(
      height: containerHeightFactor * rateOurAppWidgets.length +
          (containerHeightFactor * 1),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rateOurAppWidgets,
      ),
    );
  }
  // Widget _profileFields() {
  //   return Container(
  //     height: emailAddress != '' ? cHeight * .55 : cHeight * .48,
  //     width: cWidth,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         textBoxContainer(customerName, ""),
  //         textBoxContainer(mobileNos, ""),
  //         if (emailAddress != '')
  //           textBoxContainer(emailAddress, ""),
  //         textBoxContainer(fullAddress, ""),

  //         // textBoxContainer(),
  //       ],
  //     ),
  //     decoration: BoxDecoration(
  //       border: Border.all(width: 1.0, color: Colors.grey[400]),
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(25),
  //       ),
  //       color: Colors.white70,
  //     ),
  //   );
  // }

}
