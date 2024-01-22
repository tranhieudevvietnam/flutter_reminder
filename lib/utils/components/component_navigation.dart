import 'package:flutter/material.dart';

enum TypeAnimation { edit, add, next }

class ComponentNavigation {
  static Future nextPage({
    required BuildContext context,
    required Widget child,
    TypeAnimation animation = TypeAnimation.next,
  }) {
    return Navigator.of(context).push(_getAnimationByType(type: animation, child: child));
  }

  static _getAnimationByType({required TypeAnimation type, required Widget child}) {
    switch (type) {
      case TypeAnimation.edit:
        return _createRouteEdit(child);
      default:
        return _createRoute(child);
    }
  }

  static Route _createRouteEdit(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
