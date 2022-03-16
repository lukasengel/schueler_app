import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../routes.dart' as routes;

import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/dynamic_dialogs.dart';

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
      Get.offAllNamed(routes.login);
      Get.updateLocale(Get.deviceLocale!);
    }
  }

  void onTapPersonalization() => Get.toNamed(routes.personalization);
  void onTapNotifications() => Get.toNamed(routes.notifications);
  void onTapFilters() => Get.toNamed(routes.filters);
  void onTapAbbreviations() => Get.toNamed(routes.abbreviations);
  void onTapReportABug() => Get.toNamed(routes.report_bug);
  void onTapGithub() async {
    await url_launcher.launch("https://github.com/lukasengel/schueler_app");
  }
}
