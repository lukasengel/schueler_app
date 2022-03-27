import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../controllers/local_data.dart';
import '../../../../controllers/web_data.dart';

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

final filterDivider = Divider(
  height: 3,
  indent: 25,
  color: Get.theme.colorScheme.onTertiary,
);
