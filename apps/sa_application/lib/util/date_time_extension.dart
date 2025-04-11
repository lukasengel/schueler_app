import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Extension for the [DateTime] class.
extension SDateTimeExtension on DateTime {
  /// Format this [DateTime] to a localized string.
  String formatLocalized(BuildContext context) {
    final localeString = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(localeString).add_jm().format(this);
  }
}
