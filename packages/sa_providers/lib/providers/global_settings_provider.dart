import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';

/// Notifier for global settings.
class SGlobalSettingsNotifier extends StateNotifier<SGlobalSettings?> {
  /// Create a new [SGlobalSettingsNotifier] with the given initial state.
  SGlobalSettingsNotifier(super.state);

  /// Load global settings.
  Future<Either<SDataException, Unit>> load() async {
    // Load global settings from database.
    final result = await SPersistenceRepository.instance.loadGlobalSettings();

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Only update the state if the global settings were loaded successfully.
        state = r;
        return right(unit);
      },
    );
  }

  /// Clear state.
  ///
  /// This method is used when the user logs out.
  void clear() {
    state = null;
  }
}

/// Provider for global settings.
final sGlobalSettingsProvider = StateNotifierProvider<SGlobalSettingsNotifier, SGlobalSettings?>(
  (ref) => SGlobalSettingsNotifier(null),
);
