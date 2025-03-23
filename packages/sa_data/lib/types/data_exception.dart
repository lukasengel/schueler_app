import 'dart:convert';

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

  @override
  String toString() {
    return jsonEncode({
      'type': type.name,
      'description': description,
      'details': details,
    });
  }
}

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
  OTHER;

  /// Determines the [SDataExceptionType] of error basd on an [Exception] object.
  ///
  /// If the exception provides useful details, the method will determine the exception type.
  static SDataExceptionType fromException(Exception e) {
    // TODO: Implement after all firebase functionality is implemented.
    return SDataExceptionType.OTHER;
  }
}
