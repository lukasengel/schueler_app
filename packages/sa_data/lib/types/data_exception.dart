import 'dart:convert';

/// An enumeration of possible types of exceptions thrown by the data layer.
///
/// Used to determine the error message shown to the user.
enum SDataExceptionType {
  /// No internet connection.
  NO_CONNECTION,

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

    // If the caught object is of a different type, we cannot determine the error type.
    return SDataException(
      type: SDataExceptionType.OTHER,
      description: description,
      details: caughtObject,
    );
  }

  @override
  String toString() {
    return jsonEncode({
      'type': type.name,
      'description': description,
      if (details != null) 'details': details.toString(),
    });
  }
}

/// An exception that is thrown inside of the data layer to simplify error handling, but should reach the user.
///
/// Can be used in combination with [SDataException.fromCaughtObject] to determine the exception type and details.
enum SInternalDataException implements Exception {
  /// The requested resource was not found.
  NOT_FOUND,
}
