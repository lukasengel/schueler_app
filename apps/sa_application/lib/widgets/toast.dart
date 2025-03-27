import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
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
    title: Text('${SAppLocalizations.of(context)!.error} $message'),
    description: details != null
        ? FTappable.animated(
            child: Text(SAppLocalizations.of(context)!.tapToCopyDetails),
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
      SDataExceptionType.NO_CONNECTION => SAppLocalizations.of(context)!.dataExceptionType_noConnection,
      SDataExceptionType.NOT_FOUND => SAppLocalizations.of(context)!.dataExceptionType_notFound,
      SDataExceptionType.UNAUTHORIZED => SAppLocalizations.of(context)!.dataExceptionType_unauthorized,
      SDataExceptionType.PARSING_FAILED => SAppLocalizations.of(context)!.dataExceptionType_parsingFailed,
      SDataExceptionType.LOCAL_STORAGE_FAILURE => SAppLocalizations.of(context)!.dataExceptionType_localStorageFailure,
      SDataExceptionType.OTHER => SAppLocalizations.of(context)!.dataExceptionType_other,
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
    closeButton: ToastCloseButton(
      buttonBuilder: (context, onClose) => FButton.icon(
        onPress: onClose,
        style: FButtonStyle.ghost,
        child: FIcon(FAssets.icons.x),
      ),
    ),
    alignment: Alignment.bottomCenter,
    backgroundColor: FTheme.of(context).colorScheme.background,
    foregroundColor: FTheme.of(context).colorScheme.foreground,
    boxShadow: FTheme.of(context).style.shadow,
    borderSide: BorderSide(
      color: FTheme.of(context).colorScheme.border,
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
      message: SAppLocalizations.of(context)!.copiedDetails,
    );
  }
}
