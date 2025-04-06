import 'package:flutter/material.dart';

/// Class to namespace styling values.
abstract final class SStyles {
  /// The default maximum width for the content of a screen.
  static const defaultMaxContentWidth = 600.0;

  /// The default maximum width for a dialog
  static const defaultMaxDialogWidth = 400.0;

  /// The default padding for list views.
  static const defaultListViewPadding = EdgeInsets.fromLTRB(0, 12, 0, 48);

  /// The default spacing between tiles in a list view.
  static const defaultListTileSpacing = 10.0;

  /// The default spacing between elements in a Forui dialog.
  static const defaultDialogElementSpacing = 12.0;
}
