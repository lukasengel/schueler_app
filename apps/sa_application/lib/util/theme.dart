import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Class to namespace theme values.
abstract final class STheme {
  /// Get the Material [ThemeData] for the light theme.
  static ThemeData get materialLight => _foruiLight.toApproximateMaterialTheme().copyWith(
        scrollbarTheme: ScrollbarThemeData(
          // Make scrollbars invisible by default, so they're also hidden on desktop platforms.
          thickness: WidgetStateProperty.all(0),
        ),
      );

  /// Get the Material [ThemeData] for the dark theme.
  static ThemeData get materialDark => _foruiDark.toApproximateMaterialTheme().copyWith(
        scrollbarTheme: ScrollbarThemeData(
          // Make scrollbars invisible by default, so they're also hidden on desktop platforms.
          thickness: WidgetStateProperty.all(0),
        ),
      );

  /// Get the [FThemeData] depending on the current theme mode setting and platform brightness.
  static FThemeData foruiAdaptive(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.light ? _foruiLight : _foruiDark;
      case ThemeMode.light:
        return _foruiLight;
      case ThemeMode.dark:
        return _foruiDark;
    }
  }

  /// Get the [TextStyle] for a small caption.
  static TextStyle smallCaptionStyle(BuildContext context) {
    return FTheme.of(context).typography.sm.copyWith(
          color: FTheme.of(context).colors.mutedForeground,
          letterSpacing: 1,
        );
  }

  /// Get the [TextStyle] for a medium caption.
  static TextStyle mediumCaptionStyle(BuildContext context) {
    return FTheme.of(context).typography.base.copyWith(
          color: FTheme.of(context).colors.mutedForeground,
          letterSpacing: 1.5,
        );
  }

  /// The light [FThemeData] to be used.
  static FThemeData get _foruiLight => FThemes.zinc.light;

  /// The dark [FThemeData] to be used.
  static FThemeData get _foruiDark => FThemes.zinc.dark;
}
