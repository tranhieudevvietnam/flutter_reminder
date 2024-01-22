import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';

class WidgetIconItemReminder extends StatelessWidget {
  const WidgetIconItemReminder({super.key, required this.color, this.size, this.shadows});
  final Color color;
  final Size? size;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size?.width ?? 40,
      height: size?.height ?? 40,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        shadows: shadows
      ),
      child: Center(
        child: Assets.icons.iconColumn.svg(width: size?.width != null ? size!.width * .5 : null),
      ),
    );
  }
}
