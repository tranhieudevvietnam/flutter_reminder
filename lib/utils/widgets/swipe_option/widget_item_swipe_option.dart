import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/widgets/swipe_option/card_tile.dart';

typedef BuildWidget = Widget Function(BuildContext context, Function()? onClose, GlobalKey? globalKey);

class WidgetItemSwipeOption extends StatefulWidget {
  const WidgetItemSwipeOption({
    Key? key,
    required this.child,
    required this.menu,
    required this.borderRadius,
    required this.color,
    required this.callBackClose,
  }) : super(key: key);
  final Widget child;
  final BuildWidget menu;
  final double borderRadius;
  final Color color;
  final Function(Function()? event) callBackClose;

  @override
  State<WidgetItemSwipeOption> createState() => _WidgetItemSwipeOptionState();
}

class _WidgetItemSwipeOptionState extends State<WidgetItemSwipeOption> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _moveController;
  late AnimationController _deleteController;
  late Animation<Offset> _moveAnimation;
  late Animation<double> _deleteAnimation;

  double _dragExtent = 0.0;

  GlobalKey globalKeyMenu = GlobalKey();

  @override
  void initState() {
    _moveController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this)
      ..addStatusListener(
        _handleDismissStatusChanged,
      );
    _deleteController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _deleteAnimation = Tween<double>(begin: 1, end: .5).animate(_deleteController)
      ..addListener(() {
        setState(() {});
      });
    _updateMoveAnimation();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.callBackClose.call(_moveController!.value > 0.0
          ? () {
              _moveController!.reverse();
              // _dragExtent = 0.0;
              setState(() {
                _updateMoveAnimation();
              });
            }
          : null);
    });
  }

  @override
  void dispose() {
    _moveController?.dispose();
    _deleteController.dispose();
    super.dispose();
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    // debugPrint("status=====>$status");
    if (status == AnimationStatus.dismissed) {
      _deleteController.reverse();
      _dragExtent = 0.0;
      // _moveController!.value = .0;
      setState(() {
        _updateMoveAnimation();
      });
    }

    updateKeepAlive();
  }

  void _updateMoveAnimation() {
    double valueMenu = .25;

    try {
      valueMenu = _getSizeMenu().width / _overallDragAxisExtent;
    } catch (e) {}

    final double endOffsetX = _dragExtent.sign != 0 ? -valueMenu : _dragExtent.sign;

    ///TODO: Changed: DONE
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(endOffsetX, 0),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _updateMoveAnimation();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta!;
    final double oldDragExtent = _dragExtent;
    // debugPrint("delta===> $delta");
    // debugPrint("oldDragExtent===> $oldDragExtent");
    if (_dragExtent + delta < 0) _dragExtent += delta;
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
    final value = _dragExtent.abs() / (_overallDragAxisExtent / 4);
    if (!_moveController!.isAnimating) {
      // debugPrint(" _dragExtent ===>$_dragExtent");
      // debugPrint(" _dragExtent.abs() / _overallDragAxisExtent ===>$value");
      _moveController!.value = value;
    }
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    // debugPrint("_moveController!.value===> ${_moveController!.value}");
    final valueMenu = _getSizeMenu().width / _overallDragAxisExtent;
    // debugPrint("_getSizeMenu().width====> ${_getSizeMenu().width}");
    // debugPrint("context.screenSize().width====> ${context.screenSize().width}");
    // debugPrint("_overallDragAxisExtent====> $_overallDragAxisExtent");
    // debugPrint("valueMenu====> $valueMenu");
    // debugPrint("_moveController!.value====> ${_moveController!.value}");
    if (!(_moveController!.value > valueMenu / 2)) {
      _moveController!.value = .0;
      _dragExtent = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
    });
    _moveController!.forward();
    widget.callBackClose.call(_moveController!.value > 0.0
        ? () {
            _moveController!.reverse();
            // _dragExtent = 0.0;
            setState(() {
              _updateMoveAnimation();
            });
          }
        : null);
  }

  Size _getSizeMenu() {
    RenderBox renderBox = globalKeyMenu.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onTap: _moveController!.value > 0.0
          ? () {
              _moveController!.reverse();
              // _dragExtent = 0.0;
              setState(() {
                _updateMoveAnimation();
              });
            }
          : null,
      child: Transform.scale(
        scale: _deleteAnimation.value,
        child: CardTile(
            moveAnimation: _moveAnimation,
            controller: _moveController!,
            childMenu: widget.menu.call(
              context,
              _moveController!.value > 0.0
                  ? () {
                      _deleteController.forward();
                      _moveController!.reverse();

                      // _dragExtent = 0.0;
                      setState(() {
                        _updateMoveAnimation();
                      });
                    }
                  : null,
              globalKeyMenu,
            ),
            borderRadius: widget.borderRadius,
            color: widget.color,
            child: widget.child),
      ),
    );
  }

  @override
  bool get wantKeepAlive => _moveController?.isAnimating == true && _deleteController.isAnimating == false;

  double get _overallDragAxisExtent {
    final Size size = context.size!;
    return size.width;
  }
}
