import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/local_data.dart';
import '../../controllers/authentication.dart';

import '../../models/web_data_exception.dart';
import '../../models/auth_data_exception.dart';
import '../../widgets/dynamic_message_dialog.dart';

class LoginPageController extends GetxController {
  late LocalData localData;
  late Authentication auth;
  final usernameController = TextEditingController();
  final passwortController = TextEditingController();
  RxBool working = false.obs;
  RxBool obscure = true.obs;
  RxString error = "".obs;

  @override
  onInit() {
    localData = Get.find<LocalData>();
    auth = Get.find<Authentication>();
    usernameController.text = localData.settings.username;
    passwortController.text = localData.settings.password;
    error.value = auth.error != AuthDataException.emptyCredentials().toString()
        ? translateError(auth.error)
        : "";
    super.onInit();
  }

  Future<void> login() async {
    HapticFeedback.heavyImpact();
    working.value = true;
    error.value = "";
    localData.settings.username = usernameController.text;
    localData.settings.password = passwortController.text;
    await localData.writeSettings();
    await auth.login();
    error.value = translateError(auth.error);
    if (error.isEmpty) {
      usernameController.clear();
      passwortController.clear();
    }
    working.value = false;
  }

  void onTappedScaffold() {
    if (Get.focusScope != null) {
      Get.focusScope!.unfocus();
    }
  }

  void onPressedLogin() async {
    await login();
  }

  void onSubmitted(String input) async {
    await login();
  }

  void onPressedHelp() async {
    await showDynamicMessageDialog(
      Get.context!,
      "login_help_title".tr,
      Text("login_help_content".tr),
    );
  }

  void toggleVisibility() {
    obscure.value = !obscure.value;
  }

  String translateError(String e) {
    if (e == AuthDataException.emptyCredentials().toString()) {
      return "empty_credentials".tr;
    } else if (e == WebDataException.unauthorized().toString()) {
      return "unauthorized".tr + "\n($e)";
    } else if (e == WebDataException.forbidden().toString()) {
      return "forbidden".tr + "\n($e)";
    } else if (e == WebDataException.notFound().toString()) {
      return "not_found".tr + "\n($e)";
    } else {
      return e;
    }
  }
}
