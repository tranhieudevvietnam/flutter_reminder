import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';

// ignore: must_be_immutable
class WidgetCheckBox extends StatefulWidget {
  WidgetCheckBox({super.key, required this.value, this.onChange, this.padding});
  bool value;
  final Function(bool value)? onChange;
  final EdgeInsetsGeometry? padding;

  @override
  State<WidgetCheckBox> createState() => _WidgetCheckBoxState();
}

class _WidgetCheckBoxState extends State<WidgetCheckBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.value == true) {
      return WidgetAnimationClick(
          onTap: () {
            widget.value = false;
            widget.onChange?.call(false);
            setState(() {});
          },
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(5.0),
            child: Assets.icons.checkActive.svg(),
          ));
    } else {
      return WidgetAnimationClick(
          onTap: () {
            widget.value = true;
            widget.onChange?.call(true);
            setState(() {});
          },
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(5.0),
            child: Assets.icons.checkNone.svg(),
          ));
    }
  }
}
