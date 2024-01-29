import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';

class WidgetIconCalenderIcon extends StatelessWidget {
  const WidgetIconCalenderIcon({
    super.key,
    this.dateTime,
    this.color,
    this.colorSelected,
    this.textSize = 12,
  });
  final DateTime? dateTime;
  final Color? colorSelected;
  final Color? color;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 25,
        height: 26,
        decoration: const BoxDecoration(
          color: ColorName.red,
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: color ?? ColorName.background,
          ),
          child: Center(
            child: Text(
              dateTime != null ? "${dateTime!.day < 10 ? "0${dateTime!.day}" : dateTime!.day}" : "...",
              style: StyleFont.medium(textSize).copyWith(color: ColorName.text, fontWeight: FontWeight.w900, height: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
