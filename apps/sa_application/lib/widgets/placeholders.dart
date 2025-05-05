import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';

/// A general-purpose placeholder widget to display, for example when no data is available.
/// Contains an icon and a message below it.
class SIconPlaceholder extends StatelessWidget {
  /// The message to display.
  final String message;

  /// The widget to display as icon.
  final Widget icon;

  /// Create a new [SIconPlaceholder] with an icon.
  SIconPlaceholder.icon({
    required this.message,
    required IconData icon,
    super.key,
  }) : icon = Icon(
          icon,
          size: 42,
        );

  /// Create a new [SIconPlaceholder] with an SVG icon.
  SIconPlaceholder.svg({
    required BuildContext context,
    required this.message,
    required String svgAsset,
    super.key,
  }) : icon = SvgPicture.asset(
          svgAsset,
          width: 42,
          height: 42,
          colorFilter: ColorFilter.mode(
            FTheme.of(context).colors.foreground,
            BlendMode.srcIn,
          ),
        );

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
            icon,
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
