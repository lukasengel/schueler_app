import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';

/// Notifier for teachers.
class STeachersNotifier extends StateNotifier<List<STeacherItem>?> {
  /// Create a new [STeachersNotifier] with the given initial state.
  STeachersNotifier(super.state);

  /// Load teachers.
  Future<Either<SDataException, Unit>> load() async {
    // Load teachers from database.
    final result = await SPersistenceRepository.instance.loadTeachers();

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Sort alphabetically.
        final sorted = r.sorted((a, b) => a.abbreviation.compareTo(b.abbreviation));

        // Only update the state if the teachers were loaded successfully.
        state = sorted;
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

/// Provider for teachers.
final sTeachersProvider = StateNotifierProvider<STeachersNotifier, List<STeacherItem>?>(
  (ref) => STeachersNotifier(null),
);
