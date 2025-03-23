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
    Locale? locale,
    ThemeMode? themeMode,
    int? shownDays,
    bool? autoNextDay,
    bool? developerMode,
  }) async {
    // Create a instance with the updated values.
    final newState = state.copyWith(
      locale: locale ?? state.locale,
      themeMode: themeMode ?? state.themeMode,
      shownDays: shownDays ?? state.shownDays,
      autoNextDay: autoNextDay ?? state.autoNextDay,
      developerMode: developerMode ?? state.developerMode,
    );

    // Write changes to storage.
    final result = await SLocalSettingsRepository.instance.saveLocalSettings(
      newState,
    );

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Only update the state if the settings were saved successfully.
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
