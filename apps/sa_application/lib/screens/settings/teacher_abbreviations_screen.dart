import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
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
        prefixActions: [
          FHeaderAction.back(
            onPress: Navigator.of(context).pop,
          ),
        ],
        suffixActionsBuilder: (context, searchActionButton) => [
          // Only show the search action button if there are teachers.
          if (teachers != null && teachers.isNotEmpty) searchActionButton,
        ],
        onSearch: _onSearch,
      ),
      content: filtered != null && filtered.isNotEmpty
          // Show a tile for each teacher.
          ? ListView.separated(
              controller: _scrollController,
              padding: SStyles.defaultListViewPadding,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final teacher = filtered[index];

                return FTile(
                  subtitle: Text(teacher.name),
                  title: Text(teacher.abbreviation),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: SStyles.defaultListTileSpacing,
              ),
            )
          // If there are no teachers to display, show an icon.
          : teachers == null
              // If the list is null, it means that the data could not be loaded.
              ? SIconPlaceholder(
                  message: SLocalizations.of(context)!.noData,
                  iconSvg: FAssets.icons.ban,
                )
              : teachers.isNotEmpty
                  // If the filtered list is empty but the original list is not, it means that the search query did not match any teachers.
                  ? SIconPlaceholder(
                      message: SLocalizations.of(context)!.noResults,
                      iconSvg: FAssets.icons.searchX,
                    )
                  // If the original list is empty, it means that there are no teachers available.
                  : SIconPlaceholder(
                      message: SLocalizations.of(context)!.noTeachers,
                      iconSvg: const SvgAsset(null, 'icon_black', 'assets/images/lucky_cat.svg'),
                    ),
    );
  }
}
