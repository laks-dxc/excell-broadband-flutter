import 'dart:math' as Math;
import 'package:date_format/date_format.dart';

class Utils {
  static String bytesToSize(String bytesString) {
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    String output = '';

    if (
        // bytesString == null ||
        bytesString == 'null' || bytesString == '0.0' || bytesString == '0') {
      output = '0.00 GB';
    } else {
      double bytesInDouble = double.parse(bytesString);
      // print("bytesString " + bytesString);
      // print("bytesInDouble " + bytesInDouble.toString());

      if (bytesInDouble == 0.0)
        output = '';
      else {
        var i = (Math.log(bytesInDouble) / Math.log(1024)).floor();

        if (i == 0) output = bytesInDouble.toString() + ' ' + sizes[i];
        output = (bytesInDouble / Math.pow(1024, i)).toStringAsFixed(2) +
            ' ' +
            sizes[i];
      }
    }

    return output;
  }

  static double convertToDouble(String? value) {
    double dblValue = 0.0;
    if (value == null)
      return dblValue;
    else
      return double.parse(value);
  }

  static String mbToSize(String? mbString) {
    // var sizes = ['KB', 'MB', 'GB', 'TB'];

    String output = '';
    // print("mbString s " + mbString);
    if (mbString == null) {
      output = '0.00';
    } else {
      double mbDouble = double.parse(mbString) * 1024 * 1024;
      output = bytesToSize(mbDouble.toString());
    }

    return output;

    // if (mbDouble == 0)
    //   output = '0.00';
    // else {
    //   // if(mbDouble < 1) mbDouble =
    //   var i = (Math.log(mbDouble) / Math.log(1024)).floor();

    //   if (i == 0) output = mbDouble.toString() + ' ' + sizes[i];

    //   output =
    //       (mbDouble / Math.pow(1024, i)).toStringAsFixed(2) + ' ' + sizes[i];
  }

  static String showAsMoney(String? money, {precision = 2}) {
    if (money == null)
      return "Rs. 0";
    else {
      double moneyDouble = double.parse(money);
      return "Rs. " + moneyDouble.toStringAsFixed(precision);
    }
  }

  static String formatDateString(String unformaatedDate) {
    return formatDate(
        DateTime.parse(unformaatedDate), [dd, '-', M, '-', 'yyyy']);
  }

  static String formatDateTimeString(String? unformaatedDate) {
    if (unformaatedDate == null || unformaatedDate == "") return "";
    return formatDate(DateTime.parse(unformaatedDate),
        [dd, '-', M, '-', 'yyyy', ' ', 'hh', ':', 'mm']);
  }

  static String getDueInDaysText(String _dueDate) {
    DateTime today = DateTime.now();

    int difference = DateTime.parse(_dueDate).difference(today).inDays;
    String dueInDaysText = "0";

    if (difference < -1) {
      dueInDaysText = "Overdue by " + difference.abs().toString() + " days.";
    } else if (difference == 0) {
      dueInDaysText = "Due Today.";
    } else if (difference == -1) {
      dueInDaysText = "Overdue by a day.";
    } else if (difference == 1) {
      dueInDaysText = "Due Tomorrow.";
    } else if (difference > 1) {
      // dueInDaysText = "Due Tomorrow";
      dueInDaysText = "Due in " + difference.abs().toString() + " days.";
    }

    return dueInDaysText;
  }

  static String clipStringTo(String actualString, int maxSize,
      {overflowWith = ". "}) {
    if (actualString.length >= maxSize)
      return actualString.substring(0, maxSize - 3) +
          overflowWith +
          overflowWith +
          overflowWith;
    else
      return actualString;
  }

  static double getTextScaleFactor(double currentTextScaleFactor) {
    double textScaleFactor = 1.0;

    if (currentTextScaleFactor < 0) {
      //ignore: unused_local_variable
      double difference = 1.0 - currentTextScaleFactor;
    }

    return textScaleFactor;
  }
}
