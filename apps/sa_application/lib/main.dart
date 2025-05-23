import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/android_system_overlay_styles.dart';
import 'package:sa_application/firebase_options.dart';
import 'package:sa_application/init.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/theme/_theme.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_providers/sa_providers.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize cache for images.
  await FastCachedImageConfig.init();

  // Set the system UI mode to edge-to-edge for Android 10 or higher.
  await sInitAndroidSystemOverlayStyles();

  // Attempt to load local settings and restore the user session.
  final overrides = await Future.wait([
    loadLocalSettings(),
    restoreSession(),
  ]);

  runApp(
    Phoenix(
      child: ProviderScope(
        // Add all non-null overrides to the provider scope.
        overrides: overrides.nonNulls.toList(),
        child: const MyApp(),
      ),
    ),
  );
}

/// Main application widget.
class MyApp extends ConsumerStatefulWidget {
  /// Create a new [MyApp].
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GoRouter? router;

  @override
  Widget build(BuildContext context) {
    SLogger.debug('Rebuilding MaterialApp.');
    final locale = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.locale));
    final themeMode = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.themeMode));

    // Refresh the router when the authentication state changes.
    ref.listen(sAuthProvider, (previous, next) {
      if (previous != next) {
        router?.refresh();
      }
    });

    // Determine the theme brighthness based on the theme mode.
    final themeBrightness = switch (themeMode) {
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
    };

    // Update the Android system overlay styles for Android 10 or higher based on the theme brightness.
    sUpdateAndroidSystemOverlayStyles(themeBrightness);

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: SConstants.appName,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => FTheme(
          data: themeBrightness == Brightness.light ? zincLight : zincDark,
          child: child!,
        ),
        themeMode: themeMode,
        theme: SCustomTheme.materialLight,
        darkTheme: SCustomTheme.materialDark,
        locale: locale,
        supportedLocales: SLocalizations.supportedLocales,
        localizationsDelegates: const [
          SLocalizations.delegate,
          FLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router ??= GoRouter(
          initialLocation: '/login',
          redirect: (context, state) {
            SLogger.debug("Navigating to '${state.fullPath}.'");
            final authState = ref.read(sAuthProvider);

            // 1. LOGIN PAGE
            if (!authState.isAuthenticated) {
              return '/login';
            }

            // If user is on the login page and authenticated, redirect them.
            if (state.fullPath == '/login') {
              // If the user has manager privileges, redirect to the management page. Otherwise, redirect to the home page.
              return authState.isManager ? '/management' : '/home';
            }

            // No redirect.
            return null;
          },
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => const SLoginScreen(),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => const SHomeScreen(),
              routes: [
                GoRoute(
                  path: '/article',
                  builder: (context, state) => const SArticleScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/management',
              builder: (context, state) => const SManagementScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SSettingsScreen(),
              routes: [
                GoRoute(
                  path: '/personalization',
                  builder: (context, state) => const SPersonalizationScreen(),
                ),
                GoRoute(
                  path: '/filter-table',
                  builder: (context, state) => const SFilterTableScreen(),
                ),
                GoRoute(
                  path: '/teacher-abbreviations',
                  builder: (context, state) => const STeacherAbbreviationsScreen(),
                ),
                GoRoute(
                  path: '/report-bugs',
                  builder: (context, state) => const SReportBugsScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
