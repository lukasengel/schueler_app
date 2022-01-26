import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './personalization_page_controller.dart';

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
              SettingsText(text: "settings/filters/misc".tr),
              SettingsSwitchTile(
                label: "settings/personalization/gender_neutral_language".tr,
                value: false,
                onChanged: controller.genderLanguage,
              ),
              SettingsSwitchTile(
                label: "settings/personalization/force_german".tr,
                value: controller.localData.settings.forceGerman,
                onChanged: controller.forceGerman,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  "settings/personalization/language_note".tr,
                  style: context.textTheme.bodyText1!.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
