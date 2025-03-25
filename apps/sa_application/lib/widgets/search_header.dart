import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';

/// A widget that provides the option to smoothly switch between a normal [FHeader] and a header with a search bar.
class SSearchHeader extends StatefulWidget {
  /// Builder for the normal header.
  final FHeader Function(BuildContext, FHeaderAction) buildHeader;

  /// Callback for whenever the user types in the search field.
  final void Function(String?) onSearch;

  /// Create a new [SSearchHeader].
  const SSearchHeader({
    required this.buildHeader,
    required this.onSearch,
    super.key,
  });

  @override
  State<SSearchHeader> createState() => _SSearchHeaderState();
}

class _SSearchHeaderState extends State<SSearchHeader> {
  final _focusNode = FocusNode();
  var _showSearch = false;

  /// Callback for showing or hiding the search bar.
  void _toggleSearchBar(bool value) {
    setState(() {
      _showSearch = value;
      value ? _focusNode.requestFocus() : widget.onSearch(null);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FTheme.of(context).colorScheme.border,
          ),
        ),
      ),
      // This height has been determined using the widget inspector.
      // The height needs to be set here for the animation to work.
      height: (_showSearch ? 73 : 57) + safePadding.top,
      child: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 200,
        ),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _showSearch ? buildSearchHeader(context, safePadding) : buildNormalHeader(context),
      ),
    );
  }

  /// Builder for the normal header.
  Widget buildNormalHeader(BuildContext context) {
    return Padding(
      key: const ValueKey('normal'),
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: widget.buildHeader(
        context,
        FHeaderAction(
          icon: FIcon(FAssets.icons.search),
          onPress: () => _toggleSearchBar(true),
        ),
      ),
    );
  }

  /// Builder for the search header.
  Widget buildSearchHeader(BuildContext context, EdgeInsets safePadding) {
    return Padding(
      key: const ValueKey('search'),
      padding: EdgeInsets.fromLTRB(
        safePadding.left + 12,
        safePadding.top,
        safePadding.right + 12,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: FTextField(
              hint: SAppLocalizations.of(context)!.search,
              clearable: (value) => value.text.isNotEmpty,
              onChange: widget.onSearch,
              focusNode: _focusNode,
              maxLines: 1,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          FButton(
            onPress: () => _toggleSearchBar(false),
            label: Text(SAppLocalizations.of(context)!.cancel),
            style: FButtonStyle.secondary,
          ),
        ],
      ),
    );
  }
}
