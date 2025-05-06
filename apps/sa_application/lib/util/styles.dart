import 'package:flutter/material.dart';

/// Class to namespace styling values.
abstract final class SStyles {
  /// The default maximum width for the content of a screen.
  static const maxContentWidth = 600.0;

  /// The default padding for the content of a screen.
  static const contentPadding = EdgeInsets.fromLTRB(10, 12, 10, 12);

  /// The padding for the content of a screen that does not have a bottom navigation bar.
  ///
  /// Respects the bottom view padding, for example for devices with rounded corners.
  static EdgeInsets adaptiveContentPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(10, 12, 10, 12 + MediaQuery.viewPaddingOf(context).bottom);
  }

  /// The default spacing between tiles in a list view.
  static const listTileSpacing = 10.0;

  /// The default spacing between elements in tiles.
  static const tileElementSpacing = 5.0;

  /// The default constraints for a Forui dialog.
  static const dialogConstraints = BoxConstraints(maxWidth: 400);

  /// The padding for elements in a Forui dialog.
  static const dialogElementPadding = EdgeInsets.only(bottom: 12);
}
