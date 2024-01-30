import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';

class WidgetTimePicker extends StatefulWidget {
  final Function(TimeOfDay time) onChange;

  final TimeOfDay? timeFrom;

  const WidgetTimePicker({
    Key? key,
    required this.onChange,
    this.timeFrom,
  }) : super(key: key);
  @override
  _WidgetTimePickerState createState() => _WidgetTimePickerState();
}

class _WidgetTimePickerState extends State<WidgetTimePicker> with SingleTickerProviderStateMixin {
  late FixedExtentScrollController controllerHor;
  late FixedExtentScrollController controllerMin;
  late FixedExtentScrollController controllerType;

  final String pm = "PM";
  final String am = "AM";

  String currentTimeInType = '';
  TimeOfDay time = TimeOfDay.now();

  late TimeOfDay _timeFrom;

  @override
  void initState() {
    time = widget.timeFrom ?? time;

    currentTimeInType = time.hour >= 12 ? pm : am;

    controllerHor = FixedExtentScrollController(initialItem: time.hour > 12 ? time.hour - 12 : time.hour);
    controllerMin = FixedExtentScrollController(initialItem: time.minute);
    controllerType = FixedExtentScrollController(initialItem: time.hour < 12 ? 0 : 1);

    super.initState();
  }

  animationControllerScroll() {
    currentTimeInType = time.hour >= 12 ? pm : am;

    controllerHor.animateToItem(time.hour > 12 ? time.hour - 12 : time.hour, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    controllerMin.animateToItem(time.minute, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    controllerType.animateToItem(time.hour < 12 ? 0 : 1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  Widget durationPicker({required int length, required FixedExtentScrollController controller, required Function(int)? onSelectedItemChanged}) {
    return CupertinoPicker(
      scrollController: controller,
      backgroundColor: Colors.transparent,
      magnification: 1.0,
      onSelectedItemChanged: onSelectedItemChanged,
      itemExtent: 40,
      children: List.generate(length, (index) => Text('$index', style: StyleFont.bold(20).copyWith(height: 1.6))),
    );
  }

  Widget typeTimePicker({
    required FixedExtentScrollController controller,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      backgroundColor: Colors.transparent,
      magnification: 1.0,
      onSelectedItemChanged: (x) {
        if (x == 0) {
          currentTimeInType = am; //AM
          time = TimeOfDay(hour: time.hour - 12, minute: time.minute);
        } else {
          currentTimeInType = pm; //PM
          time = TimeOfDay(hour: time.hour + 12, minute: time.minute);
        }
        _changeValueByTable();

        setState(() {});
      },
      itemExtent: 40,
      children: List.generate(2, (index) => Text(index == 0 ? am : pm, style: StyleFont.bold(20).copyWith(height: 1.6))),
    );
  }

  _changeValueByTable() {
    _timeFrom = time;
    widget.onChange.call(_timeFrom);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: durationPicker(
                length: 12,
                controller: controllerHor,
                onSelectedItemChanged: (x) {
                  if (currentTimeInType == pm) {
                    time = TimeOfDay(hour: x + 12, minute: time.minute);
                  } else {
                    time = TimeOfDay(hour: x, minute: time.minute);
                  }
                  _changeValueByTable();
                  setState(() {});
                },
              )),
              Text(
                ":",
                style: StyleFont.bold(30).copyWith(height: 1.0),
              ),
              Expanded(
                  child: durationPicker(
                length: 60,
                controller: controllerMin,
                onSelectedItemChanged: (x) {
                  time = TimeOfDay(hour: time.hour, minute: x);
                  _changeValueByTable();

                  setState(() {});
                },
              )),
              Text(
                ":",
                style: StyleFont.bold(30).copyWith(height: 1.0),
              ),
              Expanded(child: typeTimePicker(controller: controllerType)),
            ],
          )),
    );
  }
}
