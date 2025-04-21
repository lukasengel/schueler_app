import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A port of Material's [DropdownMenu] widget to Forui.
class SDropdownMenu<T> extends StatefulWidget {
  /// The label to display above the dropdown menu.
  final Widget? label;

  /// The hint text to display when no value is selected.
  final String? hint;

  /// The entries of the dropdown menu.
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  /// Callback when a value is selected.
  final void Function(T?) onSelected;

  /// The initially selected value.
  final T? initialSelection;

  /// Whether the dropdown menu is enabled.
  final bool enabled;

  /// Create a new [SDropdownMenu].
  const SDropdownMenu({
    required this.dropdownMenuEntries,
    required this.onSelected,
    this.enabled = true,
    this.label,
    this.hint,
    this.initialSelection,
    super.key,
  });

  @override
  State<SDropdownMenu<T>> createState() => _SDropdownMenuState();
}

class _SDropdownMenuState<T> extends State<SDropdownMenu<T>> with SingleTickerProviderStateMixin {
  late TextEditingController _textController;
  late FPopoverController _popoverController;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _popoverController = FPopoverController(
      vsync: this,
    );
    _textController = TextEditingController(
      text: widget.dropdownMenuEntries.firstWhereOrNull((e) => e.value == widget.initialSelection)?.label,
    );
  }

  @override
  void dispose() {
    _popoverController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => FPopoverMenu(
        popoverController: _popoverController,
        style: FTheme.of(context).popoverMenuStyle.copyWith(
              maxWidth: constraints.maxWidth,
            ),
        childAnchor: Alignment.bottomLeft,
        menuAnchor: Alignment.topLeft,
        menu: [
          FTileGroup(
            children: widget.dropdownMenuEntries.map((e) {
              return FTile(
                title: Text(e.label),
                prefixIcon: e.leadingIcon,
                suffixIcon: e.trailingIcon,
                enabled: e.enabled,
                onPress: () {
                  _popoverController.hide();
                  _textController.text = e.label;
                  widget.onSelected(e.value);
                },
              );
            }).toList(),
          ),
        ],
        child: FTextField(
          readOnly: true,
          focusNode: _focusNode,
          controller: _textController,
          label: widget.label,
          hint: widget.hint,
          enabled: widget.enabled,
          onTap: _popoverController.show,
          keyboardType: TextInputType.none,
          suffixBuilder: (context, style, child) {
            return Padding(
              padding: FTheme.of(context).textFieldStyle.clearButtonPadding,
              child: FButton.icon(
                onPress: () {
                  _popoverController.shown ? _focusNode.unfocus() : _focusNode.requestFocus();
                  _popoverController.toggle();
                },
                style: FTheme.of(context).textFieldStyle.clearButtonStyle,
                child: FIcon(FAssets.icons.chevronDown),
              ),
            );
          },
        ),
      ),
    );
  }
}
