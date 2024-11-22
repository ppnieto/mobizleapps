import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobizleapps/screen/error.dart';
import 'package:quickalert/quickalert.dart';

class Mbz {
  static Future<bool> confirm({
    String? title,
    required String message,
    TextStyle? messageStyle,
    TextStyle? buttonStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? iconData,
  }) async {
    return bottomSheetColumn<bool>(
        title: title,
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: (messageStyle ?? TextStyle()).copyWith(color: foregroundColor),
                  maxLines: 6,
                ),
              ),
              if (iconData != null)
                Icon(
                  iconData,
                  size: 54,
                  color: foregroundColor,
                )
            ],
          ).paddingOnly(top: 20, bottom: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(foregroundColor), textStyle: MaterialStatePropertyAll(buttonStyle)),
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: Text("no".tr)),
              TextButton(
                  style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(foregroundColor), textStyle: MaterialStatePropertyAll(buttonStyle)),
                  onPressed: () {
                    Get.back(result: true);
                  },
                  child: Text("si".tr)),
            ],
          ).paddingOnly(bottom: 20)
        ],
        backgroundColor: backgroundColor);
  }

  static Future<T> bottomSheet<T>(Widget child, {Color? backgroundColor}) async {
    return await Get.bottomSheet(
      child,
      ignoreSafeArea: false,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
    );
  }

  static Future<T> bottomSheetColumn<T>(
      {String? title,
      TextStyle? titleStyle,
      required List<Widget> children,
      EdgeInsets? padding,
      Color? backgroundColor,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) async {
    return Mbz.bottomSheet(
      Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
                if (title != null) ListTile(title: Text(title, style: titleStyle)),
              ] +
              children,
        ),
      ),
      backgroundColor: backgroundColor,
    );
    /*
    return await Get.bottomSheet(
      Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
                if (title != null) ListTile(title: Text(title)),
              ] +
              children,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
    );
    */
  }

  static void snackbar(BuildContext context, String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 180),
      isDismissible: true,
    ));
    /*
    if (context.mounted) {      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
    */
  }

  static Future<String?> inputString(
      {required String title, TextStyle? titleStyle, EdgeInsets? padding, String? acceptText, String? initialValue}) async {
    TextEditingController controller = TextEditingController();
    if (initialValue != null && initialValue.isNotEmpty) {
      controller.text = initialValue;
    }
    return bottomSheetColumn<String?>(padding: padding ?? const EdgeInsets.all(20), title: title, titleStyle: titleStyle, children: [
      TextFormField(controller: controller, autofocus: true).paddingOnly(bottom: 20),
      FilledButton(onPressed: () => Get.back(result: controller.text.isEmpty ? null : controller.text), child: Text(acceptText ?? "Aceptar"))
          .paddingOnly(bottom: 20)
    ]);
  }

  static Widget errorBuilder(BuildContext context, Widget? child, Widget? resetButton) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return ErrorScreen(errorDetails: errorDetails, resetButton: resetButton);
    };
    return child!;
  }
}
