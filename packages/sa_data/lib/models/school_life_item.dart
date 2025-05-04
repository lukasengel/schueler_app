import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sa_data/converters/article_converter.dart';
import 'package:sa_data/sa_data.dart';

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
    @SArticleConverter() required SArticle? article,
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
    @SArticleConverter() required SArticle? article,
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
    @SArticleConverter() required SArticle? article,
  }) = SPostSchoolLifeItem;

  /// Create a new [SSchoolLifeItem] from a JSON object.
  factory SSchoolLifeItem.fromJson(Map<String, dynamic> json) => _$SSchoolLifeItemFromJson(json);
}
