import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import './login_page_controller.dart';

class LoginPage extends StatelessWidget {
  static const route = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    if (Get.isPlatformDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    return Scaffold(
      body: GestureDetector(
        onTap: controller.onTappedScaffold,
        child: SafeArea(
          bottom: false,
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
// ###################################################################################
// #                              LOGO AND HEADLINE                                  #
// ###################################################################################
                    Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.scaleDown,
                      height: context.height / 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                      child: Text(
                        "app_title".tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline1,
                      ),
                    ),
// ###################################################################################
// #                              ERROR MESSSAGE                                     #
// ###################################################################################
                    Obx(
                      () => controller.error.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                controller.error.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Get.theme.errorColor,
                                ),
                              ))
                          : Container(),
                    ),
// ###################################################################################
// #                                  LOGIN FORM                                     #
// ###################################################################################
                    Column(
                      children: [
                        SizedBox(
                          width: context.width >= 800
                              ? context.width / 2
                              : double.infinity,
                          child: Column(
                            children: [
                              TextField(
                                style: Get.textTheme.bodyText1,
                                decoration: InputDecoration(
                                  hintText: "username".tr,
                                ),
                                controller: controller.usernameController,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => TextField(
                                  style: Get.textTheme.bodyText1,
                                  decoration: InputDecoration(
                                    hintText: "password".tr,
                                    suffixIcon: IconButton(
                                      splashRadius: 20,
                                      icon: Icon(
                                        controller.obscure.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: controller.toggleVisibility,
                                      color: Get.isPlatformDarkMode
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                  controller: controller.passwortController,
                                  textInputAction: TextInputAction.done,
                                  obscureText: controller.obscure.value,
                                  onSubmitted: controller.onSubmitted,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: controller.onPressedLogin,
                                    child: controller.working.value
                                        ? const SpinKitThreeBounce(
                                            color: Colors.white,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text("login".tr),
                                          ),
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: controller.onPressedHelp,
                                icon: const Icon(Icons.help_outline),
                                label: Text("credentials".tr),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
// ###################################################################################
// #                                  BOTTOM TEXT                                    #
// ###################################################################################
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "school_name".tr.toUpperCase(),
                        style: Get.textTheme.headline2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
