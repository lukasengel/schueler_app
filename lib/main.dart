import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './theme.dart';
import './routes.dart' as routes;

import './controllers/local_data.dart';
import './controllers/web_data.dart';
import './controllers/authentication.dart';

import './pages/home_page/home_page.dart';
import './pages/login_page/login_page.dart';

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

  Locale get getLocale {
    Locale locale = const Locale("de", "DE");
    final deviceLocale = Get.deviceLocale;
    if (!localData.settings.forceGerman &&
        localData.supported.contains(deviceLocale) &&
        deviceLocale != null) {
      locale = Get.deviceLocale!;
    }
    return locale;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.dark,
      translationsKeys: localData.translations,
      locale: getLocale,
      fallbackLocale: const Locale("de", "DE"),
      title: "GG-Schüler-App",
      getPages: routes.getPages,
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
