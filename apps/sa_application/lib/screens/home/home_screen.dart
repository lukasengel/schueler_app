import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart' as loading_indicator;
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_providers/sa_providers.dart';

/// The home screen of the application, providing three tabs.
class SHomeScreen extends ConsumerStatefulWidget {
  /// Create a new [SHomeScreen].
  const SHomeScreen({super.key});

  @override
  ConsumerState<SHomeScreen> createState() => _SHomeScreenState();
}

class _SHomeScreenState extends ConsumerState<SHomeScreen> with WidgetsBindingObserver {
  DateTime? _latestRefresh;
  var _initial = true;
  var _index = 0;

  /// Callback for when the management view button is pressed.
  void _onPressedManagementView() {
    GoRouter.of(context).pushReplacement('/management');
  }

  /// Callback for when the settings button is pressed.
  void _onPressedSettings() {
    GoRouter.of(context).push('/settings');
  }

  /// Callback for refreshing the content.
  Future<IndicatorResult> _onRefresh() async {
    final result = await ref.read(sLoadingProvider.notifier).loadHome();

    return result.fold(
      (exceptions) {
        // Show a toast for each exception.
        for (final e in exceptions) {
          sShowDataExceptionToast(
            context: context,
            exception: e,
          );
        }

        return IndicatorResult.fail;
      },
      (r) {
        _latestRefresh = DateTime.now();
        return IndicatorResult.success;
      },
    );
  }

  /// Callback for switching the tab.
  void _onSwitchTab(int index) {
    setState(() => _index = index);
  }

  @override
  void initState() {
    // Load data as soon as the screen is built.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialRefresh());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Refresh method to be called when the screen is built or when the app is resumed.
  Future<void> _initialRefresh([bool long = true]) async {
    setState(() => _initial = true);

    // Wait for at least 500 milliseconds.
    // If the loading goes too fast, it seems like the app is flickering.
    await Future.wait([
      Future<void>.delayed(Duration(milliseconds: long ? 500 : 200)),
      _onRefresh(),
    ]);

    setState(() => _initial = false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Refresh the content when the app is resumed and the last refresh was more than 5 minutes ago.
    if (state == AppLifecycleState.resumed) {
      if (_latestRefresh == null || DateTime.now().difference(_latestRefresh!).inMinutes > 5) {
        _initialRefresh(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(sAuthProvider);

    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          [
            SLocalizations.of(context)!.substitutions,
            SLocalizations.of(context)!.news,
            SLocalizations.of(context)!.schoolLife,
          ][_index],
        ),
        prefixes: [
          // If the user has management privileges, provide a button to switch to the management view.
          if (authState.isManager)
            FHeaderAction(
              icon: const Icon(FIcons.arrowLeftRight),
              onPress: _onPressedManagementView,
            ),
        ],
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: _onPressedSettings,
          ),
        ],
      ),
      content: _initial
          // If the screen is in initial state, show a loading indicator.
          ? Center(
              child: SizedBox(
                height: 48,
                child: loading_indicator.LoadingIndicator(
                  indicatorType: loading_indicator.Indicator.ballSpinFadeLoader,
                  colors: [
                    FTheme.of(context).colors.foreground,
                  ],
                ),
              ),
            )
          // Otherwise, show the content.
          : IndexedStack(
              index: _index,
              children: [
                SSubstitutionsTab(
                  onRefresh: _onRefresh,
                ),
                SNewsTab(
                  onRefresh: _onRefresh,
                ),
                SSchoolLifeTab(
                  onRefresh: _onRefresh,
                ),
              ],
            ),
      footer: FBottomNavigationBar(
        index: _index,
        onChange: _onSwitchTab,
        children: [
          FBottomNavigationBarItem(
            icon: const Icon(FIcons.calendarSync),
            label: Text(SLocalizations.of(context)!.substitutions),
          ),
          FBottomNavigationBarItem(
            icon: const Icon(FIcons.megaphone),
            label: Text(SLocalizations.of(context)!.news),
          ),
          FBottomNavigationBarItem(
            icon: const Icon(FIcons.users),
            label: Text(SLocalizations.of(context)!.schoolLife),
          ),
        ],
      ),
    );
  }
}
