import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// A simplified replica of Forui's [FButton] widget that does not expand to fill the available width.
class SButton extends StatelessWidget {
  /// The label of the button.
  final Widget label;

  /// The prefix icon of the button.
  final Widget? prefix;

  /// The callback to be called when the button is pressed.
  final VoidCallback onPressed;

  /// The style of the button.
  final FBaseButtonStyle style;

  /// Create a new [SButton].
  const SButton({
    required this.label,
    required this.onPressed,
    this.prefix,
    this.style = FButtonStyle.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Map FBaseButtonStyle to an FButtonStyle based on the current theme.
    final style = switch (this.style) {
      FButtonStyle.primary => context.theme.buttonStyles.primary,
      FButtonStyle.secondary => context.theme.buttonStyles.secondary,
      FButtonStyle.destructive => context.theme.buttonStyles.destructive,
      FButtonStyle.outline => context.theme.buttonStyles.outline,
      FButtonStyle.ghost => context.theme.buttonStyles.ghost,
      final FButtonStyle style => style,
    };

    return FButtonData(
      style: style,
      child: FButton.raw(
        onPress: onPressed,
        style: style,
        child: Padding(
          padding: style.contentStyle.padding,
          child: DefaultTextStyle.merge(
            style: style.contentStyle.enabledTextStyle,
            child: FIconStyleData(
              style: FIconStyle(
                color: style.contentStyle.enabledIconColor,
                size: style.contentStyle.iconSize,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  if (prefix != null) prefix!,
                  label,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
