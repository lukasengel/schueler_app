import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';

/// Notifier for school life items.
class SSchoolLifeNotifier extends StateNotifier<List<SSchoolLifeItem>?> {
  /// Create a new [SSchoolLifeNotifier] with the given initial state.
  SSchoolLifeNotifier(super.state);

  /// Load school life items.
  Future<Either<SDataException, Unit>> load() async {
    // Load school life items from database.
    final result = await SPersistenceRepository.instance.loadSchoolLifeItems();

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Sort by datetime in descending order.
        final sorted = r.sorted((a, b) => b.datetime.compareTo(a.datetime));

        // Only update the state if the school life items were loaded successfully.
        state = sorted;
        return right(unit);
      },
    );
  }

  /// Add a school life item.
  Future<Either<SDataException, Unit>> add(SSchoolLifeItem newItem) async {
    // Save school life item to database.
    final result = await SPersistenceRepository.instance.saveSchoolLifeItem(newItem);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Add item to the state and sort by datetime in descending order.
        final newState = [if (state != null) ...state!, newItem]..sort((a, b) => b.datetime.compareTo(a.datetime));

        state = newState;
        return right(unit);
      },
    );
  }

  /// Update a school life item.
  Future<Either<SDataException, Unit>> update(SSchoolLifeItem updatedItem) async {
    // Update school life item in database.
    final result = await SPersistenceRepository.instance.saveSchoolLifeItem(updatedItem);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Update item in the state and sort by datetime in descending order.
        final newState = [if (state != null) ...state!]
          ..removeWhere((e) => e.id == updatedItem.id)
          ..add(updatedItem)
          ..sort((a, b) => b.datetime.compareTo(a.datetime));

        state = newState;
        return right(unit);
      },
    );
  }

  /// Delete a school life item.
  Future<Either<SDataException, Unit>> delete(SSchoolLifeItem item) async {
    // Delete school life item from database.
    final result = await SPersistenceRepository.instance.deleteSchoolLifeItem(item);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Remove school life item from the state.
        final newState = [if (state != null) ...state!]..remove(item);

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

/// Provider for school life items.
final sSchoolLifeProvider = StateNotifierProvider<SSchoolLifeNotifier, List<SSchoolLifeItem>?>(
  (ref) => SSchoolLifeNotifier(null),
);
