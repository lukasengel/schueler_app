import 'package:firebase_auth/firebase_auth.dart';

/// An enumeration of possible types of exceptions thrown by the data layer.
///
/// Used to determine the error message shown to the user.
enum SDataExceptionType {
  /// No internet connection.
  NO_CONNECTION,

  /// Could not authenticate the user due to invalid credentials.
  INVALID_CREDENTIALS,

  /// The server rejected the authentication request because too many requests were made in a short period of time.
  TOO_MANY_REQUESTS,

  /// The requested resource was not found.
  NOT_FOUND,

  /// The user is not authorized to access the requested resource.
  UNAUTHORIZED,

  /// Failed to parse the response from the server.
  PARSING_FAILED,

  /// Failed to read or write data from or to local storage.
  LOCAL_STORAGE_FAILURE,

  /// Any other type of error.
  OTHER,
}

/// A custom [Exception] class thrown by the data layer.
class SDataException implements Exception {
  /// The type of the exception.
  ///
  /// Used to determine the error message shown to the user.
  final SDataExceptionType type;

  /// A human-readable error description.
  ///
  /// Should contain technical information and will not be directly shown to the user.
  final String description;

  /// Additional details about the exception.
  ///
  /// This might be another [Exception] object or any other data type.
  final Object? details;

  /// Create a new [SDataException].
  SDataException({
    required this.type,
    required this.description,
    this.details,
  });

  /// Create a new [SDataException] from a caught [Object].
  factory SDataException.fromCaughtObject({required Object caughtObject, required String description}) {
    // If the caught object is an internal exception, determine the error type.
    if (caughtObject is SInternalDataException) {
      return switch (caughtObject) {
        SInternalDataException.NOT_FOUND => SDataException(
            type: SDataExceptionType.NOT_FOUND,
            description: description,
          ),
      };
    }

    // If the caught object is a FirebaseException, map the error code to an SDataExceptionType.
    if (caughtObject is FirebaseException) {
      final type = switch (caughtObject.code) {
        'invalid-email' ||
        'user-disabled' ||
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' ||
        'INVALID_LOGIN_CREDENTIALS' =>
          SDataExceptionType.INVALID_CREDENTIALS,
        'too-many-requests' => SDataExceptionType.TOO_MANY_REQUESTS,
        'network-request-failed' => SDataExceptionType.NO_CONNECTION,
        'not-found' => SDataExceptionType.NOT_FOUND,
        'permission-denied' => SDataExceptionType.UNAUTHORIZED,
        'unavailable' => SDataExceptionType.NO_CONNECTION,
        String() => SDataExceptionType.OTHER,
      };

      return SDataException(
        type: type,
        description: description,
        details: caughtObject,
      );
    }

    // If the caught object is of a different type, we cannot determine the error type.
    return SDataException(
      type: SDataExceptionType.OTHER,
      description: description,
      details: caughtObject,
    );
  }

  @override
  String toString() {
    return '[SDataException]\nType: ${type.name}\nDescription: $description\nDetails: $details';
  }
}

/// An exception that is thrown inside of the data layer to simplify error handling, but should reach the user.
///
/// Can be used in combination with [SDataException.fromCaughtObject] to determine the exception type and details.
enum SInternalDataException implements Exception {
  /// The requested resource was not found.
  NOT_FOUND,
}
