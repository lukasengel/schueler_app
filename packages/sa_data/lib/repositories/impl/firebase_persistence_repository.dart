import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sa_data/sa_data.dart';

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
  Future<Either<SDataException, List<STeacherItem>>> loadTeachers() {
    return _loadItems('teachers', STeacherItem.fromJson);
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
    return _loadItems('feedback', SFeedbackItem.fromJson);
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
    return _loadItem('config', 'globalSettings', SGlobalSettings.fromJson);
  }

  @override
  Future<Either<SDataException, Unit>> saveGlobalSettings(SGlobalSettings globalSettings) {
    return _saveItem('config', globalSettings.toJson());
  }

  /// Helper method to load all items from a collection.
  Future<Either<SDataException, List<T>>> _loadItems<T>(
    String collection,
    T Function(Map<String, dynamic> data) fromJson,
  ) async {
    try {
      // Load the items from Firestore.
      final snapshot = await firestore.collection(collection).get();

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
  Future<Either<SDataException, T>> _loadItem<T>(
    String collection,
    String id,
    T Function(Map<String, dynamic> data) fromJson,
  ) async {
    try {
      // Load the item from Firestore.
      final doc = await firestore.collection(collection).doc(id).get();
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
}
