import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The settings screen to manage filters for the substitution table.
class SFilterTableScreen extends StatefulWidget {
  /// Create a new [SFilterTableScreen].
  const SFilterTableScreen({super.key});

  @override
  State<SFilterTableScreen> createState() => _SFilterTableScreenState();
}

class _SFilterTableScreenState extends State<SFilterTableScreen> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: SHeaderWrapper(
        child: FHeader.nested(
          title: SHeaderTitleWrapper(
            child: Text(
              SAppLocalizations.of(context)!.filterTable,
            ),
          ),
          prefixActions: [
            FHeaderAction.back(
              onPress: Navigator.of(context).pop,
            ),
          ],
        ),
      ),
      content: Center(
        child: FIcon(
          FAssets.icons.construction,
        ),
      ),
    );
  }
}
