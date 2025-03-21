import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_item.freezed.dart';
part 'feedback_item.g.dart';

/// A feedback or bug report filed by a user.
///
/// All nullable fields are optional.
@freezed
class SFeedbackItem with _$SFeedbackItem {
  /// Create a new [SFeedbackItem].
  const factory SFeedbackItem({
    /// The database identifier.
    required String id,

    /// The name of the person who provided the feedback.
    required String? name,

    /// The email address of the person who provided the feedback.
    required String? email,

    /// The content of the feedback or bug report.
    required String message,

    /// The date and time when the feedback was submitted.
    required DateTime datetime,
  }) = _SFeedbackItem;

  /// Create a new [SFeedbackItem] from a JSON object.
  factory SFeedbackItem.fromJson(Map<String, dynamic> json) => _$SFeedbackItemFromJson(json);
}
