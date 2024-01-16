import 'package:flutter/material.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_container_count.dart';
import 'package:flutter_reminder/utils/gen/assets.gen.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';
import 'package:flutter_reminder/utils/gen/style_font.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/utils/widgets/widget_calender_current.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Edit',
                  textAlign: TextAlign.end,
                  style: StyleFont.medium(17).copyWith(color: ColorName.blue),
                ),
              ),
              Container(
                width: context.screenSize().width,
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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
                      style: StyleFont.medium(17).copyWith(color: ColorName.hintext),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: WidgetContainerCount(
                      count: 0,
                      text: "Today",
                      icon: WidgetIconCalenderCurrent(),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: WidgetContainerCount(
                      count: 1,
                      text: "Scheluded",
                      icon: Assets.icons.calenderOrigen.svg(width: 40, height: 40),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              WidgetContainerCount(
                count: 1,
                text: "All",
                icon: Assets.icons.all.svg(width: 40, height: 40),
              )
            ],
          ),
        ),
      ),
    );
  }
}
