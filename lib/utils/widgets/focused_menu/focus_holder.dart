import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'focused_datails.dart';

class FocusedHolder extends StatefulWidget {
  // final Widget child;
  final Widget Function(BuildContext context, Function() onLongPress) buildChild;
  final BuildChildMenu childMenu;

  const FocusedHolder({
    Key? key,
    // required this.child,
    required this.buildChild,
    required this.childMenu,
  }) : super(key: key);

  @override
  _FocusedHolderState createState() => _FocusedHolderState();
}

class _FocusedHolderState extends State<FocusedHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  _FocusedHolderState();

  void _getOffset() {
    RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   key: containerKey,
    //   onLongPress: () async {
    //     await HapticFeedback.mediumImpact();
    //     await openMenu(context);
    //   },
    //   child: widget.buildChild.call(context),
    // );
    return Container(
      key: containerKey,
      child: widget.buildChild.call(context, () async {
        await HapticFeedback.mediumImpact();
        await openMenu(context);
      }),
    );
  }

  Future openMenu(BuildContext context) async {
    _getOffset();

    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (context, animation, secondaryAnimation) {
          animation = Tween(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: FocusedDetails(
              childOffset: childOffset,
              childSize: childSize,
              childMenu: widget.childMenu,
              // child: widget.child,
              child: widget.buildChild.call(
                context,
                () {},
              ),
            ),
          );
        },
        fullscreenDialog: true,
        opaque: false,
      ),
    ).whenComplete(() {});
  }
}
