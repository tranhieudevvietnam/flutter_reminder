import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';

class WidgetIconItemReminder extends StatelessWidget {
  const WidgetIconItemReminder({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Center(
        child: Assets.icons.iconColumn.svg(),
      ),
    );
  }
}
