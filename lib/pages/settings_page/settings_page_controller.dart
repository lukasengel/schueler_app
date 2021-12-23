import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import './settings_subpages/personalization_page.dart';
import './settings_subpages/filters_page.dart';

import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/confirm_logout.dialog.dart';

class SettingsPageController extends GetxController {
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();
  final auth = Get.find<Authentication>();

  void logout() async {
    final input = await showConfirmLogoutDialog(
      "confirm_logout".tr,
      "logout_warning".tr,
    );
    if (input) {
      localData.clearSettings();
      auth.signOut();
      Get.back();
    }
  }

  void onTapFilters() async {
    Get.toNamed(FiltersPage.route);
  }

  void onTapPersonalization() async {
    Get.toNamed(PersonalizationPage.route);
  }

  void onTapGithub() async {
    await url_launcher.launch("https://github.com/lukasengel/schueler_app");
  }
}
