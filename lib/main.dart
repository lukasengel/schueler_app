import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './theme.dart';

import './controllers/local_data.dart';
import './controllers/web_data.dart';

import './pages/home_page/home_page.dart';
import './pages/login_page/login_page.dart';
import './pages/settings_page/settings_page.dart';
import './pages/settings_page/settings_subpages/filters_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localData = Get.put(LocalData());
  final webData = Get.put(WebData());
  await localData.initialize();
  await webData.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final localData = Get.find<LocalData>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      translationsKeys: localData.translations,
      locale: const Locale("de", "DE"),
      defaultTransition:
          Platform.isIOS ? Transition.cupertino : Transition.fade,
      title: "GG-Schüler-App",
      getPages: [
        GetPage(name: HomePage.route, page: () => HomePage()),
        GetPage(name: LoginPage.route, page: () => LoginPage()),
        GetPage(name: SettingsPage.route, page: () => SettingsPage()),
        GetPage(name: FiltersPage.route, page: () => FiltersPage())
      ],
      home: GetBuilder<WebData>(builder: (controller) {
        return controller.authState == AuthState.loggedOff
            ? const LoginPage()
            : const HomePage();
      }),
    );
  }
}
