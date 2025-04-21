import 'package:flutter/material.dart';

/// Class to namespace styling values.
abstract final class SStyles {
  /// The default maximum width for the content of a screen.
  static const maxContentWidth = 600.0;

  /// The default padding for list views.
  static const listViewPadding = EdgeInsets.fromLTRB(0, 12, 0, 48);

  /// The default spacing between tiles in a list view.
  static const listTileSpacing = 10.0;

  /// The default spacing between elements in a management tile.
  static const managementTileElementSpacing = 5.0;

  /// The default constraints for a Forui dialog.
  static const dialogConstraints = BoxConstraints(maxWidth: 400);

  /// The padding for elements in a Forui dialog.
  static const dialogElementPadding = EdgeInsets.only(bottom: 12);
}
