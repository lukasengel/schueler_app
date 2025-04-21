import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/util/_util.dart';

/// A customized [FScaffold] with some small improvements:
/// - The top padding is removed. Required for [Scrollable]s on mobile platforms.
/// - Provides factory constructors to elegantly achieve a centered and width-constrained content, optionally with a [CupertinoScrollbar].
class SScaffold extends StatelessWidget {
  /// The header of the scaffold.
  final Widget? header;

  /// The footer of the scaffold.
  final Widget? footer;

  /// The content of the scaffold.
  final Widget content;

  /// Whether to apply padding to the content.
  final bool contentPad;

  /// Create a new [SScaffold].
  const SScaffold({
    required this.content,
    this.header,
    this.footer,
    this.contentPad = true,
    super.key,
  });

  /// Create a new [SScaffold] with a width-constrained and centered content.
  factory SScaffold.constrained({
    required Widget content,
    Widget? header,
    Widget? footer,
    double maxWidth = SStyles.maxContentWidth,
    bool contentPad = true,
  }) {
    return SScaffold(
      header: header,
      footer: footer,
      contentPad: contentPad,
      content: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: content,
        ),
      ),
    );
  }

  /// Create a new [SScaffold] with a width-constrained and centered content and a [CupertinoScrollbar].
  factory SScaffold.scrollable({
    required Widget content,
    required ScrollController controller,
    Widget? header,
    Widget? footer,
    double maxWidth = SStyles.maxContentWidth,
    bool contentPad = true,
  }) {
    return SScaffold(
      header: header,
      footer: footer,
      contentPad: false,
      content: CupertinoScrollbar(
        controller: controller,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            // Wrap with builder to get the correct context for padding.
            child: Builder(
              builder: (context) => Padding(
                padding: contentPad ? FTheme.of(context).scaffoldStyle.contentPadding : EdgeInsets.zero,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with GestureDetector to unfocus the keyboard when tapping outside of a text field.
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: FScaffold(
        header: header,
        // Remove top padding, to prevent weird behavior of Scrollables on mobile platforms.
        content: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: content,
        ),
        footer: footer,
        contentPad: contentPad,
      ),
    );
  }
}
