import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_data/sa_data.dart';

/// Pre-load the application state.
///
/// That includes loading the local settings from storage and restoring the user session, if available.
Future<(List<Override>, List<SDataException>)> preloadState() async {
  final overrides = <Override>[];
  final exceptions = <SDataException>[];

  // Load local settings from storage.
  final localSettingsResult = await SLocalSettingsRepository.instance.loadLocalSettings();

  // If a record was found, add an override for the provider.
  // If an exception occurred, add it to the list of exceptions.
  localSettingsResult.fold(
    exceptions.add,
    (r) {
      if (r != null) {
        overrides.add(
          sLocalSettingsProvider.overrideWith(
            (ref) => SLocalSettingsNotifier(r),
          ),
        );
      }
    },
  );

  return (overrides, exceptions);
}
