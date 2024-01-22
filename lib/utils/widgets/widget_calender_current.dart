import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';

class WidgetIconCalenderCurrent extends StatelessWidget {
  const WidgetIconCalenderCurrent({super.key, required this.dateTime, this.color});
  final DateTime dateTime;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: ShapeDecoration(
        color: color?? ColorName.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Container(
            width: 20,
            height: 15,
            margin: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            decoration: ShapeDecoration(
              color: color?? ColorName.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: Center(
              child: Text(
                "${dateTime.day}",
                style: StyleFont.bold(10).copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
