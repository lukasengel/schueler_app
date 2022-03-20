import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './theme.dart';
import './routes.dart' as routes;

import './controllers/local_data.dart';
import './controllers/web_data.dart';
import './controllers/authentication.dart';
import './controllers/notifications.dart';

import './pages/home_page/home_page.dart';
import './pages/login_page/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localData = Get.put(LocalData());
  try {
    final webData = Get.put(WebData());
    final auth = Get.put(Authentication());
    final notifications = Get.put(Notifications());
    await localData.initialize();
    await auth.login();
    await notifications.initialize();
    await webData.fetchData();
    auth.authState.value = AuthState.LOGGED_IN;
    notifications.manageSubscription();
  } catch (e) {
    localData.error = e.toString();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final localData = Get.find<LocalData>();

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<Authentication>().authState;
    
    return GetMaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: localData.getThemeMode,
      translationsKeys: localData.translations,
      locale: localData.getLocale,
      fallbackLocale: const Locale("de", "DE"),
      title: "GG Schüler-App",
      getPages: routes.getPages,
      defaultTransition:
          Platform.isIOS ? Transition.cupertino : Transition.topLevel,
      home: authState.value == AuthState.LOGGED_IN
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
