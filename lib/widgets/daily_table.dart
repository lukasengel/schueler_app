import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/local_data.dart';

class DailyTable extends StatelessWidget {
  final List<List<int>> groups;
  final List<List<String>> data;

  const DailyTable(this.data, this.groups, {Key? key}) : super(key: key);

  String formatDate(String text) {
    RegExp regex = RegExp(r"\d\d\.\d\d\.\d\d\d\d");
    final match = regex.firstMatch(text);
    if (match != null) {
      final dateString = text.substring(match.start, match.end);
      final formatter = DateFormat(r"d.M.y");
      final datetime = formatter.parse(dateString);
      final dow = DateFormat("EEEE");
      text = dow.format(datetime).toLowerCase().tr + ", " + dateString;
    }
    return text;
  }

  TableRow getHeaderRow() {
    return TableRow(
      children: data[2].map((content) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Text(
            content,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }

  bool showGroup(String groupTitle) {
    bool show = true;
    Get.find<LocalData>().settings.filters.forEach((element) {
      if (groupTitle.startsWith(element)) {
        show = false;
      }
    });
    return show;
  }

  int get getIndexOfLastVisibleGroup {
    int index = 0;
    for (int i = 0; i < groups.length; i++) {
      if (showGroup(data[groups[i][0]][0])) {
        index = i;
      }
    }
    return index;
  }

  List<TableRow> getGroupRows() {
    bool even = false;
    List<TableRow> rows = [];

    for (int i = 0; i < groups.length; i++) {
      if (showGroup(data[groups[i][0]][0])) {
        even = !even;
        for (int x = 0; x < groups[i].length; x++) {
          if (data[groups[i][x]].length != data[2].length) {
            continue;
          }
          rows.add(
            TableRow(
              decoration: BoxDecoration(
                borderRadius: x == groups[i].length - 1 &&
                        i == getIndexOfLastVisibleGroup
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
              children: data[groups[i][x]]
                  .map((e) => Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: Text(
                          e,
                          style: Get.textTheme.bodyText1!.copyWith(
                            fontWeight: data[groups[i][x]].indexOf(e) == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        }
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = getGroupRows();

    if (rows.isEmpty) {
      return SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.watch_later_outlined,
              size: 100,
            ),
            Text(
              "no_data".tr,
              style: Get.textTheme.bodyText1,
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: EdgeInsets.all(10),
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
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                formatDate(data[0][0]),
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(
                color: Get.textTheme.bodyText2!.color,
                indent: 30,
                endIndent: 30,
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3.5),
                  1: FlexColumnWidth(2.5),
                  2: FlexColumnWidth(4),
                  3: FlexColumnWidth(4),
                  4: FlexColumnWidth(4),
                  5: FlexColumnWidth(7),
                },
                children: [
                  getHeaderRow(),
                  ...rows,
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
      ]),
    );
  }
}
