import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
    GoRouter.of(context).push('/settings/personalization');
  }

  /// Callback for when the filter table tile is pressed.
  void _onPressedFilterTable() {
    GoRouter.of(context).push('/settings/filter-table');
  }

  /// Callback for when the teacher abbreviations tile is pressed.
  void _onPressedTeacherAbbreviations() {
    GoRouter.of(context).push('/settings/teacher-abbreviations');
  }

  /// Callback for when the report bugs tile is pressed.
  void _onPressedReportBugs() {
    GoRouter.of(context).push('/settings/report-bugs');
  }

  /// Callback for when the GitHub tile is pressed.
  Future<void> _onPressedGitHub() async {
    final url = ref.read(sGlobalSettingsProvider)?.githubUrl;

    if (url != null) {
      final uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        // Attempt to launch the URL.
        try {
          final success = await launchUrl(uri);

          if (success) {
            return;
          }
        }
        // If any error occurs, show an error toast.
        catch (_) {
          if (mounted) {
            sShowErrorToast(
              context: context,
              message: SLocalizations.of(context)!.failedLaunchingUrl,
            );

            return;
          }
        }
      }
    }

    // Show error toast if global settings are not available or URL could not be launched.
    if (mounted) {
      sShowErrorToast(
        context: context,
        message: SLocalizations.of(context)!.noData,
      );
    }
  }

  /// Callback for when the GitHub tile is long pressed.
  Future<void> _onLongPressedGitHub() async {
    final newValue = !ref.read(sLocalSettingsProvider).developerMode;
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(developerMode: newValue);

    result.fold(
      (l) => sShowDataExceptionToast(
        context: context,
        exception: l,
        message: SLocalizations.of(context)!.failedSavingSettings,
      ),
      (r) => sShowInfoToast(
        context: context,
        message: SLocalizations.of(context)!.developerModeMsg(newValue.toString()),
      ),
    );
  }

  /// Callback for when the log out button is pressed.
  Future<void> _onPressedLogOut() async {
    // Ask for confirmation.
    final input = await sShowPlatformConfirmDialog(
      context: context,
      title: SLocalizations.of(context)!.confirmLogout,
      content: SLocalizations.of(context)!.confirmLogoutMsg,
      confirmLabel: SLocalizations.of(context)!.logOut,
    );

    if (input) {
      // Log out the user.
      final result = await ref.read(sAuthProvider.notifier).logout();

      // Show a toast if an error occurred.
      result.fold(
        (l) => sShowDataExceptionToast(
          context: context,
          exception: l,
        ),
        (r) => null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          SLocalizations.of(context)!.settings,
        ),
        prefixActions: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
      ),
      content: ListView(
        padding: SStyles.defaultListViewPadding,
        children: [
          FTile(
            prefixIcon: FIcon(FAssets.icons.pen),
            title: Text(SLocalizations.of(context)!.personalization),
            suffixIcon: FIcon(FAssets.icons.chevronRight),
            onPress: _onPressedPersonalization,
          ),
          const SizedBox(
            height: SStyles.defaultListTileSpacing,
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.listFilter),
            title: Text(SLocalizations.of(context)!.filterTable),
            suffixIcon: FIcon(FAssets.icons.chevronRight),
            onPress: _onPressedFilterTable,
          ),
          const SizedBox(
            height: SStyles.defaultListTileSpacing,
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.signature),
            title: Text(SLocalizations.of(context)!.teacherAbbreviations),
            suffixIcon: FIcon(FAssets.icons.chevronRight),
            onPress: _onPressedTeacherAbbreviations,
          ),
          const SizedBox(
            height: SStyles.defaultListTileSpacing,
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.messageSquareWarning),
            title: Text(SLocalizations.of(context)!.reportBugs),
            suffixIcon: FIcon(FAssets.icons.chevronRight),
            onPress: _onPressedReportBugs,
          ),
          const SizedBox(
            height: SStyles.defaultListTileSpacing,
          ),
          FTile(
            prefixIcon: FIcon(FAssets.icons.github),
            title: Text(SLocalizations.of(context)!.github),
            suffixIcon: FIcon(FAssets.icons.chevronRight),
            onPress: _onPressedGitHub,
            onLongPress: _onLongPressedGitHub,
          ),
          const SizedBox(
            height: 1.5 * SStyles.defaultListTileSpacing,
          ),
          Center(
            child: SButton(
              prefix: FIcon(FAssets.icons.logOut),
              label: Text(SLocalizations.of(context)!.logOut),
              onPressed: _onPressedLogOut,
            ),
          ),
          const SizedBox(
            height: 1.5 * SStyles.defaultListTileSpacing,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  SLocalizations.of(context)!.logoArtist.toUpperCase(),
                  style: STheme.smallCaptionStyle(context),
                ),
                Text(
                  SConstants.logoArtist.toUpperCase(),
                  style: STheme.mediumCaptionStyle(context),
                ),
                const SizedBox(
                  height: SStyles.defaultListTileSpacing,
                ),
                Text(
                  SLocalizations.of(context)!.developer.toUpperCase(),
                  style: STheme.mediumCaptionStyle(context),
                ),
                Text(
                  SConstants.developer.toUpperCase(),
                  style: STheme.smallCaptionStyle(context),
                ),
                const SizedBox(
                  height: 2 * SStyles.defaultListTileSpacing,
                ),
                Text(
                  SLocalizations.of(context)!.version(SConstants.version).toUpperCase(),
                  style: STheme.smallCaptionStyle(context),
                ),
                Text(
                  DateFormat.yMMMM(Localizations.localeOf(context).toString())
                      .format(SConstants.releaseMonth)
                      .toUpperCase(),
                  style: STheme.smallCaptionStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
