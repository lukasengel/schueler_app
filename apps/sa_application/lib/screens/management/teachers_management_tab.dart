import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

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
  /// Callback for when the edit button on a teacher tile is pressed.
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
      sliver: SContentList(
        items: teachers,
        tileBuilder: (context, item, _) => SManagementTile(
          title: Text(item.abbreviation),
          subtitle: Text(item.name),
          onDelete: () => _onDeleteTeacher(item),
          onEdit: () => _onEditTeacher(item),
        ),
        emptyBuilder: (context) => SIconPlaceholder(
          message: SLocalizations.of(context)!.noTeachers,
          iconSvg: const SvgAsset(null, 'icon_black', 'assets/images/lucky_cat.svg'),
        ),
      ),
    );
  }
}
