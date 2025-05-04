import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sa_data/sa_data.dart';
import 'package:xml/xml.dart';

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
