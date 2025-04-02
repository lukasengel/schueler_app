import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';
import 'package:uuid/uuid.dart';

/// Notifier for feedback.
class SFeedbackNotifier extends StateNotifier<List<SFeedbackItem>?> {
  /// Create a new [SFeedbackNotifier] with the given initial state.
  SFeedbackNotifier(super.state);

  /// Submit feedback, that means create a new feedback item in the database.
  Future<Either<SDataException, Unit>> submitFeedback({
    required String message,
    String? name,
    String? email,
  }) {
    // Save feedback item to database.
    return SPersistenceRepository.instance.saveFeedback(
      SFeedbackItem(
        // Create a new uuid to create a new feedback item.
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
