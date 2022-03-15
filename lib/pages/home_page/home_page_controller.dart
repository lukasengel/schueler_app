import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes.dart' as routes;
import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';

import '../../widgets/snackbar.dart';

class HomePageController extends GetxController {
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();
  int selectedTab = 0;

  void switchTabs(int index) {
    selectedTab = index;
    update();
  }

  void onPressedSettings() {
    Get.toNamed(routes.settings);
  }

  void invertSorting() async {
    if (selectedTab == 1) {
      localData.settings.reversed = !localData.settings.reversed;
    } else {
      localData.settings.reversedSchoolLife =
          !localData.settings.reversedSchoolLife;
    }
    await localData.writeSettings();
    webData.update();
  }

  Future<void> onRefresh(BuildContext context) async {
    try {
      await webData.fetchData();
    } catch (e) {
      showSnackBar(
        context: context,
        snackbar: SnackBar(
          content: Text("general/error".tr.toUpperCase() + ": " + e.toString()),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
