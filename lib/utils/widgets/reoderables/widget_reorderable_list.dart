import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';

typedef BuildChildWidget = Widget Function(BuildContext context, int index, Widget iconSort);

// ignore: must_be_immutable
class WidgetCustomListSort<T> extends StatefulWidget {
  WidgetCustomListSort({
    super.key,
    required this.listData,
    required this.buildChild,
    this.onChange,
    this.iconSort,
    this.controller,
    this.header,
  });
  List<T> listData;
  final BuildChildWidget buildChild;
  final Widget? iconSort;
  final Function(List<T> values)? onChange;
  final ScrollController? controller;
  final Widget? header;

  @override
  State<WidgetCustomListSort> createState() => _WidgetCustomListSortState<T>();
}

class _WidgetCustomListSortState<T> extends State<WidgetCustomListSort> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
        dialogBackgroundColor: Colors.transparent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.transparent,
              shadow: ColorName.hintext.withOpacity(.1),
            ),
      ),
      child: ReorderableListView(
        scrollController: widget.controller,
        proxyDecorator: proxyDecorator,
        header: widget.header,
        shrinkWrap: widget.controller != null,
        children: List.generate(
          widget.listData.length,
          (index) => Container(
            key: Key('$index'),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: widget.buildChild.call(
              context,
              index,
              ReorderableDragStartListener(
                index: index,
                child: widget.iconSort ?? const Icon(Icons.drag_handle_rounded),
              ),
            ),
          ),
        ),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = widget.listData.removeAt(oldIndex);
            widget.listData.insert(newIndex, item);
            widget.onChange?.call(widget.listData);
          });
        },
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.05, animValue)!;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }
}
