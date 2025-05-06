import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';

/// Tile to display a news item on the home page.
class SNewsTile extends StatelessWidget {
  /// The news item to display.
  final SNewsItem item;

  /// Create a new [SNewsTile].
  const SNewsTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const headlineStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1,
    );

    const subheadlineStyle = TextStyle(
      // For some reason, the subheadline is displayed much larger than the headline on the website.
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1,
    );

    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.headline.hasContent)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  item.headline!,
                  style: headlineStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            if (item.subheadline.hasContent)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  item.subheadline!,
                  style: subheadlineStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            if (item.content.hasContent)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  item.content!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
