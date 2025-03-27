import 'package:forui/forui.dart';

/// An [FTile] that contains a [FCheckbox] and can be tapped to toggle the checkbox.
class SCheckboxTile extends FTile {
  /// The callback that is called when the checkbox is toggled.
  final void Function(bool) onChanged;

  /// The value of the checkbox.
  final bool value;

  /// Create a new [SCheckboxTile].
  SCheckboxTile({
    required super.title,
    required this.onChanged,
    required this.value,
    super.prefixIcon,
    super.key,
  })
  // Add the checkbox as a suffix icon and make the tile tappable.
  : super(
          onPress: () => onChanged(!value),
          suffixIcon: FCheckbox(
            onChange: onChanged,
            value: value,
          ),
        );
}
