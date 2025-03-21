/// An enumeration of possible types of exceptions thrown by the data layer.
///
/// Can be used for localizing error messages or for determining the error handling strategy.
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

  /// Determines the [SDataExceptionType] of error basd on its [Exception] object.
  ///
  /// If the exception provides useful details, the method will determine the exception type.
  static SDataExceptionType fromException(Exception e) {
    // TODO: Implement after all firebase functionality is implemented.
    return SDataExceptionType.OTHER;
  }
}

/// A custom [Exception] class thrown by the data layer.
class SDataException implements Exception {
  /// The type of the exception.
  final SDataExceptionType type;

  /// A human-readable error message.
  final String message;

  /// Additional details about the exception.
  /// This might be another [Exception] object or any other data type.
  final Object? details;

  /// Create a new [SDataException].
  SDataException({
    required this.type,
    required this.message,
    this.details,
  });
}
