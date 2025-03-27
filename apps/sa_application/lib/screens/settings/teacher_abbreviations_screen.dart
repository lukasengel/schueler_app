import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/providers/_providers.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_common/sa_common.dart';

/// The settings screen for viewing teacher abbreviations.
class STeacherAbbreviationsScreen extends ConsumerStatefulWidget {
  /// Create a new [STeacherAbbreviationsScreen].
  const STeacherAbbreviationsScreen({super.key});

  @override
  ConsumerState<STeacherAbbreviationsScreen> createState() => _STeacherAbbreviationsScreenState();
}

class _STeacherAbbreviationsScreenState extends ConsumerState<STeacherAbbreviationsScreen> {
  final _scrollController = ScrollController();
  String? _searchQuery;

  /// Callback for when the user types in the search field.
  void _onSearch(String? inputQuery) {
    setState(() {
      _searchQuery = inputQuery;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teachers = ref.watch(sTeachersProvider);
    final hasData = teachers != null;

    // Filter the teachers based on the search query.
    final filtered = teachers?.where((element) {
      // If the search query is null or blank, show all teachers.
      return _searchQuery.hasNoContent ||
          // Check whether the teacher's abbreviation or name contains the search query.
          element.abbreviation.containsIgnoreCase(_searchQuery!) ||
          element.name.containsIgnoreCase(_searchQuery!);
    }).toList();

    return FScaffold(
      header: SSearchHeader(
        buildHeader: (context, searchButton) => FHeader.nested(
          prefixActions: [
            FHeaderAction.back(
              onPress: Navigator.of(context).pop,
            ),
          ],
          title: SHeaderTitleWrapper(
            child: Text(
              SAppLocalizations.of(context)!.teacherAbbreviations,
            ),
          ),
          suffixActions: [
            // Only show the search button if there are teachers to search.
            if (teachers != null && teachers.isNotEmpty) searchButton,
          ],
        ),
        onSearch: _onSearch,
      ),
      content: SContentWrapper(
        child: filtered != null && filtered.isNotEmpty
            // Show a tile for each teacher.
            ? Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: sDefaultListViewPadding,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final teacher = filtered[index];

                    return FTile(
                      subtitle: Text(teacher.name),
                      title: Text(teacher.abbreviation),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: sDefaultListTileSpacing,
                  ),
                ),
              )
            // If there are no teachers to display, show an icon.
            : SNoDataPlaceholder(
                message: hasData ? SAppLocalizations.of(context)!.noResults : SAppLocalizations.of(context)!.noData,
                iconSvg: hasData ? FAssets.icons.searchX : FAssets.icons.triangleAlert,
              ),
      ),
    );
  }
}
