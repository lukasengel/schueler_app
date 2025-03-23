import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_settings.freezed.dart';
part 'local_settings.g.dart';

/// The application settings, stored locally on the user's device.
@freezed
class SLocalSettings with _$SLocalSettings {
  /// Create a new [SLocalSettings].
  const factory SLocalSettings({
    /// The user's username.
    required String username,

    /// The user's password.
    required String password,

    /// The user's preferred locale.
    @SLocaleConverter() required Locale locale,

    /// The user's preferred theme mode.
    required ThemeMode themeMode,

    /// The number of days shown on the substitution plan.
    required int shownDays,

    /// Whether the substitution plan should automatically switch to the next day after 5 PM.
    required bool autoNextDay,

    /// Whether the developer mode is enabled.
    required bool developerMode,

    /// The courses that should be excluded from the substitution plan.
    required Set<String> excludedCourses,

    /// The courses that the user has manually excluded from the substitution plan.
    required Set<String> customExclusions,
  }) = _SLocalSettings;

  /// Create a new [SLocalSettings] from a JSON object.
  factory SLocalSettings.fromJson(Map<String, dynamic> json) => _$SLocalSettingsFromJson(json);

  /// Create a new [SLocalSettings] with default values.
  factory SLocalSettings.defaults() {
    return const SLocalSettings(
      username: '',
      password: '',
      locale: Locale('en'),
      themeMode: ThemeMode.system,
      shownDays: 5,
      autoNextDay: true,
      developerMode: false,
      excludedCourses: {},
      customExclusions: {},
    );
  }
}

/// JSON converter for [Locale] objects.
class SLocaleConverter implements JsonConverter<Locale, String> {
  /// Create a new [SLocaleConverter].
  const SLocaleConverter();

  @override
  Locale fromJson(String json) {
    final parts = json.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  @override
  String toJson(Locale object) => object.toString();
}
