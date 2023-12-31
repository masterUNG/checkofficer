import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  void normalDialog({
    required String title,
    Widget? contentWidget,
    Widget? actionWidget,
    Widget? firstActionWidget,
    Widget? secondActionWidget,
  }) {
    Get.dialog(
      AlertDialog(
        title: WidgetText(data: title),
        content: contentWidget,
        actions: [firstActionWidget ?? const SizedBox(), secondActionWidget ?? const SizedBox(),
          actionWidget ??
              WidgetButton(
                label: firstActionWidget == null ? 'OK' : 'Cancel',
                pressFunc: () => Get.back(),
              )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
