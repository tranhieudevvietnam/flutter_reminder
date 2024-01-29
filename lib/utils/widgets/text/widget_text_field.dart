import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';

class WidgetTextField extends StatelessWidget {
  const WidgetTextField({
    super.key,
    this.hintText,
    this.style,
    this.styleHint,
    this.textAlign = TextAlign.start,
    required this.controller,
    this.maxLines,
    this.minLines,
    this.autofocus,
  });
  final String? hintText;
  final TextStyle? style;
  final TextStyle? styleHint;
  final TextAlign textAlign;
  final TextEditingController controller;
  final int? maxLines;
  final int? minLines;
  final bool? autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign,
      style: style ?? StyleFont.regular(),
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus ?? false,
      decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hintText,
          hintStyle: styleHint ??
              StyleFont.regular().copyWith(
                color: ColorName.hinText,
              )),
    );
  }
}
