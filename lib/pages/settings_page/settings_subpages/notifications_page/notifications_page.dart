import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schueler_app/widgets/dynamic_app_bar.dart';
import 'package:schueler_app/widgets/settings_ui/settings_container.dart';

import './notifications_page_controller.dart';

import '../../../../widgets/settings_ui/settings_switch_tile.dart';
import '../../../../widgets/settings_ui/settings_text.dart';

class NotificationsPage extends StatelessWidget {
  static const route = "/settings/notifications";
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsPageController());

    return Scaffold(
      appBar: dynamicAppBar(
        context: context,
        title: "settings/notifications".tr,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.pending_outlined,
                            color: Colors.grey,
                            size: 45,
                          ),
                          Text(
                            "settings/notifications/add_courses_here".tr,
                            style: context.textTheme.bodyText1!
                                .copyWith(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
