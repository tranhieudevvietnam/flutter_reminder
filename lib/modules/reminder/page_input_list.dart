import 'package:flutter/material.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'package:flutter_reminder/utils/widgets/text/widget_text_field.dart';
import 'package:flutter_reminder/utils/widgets/widget_icon_item_reminder.dart';

import 'widgets/widget_app_bar_input.dart';

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

  @override
  void initState() {
    colorSelected = colors.first;
    super.initState();
  }

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
                title: "New List",
                onAdd: () {},
                onCancel: () {
                  Navigator.pop(context);
                },
              ),
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
                        controller: TextEditingController(),
                        hintText: "Name",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
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
                              width: 54,
                              height: 54,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 7,
                                    top: 7,
                                    child: Container(
                                      width: 40,
                                      height: 40,
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
                                        width: 54,
                                        height: 54,
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
      ),
    );
  }
}
