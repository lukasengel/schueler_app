import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sa_application/l10n/app_localizations.dart';
import 'package:sa_application/widgets/_widgets.dart';

/// The settings screen for viewing teacher abbreviations.
class STeacherAbbreviationsScreen extends StatefulWidget {
  /// Create a new [STeacherAbbreviationsScreen].
  const STeacherAbbreviationsScreen({super.key});

  @override
  State<STeacherAbbreviationsScreen> createState() => _STeacherAbbreviationsScreenState();
}

class _STeacherAbbreviationsScreenState extends State<STeacherAbbreviationsScreen> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: SHeaderWrapper(
        child: FHeader.nested(
          title: Text(
            SAppLocalizations.of(context)!.teacherAbbreviations,
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
