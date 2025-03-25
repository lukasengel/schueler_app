import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/util/_util.dart';

/// Show a platform-specific message dialog with the given title, content and an OK button.
///
/// Shows a [CupertinoAlertDialog] on iOS and an [FDialog] on other platforms.
Future<void> sShowPlatformMessageDialog({required BuildContext context, Widget? title, Widget? content}) {
  // Determine whether to show a Cupertino dialog.
  if (Platform.isIOS) {
    return sShowCupertinoMessageDialog(
      context: context,
      title: title,
      content: content,
    );
  }

  // Show a Forui dialog.
  return sShowForuiMessageDialog(
    context: context,
    title: title,
    content: content,
  );
}

/// Show a [CupertinoAlertDialog] with the given title, content and an OK button.
///
/// The value of [sDefaultMaxDialogWidth] is ignored, since Cupertino dialogs have a defazult width.
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
/// The value of [sDefaultMaxDialogWidth] is used as the maximum width constraint for the dialog.
Future<void> sShowForuiMessageDialog({required BuildContext context, Widget? title, Widget? content}) {
  return showDialog(
    context: context,
    builder: (context) => ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: sDefaultMaxDialogWidth,
      ),
      child: FDialog.adaptive(
        title: title != null
            ? Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: title,
              )
            : null,
        body: content != null
            ? Padding(
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
          ),
        ],
      ),
    ),
  );
}

/// Show a platform-specific confirm dialog with the given title, content and cancel and confirm buttons.
///
/// Shows a [CupertinoActionSheet] on iOS and an [FDialog] on other platforms.
///
/// Returns `true` or `false` depending on the user's choice.
Future<bool> sShowPlatformConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
}) {
  // Determine whether to show a Cupertino confirm dialog.
  if (Platform.isIOS) {
    return sShowCupertinoConfirmDialog(
      context: context,
      title: title,
      content: content,
      confirmLabel: confirmLabel,
    );
  }

  // Show a Forui confirm dialog.
  return sShowForuiConfirmDialog(
    context: context,
    title: title,
    content: content,
    confirmLabel: confirmLabel,
  );
}

/// Show a [CupertinoActionSheet] with the given title, content and cancel and confirm buttons.
///
/// The value of [sDefaultMaxDialogWidth] is used as the maximum width constraint for the action sheet.
///
/// Returns `true` or `false` depending on the user's choice.
Future<bool> sShowCupertinoConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
}) async {
  final input = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (context) => CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Theme.of(context).brightness,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: sDefaultMaxDialogWidth,
        ),
        child: CupertinoActionSheet(
          title: Text(title),
          message: Text(content),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(true),
              isDestructiveAction: true,
              child: Text(confirmLabel),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: Navigator.of(context).pop,
            child: Text(SAppLocalizations.of(context)!.cancel),
          ),
        ),
      ),
    ),
  );

  // If the user closes the dialog otherwise, return false.
  return input ?? false;
}

/// Show an [FDialog] with the given title, content and cancel and confirm buttons.
///
/// The value of [sDefaultMaxDialogWidth] is used as the maximum width constraint for the dialog.
///
/// Returns `true` or `false` depending on the user's choice.
Future<bool> sShowForuiConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
}) async {
  final input = await showDialog<bool>(
    context: context,
    builder: (context) => ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: sDefaultMaxDialogWidth,
      ),
      child: FDialog.adaptive(
        title: Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: Text(content),
        ),
        actions: [
          FButton(
            onPress: () => Navigator.of(context).pop(true),
            label: Text(confirmLabel),
            style: FButtonStyle.secondary,
          ),
          FButton(
            onPress: Navigator.of(context).pop,
            label: Text(SAppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    ),
  );

  // If the user closes the dialog otherwise, return false.
  return input ?? false;
}
