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
    localData.settings.sortingAZ = !localData.settings.sortingAZ;
    await localData.writeSettings();
    webData.update();
  }

  Future<void> onRefresh() async {
    await webData.fetchData();
  }
}
