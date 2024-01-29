import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/contants/constant_data.dart';
import 'package:flutter_reminder/models/model_list_reminder.dart';
import 'package:flutter_reminder/models/model_total_count.dart';
import 'package:flutter_reminder/modules/reminder/page_home_edit.dart';
import 'package:flutter_reminder/modules/reminder/page_input_list.dart';
import 'package:flutter_reminder/modules/reminder/page_input_reminder.dart';
import 'package:flutter_reminder/services/service_data_list_reminder.dart';
import 'package:flutter_reminder/services/service_data_total_count.dart';
import 'package:flutter_reminder/utils/components/component_navigation.dart';
import 'package:flutter_reminder/utils/widgets/dialog/show_bottom_sheet_basic.dart';
import 'package:flutter_reminder/utils/widgets/reoderables/widget_reorderable_list.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_container_count.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/utils/widgets/focused_menu/focus_holder.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';
import 'package:flutter_reminder/utils/widgets/swipe_option/widget_item_swipe_option.dart';

import '../../utils/widgets/reoderables/widget_reorderable_wrap.dart';
import 'widgets/widget_item_menu_focus.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> with SingleTickerProviderStateMixin {
  ServiceDataListReminderEvent service = ServiceDataListReminder.instant;
  ServiceDataTotalCountEvent serviceTotal = ServiceDataTotalCount.instant;

  List<ModelTotalCount> listTotal = [];
  List<ModelListReminder> listReminder = [];

  ScrollController scrollController = ScrollController();
  ValueNotifier<double> opacityAppBar = ValueNotifier(0.0);
  ValueNotifier<double> opacityBottom = ValueNotifier(1.0);

  List<Map<String, Function()?>> eventCloseShowMores = [];

  @override
  void initState() {
    listReminder = service.getAll();
    listTotal = serviceTotal.getAll();

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        opacityBottom.value = 0.0;
      } else {
        opacityBottom.value = 1.0;
      }
      if (listTotal.isEmpty) {
        listTotal = ConstantData.instant.listTotal;
        await serviceTotal.updateAll(listTotal);
        setState(() {});
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
                  padding: EdgeInsets.only(top: paddingScreen.top),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(value),
                      border: Border(bottom: BorderSide(color: ColorName.hinText.withOpacity(value / 3), width: 0.3))),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      WidgetAnimationClick(
                        onTap: () async {
                          List<ModelTotalCount>? resultEdit = await ComponentNavigation.nextPage(
                            context: context,
                            child: PageHomeEdit(listReminder: listReminder, listTotal: listTotal),
                            animation: TypeAnimation.edit,
                          );
                          if (resultEdit != null) {
                            listTotal = resultEdit;
                            await service.updateAll(listData: listReminder);
                            await serviceTotal.updateAll(listTotal);
                          }
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16).copyWith(bottom: 10),
                          child: Text(
                            'Edit',
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
                child: WidgetCustomListSort<ModelListReminder>(
                  padding: const EdgeInsets.only(bottom: 16),
                  controller: scrollController,
                  onChange: (values) async {
                    await service.updateAll(listData: values as List<ModelListReminder>);
                  },
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
                      WidgetReorderableWrap(
                        listData: listTotal,
                        onChange: (values) async {
                          await serviceTotal.updateAll(listTotal);
                        },
                        buildChild: (context, index) => WidgetContainerTotalCount(
                          count: listTotal[index].value!,
                          text: listTotal[index].title!,
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
                    menu: (context, onClose, globalKey) => Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                        color: Colors.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          WidgetAnimationClick(
                            onTap: () async {
                              onClose?.call();
                              await Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                              await service.delete(listReminder[index].id!);

                              setState(() {
                                listReminder.removeAt(index);
                              });
                            },
                            child: Container(
                              key: globalKey,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: Text(
                                  "Delete",
                                  style: StyleFont.medium().copyWith(color: Colors.white),
                                ),
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
                                            color: Color(listReminder[index].color!),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              listReminder[index].title!,
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
                                            style: StyleFont.regular().copyWith(color: ColorName.hinText, height: 1.0),
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
                                  child: WidgetItemMenuFocus(
                                    title: "Display list information",
                                    color: ColorName.text,
                                    icon: Assets.icons.info.svg(width: 20),
                                  ),
                                ),
                                Container(
                                  width: ctx.screenSize().width / 2,
                                  height: .3,
                                  color: ColorName.hinText,
                                ),
                                WidgetAnimationClick(
                                  onTap: () {
                                    onClose.call();
                                  },
                                  child: WidgetItemMenuFocus(
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
            ValueListenableBuilder<double>(
              valueListenable: opacityBottom,
              builder: (context, value, child) => Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16).copyWith(bottom: paddingScreen.bottom + 16),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(value),
                    border: Border(
                      top: BorderSide(color: ColorName.hinText.withOpacity(value / 3), width: .3),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WidgetAnimationClick(
                      onTap: () {
                        ShowBottomSheetBasic.instant.show(context: context, child: const PageInputReminder());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                    ),
                    WidgetAnimationClick(
                      onTap: () async {
                        final result = await ShowBottomSheetBasic.instant.show(context: context, child: const PageInputList());
                        if (result != null) {
                          listReminder = service.getAll();
                          setState(() {});
                        }
                      },
                      child: Text(
                        "Add List",
                        style: StyleFont.regular(18).copyWith(color: ColorName.blue, height: 1.0),
                      ),
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
}
