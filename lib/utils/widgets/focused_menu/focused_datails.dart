import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';

typedef BuildChildMenu = Widget Function(BuildContext context, Function() onClose);

class FocusedDetails extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightMenu = 140;

    final leftOffset = childOffset.dx;
    final topOffset =
        (childOffset.dy + heightMenu + childSize!.height) < size.height ? childOffset.dy + childSize!.height : childOffset.dy - heightMenu;
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
                  color: (ColorName.hintext).withOpacity(0.5),
                ),
              )),
          Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: AbsorbPointer(absorbing: true, child: SizedBox(width: childSize!.width, height: childSize!.height, child: child)))),
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
                padding: const EdgeInsets.only(top: 10),
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
                    child: childMenu.call(
                      context,
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
