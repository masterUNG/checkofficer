import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  void normalDialog({
    required String title,
    Widget? contentWidget,
    Widget? actionWidget,
  }) {
    Get.dialog(
      AlertDialog(
        title: WidgetText(data: title),
        content: contentWidget,
        actions: [
          actionWidget ??
              WidgetButton(
                label: 'OK',
                pressFunc: () => Get.back(),
              )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
