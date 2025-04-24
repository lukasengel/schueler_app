import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The home screen tab for viewing the substitutions plan.
class SSubstitutionsTab extends StatelessWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SSubstitutionsTab].
  const SSubstitutionsTab({
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SRefreshableContentWrapper(
      onRefresh: onRefresh,
      sliver: SliverFillRemaining(
        child: SIconPlaceholder(
          iconSvg: FAssets.icons.construction,
          message: 'Coming soon...',
        ),
      ),
    );
  }
}
