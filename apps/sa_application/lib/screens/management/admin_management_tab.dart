import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The tab of the management screen for administrative tasks.
class SAdminManagementTab extends StatelessWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SAdminManagementTab].
  const SAdminManagementTab({
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SRefreshableContentWrapper(
      onRefresh: onRefresh,
      sliver: SliverFillRemaining(
        child: SIconPlaceholder(
          iconSvg: FAssets.icons.rabbit,
          message: 'Work in Progress',
        ),
      ),
    );
  }
}
