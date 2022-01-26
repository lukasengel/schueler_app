import 'package:get/get.dart';
import 'package:schueler_app/pages/settings_page/settings_subpages/notifications_page/notifications_page.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'settings_subpages/personalizations_page/personalization_page.dart';
import 'settings_subpages/filters_page/filters_page.dart';
import './settings_subpages/report_a_bug_page/report_bug_page.dart';
import 'settings_subpages/abbreviations_page/abbreviations_page.dart';

import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/dynamic_confirm_dialog.dart';

class SettingsPageController extends GetxController {
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();
  final auth = Get.find<Authentication>();

  void logout() async {
    final input = await showDynamicConfirmDialog(
      header: "settings/logout_dialog/header".tr,
      warning: "settings/logout_dialog/message".tr,
      confirm: "settings/logout".tr,
    );
    if (input) {
      await localData.clearSettings();
      await auth.signOut();
      Get.back();
    }
  }

  void onTapPersonalization() => Get.toNamed(PersonalizationPage.route);
  void onTapNotifications() => Get.toNamed(NotificationsPage.route);
  void onTapFilters() => Get.toNamed(FiltersPage.route);
  void onTapAbbreviations() => Get.toNamed(AbbreviationsPage.route);
  void onTapReportABug() => Get.toNamed(ReportBugPage.route);
  void onTapGithub() async {
    await url_launcher.launch("https://github.com/lukasengel/schueler_app");
  }
}
