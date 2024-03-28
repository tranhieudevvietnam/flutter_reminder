import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/contants/constant_data.dart';
import 'package:flutter_reminder/modules/reminder/inputs/views/view_priority.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/check/widget_swip_box.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender.dart';
import 'package:flutter_reminder/utils/widgets/widget_time_picker.dart';

import 'views/view_repeat.dart';

class PageInputDetail extends StatefulWidget {
  const PageInputDetail({super.key, this.dateTimeSelected});
  final DateTime? dateTimeSelected;

  @override
  State<PageInputDetail> createState() => _PageInputDetailState();
}

class _PageInputDetailState extends State<PageInputDetail> {
  DateTime? dateSelected;
  TimeOfDay? timeSelected;
  bool showCalender = false;
  bool showTimePicker = false;

  TypeRepeat typeRepeat = TypeRepeat.never;
  TypePriority typePriority = TypePriority.normal;
  @override
  void initState() {
    dateSelected = widget.dateTimeSelected ?? dateSelected;
    dateSelected ??= DateTime.now().onlyDayMonthYear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: ColorName.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            // #region app bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(children: [
                WidgetAnimationClick(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(children: [
                    Assets.icons.back.svg(),
                    Text(
                      "New Reminder",
                      style: StyleFont.regular().copyWith(color: ColorName.blue),
                    )
                  ]),
                ),
                Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        "Detail",
                        style: StyleFont.bold(18),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: WidgetAnimationClick(
                    onTap: () {},
                    child: Text(
                      "Add",
                      textAlign: TextAlign.right,
                      style: StyleFont.regular().copyWith(color: ColorName.blue),
                    ),
                  ),
                ),
              ]),
            ),

            // #endregion

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Assets.icons.datetime.svg(),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date",
                                      style: StyleFont.medium(),
                                    ),
                                    if (dateSelected != null)
                                      Text(
                                        _getTextSelected(),
                                        style: StyleFont.regular(12).copyWith(color: ColorName.blue),
                                      ),
                                  ],
                                ),
                              ),
                              WidgetSwipeBox(
                                value: showCalender,
                                onChange: (value) {
                                  setState(() {
                                    showCalender = value;
                                  });
                                },
                              )
                            ],
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                            height: showCalender == true ? 388 : 0,
                            child: WidgetCalendar(
                              current: dateSelected,
                              onSelected: (DateTime value) {
                                // dateSelected.value = value;
                                setState(() {
                                  dateSelected = value.onlyDayMonthYear();
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: ColorName.border.withOpacity(.5),
                          ),
                          Row(
                            children: [
                              Assets.icons.time.svg(),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Time",
                                      style: StyleFont.medium(),
                                    ),
                                    if (timeSelected != null)
                                      Text(
                                        "${(timeSelected!.hour) >= 10 ? "${timeSelected!.hour}" : "0${timeSelected!.hour}"}: ${(timeSelected!.minute) >= 10 ? "${timeSelected!.minute}" : "0${timeSelected!.minute}"}",
                                        style: StyleFont.regular(12).copyWith(color: ColorName.hinText),
                                      ),
                                  ],
                                ),
                              ),
                              WidgetSwipeBox(
                                value: showTimePicker,
                                onChange: (value) {
                                  if (value == false) {
                                    timeSelected = null;
                                  } else {
                                    timeSelected = TimeOfDay.now();
                                  }
                                  setState(() {
                                    showTimePicker = value;
                                  });
                                },
                              )
                            ],
                          ),
                          AnimatedContainer(
                            color: Colors.transparent,
                            margin: EdgeInsets.symmetric(vertical: showTimePicker == true ? 16 : 0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            height: showTimePicker == true ? 150 : 0,
                            padding: EdgeInsets.symmetric(horizontal: context.screenSize().width * .15),
                            child: WidgetTimePicker(
                              onChange: (time) {
                                timeSelected = time;
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: ViewRepeat(
                        date: dateSelected!,
                        time: timeSelected,
                        typeRepeat: typeRepeat,
                        onChange: (value) {
                          typeRepeat = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: ViewPriority(
                        typePriority: typePriority,
                        onChange: (value) {
                          setState(() {
                            typePriority = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getTextSelected() {
    final dateTime = DateTime.now().onlyDayMonthYear();
    final dayTemp = dateSelected?.onlyDayMonthYear().difference(dateTime).inDays;
    switch (dayTemp) {
      case 0:
        return "Today";
      case 1:
        return "Tomorrow";
      default:
        return dateSelected?.getDayMonthYear();
    }
  }
}
