import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './notifications_page_controller.dart';

import '../../../../widgets/settings_ui/settings_switch_tile.dart';
import '../../../../widgets/settings_ui/settings_text.dart';
import '../../../../widgets/settings_ui/settings_container.dart';
import '../../../../widgets/settings_ui/settings_info_box.dart';

class NotificationsPage extends StatelessWidget {
  static const route = "/settings/notifications";
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsPageController());

    return Scaffold(
      appBar: AppBar(
        title: Text("settings/notifications".tr),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: controller.addCourse,
      ),
      body: SafeArea(
          bottom: false,
          child: GetBuilder<NotificationsPageController>(
            builder: (_) {
              final notifications = controller.localData.settings.notifications;
              return ListView(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 60),
                children: [
                  SettingsText(text: "settings/notifications".tr),
                  SettingsSwitchTile(
                    label: "settings/notifications/substitutions".tr,
                    onChanged: controller.onChangedDailyNotifications,
                    value: controller.localData.settings.dailyNotifications,
                  ),
                  SettingsSwitchTile(
                    label: "settings/notifications/smv_news".tr,
                    onChanged: controller.onChangedSmvNews,
                    value: controller.localData.settings.smvNotifications,
                  ),
                  SettingsText(text: "settings/notifications/relevant".tr),
                  if (notifications.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: SettingsInfoBox(
                        "settings/notifications/add_courses_here".tr,
                      ),
                    ),
                  if (notifications.isNotEmpty)
                    ...notifications.map(
                      (e) => SettingsContainer(
                        padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e, style: context.textTheme.bodyText2),
                            IconButton(
                              onPressed: () => controller.deleteCourse(e),
                              icon: Icon(
                                Icons.close,
                                color: context.theme.primaryColor,
                              ),
                              splashRadius: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          )),
    );
  }
}
