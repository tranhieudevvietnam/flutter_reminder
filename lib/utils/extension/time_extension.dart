import 'package:flutter/material.dart';

extension TimeExtension on TimeOfDay {
  getHour() {
    if (hour >= 10) {
      return "$hour";
    }
    return "0$hour";
  }

  getMinute() {
    if (minute >= 10) {
      return "$minute";
    }
    return "0$minute";
  }
}
