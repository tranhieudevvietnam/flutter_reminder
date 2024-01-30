import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/check/widget_swip_box.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender.dart';
import 'package:flutter_reminder/utils/widgets/widget_time_picker.dart';

class PageInputDetail extends StatefulWidget {
  const PageInputDetail({super.key, required this.dateTimeSelected});
  final DateTime dateTimeSelected;

  @override
  State<PageInputDetail> createState() => _PageInputDetailState();
}

class _PageInputDetailState extends State<PageInputDetail> {
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
            Row(children: [
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

            // #endregion

            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  SizedBox(
                    height: 388,
                    child: WidgetCalendar(
                      onSelected: (DateTime value) {
                        // dateSelected.value = value;
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
                        child: Text(
                          "Time",
                          style: StyleFont.medium(),
                        ),
                      ),
                      WidgetSwipeBox(
                        value: true,
                        onChange: (value) {
                          debugPrint("xxxx===>$value");
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    child: WidgetTimePicker(
                      onChange: (time) {},
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
