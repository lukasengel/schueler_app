import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import './../../../controllers/local_data.dart';
// import './../../../controllers/web_data.dart';

import '../../../widgets/settings_ui/filter_settings.dart';
import '../../../widgets/settings_ui/settings_text.dart';

class FiltersPage extends StatelessWidget {
  static const route = "/settings/filters";
  const FiltersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final localData = Get.find<LocalData>();
    // final webData = Get.find<WebData>();
    return Scaffold(
      appBar: AppBar(
        title: Text("filters".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 25),
          children: [
            SettingsText(text: "choose_grade".tr),
            const GradeFilterSettings(),
            SettingsText(text: "misc".tr),
            const MiscFilterSettings(),
          ],
        ),
      ),
    );
  }
}
