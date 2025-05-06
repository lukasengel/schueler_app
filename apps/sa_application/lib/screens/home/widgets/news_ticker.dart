import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:marquee/marquee.dart';

/// A widget to show a news ticker, i.e. a horizontally scrolling text.
class SNewsTicker extends StatelessWidget {
  /// The items of the ticker.
  final List<String> tickerItems;

  /// Create a new [SNewsTicker].
  const SNewsTicker({
    required this.tickerItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: FTheme.of(context).colors.primary,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: FTheme.of(context).colors.border,
            width: FTheme.of(context).style.borderWidth,
          ),
        ),
        boxShadow: FTheme.of(context).style.shadow,
      ),
      alignment: Alignment.center,
      child: Marquee(
        // Add separators between all items like on the website.
        text: tickerItems.map((item) => '    +++    $item').join(),
        style: TextStyle(
          color: FTheme.of(context).colors.primaryForeground,
          height: 1,
        ),
      ),
    );
  }
}
