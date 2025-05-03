import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

/// Authentication state of the app. Currently, only a wrapper for the currently logged in user.
@immutable
class SAuthState {
  /// The current user.
  final SUser? user;

  /// Create a new [SAuthState].
  const SAuthState({
    required this.user,
  });

  /// Whether the user is authenticated.
  bool get isAuthenticated => user != null;

  /// Whether the user has management privileges.
  bool get isManager => user != null && user!.privileges.index >= SUserPrivileges.MANAGER.index;

  /// Whether the user has admin privileges.
  bool get isAdmin => user != null && user!.privileges.index >= SUserPrivileges.ADMIN.index;
}

/// Notifier for authentication.
class SAuthNotifier extends StateNotifier<SAuthState> {
  // Reference to access other providers.
  final Ref _ref;

  /// Create a new [SAuthNotifier] with the given initial state.
  SAuthNotifier(this._ref, super.state) {
    // Subscribe to the user stream.
    SAuthRepository.instance.user.listen((user) {
      state = SAuthState(
        user: user,
      );
    });
  }

  /// Log in the user with the given [username] and [password].
  Future<Either<SDataException, Unit>> login({required String username, required String password}) async {
    final loginResult = await SAuthRepository.instance.login(
      username: username,
      password: password,
    );

    return loginResult.fold(
      left,
      (r) async {
        // Upon success, update the local settings with the username and password.
        final updateRes = await _ref.read(sLocalSettingsProvider.notifier).updateWith(
              username: username,
              password: password,
            );

        return updateRes;
      },
    );
  }

  /// Log out the currently logged in user.
  ///
  /// This includes clearing the entire application state and resetting the local settings.
  Future<Either<SDataException, Unit>> logout() async {
    await _ref.read(sLoadingProvider.notifier).clear();
    return SAuthRepository.instance.logout();
  }
}

/// Provider for authentication.
final sAuthProvider = StateNotifierProvider<SAuthNotifier, SAuthState>(
  (ref) => SAuthNotifier(
    ref,
    const SAuthState(
      user: null,
    ),
  ),
);
