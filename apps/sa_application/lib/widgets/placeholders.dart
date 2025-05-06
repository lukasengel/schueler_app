import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';

/// A general-purpose placeholder widget to display, for example when no data is available.
///
/// Consists of an icon and a message below it.
class SIconPlaceholder extends StatelessWidget {
  /// The message to display.
  final String message;

  /// The icon to display.
  final IconData icon;

  /// Create a new [SIconPlaceholder].
  const SIconPlaceholder({
    required this.message,
    required this.icon,
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
            Icon(
              icon,
              size: 42,
              color: FTheme.of(context).colors.foreground,
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

/// A general-purpose placeholder widget to display, for example when no data is available.
///
/// Consists of an SVG icon and a message below it.
class SSvgPlaceholder extends StatelessWidget {
  /// The message to display.
  final String message;

  /// The SVG asset to display.
  final String svgAsset;

  /// Create a new [SSvgPlaceholder].
  const SSvgPlaceholder({
    required this.message,
    required this.svgAsset,
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
            SvgPicture.asset(
              svgAsset,
              width: 42,
              height: 42,
              colorFilter: ColorFilter.mode(
                FTheme.of(context).colors.foreground,
                BlendMode.srcIn,
              ),
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
