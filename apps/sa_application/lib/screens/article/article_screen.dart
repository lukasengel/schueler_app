import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:glossy/glossy.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/l10n/l10n.dart';
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
    final isValid = item is SSchoolLifeItem;

    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          isValid ? item.headline : SLocalizations.of(context)!.invalidArticle,
        ),
        prefixActions: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
      ),
      content: isValid && item.article != null
          // Display the article elements and the image, if the item holds one.
          ? ListView(
              padding: SStyles.listViewPadding.copyWith(
                top: 8,
              ),
              children: [
                // If this is a post, display the image at the top.
                if (item is SPostSchoolLifeItem)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _buildImage(context, item.imageUrl),
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

                if (item.hyperlink != null)
                  Container(
                    padding: const EdgeInsets.only(
                      top: 24,
                    ),
                    alignment: Alignment.center,
                    child: IntrinsicWidth(
                      child: FButton(
                        prefix: FIcon(FAssets.icons.link),
                        label: Text(SLocalizations.of(context)!.externalContent),
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
                      ),
                    ),
                  ),
              ],
            )
          // If no article is embedded, display a placeholder.
          : SIconPlaceholder(
              iconSvg: FAssets.icons.ban,
              message: SLocalizations.of(context)!.invalidArticle,
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
    final borderRadius = FTheme.of(context).style.borderRadius;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: Stack(
              children: [
                FastCachedImage(
                  url: src,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                ),
                GlossyContainer(
                  height: double.infinity,
                  width: double.infinity,
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white38,
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius + BorderRadius.circular(3),
                    ),
                    child: FastCachedImage(
                      url: src,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ],
            ),
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
