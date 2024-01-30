import 'package:flutter_reminder/models/model_total_count.dart';
import 'package:uuid/uuid.dart';

enum TypeRepeat { never, everyDay, everyWeek, everyMonth }

enum TypePriority { veryHigh, high, normal, slow }

class ConstantData {
  ConstantData._();

  static ConstantData instant = ConstantData._();

  final listTotalNoneId = [
    ModelTotalCount(
      title: "Today",
      value: 0,
      selected: false,
    ),
    ModelTotalCount(
      title: "Yesterday",
      value: 0,
      selected: false,
    ),
    ModelTotalCount(
      title: "Scheduled",
      value: 0,
      selected: false,
    ),
    ModelTotalCount(
      title: "All",
      value: 0,
      selected: false,
    ),
    ModelTotalCount(
      title: "Done",
      value: 0,
      selected: false,
    ),
  ];
  final listTotal = [
    ModelTotalCount(
      id: const Uuid().v1(),
      title: "Today",
      value: 0,
      selected: true,
    ),
    ModelTotalCount(
      id: const Uuid().v1(),
      title: "Yesterday",
      value: 0,
      selected: true,
    ),
    ModelTotalCount(
      id: const Uuid().v1(),
      title: "Scheduled",
      value: 0,
      selected: true,
    ),
    ModelTotalCount(
      id: const Uuid().v1(),
      title: "All",
      value: 0,
      selected: true,
    ),
    ModelTotalCount(
      id: const Uuid().v1(),
      title: "Done",
      value: 0,
      selected: true,
    ),
  ];
}
