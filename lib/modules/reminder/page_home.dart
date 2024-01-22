import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/modules/reminder/data/data_reminder.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_list.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_container_count.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/utils/widgets/focused_menu/focus_holder.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender_current.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';
import 'package:flutter_reminder/utils/widgets/swipe_option/widget_item_swipe_option.dart';

import 'data/data_total_count.dart';
import '../../utils/widgets/reoderables/widget_reorderable_wrap.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> with SingleTickerProviderStateMixin {
  List<DataTotalCount> listTotal = [
    DataTotalCount(title: "Today", value: 0, icon: const WidgetIconCalenderCurrent()),
    DataTotalCount(title: "Scheluded", value: 0, icon: Assets.icons.calenderOrigen.svg(width: 40, height: 40)),
    DataTotalCount(title: "All", value: 0, icon: Assets.icons.all.svg(width: 40, height: 40)),
  ];
  List<DataReminder> listReminder = [
    DataReminder(color: ColorName.colorOrigen, title: "Reminders", value: 1),
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

  ScrollController scrollController = ScrollController();
  ValueNotifier<double> opacityAppBar = ValueNotifier(0.0);
  ValueNotifier<double> opacityBottom = ValueNotifier(1.0);

  List<Map<String, Function()?>> eventCloseShowMores = [];

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels < 0) {
        opacityAppBar.value = 0.0;
      } else {
        final valueTemp = scrollController.position.pixels / 10;
        if (valueTemp > 1) {
          opacityAppBar.value = 1.0;
        } else {
          opacityAppBar.value = valueTemp;
        }
      }
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        opacityBottom.value = 0.0;
      } else {
        opacityBottom.value = 1.0;
      }
    });

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        opacityBottom.value = 0.0;
      } else {
        opacityBottom.value = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets paddingScreen = MediaQuery.of(context).padding;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: eventCloseShowMores.isNotEmpty
          ? () {
              for (var element in eventCloseShowMores) {
                element.values.first?.call();
              }
            }
          : null,
      child: Scaffold(
        backgroundColor: ColorName.background,
        body: Column(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: opacityAppBar,
              builder: (ctx, value, child) => Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: context.screenSize().width,
                  padding: EdgeInsets.only(bottom: 10, top: paddingScreen.top + 16, left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(value),
                      border: Border(bottom: BorderSide(color: ColorName.hintext.withOpacity(value / 3), width: 0.3))),
                  child: Text(
                    'Edit',
                    textAlign: TextAlign.end,
                    style: StyleFont.medium(17).copyWith(color: ColorName.blue),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WidgetCustomListSort(
                  controller: scrollController,
                  iconSort: Assets.icons.menuRow.svg(),
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<double>(
                        valueListenable: opacityAppBar,
                        builder: (context, value, child) => Container(
                          width: context.screenSize().width,
                          height: 40 - (40 * value),
                          margin: const EdgeInsets.only(top: 16, bottom: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE3E3E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Assets.icons.search.svg(),
                              const SizedBox(width: 4),
                              Text(
                                'Search',
                                textAlign: TextAlign.center,
                                style: StyleFont.medium(17).copyWith(color: ColorName.hintext, height: 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      WidgetReorderableWrap(
                        listData: listTotal,
                        buildChild: (context, index) => WidgetContainerTotalCount(
                          count: listTotal[index].value,
                          text: listTotal[index].title,
                          icon: listTotal[index].icon,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "My Lists",
                          style: StyleFont.bold(22),
                        ),
                      ),
                    ],
                  ),
                  listData: listReminder,
                  buildChild: (context, index, iconSort) => WidgetItemSwipeOption(
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
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     controller: scrollController,
            //     padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 4, bottom: 50),
            //     physics: const BouncingScrollPhysics(),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         ValueListenableBuilder<double>(
            //           valueListenable: opacityAppBar,
            //           builder: (context, value, child) => Container(
            //             width: context.screenSize().width,
            //             height: 40 - (40 * value),
            //             margin: const EdgeInsets.only(top: 4, bottom: 24),
            //             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //             decoration: ShapeDecoration(
            //               color: const Color(0xFFE3E3E8),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10),
            //               ),
            //             ),
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Assets.icons.search.svg(),
            //                 const SizedBox(width: 4),
            //                 Text(
            //                   'Search',
            //                   textAlign: TextAlign.center,
            //                   style: StyleFont.medium(17).copyWith(color: ColorName.hintext, height: 1.0),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //         WidgetReorderableWrap(
            //           listData: listTotal,
            //           buildChild: (context, index) => WidgetContainerTotalCount(
            //             count: listTotal[index].value,
            //             text: listTotal[index].title,
            //             icon: listTotal[index].icon,
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           child: Text(
            //             "My Lists",
            //             style: StyleFont.bold(22),
            //           ),
            //         ),
            //         ...List.generate(
            //           listReminder.length,
            //           (index) => Padding(
            //             padding: const EdgeInsets.only(bottom: 10),
            //             child: WidgetItemSwipeOption(
            //               color: Colors.red,
            //               borderRadius: 14,
            //               callBackClose: (event) {
            //                 setState(() {
            //                   eventCloseShowMores.add({"$index": event});
            //                 });
            //               },
            //               menu: (context, globalKey) => Container(
            //                 decoration: const BoxDecoration(
            //                   borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
            //                   color: Colors.red,
            //                 ),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.end,
            //                   children: [
            //                     WidgetAnimationClick(
            //                       onTap: () {},
            //                       child: Padding(
            //                         key: globalKey,
            //                         padding: const EdgeInsets.symmetric(horizontal: 16),
            //                         child: Text(
            //                           "Delete",
            //                           style: StyleFont.medium().copyWith(color: Colors.white),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               child: FocusedHolder(
            //                 buildChild: (context, onLongPress) => Container(
            //                   // margin: const EdgeInsets.only(bottom: 12),
            //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //                   clipBehavior: Clip.antiAlias,
            //                   decoration: ShapeDecoration(
            //                     color: Colors.white,
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(12),
            //                     ),
            //                   ),
            //                   child: Row(
            //                     children: [
            //                       Expanded(
            //                         child: Row(
            //                           children: [
            //                             WidgetIconItemReminder(
            //                               color: listReminder[index].color,
            //                             ),
            //                             const SizedBox(
            //                               width: 10,
            //                             ),
            //                             Expanded(
            //                               child: Text(
            //                                 listReminder[index].title,
            //                                 maxLines: 1,
            //                                 overflow: TextOverflow.ellipsis,
            //                                 style: StyleFont.regular(),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       Row(
            //                         children: [
            //                           Padding(
            //                             padding: const EdgeInsets.symmetric(horizontal: 5),
            //                             child: Text(
            //                               "${listReminder[index].value}",
            //                               style: StyleFont.regular().copyWith(color: ColorName.hintext, height: 1.0),
            //                             ),
            //                           ),
            //                           Assets.icons.arrowRight.svg()
            //                         ],
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //                 childMenu: (ctx, globalKey, onClose) {
            //                   return Container(
            //                     key: globalKey,
            //                     width: ctx.screenSize().width / 2,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(16),
            //                       color: Colors.white,
            //                     ),
            //                     child: Column(
            //                       children: [
            //                         WidgetAnimationClick(
            //                           onTap: () {
            //                             onClose.call();
            //                           },
            //                           child: _buildItemMenuFocus(
            //                             title: "Display list information",
            //                             color: ColorName.text,
            //                             icon: Assets.icons.info.svg(width: 20),
            //                           ),
            //                         ),
            //                         Container(
            //                           width: ctx.screenSize().width / 2,
            //                           height: .3,
            //                           color: ColorName.hintext,
            //                         ),
            //                         WidgetAnimationClick(
            //                           onTap: () {
            //                             onClose.call();
            //                           },
            //                           child: _buildItemMenuFocus(
            //                             title: "Delete",
            //                             color: Colors.red,
            //                             icon: Assets.icons.delete.svg(
            //                               color: Colors.red,
            //                               width: 20,
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   );
            //                 },
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            ValueListenableBuilder<double>(
              valueListenable: opacityBottom,
              builder: (context, value, child) => Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16).copyWith(bottom: paddingScreen.bottom + 16),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(value),
                    border: Border(
                      top: BorderSide(color: ColorName.hintext.withOpacity(value / 3), width: .3),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Assets.icons.add.svg(),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "New Reminder",
                          style: StyleFont.bold(18).copyWith(color: ColorName.blue, height: 1.0),
                        )
                      ],
                    ),
                    Text(
                      "Add List",
                      style: StyleFont.regular(18).copyWith(color: ColorName.blue, height: 1.0),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
