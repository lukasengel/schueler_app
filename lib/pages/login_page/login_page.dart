import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import './login_page_controller.dart';

//TODO: Filtermechanismus verbessern, Sonstiges-Filter implementieren
//TODO: Klassenauswahl-Mechanismus
//TODO: Benachrichtigungen

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
        onTap: controller.onTappedScaffold,
        child: Column(
          children: [
// // ###################################################################################
// // #                              LOGO AND HEADLINE                                  #
// // ###################################################################################
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
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            "app_title".tr,
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
            Expanded(
              flex: context.orientation == Orientation.landscape ? 4 : 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Anmeldung",
                          style: Get.textTheme.headline6,
                        ),
                      ),
                      const SizedBox(height: 20),
// // ###################################################################################
// // #                              ERROR MESSSAGE                                     #
// // ###################################################################################
                      Obx(
                        () => controller.error.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
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
// // ###################################################################################
// // #                                  LOGIN FORM                                     #
// // ###################################################################################
                      SizedBox(
                        width: context.width >= 800
                            ? context.width / 2
                            : double.infinity,
                        child: Column(
                          children: [
                            TextField(
                              enableSuggestions: false,
                              autocorrect: false,
                              style: context.textTheme.bodyText1,
                              decoration: InputDecoration(
                                hintText: "username".tr,
                              ),
                              autofillHints: const [AutofillHints.username],
                              controller: controller.usernameController,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => TextField(
                                enableSuggestions: false,
                                autocorrect: false,
                                style: context.textTheme.bodyText1,
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
                                autofillHints: const [AutofillHints.password],
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text("login".tr),
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
                                "credentials".tr,
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
                        "school_name".tr.toUpperCase(),
                        style: Get.textTheme.headline2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
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
