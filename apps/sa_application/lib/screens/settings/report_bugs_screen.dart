import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The settings screen for reporting bugs or providing feedback.
class SReportBugsScreen extends StatefulWidget {
  /// Create a new [SReportBugsScreen].
  const SReportBugsScreen({super.key});

  @override
  State<SReportBugsScreen> createState() => _SReportBugsScreenState();
}

class _SReportBugsScreenState extends State<SReportBugsScreen> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: SHeaderWrapper(
        child: FHeader.nested(
          title: Text(
            SAppLocalizations.of(context)!.reportBugs,
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
