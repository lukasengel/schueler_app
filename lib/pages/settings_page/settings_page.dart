import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import './settings_page_controller.dart';
import '../../widgets/settings_tile.dart';

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
        child: GetBuilder<SettingsPageController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                SettingsTile(
                  icon: const Icon(Icons.filter_list),
                  label: "filters".tr,
                  onTap: controller.onTapFilters,
                ),
                SettingsTile(
                  icon: const Icon(Icons.report_problem),
                  label: "report_a_bug".tr,
                  onTap: () {},
                ),
                SettingsTile(
                  icon: const Icon(FontAwesome5.github_square),
                  label: "github".tr,
                  onTap: () {},
                ),
                SettingsSwitch(
                  label: "gender_language".tr,
                  value: false,
                  onChanged: controller.genderLanguage,
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: controller.logout,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("logout".tr),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
