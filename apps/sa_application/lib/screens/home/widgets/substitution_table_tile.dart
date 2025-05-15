import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/date_time_extension.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_data/sa_data.dart';
import 'package:sa_providers/sa_providers.dart';

/// Tile to display the substitution table for one day.
class SSubstitutionTableTile extends ConsumerWidget {
  /// The table to display.
  final SSubstitutionTable table;

  /// The time of the latest update.
  final DateTime latestUpdate;

  /// The time of the latest fetch.
  final DateTime latestFetch;

  /// Callback for looking up a teacher abbreviation.
  final void Function(String) onLookupTeacher;

  /// Create a new [SSubstitutionTableTile].
  const SSubstitutionTableTile({
    required this.table,
    required this.latestUpdate,
    required this.latestFetch,
    required this.onLookupTeacher,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exclusionOptions = ref.watch(sGlobalSettingsProvider.select((gs) => gs?.exclusionOptions));
    final excludedCourses = ref.watch(sLocalSettingsProvider.select((ls) => ls.excludedCourses));
    final groupedRows = table.rows.groupListsBy((row) => row.group);

    // Remove all groups that have been excluded.
    if (exclusionOptions != null && exclusionOptions.isNotEmpty) {
      groupedRows.removeWhere(
        (group, rows) => excludedCourses.any((course) {
          // Get the exclusion option for the excluded course.
          final exclusionOption = exclusionOptions.firstWhereOrNull((option) => option.id == course);

          // If an exclusion option is found for the course, check if the group matches its regex.
          return exclusionOption != null && RegExp(exclusionOption.regex).hasMatch(group);
        }),
      );
    }

    // If there are no rows left, show a placeholder.
    if (groupedRows.isEmpty) {
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDate(
              context,
              table.date,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: SSvgPlaceholder(
                message: SLocalizations.of(context)!.noSubstitutions,
                svgAsset: 'assets/images/lucky_cat.svg',
              ),
            ),
            _buildTimestamp(
              context,
              latestUpdate,
              latestFetch,
              ref.watch(
                sLocalSettingsProvider.select((ls) => ls.developerMode),
              ),
            ),
          ],
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: FTheme.of(context).style.borderRadius,
              border: Border.all(
                color: FTheme.of(context).colors.border,
                width: FTheme.of(context).style.borderWidth,
              ),
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: FTheme.of(context).style.borderRadius,
              ),
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDate(
                    context,
                    table.date,
                  ),
                  const Divider(
                    height: 20,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _buildHeaderRow(
                    context,
                    const SSubstitutionTableRow(
                      course: 'Kl.',
                      period: 'Std.',
                      absent: 'Abw.',
                      substitute: 'Ver.',
                      room: 'Raum',
                      info: 'Info',
                      group: 'Kl.',
                    ),
                  ),
                  ...groupedRows.entries.mapIndexed(
                    (index, rows) => _buildGroup(
                      context,
                      rows.value,
                      index.isEven,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: _buildTimestamp(
              context,
              latestUpdate,
              latestFetch,
              ref.watch(
                sLocalSettingsProvider.select((ls) => ls.developerMode),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build the date text.
  Widget _buildDate(BuildContext context, DateTime datetime) {
    return Text(
      table.date.formatDateLocalized(context),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    );
  }

  /// Helper method to build the timestamp text.
  Widget _buildTimestamp(BuildContext context, DateTime latestUpdate, DateTime latestFetch, bool showFetch) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          SLocalizations.of(context)!.latestUpdate(
            latestUpdate.formatDateTimeLocalized(context),
          ),
          style: _regularStyle(context),
        ),
        if (showFetch)
          Text(
            SLocalizations.of(context)!.latestFetch(
              latestFetch.formatDateTimeLocalized(context),
            ),
            style: _regularStyle(context),
          ),
      ],
    );
  }

  /// Helper method to build a group of substitution table rows.
  Widget _buildGroup(BuildContext context, List<SSubstitutionTableRow> rows, bool even) {
    return ColoredBox(
      color: even ? FTheme.of(context).colors.background : FTheme.of(context).colors.secondary.withValues(alpha: 0.7),
      child: Column(
        children: rows.map((row) => _buildRow(context, row)).toList(),
      ),
    );
  }

  /// Helper method to build a substitution table header row.
  Widget _buildHeaderRow(BuildContext context, SSubstitutionTableRow row) {
    return _buildRawRow(
      minHeight: 24,
      course: Text(
        row.course,
        style: _boldStyle(context),
      ),
      period: Text(
        row.period,
        style: _boldStyle(context),
      ),
      absent: Text(
        row.absent,
        style: _boldStyle(context),
      ),
      substitute: Text(
        row.substitute,
        style: _boldStyle(context),
      ),
      room: Text(
        row.room,
        style: _boldStyle(context),
      ),
      info: Text(
        row.info,
        style: _boldStyle(context),
      ),
    );
  }

  /// Helper method to build a substitution table row.
  Widget _buildRow(BuildContext context, SSubstitutionTableRow row) {
    return _buildRawRow(
      minHeight: 45,
      course: Text(
        // Sometime, there are multiple course names in the same cell. If so, add a line break inbetween.
        row.course.replaceAll(' ', '\n'),
        style: _boldStyle(context),
      ),
      period: Text(
        row.period,
        style: _regularStyle(context),
      ),
      absent: FTappable(
        onPress: () => onLookupTeacher(row.absent),
        child: Text(
          row.absent,
          style: _regularStyle(context),
        ),
      ),
      substitute: FTappable(
        onPress: () => onLookupTeacher(row.substitute),
        child: Text(
          // If there is info in parantheses after the substitute, add a line break inbetween.
          RegExp(r'^[^-].*\([^)]+\)|\([^)]+\)$').hasMatch(row.substitute)
              ? row.substitute.replaceAll(RegExp(r'\s\('), '\n(')
              : row.substitute,
          style: _regularStyle(context),
        ),
      ),
      room: Text(
        row.room,
        style: _regularStyle(context),
      ),
      info: Text(
        row.info,
        style: _regularStyle(context),
      ),
    );
  }

  /// Helper method to build a raw substitution table row.
  Widget _buildRawRow({
    required double minHeight,
    required Widget course,
    required Widget period,
    required Widget absent,
    required Widget substitute,
    required Widget room,
    required Widget info,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 5,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: course,
          ),
          Expanded(
            flex: 5,
            child: period,
          ),
          Expanded(
            flex: 8,
            child: absent,
          ),
          Expanded(
            flex: 8,
            child: substitute,
          ),
          Expanded(
            flex: 7,
            child: room,
          ),
          Expanded(
            flex: 15,
            child: info,
          ),
        ],
      ),
    );
  }

  /// Bold text style for substitution table header and course column content.
  TextStyle _boldStyle(BuildContext context) {
    return FTheme.of(context).typography.sm.copyWith(fontWeight: FontWeight.w600);
  }

  /// Regular text style for substitution table content.
  TextStyle _regularStyle(BuildContext context) {
    return FTheme.of(context).typography.sm.copyWith(fontWeight: FontWeight.w400);
  }
}
