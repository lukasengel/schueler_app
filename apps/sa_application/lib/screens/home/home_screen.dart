import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/types/data_exception.dart';

/// The home screen of the application, providing three tabs.
class SHomeScreen extends ConsumerStatefulWidget {
  /// Create a new [SHomeScreen].
  const SHomeScreen({super.key});

  @override
  ConsumerState<SHomeScreen> createState() => _SHomeScreenState();
}

class _SHomeScreenState extends ConsumerState<SHomeScreen> {
  var _index = 0;

  /// Callback for when the settings button is pressed.
  void _onPressedSettings() {
    GoRouter.of(context).push('/settings');
  }

  /// Callback for when the refresh button is pressed.
  Future<void> _onPressedRefresh() async {
    final result = await ref.read(sLoadingProvider.notifier).load();

    // If an error occurred, show a toast for each type of exception.
    result.fold(
      (l) {
        // If, let's suppose, there is no internet connection, we don't want to show five toasts all saying the same thing.
        // Therefore, group all exception by their type and combine their descriptions and details.
        final groupedExceptions = l.groupListsBy((exception) => exception.type).entries.map((entry) {
          final descriptions = entry.value.map((e) => e.description);
          final details = entry.value.map((e) => e.details).nonNulls;

          return SDataException(
            type: entry.key,
            description: descriptions.map((e) => '\n- $e').join(),
            details: details.map((e) => '\n- $e').join(),
          );
        });

        // Show a toast for each grouped exception.
        for (final e in groupedExceptions) {
          sShowDataExceptionToast(
            context: context,
            exception: e,
          );
        }
      },
      (r) => null,
    );
  }

  /// Callback for switching the tab.
  void _onSwitchTab(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: SHeaderWrapper(
        child: FHeader.nested(
          title: SHeaderTitleWrapper(
            child: Text(
              [
                SLocalizations.of(context)!.substitutions,
                SLocalizations.of(context)!.news,
                SLocalizations.of(context)!.schoolLife,
              ][_index],
            ),
          ),
          prefixActions: [
            FHeaderAction(
              icon: FIcon(FAssets.icons.refreshCw),
              onPress: _onPressedRefresh,
            ),
          ],
          suffixActions: [
            FHeaderAction(
              icon: FIcon(FAssets.icons.settings),
              onPress: _onPressedSettings,
            ),
          ],
        ),
      ),
      content: Center(
        child: FIcon(
          FAssets.icons.construction,
        ),
      ),
      footer: FBottomNavigationBar(
        index: _index,
        onChange: _onSwitchTab,
        children: [
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.calendarSync),
            label: Text(SLocalizations.of(context)!.substitutions),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.megaphone),
            label: Text(SLocalizations.of(context)!.news),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.users),
            label: Text(SLocalizations.of(context)!.schoolLife),
          ),
        ],
      ),
    );
  }
}
