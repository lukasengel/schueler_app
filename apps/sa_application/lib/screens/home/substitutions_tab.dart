import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:glossy/glossy.dart';
import 'package:go_router/go_router.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/screens/_screens.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_providers/sa_providers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toastification/toastification.dart';

/// The home screen tab for viewing the substitutions plan.
class SSubstitutionsTab extends ConsumerStatefulWidget {
  /// Callback for refreshing the content.
  final Future<IndicatorResult> Function() onRefresh;

  /// Create a new [SSubstitutionsTab].
  const SSubstitutionsTab({
    required this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<SSubstitutionsTab> createState() => _SSubstitutionsTabState();
}

class _SSubstitutionsTabState extends ConsumerState<SSubstitutionsTab> {
  final _pageController = PageController();

  /// Callback for looking up a teacher by abbreviation.
  Future<void> _onLookupTeacher(String substitute) async {
    final match = RegExp('[a-zäöüß]{3}').stringMatch(substitute);

    // Check if the string contains a valid teacher abbreviation.
    if (match != null) {
      final teacher = ref.read(sTeachersProvider)?.firstWhereOrNull((teacher) => match == teacher.abbreviation);

      // Show a toast with the teacher's name, if found.
      sShowToast(
        context: context,
        title: Text(
          teacher != null
              ? SLocalizations.of(context)!.teacher(teacher.name)
              : SLocalizations.of(context)!.unknownTeacher,
        ),
        type: teacher != null ? ToastificationType.info : ToastificationType.error,
        // Allow the user to view all teacher abbreviations.
        duration: const Duration(seconds: 3),
        description: FTappable(
          child: Text(SLocalizations.of(context)!.showAll),
          onPress: () {
            GoRouter.of(context).push('/settings/teacher-abbreviations');
            toastification.dismissAll();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // If the user has the auto next day enabled.
    if (ref.read(sLocalSettingsProvider).autoNextDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final now = DateTime.now();

        // If it is a weekday and after 5 PM, jump to the next day.
        if (now.weekday < 6 && now.hour >= 17) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final externalData = ref.watch(sExternalDataProvider);
    final shownDays = ref.watch(sLocalSettingsProvider.select((s) => s.shownDays));

    if (externalData != null && externalData.substitutionTables.isNotEmpty) {
      final pageCount = min(
        externalData.substitutionTables.length,
        shownDays,
      );

      return Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            itemBuilder: (context, index) {
              return SRefreshableWrapper(
                bottomPadding: 16,
                onRefresh: widget.onRefresh,
                sliver: SSubstitutionTableTile(
                  table: externalData.substitutionTables[index],
                  latestUpdate: externalData.latestUpdate,
                  latestFetch: externalData.latestFetch,
                  onLookupTeacher: _onLookupTeacher,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: GlossyContainer(
                height: 12,
                width: pageCount * 20 + (pageCount - 1) * 12 + 7,
                opacity: 0.05,
                border: const Border(),
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: SmoothPageIndicator(
                    count: pageCount,
                    controller: _pageController,
                    onDotClicked: _pageController.jumpToPage,
                    effect: ColorTransitionEffect(
                      spacing: 12,
                      dotWidth: 20,
                      dotHeight: 5,
                      radius: 4,
                      activeDotColor: FTheme.of(context).colors.primary,
                      dotColor: FTheme.of(context).colors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SRefreshableWrapper(
      onRefresh: widget.onRefresh,
      sliver: SliverFillRemaining(
        child: externalData == null
            // If the data is null, it means that the data could not be loaded.
            ? SIconPlaceholder(
                message: SLocalizations.of(context)!.noData,
                icon: FIcons.ban,
              )
            // If there are no substitution tables, show a message.
            // This should technically never occurr: Even if no substitions were available, there should still be SubstitutionTable objects with empty rows.
            : SSvgPlaceholder(
                message: SLocalizations.of(context)!.noSubstitutions,
                svgAsset: 'assets/images/lucky_cat.svg',
              ),
      ),
    );
  }
}
