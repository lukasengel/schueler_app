import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_data/sa_data.dart';
import 'package:uuid/uuid.dart';

/// The different types of school life items.
enum _SSchoolLifeItemType {
  ANNOUNCEMENT,
  EVENT,
  POST,
}

/// The possible image sources for a school life item.
enum _SImageSource {
  EXTERNAL,
  FILE,
}

/// The dialog for creating or editing a teacher.
class SSchoolLifeDialog extends StatefulWidget {
  /// The initial [STeacherItem] to edit.
  final SSchoolLifeItem? initial;

  /// Create a new [SSchoolLifeDialog].
  const SSchoolLifeDialog({
    this.initial,
    super.key,
  });

  @override
  State<SSchoolLifeDialog> createState() => _SSchoolLifeDialogState();
}

class _SSchoolLifeDialogState extends State<SSchoolLifeDialog> with SingleTickerProviderStateMixin {
  late FDateFieldController _eventDateController;
  final _headlineController = TextEditingController();
  final _contentController = TextEditingController();
  final _hyperlinkController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imageFieldKey = GlobalKey<FormFieldState<String>>();

  late String _uuid;
  var _itemType = _SSchoolLifeItemType.ANNOUNCEMENT;
  var _imageSource = _SImageSource.FILE;
  var _darkHeadlineColoring = true;
  var _uploading = false;

  /// Callback for when the cancel button is pressed.
  Future<void> _onPressedCancel() async {
    // Dismiss the keyboard.
    FocusScope.of(context).unfocus();

    /// Ask for confirmation before.
    final input = await sShowPlatformConfirmDialog(
      context: context,
      title: SLocalizations.of(context)!.discardChanges,
      content: SLocalizations.of(context)!.discardChangesMsg,
      confirmLabel: SLocalizations.of(context)!.discard,
    );

    if (input == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Callback for when the save button is pressed.
  void _onPressedSave() {
    // Validate the form.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Extract the input from the form and create a new school life item.
    final result = switch (_itemType) {
      _SSchoolLifeItemType.ANNOUNCEMENT => SSchoolLifeItem.announcement(
          id: widget.initial?.id ?? const Uuid().v4(),
          datetime: widget.initial?.datetime ?? DateTime.now(),
          headline: _headlineController.text.trim(),
          content: _contentController.text.trim(),
          hyperlink: _hyperlinkController.text.trimOrNull(),
          article: widget.initial?.article,
        ),
      _SSchoolLifeItemType.EVENT => SSchoolLifeItem.event(
          id: widget.initial?.id ?? const Uuid().v4(),
          datetime: widget.initial?.datetime ?? DateTime.now(),
          headline: _headlineController.text.trim(),
          content: _contentController.text.trim(),
          eventDate: _eventDateController.value!,
          hyperlink: _hyperlinkController.text.trimOrNull(),
          article: widget.initial?.article,
        ),
      _SSchoolLifeItemType.POST => SSchoolLifeItem.post(
          id: widget.initial?.id ?? const Uuid().v4(),
          datetime: widget.initial?.datetime ?? DateTime.now(),
          headline: _headlineController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          darkHeadline: _darkHeadlineColoring,
          hyperlink: _hyperlinkController.text.trimOrNull(),
          article: widget.initial?.article,
        ),
    };

    // Pop the screen and return the result.
    Navigator.of(context).pop(result);
  }

  /// Callback for when the image upload button is pressed.
  Future<void> _onUploadImage() async {
    setState(() => _uploading = true);

    // Show a file picker to select an image.
    final selection = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (selection != null && mounted) {
      // Upload image. The directory name is the UUID of the item.
      final result = await SPersistenceRepository.instance.uploadImage(
        selection.files.single.name,
        _uuid,
        selection.files.single.bytes!,
      );

      result.fold(
        (l) => sShowDataExceptionToast(
          context: context,
          exception: l,
        ),
        (r) {
          setState(() {
            _imageUrlController.text = r;
            _imageFieldKey.currentState?.didChange(r);
          });
        },
      );
    }

    setState(() => _uploading = false);
  }

  /// Callback for when the remove image button is pressed.
  void _onRemoveImage() {
    setState(() {
      _imageUrlController.clear();
      _imageFieldKey.currentState?.didChange(null);
    });
  }

  /// Callback for when the type of item is selected using the dropdown menu.
  void _onSelectType(_SSchoolLifeItemType? value) {
    if (value != null) {
      setState(() {
        _itemType = value;
      });
    }
  }

  /// Callback for when the image source is selected using the dropdown menu.
  void _onSelectImageSource(_SImageSource? value) {
    if (value != null) {
      setState(() {
        _imageSource = value;
      });
    }
  }

  /// Callback for when the headline coloring is selected using the dropdown menu.
  void _onSelectHeadlineColoring(bool? value) {
    if (value != null) {
      setState(() {
        _darkHeadlineColoring = value;
      });
    }
  }

  /// Callback for validating a required field.
  String? _onValidateRequired(String? input) {
    return input.hasNoContent ? SLocalizations.of(context)!.requiredField : null;
  }

  @override
  void initState() {
    super.initState();

    DateTime? initialDate;

    if (widget.initial != null) {
      _uuid = widget.initial!.id;
      _headlineController.text = widget.initial!.headline;
      _contentController.text = widget.initial!.content;
      _hyperlinkController.text = widget.initial!.hyperlink ?? '';

      widget.initial!.map(
        announcement: (item) {
          _itemType = _SSchoolLifeItemType.ANNOUNCEMENT;
        },
        event: (item) {
          _itemType = _SSchoolLifeItemType.EVENT;
          initialDate = item.eventDate;
        },
        post: (item) {
          _itemType = _SSchoolLifeItemType.POST;
          _darkHeadlineColoring = item.darkHeadline;
          _imageUrlController.text = item.imageUrl;

          WidgetsBinding.instance.addPersistentFrameCallback((_) {
            _imageFieldKey.currentState?.didChange(item.imageUrl);
          });

          // If the image is stored in Firebase storage, it has been uploaded by the user.
          _imageSource =
              item.imageUrl.contains('firebasestorage.googleapis.com') ? _SImageSource.FILE : _SImageSource.EXTERNAL;
        },
      );
    } else {
      _uuid = const Uuid().v4();
    }

    _eventDateController = FDateFieldController(
      validator: (input) => _onValidateRequired(input?.toString()),
      initialDate: initialDate,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _eventDateController.dispose();
    _headlineController.dispose();
    _contentController.dispose();
    _hyperlinkController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SScaffold.constrained(
      header: SHeader(
        title: Text(
          // Show "add" or "edit" depending on whether the initial item is null or not.
          widget.initial == null ? SLocalizations.of(context)!.addEntry : SLocalizations.of(context)!.editEntry,
        ),
        prefixes: [
          FHeaderAction.back(
            onPress: _uploading ? null : _onPressedCancel,
          ),
        ],
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.check),
            onPress: _uploading ? null : _onPressedSave,
          ),
        ],
      ),
      content: SingleChildScrollView(
        padding: SStyles.adaptiveContentPadding(context),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show a dropdown menu to select the type of item.
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                  ),
                  child: FSelect.fromMap(
                    {
                      SLocalizations.of(context)!.announcement: _SSchoolLifeItemType.ANNOUNCEMENT,
                      SLocalizations.of(context)!.event: _SSchoolLifeItemType.EVENT,
                      SLocalizations.of(context)!.post: _SSchoolLifeItemType.POST,
                    },
                    onChange: _onSelectType,
                    initialValue: _itemType,
                    label: Text(SLocalizations.of(context)!.type),
                  ),
                ),
              ),
              const SizedBox(
                height: SStyles.listTileSpacing,
              ),
              FTextFormField(
                controller: _headlineController,
                label: Text(SLocalizations.of(context)!.headline),
                hint: SLocalizations.of(context)!.headline,
                textInputAction: TextInputAction.done,
                validator: _onValidateRequired,
              ),
              const SizedBox(
                height: SStyles.listTileSpacing,
              ),
              FTextFormField(
                controller: _contentController,
                label: Text(SLocalizations.of(context)!.content),
                hint: SLocalizations.of(context)!.content,
                textInputAction: TextInputAction.newline,
                validator: _onValidateRequired,
                maxLines: 20,
                minLines: 10,
              ),

              // If the event type is selected, show a date picker.
              if (_itemType == _SSchoolLifeItemType.EVENT) ...[
                const SizedBox(
                  height: SStyles.listTileSpacing,
                ),
                FDateField.calendar(
                  controller: _eventDateController,
                  label: Text(SLocalizations.of(context)!.eventDate),
                ),
              ],

              // If the post type is selected, show an image picker.
              if (_itemType == _SSchoolLifeItemType.POST) ...[
                const SizedBox(
                  height: SStyles.listTileSpacing,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FSelect.fromMap(
                        {
                          SLocalizations.of(context)!.external: _SImageSource.EXTERNAL,
                          SLocalizations.of(context)!.file: _SImageSource.FILE,
                        },
                        onChange: _onSelectImageSource,
                        initialValue: _imageSource,
                        label: Text(SLocalizations.of(context)!.imageSource),
                        hint: SLocalizations.of(context)!.imageSource,
                        // Disable the dropdown menu if an upload is in progress or if the field is not empty.
                        enabled: !_uploading && _imageUrlController.text.isBlank,
                      ),
                    ),
                    const SizedBox(
                      width: SStyles.listTileSpacing,
                    ),
                    Expanded(
                      child: FSelect.fromMap(
                        {
                          SLocalizations.of(context)!.light: false,
                          SLocalizations.of(context)!.dark: true,
                        },
                        onChange: _onSelectHeadlineColoring,
                        initialValue: _darkHeadlineColoring,
                        label: Text(
                          SLocalizations.of(context)!.headlineColoring,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        hint: SLocalizations.of(context)!.imageSource,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: SStyles.listTileSpacing,
                ),
                FormField<String>(
                  key: _imageFieldKey,
                  // Yeah, this ain't the prettiest solution, but it works without weird side effects.
                  validator: (_) => _onValidateRequired(_imageUrlController.text),
                  builder: (field) => FLabel(
                    axis: Axis.vertical,
                    label: Text(SLocalizations.of(context)!.image),
                    error: field.errorText != null ? Text(field.errorText!) : null,
                    states: {
                      if (field.errorText != null) WidgetState.error,
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: FTextField(
                            controller: _imageUrlController,
                            onChange: (_) => setState(() {}),
                            textInputAction: TextInputAction.done,
                            hint: SLocalizations.of(context)!.imageUrl,
                            enabled: _imageSource == _SImageSource.EXTERNAL,
                            clearable: (value) => value.text.isNotEmpty,
                          ),
                        ),

                        // If the file image source is selected, show a button to upload an image.
                        if (_imageSource == _SImageSource.FILE) ...[
                          const SizedBox(
                            width: SStyles.listTileSpacing,
                          ),
                          FButton.raw(
                            style: FButtonStyle.secondary,
                            onPress: _uploading
                                ? null
                                : _imageUrlController.text.isBlank
                                    ? _onUploadImage
                                    : _onRemoveImage,
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: _uploading
                                  ? LoadingIndicator(
                                      indicatorType: Indicator.ballPulseSync,
                                      colors: [
                                        FTheme.of(context).colors.secondaryForeground,
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          _imageUrlController.text.isBlank ? FIcons.upload : FIcons.x,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          _imageUrlController.text.isBlank
                                              ? SLocalizations.of(context)!.uploadImage
                                              : SLocalizations.of(context)!.removeImage,
                                          style: FTheme.of(context).typography.sm,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(
                height: SStyles.listTileSpacing,
              ),
              FTextField(
                controller: _hyperlinkController,
                label: Text(SLocalizations.of(context)!.hyperlink),
                hint: SLocalizations.of(context)!.hyperlinkOptional,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
