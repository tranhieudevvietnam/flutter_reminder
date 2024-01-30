import 'dart:async';

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

  // final String pm = "PM";
  // final String am = "AM";

  // String currentTimeInType = '';
  TimeOfDay time = TimeOfDay.now();

  Timer? timer;

  late TimeOfDay _timeFrom;

  @override
  void initState() {
    if (widget.timeFrom != null) {
      time = widget.timeFrom ?? time;
      animationControllerScroll();
    }

    // currentTimeInType = time.hour >= 12 ? pm : am;

    // controllerHor = FixedExtentScrollController(initialItem: time.hour > 12 ? time.hour - 12 : time.hour);
    // controllerMin = FixedExtentScrollController(initialItem: time.minute);
    // controllerType = FixedExtentScrollController(initialItem: time.hour < 12 ? 0 : 1);
    controllerHor = FixedExtentScrollController(initialItem: time.hour);
    controllerMin = FixedExtentScrollController(initialItem: time.minute);

    super.initState();
  }

  animationControllerScroll() {
    // currentTimeInType = time.hour >= 12 ? pm : am;

    // controllerHor.animateToItem(time.hour > 12 ? time.hour - 12 : time.hour, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    // controllerMin.animateToItem(time.minute, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    // controllerType.animateToItem(time.hour < 12 ? 0 : 1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    controllerHor.animateToItem(time.hour, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    controllerMin.animateToItem(time.minute, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  Widget durationPicker({
    required int length,
    required FixedExtentScrollController controller,
    required Function(int index) onSelectedItemChanged,
    required Function(int index) onValidate,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      backgroundColor: Colors.transparent,
      magnification: 1.0,
      onSelectedItemChanged: onSelectedItemChanged,
      itemExtent: 40,
      children: List.generate(length, (index) {
        final String indexShow = index >= 10 ? "$index" : "0$index";
        return Text(indexShow,
            style:
                (onValidate(index) == true ? StyleFont.medium(22) : StyleFont.medium(20).copyWith(color: ColorName.hinText)).copyWith(height: 1.6));
      }),
    );
  }

  // Widget typeTimePicker({
  //   required FixedExtentScrollController controller,
  // }) {
  //   return CupertinoPicker(
  //     scrollController: controller,
  //     backgroundColor: Colors.transparent,
  //     magnification: 1.0,
  //     onSelectedItemChanged: (x) {
  //       if (x == 0) {
  //         currentTimeInType = am; //AM
  //         time = TimeOfDay(hour: time.hour - 12, minute: time.minute);
  //       } else {
  //         currentTimeInType = pm; //PM
  //         time = TimeOfDay(hour: time.hour + 12, minute: time.minute);
  //       }
  //       _changeValueByTable();

  //       setState(() {});
  //     },
  //     itemExtent: 40,
  //     children: List.generate(2, (index) {
  //       final value = index == 0 ? am : pm;
  //       return Text(value,
  //           style:
  //               (value == currentTimeInType ? StyleFont.medium(20) : StyleFont.medium(18).copyWith(color: ColorName.hinText)).copyWith(height: 1.7));
  //     }),
  //   );
  // }

  _changeValueByTable() {
    timer?.cancel();
    timer = Timer(
      const Duration(seconds: 1),
      () {
        _timeFrom = time;
        widget.onChange.call(_timeFrom);
      },
    );
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
                length: 24,
                controller: controllerHor,
                onSelectedItemChanged: (x) {
                  // if (currentTimeInType == pm) {
                  //   time = TimeOfDay(hour: x + 12, minute: time.minute);
                  // } else {
                  time = TimeOfDay(hour: x, minute: time.minute);
                  // }
                  _changeValueByTable();
                  setState(() {});
                },
                onValidate: (index) {
                  // if (currentTimeInType == am) {
                  return time.hour == index;
                  // }
                  // return (time.hour - 12) == index;
                },
              )),
              Text(
                ":",
                style: StyleFont.medium(30).copyWith(height: 1.0),
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
                onValidate: (index) {
                  return time.minute == index;
                },
              )),
              // Text(
              //   ":",
              //   style: StyleFont.medium(30).copyWith(height: 1.0),
              // ),
              // Expanded(child: typeTimePicker(controller: controllerType)),
            ],
          )),
    );
  }
}
