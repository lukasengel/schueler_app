import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';

import '../../models/substitution_table.dart';
import '../../routes.dart' as routes;

import '../snackbar.dart';
import './table_row_widget.dart';

class TableContainer extends StatelessWidget {
  final int index;

  const TableContainer(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webData = Get.find<WebData>();
    final table = webData.substitutionTables[index];
    
//########################################################################
//#                               Logic                                  #
//########################################################################

    void lookup(String substitute) {
      final teachers = Get.find<WebData>().teachers;
      String one = "";
      String two = "home/unknown_teacher".tr;

      if (substitute.trim()[0] == '-') {
        two = "home/no_teacher".tr;
      } else if (substitute.length >= 3) {
        final content = substitute.substring(0, 3);
        final index =
            teachers.where((element) => element.abbreviation == content);
        if (index.isNotEmpty) {
          one = index.first.abbreviation;
          two = index.first.name;
        }
      }

      showSnackBar(
        context: Get.context!,
        snackbar: SnackBar(
          content: one.isEmpty ? Text(two) : Text(one + ": " + two),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: "home/show_all".tr,
            onPressed: () => Get.toNamed(routes.abbreviations),
          ),
        ),
      );
    }

    bool showGroup(String group) {
      final filters = Get.find<LocalData>().settings.filters;
      bool show = true;
      bool match = false;
      for (var element in filters.keys) {
        if (group.startsWith(element)) {
          match = true;
          show = filters[element]!;
          break;
        }
      }
      return match ? show : filters["misc"];
    }

    bool isLastVisibleGroup(String group) {
      String id = "";
      for (int i = 0; i < table.groups.length; i++) {
        if (showGroup(table.groups[i])) {
          id = table.groups[i];
        }
      }
      return id == group;
    }

// //########################################################################
// //#                             Builders                                 #
// //########################################################################

    Widget buildNoDataScreen() {
      return SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageIcon(
              AssetImage("assets/images/lucky_cat.png"),
              size: 100,
            ),
            Text(
              DateFormat.yMMMMEEEEd(Get.locale.toString()).format(table.date),
              style: context.textTheme.headline4,
            ),
            const SizedBox(height: 10),
            Text(
              "home/no_data".tr,
              style: context.textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            Text(
              "home/as_of".tr +
                  DateFormat.yMd(Get.locale.toString())
                      .add_jms()
                      .format(webData.latestUpdate),
              style: Get.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    List<Widget> buildRows() {
      List<Widget> list = [];
      bool even = false;
      table.groups.forEach((group) {
        if (showGroup(group)) {
          list.add(
            Container(
              decoration: even
                  ? BoxDecoration(
                      borderRadius: isLastVisibleGroup(group)
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            )
                          : null,
                      color: Get.isPlatformDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                    )
                  : null,
              child: Column(
                children: table.getGroup(group).map((row) {
                  return TableRowWidget(
                    row: row,
                    lookup: lookup,
                  );
                }).toList(),
              ),
            ),
          );
          even = !even;
        }
      });
      return list;
    }

    final rows = buildRows();

    return rows.isEmpty
        ? buildNoDataScreen()
        : SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ],
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Text(
                          DateFormat.yMMMMEEEEd(Get.locale.toString())
                              .format(table.date),
                          style: context.textTheme.headline4,
                        ),
                        const Divider(
                          color: Colors.grey,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const TableHeaderRow(header: SubstitutionTable.header),
                        ...rows,
                      ],
                    )),
              ),
              Text(
                "home/as_of".tr +
                    DateFormat.yMd(Get.locale.toString())
                        .add_jms()
                        .format(webData.latestUpdate),
                style: context.textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
            ]),
          );
  }
}
