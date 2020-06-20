import 'package:ExcellCustomer/models/AppTheme.dart';
import 'package:ExcellCustomer/models/enum.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static AppThemeData lightMode = AppThemeData(
      radialGradient: RadialGradient(
          colors: [_fromHex('#112c75'), _fromHex('#20347e')], stops: [0, 1], radius: 20.0),
      primaryGradientColors: [_fromHex('#112c75'), _fromHex('#20347e')],
      primaryColor: _fromHex('#112c75'),
      disabledBackground: _fromHex('#d9d8e7'),
      enabledBackground: _fromHex('#d9d8e7'),
      activeBackground: _fromHex('#b4b2d0'),
      primaryText: _fromHex('#112c75'),
      disabledText: _fromHex('#434343'));

  static AppThemeData darkMode =
      AppThemeData(primaryGradientColors: [_fromHex('#112c75'), _fromHex('#20347e')]);

  static AppThemeData getTheme(AppTheme _appTheme) {
    return _appTheme == AppTheme.Light ? lightMode : darkMode;
  }

  static Color _fromHex(String hexCode) {
    return Color(int.parse('0xff' + hexCode.replaceFirst('#', '')));
  }
}
