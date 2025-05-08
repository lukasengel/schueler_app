import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:locale_names/locale_names.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/theme/_theme.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

/// The settings screen for personalization.
class SPersonalizationScreen extends ConsumerStatefulWidget {
  /// Create a new [SPersonalizationScreen].
  const SPersonalizationScreen({super.key});

  @override
  ConsumerState<SPersonalizationScreen> createState() => _SPersonalizationScreenState();
}

class _SPersonalizationScreenState extends ConsumerState<SPersonalizationScreen> {
  // Controllers for the select menu tiles.
  FSelectMenuTileController<ThemeMode>? _themeModeController;
  FSelectMenuTileController<Locale>? _languageController;
  FSelectMenuTileController<int>? _daysController;

  /// Callback for when the theme mode is selected.
  Future<void> _onSelectThemeMode((ThemeMode, bool) selection) async {
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(themeMode: selection.$1);
    _showErrorToastOnLeft(result);
  }

  /// Callback for when the locale is selected.
  Future<void> _onSelectLocale((Locale, bool) selection) async {
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(locale: selection.$1);
    _showErrorToastOnLeft(result);
  }

  /// Callback for when the number of shown days is selected.
  Future<void> _onSelectShownDays((int, bool) selection) async {
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(shownDays: selection.$1);
    _showErrorToastOnLeft(result);
  }

  /// Callback for when the auto next day tile is pressed.
  Future<void> _onPressedAutoNextDay(bool newValue) async {
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(autoNextDay: newValue);
    _showErrorToastOnLeft(result);
  }

  /// Callback for when the inclusive language tile is pressed.
  void _onPressedInclusiveLanguage() {
    sShowCustomDialog<void>(
      context: context,
      content: Container(
        height: 250,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            'assets/images/lindner.gif',
          ),
        ),
      ),
      actions: [
        FButton(
          onPress: Navigator.of(context).pop,
          child: Text(SLocalizations.of(context)!.ok),
        ),
      ],
    );
  }

  /// Helper method to show an error toast, if updating the settings failed.
  void _showErrorToastOnLeft(Either<SDataException, Unit> result) {
    result.fold(
      (l) => sShowDataExceptionToast(
        context: context,
        exception: l,
        message: SLocalizations.of(context)!.failedSavingSettings,
      ),
      (r) => null,
    );
  }

  @override
  void dispose() {
    _themeModeController?.dispose();
    _languageController?.dispose();
    _daysController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          SLocalizations.of(context)!.personalization,
        ),
        prefixes: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
      ),
      content: ListView(
        padding: SCustomStyles.adaptiveContentPadding(context),
        children: [
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.themeMode));

              return FSelectMenuTile(
                autoHide: true,
                selectController: _themeModeController ??= FSelectMenuTileController.radio(
                  value: themeMode,
                ),
                onSelect: _onSelectThemeMode,
                prefixIcon: Icon(
                  switch (themeMode) {
                    ThemeMode.light => FIcons.sun,
                    ThemeMode.system => FIcons.sunMoon,
                    ThemeMode.dark => FIcons.moon,
                  },
                ),
                title: Text(SLocalizations.of(context)!.appearance),
                details: Text(
                  switch (themeMode) {
                    ThemeMode.light => SLocalizations.of(context)!.light,
                    ThemeMode.system => SLocalizations.of(context)!.system,
                    ThemeMode.dark => SLocalizations.of(context)!.dark,
                  },
                ),
                menu: [
                  FSelectTile(
                    title: Text(SLocalizations.of(context)!.light),
                    value: ThemeMode.light,
                  ),
                  FSelectTile(
                    title: Text(SLocalizations.of(context)!.system),
                    value: ThemeMode.system,
                  ),
                  FSelectTile(
                    title: Text(SLocalizations.of(context)!.dark),
                    value: ThemeMode.dark,
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: SCustomStyles.listTileSpacing,
          ),
          Consumer(
            builder: (context, ref, child) {
              final shownDays = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.shownDays));

              return FSelectMenuTile.builder(
                autoHide: true,
                selectController: _daysController ??= FSelectMenuTileController.radio(
                  value: shownDays,
                ),
                onSelect: _onSelectShownDays,
                prefixIcon: const Icon(FIcons.calendarCog),
                title: Text(SLocalizations.of(context)!.shownDays),
                description: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: Text(SLocalizations.of(context)!.shownDaysInfo),
                ),
                details: Text('$shownDays'),
                count: 4,
                menuBuilder: (context, index) => FSelectTile(
                  title: Text('${index + 2}'),
                  value: index + 2,
                ),
              );
            },
          ),
          const SizedBox(
            height: SCustomStyles.listTileSpacing,
          ),
          FLabel(
            axis: Axis.vertical,
            style: context.theme.labelStyles.verticalStyle,
            description: Padding(
              padding: const EdgeInsets.only(
                left: 5,
              ),
              child: Text(
                SLocalizations.of(context)!.autoNextDayInfo,
                style: FTheme.of(context).tileGroupStyle.descriptionTextStyle.maybeResolve({}),
              ),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final autoNextDay =
                    ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.autoNextDay));

                return SCheckboxTile(
                  title: Text(SLocalizations.of(context)!.autoNextDay),
                  onChanged: _onPressedAutoNextDay,
                  value: autoNextDay,
                );
              },
            ),
          ),
          const SizedBox(
            height: SCustomStyles.listTileSpacing,
          ),
          Consumer(
            builder: (context, ref, child) {
              final isDev = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.developerMode));
              final locale = ref.watch(sLocalSettingsProvider.select((localSettings) => localSettings.locale));

              return FTileGroup(
                description: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: Text(SLocalizations.of(context)!.languageInfo),
                ),
                children: [
                  // Only show inclusive language tile in developer mode.
                  if (isDev)
                    FTile(
                      prefixIcon: const Icon(FIcons.squareAsterisk),
                      title: Text(SLocalizations.of(context)!.inclusiveLanguage),
                      suffixIcon: FCheckbox(
                        onChange: (_) => _onPressedInclusiveLanguage(),
                      ),
                      onPress: _onPressedInclusiveLanguage,
                    ),
                  FSelectMenuTile.builder(
                    autoHide: true,
                    selectController: _languageController ??= FSelectMenuTileController.radio(
                      value: locale,
                    ),
                    onSelect: _onSelectLocale,
                    prefixIcon: const Icon(FIcons.languages),
                    title: Text(SLocalizations.of(context)!.language),
                    details: Text(locale.nativeDisplayLanguage.capitalize()),
                    count: SLocalizations.supportedLocales.length,
                    menuBuilder: (context, index) {
                      final locale = SLocalizations.supportedLocales[index];

                      return FSelectTile(
                        title: Text(locale.nativeDisplayLanguage.capitalize()),
                        value: locale,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
