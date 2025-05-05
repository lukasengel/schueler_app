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

  /// The floating action button of the scaffold.
  final Widget? floatingActionButton;

  /// The content of the scaffold.
  final Widget content;

  /// Create a new [SScaffold].
  const SScaffold({
    required this.content,
    this.header,
    this.footer,
    this.floatingActionButton,
    super.key,
  });

  /// Create a new [SScaffold] with a width-constrained and centered content.
  factory SScaffold.constrained({
    required Widget content,
    Widget? header,
    Widget? footer,
    Widget? floatingActionButton,
    double maxWidth = SStyles.maxContentWidth,
  }) {
    return SScaffold(
      header: header,
      footer: footer,
      floatingActionButton: floatingActionButton,
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
    Widget? floatingActionButton,
    double maxWidth = SStyles.maxContentWidth,
  }) {
    return SScaffold(
      header: header,
      footer: footer,
      floatingActionButton: floatingActionButton,
      content: CupertinoScrollbar(
        controller: controller,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: content,
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
        footer: footer,
        childPad: false,
        // Remove top padding, to prevent weird behavior of Scrollables on mobile platforms.
        child: Stack(
          children: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: content,
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.all(8),
              child: floatingActionButton,
            ),
          ],
        ),
      ),
    );
  }
}
