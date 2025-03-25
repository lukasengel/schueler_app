import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The settings root screen.
class SSettingsScreen extends ConsumerStatefulWidget {
  /// Create a new [SSettingsScreen].
  const SSettingsScreen({super.key});

  @override
  ConsumerState<SSettingsScreen> createState() => _SSettingsScreenState();
}

class _SSettingsScreenState extends ConsumerState<SSettingsScreen> {
  /// Callback for when the personalization tile is pressed.
  void _onPressedPersonalization() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const SPersonalizationScreen(),
      ),
    );
  }

  /// Callback for when the filter table tile is pressed.
  void _onPressedFilterTable() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const SFilterTableScreen(),
      ),
    );
  }

  /// Callback for when the teacher abbreviations tile is pressed.
  void _onPressedTeacherAbbreviations() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const STeacherAbbreviationsScreen(),
      ),
    );
  }

  /// Callback for when the report bugs tile is pressed.
  void _onPressedReportBugs() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const SReportBugsScreen(),
      ),
    );
  }

  /// Callback for when the GitHub tile is pressed.
  void _onPressedGitHub() {
    // TODO: Implement, once global settings are available.
  }

  /// Callback for when the GitHub tile is long pressed.
  Future<void> _onLongPressedGitHub() async {
    final newValue = !ref.read(sLocalSettingsProvider).developerMode;
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(developerMode: newValue);

    result.fold(
      (l) => sShowDataExceptionToast(
        context: context,
        exception: l,
        message: SAppLocalizations.of(context)!.failedSavingSettings,
      ),
      (r) => sShowInfoToast(
        context: context,
        message: SAppLocalizations.of(context)!.developerModeMsg(newValue.toString()),
      ),
    );
  }

  /// Callback for when the log out button is pressed.
  void _onPressedLogOut() {
    // TODO: Implement, once authentication is available.
  }

  @override
  Widget build(BuildContext context) {
    final smallCaptionStyle = FTheme.of(context).typography.sm.copyWith(
          color: FTheme.of(context).colorScheme.mutedForeground,
          letterSpacing: 1,
        );

    final mediumCaptionStyle = FTheme.of(context).typography.base.copyWith(
          color: FTheme.of(context).colorScheme.mutedForeground,
          letterSpacing: 1.5,
        );

    return FScaffold(
      header: SHeaderWrapper(
        child: FHeader.nested(
          title: SHeaderTitleWrapper(
            child: Text(
              SAppLocalizations.of(context)!.settings,
            ),
          ),
          prefixActions: [
            FHeaderAction.back(
              onPress: Navigator.of(context).pop,
            ),
          ],
        ),
      ),
      content: SContentWrapper(
        child: ListView(
          padding: sDefaultListViewPadding,
          children: [
            FTile(
              prefixIcon: FIcon(FAssets.icons.pen),
              title: Text(SAppLocalizations.of(context)!.personalization),
              suffixIcon: FIcon(FAssets.icons.chevronRight),
              onPress: _onPressedPersonalization,
            ),
            const SizedBox(
              height: sDefaultListTileSpacing,
            ),
            FTile(
              prefixIcon: FIcon(FAssets.icons.listFilter),
              title: Text(SAppLocalizations.of(context)!.filterTable),
              suffixIcon: FIcon(FAssets.icons.chevronRight),
              onPress: _onPressedFilterTable,
            ),
            const SizedBox(
              height: sDefaultListTileSpacing,
            ),
            FTile(
              prefixIcon: FIcon(FAssets.icons.signature),
              title: Text(SAppLocalizations.of(context)!.teacherAbbreviations),
              suffixIcon: FIcon(FAssets.icons.chevronRight),
              onPress: _onPressedTeacherAbbreviations,
            ),
            const SizedBox(
              height: sDefaultListTileSpacing,
            ),
            FTile(
              prefixIcon: FIcon(FAssets.icons.messageSquareWarning),
              title: Text(SAppLocalizations.of(context)!.reportBugs),
              suffixIcon: FIcon(FAssets.icons.chevronRight),
              onPress: _onPressedReportBugs,
            ),
            const SizedBox(
              height: sDefaultListTileSpacing,
            ),
            FTile(
              prefixIcon: FIcon(FAssets.icons.github),
              title: Text(SAppLocalizations.of(context)!.github),
              suffixIcon: FIcon(FAssets.icons.chevronRight),
              onPress: _onPressedGitHub,
              onLongPress: _onLongPressedGitHub,
            ),
            const SizedBox(
              height: 1.5 * sDefaultListTileSpacing,
            ),
            Center(
              child: SizedBox(
                width: 220,
                child: FButton(
                  prefix: FIcon(FAssets.icons.logOut),
                  label: Text(SAppLocalizations.of(context)!.logOut),
                  onPress: _onPressedLogOut,
                ),
              ),
            ),
            const SizedBox(
              height: 1.5 * sDefaultListTileSpacing,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    SAppLocalizations.of(context)!.logoArtist.toUpperCase(),
                    style: smallCaptionStyle,
                  ),
                  Text(
                    sLogoArtist.toUpperCase(),
                    style: mediumCaptionStyle,
                  ),
                  const SizedBox(
                    height: sDefaultListTileSpacing,
                  ),
                  Text(
                    SAppLocalizations.of(context)!.developer.toUpperCase(),
                    style: smallCaptionStyle,
                  ),
                  Text(
                    sDeveloper.toUpperCase(),
                    style: mediumCaptionStyle,
                  ),
                  const SizedBox(
                    height: 2 * sDefaultListTileSpacing,
                  ),
                  Text(
                    SAppLocalizations.of(context)!.version(sVersion).toUpperCase(),
                    style: smallCaptionStyle,
                  ),
                  Text(
                    DateFormat.yMMMM(Localizations.localeOf(context).toString()).format(sReleaseMonth).toUpperCase(),
                    style: smallCaptionStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
