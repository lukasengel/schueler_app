import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';

/// Notifier for local settings.
class SLocalSettingsNotifier extends StateNotifier<SLocalSettings> {
  /// Create a new [SLocalSettingsNotifier] with the given initial state.
  SLocalSettingsNotifier(super.state);

  /// Update local settings with the given values.
  Future<Either<SDataException, Unit>> updateWith({
    String? username,
    String? password,
    Locale? locale,
    ThemeMode? themeMode,
    int? shownDays,
    bool? autoNextDay,
    bool? developerMode,
    Set<String>? excludedCourses,
    Set<String>? customExclusions,
  }) {
    return _update(
      state.copyWith(
        username: username ?? state.username,
        password: password ?? state.password,
        locale: locale ?? state.locale,
        themeMode: themeMode ?? state.themeMode,
        shownDays: shownDays ?? state.shownDays,
        autoNextDay: autoNextDay ?? state.autoNextDay,
        developerMode: developerMode ?? state.developerMode,
        excludedCourses: excludedCourses ?? state.excludedCourses,
        customExclusions: customExclusions ?? state.customExclusions,
      ),
    );
  }

  /// Reset local settings, i.e. restore the defaults.
  ///
  /// This method is used when the user logs out.
  Future<Either<SDataException, Unit>> reset() async {
    return _update(SLocalSettings.defaults());
  }

  /// Helper method to save the local settings and update the state, if successful.
  Future<Either<SDataException, Unit>> _update(SLocalSettings newState) async {
    // Save the settings to storage.
    final result = await SLocalSettingsRepository.instance.saveLocalSettings(
      newState,
    );

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Only update the state if the local settings were saved successfully.
        state = newState;
        return right(unit);
      },
    );
  }
}

/// Provider for local settings.
final sLocalSettingsProvider = StateNotifierProvider<SLocalSettingsNotifier, SLocalSettings>(
  // Initialize with default values, so the app remains functional even if settings cannot be loaded.
  (ref) => SLocalSettingsNotifier(SLocalSettings.defaults()),
);
