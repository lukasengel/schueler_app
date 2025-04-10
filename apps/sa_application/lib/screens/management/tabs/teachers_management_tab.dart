import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/sa_data.dart';

/// Management screen tab for editing or removing teachers.
class STeachersManagementTab extends ConsumerStatefulWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [STeachersManagementTab].
  const STeachersManagementTab({
    required this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<STeachersManagementTab> createState() => _STeachersManagementTabState();
}

class _STeachersManagementTabState extends ConsumerState<STeachersManagementTab> {
  /// Callback for when a teacher tile is pressed.
  Future<void> _onEditTeacher(STeacherItem teacher) async {
    // Show a dialog to edit the teacher.
    final input = await sShowAdaptiveDialog<STeacherItem>(
      context: context,
      builder: (context) => STeacherDialog(
        initial: teacher,
      ),
    );

    if (input != null) {
      // Update the teacher in the database.
      final res = await ref.read(sTeachersProvider.notifier).update(input);

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

  /// Callback for when the delete button on a teacher tile is pressed.
  Future<void> _onDeleteTeacher(STeacherItem teacher) async {
    // Show a confirmation dialog.
    final input = await sShowPlatformConfirmDialog(
      context: context,
      title: SLocalizations.of(context)!.confirmDelete,
      content: SLocalizations.of(context)!.confirmDeleteMsg,
      confirmLabel: SLocalizations.of(context)!.delete,
    );

    if (input == true) {
      // Delete the teacher from the database.
      final res = await ref.read(sTeachersProvider.notifier).delete(teacher);

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

  @override
  Widget build(BuildContext context) {
    final teachers = ref.watch(sTeachersProvider);

    return SRefreshableContentWrapper(
      onRefresh: widget.onRefresh,
      sliver: teachers != null && teachers.isNotEmpty
          // Show a tile for each teacher.
          ? SliverList.separated(
              itemCount: teachers.length + 1,
              itemBuilder: (context, index) {
                // Show the number of elements at the end of the list.
                if (index == teachers.length) {
                  return Center(
                    child: Text(
                      SLocalizations.of(context)!.elements(teachers.length),
                      style: STheme.smallCaptionStyle(context),
                    ),
                  );
                }

                final teacher = teachers[index];

                return FTile(
                  subtitle: Text(teacher.name),
                  title: Text(teacher.abbreviation),
                  onPress: () => _onEditTeacher(teacher),
                  suffixIcon: FButton.icon(
                    onPress: () => _onDeleteTeacher(teacher),
                    style: FButtonStyle.ghost,
                    child: FIcon(
                      FAssets.icons.trash2,
                      color: FTheme.of(context).colorScheme.destructive,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: SStyles.defaultListTileSpacing,
              ),
            )
          // If there are no teachers to display, show an icon.
          : SliverFillRemaining(
              child: SIconPlaceholder(
                message: SLocalizations.of(context)!.noData,
                iconSvg: FAssets.icons.ban,
              ),
            ),
    );
  }
}
