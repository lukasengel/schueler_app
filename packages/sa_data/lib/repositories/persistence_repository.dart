import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sa_data/sa_data.dart';

/// Interface definition for a persistence repository.
///
/// A persistence repository is responsible for loading and storing data to and from a persistent database.
///
/// This class in meant to be extended by platform-specific or use-case-specific implementations.
abstract class SPersistenceRepository {
  /// The instance of [SPersistenceRepository] to be used throughout the app.
  static SPersistenceRepository get instance {
    return SFirebasePersistenceRepository.instance;
  }

  /// Load all school life items from the database.
  ///
  /// If an error occurs while retrieving data, an [SDataException] is returned.
  Future<Either<SDataException, List<SSchoolLifeItem>>> loadSchoolLifeItems();

  /// Save a school life item to the database.
  ///
  /// If a school life item with the same ID already exists, it will be updated.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> saveSchoolLifeItem(SSchoolLifeItem item);

  /// Delete a school life item from the database.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> deleteSchoolLifeItem(SSchoolLifeItem item);

  /// Load all teachers from the database.
  ///
  /// If an error occurs while retrieving data, an [SDataException] is returned.
  Future<Either<SDataException, List<STeacherItem>>> loadTeachers();

  /// Save a teacher to the database.
  ///
  /// If a teacher item with the same ID already exists, it will be updated.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> saveTeacher(STeacherItem teacher);

  /// Delete a teacher from the database.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> deleteTeacher(STeacherItem teacher);

  /// Load all feedback items from the database.
  ///
  /// If an error occurs while retrieving data, an [SDataException] is returned.
  Future<Either<SDataException, List<SFeedbackItem>>> loadFeedback();

  /// Save a feedback item to the database.
  ///
  /// If a feedback item with the same ID already exists, it will be updated.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> saveFeedback(SFeedbackItem feedback);

  /// Delete a feedback item from the database.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> deleteFeedback(SFeedbackItem feedback);

  /// Load global settings from the database.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, SGlobalSettings>> loadGlobalSettings();

  /// Save global settings to the database.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, Unit>> saveGlobalSettings(SGlobalSettings settings);

  /// Upload an image and return the URL to access it.
  ///
  /// [filename] is the name of the file.
  /// [dir] is the directory in which the file should be stored.
  /// [bytes] is the image data.
  ///
  /// Returns an [SDataException] upon failure.
  Future<Either<SDataException, String>> uploadImage(String filename, String dir, Uint8List bytes);
}
