import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';

class WidgetItemMenuFocus extends StatelessWidget {
  const WidgetItemMenuFocus({super.key, required this.title, required this.icon, this.color});
  final String title;
  final Widget icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: StyleFont.regular().copyWith(color: color ?? Colors.red),
            ),
          ),
          icon
        ],
      ),
    );
  }
}
