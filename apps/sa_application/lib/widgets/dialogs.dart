import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';

/// Show a platform-specific message dialog with the given title, content and an OK button.
///
/// Shows a native dialog using [FlutterPlatformAlert] on iOS, and an [FDialog] on other platforms.
Future<void> sShowPlatformMessageDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  // Show a native dialog on iOS.
  if (Platform.isIOS) {
    return FlutterPlatformAlert.showCustomAlert(
      windowTitle: title,
      text: content,
      neutralButtonTitle: SLocalizations.of(context)!.ok,
    );
  }

  // On other platforms, show a Forui dialog.
  return sShowCustomDialog(
    context: context,
    title: Text(title),
    content: Text(content),
    actions: [
      FButton(
        onPress: Navigator.of(context).pop,
        label: Text(SLocalizations.of(context)!.ok),
      ),
    ],
  );
}

/// Show a platform-specific confirm dialog with the given title, content and cancel and confirm buttons.
///
/// Shows a native dialog using [FlutterPlatformAlert] on iOS, and an [FDialog] on other platforms.
///
/// Returns `true` or `false` depending on the user's choice.
Future<bool> sShowPlatformConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
}) async {
  // Show a native dialog on iOS.
  if (Platform.isIOS) {
    final input = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: title,
      text: content,
      positiveButtonTitle: confirmLabel,
      negativeButtonTitle: SLocalizations.of(context)!.cancel,
      options: PlatformAlertOptions(
        ios: IosAlertOptions(
          positiveButtonStyle: IosButtonStyle.destructive,
          negativeButtonStyle: IosButtonStyle.cancel,
        ),
      ),
    );

    return input == CustomButton.positiveButton;
  }

  // On other platforms, show a Forui dialog.
  final input = await sShowCustomDialog<bool>(
    context: context,
    title: Text(title),
    content: Text(content),
    actions: [
      FButton(
        onPress: Navigator.of(context).pop,
        label: Text(SLocalizations.of(context)!.cancel),
        style: FButtonStyle.secondary,
      ),
      FButton(
        onPress: () => Navigator.of(context).pop(true),
        label: Text(confirmLabel),
      ),
    ],
  );

  return input ?? false;
}

/// Show a custom dialog with the given title, content and actions using an [FDialog].
///
/// Used for all dialogs that should look the same across all platforms or for dialogs, that cannot be displayed using the native API.
Future<T?> sShowCustomDialog<T>({
  required BuildContext context,
  required List<Widget> actions,
  Widget? title,
  Widget? content,
}) {
  return sShowAdaptiveDialog(
    context: context,
    builder: (context) => ConstrainedBox(
      constraints: SStyles.dialogConstraints,
      child: FDialog.adaptive(
        title: title != null
            ? Padding(
                padding: SStyles.dialogElementPadding,
                child: title,
              )
            : null,
        body: content != null
            ? Padding(
                padding: SStyles.dialogElementPadding,
                child: content,
              )
            : null,
        actions: actions,
      ),
    ),
  );
}

/// Mimics the behavior of [showAdaptiveDialog].
///
/// The only difference is that [showDialog] is used instead of [showCupertinoDialog] on macOS.
Future<T?> sShowAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  /// Wrap the dialog with a [PopScope] and a [GestureDetector] to dismiss the keyboard when tapping outside of a text field.
  Widget buildWrappedDialog(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => FocusScope.of(context).unfocus(),
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: builder(context),
      ),
    );
  }

  // On iOS, use Cupertino animation.
  if (Platform.isIOS) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: buildWrappedDialog,
    );
  }

  // On other platforms, use Material animation.
  return showDialog<T>(
    context: context,
    builder: buildWrappedDialog,
  );
}
