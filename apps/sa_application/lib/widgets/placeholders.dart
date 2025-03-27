import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A placeholder widget to display when there is no data, either because of an empty list or an error.
class SNoDataPlaceholder extends StatelessWidget {
  /// The message to display.
  final String message;

  /// The icon to display as an SVG asset.
  final SvgAsset iconSvg;

  /// Create a new [SNoDataPlaceholder].
  const SNoDataPlaceholder({
    required this.message,
    required this.iconSvg,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: safePadding.bottom,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FIcon(
              iconSvg,
              size: 42,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message,
              style: FTheme.of(context).typography.sm,
            ),
          ],
        ),
      ),
    );
  }
}
