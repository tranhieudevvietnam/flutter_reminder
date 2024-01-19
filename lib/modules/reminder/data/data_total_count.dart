import 'package:flutter/material.dart';
import 'package:flutter_reminder/modules/reminder/widgets/reoderables/widget_reorderable_wrap.dart';

class DataTotalCount extends DataReorderableWrap {
  final String title;
  final num value;
  final Widget icon;

  DataTotalCount({required this.title, required this.value, required this.icon, Offset offset = const Offset(0, 0), Size size = const Size(0, 0)})
      : super(offset: offset, size: size);
}
