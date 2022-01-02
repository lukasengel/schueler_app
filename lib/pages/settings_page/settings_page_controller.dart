import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import './settings_subpages/personalization_page.dart';
import './settings_subpages/filters_page.dart';
import './settings_subpages/report_bug_page.dart';

import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/confirm_dialog.dart';

class SettingsPageController extends GetxController {
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();
  final auth = Get.find<Authentication>();

  void logout() async {
    final input = await showConfirmDialog(
      "confirm_logout".tr,
      "logout_warning".tr,
      "logout".tr,
    );
    if (input) {
      await localData.clearSettings();
      await auth.signOut();
      Get.back();
    }
  }

  void onTapFilters() {
    Get.toNamed(FiltersPage.route);
  }

  void onTapPersonalization() {
    Get.toNamed(PersonalizationPage.route);
  }

  void onTapGithub() async {
    await url_launcher.launch("https://github.com/lukasengel/schueler_app");
  }

  void onTapReportABug() {
    Get.toNamed(ReportBugPage.route);
  }
}
