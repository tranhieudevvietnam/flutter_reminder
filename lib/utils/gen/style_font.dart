import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/fonts.gen.dart';

class StyleFont {
  static const double _fontSizeScale = 0;

  static TextStyle bold([double fontSize = 17]) {
    fontSize += _fontSizeScale;
    return TextStyle(
      fontFamily: FontFamily.bold,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: ColorName.text,
    );
  }

  static TextStyle medium([double fontSize = 17]) {
    fontSize += _fontSizeScale;
    return TextStyle(
      fontFamily: FontFamily.medium,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: ColorName.text,
    );
  }

  static TextStyle regular([double fontSize = 17]) {
    fontSize += _fontSizeScale;
    return TextStyle(
      fontFamily: FontFamily.regular,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: ColorName.text,
    );
  }
}
