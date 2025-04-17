import 'package:dartz/dartz.dart';
import 'package:sa_data/sa_data.dart';

/// Interface definition for a local settings repository.
///
/// A local settings repository is responsible for loading and storing the settings of the current user.
///
/// This class in meant to be extended by platform-specific or use-case-specific implementations.
abstract class SLocalSettingsRepository {
  /// The instance of [SLocalSettingsRepository] to be used throughout the app.
  static SLocalSettingsRepository get instance {
    return SSharedPrefsLocalSettingsRepository.instance;
  }

  /// Load local settings from storage.
  ///
  /// Returns `null` if no record is found.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, SLocalSettings?>> loadLocalSettings();

  /// Save local settings to storage.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> saveLocalSettings(SLocalSettings localSettings);
}
