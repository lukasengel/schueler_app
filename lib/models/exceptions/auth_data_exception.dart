class AuthDataException implements Exception {
  final String error;
  final String details;

  @override
  String toString() => "$error: $details";

  AuthDataException(this.error, this.details);

  AuthDataException.emptyCredentials()
      : error = "ERROR",
        details = "Empty Credentials";
}
