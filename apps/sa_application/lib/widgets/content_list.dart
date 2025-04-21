import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';
import 'package:sa_application/util/_util.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// A generic widget that takes a list of items and displays them in a list using the provided [tileBuilder].
///
/// If the list is empty, it displays a view built by the [emptyBuilder].
/// If the list is null, it shows an icon and a message indicating that the data could not be loaded.
///
/// Attention: Returns a sliver, not a box widget.
class SContentList<T> extends StatelessWidget {
  /// The list of items to be displayed.
  final List<T>? items;

  /// A builder function that creates a widget for each item in the list.
  final ValueWidgetBuilder<T> tileBuilder;

  /// A builder function that creates a widget to be displayed when the list is empty.
  final WidgetBuilder emptyBuilder;

  /// Create a new [SContentList].
  const SContentList({
    required this.items,
    required this.tileBuilder,
    required this.emptyBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return items != null && items!.isNotEmpty
        // Show a tile for each school life item.
        ? SliverList.separated(
            itemCount: items!.length + 1,
            itemBuilder: (context, index) {
              // Show the number of elements at the end of the list.
              if (index == items!.length) {
                return Center(
                  child: Text(
                    SLocalizations.of(context)!.elements(items!.length),
                    style: STheme.smallCaptionStyle(context),
                  ),
                );
              }

              return tileBuilder(context, items![index], null);
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: SStyles.listTileSpacing,
            ),
          )
        // If there are no items to display, show an icon.
        : SliverFillRemaining(
            child: items == null
                // If the list is null, it means that the data could not be loaded.
                ? SIconPlaceholder(
                    message: SLocalizations.of(context)!.noData,
                    iconSvg: FAssets.icons.ban,
                  )
                // If the list is empty, it means that there are items available in the database.
                : emptyBuilder(context),
          );
  }
}
