import 'dart:math' as Math;

class Utils {
  static String bytesToSize(String bytesString) {
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    String output = '';

    if (bytesString == null || bytesString == '0.0') {
      output = '0.00 GB';
    } else {
     
      double bytesInDouble = double.parse(bytesString);

      if (bytesInDouble == 0.0) output = '';

      var i = (Math.log(bytesInDouble) / Math.log(1024)).floor();

      if (i == 0) output = bytesInDouble.toString() + ' ' + sizes[i];
      output = (bytesInDouble / Math.pow(1024, i)).toStringAsFixed(2) + ' ' + sizes[i];
    }

    return output;
  }

  static double convertToDouble(String value) {
    double dblValue = 0.0;
    if (value == null)
      return dblValue;
    else
      return double.parse(value);
  }

  
  static String mbToSize(String mbString) {
    var sizes = ['MB', 'GB', 'TB'];

    String output = '';

    if (mbString == null) {
      output = '0.00';
    } else {
      double mbDouble = double.parse(mbString);

      if (mbDouble == 0)
        output = '0.00';
      else {
        var i = (Math.log(mbDouble) / Math.log(1024)).floor();

        if (i == 0) output = mbDouble.toString() + ' ' + sizes[i];

        output =
            (mbDouble / Math.pow(1024, i)).toStringAsFixed(2) + ' ' + sizes[i];
      }
    }
    return output;
  }
}
