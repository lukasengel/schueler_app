import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SAuthRepository] using Firebase Auth.
class SFirebaseAuthRepository extends SAuthRepository {
  // Make the class non-instantiable.
  SFirebaseAuthRepository._() {
    // Listen to auth state changes.
    firebaseAuth.userChanges().listen((user) async {
      if (user != null) {
        // Load the user's privileges from the database.
        final result = await SFirebasePersistenceRepository.instance.loadUserPrivileges(user.uid);

        // If an error occurred, log it.
        final privileges = result.fold(
          (l) {
            SLogger.error('Failed to load user privileges for ${user.uid}.\n\n$l');
            return null;
          },
          (r) => r,
        );

        // If no privileges are available, either due to an error or because there is no entry for this user, they are considered a student.
        return _controller.add(
          SUser(
            displayName: user.displayName ?? user.uid,
            privileges: privileges ?? SUserPrivileges.STUDENT,
          ),
        );
      }

      _controller.add(null);
    });
  }

  /// The instance to be used throughout the app.
  static final instance = SFirebaseAuthRepository._();

  // A custom Firebase Auth instance.
  FirebaseAuth? _firebaseAuth;

  /// The firestore instance to be used. If no custom instance is set, the default instance will be used.
  FirebaseAuth get firebaseAuth => _firebaseAuth ?? FirebaseAuth.instance;

  /// Set a custom firestore instance to be used.
  set firebaseAuth(FirebaseAuth firebaseAuth) {
    _firebaseAuth = firebaseAuth;
  }

  // The stream controller for the user stream.
  final _controller = StreamController<SUser?>.broadcast();

  @override
  Stream<SUser?> get user => _controller.stream;

  @override
  Future<Either<SDataException, Unit>> login({required String username, required String password}) async {
    try {
      // Calculate the Firebase username, which is a SHA-256 hash of the username and password.
      // This is necessary, because we want to use the same username to work with multiple passwords.
      // Not the prettiest solution, but it's acceptable for the amount of effort we want to put into this.
      final bytes = utf8.encode('$username-$password');
      final hash = sha256.convert(bytes).toString();

      // Use the hash as username and my domain as email.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '$hash@lukasengel.net',
        password: password,
      );

      // Attempt to register the client for analytics.
      final analyticsResult = await registerClient();

      // If an error occurred, log it.
      analyticsResult.fold(
        (l) => SLogger.error('Failed to register client for analytics.\n\n$l'),
        (r) => null,
      );

      SLogger.debug("Logged in as '$username.'");
      return right(unit);
    } catch (e) {
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: 'Failed to log in.',
        ),
      );
    }
  }

  @override
  Future<Either<SDataException, Unit>> logout() async {
    try {
      await firebaseAuth.signOut();
      _controller.add(null);
      SLogger.debug('Logged out.');
      return right(unit);
    } catch (e) {
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: 'Failed to log out.',
        ),
      );
    }
  }

  /// Performs analytics registration for the client upon login.
  ///
  /// This function is executed during the login process to ensure that each client
  /// is registered for anonymous and GDPR-compliant usage statistics. The goal is
  /// to track the number of app downloads and registrations without collecting any
  /// personally identifiable information.
  ///
  /// The function checks if the client has already been registered for analytics.
  /// If not, it registers the client by adding a random value to the "iosClients"
  /// or "androidClients" array in the database. This allows tracking the number of
  /// unique installations and sign-ins without identifying individual clients.
  ///
  /// This registration process is performed only once per installation, during the
  /// first login.
  Future<Either<SDataException, Unit>> registerClient() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final registered = prefs.getBool('analyticsRegistered');

      // If the cleint has already been registered in analytics, do nothing.
      if (registered != true) {
        // Register the client in analytics.
        await SFirebasePersistenceRepository.instance.registerClient();

        // Save the registration status in shared preferences.
        await prefs.setBool('analyticsRegistered', true);
      }

      return right(unit);
    } catch (e) {
      return left(
        SDataException.fromCaughtObject(
          caughtObject: e,
          description: 'Failed to register client in analytics.',
        ),
      );
    }
  }
}
