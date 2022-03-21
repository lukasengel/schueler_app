import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './theme.dart';
import './routes.dart' as routes;

import './controllers/local_data.dart';
import './controllers/authentication.dart';
import './controllers/notifications.dart';
import './controllers/web_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final localData = Get.put(LocalData());
  final auth = Get.put(Authentication());
  Get.put(WebData());
  Get.put(Notifications());

  await localData.initialize();
  await auth.login();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final localData = Get.find<LocalData>();
  final authState = Get.find<Authentication>().authState;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: localData.getThemeMode,
      translationsKeys: localData.translations,
      locale: const Locale("de", "DE"),
      title: "Schüler-App",
      getPages: routes.getPages,
      defaultTransition:
          Platform.isIOS ? Transition.cupertino : Transition.topLevel,
      initialRoute:
          authState.value == AuthState.LOGGED_IN ? routes.home : routes.login,
    );
  }
}
