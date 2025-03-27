import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_common/sa_common.dart';

/// The settings screen for reporting bugs or providing feedback.
class SReportBugsScreen extends ConsumerStatefulWidget {
  /// Create a new [SReportBugsScreen].
  const SReportBugsScreen({super.key});

  @override
  ConsumerState<SReportBugsScreen> createState() => _SReportBugsScreenState();
}

class _SReportBugsScreenState extends ConsumerState<SReportBugsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  /// Callback for when the privacy note button is pressed.
  void _onPressedPrivacyNote() {
    sShowPlatformMessageDialog(
      context: context,
      title: Text(SAppLocalizations.of(context)!.privacyNote),
      content: Text(SAppLocalizations.of(context)!.privacyInfo),
    );
  }

  /// Callback for when the cancel button is pressed.
  Future<void> _onPressedCancel() async {
    // Extract the inputs from the text controllers.
    final inputs = [
      _nameController.text,
      _emailController.text,
      _messageController.text,
    ];

    // Check if any of the fields have content.
    final notEmpty = inputs.any((element) => element.hasContent);

    // If there is content, ask for confirmation first.
    if (notEmpty) {
      final input = await sShowPlatformConfirmDialog(
        context: context,
        title: SAppLocalizations.of(context)!.discardFeedback,
        content: SAppLocalizations.of(context)!.discardFeedbackMsg,
        confirmLabel: SAppLocalizations.of(context)!.discard,
      );

      if (input == false) {
        return;
      }
    }

    // Pop the screen.
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Callback for when the submit button is pressed.
  Future<void> _onPressedSubmit() async {
    // Validate form.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ask for confirmation.
    final input = await sShowPlatformConfirmDialog(
      context: context,
      title: SAppLocalizations.of(context)!.submitFeedback,
      content: SAppLocalizations.of(context)!.submitFeedbackMsg,
      confirmLabel: SAppLocalizations.of(context)!.submit,
    );

    // If the user confirms, send the feedback.
    if (input) {
      // Send feedback.
      final result = await ref.read(sFeedbackProvider.notifier).submitFeedback(
            message: _messageController.text,
            name: _nameController.text,
            email: _emailController.text,
          );

      // Show a toast if an error occurred.
      result.fold(
        (l) => sShowDataExceptionToast(
          context: context,
          exception: l,
          message: SAppLocalizations.of(context)!.failedSavingSettings,
        ),
        (r) => null,
      );

      // Pop the screen.
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  /// Callback to validate the message field.
  String? _onValidate(String? input) {
    return input.hasNoContent ? SAppLocalizations.of(context)!.enterMessage : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: FScaffold(
        header: SHeaderWrapper(
          child: FHeader.nested(
            title: SHeaderTitleWrapper(
              child: Text(
                SAppLocalizations.of(context)!.reportBugs,
              ),
            ),
            prefixActions: [
              FHeaderAction.back(
                onPress: _onPressedCancel,
              ),
            ],
            suffixActions: [
              FHeaderAction(
                icon: FIcon(FAssets.icons.send),
                onPress: _onPressedSubmit,
              ),
            ],
          ),
        ),
        content: SContentWrapper(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: sDefaultListViewPadding,
              children: [
                FTextField(
                  controller: _nameController,
                  label: Text(SAppLocalizations.of(context)!.contactDetails),
                  hint: SAppLocalizations.of(context)!.nameOptional,
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: sDefaultListTileSpacing,
                ),
                FTextField(
                  controller: _emailController,
                  hint: SAppLocalizations.of(context)!.emailOptional,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: sDefaultListTileSpacing,
                ),
                FTextField(
                  controller: _messageController,
                  label: Text(SAppLocalizations.of(context)!.message),
                  hint: SAppLocalizations.of(context)!.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  validator: _onValidate,
                ),
                const SizedBox(
                  height: sDefaultListTileSpacing,
                ),
                Center(
                  child: FTappable.animated(
                    onPress: _onPressedPrivacyNote,
                    child: Text(
                      SAppLocalizations.of(context)!.privacyNote,
                      style: FTheme.of(context).typography.sm,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
