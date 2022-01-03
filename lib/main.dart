import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './theme.dart';

import './controllers/local_data.dart';
import './controllers/web_data.dart';
import './controllers/authentication.dart';

import './pages/home_page/home_page.dart';
import './pages/login_page/login_page.dart';
import './pages/settings_page/settings_page.dart';
import './pages/settings_page/settings_subpages/filters_page.dart';
import './pages/settings_page/settings_subpages/personalization_page.dart';
import './pages/settings_page/settings_subpages/report_a_bug_page/report_bug_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localData = Get.put(LocalData());
  Get.put(WebData());
  final auth = Get.put(Authentication());
  await localData.initialize();
  await auth.login();
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
        GetPage(name: HomePage.route, page: () => const HomePage()),
        GetPage(name: LoginPage.route, page: () => const LoginPage()),
        GetPage(name: SettingsPage.route, page: () => const SettingsPage()),
        GetPage(name: FiltersPage.route, page: () => const FiltersPage()),
        GetPage(
          name: PersonalizationPage.route,
          page: () => const PersonalizationPage(),
        ),
        GetPage(name: ReportBugPage.route, page: () => const ReportBugPage())
      ],
      home: GetBuilder<Authentication>(
        builder: (controller) {
          return controller.authState == AuthState.LOGGED_IN
              ? const HomePage()
              : const LoginPage();
        },
      ),
    );
  }
}
