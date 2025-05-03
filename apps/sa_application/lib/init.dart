import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

/// Attempt to load the local settings from storage, and, if successful, provide an override for the local settings provider.
Future<Override?> loadLocalSettings() async {
  // Load local settings from storage.
  final localSettingsResult = await SLocalSettingsRepository.instance.loadLocalSettings();

  // If a record was found, add an override for the local settings provider.
  return localSettingsResult.fold(
    (l) {
      // If an error occurs here, do not inform the user.
      // Firstly, because this should never happen, at least I never managed to provoke an error on any platform.
      // Secondly, because the app will work regardless, at least to a certain extent, since the default values are used.
      // Lastly, because there is nothing we could do about it, anyway.
      SLogger.error('Failed to load local settings: $l');
      return null;
    },
    (r) {
      if (r != null) {
        return sLocalSettingsProvider.overrideWith(
          (ref) => SLocalSettingsNotifier(r),
        );
      }

      return null;
    },
  );
}

/// Attempt to restore the user session, and, if successful, provide an override for the auth provider.
Future<Override?> restoreSession() async {
  // Wait for the user session to be automatically restored by Firebase.
  final user = await SAuthRepository.instance.user.first;

  // If a user was found, provide an override.
  if (user != null) {
    return sAuthProvider.overrideWith(
      (ref) => SAuthNotifier(
        ref,
        SAuthState(user: user),
      ),
    );
  }

  return null;
}
