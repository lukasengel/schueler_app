import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The management screen tab for adding, editing and deleting school life items.
class SSchoolLifeManagementTab extends StatelessWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SSchoolLifeManagementTab].
  const SSchoolLifeManagementTab({
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SRefreshableContentWrapper(
      onRefresh: onRefresh,
      sliver: SliverFillRemaining(
        child: Center(
          child: FIcon(
            FAssets.icons.construction,
          ),
        ),
      ),
    );
  }
}
