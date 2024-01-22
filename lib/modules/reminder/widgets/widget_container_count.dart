import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';

class WidgetContainerTotalCount extends StatelessWidget {
  const WidgetContainerTotalCount({super.key, required this.icon, required this.text, required this.count});
  final Widget icon;
  final String text;
  final num count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 8, right: 16, left: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: StyleFont.medium(17).copyWith(color: ColorName.hinText),
              )
            ],
          ),
          Text(
            "$count",
            style: StyleFont.bold(28),
          )
        ],
      ),
    );
  }
}
