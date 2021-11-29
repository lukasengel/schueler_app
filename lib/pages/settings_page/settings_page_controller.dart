import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/settings_page/settings_subpages/filters_page.dart';
import '../../widgets/dynamic_message_dialog.dart';
import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';
import '../../models/settings.dart';

class SettingsPageController extends GetxController {
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();

  void logout() async {
    localData.settings = Settings.empty();
    localData.writeSettings();
    webData.setAuthState(false);
    Get.back();
  }

  void onTapFilters() async {
    Get.toNamed(FiltersPage.route);
  }

  Future<bool> genderLanguage(_) async {
    await showDynamicMessageDialog(
        Get.context!, "", Image.asset("assets/images/lindner.gif"));
    return false;
  }
}
