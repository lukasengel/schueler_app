import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../../controllers/local_data.dart';
import './../../../controllers/web_data.dart';

class FiltersPage extends StatelessWidget {
  static const route = "/settings/filters";
  FiltersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localData = Get.find<LocalData>();
    final webData = Get.find<WebData>();
    return Scaffold(
      appBar: AppBar(
        title: Text("filters".tr),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "choose_grade".tr,
                style: Get.textTheme.caption,
              ),
            ),
            SettingsFilters(
              onChanged: (filters) async {
                localData.settings.filters = filters;
                await localData.writeSettings();
                await webData.fetchData();
              },
              filters: localData.settings.filters,
            )
          ],
        ),
      ),
    );
  }
}

class SettingsFilters extends StatefulWidget {
  final List<String> filters;
  final Future<void> Function(List<String>) onChanged;

  SettingsFilters({required this.onChanged, required this.filters, Key? key})
      : super(key: key);

  @override
  State<SettingsFilters> createState() => _SettingsFiltersState();
}

class _SettingsFiltersState extends State<SettingsFilters> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.theme.cardColor,
      ),
      child: Column(
        children: List.generate(8, (index) {
          final grade = (index + 5).toString();
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$grade. Klasse"),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Switch.adaptive(
                      value: !widget.filters.contains(grade),
                      onChanged: (val) async {
                        setState(() {});
                        if (widget.filters.contains(grade)) {
                          widget.filters.remove(grade);
                        } else {
                          widget.filters.add(grade);
                        }
                        await widget.onChanged(widget.filters);
                        setState(() {});
                      },
                      activeColor: Get.theme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (index != 7)
                const Divider(
                  indent: 18,
                  color: Colors.grey,
                ),
            ],
          );
        }),
      ),
    );
  }
}
