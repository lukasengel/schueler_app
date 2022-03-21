import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../controllers/local_data.dart';
import '../../../../controllers/web_data.dart';
import '../../../../widgets/settings_ui/settings_container.dart';

class GradeFilterSettings extends StatefulWidget {
  const GradeFilterSettings({
    Key? key,
  }) : super(key: key);

  @override
  State<GradeFilterSettings> createState() => _GradeFilterSettingsState();
}

class _GradeFilterSettingsState extends State<GradeFilterSettings> {
  String get enumeration {
    if (Get.locale == const Locale("en", "US")) {
      return "th ";
    }
    return ". ";
  }

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        children: List.generate(8, (index) {
          final grade = (index + 5).toString();
          return Column(
            children: [
              FilterSwitch(
                filterKey: grade,
                label: grade + enumeration + "settings/filters/grade".tr,
              ),
              if (index != 7) _divider,
            ],
          );
        }),
      ),
    );
  }
}

class MiscFilterSettings extends StatefulWidget {
  const MiscFilterSettings({
    Key? key,
  }) : super(key: key);

  @override
  State<MiscFilterSettings> createState() => _MiscFilterSettingsState();
}

class _MiscFilterSettingsState extends State<MiscFilterSettings> {
  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        children: [
          FilterSwitch(filterKey: "i", label: "settings/filters/inst".tr),
          _divider,
          FilterSwitch(filterKey: "Wku", label: "settings/filters/wku".tr),
          _divider,
          FilterSwitch(filterKey: "Fku", label: "settings/filters/fku".tr),
          _divider,
          FilterSwitch(filterKey: "OGTS", label: "settings/filters/ogts".tr),
          _divider,
          FilterSwitch(filterKey: "GGTS", label: "settings/filters/ggts".tr),
          _divider,
          FilterSwitch(filterKey: "misc", label: "settings/filters/misc".tr),
        ],
      ),
    );
  }
}

class FilterSwitch extends StatefulWidget {
  final String label;
  final String filterKey;
  const FilterSwitch({required this.filterKey, required this.label, Key? key})
      : super(key: key);

  @override
  _FilterSwitchState createState() => _FilterSwitchState();
}

class _FilterSwitchState extends State<FilterSwitch> {
  @override
  Widget build(BuildContext context) {
    final localData = Get.find<LocalData>();

    void toggle() async {
      setState(() {});
      await localData.toggleFilter(widget.filterKey);
      Get.find<WebData>().update();
      setState(() {});
    }

    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 25),
      onPressed: () {
        if (Platform.isIOS) {
          HapticFeedback.lightImpact();
        }
        toggle();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Switch.adaptive(
              value: localData.settings.filters[widget.filterKey]!,
              onChanged: (_) => toggle(),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

final _divider = Divider(
  height: 3,
  indent: 25,
  color: Get.theme.colorScheme.onTertiary,
);
