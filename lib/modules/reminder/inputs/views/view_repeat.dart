
import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/contants/constant_data.dart';
import 'package:flutter_reminder/utils/extension/time_extension.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'dart:math' as math;

class ViewRepeat extends StatefulWidget {
  const ViewRepeat({
    super.key,
    this.date,
    this.time,
    this.onChange,
    required this.typeRepeat,
  });
  final DateTime? date;
  final TimeOfDay? time;
  final TypeRepeat typeRepeat;
  final Function(TypeRepeat value)? onChange;

  @override
  State<ViewRepeat> createState() => _ViewRepeatState();
}

class _ViewRepeatState extends State<ViewRepeat> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> listData = [
    {'title': "Never", 'key': TypeRepeat.never},
    {'title': "Every day", 'key': TypeRepeat.everyDay},
    {'title': "Every week", 'key': TypeRepeat.everyWeek},
    {'title': "Every month", 'key': TypeRepeat.everyMonth},
  ];
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _offsetAnimation = Tween<double>(
    end: 180 * math.pi / 360,
    begin: 0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.time != null) {
      listData.firstWhere((element) => element['key'] == TypeRepeat.everyDay)['title'] =
          "${widget.time!.getHour()}:${widget.time!.getMinute()} every day";
    } else {
      listData.firstWhere((element) => element['key'] == TypeRepeat.everyDay)['title'] = "Every day";
    }
    if (widget.date != null) {
      listData.firstWhere((element) => element['key'] == TypeRepeat.everyWeek)['title'] = "${widget.date!.getDateTimeFormat("EEEE")} of every month";
      listData.firstWhere((element) => element['key'] == TypeRepeat.everyMonth)['title'] = "${widget.date!.day}th of every month";
    }
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (!_controller.isCompleted) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Assets.icons.repeat.svg(),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Repeat",
                  style: StyleFont.medium(),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          listData.firstWhere((element) => element['key'] == widget.typeRepeat)['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StyleFont.regular().copyWith(color: ColorName.hinText),
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: _offsetAnimation.value,
                    child: Assets.icons.arrowRight.svg(),
                  )
                ],
              ),
            )
          ]),
        ),
        AnimatedContainer(
          // margin: EdgeInsets.only(top: _offsetAnimation.value != 0 ? 16 : 0),
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.only(top: _offsetAnimation.value != 0 ? 12 : 0),
          height: _offsetAnimation.value != 0 ? 200 : 0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  listData.length,
                  (index) => Container(
                        width: context.screenSize().width,
                        decoration: BoxDecoration(
                          border: (listData.length - 1) > index ? Border(bottom: BorderSide(color: ColorName.border.withOpacity(.5))) : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _controller.reverse();
                              widget.onChange?.call(listData[index]['key']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "${listData[index]['title']}",
                                style: StyleFont.regular(),
                              ),
                            ),
                          ),
                        ),
                      ))),
        )
      ],
    );
  }
}
