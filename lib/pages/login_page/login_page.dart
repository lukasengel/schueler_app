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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Get.theme.scaffoldBackgroundColor
          : Get.theme.colorScheme.primary,
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
                          backgroundColor: Get.theme.colorScheme.primary,
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
                            style: context.textTheme.headlineLarge,
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
                  color: Get.theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 3, 0, 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "login/login_header".tr,
                              style: Get.textTheme.headlineMedium,
                            ),
                          ),
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
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: context.theme.errorColor,
                                      ),
                                    ),
                                  )
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
                                  style: context.textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: context
                                        .theme.colorScheme.onTertiaryContainer,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: "login/username".tr,
                                  ),
                                  autofillHints: const [AutofillHints.username],
                                  controller: controller.usernameController,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => TextField(
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: context.textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                      fillColor: context.theme.colorScheme
                                          .onTertiaryContainer,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 10,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      hintText: "login/password".tr,
                                      suffixIcon: IconButton(
                                        splashRadius: 20,
                                        icon: Icon(
                                          controller.obscure.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: controller.toggleVisibility,
                                        color: Get.isDarkMode
                                            ? Get.theme.colorScheme.onTertiary
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
                                Container(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                            style: Get.textTheme.bodySmall,
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
