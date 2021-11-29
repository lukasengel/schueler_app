import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';

import '../../models/web_data_exception.dart';
import '../../widgets/dynamic_message_dialog.dart';

class LoginPageController extends GetxController {
  late LocalData localData;
  late WebData webData;
  final usernameController = TextEditingController();
  final passwortController = TextEditingController();
  RxBool working = false.obs;
  RxBool obscure = true.obs;
  RxString error = "".obs;

  @override
  onInit() {
    localData = Get.find<LocalData>();
    webData = Get.find<WebData>();
    usernameController.text = localData.settings.username;
    passwortController.text = localData.settings.password;
    error.value =
        webData.error != WebDataException.emptyCredentials().toString()
            ? translateError(webData.error)
            : "";
    super.onInit();
  }

  Future<void> login() async {
    working.value = true;
    error.value = "";
    localData.settings.username = usernameController.text;
    localData.settings.password = passwortController.text;
    await localData.writeSettings();
    await webData.fetchData();
    error.value = translateError(webData.error);
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
    if (e == WebDataException.emptyCredentials().toString()) {
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
