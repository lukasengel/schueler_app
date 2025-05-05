import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';
import 'package:sa_common/sa_common.dart';
import 'package:sa_providers/sa_providers.dart';

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
    setState(() => _searchQuery = inputQuery?.trimOrNull());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teachers = ref.watch(sTeachersProvider);

    // Filter the teachers based on the search query.
    final filtered = teachers?.where((element) {
      // If the search query is null or blank, show all teachers.
      return _searchQuery.hasNoContent ||
          // Check whether the teacher's abbreviation or name contains the search query.
          element.abbreviation.containsIgnoreCase(_searchQuery!) ||
          element.name.containsIgnoreCase(_searchQuery!);
    }).toList();

    return SScaffold.scrollable(
      controller: _scrollController,
      header: SSearchHeader(
        title: Text(
          SLocalizations.of(context)!.teacherAbbreviations,
        ),
        prefixes: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
        suffixesBuilder: (context, searchActionButton) => [
          // Only show the search action button if there are teachers.
          if (teachers != null && teachers.isNotEmpty) searchActionButton,
        ],
        onSearch: _onSearch,
      ),
      content: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: SStyles.listViewPadding,
            sliver: STileList(
              items: filtered,
              tileBuilder: (context, item, _) => FTile(
                subtitle: Text(item.name),
                title: Text(item.abbreviation),
              ),
              emptyBuilder: (context) => teachers!.isNotEmpty
                  // If the filtered list is empty but the original list is not, it means that the search query did not match any teachers.
                  ? SIconPlaceholder.icon(
                      message: SLocalizations.of(context)!.noResults,
                      icon: FIcons.searchX,
                    )
                  // If the original list is empty, it means that there are no teachers available.
                  : SIconPlaceholder.svg(
                      context: context,
                      message: SLocalizations.of(context)!.noTeachers,
                      svgAsset: 'assets/images/lucky_cat.svg',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
