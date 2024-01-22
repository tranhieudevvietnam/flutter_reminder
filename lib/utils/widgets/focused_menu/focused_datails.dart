import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';

typedef BuildChildMenu = Widget Function(BuildContext context, GlobalKey globalKey, Function() onClose);

class FocusedDetails extends StatefulWidget {
  final BuildChildMenu childMenu;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final Size? childSize;
  final Widget child;

  const FocusedDetails({
    Key? key,
    required this.childMenu,
    required this.child,
    required this.childOffset,
    required this.childSize,
    this.menuBoxDecoration,
  }) : super(key: key);

  @override
  State<FocusedDetails> createState() => _FocusedDetailsState();
}

class _FocusedDetailsState extends State<FocusedDetails> {
  double heightMenu = 140;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSizeMenu();
    });
  }

  void _getSizeMenu() {
    RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    setState(() {
      heightMenu = size.height + 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final leftOffset = widget.childOffset.dx;
    final topOffset = (widget.childOffset.dy + heightMenu + widget.childSize!.height) < size.height
        ? widget.childOffset.dy + widget.childSize!.height
        : widget.childOffset.dy - heightMenu;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: (ColorName.hinText).withOpacity(0.5),
                ),
              )),
          Positioned(
              top: widget.childOffset.dy,
              left: widget.childOffset.dx,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: AbsorbPointer(
                      absorbing: true, child: SizedBox(width: widget.childSize!.width, height: widget.childSize!.height, child: widget.child)))),
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Transform.scale(
                  scale: value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              tween: Tween(begin: 0.0, end: 1.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TweenAnimationBuilder(
                    builder: (context, dynamic value, child) {
                      return Transform(
                        transform: Matrix4.rotationX(1.5708 * value),
                        alignment: Alignment.bottomCenter,
                        child: child,
                      );
                    },
                    tween: Tween(begin: 1.0, end: 0.0),
                    duration: const Duration(milliseconds: 200),
                    child: widget.childMenu.call(
                      context,
                      globalKey,
                      () {
                        Navigator.pop(context);
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
