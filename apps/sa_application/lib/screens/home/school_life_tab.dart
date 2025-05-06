import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_providers/sa_providers.dart';

/// The home screen tab for viewing school life items.
class SSchoolLifeTab extends ConsumerWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SSchoolLifeTab].
  const SSchoolLifeTab({
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(sSchoolLifeProvider);

    return SRefreshableWrapper(
      onRefresh: onRefresh,
      sliver: SContentList(
        items: items,
        showCount: false,
        tileBuilder: (context, item, child) => SSchoolLifeTile(
          key: ValueKey(item),
          item: item,
        ),
        emptyBuilder: (context) => SSvgPlaceholder(
          message: SLocalizations.of(context)!.noSchoolLifeItems,
          svgAsset: 'assets/images/lucky_cat.svg',
        ),
      ),
    );
  }
}
