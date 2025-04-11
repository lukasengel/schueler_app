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
      sliver: feedbackItems != null && feedbackItems.isNotEmpty
          // Show a tile for each feedback item.
          ? SliverList.separated(
              itemCount: feedbackItems.length + 1,
              itemBuilder: (context, index) {
                // Show the number of elements at the end of the list.
                if (index == feedbackItems.length) {
                  return Center(
                    child: Text(
                      SLocalizations.of(context)!.elements(feedbackItems.length),
                      style: STheme.smallCaptionStyle(context),
                    ),
                  );
                }

                final feedbackItem = feedbackItems[index];

                return SManagementTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FLabel(
                        axis: Axis.vertical,
                        label: Text(SLocalizations.of(context)!.message),
                        child: Text(
                          feedbackItem.message,
                          maxLines: 100,
                        ),
                      ),
                      // Show name, if available.
                      if (feedbackItem.name != null) ...[
                        const SizedBox(
                          height: 8,
                        ),
                        FLabel(
                          axis: Axis.vertical,
                          label: Text(SLocalizations.of(context)!.name),
                          child: Text(feedbackItem.name!),
                        ),
                      ],
                      // Show email, if available.
                      if (feedbackItem.email != null) ...[
                        const SizedBox(
                          height: 8,
                        ),
                        FLabel(
                          axis: Axis.vertical,
                          label: Text(SLocalizations.of(context)!.email),
                          child: Text(feedbackItem.email!),
                        ),
                      ],
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    feedbackItem.datetime.formatLocalized(context),
                  ),
                  onDelete: () => _onDeleteFeedback(feedbackItem),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: SStyles.defaultListTileSpacing,
              ),
            )
          // If there is no feedback to display, show an icon.
          : SliverFillRemaining(
              child: feedbackItems == null
                  // If the list is null, it means that the data could not be loaded.
                  ? SIconPlaceholder(
                      message: SLocalizations.of(context)!.noData,
                      iconSvg: FAssets.icons.ban,
                    )
                  // If the list is empty, it means that there is no feedback available.
                  : SIconPlaceholder(
                      message: SLocalizations.of(context)!.noFeedback,
                      iconSvg: const SvgAsset(null, 'icon_black', 'assets/images/lucky_cat.svg'),
                    ),
            ),
    );
  }
}
