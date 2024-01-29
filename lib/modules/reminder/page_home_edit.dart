import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/contants/constant_data.dart';
import 'package:flutter_reminder/models/model_list_reminder.dart';
import 'package:flutter_reminder/models/model_total_count.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/check/widget_check_box.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_list.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';

import 'package:flutter_component/flutter_component.dart';

// ignore: must_be_immutable
class PageHomeEdit extends StatefulWidget {
  PageHomeEdit({super.key, required this.listReminder, required this.listTotal});
  List<ModelListReminder> listReminder;
  List<ModelTotalCount> listTotal;
  @override
  State<PageHomeEdit> createState() => _PageHomeEditState();
}

class _PageHomeEditState extends State<PageHomeEdit> {
  ScrollController scrollController = ScrollController();
  ValueNotifier<double> opacityAppBar = ValueNotifier(0.0);

  List<ModelTotalCount> listTotalDefault = ConstantData.instant.listTotalNoneId;
  List<ModelTotalCount> listTotalChange = [];

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
    final listTitleTemp = widget.listTotal.map((e) => e.title).toList();

    listTotalChange = [
      ...widget.listTotal,
      ...listTotalDefault.where((element) => !listTitleTemp.contains(element.title)).toList(),
    ];

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
                          listTotalChange.where((element) => element.selected == true).toList(),
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
                      listData: listTotalChange,
                      physics: const NeverScrollableScrollPhysics(),
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
                                    value: listTotalChange[index].selected ?? false,
                                    padding: const EdgeInsets.only(right: 16),
                                    onChange: (value) {
                                      listTotalChange[index].selected = value;
                                      setState(() {});
                                    },
                                  ),
                                  listTotalChange[index].icon,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      listTotalChange[index].title!,
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
                              color: Color(widget.listReminder[index].color!),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                widget.listReminder[index].title!,
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
