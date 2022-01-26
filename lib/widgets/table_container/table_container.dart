import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:schueler_app/widgets/table_container/table_container_controller.dart';

class TableContainer extends StatelessWidget {
  final int index;

  const TableContainer(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered(tag: "$index")) {
      Get.delete(tag: "$index");
    }
    final controller = Get.put(TableContainerController(index), tag: "$index");

//########################################################################
//#                             Builders                                 #
//########################################################################

    Widget buildNoDataScreen() {
      return SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.update, size: 100),
            Text(
              DateFormat.yMMMMEEEEd(Get.locale.toString())
                  .format(controller.table.date),
              style: context.textTheme.headline4,
            ),
            const SizedBox(height: 10),
            Text(
              "home/no_data".tr,
              style: context.textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            Text(
              controller.latestUpdate,
              style: Get.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    TableRow getHeaderRow() {
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

    List<TableRow> getRows() {
      List<TableRow> groupRows = [];
      bool even = false;

      for (var group in controller.groups) {
        bool show =
            controller.showGroup(controller.table.rows[group[0]].course);
        if (show) {
          even = !even;
        }
        for (int i = 0; i < group.length; i++) {
          if (!show) {
            break;
          }
          groupRows.add(TableRow(
            decoration: BoxDecoration(
              borderRadius:
                  group == controller.groups[controller.lastVisibleGroup] &&
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
                controller.table.rows[group[i]].course,
                style: Get.textTheme.bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                controller.table.rows[group[i]].period,
                style: Get.textTheme.bodyText1,
              ),
              CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  child: Text(
                    controller.table.rows[group[i]].absent,
                    style: Get.textTheme.bodyText1,
                  ),
                  onPressed: () {
                    controller.lookup(controller.table.rows[group[i]].absent);
                  }),
              CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  child: Text(
                    controller.table.rows[group[i]].substitute,
                    style: Get.textTheme.bodyText1,
                  ),
                  onPressed: () {
                    controller
                        .lookup(controller.table.rows[group[i]].substitute);
                  }),
              Text(
                controller.table.rows[group[i]].room,
                style: Get.textTheme.bodyText1,
              ),
              Text(
                controller.table.rows[group[i]].info,
                style: Get.textTheme.bodyText1,
              ),
            ].map((e) {
              return Padding(
                  child: e, padding: const EdgeInsets.fromLTRB(5, 5, 0, 5));
            }).toList(),
          ));
        }
      }
      return groupRows;
    }

//########################################################################
//#                                 Table                                #
//########################################################################

    final rows = getRows();
    return rows.isEmpty
        ? buildNoDataScreen()
        : SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                            .format(controller.table.date),
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
                        children: [getHeaderRow(), ...rows],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    controller.latestUpdate,
                    style: context.textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          );
  }
}
