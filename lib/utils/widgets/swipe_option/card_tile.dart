import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';

class CardTile extends StatelessWidget {
  final Animation<Offset> moveAnimation;
  final AnimationController controller;
  final Widget child;
  final Widget background;
  final double borderRadius;
  final Color color;

  const CardTile({
    Key? key,
    required this.moveAnimation,
    required this.controller,
    required this.child,
    required this.background,
    required this.borderRadius,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (!moveAnimation.isDismissed)
          Positioned.fill(
            left: 10,
            top: 1,
            right: 1,
            bottom: 1,
            child: background,
          ),

        SlideTransition(
          position: moveAnimation,
          child: child,
        ),

        // content,
      ],
    );
  }
}
