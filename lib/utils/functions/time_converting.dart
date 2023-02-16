import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConverting {
  static DateTime convertToDateTime(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  }

  static TimeOfDay getTime(int timeStamp) {
    return TimeOfDay.fromDateTime(convertToDateTime(timeStamp));
  }

  static String getDayNameFromTimeStamp(int timeStamp,
          {bool setFullDayName = false}) =>
      DateFormat(setFullDayName ? 'EEEE' : 'EEE')
          .format(convertToDateTime(timeStamp));
}
