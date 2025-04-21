import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/l10n.dart';

/// An [FTile] that, when pressed, shows a popover menu with options to edit or delete the item.
class SManagementTile extends StatefulWidget {
  /// The title of the tile.
  final Widget title;

  /// The subtitle of the tile.
  final Widget subtitle;

  /// The callback for when the edit menu item is pressed.
  final Future<void> Function()? onEdit;

  /// The callback for when the delete menu item is pressed.
  final Future<void> Function()? onDelete;

  /// Create a new [SManagementTile].
  const SManagementTile({
    required this.title,
    required this.subtitle,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  State<SManagementTile> createState() => _SSManagementTileState();
}

class _SSManagementTileState extends State<SManagementTile> with SingleTickerProviderStateMixin {
  late FPopoverController _popoverController;

  @override
  void initState() {
    super.initState();
    _popoverController = FPopoverController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FPopoverMenu.automatic(
      popoverController: _popoverController,
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      menu: [
        FTileGroup(
          children: [
            if (widget.onEdit != null)
              FTile(
                prefixIcon: FIcon(FAssets.icons.pen),
                title: Text(SLocalizations.of(context)!.edit),
                onPress: () {
                  _popoverController.hide();
                  widget.onEdit!();
                },
              ),
            if (widget.onDelete != null)
              FTile(
                prefixIcon: FIcon(FAssets.icons.trash2),
                title: Text(SLocalizations.of(context)!.delete),
                onPress: () {
                  _popoverController.hide();
                  widget.onDelete!();
                },
              ),
          ],
        ),
      ],
      child: FTile(
        title: widget.title,
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: widget.subtitle,
            ),
            FIcon(
              FAssets.icons.ellipsis,
              size: 13,
            ),
          ],
        ),
        onPress: _popoverController.toggle,
      ),
    );
  }
}
