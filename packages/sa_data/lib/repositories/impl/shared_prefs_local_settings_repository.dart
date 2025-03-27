import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sa_data/sa_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SLocalSettingsRepository] using Shared Preferences.
class SSharedPrefsLocalSettingsRepository implements SLocalSettingsRepository {
  // Make the class non-instantiable.
  SSharedPrefsLocalSettingsRepository._();

  /// The instance to be used throughout the app.
  static final instance = SSharedPrefsLocalSettingsRepository._();

  @override
  Future<Either<SDataException, SLocalSettings?>> loadLocalSettings() async {
    try {
      // Load settings from disk.
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('localSettings');

      // If a record is found, decode it and return the settings.
      if (json != null) {
        final settings = SLocalSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
        return right(settings);
      }

      // If no record is found, return `null`.
      return right(null);
    } catch (e) {
      return left(
        SDataException(
          type: SDataExceptionType.LOCAL_STORAGE_FAILURE,
          description: 'Failed to load local settings from shared preferences.',
          details: e,
        ),
      );
    }
  }

  @override
  Future<Either<SDataException, Unit>> saveLocalSettings(SLocalSettings localSettings) async {
    try {
      // Save settings to disk.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'localSettings',
        jsonEncode(localSettings.toJson()),
      );

      return right(unit);
    } catch (e) {
      return left(
        SDataException(
          type: SDataExceptionType.LOCAL_STORAGE_FAILURE,
          description: 'Failed to save local settings to shared preferences.',
          details: e,
        ),
      );
    }
  }
}
