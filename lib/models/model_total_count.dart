import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_wrap.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender_current.dart';

class ModelTotalCount extends DataReorderableWrap {
  String? title;
  num? value;
  bool? selected;

  ModelTotalCount({this.title, this.value, this.selected,  String? id, Offset offset = const Offset(0, 0), Size size = const Size(0, 0)}) {
    this.id = id;
    this.offset = offset;
    this.size = size;
  }

  Widget get icon {
    switch (title) {
      case "Today":
        return WidgetIconCalenderCurrent(
          dateTime: DateTime.now(),
        );
      case "Yesterday":
        return WidgetIconCalenderCurrent(
          color: Colors.red,
          dateTime: DateTime.now().add(const Duration(days: -1)),
        );
      case "Scheduled":
        return Assets.icons.calenderOrigen.svg(width: 40, height: 40);
      case "All":
        return Assets.icons.all.svg(width: 40, height: 40);
      case "Done":
        return Assets.icons.allDone.svg(width: 40, height: 40);
      default:
        return const SizedBox();
    }
  }

  getWidgetIcon() {
    switch (title) {
      case "WidgetIconCalenderCurrent":
        break;
      default:
    }
  }

  ModelTotalCount.formJson(Map json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
    selected = json['selected'];
  }

  @override
  Map<dynamic, dynamic> toJson() {
    final mapData = <dynamic, dynamic>{};
    mapData['id'] = id;
    mapData['title'] = title;
    mapData['value'] = value;
    mapData['selected'] = selected;
    return mapData;
  }
}
