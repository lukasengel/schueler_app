import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

/// Notifier for loading data.
///
/// Serves as a central point to load and clear data for the entire application.
class SLoadingNotifier extends StateNotifier<bool> {
  // Reference to access other providers.
  final Ref _ref;

  /// Create a new [SLoadingNotifier] with the given initial state.
  SLoadingNotifier(this._ref, super.state);

  /// Load all data required by the home view.
  Future<Either<List<SDataException>, Unit>> loadHome() async {
    final futures = [
      _ref.read(sGlobalSettingsProvider.notifier).load(),
      _ref.read(sExternalDataProvider.notifier).load(),
      _ref.read(sSchoolLifeProvider.notifier).load(),
      _ref.read(sTeachersProvider.notifier).load(),
    ];

    // Wait for all futures to complete.
    final results = await Future.wait(futures);

    // Check if any exceptions occurred.
    final exceptions = results.where((e) => e.isLeft()).map((e) => e.forceLeft()).toList();

    // If, let's suppose, there is no internet connection, we don't want to show five toasts all saying the same thing.
    // Therefore, group all exception by their type and combine their descriptions and details.
    final groupedExceptions = exceptions.groupListsBy((exception) => exception.type).entries.map((entry) {
      final descriptions = entry.value.map((e) => e.description);
      final details = entry.value.map((e) => e.details).nonNulls;

      return SDataException(
        type: entry.key,
        description: descriptions.map((e) => '\n- $e').join(),
        details: details.map((e) => '\n- $e').join(),
      );
    }).toList();

    // Return the exceptions, if any.
    return groupedExceptions.isNotEmpty ? left(groupedExceptions) : right(unit);
  }

  /// Load all data required by the management view.
  Future<Either<List<SDataException>, Unit>> loadManagement() async {
    final futures = [
      _ref.read(sGlobalSettingsProvider.notifier).load(),
      _ref.read(sSchoolLifeProvider.notifier).load(),
      _ref.read(sTeachersProvider.notifier).load(),
      _ref.read(sFeedbackProvider.notifier).load(),
    ];

    // Wait for all futures to complete.
    final results = await Future.wait(futures);

    // Check if any exceptions occurred.
    final exceptions = results.where((e) => e.isLeft()).map((e) => e.forceLeft()).toList();

    // If, let's suppose, there is no internet connection, we don't want to show five toasts all saying the same thing.
    // Therefore, group all exception by their type and combine their descriptions and details.
    final groupedExceptions = exceptions.groupListsBy((exception) => exception.type).entries.map((entry) {
      final descriptions = entry.value.map((e) => e.description);
      final details = entry.value.map((e) => e.details).nonNulls;

      return SDataException(
        type: entry.key,
        description: descriptions.map((e) => '\n- $e').join(),
        details: details.map((e) => '\n- $e').join(),
      );
    }).toList();

    // Return the exceptions, if any.
    return groupedExceptions.isNotEmpty ? left(groupedExceptions) : right(unit);
  }

  /// Clear the entire application state and reset the local settings.
  Future<Either<SDataException, Unit>> clear() async {
    _ref.read(sExternalDataProvider.notifier).clear();
    _ref.read(sFeedbackProvider.notifier).clear();
    _ref.read(sGlobalSettingsProvider.notifier).clear();
    _ref.read(sTeachersProvider.notifier).clear();
    _ref.read(sSchoolLifeProvider.notifier).clear();
    return _ref.read(sLocalSettingsProvider.notifier).reset();
  }
}

/// Provider for loading data.
final sLoadingProvider = StateNotifierProvider<SLoadingNotifier, bool>(
  (ref) => SLoadingNotifier(ref, false),
);
