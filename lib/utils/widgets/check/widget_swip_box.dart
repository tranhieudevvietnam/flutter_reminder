import 'package:flutter/material.dart';
import 'package:flutter_reminder/utils/gen/colors.gen.dart';

// ignore: must_be_immutable
class WidgetSwipeBox extends StatefulWidget {
  const WidgetSwipeBox({super.key, required this.value, this.onChange, this.size = const Size(51, 31)});
  final Size size;
  final bool value;
  final Function(bool value)? onChange;

  @override
  State<WidgetSwipeBox> createState() => _WidgetSwipeBoxState();
}

class _WidgetSwipeBoxState extends State<WidgetSwipeBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    end: const Offset(1.0, 0.0),
    begin: const Offset(-1.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    if (widget.value == true) {
      _controller.forward();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_offsetAnimation.value.dx == -1.0) {
          _controller.forward();
          widget.onChange?.call(true);
        } else {
          _controller.reverse();
          widget.onChange?.call(false);
        }
      },
      child: AnimatedContainer(
        width: widget.size.width,
        height: widget.size.height,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(100), color: _offsetAnimation.value.dx == 1.0 ? Colors.green : ColorName.hinText),
        duration: const Duration(milliseconds: 200),
        child: Align(
          alignment: Alignment(_offsetAnimation.value.dx, _offsetAnimation.value.dy),
          child: Container(
            width: widget.size.height - 2,
            height: widget.size.height - 2,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
          ),
        ),
      ),
    );
  }
}
