import 'package:flutter/material.dart';
import 'package:flutter_component/flutter_component.dart';

class ShowBottomSheetBasic {
  ShowBottomSheetBasic._();
  static ShowBottomSheetBasic instant = ShowBottomSheetBasic._();

  show({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            constraints: BoxConstraints(maxHeight: context.screenSize().height * .93),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: child,
          );
        });
  }
}
