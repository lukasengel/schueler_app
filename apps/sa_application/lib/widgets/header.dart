import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// A customized [FHeader] with some small improvements:
/// - The header has a bottom border.
/// - The title is padded to prevent overlap with the prefix and suffix actions.
class SHeader extends StatelessWidget {
  /// The title of the header.
  final Widget title;

  /// The prefix actions of the header.
  final List<Widget>? prefixes;

  /// The suffix actions of the header.
  final List<Widget>? suffixes;

  /// Create a new [SHeader].
  const SHeader({
    required this.title,
    this.prefixes,
    this.suffixes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      // Give the header the same border as the FBottomNavigationBar.
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FTheme.of(context).colors.border,
          ),
        ),
      ),
      child: FHeader.nested(
        /// Wrap the title in a padding, so it does not overlap with the prefix and suffix actions.
        title: Padding(
          padding: const EdgeInsets.symmetric(
            // Width of a single prefix and suffix action.
            horizontal: 36,
          ),
          child: title,
        ),
        prefixes: prefixes ?? [],
        suffixes: suffixes ?? [],
      ),
    );
  }
}
