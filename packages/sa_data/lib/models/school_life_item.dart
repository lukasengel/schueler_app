import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xml/xml.dart';

part 'school_life_item.freezed.dart';
part 'school_life_item.g.dart';

/// An item on the school life page. This can be an announcement, an event or a post.
///
/// All nullable fields are optional.
@freezed
class SSchoolLifeItem with _$SSchoolLifeItem {
  /// Create a new [SSchoolLifeItem] that represents an announcement.
  const factory SSchoolLifeItem.announcement({
    /// The database identifier.
    required String id,

    /// The date and time when the item was created.
    required DateTime datetime,

    /// The headline of the announcement.
    required String headline,

    /// The content text of the announcement.
    required String content,

    /// Provide a hyperlink for students to visit.
    required String? hyperlink,

    /// Article to be opened when the item is clicked.
    @SXmlDocumentConverter() required XmlDocument? article,
  }) = SAnnouncementSchoolLifeItem;

  /// Create a new [SSchoolLifeItem] that represents an event.
  const factory SSchoolLifeItem.event({
    /// The database identifier.
    required String id,

    /// The date and time when the item was created.
    required DateTime datetime,

    /// The headline of the event.
    required String headline,

    /// The content text of the event.
    required String content,

    /// The date when the event will take place.
    required DateTime eventDate,

    /// Provide a hyperlink for students to visit.
    required String? hyperlink,

    /// Article to be opened when the item is clicked.
    @SXmlDocumentConverter() required XmlDocument? article,
  }) = SEventSchoolLifeItem;

  /// Create a new [SSchoolLifeItem] that represents a post.
  const factory SSchoolLifeItem.post({
    /// The database identifier.
    required String id,

    /// The date and time when the item was created.
    required DateTime datetime,

    /// The headline of the article.
    required String headline,

    /// The content text of the article.
    required String content,

    /// The URL of the image to be displayed.
    required String imageUrl,

    /// Whether the headline should be displayed in dark mode on top of the image.
    required bool darkHeadline,

    /// Provide a hyperlink for students to visit.
    required String? hyperlink,

    /// Article to be opened when the item is clicked.
    @SXmlDocumentConverter() required XmlDocument? article,
  }) = SPostSchoolLifeItem;

  /// Create a new [SSchoolLifeItem] from a JSON object.
  factory SSchoolLifeItem.fromJson(Map<String, dynamic> json) => _$SSchoolLifeItemFromJson(json);
}

/// JSON converter for [XmlDocument] objects.
class SXmlDocumentConverter implements JsonConverter<XmlDocument, String> {
  /// Create a new [SXmlDocumentConverter].
  const SXmlDocumentConverter();

  @override
  XmlDocument fromJson(String json) => XmlDocument.parse(json);

  @override
  String toJson(XmlDocument object) => object.toXmlString(pretty: true, indent: '\t');
}
