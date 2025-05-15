import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/theme/_theme.dart';

/// Class to namespace custom theme values.
abstract final class SCustomTheme {
  /// Get the light Material [ThemeData] based on the light [FThemeData].
  static ThemeData get materialLight => zincLight.toApproximateMaterialTheme().copyWith(
        scrollbarTheme: ScrollbarThemeData(
          // Make scrollbars invisible by default, so they're also hidden on desktop platforms.
          thickness: WidgetStateProperty.all(0),
        ),
      );

  /// Get the dark Material [ThemeData] based on the dark [FThemeData].
  static ThemeData get materialDark => zincDark.toApproximateMaterialTheme().copyWith(
        scrollbarTheme: ScrollbarThemeData(
          // Make scrollbars invisible by default, so they're also hidden on desktop platforms.
          thickness: WidgetStateProperty.all(0),
        ),
      );
}
