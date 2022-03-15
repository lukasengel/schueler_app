import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import './login_page_controller.dart';

//TODO: Benachrichtigungen
//TODO: iOS Splash Screen
//TODO: Indexed Stack instead of GetBuilder
//TODO: ZZZ-Icon
//TODO: Login Page Logi
//TODO: Broadcast Message
//TODO: Android Cursor Size

class LoginPage extends StatelessWidget {
  static const route = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Get.isPlatformDarkMode
          ? Get.theme.scaffoldBackgroundColor
          : Get.theme.primaryColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: controller.onTappedScaffold,
        child: Column(
          children: [
// ###################################################################################
// #                              LOGO AND HEADLINE                                  #
// ###################################################################################
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  heightFactor: 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          backgroundColor: Get.theme.primaryColor,
                          radius: double.infinity,
                          child: Image.asset(
                            "assets/images/logo_light.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            "general/app_title".tr,
                            textAlign: TextAlign.center,
                            style: context.textTheme.headline1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: context.orientation == Orientation.landscape ? 4 : 3,
              child: Container(
                width: context.width >= 500 ? 500 : double.infinity,
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "login/login_header".tr,
                              style: Get.textTheme.headline6,
                            ),
                          ),
                          const SizedBox(height: 15),
                          // ###################################################################################
                          // #                              ERROR MESSSAGE                                     #
                          // ###################################################################################
                          Obx(
                            () => controller.error.isNotEmpty
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      controller.error.value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: context.theme.errorColor,
                                      ),
                                    ))
                                : Container(),
                          ),
                          // ###################################################################################
                          // #                                  LOGIN FORM                                     #
                          // ###################################################################################
                          SizedBox(
                            width: context.width >= 800
                                ? context.width / 2
                                : double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: context.textTheme.bodyText2!
                                      .copyWith(fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: "login/username".tr,
                                  ),
                                  autofillHints: const [AutofillHints.username],
                                  controller: controller.usernameController,
                                  textInputAction: TextInputAction.next,
                                ),
                                const Divider(
                                  height: 3,
                                  indent: 25,
                                  color: Colors.grey,
                                ),
                                Obx(
                                  () => TextField(
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: context.textTheme.bodyText2!
                                        .copyWith(fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: "login/password".tr,
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
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    controller: controller.passwortController,
                                    textInputAction: TextInputAction.done,
                                    obscureText: controller.obscure.value,
                                    onSubmitted: controller.onSubmitted,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Obx(
                                    () => SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: controller.onPressedLogin,
                                        child: controller.working.value
                                            ? const SpinKitThreeBounce(
                                                color: Colors.white,
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                    "login/login_button".tr),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton.icon(
                                  onPressed: controller.onPressedHelp,
                                  icon: const Icon(Icons.help_outline),
                                  label: Text(
                                    "login/credentials_button".tr,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ###################################################################################
                          // #                                  BOTTOM TEXT                                    #
                          // ###################################################################################
                          Text(
                            "general/school_name".tr.toUpperCase(),
                            style: Get.textTheme.headline2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
