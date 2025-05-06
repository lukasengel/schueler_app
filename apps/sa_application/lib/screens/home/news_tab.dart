import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_providers/sa_providers.dart';

/// The home screen tab for viewing news from the principal's office.
class SNewsTab extends ConsumerWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SNewsTab].
  const SNewsTab({
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickerItems = ref.watch(sExternalDataProvider)?.tickerItems;
    final newsItems = ref.watch(sExternalDataProvider)?.newsItems;

    final hasTicker = tickerItems != null && tickerItems.isNotEmpty;

    return Stack(
      children: [
        SRefreshableWrapper(
          // If a ticker is present, add bottom padding to avoid overlapping.
          bottomPadding: hasTicker ? 44 : 0,
          onRefresh: onRefresh,
          sliver: SContentList(
            items: newsItems,
            showCount: false,
            tileBuilder: (context, item, child) => SNewsTile(
              key: ValueKey(item),
              item: item,
            ),
            emptyBuilder: (context) => SSvgPlaceholder(
              message: SLocalizations.of(context)!.noNews,
              svgAsset: 'assets/images/lucky_cat.svg',
            ),
          ),
        ),
        // Show news ticker, if available.
        if (hasTicker)
          OverflowBox(
            maxWidth: MediaQuery.sizeOf(context).width,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 8,
              ),
              alignment: Alignment.bottomCenter,
              child: SNewsTicker(
                tickerItems: tickerItems,
              ),
            ),
          ),
      ],
    );
  }
}
