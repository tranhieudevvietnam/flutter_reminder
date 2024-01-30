import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/models/model_list_reminder.dart';
import 'package:flutter_reminder/modules/reminder/widgets/widget_app_bar_input.dart';
import 'package:flutter_reminder/services/service_data_list_reminder.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/text/widget_text_field.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';
import 'package:uuid/uuid.dart';


class PageInputList extends StatefulWidget {
  const PageInputList({super.key});

  @override
  State<PageInputList> createState() => _PageInputListState();
}

class _PageInputListState extends State<PageInputList> {
  List<dynamic> colors = [
    0xFFF14C3B,
    0xFFFFA032,
    0xFFF7CE45,
    0xFF5DC466,
    0xFF0C79FE,
    0xFFB67AD5,
    0xFF998667,
  ];

  dynamic colorSelected;

  TextEditingController nameController = TextEditingController();

  ServiceDataListReminderEvent service = ServiceDataListReminder.instant;

  @override
  void initState() {
    colorSelected = colors.first;
    super.initState();
  }

  _handleEventAdd(BuildContext context) async {
    final result = await service.insert(data: ModelListReminder(id: const Uuid().v1(), color: colorSelected, title: nameController.text, value: 0));
    nameController.clear();
    // ignore: use_build_context_synchronously
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    const widthColor = 54.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
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
                title: "New List",
                onSubmit: () async {
                  await _handleEventAdd.call(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: WidgetIconItemReminder(
                                color: Color(colorSelected),
                                size: const Size(100, 100),
                                shadows: [
                                  BoxShadow(
                                    color: Color(colorSelected),
                                    blurRadius: 20,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFE4E4E5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: WidgetTextField(
                                controller: nameController,
                                hintText: "Name",
                                style: StyleFont.bold(),
                                autofocus: true,
                                styleHint: StyleFont.bold().copyWith(color: ColorName.hinText),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: context.screenSize().width,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Wrap(
                          children: List.generate(
                              colors.length,
                              (index) => WidgetAnimationClick(
                                    onTap: () {
                                      setState(() {
                                        colorSelected = colors[index];
                                      });
                                    },
                                    child: SizedBox(
                                      width: widthColor,
                                      height: widthColor,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: widthColor - 20,
                                              height: widthColor - 20,
                                              decoration: ShapeDecoration(
                                                color: Color(colors[index]),
                                                shape: const OvalBorder(),
                                              ),
                                            ),
                                          ),
                                          if (colorSelected == colors[index])
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                                width: widthColor,
                                                height: widthColor,
                                                decoration: const ShapeDecoration(
                                                  shape: OvalBorder(
                                                    side: BorderSide(color: Color(0xFFB6B6B9), width: 3),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
