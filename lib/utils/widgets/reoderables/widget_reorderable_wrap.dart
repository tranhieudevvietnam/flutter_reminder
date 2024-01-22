import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';

typedef BuildChildWidget = Widget Function(BuildContext context, int index);

class DataReorderableWrap {
  late GlobalKey globalKey;
  Offset offset;
  Size size;

  DataReorderableWrap({required this.offset, required this.size}) {
    globalKey = GlobalKey();
  }
}

// ignore: must_be_immutable
class WidgetReorderableWrap extends StatefulWidget {
  WidgetReorderableWrap({super.key, required this.listData, required this.buildChild});
  List<DataReorderableWrap> listData;
  final BuildChildWidget buildChild;

  @override
  State<WidgetReorderableWrap> createState() => _WidgetReorderableWrapState();
}

class _WidgetReorderableWrapState extends State<WidgetReorderableWrap> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController selectedAnimationController;
  late Animation<double> animation;

  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;

  int indexSelected = -1;
  Size? sizeItemSelected;
  GlobalKey globalKeySelected = GlobalKey();

  StreamController streamController = StreamController();

  Offset positionStart = const Offset(0, 0);
  Offset positionCurrent = const Offset(0, 0);
  Offset? positionCurrentNew;
  late BuildContext contextScreen;
  @override
  void initState() {
    selectedAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(parent: selectedAnimationController, curve: Curves.easeInOut);
    animation.addListener(() {
      if (selectedAnimationController.isDismissed == true) {
        indexSelected = -1;
      }
      streamController.sink.add(null);
    });

    _moveController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this)
      ..addStatusListener(
        _handleDismissStatusChanged,
      );

    _updateMoveAnimation();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _renderUI();
    });
  }

  _renderUI() {
    for (var element in widget.listData) {
      final renderBoxTemp = element.globalKey.currentContext!.findRenderObject()! as RenderBox;
      Offset offset = renderBoxTemp.localToGlobal(Offset.zero);
      Size size = renderBoxTemp.size;

      element.offset = _convertOffsetScreen(offset);
      element.size = size;
    }
  }

  Offset _convertOffsetScreen(Offset offset) {
    RenderBox? renderBoxTempScreen = context.findRenderObject() as RenderBox;
    Offset offsetScreen = renderBoxTempScreen.globalToLocal(offset);
    return offsetScreen;
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    updateKeepAlive();
  }

  void _updateMoveAnimation() {
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: positionCurrent,
        end: positionCurrentNew ?? positionCurrent,
      ),
    );
    streamController.sink.add(null);
  }

  _onChangePosition() {
    final renderBoxTemp = globalKeySelected.currentContext!.findRenderObject()! as RenderBox;
    Offset offset = renderBoxTemp.localToGlobal(Offset.zero);
    final positionDone = _convertOffsetScreen(offset);
    // debugPrint("onLongPressCancel==1====>$positionDone");

    final indexTemp = widget.listData.indexWhere((element) {
      // debugPrint("widget.listData======>offset:${element.offset}  size:${element.size}");
      // debugPrint("positionDone======>$positionDone");
      if ((element.offset.dx - element.size.width / 2) < positionDone.dx && positionDone.dx < (element.offset.dx + element.size.width / 2)) {
        if ((element.offset.dy - element.size.height / 2) < positionDone.dy && positionDone.dy < (element.offset.dy + element.size.height / 2)) {
          return true;
        }
        return false;
      }

      return false;
    });
    // debugPrint("index insert====>$indexTemp");
    if (indexTemp == indexSelected || indexTemp < 0) return;
    final item = widget.listData.removeAt(indexSelected);
    widget.listData.insert(indexTemp, item);
    setState(() {});
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _renderUI();
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Future.delayed(const Duration(milliseconds: 600), () {
      _renderUI();
      debugPrint("_renderUI");
    });

    contextScreen = context;
    debugPrint("height screen ====> ${context.screenSize().height}");
    return Listener(
      onPointerDown: (event) {
        // debugPrint("onPointerDown=====>${event.position}");
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            final renderBoxTemp = widget.listData[indexSelected].globalKey.currentContext!.findRenderObject()! as RenderBox;
            Offset offset = renderBoxTemp.globalToLocal(event.position);
            positionStart = Offset(offset.dx, offset.dy);
          },
        );
        // debugPrint("onPointerDown=====>$positionStart");
        // debugPrint("onPointerDown===renderBox.size.height====> W:${renderBox.size.width} == H:${renderBox.size.height}");
      },
      onPointerMove: (event) {
        // debugPrint("onPointerMove=====>$positionCurrent/${event.position}");
        RenderBox? renderBoxTemp = context.findRenderObject() as RenderBox;
        Offset offset = renderBoxTemp.globalToLocal(event.position);
        // debugPrint("onPointerMove=====>$offset");

        positionCurrentNew = Offset(offset.dx - positionStart.dx, offset.dy - positionStart.dy);
        _updateMoveAnimation();
      },
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: buildBodyWrap<DataReorderableWrap>(
              context: context,
              countRow: 2,
              data: widget.listData,
              buildItem: (index) {
                return WidgetItemReorderableWrap(
                  buildChild: widget.buildChild,
                  animation: animation,
                  selectedAnimationController: selectedAnimationController,
                  index: index,
                  globalKey: widget.listData[index].globalKey,
                  onLongPressCancel: () {
                    _onChangePosition();
                  },
                  onLongPress: () {
                    indexSelected = index;
                    sizeItemSelected = _getSizeByKey(widget.listData[index].globalKey);
                    _getOffset(widget.listData[index].globalKey);
                  },
                );
              },
            ),
          ),
          StreamBuilder(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (indexSelected >= 0) {
                return Positioned(
                  left: _moveAnimation.value.dx,
                  top: _moveAnimation.value.dy,
                  child: SizedBox(
                    key: globalKeySelected,
                    width: sizeItemSelected?.width ?? 0,
                    height: sizeItemSelected?.height != null ? sizeItemSelected!.height + 8 : 0, // 8 - elevation
                    child: WidgetItemSelectedReorderableWrap(
                      animation: animation,
                      buildChild: (context) {
                        return widget.buildChild.call(context, indexSelected);
                      },
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }

  List<Widget> buildBodyWrap<T>({
    required BuildContext context,
    required int countRow,
    bool lastItem = true,
    int index = 0,
    required List<T>? data,
    List<Widget>? listChild,
    double vertical = 10,
    double horizontal = 10,
    Function(BuildContext context)? buildLoading,
    required Function(int index) buildItem,
  }) {
    listChild ??= [];
    List<Widget> listChildRow = [];

    if (data != null) {
      for (int i = index; i < index + countRow; i++) {
        if (i < data.length) {
          listChildRow.add(
            Expanded(child: buildItem.call(i)),
          );
          // if (i < (data.length - 1) && (i < (index + countRow - 1))) {
          if (i < (index + countRow - 1)) {
            listChildRow.add(SizedBox(
              width: horizontal,
            ));
          }
        } else {
          listChildRow.add(const Expanded(child: SizedBox()));
        }
      }
    }

    listChild.add(Padding(
      padding: EdgeInsets.symmetric(vertical: vertical / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listChildRow,
      ),
    ));

    if ((index + countRow) < (data?.length ?? 0)) {
      buildBodyWrap(
          index: index + countRow, data: data, listChild: listChild, buildItem: buildItem, context: context, countRow: countRow, lastItem: lastItem);
    } else {
      if (lastItem == false) {
        listChild.add(buildLoading?.call(context) ?? const SizedBox());
      } else {
        listChild.add(const SizedBox());
      }
    }

    return listChild;
  }

  Size _getSizeByKey(GlobalKey globalKey) {
    RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    // debugPrint("_getSizeByKey====>$size");
    return size;
  }

  void _getOffset(GlobalKey globalKey) {
    final renderBoxTemp = globalKey.currentContext!.findRenderObject()! as RenderBox;
    // RenderBox? renderBoxTempCurrent = context.findRenderObject() as RenderBox;

    Offset offset = (contextScreen.findRenderObject()! as RenderBox).globalToLocal(renderBoxTemp.localToGlobal(Offset.zero));
    // debugPrint("onLongPress==offset===>$offset");
    positionCurrent = Offset(offset.dx, offset.dy - (8 - 5)); // 8-elevation , 5-margin, 16-padding horizontal
    // debugPrint("onLongPress==positionCurrent===>$positionCurrent");
    positionCurrentNew = null;
    _updateMoveAnimation();
    _moveController?.value = 1;
  }

  @override
  bool get wantKeepAlive => _moveController?.isAnimating == true;
}

// ignore: must_be_immutable
class WidgetItemReorderableWrap extends StatefulWidget {
  const WidgetItemReorderableWrap(
      {super.key,
      required this.buildChild,
      required this.animation,
      required this.selectedAnimationController,
      required this.index,
      required this.onLongPressCancel,
      required this.onLongPress,
      required this.globalKey});

  final BuildChildWidget buildChild;
  final Animation<double> animation;
  final int index;
  final AnimationController selectedAnimationController;
  final Function() onLongPress;
  final Function() onLongPressCancel;
  final GlobalKey globalKey;

  @override
  State<WidgetItemReorderableWrap> createState() => _WidgetItemReorderableWrapState();
}

class _WidgetItemReorderableWrapState extends State<WidgetItemReorderableWrap> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    // GlobalKey globalKey = GlobalKey();
    return GestureDetector(
      key: widget.globalKey,
      behavior: HitTestBehavior.translucent,
      onLongPressEnd: (details) {
        setState(() {
          selected = false;
        });
        debugPrint("onLongPressEnd=====??");
        widget.selectedAnimationController.reverse();
        widget.onLongPressCancel.call();
      },
      onLongPress: () {
        setState(() {
          selected = true;
        });
        widget.onLongPress.call();
        widget.selectedAnimationController.forward();
      },
      child: Opacity(
        opacity: selected ? 0.5 : 1.0,
        child: widget.buildChild.call(context, widget.index),
      ),
    );
  }
}

class WidgetItemSelectedReorderableWrap extends StatefulWidget {
  const WidgetItemSelectedReorderableWrap({
    super.key,
    required this.buildChild,
    required this.animation,
  });
  final Widget Function(BuildContext context) buildChild;
  final Animation<double> animation;

  @override
  State<WidgetItemSelectedReorderableWrap> createState() => _WidgetItemSelectedReorderableWrapState();
}

class _WidgetItemSelectedReorderableWrapState extends State<WidgetItemSelectedReorderableWrap> {
  @override
  Widget build(BuildContext context) {
    final double scale = lerpDouble(1, 1.05, widget.animation.value)!;
    return Transform.scale(
      scale: scale,
      child: Card(
        elevation: scale == 1 ? 0 : 8,
        shadowColor: ColorName.hinText.withOpacity(.3),
        child: widget.buildChild.call(context),
      ),
    );
  }
}
