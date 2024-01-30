import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/contants/constant_data.dart';
import 'package:flutter_reminder/utils/gen/gen_export.dart';
import 'dart:math' as math;

class ViewPriority extends StatefulWidget {
  const ViewPriority({
    super.key,
    this.onChange,
    required this.typePriority,
  });
  final TypePriority typePriority;
  final Function(TypePriority value)? onChange;

  @override
  State<ViewPriority> createState() => _ViewPriorityState();
}

class _ViewPriorityState extends State<ViewPriority> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> listData = [
    {'title': "Normal", 'key': TypePriority.normal},
    {'title': "Slow", 'key': TypePriority.slow},
    {'title': "High", 'key': TypePriority.high},
    {'title': "Very high", 'key': TypePriority.veryHigh},
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
            Text(
              "Priority",
              style: StyleFont.medium(),
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
                          listData.firstWhere((element) => element['key'] == widget.typePriority)['title'],
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
                  _offsetAnimation.value != 0 ? listData.length : 0,
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
