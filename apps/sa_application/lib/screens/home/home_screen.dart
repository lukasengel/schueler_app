import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/widgets/_widgets.dart';

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
    Navigator.of(context).pushNamed('/settings');
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
                SAppLocalizations.of(context)!.substitutions,
                SAppLocalizations.of(context)!.news,
                SAppLocalizations.of(context)!.schoolLife,
              ][_index],
            ),
          ),
          prefixActions: [
            // TODO: Remove once proper authentication has been implemented.
            FHeaderAction(
              icon: FIcon(FAssets.icons.hardDriveDownload),
              onPress: () {
                ref.read(sTeachersProvider.notifier).load();
                ref.read(sGlobalSettingsProvider.notifier).load();
              },
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
            label: Text(SAppLocalizations.of(context)!.substitutions),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.megaphone),
            label: Text(SAppLocalizations.of(context)!.news),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.users),
            label: Text(SAppLocalizations.of(context)!.schoolLife),
          ),
        ],
      ),
    );
  }
}
