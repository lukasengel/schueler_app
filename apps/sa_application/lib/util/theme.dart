import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// The application theme.
abstract final class SAppTheme {
  /// Get the Material [ThemeData] for the light theme.
  static ThemeData get light => _lightTheme.toApproximateMaterialTheme();

  /// Get the Material [ThemeData] for the dark theme.
  static ThemeData get dark => _darkTheme.toApproximateMaterialTheme();

  /// Get the [FThemeData] depending on the current theme mode setting and platform brightness.
  static FThemeData adaptive(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.light ? _lightTheme : _darkTheme;
      case ThemeMode.light:
        return _lightTheme;
      case ThemeMode.dark:
        return _darkTheme;
    }
  }

  /// The light [FThemeData] to be used.
  static FThemeData get _lightTheme => FThemes.zinc.light;

  /// The dark [FThemeData] to be used.
  static FThemeData get _darkTheme => FThemes.zinc.dark;
}
