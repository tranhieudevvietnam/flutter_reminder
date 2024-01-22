import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_app_bar_input.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/text/widget_text_field.dart';

class PageInputReminder extends StatefulWidget {
  const PageInputReminder({super.key});

  @override
  State<PageInputReminder> createState() => _PageInputReminderState();
}

class _PageInputReminderState extends State<PageInputReminder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
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
                decoration: BoxDecoration(
                    border: Border.all(color: ColorName.border, width: .5), color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    WidgetTextField(hintText: "title", controller: TextEditingController()),
                    Container(
                      width: context.screenSize().width,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: .5,
                      color: ColorName.border,
                    ),
                    WidgetTextField(
                      hintText: "Notes",
                      controller: TextEditingController(),
                      maxLines: 5,
                      minLines: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
