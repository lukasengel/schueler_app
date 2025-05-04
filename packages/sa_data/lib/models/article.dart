import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';

/// Represents an article embedded in a school life item.
@freezed
class SArticle with _$SArticle {
  /// Create a new [SArticle].
  const factory SArticle({
    /// The auhor of the article.
    required String author,

    /// The elements this article consists of.
    required List<SArticleElement> elements,
  }) = _SArticle;
}

/// Represents a single element in an article.
@freezed
class SArticleElement with _$SArticleElement {
  /// Create a new [SArticleElement] that represents a headline.
  const factory SArticleElement.headline({
    /// The headline text. Must not contain line breaks.
    required String text,
  }) = _SHeadlineArticleElement;

  /// Create a new [SArticleElement] that represents a subheadline.
  const factory SArticleElement.subheadline({
    /// The subheadline text. Must not contain line breaks.
    required String text,
  }) = _SSubheadlineArticleElement;

  /// Create a new [SArticleElement] that represents a paragraph.
  const factory SArticleElement.paragraph({
    /// The paragraph text. Must not contain line breaks.
    required String text,
  }) = _SParagraphArticleElement;

  /// Create a new [SArticleElement] that represents a content.
  const factory SArticleElement.content({
    /// The content text. May contain line breaks.
    required String text,
  }) = _SContentArticleElement;

  /// Create a new [SArticleElement] that represents an image.
  const factory SArticleElement.image({
    /// The image source URL.
    required String src,

    /// An optional caption for the image. Must not contain line breaks.
    required String? caption,
  }) = _SImageArticleElement;
}
