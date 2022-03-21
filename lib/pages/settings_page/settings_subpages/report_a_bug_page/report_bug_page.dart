import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/settings_ui/settings_container.dart';
import '../../../../widgets/settings_ui/settings_text.dart';
import './report_bug_page_controller.dart';

class ReportBugPage extends StatelessWidget {
  static const route = "/settings/report-a-bug";
  const ReportBugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportBugPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("settings/feedback/app_bar_title".tr),
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: controller.discard,
        ),
        actions: [
          Obx(() => IconButton(
                disabledColor: Get.theme.colorScheme.onTertiary,
                icon: const Icon(Icons.done),
                onPressed: controller.valid.value ? controller.submit : null,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: controller.unfocus,
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 25),
            children: [
              SettingsText(text: "settings/feedback/contact_details".tr),
              SettingsContainer(
                padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                child: Column(
                  children: [
                    TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: controller.nameController,
                      textInputAction: TextInputAction.next,
                      style:
                          context.textTheme.bodyLarge!.copyWith(fontSize: 16),
                      onSubmitted: (_) => controller.node.requestFocus(),
                      decoration: InputDecoration(
                        hintText: "settings/feedback/name".tr,
                        suffixIcon: IconButton(
                          color: Get.theme.colorScheme.onTertiary,
                          splashRadius: 20,
                          icon: const Icon(Icons.help_outline),
                          onPressed: controller.onPressedHelp,
                        ),
                      ),
                    ),
                    Divider(
                      height: 3,
                      indent: 25,
                      color: Get.theme.colorScheme.onTertiary,
                    ),
                    TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: controller.emailController,
                      textInputAction: TextInputAction.next,
                      focusNode: controller.node,
                      style:
                          context.textTheme.bodyLarge!.copyWith(fontSize: 16),
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        hintText: "settings/feedback/email".tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              SettingsText(text: "settings/feedback/feedback".tr),
              SettingsContainer(
                child: TextField(
                  maxLength: 500,
                  maxLines: 10,
                  controller: controller.messageController,
                  style: context.textTheme.bodyLarge!.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    hintText: "settings/feedback/message".tr,
                    border: InputBorder.none,
                  ),
                  onChanged: controller.validate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
