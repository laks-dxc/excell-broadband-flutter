import 'package:flutter/material.dart';

class AppThemeData {
  final List<Color> primaryGradientColors;
  final Color primaryColor;
  final Color disabledBackground;
  final Color enabledBackground;
  final Color activeBackground;
  final Color primaryText;
  final Color disabledText;
  final Gradient radialGradient;
  final Color textColor;
  final Color appBarColor;
  final Color scaffoldBgColor;

  AppThemeData(
      {this.primaryGradientColors,
      this.primaryColor,
      this.disabledBackground,
      this.enabledBackground,
      this.activeBackground,
      this.primaryText,
      this.disabledText,
      this.radialGradient,
      this.textColor,
      this.scaffoldBgColor,
      this.appBarColor});

  AppThemeData copyWith(
      {List<dynamic> primaryGradientColors,
      Color primaryColor,
      Color disabledBackground,
      Color enabledBackground,
      Color activeBackground,
      Color primaryText,
      Color disabledText,
      List<Color> radialGradient,
      Color textColor,
      Color scaffoldBgColor,
      Color appBarColor}) {
    return AppThemeData(
        primaryGradientColors: primaryGradientColors ?? this.primaryGradientColors,
        primaryColor: primaryColor ?? this.primaryColor,
        disabledBackground: disabledBackground ?? this.disabledBackground,
        enabledBackground: enabledBackground ?? this.enabledBackground,
        activeBackground: activeBackground ?? this.activeBackground,
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
      'primaryText': primaryText,
      'disabledText': disabledText,
    };
  }

  static AppThemeData fromMap(Map<Color, dynamic> map) {
    if (map == null) return null;

    return AppThemeData(
      primaryGradientColors: List<dynamic>.from(map['primaryGradientColors']),
      primaryColor: map['primaryColor'],
      disabledBackground: map['disabledBackground'],
      enabledBackground: map['enabledBackground'],
      activeBackground: map['activeBackground'],
      primaryText: map['primaryText'],
      disabledText: map['disabledText'],
    );
  }
}
