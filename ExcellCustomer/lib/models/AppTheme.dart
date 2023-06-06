import 'package:flutter/material.dart';

class AppThemeData {
  final List<dynamic>? primaryGradientColors;
  final Color primaryColor;
  final Color disabledBackground;
  final Color enabledBackground;
  final Color activeBackground;
  final Color inActiveBackground;

  final Color primaryText;
  final Color disabledText;
  final RadialGradient? radialGradient;
  final Color textColor;
  final Color appBarColor;
  final Color? scaffoldBgColor;

  AppThemeData(
      {this.primaryGradientColors,
      required this.primaryColor,
      required this.disabledBackground,
      required this.enabledBackground,
      required this.activeBackground,
      required this.primaryText,
      required this.disabledText,
      this.radialGradient,
      required this.textColor,
      this.scaffoldBgColor,
      required this.inActiveBackground,
      required this.appBarColor});

  AppThemeData copyWith(
      {List<dynamic>? primaryGradientColors,
      Color? primaryColor,
      Color? disabledBackground,
      Color? enabledBackground,
      Color? activeBackground,
      Color? inActiveBackground,
      Color? primaryText,
      Color? disabledText,
      // List<Color>? radialGradient,
      Color? textColor,
      Color? scaffoldBgColor,
      Color? appBarColor}) {
    return AppThemeData(
        primaryGradientColors:
            primaryGradientColors ?? this.primaryGradientColors,
        primaryColor: primaryColor ?? this.primaryColor,
        disabledBackground: disabledBackground ?? this.disabledBackground,
        enabledBackground: enabledBackground ?? this.enabledBackground,
        activeBackground: activeBackground ?? this.activeBackground,
        inActiveBackground: inActiveBackground ?? this.inActiveBackground,
        primaryText: primaryText ?? this.primaryText,
        disabledText: disabledText ?? this.disabledText,
        radialGradient: radialGradient ?? this.radialGradient,
        textColor: textColor ?? this.textColor,
        scaffoldBgColor: scaffoldBgColor ?? this.scaffoldBgColor,
        appBarColor: appBarColor ?? this.appBarColor);
  }

  Map<String, dynamic> toMap() {
    return {
      'primaryGradientColors': primaryGradientColors,
      'primaryColor': primaryColor,
      'disabledBackground': disabledBackground,
      'enabledBackground': enabledBackground,
      'activeBackground': activeBackground,
      'inActiveBackground': inActiveBackground,
      'primaryText': primaryText,
      'disabledText': disabledText,
    };
  }

  static AppThemeData fromMap(Map<Color, dynamic> map) {
    // if (map == null) return null;

    return AppThemeData(
      primaryGradientColors: List<Color>.from(map['primaryGradientColors']),
      primaryColor: map['primaryColor'],
      disabledBackground: map['disabledBackground'],
      enabledBackground: map['enabledBackground'],
      activeBackground: map['activeBackground'],
      inActiveBackground: map['inActiveBackground'],
      primaryText: map['primaryText'],
      disabledText: map['disabledText'],
      appBarColor: map['appBarColor'],
      textColor: map['textColor'],
    );
  }
}
