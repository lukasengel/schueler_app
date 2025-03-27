import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_settings.freezed.dart';
part 'global_settings.g.dart';

/// The global application settings, stored on the server and applicable to all users.
@freezed
class SGlobalSettings with _$SGlobalSettings {
  /// Create a new [SGlobalSettings].
  const factory SGlobalSettings({
    /// The database identifier.
    required String id,

    /// The URL of the project page on GitHub.
    required String githubUrl,

    /// The available exclusion options for filtering the substitution plan.
    required List<SExclusionOption> exclusionOptions,
  }) = _SGlobalSettings;

  /// Create a new [SGlobalSettings] from a JSON object.
  factory SGlobalSettings.fromJson(Map<String, dynamic> json) => _$SGlobalSettingsFromJson(json);
}

/// Represents an exclusion option for filtering the substitution plan.
///
/// The exclusion options are managed globally, while each user has a set of exclusion option IDs in their local settings.
@freezed
class SExclusionOption with _$SExclusionOption {
  /// Create a new [SExclusionOption].
  const factory SExclusionOption({
    /// The unique identifier of the exclusion option.
    ///
    /// If this ID is present in the user's exlusion list, all courses matching the [regex] will be excluded from the substitution plan.
    required String id,

    /// The human-readable name of the exclusion option.
    ///
    /// This name will be shown to the user in the settings screen and won't be localized, since all course names are in German.
    required String name,

    /// The regular expression to filter the substitution plan by matching the course name.
    ///
    /// The expression is applied to the course name to determine if the course should be hidden.
    required String regex,
  }) = _SExclusionOption;

  /// Create a new [SExclusionOption] from a JSON object.
  factory SExclusionOption.fromJson(Map<String, dynamic> json) => _$SExclusionOptionFromJson(json);
}
