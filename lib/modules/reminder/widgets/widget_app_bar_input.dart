import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';

class WidgetAppBarInput extends StatelessWidget {
  const WidgetAppBarInput({
    super.key,
    required this.title,
    required this.onCancel,
    this.onSubmit,
  });
  final String title;
  final Function() onCancel;
  final Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: WidgetAnimationClick(
            onTap: onCancel,
            child: Text(
              "Cancel",
              style: StyleFont.regular().copyWith(color: ColorName.blue),
            ),
          ),
        ),
        Expanded(
            flex: 3,
            child: Center(
              child: Text(
                title,
                style: StyleFont.bold(18),
              ),
            )),
        Expanded(
          flex: 1,
          child: WidgetAnimationClick(
            onTap: onSubmit,
            child: Text(
              "Add",
              textAlign: TextAlign.right,
              style: StyleFont.regular().copyWith(color: ColorName.blue),
            ),
          ),
        ),
      ],
    );
  }
}
