import 'package:flutter/material.dart';

class Constants {
  static final baseURL = 'https://app.excellbroadband.com/api/index.php';
  static final colors = {
    'gradient_from_color': rgb(101, 115, 255),
    'gradient_to_color': rgb(206, 107, 168),
    'gradient_colors': [
      rgb(101, 115, 255),
      rgb(122, 113, 238),
      rgb(143, 112, 220),
      rgb(164, 110, 203),
      rgb(185, 109, 185),
      rgb(206, 107, 168),
      rgb(197, 100, 151),
      rgb(188, 94, 134),
      rgb(180, 87, 118),
      rgb(171, 80, 101),
      rgb(162, 74, 84),
      rgb(153, 67, 67)
    ],
    'excell_color':Color.fromRGBO(184, 27, 77, 10),
    'gradient_colors2': [fromHex('#bb377d'), fromHex('#fbd3e9')],
    'gradient_colors3': [fromHex('#b993d6'), fromHex('#8ca6db')],
    
  };

  static Color rgb(r, g, b) {
    return Color(
        int.parse('0xff' + _rgbToHex(r) + _rgbToHex(g) + _rgbToHex(b)));
  }

  static Color rgba(r, g, b, a) {
    return Color(
        int.parse('0xff' + _rgbToHex(r) + _rgbToHex(g) + _rgbToHex(b)));
  }

  static Color fromHex(String hexCode) {
    return Color(int.parse('0xff' + hexCode.replaceAll('#', '')));
  }

  static _rgbToHex(colorCode) {
    var hex = colorCode.toRadixString(16);
    if (hex.length < 2) {
      hex = "0" + hex;
    }
    return hex;
  }
}

/*#ff0084, #33001b;
*/
