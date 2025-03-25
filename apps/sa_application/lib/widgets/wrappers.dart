import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/util/_util.dart';

/// Wrapper for [FHeader] widgets to give them a border at the bottom.
class SHeaderWrapper extends StatelessWidget {
  /// The widget to wrap.
  final FHeader child;

  /// Create a new [SHeaderWrapper].
  const SHeaderWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FTheme.of(context).colorScheme.border,
          ),
        ),
      ),
      child: child,
    );
  }
}

/// Wrapper for the title of a [FHeader], so it does not overlap with the prefix and suffix actions.
class SHeaderTitleWrapper extends StatelessWidget {
  /// The widget to wrap.
  final Widget child;

  /// Create a new [SHeaderTitleWrapper].
  const SHeaderTitleWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 36,
      ),
      child: child,
    );
  }
}

/// Wrapper for the content of a screen to center it and give it a maximum width.
class SContentWrapper extends StatelessWidget {
  /// The widget to wrap.
  final Widget child;

  /// The maximum width the contant may expand to.
  final double maxWidth;

  /// Create a new [SContentWrapper].
  const SContentWrapper({
    required this.child,
    super.key,
    this.maxWidth = sDefaultMaxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: child,
      ),
    );
  }
}
