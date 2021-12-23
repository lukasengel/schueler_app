import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import './../../../controllers/local_data.dart';
// import './../../../controllers/web_data.dart';

import '../../../widgets/dynamic_message_dialog.dart';
import '../../../widgets/settings_ui/settings_switch_tile.dart';
import '../../../widgets/settings_ui/settings_text.dart';

class PersonalizationPage extends StatelessWidget {
  static const route = "/settings/personalization";
  const PersonalizationPage({Key? key}) : super(key: key);

  Future<bool> genderLanguage(_) async {
    await showDynamicMessageDialog(
        Get.context!, "", Image.asset("assets/images/lindner.gif"));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    //final localData = Get.find<LocalData>();
    //final webData = Get.find<WebData>();
    return Scaffold(
      appBar: AppBar(
        title: Text("personalization".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 5),
          children: [
            SettingsText(text: "misc".tr),
            SettingsSwitchTile(
              label: "gender_language".tr,
              value: false,
              onChanged: genderLanguage,
            ),
          ],
        ),
      ),
    );
  }
}
