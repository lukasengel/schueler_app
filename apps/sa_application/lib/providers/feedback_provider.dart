import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';
import 'package:uuid/uuid.dart';

/// Notifier for feedback.
class SFeedbackNotifier extends StateNotifier<List<SFeedbackItem>?> {
  /// Create a new [SFeedbackNotifier] with the given initial state.
  SFeedbackNotifier(super.state);

  /// Load feedback.
  Future<Either<SDataException, Unit>> load() async {
    // Load feedback from database.
    final result = await SPersistenceRepository.instance.loadFeedback();

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Sort by datetime in descending order.
        final sorted = r.sorted((a, b) => b.datetime.compareTo(a.datetime));

        // Only update the state if the feedback was loaded successfully.
        state = sorted;
        return right(unit);
      },
    );
  }

  /// Delete a feedback item.
  Future<Either<SDataException, Unit>> delete(SFeedbackItem feedbackItem) async {
    // Delete feedback item from database.
    final result = await SPersistenceRepository.instance.deleteFeedback(feedbackItem);

    // Check if the operation was successful.
    return result.fold(
      left,
      (r) {
        // Remove feedback item from the state.
        final newState = [if (state != null) ...state!]..remove(feedbackItem);

        state = newState;
        return right(unit);
      },
    );
  }

  /// Submit feedback, that means create a new feedback item in the database.
  Future<Either<SDataException, Unit>> submit({
    required String message,
    String? name,
    String? email,
  }) {
    // Save feedback item to database.
    return SPersistenceRepository.instance.saveFeedback(
      SFeedbackItem(
        // Generate a new uuid to create a new feedback item.
        id: const Uuid().v4(),
        name: name,
        email: email,
        message: message,
        // Provide a timestamp.
        datetime: DateTime.now(),
      ),
    );
  }

  /// Clear state.
  ///
  /// This method is used when the user logs out.
  void clear() {
    state = null;
  }
}

/// Provider for feedback.
final sFeedbackProvider = StateNotifierProvider<SFeedbackNotifier, List<SFeedbackItem>?>(
  (ref) => SFeedbackNotifier(null),
);
