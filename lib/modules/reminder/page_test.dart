import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/modules/reminder/data/data_reminder.dart';
import 'package:flutter_reminder/modules/reminder/data/data_total_count.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_list.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_wrap.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';
import 'package:flutter_reminder/utils/widgets/focused_menu/focus_holder.dart';
import 'package:flutter_reminder/utils/widgets/swipe_option/widget_item_swipe_option.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender_current.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';

import 'widgets/widget_container_count.dart';

class PageTest extends StatefulWidget {
  const PageTest({super.key});

  @override
  State<PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ReorderableExample()),
    );
  }
}

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _ReorderableListViewExampleState();
}

class _ReorderableListViewExampleState extends State<ReorderableExample> {
  // final List<int> _items = List<int>.generate(50, (int index) => index);
  List<DataTotalCount> listTotal = [
    DataTotalCount(title: "Today", value: 0, icon: const WidgetIconCalenderCurrent()),
    DataTotalCount(title: "Scheluded", value: 0, icon: Assets.icons.calenderOrigen.svg(width: 40, height: 40)),
    DataTotalCount(title: "All", value: 0, icon: Assets.icons.all.svg(width: 40, height: 40)),
  ];
  List<DataReminder> listReminder = [
    DataReminder(color: ColorName.colorOrigen, title: "Reminders", value: 1),
    DataReminder(color: ColorName.blue, title: "Reminders2 Reminders2 Reminders2 Reminders2 Reminders2 Reminders2 Reminders2 ", value: 999),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
    DataReminder(color: ColorName.blue, title: "Reminders2", value: 2),
  ];

  List<Map<String, Function()?>> eventCloseShowMores = [];

  // Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  //   return AnimatedBuilder(
  //     animation: animation,
  //     builder: (BuildContext context, Widget? child) {
  //       final double animValue = Curves.easeInOut.transform(animation.value);
  //       // final double elevation = lerpDouble(1, 6, animValue)!;
  //       final double scale = lerpDouble(1, 1.05, animValue)!;
  //       return Transform.scale(
  //         scale: scale,
  //         // Create a Card based on the color and the content of the dragged one
  //         // and set its elevation to the animated value.
  //         child: child,
  //       );
  //     },
  //     child: child,
  //   );
  // }

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // const WrapExample(),
          Expanded(
            child: WidgetCustomListSort(
              header: WidgetReorderableWrap(
                listData: listTotal,
                buildChild: (context, index) => WidgetContainerTotalCount(
                  count: listTotal[index].value,
                  text: listTotal[index].title,
                  icon: listTotal[index].icon,
                ),
              ),
              listData: listReminder,
              iconSort: Assets.icons.menuRow.svg(),
              buildChild: (context, index, iconSort) {
                return WidgetItemSwipeOption(
                  color: Colors.red,
                  borderRadius: 14,
                  callBackClose: (event) {
                    setState(() {
                      eventCloseShowMores.add({"$index": event});
                    });
                  },
                  menu: (context, globalKey) => Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                      color: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        WidgetAnimationClick(
                          onTap: () {},
                          child: Padding(
                            key: globalKey,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Delete",
                              style: StyleFont.medium().copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: FocusedHolder(
                      buildChild: (context, onLongPress) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onLongPress: onLongPress,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8).copyWith(left: 12),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        WidgetIconItemReminder(
                                          color: listReminder[index].color,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            listReminder[index].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: StyleFont.regular(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5).copyWith(left: 10),
                                        child: Text(
                                          "${listReminder[index].value}",
                                          style: StyleFont.regular().copyWith(color: ColorName.hintext, height: 1.0),
                                        ),
                                      ),
                                      iconSort

                                      // Assets.icons.arrowRight.svg()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      childMenu: (ctx, globalKey, onClose) {
                        return Container(
                          key: globalKey,
                          width: ctx.screenSize().width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              WidgetAnimationClick(
                                onTap: () {
                                  onClose.call();
                                },
                                child: _buildItemMenuFocus(
                                  title: "Display list information",
                                  color: ColorName.text,
                                  icon: Assets.icons.info.svg(width: 20),
                                ),
                              ),
                              Container(
                                width: ctx.screenSize().width / 2,
                                height: .3,
                                color: ColorName.hintext,
                              ),
                              WidgetAnimationClick(
                                onTap: () {
                                  onClose.call();
                                },
                                child: _buildItemMenuFocus(
                                  title: "Delete",
                                  color: Colors.red,
                                  icon: Assets.icons.delete.svg(
                                    color: Colors.red,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16),
    //   child: Theme(
    //     data: ThemeData(
    //       canvasColor: Colors.transparent,
    //       shadowColor: Colors.transparent,
    //       dialogBackgroundColor: Colors.transparent,
    //       colorScheme: Theme.of(context).colorScheme.copyWith(
    //             background: Colors.transparent,
    //             shadow: ColorName.hintext.withOpacity(.1),
    //           ),
    //     ),
    //     child: ReorderableListView(
    //       proxyDecorator: proxyDecorator,
    //       children: List.generate(
    //         listReminder.length,
    //         (index) => Container(
    //           key: Key('$index'),
    //           margin: const EdgeInsets.symmetric(vertical: 5),
    //           height: 80,
    //           color: Colors.red,
    //           child: Center(
    //             child: Text('Card $index'),
    //           ),
    //         ),
    //       ),
    //       onReorder: (int oldIndex, int newIndex) {
    //         setState(() {
    //           if (oldIndex < newIndex) {
    //             newIndex -= 1;
    //           }
    //           final item = listReminder.removeAt(oldIndex);
    //           listReminder.insert(newIndex, item);
    //         });
    //       },
    //     ),
    //   ),
    // );
  }

  Widget _buildItemMenuFocus({required String title, required Widget icon, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: StyleFont.regular().copyWith(color: color ?? Colors.red),
            ),
          ),
          icon
        ],
      ),
    );
  }
}
