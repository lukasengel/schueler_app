import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/theme/_theme.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/sa_data.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen to display an article.
class SArticleScreen extends StatelessWidget {
  /// Create a new [SArticleScreen].
  const SArticleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final item = GoRouterState.of(context).extra;

    if (item is SSchoolLifeItem && item.article != null) {
      return SScaffold.constrained(
        header: SHeader(
          title: Text(
            item.headline,
          ),
          prefixes: [
            FHeaderAction.back(
              onPress: Navigator.of(context).pop,
            ),
          ],
        ),
        content: ListView(
          padding: SCustomStyles.adaptiveContentPadding(context),
          children: [
            // If this is a post, display the image at the top.
            if (item is SPostSchoolLifeItem)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 4,
                ),
                child: SBlurredBackgroundImage(
                  url: item.imageUrl,
                  height: 300,
                  width: double.infinity,
                  borderRadius: FTheme.of(context).style.borderRadius,
                ),
              ),

            // Display the date of the article on top.
            _buildCaption(context, item.datetime.formatDateLocalized(context)),

            // Build the article elements.
            ...item.article!.elements.map(
              (element) => element.map(
                headline: (headlineElement) => _buildHeadline(context, headlineElement.text),
                subheadline: (subheadlineElement) => _buildSubheadline(context, subheadlineElement.text),
                paragraph: (paragraphElement) => _buildParagraph(context, paragraphElement.text),
                content: (contentElement) => _buildContent(context, contentElement.text),
                image: (imageElement) => _buildImage(context, imageElement.src, imageElement.caption),
              ),
            ),

            // Display the author of the article at the bottom.
            Align(
              alignment: Alignment.centerRight,
              child: _buildCaption(context, item.article!.author),
            ),

            // If the article has a hyperlink, display a button to open it.
            if (item.hyperlink != null)
              Container(
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                alignment: Alignment.center,
                child: FButton(
                  intrinsicWidth: true,
                  prefix: const Icon(FIcons.link),
                  style: FButtonStyle.secondary,
                  onPress: () async {
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
                  },
                  child: Text(
                    SLocalizations.of(context)!.externalContent,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          SLocalizations.of(context)!.invalidArticle,
        ),
        prefixes: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
      ),
      content: SIconPlaceholder(
        message: SLocalizations.of(context)!.invalidArticle,
        icon: FIcons.ban,
      ),
    );
  }

  Widget _buildCaption(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.grey.shade400,
      ),
    );
  }

  Widget _buildHeadline(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubheadline(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildContent(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Text(
        text,
      ),
    );
  }

  Widget _buildImage(BuildContext context, String src, [String? caption]) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SBlurredBackgroundImage(
            url: src,
            height: 300,
            width: double.infinity,
            borderRadius: FTheme.of(context).style.borderRadius,
          ),
          if (caption != null)
            Text(
              caption,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.grey.shade400,
              ),
            ),
        ],
      ),
    );
  }
}
