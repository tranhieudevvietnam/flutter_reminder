import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_app_bar_input.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_calender_icon.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/text/widget_text_field.dart';

class PageInputReminder extends StatefulWidget {
  const PageInputReminder({super.key});

  @override
  State<PageInputReminder> createState() => _PageInputReminderState();
}

class _PageInputReminderState extends State<PageInputReminder> with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final dateTimeCurrent = DateTime.now().onlyDayMonthYear();
  DateTime dateTimeSelected = DateTime.now().onlyDayMonthYear();

  List<Map<String, dynamic>> listDateTime = [];
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    end: Offset.zero,
    begin: const Offset(0.0, 2.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    listDateTime = [
      {'title': 'Today', 'dateTime': dateTimeCurrent},
      {'title': 'Tomorrow', 'dateTime': dateTimeCurrent.add(const Duration(days: 1))},
      {'title': 'This Weekend', 'dateTime': dateTimeCurrent.add(Duration(days: DateTime.daysPerWeek - dateTimeCurrent.weekday))},
      {'title': 'Date & Time', 'dateTime': null},
    ];
    super.initState();
  }

  String _getTitleByDateTime() {
    final dataTemp = listDateTime.firstWhere((element) {
      final dateTimeTemp = element['dateTime'];
      if (dateTimeTemp != null && dateTimeTemp is DateTime) {
        if (dateTimeTemp.difference(dateTimeSelected).inDays == 0) {
          return true;
        }
      }
      return false;
    });
    return dataTemp['title'];
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    WidgetAppBarInput(
                      title: "New Reminder",
                      onAdd: () {},
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          WidgetTextField(
                            hintText: "Title",
                            controller: titleController,
                            autofocus: true,
                          ),
                          Container(
                            width: context.screenSize().width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: .5,
                            color: ColorName.border,
                          ),
                          WidgetTextField(
                            hintText: "Notes",
                            controller: notesController,
                            maxLines: 5,
                            minLines: 3,
                          ),
                        ],
                      ),
                    ),
                    WidgetAnimationClick(
                      onTap: () {
                        if (_offsetAnimation.value.dy == 2.0) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details",
                                style: StyleFont.medium(),
                              ),
                              Text(
                                _getTitleByDateTime(),
                                style: StyleFont.regular(14).copyWith(color: ColorName.hinText),
                              ),
                            ],
                          ),
                          Assets.icons.arrowRight.svg()
                        ]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(
                          "List",
                          style: StyleFont.medium(),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: ColorName.primary),
                              ),
                              Text(
                                "List",
                                style: StyleFont.regular(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Assets.icons.arrowRight.svg()
                            ],
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    listDateTime.length,
                    (index) => Expanded(
                          child: WidgetAnimationClick(
                            onTap: () {
                              setState(() {
                                dateTimeSelected = listDateTime[index]['dateTime'];
                              });

                              _controller.reverse();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Opacity(
                                opacity: (listDateTime[index]['dateTime'])?.difference(dateTimeSelected).inDays == 0 ? 1.0 : 0.5,
                                child: _buildItemSelectDatetime(
                                  dateTime: listDateTime[index]['dateTime'],
                                  title: listDateTime[index]['title'],
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemSelectDatetime({DateTime? dateTime, required String title}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(color: ColorName.border.withOpacity(.5))),
          child: Center(
            child: WidgetIconCalenderIcon(
              dateTime: dateTime,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: StyleFont.regular(12),
        )
      ],
    );
  }
}
