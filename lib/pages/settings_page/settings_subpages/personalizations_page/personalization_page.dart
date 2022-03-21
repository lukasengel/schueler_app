import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './personalization_page_controller.dart';

import '../../../../widgets/settings_ui/settings_container.dart';
import '../../../../widgets/settings_ui/settings_switch_tile.dart';
import '../../../../widgets/settings_ui/settings_text.dart';

class PersonalizationPage extends StatelessWidget {
  static const route = "/settings/personalization";
  const PersonalizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PersonalizationPageController());
    return Scaffold(
      appBar: AppBar(
        title: Text("settings/personalization".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: GetBuilder<PersonalizationPageController>(builder: (controller) {
          return ListView(
            padding: const EdgeInsets.only(top: 5),
            children: [
              SettingsText(text: "settings/personalization/colors".tr),
              SettingsContainer(
                padding: const EdgeInsets.all(5),
                child: LayoutBuilder(
                  builder: (context, constraints) => ToggleButtons(
                    renderBorder: false,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: controller.onPressedToggleButton,
                    isSelected: controller.selectedTheme,
                    constraints:
                        BoxConstraints(minWidth: constraints.maxWidth / 3),
                    splashColor: Get.theme.colorScheme.primary.withOpacity(0.2),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            const Icon(Icons.light_mode_outlined),
                            Text(
                              "settings/personalization/light".tr,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(children: [
                          const Icon(Icons.brightness_6_outlined),
                          Text(
                            "settings/personalization/system".tr,
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            const Icon(Icons.dark_mode),
                            Text(
                              "settings/personalization/dark".tr,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SettingsText(text: "settings/filters/misc".tr),
              SettingsSwitchTile(
                label: "settings/personalization/gender_neutral_language".tr,
                value: false,
                onChanged: controller.genderLanguage,
              ),
            ],
          );
        }),
      ),
    );
  }
}
