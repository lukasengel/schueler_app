import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/local_data.dart';

import '../../../../widgets/dynamic_dialogs.dart';
import '../../../../models/settings.dart';

class PersonalizationPageController extends GetxController {
  final localData = Get.find<LocalData>();
  List<bool> selectedTheme = [];

  @override
  void onInit() {
    for (int i = 0; i < 3; i++) {
      selectedTheme.add(localData.settings.selectedTheme.index == i);
    }
    super.onInit();
  }

  Future<bool> jumpToNexDay() async {
    final settings = localData.settings;
    settings.jumpToNextDay = !settings.jumpToNextDay;
    await localData.writeSettings();
    return settings.jumpToNextDay;
  }

  Future<bool> androidAlternativeTransition() async {
    final settings = localData.settings;
    settings.androidAlternativeTransition =
        !settings.androidAlternativeTransition;
    await localData.writeSettings();
    return settings.androidAlternativeTransition;
  }

  Future<bool> genderLanguage() async {
    await showDynamicMessageDialog(
      content: Image.asset("assets/images/lindner.gif"),
    );
    return false;
  }

  Future<void> onPressedToggleButton(int index) async {
    for (int i = 0; i < selectedTheme.length; i++) {
      selectedTheme[i] = i == index;
    }
    update();
    localData.settings.selectedTheme = ColorMode.values[index];
    switch (localData.settings.selectedTheme) {
      case ColorMode.LIGHT:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case ColorMode.SYSTEM:
        Get.changeThemeMode(ThemeMode.system);
        break;
      case ColorMode.DARK:
        Get.changeThemeMode(ThemeMode.dark);
        break;
    }
    await localData.writeSettings();
  }
}
