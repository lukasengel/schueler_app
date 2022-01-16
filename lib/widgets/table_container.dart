import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/local_data.dart';
import '../models/substitution_table.dart';

class TableContainer extends StatelessWidget {
  final String latestUpdate;
  final SubstitutionTable item;
  const TableContainer(
      {required this.item, required this.latestUpdate, Key? key})
      : super(key: key);

//########################################################################
//#                    Sorting Logic / Builders                          #
//########################################################################

  List<List<int>> groupSubstitutions(SubstitutionTable table) {
    List<List<int>> groups = [];
    int group = 0;
    for (int i = 0; i < table.rows.length; i++) {
      final course = table.rows[i].course;
      if (course == String.fromCharCode(160) && groups.isNotEmpty) {
        groups[group].add(i);
      } else {
        groups.add([i]);
        group = groups.length - 1;
      }
    }
    return groups;
  }

  bool showGroup(String groupTitle) {
    final settings = Get.find<LocalData>().settings;
    bool show = true;
    bool match = false;
    for (var element in settings.filters.keys) {
      if (groupTitle.startsWith(element)) {
        match = true;
        show = settings.filters[element]!;
        break;
      }
    }
    return match ? show : settings.filters["misc"];
  }

  TableRow get getHeaderRow {
    final headerRow = ["Kl.", "Std.", "Abw.", "Ver.", "Raum", "Info"];
    return TableRow(
      children: headerRow.map((content) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Text(
            content,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = groupSubstitutions(item);

    int indexOfLastVisibleGroup() {
      int index = 0;
      for (int i = 0; i < groups.length; i++) {
        if (showGroup(item.rows[groups[i][0]].course)) {
          index = i;
        }
      }
      return index;
    }

    List<TableRow> getRows() {
      final lastVisibleGroup = indexOfLastVisibleGroup();
      List<TableRow> groupRows = [];
      bool even = false;
      for (var group in groups) {
        bool show = showGroup(item.rows[group[0]].course);
        if (show) {
          even = !even;
        }
        for (int i = 0; i < group.length; i++) {
          if (show) {
            groupRows.add(TableRow(
              decoration: BoxDecoration(
                borderRadius: group == groups[lastVisibleGroup] &&
                        i == group.length - 1
                    ? const BorderRadius.vertical(bottom: Radius.circular(15))
                    : null,
                color: Get.isPlatformDarkMode
                    ? even
                        ? Get.theme.cardColor
                        : Colors.grey[850]
                    : even
                        ? Colors.white
                        : Colors.grey[200],
              ),
              children: [
                Text(
                  item.rows[group[i]].course,
                  style: Get.textTheme.bodyText1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  item.rows[group[i]].period,
                  style: Get.textTheme.bodyText1,
                ),
                Text(
                  item.rows[group[i]].absent,
                  style: Get.textTheme.bodyText1,
                ),
                Text(
                  item.rows[group[i]].substitute,
                  style: Get.textTheme.bodyText1,
                ),
                Text(
                  item.rows[group[i]].room,
                  style: Get.textTheme.bodyText1,
                ),
                Text(
                  item.rows[group[i]].info,
                  style: Get.textTheme.bodyText1,
                ),
              ]
                  .map((e) => Padding(
                      child: e, padding: const EdgeInsets.fromLTRB(5, 5, 0, 5)))
                  .toList(),
            ));
          } else {
            break;
          }
        }
      }
      return groupRows;
    }

    final rows = getRows();

//########################################################################
//#                            No Data Screen                            #
//########################################################################

    if (rows.isEmpty) {
      return SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.update, size: 100),
            Text(
              DateFormat.yMMMMEEEEd(Get.locale.toString()).format(item.date),
              style: context.textTheme.headline4,
            ),
            const SizedBox(height: 10),
            Text(
              "no_data".tr,
              style: context.textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            Text(
              latestUpdate,
              style: Get.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

//########################################################################
//#                                 Table                                #
//########################################################################

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
              color: Get.theme.cardColor,
            ),
            child: Column(
              children: [
                Text(
                  DateFormat.yMMMMEEEEd(Get.locale.toString())
                      .format(item.date),
                  style: context.textTheme.headline4,
                ),
                Divider(
                  color: context.textTheme.bodyText2!.color,
                  indent: 30,
                  endIndent: 30,
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(2.5),
                    2: FlexColumnWidth(4),
                    3: FlexColumnWidth(4),
                    4: FlexColumnWidth(3.5),
                    5: FlexColumnWidth(7.5),
                  },
                  children: [
                    getHeaderRow,
                    ...rows,
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              latestUpdate,
              style: context.textTheme.bodyText1,
            ),
          ),
          const SizedBox(
            height: 65,
          ),
        ],
      ),
    );
  }
}
