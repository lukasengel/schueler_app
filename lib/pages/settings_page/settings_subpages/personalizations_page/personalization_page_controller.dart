import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/local_data.dart';

import '../../../../widgets/dynamic_message_dialog.dart';

class PersonalizationPageController extends GetxController {
  final localData = Get.find<LocalData>();

  Future<bool> genderLanguage() async {
    await showDynamicMessageDialog(
      context: Get.context!,
      content: Image.asset("assets/images/lindner.gif"),
    );
    return false;
  }

  Future<bool> forceGerman() async {
    localData.settings.forceGerman = !localData.settings.forceGerman;
    await localData.writeSettings();
    Get.updateLocale(localData.settings.forceGerman && Get.deviceLocale != null
        ? const Locale("de", "DE")
        : Get.deviceLocale!);
    return localData.settings.forceGerman;
  }
}
