import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void showSnackBar({
  required Widget content,
  SnackBarAction? action,
  Duration? duration,
}) {
  final context = Get.context!;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
    duration: duration ?? const Duration(seconds: 5),
    action: action,
  ));
}

void showErrorSnackbar(Object e) {
  if (e is FirebaseException) {
    showSnackBar(
      content: Text("general/error".tr.toUpperCase() + ": " + e.message!),
    );
  } else {
    showSnackBar(
      content: Text(
        "general/error".tr.toUpperCase() + ": " + e.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
      ),
    );
  }
}
