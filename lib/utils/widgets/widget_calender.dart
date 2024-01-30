import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';

class WidgetCalendar extends StatefulWidget {
  const WidgetCalendar({
    Key? key,
    required this.onSelected,
    this.current,
  }) : super(key: key);
  final Function(DateTime value) onSelected;
  final DateTime? current;
  @override
  State<WidgetCalendar> createState() => _WidgetCalendarState();
}

class _WidgetCalendarState extends State<WidgetCalendar> {
  final _lsWeekDay = <String>['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  late DateTime dateSelected;
  late DateTime currentDateTime;

  PageController controller = PageController(initialPage: 1);

  @override
  void initState() {
    currentDateTime = widget.current ?? DateTime.now();
    dateSelected = widget.current ?? DateTime.now();
    controller.addListener(() {
      if (controller.page == controller.page?.toInt()) {
        debugPrint("xxx: ${controller.page}");
        if (controller.page?.toInt() == 1) return;
        if (controller.page!.toInt() < 1) {
          currentDateTime = DateTime(currentDateTime.year, currentDateTime.month - 1);
          setState(() {});
        } else {
          currentDateTime = DateTime(currentDateTime.year, currentDateTime.month + 1);
          setState(() {});
        }
        controller.jumpToPage(1);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    // "Tháng ${currentDateTime.month} ${currentDateTime.year}",
                    currentDateTime.getDateTimeFormat("MMM yyyy"),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  Assets.icons.next.svg(width: 16)
                ],
              ),
            ),
            WidgetAnimationClick(
                onTap: () {
                  currentDateTime = DateTime(currentDateTime.year, currentDateTime.month - 1);
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: Assets.icons.back.svg(width: 16),
                )),
            WidgetAnimationClick(
                onTap: () {
                  currentDateTime = DateTime(currentDateTime.year, currentDateTime.month + 1);
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: Assets.icons.next.svg(width: 16),
                )),
          ],
        ),
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemBuilder: (context, index) {
              if (index == 0) {
                return renderCalendar(DateTime(currentDateTime.year, currentDateTime.month - 1));
              }

              if (index == 2) {
                return renderCalendar(DateTime(currentDateTime.year, currentDateTime.month + 1));
              }

              return renderCalendar(currentDateTime);
            },
          ),
        ),
      ],
    );
  }

  Widget renderCalendar(DateTime dateTime) {
    return CalendarMonthView(
      dateTime: dateTime,
      weekdayTitle: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: List.generate(
            _lsWeekDay.length,
            (index) => Expanded(
              child: Text(
                _lsWeekDay[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorName.hinText),
              ),
            ),
          ),
        ),
      ),
      itemCalendarBuilder: (context, DateTime date, int index) {
        return WidgetCalendarItem(
          onTap: () {
            dateSelected = date;
            widget.onSelected.call(date);
            setState(() {});
            // Navigator.of(context).pop();
          },
          day: date,
          // colorBackground: index % 2 == 0 ? Colors.white : Colors.grey[100],
          colorBackground: Colors.transparent,
          colorSelected: ColorName.primary,
          onValidateSelected: () {
            final checkSelected = dateSelected.onlyDayMonthYear().difference(date.onlyDayMonthYear()).inDays;
            return checkSelected == 0;
          },
        );
      },
    );
  }
}

class WidgetCalendarItem extends StatelessWidget {
  const WidgetCalendarItem({
    Key? key,
    required this.day,
    required this.onValidateSelected,
    this.onTap,
    this.colorSelected,
    this.colorBackground,
    this.textStyle,
  }) : super(key: key);
  final DateTime day;
  final bool Function() onValidateSelected;
  final Function()? onTap;
  final Color? colorSelected;
  final Color? colorBackground;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return WidgetAnimationClick(
      onTap: () {
        onTap?.call();
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: onValidateSelected.call() == true ? colorSelected ?? Colors.red : colorBackground ?? Colors.white,
              border: Border.all(
                  color: onValidateSelected.call() == true
                      ? colorSelected ?? Colors.red
                      : DateTime.now().onlyDayMonthYear().difference(day.onlyDayMonthYear()).inDays == 0
                          ? colorSelected ?? Colors.red
                          : Colors.transparent)),
          child: Center(
            child: Column(
              children: [
                Text(
                  day.day.toString(),
                  style: (textStyle ?? const TextStyle(fontSize: 18)).copyWith(
                    color: onValidateSelected.call() == true ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${LunarCalendar.convertSolar2Lunar(day).first}/${LunarCalendar.convertSolar2Lunar(day)[1]}",
                  style:
                      (textStyle ?? const TextStyle(fontSize: 10)).copyWith(color: onValidateSelected.call() == true ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
