import 'package:client_information/client_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var _isAndroid10 = false;

/// Initializes system UI settings for Android 10 (API 29) or higher.
///
/// Enables edge-to-edge display by adjusting system UI mode.
///
/// Should be called once during app initialization.
Future<void> sInitAndroidSystemOverlayStyles() async {
  // Retrieve device information.
  final clientInformation = await ClientInformation.fetch();

  // Check if the device is running Android 10 (API 29) or higher.
  _isAndroid10 = clientInformation.osName == 'Android' && clientInformation.osVersionCode >= 29;

  // If the platform is Android 10 or higher, set the system UI mode to edge-to-edge.
  if (_isAndroid10) {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }
}

/// Updates system UI overlay style based on the given brightness.
///
/// Sets transparent bars and adjusts icon brightness for Android 10 or higher.
///
/// Should be called when the theme mode changes (light/dark mode).
void sUpdateAndroidSystemOverlayStyles(Brightness brightness) {
  // If the platform is Android 12 or higher, adjust the system overlay based on the theme mode.
  if (_isAndroid10) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }
}
