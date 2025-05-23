import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sa_data/sa_data.dart';
import 'package:uuid/uuid.dart';

/// An implementation of [SPersistenceRepository] using Firebase Realtime Database.
class SFirebasePersistenceRepository extends SPersistenceRepository {
  // Make the class non-instantiable.
  SFirebasePersistenceRepository._();

  /// The instance to be used throughout the app.
  static final instance = SFirebasePersistenceRepository._();

  // A custom Firestore instance.
  FirebaseFirestore? _firestore;

  /// The firestore instance to be used. If no custom instance is set, the default instance will be used.
  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  /// Set a custom firestore instance to be used.
  set firestore(FirebaseFirestore firestore) {
    _firestore = firestore;
  }

  @override
  Future<Either<SDataException, SExternalDataSnapshot>> loadExternalData() {
    return _loadItem('external', 'latest', SExternalDataSnapshot.fromJson);
  }

  @override
  Future<Either<SDataException, List<SSchoolLifeItem>>> loadSchoolLifeItems() {
    return _loadItems('schoolLife', SSchoolLifeItem.fromJson);
  }

  @override
  Future<Either<SDataException, Unit>> saveSchoolLifeItem(SSchoolLifeItem item) {
    return _saveItem('schoolLife', item.toJson());
  }

  @override
  Future<Either<SDataException, Unit>> deleteSchoolLifeItem(SSchoolLifeItem item) {
    return _deleteItem('schoolLife', item.id);
  }

  @override
  Future<Either<SDataException, List<STeacherItem>>> loadTeachers() {
    return _loadItems('teachers', STeacherItem.fromJson, true);
  }

  @override
  Future<Either<SDataException, Unit>> saveTeacher(STeacherItem teacher) {
    return _saveItem('teachers', teacher.toJson());
  }

  @override
  Future<Either<SDataException, Unit>> deleteTeacher(STeacherItem teacher) {
    return _deleteItem('teachers', teacher.id);
  }

  @override
  Future<Either<SDataException, List<SFeedbackItem>>> loadFeedback() {
    return _loadItems('feedback', SFeedbackItem.fromJson, true);
  }

  @override
  Future<Either<SDataException, Unit>> saveFeedback(SFeedbackItem feedback) {
    return _saveItem('feedback', feedback.toJson());
  }

  @override
  Future<Either<SDataException, Unit>> deleteFeedback(SFeedbackItem feedback) {
    return _deleteItem('feedback', feedback.id);
  }

  @override
  Future<Either<SDataException, SGlobalSettings>> loadGlobalSettings() {
    return _loadItem('config', 'globalSettings', SGlobalSettings.fromJson, true);
  }

  @override
  Future<Either<SDataException, Unit>> saveGlobalSettings(SGlobalSettings globalSettings) {
    return _saveItem('config', globalSettings.toJson());
  }

  @override
  Future<Either<SDataException, String>> uploadImage(String filename, String dir, Uint8List bytes) async {
    try {
      var i = 1;
      var fullFilename = filename;

      // Generate a unique filename by appending a number if the file already exists.
      while (await _fileExists('images/$dir', fullFilename)) {
        fullFilename = '$i-$filename';
        i++;
      }

      // Upload to Firebase Storage.
      final imageRef = FirebaseStorage.instance.ref('images/$dir/$fullFilename');
      await imageRef.putData(bytes);

      return right(
        // Return the download URL of the uploaded image.
        await imageRef.getDownloadURL(),
      );
    } catch (e) {
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: "Failed to upload image '$filename' to directory '$dir'.",
        ),
      );
    }
  }

  /// Load the privileges of a user by their UID.
  ///
  /// Only elevated privileges need to be stored in the database.
  /// If no entry is found for the user, `null` is returned.
  ///
  /// Used by [SFirebaseAuthRepository].
  Future<Either<SDataException, SUserPrivileges?>> loadUserPrivileges(String uid) async {
    final result = await _loadItem('config', 'privileges', Map<String, String>.from, true);

    return result.fold(
      left,
      (r) {
        final rawPrivileges = r[uid];

        return right(
          rawPrivileges != null ? SUserPrivileges.values.byName(rawPrivileges) : null,
        );
      },
    );
  }

  /// Registers the client in the analytics database.
  ///
  /// This function is used to register a client in the analytics database for anonymous
  /// and GDPR-compliant usage statistics. It adds a random UUID along with a timestamp
  /// to the appropriate collection in Firestore, depending on the client's platform.
  ///
  /// Note: This function should only be called for Android and iOS clients. Other platforms
  /// are not supported and will be ignored.
  ///
  /// Used by [SFirebaseAuthRepository].
  Future<void> registerClient() async {
    // Only Android and iOS clients should be registered.
    if (Platform.isAndroid || Platform.isIOS) {
      // ADJUST_VERSION_NUMBER
      final document = firestore.collection('analytics').doc('clientMetrics-v2.0');

      await document.set(
        {
          Platform.isAndroid ? 'androidClients' : 'iosClients': {
            const Uuid().v4(): DateTime.now().toIso8601String(),
          },
        },
        SetOptions(
          merge: true,
        ),
      );
    }
  }

  /// Helper method to load all items from a collection.
  Future<Either<SDataException, List<T>>> _loadItems<T>(
    String collection,
    T Function(Map<String, dynamic> data) fromJson, [
    bool allowCache = false,
  ]) async {
    try {
      // Load the items from Firestore.
      final snapshot = await firestore.collection(collection).get(
            GetOptions(
              source: allowCache ? Source.serverAndCache : Source.server,
            ),
          );

      // Convert the items to the desired type.
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return fromJson(data);
      }).toList();

      return right(items);
    } catch (e) {
      // Return an exception if loading failed.
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: "Failed to load items from collection '$collection.'",
        ),
      );
    }
  }

  /// Helper method to load an item from a collection.
  ///
  /// If [allowCache] is set to `true`, the method will fall back to the cache if the server is not reachable, instead of returning an exception.
  Future<Either<SDataException, T>> _loadItem<T>(
    String collection,
    String id,
    T Function(Map<String, dynamic> data) fromJson, [
    bool allowCache = false,
  ]) async {
    try {
      // Load the item from Firestore.
      final doc = await firestore.collection(collection).doc(id).get(
            GetOptions(
              source: allowCache ? Source.serverAndCache : Source.server,
            ),
          );

      final data = doc.data();

      // Convert the item to the desired type.
      if (data != null) {
        data['id'] = doc.id;
        return right(fromJson(data));
      }

      // If the item was not found, throw an internal exception.
      throw SInternalDataException.NOT_FOUND;
    } catch (e) {
      // Return an exception if loading failed.
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: "Failed to load item with ID '$id' from collection '$collection.'",
        ),
      );
    }
  }

  /// Helper method to save an item to a collection.
  Future<Either<SDataException, Unit>> _saveItem(String collection, Map<String, dynamic> data) async {
    // Remove the ID from the data map.
    final id = data.remove('id') as String;

    try {
      // Save the item to Firestore.
      await firestore.collection(collection).doc(id).set(data);
      return right(unit);
    } catch (e) {
      // Return an exception if saving failed.
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: "Failed to save item with ID '$id' to collection '$collection.'",
        ),
      );
    }
  }

  /// Helper method to delete an item from a collection.
  Future<Either<SDataException, Unit>> _deleteItem(String collection, String id) async {
    try {
      // Delete the item from Firestore.
      await firestore.collection(collection).doc(id).delete();
      return right(unit);
    } catch (e) {
      // Return an exception if deleting failed.
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: "Failed to delete item with ID '$id' from collection '$collection.'",
        ),
      );
    }
  }

  /// Helper method to check if a file exists in Firebase Storage.
  Future<bool> _fileExists(String dir, String filename) async {
    final directory = await FirebaseStorage.instance.ref(dir).list();
    return directory.items.any((element) => element.name == filename);
  }
}
