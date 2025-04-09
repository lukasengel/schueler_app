import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/firebase_options.dart';
import 'package:sa_application/init.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_common/sa_common.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Attempt to load local settings and restore the user session.
  final overrides = await Future.wait([
    loadLocalSettings(),
    restoreSession(),
  ]);

  runApp(
    ProviderScope(
      // Add all non-null overrides to the provider scope.
      overrides: overrides.nonNulls.toList(),
      child: const MyApp(),
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

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: SConstants.appName,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => FTheme(
          data: STheme.foruiAdaptive(context, themeMode),
          child: child!,
        ),
        themeMode: themeMode,
        theme: STheme.materialLight,
        darkTheme: STheme.materialDark,
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
