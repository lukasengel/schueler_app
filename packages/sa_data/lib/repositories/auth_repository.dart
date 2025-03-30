import 'package:dartz/dartz.dart';
import 'package:sa_data/sa_data.dart';

/// Interface for an authentication repository.
///
/// An authentication repository is responsible for handling user sessions and authentication.
///
/// It should be able to persist a user's session across app restarts.
/// If a valid session is available, the stream [user] should emit the currently logged-in user upon startup, otherwise `null`.
///
/// This class in meant to be extended by platform-specific or use-case-specific implementations.
abstract class SAuthRepository {
  /// The instance of [SAuthRepository] to be used throughout the app.
  static SAuthRepository get instance {
    return SFirebaseAuthRepository.instance;
  }

  /// Stream with the currently logged-in user.
  ///
  /// If no user is logged in, the stream will emit `null`.
  Stream<SUser?> get user;

  /// Log in and start a user session.
  ///
  /// Expects password as plain text.
  ///
  /// Returns [SDataException] upon failure.
  Future<Either<SDataException, Unit>> login({required String username, required String password});

  /// Log out and clear the user session.
  ///
  /// Returns [SDataException] upon failure.
  Future<Either<SDataException, Unit>> logout();
}
