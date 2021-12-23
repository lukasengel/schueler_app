import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../../controllers/local_data.dart';
import './../../../controllers/web_data.dart';

import '../settings_ui/settings_text.dart';
import '../settings_ui/filter_settings.dart';

class SettingsSubpage extends StatelessWidget {
  late LocalData localData;
  late WebData webData;

  SettingsSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    localData = Get.find<LocalData>();
    webData = Get.find<WebData>();
    return Scaffold(
      appBar: AppBar(
        title: Text("filters".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            SettingsText(text: "choose_grade".tr),
            const GradeFilterSettings(),
          ],
        ),
      ),
    );
  }
}
