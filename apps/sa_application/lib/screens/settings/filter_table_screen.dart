import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The settings screen to manage filters for the substitution table.
class SFilterTableScreen extends ConsumerStatefulWidget {
  /// Create a new [SFilterTableScreen].
  const SFilterTableScreen({super.key});

  @override
  ConsumerState<SFilterTableScreen> createState() => _SFilterTableScreenState();
}

class _SFilterTableScreenState extends ConsumerState<SFilterTableScreen> {
  /// Callback for when the "Select/Deselect all" button is tapped.
  ///
  /// `true` to select all, `false` to deselect all.
  Future<void> _onPressedSelectAll(bool value) async {
    // Determine the set of IDs for all exclusion options.
    final exclusionIds = ref.read(sGlobalSettingsProvider)?.exclusionOptions.map((e) => e.id).toSet();

    if (exclusionIds != null) {
      // Determine the new set of excluded courses.
      final newExclusions = Set<String>.from(ref.read(sLocalSettingsProvider).excludedCourses);
      value ? newExclusions.removeAll(exclusionIds) : newExclusions.addAll(exclusionIds);

      // Update local settings.
      final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(excludedCourses: newExclusions);

      // Show a toast if an error occurred.
      result.fold(
        (l) => sShowDataExceptionToast(
          context: context,
          exception: l,
          message: SLocalizations.of(context)!.failedSavingSettings,
        ),
        (r) => null,
      );
    }
  }

  /// Callback for when the "How does this work?" button is tapped.
  void _onPressedHowDoesThisWork() {
    sShowPlatformMessageDialog(
      context: context,
      title: SLocalizations.of(context)!.howDoesThisWork,
      content: SLocalizations.of(context)!.filterInfo,
    );
  }

  /// Callback for when the checkbox tile of an exclusion option is tapped.
  Future<void> _onChangeExclusion(String id, bool value) async {
    // Determine the new set of excluded courses.
    final newExclusions = Set<String>.from(ref.read(sLocalSettingsProvider).excludedCourses);
    value ? newExclusions.add(id) : newExclusions.remove(id);

    // Update local settings.
    final result = await ref.read(sLocalSettingsProvider.notifier).updateWith(excludedCourses: newExclusions);

    // Show a toast if an error occurred.
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
  Widget build(BuildContext context) {
    final globalSettings = ref.watch(sGlobalSettingsProvider);
    final localSettings = ref.watch(sLocalSettingsProvider);

    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          SLocalizations.of(context)!.filterTable,
        ),
        prefixActions: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
      ),
      content: globalSettings != null && globalSettings.exclusionOptions.isNotEmpty
          // If global settings are available, show a checkbox tile for each exclusion option.
          ? ListView(
              padding: SStyles.listViewPadding,
              children: [
                FTileGroup.builder(
                  count: globalSettings.exclusionOptions.length,
                  tileBuilder: (context, index) {
                    // Determine if the course is excluded.
                    final exclusionOption = globalSettings.exclusionOptions[index];
                    final isExcluded = localSettings.excludedCourses.contains(exclusionOption.id);

                    return SCheckboxTile(
                      title: Text(exclusionOption.name),
                      onChanged: (value) => _onChangeExclusion(exclusionOption.id, !value),
                      value: !isExcluded,
                    );
                  },
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: SStyles.listTileSpacing,
                      ),
                      Builder(
                        builder: (context) {
                          // Determine if any course is excluded.
                          final isAnyExcluded = globalSettings.exclusionOptions.any(
                            (e) => localSettings.excludedCourses.contains(e.id),
                          );

                          return IntrinsicWidth(
                            child: FButton(
                              label: Text(
                                isAnyExcluded
                                    ? SLocalizations.of(context)!.selectAll
                                    : SLocalizations.of(context)!.deselectAll,
                              ),
                              style: FButtonStyle.secondary,
                              onPress: () => _onPressedSelectAll(isAnyExcluded),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: SStyles.listTileSpacing,
                      ),
                      FTappable.animated(
                        onPress: _onPressedHowDoesThisWork,
                        child: Text(
                          SLocalizations.of(context)!.howDoesThisWork,
                          style: FTheme.of(context).typography.sm,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          // Otherwise, show a placeholder.
          : SIconPlaceholder(
              message: SLocalizations.of(context)!.noData,
              iconSvg: FAssets.icons.ban,
            ),
    );
  }
}
