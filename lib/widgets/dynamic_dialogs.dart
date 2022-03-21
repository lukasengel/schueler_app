import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

ThemeData get _getTheme {
  return ThemeData(
    brightness: Get.theme.brightness,
    colorScheme: Get.theme.colorScheme,
  );
}

CupertinoThemeData get _getCupertinoTheme {
  return CupertinoThemeData(
    brightness: Get.theme.brightness,
  );
}

Future<void> showDynamicMessageDialog({
  String? title,
  Widget? content,
}) {
  return Platform.isIOS
      ? showCupertinoDialog(
          context: Get.context!,
          builder: (context) => CupertinoTheme(
            data: _getCupertinoTheme,
            child: CupertinoAlertDialog(
              title: title != null && title.isNotEmpty ? Text(title) : null,
              content: content,
              actions: [
                CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            ),
          ),
        )
      : showDialog(
          context: Get.context!,
          builder: (context) => Theme(
            data: _getTheme,
            child: AlertDialog(
              title: title != null && title.isNotEmpty ? Text(title) : null,
              content: content,
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            ),
          ),
        );
}

Future<bool> showDynamicConfirmDialog({
  required String header,
  required String warning,
  required String confirm,
}) async {
  if (Platform.isIOS) {
    final input = await showCupertinoModalPopup(
        context: Get.context!,
        builder: (context) {
          return CupertinoTheme(
            data: _getCupertinoTheme,
            child: CupertinoActionSheet(
              title: Text(header),
              message: Text(warning),
              actions: [
                CupertinoActionSheetAction(
                  child: Text(
                    confirm,
                    style: const TextStyle(color: CupertinoColors.systemRed),
                  ),
                  onPressed: () => Get.back(result: true),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                child: Text(
                  "general/cancel".tr,
                  style: const TextStyle(color: CupertinoColors.activeBlue),
                ),
                onPressed: Get.back,
              ),
            ),
          );
        });
    return input ?? false;
  }

  final input = await Get.dialog(
    Theme(
      data: _getTheme,
      child: AlertDialog(
        title: Text(header, style: const TextStyle(fontSize: 18)),
        content: Text(warning),
        buttonPadding: const EdgeInsets.all(20),
        actions: <Widget>[
          TextButton(
            child: Text("general/cancel".tr.toUpperCase()),
            onPressed: Get.back,
          ),
          TextButton(
            child: Text(confirm.toUpperCase()),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    ),
  );
  return input ?? false;
}
