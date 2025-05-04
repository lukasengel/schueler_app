import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_data_snapshot.freezed.dart';
part 'external_data_snapshot.g.dart';

/// Represents a snapshot of external data.
///
/// This data is fetched from the school's substition plan website.
@freezed
class SExternalDataSnapshot with _$SExternalDataSnapshot {
  /// Create a new [SExternalDataSnapshot].
  const factory SExternalDataSnapshot({
    /// All available substitution tables. Typically the tables for the next five school days.
    required List<SSubstitutionTable> substitutionTables,

    /// All available news from the principal's office.
    required List<SNewsItem> newsItems,

    /// The content of the news ticker at the bottom of the website.
    required List<String> tickerItems,

    /// The date when the data on the website was last updated.
    required DateTime latestUpdate,

    /// The date when this snapshot was fetched.
    required DateTime latestFetch,
  }) = _SExternalDataSnapshot;

  /// Create a new [SExternalDataSnapshot] from a JSON object.
  factory SExternalDataSnapshot.fromJson(Map<String, dynamic> json) => _$SExternalDataSnapshotFromJson(json);
}

/// Represents the substitution table for a specific day.
@freezed
class SSubstitutionTable with _$SSubstitutionTable {
  /// Create a new [SSubstitutionTable].
  const factory SSubstitutionTable({
    /// The date of the substitution table.
    required DateTime date,

    /// The individual substitution rows, i.e. the lessons that are being substituted or changed on that day.
    required List<SSubstitutionTableRow> rows,
  }) = _SSubstitutionTable;

  /// Create a new [SSubstitutionTable] from a JSON object.
  factory SSubstitutionTable.fromJson(Map<String, dynamic> json) => _$SSubstitutionTableFromJson(json);
}

/// Represents a single row within a substitution table, which typically consists of six fields.
///
/// The field names have been translated from German to English, since the website is in German.
///
/// The `group` attribute is not directly displayed in the table, but instead used by the frontend to group multiple rows.
/// On the website, in case multiple rows belong to the same course, the course name is only written in the first row.
/// Therefore, the group attribute is determined programmatically.
/// For example:
///
/// ```txt
/// Kl. | Std. | Abw. | Ver. | Raum | Info  => Group
/// 5a  | 1    | mma  | jdo  | 101  | -     => 5a
///     | 2    | mma  | jdo  | 101  | -     => 5a
/// 6a  | 2    | abc  | def  | 201  | -     => 6a
///     | 3    | abc  | xyz  | 201  | -     => 6a
///     | 4    | mma  | jdo  | 201  | -     => 6a
/// ```
@freezed
class SSubstitutionTableRow with _$SSubstitutionTableRow {
  /// Create a new [SSubstitutionTableRow].
  const factory SSubstitutionTableRow({
    /// The course or class for which the substitution lesson is scheduled. [German: Klasse]
    required String course,

    /// The period during which the substitution lesson takes place. [German: Stunde]
    required String period,

    /// The absent teacher. [German: Abwesend]
    required String absent,

    /// The substitute teacher. [German: Vertretung]
    required String substitute,

    /// The room where the substituted lesson takes place. [German: Raum]
    required String room,

    /// Additional information or remarks. [German: Info]
    required String info,

    /// The group this row belongs to. Used for frontend grouping logic.
    required String group,
  }) = _SSubstitutionTableRow;

  /// Create a new [SSubstitutionTableRow] from a JSON object.
  factory SSubstitutionTableRow.fromJson(Map<String, dynamic> json) => _$SSubstitutionTableRowFromJson(json);
}

/// Represents an item on the principal's office news board.
@freezed
class SNewsItem with _$SNewsItem {
  /// Create a new [SNewsItem].
  const factory SNewsItem({
    ///The headline of the item.
    required String? headline,

    /// The subheadline of the item.
    required String? subheadline,

    /// The body text of the item.
    required String? content,
  }) = _SNewsItem;

  /// Create a new [SNewsItem] from a JSON object.
  factory SNewsItem.fromJson(Map<String, dynamic> json) => _$SNewsItemFromJson(json);
}
