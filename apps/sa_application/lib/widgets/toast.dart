import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_data/sa_data.dart';
import 'package:toastification/toastification.dart';

/// Show an info toast on the bottom of the screen with the given message.
void sShowInfoToast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  _showThemedToast(
    context: context,
    type: ToastificationType.info,
    title: Text(message),
    duration: duration,
  );
}

/// Show an error toast with the given [message].
///
/// If [details] are provided, give the user the option to copy them to the clipboard.
void sShowErrorToast({
  required BuildContext context,
  required String message,
  String? details,
  Duration duration = const Duration(seconds: 5),
}) {
  _showThemedToast(
    context: context,
    type: ToastificationType.error,
    title: Text('${SLocalizations.of(context)!.error} $message'),
    description: details != null
        ? FTappable(
            child: Text(SLocalizations.of(context)!.tapToCopyDetails),
            onPress: () => _copyToClipboard(context, details),
          )
        : null,
    duration: duration,
  );
}

/// Display an error toast based on a [SDataException].
///
/// If no [message] is provided, it will be determined based on the exception type.
/// The exception will be used as details for the user user to copy.
void sShowDataExceptionToast({
  required BuildContext context,
  required SDataException exception,
  String? message,
  Duration duration = const Duration(seconds: 5),
}) {
  String resultingMessage;

  // If no message is provided, determine it based on the exception type.
  if (message == null) {
    resultingMessage = switch (exception.type) {
      SDataExceptionType.NO_CONNECTION => SLocalizations.of(context)!.dataExceptionType_noConnection,
      SDataExceptionType.INVALID_CREDENTIALS => SLocalizations.of(context)!.dataExceptionType_invalidCredentials,
      SDataExceptionType.TOO_MANY_REQUESTS => SLocalizations.of(context)!.dataExceptionType_tooManyRequests,
      SDataExceptionType.NOT_FOUND => SLocalizations.of(context)!.dataExceptionType_notFound,
      SDataExceptionType.UNAUTHORIZED => SLocalizations.of(context)!.dataExceptionType_unauthorized,
      SDataExceptionType.PARSING_FAILED => SLocalizations.of(context)!.dataExceptionType_parsingFailed,
      SDataExceptionType.LOCAL_STORAGE_FAILURE => SLocalizations.of(context)!.dataExceptionType_localStorageFailure,
      SDataExceptionType.OTHER => SLocalizations.of(context)!.dataExceptionType_other,
    };
  }
  // Otherwise, use the provided message.
  else {
    resultingMessage = message;
  }

  sShowErrorToast(
    context: context,
    message: resultingMessage,
    // Provide the exception as details.
    details: exception.toString(),
    duration: duration,
  );
}

/// Helper function to display a toast with the correct theming.
void _showThemedToast({
  required BuildContext context,
  required ToastificationType type,
  required Widget title,
  Widget? description,
  Duration? duration,
}) {
  // Provide haptic feedback on mobile platforms.
  if (Platform.isIOS || Platform.isAndroid) {
    HapticFeedback.mediumImpact();
  }

  toastification.show(
    context: context,
    title: title,
    description: description,
    autoCloseDuration: duration,
    type: type,
    alignment: Alignment.bottomCenter,
    backgroundColor: FTheme.of(context).colors.background,
    foregroundColor: FTheme.of(context).colors.foreground,
    boxShadow: FTheme.of(context).style.shadow,
    borderSide: BorderSide(
      color: FTheme.of(context).colors.border,
      width: FTheme.of(context).style.borderWidth,
    ),
    animationDuration: const Duration(
      milliseconds: 400,
    ),
  );
}

/// Helper function to copy the given text to the clipboard.
Future<void> _copyToClipboard(BuildContext context, String text) async {
  // Copy to clipboard.
  await Clipboard.setData(ClipboardData(text: text));

  // Show info toast as confirmation.
  if (context.mounted) {
    sShowInfoToast(
      context: context,
      message: SLocalizations.of(context)!.copiedDetails,
    );
  }
}
