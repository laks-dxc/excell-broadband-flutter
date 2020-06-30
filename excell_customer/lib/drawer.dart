import 'package:ExcellCustomer/payments.dart';
import 'package:ExcellCustomer/profile.dart';
import 'package:ExcellCustomer/support.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'helpers/appStyles.dart';
import 'models/AppTheme.dart';
import 'models/enum.dart';
import 'dashboard.dart';
import 'myPackages.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  static AppThemeData selectedTheme = AppStyles.getTheme(AppTheme.Light);

  final List<ScreenHiddenDrawer> itens = [
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Home",

          colorLineSelected: selectedTheme.appBarColor,
          baseStyle: TextStyle(color: selectedTheme.textColor.withOpacity(0.6), fontSize: 25.0),
          selectedStyle: TextStyle(color: selectedTheme.textColor),
        ),
        Dashboard()),
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Payment",
          colorLineSelected: selectedTheme.appBarColor,
          baseStyle: TextStyle(color: selectedTheme.textColor.withOpacity(0.6), fontSize: 25.0),
          selectedStyle: TextStyle(color: selectedTheme.textColor),
        ),
        Payment()),
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Packages",
          colorLineSelected: selectedTheme.appBarColor,
          baseStyle: TextStyle(color: selectedTheme.textColor.withOpacity(0.6), fontSize: 25.0),
          selectedStyle: TextStyle(color: selectedTheme.textColor),
        ),
        MyPackages()),
    ScreenHiddenDrawer(

        ItemHiddenMenu(

          name: "Support",
          colorLineSelected: selectedTheme.appBarColor,
          baseStyle: TextStyle(color: selectedTheme.textColor.withOpacity(0.6), fontSize: 25.0),
          selectedStyle: TextStyle(color: selectedTheme.textColor),
          
        ),
        Support()),
    ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Profile",
          colorLineSelected: selectedTheme.appBarColor,
          baseStyle: TextStyle(color: selectedTheme.textColor.withOpacity(0.6), fontSize: 25.0),
          selectedStyle: TextStyle(color: selectedTheme.textColor),
        ),
        Profile())
  ];

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      initPositionSelected: 0,
      screens: itens,
      // curveAnimation: Curves.easeInOutExpo,
      backgroundColorMenu: Colors.white,
      typeOpen: TypeOpen.FROM_LEFT,
      enableScaleAnimation: true,
      backgroundColorContent: selectedTheme.scaffoldBgColor,
      //    enableCornerAnimin: true,
      slidePercent: 90.0,
      verticalScalePercent: 80.0,
      contentCornerRadius: 50.0,
      iconMenuAppBar: Image.asset('assets/icons8-menu-16.png'),
      //    backgroundContent: DecorationImage((image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
      //    whithAutoTittleName: true,
      //    styleAutoTittleName: TextStyle(color: Colors.red),
      //    actionsAppBar: <Widget>[],
      //    backgroundColorContent: Colors.blue,
      backgroundColorAppBar: selectedTheme.appBarColor,
      elevationAppBar: 8.0,
      //    tittleAppBar: Center(child: Icon(Icons.ac_unit),),
      //    enableShadowItensMenu: true,
      backgroundMenu: DecorationImage(
          alignment: Alignment.topCenter,
          image: ExactAssetImage('assets/login_bg.png'),
          fit: BoxFit.fitWidth),
    );
  }
}
