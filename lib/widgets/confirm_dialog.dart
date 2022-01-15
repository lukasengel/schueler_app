import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Future<bool> showConfirmDialog(
    String header, String warning, String confirm) async {
  if (Platform.isIOS) {
    final input = await showCupertinoModalPopup(
        context: Get.context!,
        builder: (context) {
          return CupertinoActionSheet(
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
                "cancel".tr,
                style: const TextStyle(color: CupertinoColors.activeBlue),
              ),
              onPressed: Get.back,
            ),
          );
        });
    return input ?? false;
  }

  final input = await Get.dialog(
    AlertDialog(
      title: Text(header, style: const TextStyle(fontSize: 18)),
      content: Text(warning),
      buttonPadding: const EdgeInsets.all(20),
      actions: <Widget>[
        TextButton(
          child: Text("cancel".tr.toUpperCase()),
          onPressed: Get.back,
        ),
        TextButton(
          child: Text(confirm.toUpperCase()),
          onPressed: () => Get.back(result: true),
        ),
      ],
    ),
  );
  return input ?? false;
}
