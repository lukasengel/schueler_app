import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/sa_data.dart';

/// The tab of the management screen for reviewing feedback.
class SFeedbackManagementTab extends ConsumerStatefulWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SFeedbackManagementTab].
  const SFeedbackManagementTab({
    required this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<SFeedbackManagementTab> createState() => _SFeedbackManagementTabState();
}

class _SFeedbackManagementTabState extends ConsumerState<SFeedbackManagementTab> {
  /// Callback for when the delete button on a feedback tile is pressed.
  Future<void> _onDeleteFeedback(SFeedbackItem feedbackItem) async {
    // Show a confirmation dialog.
    final input = await sShowPlatformConfirmDialog(
      context: context,
      title: SLocalizations.of(context)!.confirmDelete,
      content: SLocalizations.of(context)!.confirmDeleteMsg,
      confirmLabel: SLocalizations.of(context)!.delete,
    );

    if (input == true) {
      // Delete the teacher from the database.
      final res = await ref.read(sFeedbackProvider.notifier).delete(feedbackItem);

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
    final feedbackItems = ref.watch(sFeedbackProvider);

    return SRefreshableContentWrapper(
      onRefresh: widget.onRefresh,
      sliver: SContentList(
        items: feedbackItems,
        tileBuilder: (context, item, _) => SManagementTile(
          onDelete: () => _onDeleteFeedback(item),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FLabel(
                axis: Axis.vertical,
                label: Text(SLocalizations.of(context)!.message),
                child: Text(
                  item.message,
                  maxLines: 100,
                ),
              ),
              const SizedBox(
                height: SStyles.tileElementSpacing,
              ),
              // Show name, if available.
              if (item.name != null) ...[
                FLabel(
                  axis: Axis.vertical,
                  label: Text(SLocalizations.of(context)!.name),
                  child: Text(item.name!),
                ),
                const SizedBox(
                  height: SStyles.tileElementSpacing,
                ),
              ],
              // Show email, if available.
              if (item.email != null) ...[
                FLabel(
                  axis: Axis.vertical,
                  label: Text(SLocalizations.of(context)!.email),
                  child: Text(item.email!),
                ),
                const SizedBox(
                  height: SStyles.tileElementSpacing,
                ),
              ],
            ],
          ),
          subtitle: Text(
            item.datetime.formatDateTimeLocalized(context),
          ),
        ),
        emptyBuilder: (context) => SIconPlaceholder(
          message: SLocalizations.of(context)!.noFeedback,
          iconSvg: const SvgAsset(null, 'icon_black', 'assets/images/lucky_cat.svg'),
        ),
      ),
    );
  }
}
