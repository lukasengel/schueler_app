import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import './settings_page_controller.dart';
import '../../widgets/settings_ui/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  static const route = "/settings";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: GetBuilder<SettingsPageController>(builder: (controller) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 25),
            children: [
              SettingsTile(
                icon: const Icon(Icons.edit),
                label: "personalization".tr,
                onTap: controller.onTapPersonalization,
              ),
              SettingsTile(
                icon: const Icon(Icons.filter_list),
                label: "filters".tr,
                onTap: controller.onTapFilters,
              ),
              SettingsTile(
                icon: const Icon(Icons.notifications),
                label: "notifications".tr,
                onTap: () {},
              ),
              SettingsTile(
                icon: const Icon(Icons.report_problem),
                label: "report_a_bug".tr,
                onTap: controller.onTapReportABug,
              ),
              SettingsTile(
                icon: const Icon(FontAwesome5.github_square),
                label: "github".tr,
                onTap: controller.onTapGithub,
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  onPressed: controller.logout,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("logout".tr),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
