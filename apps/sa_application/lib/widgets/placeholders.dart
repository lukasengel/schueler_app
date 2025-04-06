import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// A general-purpose placeholder widget to display, for example when no data is available.
class SIconPlaceholder extends StatelessWidget {
  /// The message to display.
  final String message;

  /// The icon to display as an SVG asset.
  final SvgAsset iconSvg;

  /// Create a new [SIconPlaceholder].
  const SIconPlaceholder({
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
