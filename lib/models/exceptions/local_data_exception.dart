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
  LocalDataException.operationsParseError(this.details)
      : error = "Error parsing operation queue.";

      LocalDataException.clearSettingsError(this.details)
      : error = "Error clearing user settings.";

  LocalDataException.settingsWriteError(this.details)
      : error = "Error writing settings to storage";
  LocalDataException.operationsWriteError(this.details)
      : error = "Error writing operation queue to storage";
}
