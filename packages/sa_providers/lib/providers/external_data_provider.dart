import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';

/// Notifier for external data.
class SExternalDataNotifier extends StateNotifier<SExternalDataSnapshot?> {
  /// Create a new [SExternalDataNotifier] with the given initial state.
  SExternalDataNotifier(super.state);

  /// Load external data.
  Future<Either<SDataException, Unit>> load() async {
    // Load external data from database.
    final result = await SPersistenceRepository.instance.loadExternalData();

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Only update the state if the external data was loaded successfully.
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

/// Provider for external data.
final sExternalDataProvider = StateNotifierProvider<SExternalDataNotifier, SExternalDataSnapshot?>(
  (ref) => SExternalDataNotifier(null),
);
