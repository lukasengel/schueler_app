import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_item.freezed.dart';
part 'teacher_item.g.dart';

/// Type to represent a teacher of the school.
@freezed
class STeacherItem with _$STeacherItem {
  /// Create a new [STeacherItem].
  const factory STeacherItem({
    /// The database identifier.
    required String id,

    /// The abbreviation of the teacher's name.
    required String abbreviation,

    /// The name of the teacher.
    required String name,
  }) = _STeacherItem;

  /// Create a new [STeacherItem] from a JSON object.
  factory STeacherItem.fromJson(Map<String, dynamic> json) => _$STeacherItemFromJson(json);
}
