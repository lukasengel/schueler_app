import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';

/// Wrapper for the content of a screen to make it refreshable using an [EasyRefresh] widget.
class SRefreshableContentWrapper extends StatefulWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// The controller for the [EasyRefresh] widget.
  final EasyRefreshController? controller;

  /// Child to be wrapped. Must be a sliver.
  final Widget sliver;

  /// Create a new [SRefreshableContentWrapper].
  const SRefreshableContentWrapper({
    required this.onRefresh,
    required this.sliver,
    this.controller,
    super.key,
  });

  @override
  State<SRefreshableContentWrapper> createState() => _SRefreshableContentWrapperState();
}

class _SRefreshableContentWrapperState extends State<SRefreshableContentWrapper> {
  var _hasDispatchedHapticFeedback = false;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: widget.onRefresh,
      controller: widget.controller,
      header: ClassicHeader(
        dragText: SLocalizations.of(context)!.pullToRefresh,
        armedText: SLocalizations.of(context)!.releaseToRefresh,
        readyText: SLocalizations.of(context)!.refreshing,
        processingText: SLocalizations.of(context)!.refreshing,
        processedText: SLocalizations.of(context)!.refreshSuceeded,
        failedText: SLocalizations.of(context)!.refreshFailed,
        showMessage: false,
        textBuilder: (context, state, text) {
          // When the refresh started, dispatch haptic feedback.
          if (state.mode == IndicatorMode.ready && !_hasDispatchedHapticFeedback) {
            HapticFeedback.lightImpact();
            _hasDispatchedHapticFeedback = true;
          }

          // When the refresh is done, reset flag.
          else if (state.mode == IndicatorMode.done) {
            _hasDispatchedHapticFeedback = false;
          }

          return Text(text);
        },
      ),
      child: CustomScrollView(
        cacheExtent: 10000,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: SStyles.listTileSpacing,
            ),
            sliver: widget.sliver,
          ),
        ],
      ),
    );
  }
}
