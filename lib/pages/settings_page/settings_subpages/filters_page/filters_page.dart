import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './filter_widgets.dart';

import '../../../../widgets/settings_ui/settings_text.dart';

class FiltersPage extends StatelessWidget {
  static const route = "/settings/filters";
  const FiltersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings/filters".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 60),
          children: [
            SettingsText(text: "settings/filters/grade".tr),
            const GradeFilterSettings(),
            SettingsText(text: "settings/filters/misc".tr),
            const MiscFilterSettings(),
          ],
        ),
      ),
    );
  }
}
