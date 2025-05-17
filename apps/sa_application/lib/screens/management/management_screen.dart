import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart' as loading_indicator;
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

/// The management screen of the application, providing two to four tabs, depending on the user's privileges.
class SManagementScreen extends ConsumerStatefulWidget {
  /// Create a new [SManagementScreen].
  const SManagementScreen({super.key});

  @override
  ConsumerState<SManagementScreen> createState() => _SManagementScreenState();
}

class _SManagementScreenState extends ConsumerState<SManagementScreen> with WidgetsBindingObserver {
  DateTime? _pauseTime;
  var _initial = true;
  var _index = 0;

  /// Callback for when the student view button is pressed.
  void _onPressedStudentView() {
    GoRouter.of(context).pushReplacement('/home');
  }

  /// Callback for when the settings button is pressed.
  void _onPressedSettings() {
    GoRouter.of(context).push('/settings');
  }

  /// Callback for when the add school life item button is pressed.
  Future<void> _onPressedAddSchoolLifeItem() async {
    // Show a dialog to create a new school life item.
    final input = await sShowAdaptiveDialog<SSchoolLifeItem>(
      context: context,
      builder: (context) => const SSchoolLifeDialog(),
    );

    if (input != null) {
      // Save the new school life item to the database.
      final res = await ref.read(sSchoolLifeProvider.notifier).add(input);

      // Show a toast if an error occurred.
      res.fold(
        (l) => sShowDataExceptionToast(
          context: context,
          exception: l,
        ),
        (r) => null,
      );
    }
  }

  /// Callback for when the add teacher button is pressed.
  Future<void> _onPressedAddTeacher() async {
    // Show a dialog to create a new teacher.
    final input = await sShowAdaptiveDialog<STeacherItem>(
      context: context,
      builder: (context) => const STeacherDialog(),
    );

    if (input != null) {
      // Save the new teacher to the database.
      final res = await ref.read(sTeachersProvider.notifier).add(input);

      // Show a toast if an error occurred.
      res.fold(
        (l) => sShowDataExceptionToast(
          context: context,
          exception: l,
        ),
        (r) => null,
      );
    }
  }

  /// Callback for refreshing the content.
  Future<IndicatorResult> _onRefresh() async {
    final result = await ref.read(sLoadingProvider.notifier).loadManagement();

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
      (r) => IndicatorResult.success,
    );
  }

  /// Callback for switching the tab.
  void _onSwitchTab(int index) {
    setState(() => _index = index);
  }

  @override
  void initState() {
    // Refresh the content as soon as the screen is built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for at least 500 milliseconds.
      // If the loading goes too fast, it seems like the app is flickering.
      // Ensure to clear the state if the loading fails.
      await Future.wait([
        Future<void>.delayed(const Duration(milliseconds: 500)),
        _onRefresh(),
      ]);

      setState(() => _initial = false);
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // If the app is paused, store the pause time.
    if (state == AppLifecycleState.paused) {
      _pauseTime = DateTime.now();
    }

    // Restart the entire application if the app is resumed after being paused for more than 15 minutes.
    // This is done to avoid any outdated data to be displayed.
    else if (state == AppLifecycleState.resumed) {
      if (_pauseTime != null && DateTime.now().difference(_pauseTime!).inMinutes > 5) {
        Phoenix.rebirth(context);
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
            SLocalizations.of(context)!.schoolLife,
            SLocalizations.of(context)!.teachers,
            SLocalizations.of(context)!.feedback,
            SLocalizations.of(context)!.administration,
          ][_index],
        ),
        prefixes: [
          FHeaderAction(
            icon: const Icon(FIcons.arrowLeftRight),
            onPress: _onPressedStudentView,
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
          : [
              SSchoolLifeManagementTab(
                onRefresh: _onRefresh,
              ),
              STeachersManagementTab(
                onRefresh: _onRefresh,
              ),
              SFeedbackManagementTab(
                onRefresh: _onRefresh,
              ),
              SAdminManagementTab(
                onRefresh: _onRefresh,
              ),
            ][_index],
      floatingActionButton: !_initial && _index < 2
          ? [
              FButton(
                intrinsicWidth: true,
                onPress: _onPressedAddSchoolLifeItem,
                prefix: const Icon(FIcons.plus),
                child: Text(SLocalizations.of(context)!.addEntry),
              ),
              FButton(
                intrinsicWidth: true,
                onPress: _onPressedAddTeacher,
                prefix: const Icon(FIcons.plus),
                child: Text(SLocalizations.of(context)!.addTeacher),
              ),
            ][_index]
          : null,
      footer: FBottomNavigationBar(
        index: _index,
        onChange: _onSwitchTab,
        children: [
          FBottomNavigationBarItem(
            icon: const Icon(FIcons.users),
            label: Text(SLocalizations.of(context)!.schoolLife),
          ),
          FBottomNavigationBarItem(
            icon: const Icon(FIcons.signature),
            label: Text(SLocalizations.of(context)!.teachers),
          ),
          if (authState.isAdmin) ...[
            FBottomNavigationBarItem(
              icon: const Icon(FIcons.messageCircleWarning),
              label: Text(SLocalizations.of(context)!.feedback),
            ),
            // FBottomNavigationBarItem(
            //   icon: const Icon(FIcons.settings2),
            //   label: Text(SLocalizations.of(context)!.administration),
            // ),
          ],
        ],
      ),
    );
  }
}
