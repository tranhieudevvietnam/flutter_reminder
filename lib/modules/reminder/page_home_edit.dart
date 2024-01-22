import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/check/widget_check_box.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_list.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender_current.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';

import 'data/data_reminder.dart';
import 'data/data_total_count.dart';
import 'package:flutter_component/flutter_component.dart';

// ignore: must_be_immutable
class PageHomeEdit extends StatefulWidget {
  PageHomeEdit({super.key, required this.listReminder, required this.listTotal});
  List<DataReminder> listReminder;
  List<String> listTotal;
  @override
  State<PageHomeEdit> createState() => _PageHomeEditState();
}

class _PageHomeEditState extends State<PageHomeEdit> {
  ScrollController scrollController = ScrollController();
  ValueNotifier<double> opacityAppBar = ValueNotifier(0.0);

  List<DataTotalCount> listTotalDefault = [
    DataTotalCount(
        title: "Today",
        value: 0,
        icon: WidgetIconCalenderCurrent(
          dateTime: DateTime.now(),
        )),
    DataTotalCount(
        title: "Yesterday",
        value: 0,
        icon: WidgetIconCalenderCurrent(
          color: Colors.red,
          dateTime: DateTime.now().add(const Duration(days: -1)),
        )),
    DataTotalCount(title: "Scheluded", value: 0, icon: Assets.icons.calenderOrigen.svg(width: 40, height: 40)),
    DataTotalCount(title: "All", value: 0, icon: Assets.icons.all.svg(width: 40, height: 40)),
    DataTotalCount(title: "Done", value: 0, icon: Assets.icons.allDone.svg(width: 40, height: 40)),
  ];

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
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets paddingScreen = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: ColorName.background,
      body: Column(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: opacityAppBar,
            builder: (ctx, value, child) => Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(top: paddingScreen.top),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(value),
                    border: Border(bottom: BorderSide(color: ColorName.hinText.withOpacity(value / 3), width: 0.3))),
                child: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    WidgetAnimationClick(
                      onTap: () {
                        ///TODO: handle done
                        Navigator.pop(
                          context,
                          listTotalDefault.where((element) => widget.listTotal.contains(element.title)).toList(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16).copyWith(bottom: 10),
                        child: Text(
                          'Done',
                          textAlign: TextAlign.end,
                          style: StyleFont.medium(17).copyWith(color: ColorName.blue),
                        ),
                      ),
                    ),
                  ],
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
                              style: StyleFont.medium(17).copyWith(color: ColorName.hinText, height: 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    WidgetCustomListSort(
                      iconSort: Assets.icons.menuRow.svg(),
                      listData: listTotalDefault,
                      shrinkWrap: true,
                      buildChild: (context, index, iconSort) => Container(
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
                                  WidgetCheckBox(
                                    value: widget.listTotal.contains(listTotalDefault[index].title),
                                    padding: const EdgeInsets.only(right: 16),
                                    onChange: (value) {
                                      if (value == true) {
                                        widget.listTotal.add(listTotalDefault[index].title);
                                      } else {
                                        widget.listTotal.remove(listTotalDefault[index].title);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  listTotalDefault[index].icon,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      listTotalDefault[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: StyleFont.regular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            iconSort
                          ],
                        ),
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
                listData: widget.listReminder,
                buildChild: (context, index, iconSort) => Container(
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
                            WidgetAnimationClick(
                              onTap: () {
                                setState(() {
                                  widget.listReminder.removeAt(index);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Assets.icons.remove.svg(),
                              ),
                            ),
                            WidgetIconItemReminder(
                              color: widget.listReminder[index].color,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                widget.listReminder[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: StyleFont.regular(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      iconSort
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
