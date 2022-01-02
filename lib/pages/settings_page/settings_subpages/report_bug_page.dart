import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import './../../../controllers/local_data.dart';
// import './../../../controllers/web_data.dart';

import '../../../widgets/settings_ui/settings_container.dart';
import '../../../widgets/settings_ui/settings_text.dart';
import './report_bug_page_controller.dart';

class ReportBugPage extends StatelessWidget {
  static const route = "/settings/report-a-bug";
  const ReportBugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportBugPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("feedback".tr),
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: controller.discard,
          tooltip: "Back",
        ),
        actions: [
          Obx(() => IconButton(
                onPressed: controller.valid.value ? controller.submit : null,
                icon: const Icon(Icons.done),
              )),
        ],
      ),
      body: GestureDetector(
        onTap: controller.unfocus,
        child: ListView(
          padding: const EdgeInsets.only(top: 5),
          children: [
            SettingsText(text: "contact_information".tr),
            SettingsContainer(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: controller.nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "name".tr,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.help_outline),
                        onPressed: controller.onPressedHelp,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 3,
                    indent: 25,
                    color: Colors.grey,
                  ),
                  TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "email".tr,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            SettingsText(text: "report".tr),
            SettingsContainer(
              child: TextField(
                maxLength: 500,
                maxLines: 10,
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: "message".tr,
                  border: InputBorder.none,
                ),
                onChanged: controller.validate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
