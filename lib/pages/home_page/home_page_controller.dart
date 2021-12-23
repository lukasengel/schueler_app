import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../settings_page/settings_page.dart';
import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';

class HomePageController extends GetxController {
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();
  int selectedTab = 0;

  void switchTabs(int index) {
    selectedTab = index;
    update();
  }

  void onPressedSettings() {
    Get.toNamed(SettingsPage.route);
  }

  void invertSorting() async {
    localData.settings.reversed = !localData.settings.reversed;
    await localData.writeSettings();
    webData.update();
  }

  Future<void> onRefresh(BuildContext context) async {
    try {
      await webData.fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error".tr.toUpperCase() + ": " + e.toString()),
        duration: const Duration(seconds: 5),
      ));
    }
  }
}
