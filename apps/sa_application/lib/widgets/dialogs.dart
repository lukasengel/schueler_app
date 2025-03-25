import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/util/_util.dart';

/// Show a platform-specific message dialog with the given title, content and an OK button.
///
/// Shows a [CupertinoAlertDialog] on macOS and iOS and an [FDialog] on other platforms.
Future<void> sShowPlatformMessageDialog({required BuildContext context, Widget? title, Widget? content}) {
  // Determine whether to show a Cupertino dialog.
  if (Platform.isIOS || Platform.isMacOS) {
    return sShowCupertinoMessageDialog(
      context: context,
      title: title,
      content: content,
    );
  }

  // Show a Material dialog.
  return sShowForuiMessageDialog(
    context: context,
    title: title,
    content: content,
  );
}

/// Show a [CupertinoAlertDialog] with the given title, content and an OK button.
Future<void> sShowCupertinoMessageDialog({required BuildContext context, Widget? title, Widget? content}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Theme.of(context).brightness,
      ),
      child: CupertinoAlertDialog(
        title: title,
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: Navigator.of(context).pop,
            child: Text(SAppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    ),
  );
}

/// Show an [FDialog] with the given title, content and an OK button.
///
/// The value of [sDefaultMaxDialogContentWidth] is used as the maximum width constraint for the content.
Future<void> sShowForuiMessageDialog({required BuildContext context, Widget? title, Widget? content}) {
  return showDialog(
    context: context,
    builder: (context) => FDialog.adaptive(
      title: title != null
          ? Container(
              constraints: const BoxConstraints(
                maxWidth: sDefaultMaxDialogContentWidth,
              ),
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: title,
            )
          : null,
      body: content != null
          ? Container(
              constraints: const BoxConstraints(
                maxWidth: sDefaultMaxDialogContentWidth,
              ),
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: content,
            )
          : null,
      actions: [
        FButton(
          onPress: Navigator.of(context).pop,
          label: Text(SAppLocalizations.of(context)!.ok),
          style: FButtonStyle.outline,
        ),
      ],
    ),
  );
}
