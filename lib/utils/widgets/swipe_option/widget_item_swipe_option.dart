import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reminder/utils/widgets/swipe_option/card_tile.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

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
  final Widget menu;
  final double borderRadius;
  final Color color;
  final Function(Function()? event) callBackClose;

  @override
  State<WidgetItemSwipeOption> createState() => _WidgetItemSwipeOptionState();
}

class _WidgetItemSwipeOptionState extends State<WidgetItemSwipeOption> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;

  AnimationController? _resizeController;
  Animation<double>? _resizeAnimation;

  double _dragExtent = 0.0;
  bool _dragUnderway = false;

  @override
  void initState() {
    _moveController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this)
      ..addStatusListener(
        _handleDismissStatusChanged,
      );
    _updateMoveAnimation();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.callBackClose.call(_moveController!.value > 0.0
          ? () {
              _moveController!.reverse();
              // _dragExtent = 0.0;
              _dragUnderway = false;
              setState(() {
                _updateMoveAnimation();
              });
            }
          : null);
    });
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    // debugPrint("status=====>$status");
    if (status == AnimationStatus.dismissed) {
      _dragExtent = 0.0;
      // _moveController!.value = .0;
      _dragUnderway = false;
      setState(() {
        _updateMoveAnimation();
      });
    }

    updateKeepAlive();
  }

  void _updateMoveAnimation() {
    final double endOffsetX = _dragExtent.sign != 0 ? -.25 : _dragExtent.sign;

    ///TODO: Changed: DONE
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(endOffsetX, 0),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    _dragUnderway = true;
    // if (_moveController!.isAnimating) {
    //   _dragExtent = _moveController!.value * _overallDragAxisExtent * _dragExtent.sign;
    //   // _moveController!.stop();
    // }

    // else {
    //   _dragExtent = 0.0;
    //   _moveController!.value = 0.0;
    // }
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
    final value = _dragExtent.abs() / _overallDragAxisExtent;
    if (!_moveController!.isAnimating) {
      // debugPrint(" _dragExtent ===>$_dragExtent");
      // debugPrint(" _dragExtent.abs() / _overallDragAxisExtent ===>$value");
      _moveController!.value = value;
    }
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    _dragUnderway = false;
    // debugPrint("_moveController!.value===> ${_moveController!.value}");
    if (!(_moveController!.value > .30)) {
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
            _dragUnderway = false;
            setState(() {
              _updateMoveAnimation();
            });
          }
        : null);
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
              _dragUnderway = false;
              setState(() {
                _updateMoveAnimation();
              });
            }
          : null,
      child: CardTile(
          moveAnimation: _moveAnimation,
          controller: _moveController!,
          background: widget.menu,
          borderRadius: widget.borderRadius,
          color: widget.color,
          child: widget.child),
    );
  }

  @override
  bool get wantKeepAlive => _moveController?.isAnimating == true || _resizeController?.isAnimating == true;

  double get _overallDragAxisExtent {
    final Size size = context.size!;
    // final double threshold = widget.swipeThreshold;

    // ///TODO: changed: DONE
    // return widget.swipeToTrigger ? size.width * threshold : size.width;

    return size.width / 3;
  }
}
