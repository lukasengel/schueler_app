import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The home screen of the application, providing three tabs.
class SHomeScreen extends ConsumerStatefulWidget {
  /// Create a new [SHomeScreen].
  const SHomeScreen({super.key});

  @override
  ConsumerState<SHomeScreen> createState() => _SHomeScreenState();
}

class _SHomeScreenState extends ConsumerState<SHomeScreen> with SingleTickerProviderStateMixin {
  late FPopoverController _popoverController;
  var _initial = true;
  var _index = 0;

  /// Callback for when the management view button is pressed.
  void _onPressedManagementView() {
    GoRouter.of(context).push('/management');
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
      (r) => IndicatorResult.success,
    );
  }

  /// Callback for switching the tab.
  void _onSwitchTab(int index) {
    setState(() => _index = index);
  }

  @override
  void initState() {
    // Load data as soon as the screen is built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for at least 300 milliseconds.
      // If the loading goes too fast, it seems like the app is flickering.
      await Future.wait([
        _onRefresh(),
      ]);

      setState(() => _initial = false);
    });

    _popoverController = FPopoverController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
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
        suffixActions: [
          FPopoverMenu(
            popoverController: _popoverController,
            menu: [
              FTileGroup(
                children: [
                  FTile(
                    prefixIcon: FIcon(FAssets.icons.shield),
                    title: Text(SLocalizations.of(context)!.managementView),
                    onPress: _onPressedManagementView,
                  ),
                  FTile(
                    prefixIcon: FIcon(FAssets.icons.settings),
                    title: Text(SLocalizations.of(context)!.settings),
                    onPress: _onPressedSettings,
                  ),
                ],
              ),
            ],
            child: FHeaderAction(
              icon: FIcon(authState.isManager ? FAssets.icons.ellipsisVertical : FAssets.icons.settings),
              onPress: authState.isManager ? _popoverController.toggle : _onPressedSettings,
            ),
          ),
        ],
      ),
      content: _initial
          // If the screen is in initial state, show a loading indicator.
          ? Center(
              child: SIconPlaceholder(
                message: SLocalizations.of(context)!.loading,
                iconSvg: FAssets.icons.hourglass,
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
