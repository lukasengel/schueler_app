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

/// The management screen tab for adding, editing and deleting school life items.
class SSchoolLifeManagementTab extends ConsumerStatefulWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SSchoolLifeManagementTab].
  const SSchoolLifeManagementTab({
    required this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<SSchoolLifeManagementTab> createState() => _SSchoolLifeManagementTabState();
}

class _SSchoolLifeManagementTabState extends ConsumerState<SSchoolLifeManagementTab> {
  /// Callback for when the edit button on a school life item tile is pressed.
  Future<void> _onEditSchoolLifeItem(SSchoolLifeItem item) async {
    // Show a dialog to edit the school life item.
    final input = await sShowAdaptiveDialog<SSchoolLifeItem>(
      context: context,
      builder: (context) => SSchoolLifeDialog(
        initial: item,
      ),
    );

    if (input != null) {
      // Update the school life item in the database.
      final res = await ref.read(sSchoolLifeProvider.notifier).update(input);

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

  /// Callback for when the delete button on a school life item tile is pressed.
  Future<void> _onDeleteSchoolLifeItem(SSchoolLifeItem item) async {
    // Show a confirmation dialog.
    final input = await sShowPlatformConfirmDialog(
      context: context,
      title: SLocalizations.of(context)!.confirmDelete,
      content: SLocalizations.of(context)!.confirmDeleteMsg,
      confirmLabel: SLocalizations.of(context)!.delete,
    );

    if (input == true) {
      // Delete the school life item from the database.
      final res = await ref.read(sSchoolLifeProvider.notifier).delete(item);

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
    final schoolLifeItems = ref.watch(sSchoolLifeProvider);

    return SRefreshableContentWrapper(
      onRefresh: widget.onRefresh,
      sliver: SContentList(
        items: schoolLifeItems,
        tileBuilder: (context, item, _) => SManagementTile(
          onEdit: () => _onEditSchoolLifeItem(item),
          onDelete: () => _onDeleteSchoolLifeItem(item),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.headline,
              ),
              const SizedBox(
                height: SStyles.tileElementSpacing,
              ),
              Text(
                item.content,
                style: FTheme.of(context).typography.sm,
                maxLines: 2,
              ),
              const SizedBox(
                height: SStyles.tileElementSpacing,
              ),
            ],
          ),
          subtitle: Text(
            item.datetime.toLocal().formatDateTimeLocalized(context),
          ),
        ),
        emptyBuilder: (context) => SIconPlaceholder(
          message: SLocalizations.of(context)!.noSchoolLifeItems,
          iconSvg: const SvgAsset(null, 'icon_black', 'assets/images/lucky_cat.svg'),
        ),
      ),
    );
  }
}
