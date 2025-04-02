import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';

/// Notifier for loading data.
///
/// Serves as a central point to load and clear the entire application state.
class SLoadingNotifier extends StateNotifier<bool> {
  // Reference to access other providers.
  final Ref _ref;

  /// Create a new [SLoadingNotifier] with the given initial state.
  SLoadingNotifier(this._ref, super.state);

  /// Load all data required by the home view.
  Future<Either<List<SDataException>, Unit>> load() async {
    final futures = [
      _ref.read(sGlobalSettingsProvider.notifier).load(),
      _ref.read(sTeachersProvider.notifier).load(),
    ];

    // Wait for all futures to complete.
    final results = await Future.wait(futures);

    // Check if any exceptions occurred.
    final exceptions = results.where((e) => e.isLeft()).map((e) => e.forceLeft()).toList();

    // Return the exceptions, if any.
    return exceptions.isNotEmpty ? left(exceptions) : right(unit);
  }

  /// Clear the entire application state and reset the local settings.
  Future<Either<SDataException, Unit>> clear() async {
    _ref.read(sFeedbackProvider.notifier).clear();
    _ref.read(sGlobalSettingsProvider.notifier).clear();
    _ref.read(sTeachersProvider.notifier).clear();
    return _ref.read(sLocalSettingsProvider.notifier).reset();
  }
}

/// Provider for loading data.
final sLoadingProvider = StateNotifierProvider<SLoadingNotifier, bool>(
  (ref) => SLoadingNotifier(ref, false),
);
