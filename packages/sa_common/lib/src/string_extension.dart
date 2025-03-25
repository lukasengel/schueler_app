/// Extension for the built-in [String] class.
extension SStringExtension on String {
  /// Whether this string is blank.
  ///
  /// A string is considered blank if it is empty or contains only whitespace characters.
  bool get isBlank => trim().isEmpty;

  /// Whether this string is not blank.
  ///
  /// A string is considered not blank if it is not empty and contains at least one non-whitespace character.
  bool get isNotBlank => !isBlank;

  /// Whether this string contains the other string, ignoring the case.
  bool containsIgnoreCase(String other) => toLowerCase().contains(other.toLowerCase());

  /// Capitalize this string by converting the first character to uppercase.
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  /// Trim this string or return `null` if it is blank.
  String? trimOrNull() => isNotBlank ? trim() : null;
}

/// Extension for the built-in [String?] class.
extension SNullableStringExtension on String? {
  /// Whether the string has content.
  ///
  /// A string is considered to have content if it is not `null` and not blank.
  bool get hasContent => this != null && this!.isNotBlank;

  /// Whether the string has no content.
  ///
  /// A string is considered to have no content if it is `null` or blank.
  bool get hasNoContent => !hasContent;
}
