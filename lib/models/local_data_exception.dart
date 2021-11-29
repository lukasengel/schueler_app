class LocalDataException implements Exception {
  final String error;
  final String details;

  @override
  String toString() {
    return "$error: $details";
  }

  LocalDataException(this.error, this.details);
  LocalDataException.languageParseError(this.details)
      : error = "Error parsing language data from storage";
  LocalDataException.settingsParseError(this.details)
      : error = "Error parsing Shared Preferences.";
}
