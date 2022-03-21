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
    final style1 = TextStyle(
      color: Get.theme.colorScheme.onTertiary,
      fontSize: 16,
      fontFamily: "Montserrat",
      letterSpacing: 1,
    );

    final style2 = TextStyle(
      color: Get.theme.colorScheme.onTertiary,
      fontSize: 20,
      fontFamily: "Montserrat",
      letterSpacing: 1,
    );

    const spacer1 = SizedBox(height: 5);
    const spacer2 = SizedBox(height: 10);

    Get.put(SettingsPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("general/settings".tr),
      ),
      body: SafeArea(
        bottom: false,
// ###################################################################################
// #                               SETTING TILES                                     #
// ###################################################################################
        child: GetBuilder<SettingsPageController>(builder: (controller) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 60),
            children: [
              SettingsTile(
                icon: const Icon(Icons.edit),
                label: "settings/personalization".tr,
                onTap: controller.onTapPersonalization,
              ),
              SettingsTile(
                icon: const Icon(Icons.filter_list),
                label: "settings/filters".tr,
                onTap: controller.onTapFilters,
              ),
              SettingsTile(
                icon: const Icon(Icons.notifications),
                label: "settings/notifications".tr,
                onTap: controller.onTapNotifications,
              ),
              SettingsTile(
                icon: const Icon(Icons.history_edu),
                label: "settings/abbreviations".tr,
                onTap: controller.onTapAbbreviations,
              ),
              SettingsTile(
                icon: const Icon(Icons.report_problem),
                label: "settings/report_a_bug".tr,
                onTap: controller.onTapReportABug,
              ),
              SettingsTile(
                icon: const Icon(FontAwesome5.github_square),
                label: "settings/github".tr,
                onTap: controller.onTapGithub,
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  onPressed: controller.logout,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("settings/logout".tr),
                  ),
                ),
              ),
// ###################################################################################
// #                               COPYRIGHT NOTICE                                  #
// ###################################################################################
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      "settings/copyright/logo_artist".tr,
                      style: style1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    spacer1,
                    Text(
                      "settings/copyright/nika".tr.tr.toUpperCase(),
                      style: style2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    spacer2,
                    Text(
                      "settings/copyright/developer".tr,
                      style: style1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    spacer1,
                    Text(
                      "settings/copyright/lukas".tr.toUpperCase(),
                      style: style2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "settings/copyright/license".tr.toUpperCase(),
                      style: style1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
