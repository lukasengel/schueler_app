import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tile to display a school life item on the home page.
class SSchoolLifeTile extends StatelessWidget {
  /// The school life item to display.
  final SSchoolLifeItem item;

  /// Create a new [SSchoolLifeTile].
  const SSchoolLifeTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return item.map(
      announcement: (announcementItem) => _SSchoolLifeBaseTile(
        key: key,
        item: announcementItem,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.headline,
              style: FTheme.of(context).cardStyle.contentStyle.titleTextStyle,
            ),
          ],
        ),
      ),
      event: (eventItem) => _SSchoolLifeBaseTile(
        key: key,
        item: eventItem,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventItem.eventDate.formatDateLocalized(context),
              style: FTheme.of(context).typography.lg,
            ),
            Text(
              item.headline,
              style: FTheme.of(context).cardStyle.contentStyle.titleTextStyle,
            ),
          ],
        ),
      ),
      post: (postItem) => _SPostSchoolLifeTile(
        key: key,
        item: postItem,
      ),
    );
  }
}

/// Tile to display a post school life item item on the home page.
class _SPostSchoolLifeTile extends StatelessWidget {
  /// The post item to display.
  final SPostSchoolLifeItem item;

  /// Create a new [_SPostSchoolLifeTile].
  const _SPostSchoolLifeTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _SSchoolLifeBaseTile(
      key: key,
      item: item,
      childPadding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SBlurredBackgroundImage(
            url: item.imageUrl,
            height: 300,
            width: double.infinity,
            // Only round the top corners of the image.
            borderRadius: BorderRadius.vertical(
              top: FTheme.of(context).style.borderRadius.topRight,
            ),
          ),
          // Display a container that contains the headline of the post.
          Container(
            // Add a margin, so it does not overlap the border of the image.
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            color: (item.darkHeadline ? Colors.black : Colors.white).withValues(
              alpha: 0.4,
            ),
            child: Text(
              item.headline.toUpperCase(),
              maxLines: 3,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Common base tile for all types of school life items.
class _SSchoolLifeBaseTile extends StatelessWidget {
  /// The item to display.
  final SSchoolLifeItem item;

  /// The type-specific content to display.
  final Widget child;

  /// Padding for the child widget.
  final EdgeInsets childPadding;

  /// Create a new [_SSchoolLifeBaseTile].
  const _SSchoolLifeBaseTile({
    required this.item,
    required this.child,
    this.childPadding = const EdgeInsets.fromLTRB(15, 5, 15, 3),
    super.key,
  });

  /// Callback for when the tile is tapped.
  Future<void> _onTap(BuildContext context) async {
    // Open the article, if available.
    if (item.article != null) {
      await GoRouter.of(context).push(
        '/home/article',
        extra: item,
      );
    }
    // Otherwise, open the hyperlink.
    else if (item.hyperlink != null) {
      // Attempt to launch the URL.
      try {
        await launchUrl(
          Uri.parse(item.hyperlink!),
        );
      }
      // If any error occurs, show an error toast.
      catch (e) {
        if (context.mounted) {
          sShowErrorToast(
            context: context,
            message: SLocalizations.of(context)!.failedLaunchingUrl,
            details: e.toString(),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tileStyle = FTheme.of(context).tileGroupStyle.tileStyle;
    final cardStyle = FTheme.of(context).cardStyle;

    // A tile should be tappable if it has a hyperlink or an article or both.
    final tappable = item.hyperlink.hasContent || item.article != null;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: tappable ? () => _onTap(context) : null,
      child: FCard.raw(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: childPadding,
              child: child,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.content,
                    style: tileStyle.contentStyle.enabledStyle.titleTextStyle,
                    maxLines: 100,
                  ),
                  // If the tile is tappable, display a hint for the user.
                  if (tappable)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          SLocalizations.of(context)!.tapToReadMore,
                          style: cardStyle.contentStyle.subtitleTextStyle.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  // Display the creation date and type of the item.
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.map(
                            announcement: (_) => SLocalizations.of(context)!.announcement,
                            event: (_) => SLocalizations.of(context)!.event,
                            post: (_) => SLocalizations.of(context)!.post,
                          ),
                          style: tileStyle.contentStyle.enabledStyle.subtitleTextStyle,
                        ),
                        Text(
                          item.datetime.formatDateLocalized(context),
                          style: tileStyle.contentStyle.enabledStyle.subtitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
