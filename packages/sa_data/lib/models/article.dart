import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xml/xml.dart';

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

/// JSON converter for [SArticle] objects, serialized as XML.
class SArticleConverter implements JsonConverter<SArticle, String> {
  /// Create a new [SArticleConverter].
  const SArticleConverter();

  @override
  SArticle fromJson(String json) {
    final rawArticle = XmlDocument.parse(json).getElement('article');

    if (rawArticle != null) {
      final author = rawArticle.getAttribute('author');
      final elements = rawArticle.childElements.map(_fromXml).toList();

      if (author != null) {
        return SArticle(
          author: author,
          elements: elements,
        );
      }

      throw Exception("Element <article> must have an 'author' attribute.");
    }

    throw Exception('Element <article> not found.');
  }

  @override
  String toJson(SArticle object) {
    final builder = XmlBuilder();

    builder
      ..processing('xml', 'version="1.0" encoding="UTF-8"')
      ..element(
        'article',
        attributes: {'author': object.author},
        nest: () {
          for (final element in object.elements) {
            builder.element(
              element.map(
                headline: (_) => 'headline',
                subheadline: (_) => 'subheadline',
                paragraph: (_) => 'paragraph',
                content: (_) => 'content',
                image: (_) => 'image',
              ),
              attributes: element.maybeMap(
                image: (imageElement) => {'src': imageElement.src},
                orElse: () => {},
              ),
              nest: () => element.map(
                headline: (headlineItem) => builder.text(headlineItem.text),
                subheadline: (subheadlineItem) => builder.text(subheadlineItem.text),
                paragraph: (paragraphItem) => builder.text(paragraphItem.text),
                content: (contentItem) => builder.xml(contentItem.text.xml),
                image: (imageItem) {
                  if (imageItem.caption != null) {
                    builder.element(
                      'caption',
                      nest: () => builder.text(imageItem.caption!),
                    );
                  }
                },
              ),
            );
          }
        },
      );

    return builder.buildDocument().toXmlString();
  }

  /// Convert an [XmlElement] to an [SArticleElement].
  static SArticleElement _fromXml(XmlElement element) {
    return switch (element.name.local) {
      'headline' => SArticleElement.headline(text: element.innerText),
      'subheadline' => SArticleElement.subheadline(text: element.innerText),
      'paragraph' => SArticleElement.paragraph(text: element.innerText),
      'content' => SArticleElement.content(text: element.innerXml.regular),
      'image' => () {
          final src = element.getAttribute('src');

          if (src != null) {
            return SArticleElement.image(
              src: src,
              caption: element.getElement('caption')?.innerText,
            );
          }

          throw Exception("Element <image> must have a 'src' attribute.");
        }(),
      _ => throw Exception('Element <${element.name.local}> is unknown.'),
    };
  }
}

/// Extension methods for converting strings to and from XML.
extension _SStringXmlExtension on String {
  /// Convert a normal string to an XML string.
  ///
  /// That means, replace raw line breaks with `<lb/>` tags.
  String get xml {
    return replaceAll('\n', '<lb/>').trim();
  }

  /// Convert an XML string to a normal string.
  ///
  /// That means, ignore all whitespace characters and replace `<lb/>` tags with raw line breaks.
  String get regular {
    return replaceAll(RegExp(r'\s+'), ' ').replaceAll('<lb/>', '\n').trim();
  }
}
