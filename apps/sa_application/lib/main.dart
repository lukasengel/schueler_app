import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/firebase_options.dart';
import 'package:sa_application/init.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/util/_util.dart';
import 'package:toastification/toastification.dart';

// TODO: Display pre-load exceptions.
// TODO: Disable offline persistence for the Firebase Firestore instance.
// TODO: Scrollbars, especially for the teacher abbreviations screen.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pre-load the application state.
  final preloadResult = await preloadState();

  runApp(
    ProviderScope(
      overrides: preloadResult.$1,
      child: const MyApp(),
    ),
  );
}

/// Main application widget of the application.
class MyApp extends ConsumerStatefulWidget {
  /// Create a new [MyApp].
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.locale));
    final themeMode = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.themeMode));

    return ToastificationWrapper(
      child: MaterialApp(
        title: sAppName,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => FTheme(
          data: SAppTheme.adaptive(context, themeMode),
          child: child!,
        ),
        themeMode: themeMode,
        theme: SAppTheme.light,
        darkTheme: SAppTheme.dark,
        locale: locale,
        supportedLocales: SAppLocalizations.supportedLocales,
        localizationsDelegates: const [
          SAppLocalizations.delegate,
          FLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {
          '/': (context) => const SHomeScreen(),
          '/settings': (context) => const SSettingsScreen(),
        },
      ),
    );
  }
}
