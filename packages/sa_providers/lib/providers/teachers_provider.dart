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

  /// Add a teacher.
  Future<Either<SDataException, Unit>> add(STeacherItem newTeacher) async {
    // Save teacher item to database.
    final result = await SPersistenceRepository.instance.saveTeacher(newTeacher);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Add teacher to the state and sort alphabetically.
        final newState = [if (state != null) ...state!, newTeacher]
          ..sort((a, b) => a.abbreviation.compareTo(b.abbreviation));

        state = newState;
        return right(unit);
      },
    );
  }

  /// Update a teacher.
  Future<Either<SDataException, Unit>> update(STeacherItem updatedTeacher) async {
    // Update teacher item in database.
    final result = await SPersistenceRepository.instance.saveTeacher(updatedTeacher);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Update teacher in the state and sort alphabetically.
        final newState = [if (state != null) ...state!]
          ..removeWhere((e) => e.id == updatedTeacher.id)
          ..add(updatedTeacher)
          ..sort((a, b) => a.abbreviation.compareTo(b.abbreviation));

        state = newState;
        return right(unit);
      },
    );
  }

  /// Delete a teacher.
  Future<Either<SDataException, Unit>> delete(STeacherItem teacher) async {
    // Delete teacher item from database.
    final result = await SPersistenceRepository.instance.deleteTeacher(teacher);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Remove teacher from the state.
        final newState = [if (state != null) ...state!]..remove(teacher);

        state = newState;
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
