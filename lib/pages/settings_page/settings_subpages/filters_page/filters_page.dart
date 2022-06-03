import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import './filter_widgets.dart';

import '../../../../controllers/local_data.dart';
import '../../../../controllers/web_data.dart';
import '../../../../widgets/settings_ui/settings_container.dart';
import '../../../../widgets/settings_ui/settings_text.dart';

class FiltersPage extends StatefulWidget {
  static const route = "/settings/filters";
  const FiltersPage({Key? key}) : super(key: key);

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final localData = Get.find<LocalData>();

  String get enumeration {
    if (Get.locale == const Locale("en", "US")) {
      return "th ";
    }
    return ". ";
  }

  void toggleAll(bool enabled) async {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    await localData.setAllFilters(enabled);
    Get.find<WebData>().update();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings/filters".tr),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 150),
          children: [
            SettingsText(text: "settings/filters/grade".tr),
            SettingsContainer(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Column(
                children: List.generate(8, (index) {
                  final grade = (index + 5).toString();
                  return Column(
                    children: [
                      FilterSwitch(
                        filterKey: grade,
                        label:
                            grade + enumeration + "settings/filters/grade".tr,
                      ),
                      if (index != 7) filterDivider,
                    ],
                  );
                }),
              ),
            ),
            SettingsText(text: "settings/filters/misc".tr),
            SettingsContainer(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Column(
                children: [
                  FilterSwitch(
                      filterKey: "i", label: "settings/filters/inst".tr),
                  filterDivider,
                  FilterSwitch(
                      filterKey: "Wku", label: "settings/filters/wku".tr),
                  filterDivider,
                  FilterSwitch(
                      filterKey: "Fku", label: "settings/filters/fku".tr),
                  filterDivider,
                  FilterSwitch(
                      filterKey: "OGTS", label: "settings/filters/ogts".tr),
                  filterDivider,
                  FilterSwitch(
                      filterKey: "GGTS", label: "settings/filters/ggts".tr),
                  filterDivider,
                  FilterSwitch(
                      filterKey: "misc", label: "settings/filters/misc".tr),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 1,
            tooltip: "tooltips/disable_all".tr,
            onPressed: () => toggleAll(false),
            child: const Icon(Icons.clear_all),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 2,
            tooltip: "tooltips/enable_all".tr,
            onPressed: () => toggleAll(true),
            child: const Icon(Icons.done_all),
          ),
        ],
      ),
    );
  }
}
