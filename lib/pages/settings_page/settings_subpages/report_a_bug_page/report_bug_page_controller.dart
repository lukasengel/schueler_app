import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/web_data.dart';
import '../../../../widgets/dynamic_dialogs.dart';
import '../../../../widgets/snackbar.dart';
import '../../../../models/web_data/feedback_item.dart';

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
      title: "settings/feedback/privacy_dialog/header".tr,
      content: Text("settings/feedback/privacy_dialog/message".tr),
    );
  }

  void validate(String text) {
    valid.value = text.isNotEmpty;
  }

  void submit() async {
    final input = await showDynamicConfirmDialog(
      header: "settings/feedback/submit_dialog/header".tr,
      warning: "settings/feedback/submit_dialog/message".tr,
      confirm: "settings/feedback/submit_dialog/confirm".tr,
    );
    if (input) {
      final webData = Get.find<WebData>();
      try {
        await webData.submitFeedback(FeedbackItem(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          message: messageController.text.trim(),
        ));
      } catch (e) {
        showErrorSnackbar(e);
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
      final input = await showDynamicConfirmDialog(
        header: "settings/feedback/discard_dialog/header".tr,
        warning: "settings/feedback/discard_dialog/message".tr,
        confirm: "settings/feedback/discard_dialog/confirm".tr,
      );
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
