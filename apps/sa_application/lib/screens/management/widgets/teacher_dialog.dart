import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/theme/_theme.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';
import 'package:uuid/uuid.dart';

/// The dialog for creating or editing a teacher.
class STeacherDialog extends ConsumerStatefulWidget {
  /// The initial [STeacherItem] to edit.
  final STeacherItem? initial;

  /// Create a new [STeacherDialog].
  const STeacherDialog({
    this.initial,
    super.key,
  });

  @override
  ConsumerState<STeacherDialog> createState() => _STeacherDialogState();
}

class _STeacherDialogState extends ConsumerState<STeacherDialog> {
  final _abbreviationController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _usedAbbreviations = <String>{};

  void _onPressedSave() {
    // Validate the form.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      STeacherItem(
        id: widget.initial?.id ?? const Uuid().v4(),
        abbreviation: _abbreviationController.text.trim(),
        name: _nameController.text.trim(),
      ),
    );
  }

  /// Callback for validating the abbreviation field.
  String? _onValidateAbbreviation(String? input) {
    if (input.hasNoContent) {
      return SLocalizations.of(context)!.requiredField;
    }

    /// Check if the abbreviation is already in use.
    if (_usedAbbreviations.contains(input) && widget.initial?.abbreviation != input) {
      return SLocalizations.of(context)!.alreadyTaken;
    }

    return null;
  }

  /// Callback for validating the name field.
  String? _onValidateName(String? input) {
    if (input.hasNoContent) {
      return SLocalizations.of(context)!.requiredField;
    }

    return null;
  }

  @override
  void initState() {
    _usedAbbreviations.addAll(ref.read(sTeachersProvider)?.map((e) => e.abbreviation) ?? {});

    if (widget.initial != null) {
      _nameController.text = widget.initial!.name;
      _abbreviationController.text = widget.initial!.abbreviation;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: SCustomStyles.dialogConstraints,
      child: FDialog.adaptive(
        title: Padding(
          padding: SCustomStyles.dialogElementPadding,
          child: Text(
            // Show "Add" or "Edit" depending on whether the initial item is null or not.
            widget.initial == null ? SLocalizations.of(context)!.addTeacher : SLocalizations.of(context)!.editTeacher,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: SCustomStyles.dialogElementPadding,
                child: FTextFormField(
                  label: Text(SLocalizations.of(context)!.abbreviation),
                  hint: SLocalizations.of(context)!.abbreviation,
                  textInputAction: TextInputAction.next,
                  controller: _abbreviationController,
                  validator: _onValidateAbbreviation,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding: SCustomStyles.dialogElementPadding,
                child: FTextFormField(
                  label: Text(SLocalizations.of(context)!.name),
                  hint: SLocalizations.of(context)!.name,
                  textInputAction: TextInputAction.send,
                  onSubmit: (_) => _onPressedSave(),
                  controller: _nameController,
                  validator: _onValidateName,
                  autocorrect: false,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FButton(
            onPress: Navigator.of(context).pop,
            style: FButtonStyle.secondary,
            child: Text(SLocalizations.of(context)!.cancel),
          ),
          FButton(
            onPress: _onPressedSave,
            child: Text(SLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}
