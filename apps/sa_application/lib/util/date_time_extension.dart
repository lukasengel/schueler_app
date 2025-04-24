import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Extension for the [DateTime] class.
extension SDateTimeExtension on DateTime {
  /// Format this [DateTime] to a localized date and time string.
  String formatDateTimeLocalized(BuildContext context) {
    final localeString = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(localeString).add_jm().format(this);
  }

  /// Format this [DateTime] to a localized date string including the day of the week.
  String formatDateLocalized(BuildContext context) {
    final localeString = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMEEEEd(localeString).format(this);
  }
}
