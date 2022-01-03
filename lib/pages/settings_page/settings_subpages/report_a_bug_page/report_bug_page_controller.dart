import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../controllers/web_data.dart';
import '../../../../widgets/dynamic_message_dialog.dart';
import '../../../../widgets/confirm_dialog.dart';
import '../../../../models/feedback_item.dart';

class ReportBugPageController extends GetxController {
  RxBool valid = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final node = FocusNode();

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  void onPressedHelp() {
    showDynamicMessageDialog(
      Get.context!,
      "why_name_header".tr,
      Text("why_name_message".tr),
    );
  }

  void validate(String text) {
    valid.value = text.isNotEmpty;
  }

  void submit() async {
    final input = await showConfirmDialog(
        "submit".tr, "submit_message".tr, "confirm_submit".tr);
    if (input) {
      final webData = Get.find<WebData>();
      try {
        await webData.submitFeedback(FeedbackItem(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          message: messageController.text.trim(),
        ));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text("error".tr.toUpperCase() + ": " + e.message!),
          duration: const Duration(seconds: 5),
        ));
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).clearSnackBars();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text("error".tr.toUpperCase() + ": " + e.toString()),
          duration: const Duration(seconds: 5),
        ));
      }
      Get.back();
    }
  }

  bool get isNotEmpty {
    return messageController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        nameController.text.isNotEmpty;
  }

  void discard() async {
    if (isNotEmpty) {
      final input = await showConfirmDialog(
          "discard".tr, "discard_message".tr, "confirm_discard".tr);
      if (!input) {
        return;
      }
    }
    Get.back();
  }

  void unfocus() {
    if (Get.focusScope != null) {
      Get.focusScope!.unfocus();
    }
  }
}
