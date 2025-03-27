import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
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
        message: SAppLocalizations.of(context)!.failedSavingSettings,
      ),
      (r) => null,
    );
  }

  /// Callback for when the "How does this work?" button is tapped.
  void _onPressedHowDoesThisWork() {
    sShowPlatformMessageDialog(
      context: context,
      title: Text(SAppLocalizations.of(context)!.howDoesThisWork),
      content: Text(SAppLocalizations.of(context)!.filterInfo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalSettings = ref.watch(sGlobalSettingsProvider);
    final localSettings = ref.watch(sLocalSettingsProvider);

    return FScaffold(
      header: SHeaderWrapper(
        child: FHeader.nested(
          title: SHeaderTitleWrapper(
            child: Text(
              SAppLocalizations.of(context)!.filterTable,
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
        child: globalSettings != null
            // If global settings are available, show a checkbox tile for each exclusion option.
            ? ListView(
                padding: sDefaultListViewPadding,
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
                  const SizedBox(
                    height: sDefaultListTileSpacing,
                  ),
                  Center(
                    child: FTappable.animated(
                      onPress: _onPressedHowDoesThisWork,
                      child: Text(
                        SAppLocalizations.of(context)!.howDoesThisWork,
                        style: FTheme.of(context).typography.sm,
                      ),
                    ),
                  ),
                ],
              )
            // Otherwise, show a placeholder.
            : SNoDataPlaceholder(
                message: SAppLocalizations.of(context)!.noData,
                iconSvg: FAssets.icons.triangleAlert,
              ),
      ),
    );
  }
}
