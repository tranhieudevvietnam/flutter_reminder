import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/fonts.gen.dart';

class StyleFont {
  static const double _fontSizeScale = 0;

  static TextStyle bold([double fontSize = 16]) {
    fontSize += _fontSizeScale;
    return TextStyle(
      fontFamily: FontFamily.mPLUSRounded1cBold,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: ColorName.text,
    );
  }

  static TextStyle medium([double fontSize = 16]) {
    fontSize += _fontSizeScale;
    return TextStyle(
      fontFamily: FontFamily.mPLUSRounded1cMedium,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: ColorName.text,
    );
  }

  static TextStyle regular([double fontSize = 16]) {
    fontSize += _fontSizeScale;
    return TextStyle(
      fontFamily: FontFamily.mPLUSRounded1cRegular,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: ColorName.text,
    );
  }
}
