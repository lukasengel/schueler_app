import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/web_data.dart';
import '../../controllers/local_data.dart';

import '../../models/substitution_table.dart';

import '../snackbar.dart';

import '../../pages/settings_page/settings_subpages/abbreviations_page/abbreviations_page.dart';

class TableContainerController extends GetxController {
  final int index;
  TableContainerController(this.index);

  late SubstitutionTable table;
  late List<List<int>> groups;
  late int lastVisibleGroup;
  late String latestUpdate;

  final webData = Get.find<WebData>();

  @override
  void onInit() {
    table = webData.substitutionTables[index];
    groups = getGroups();
    lastVisibleGroup = getLastVisibleGroup();
    latestUpdate = webData.latestUpdate;
    super.onInit();
  }

//########################################################################
//#                          Sorting Logic                               #
//########################################################################

  List<List<int>> getGroups() {
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
    final filters = Get.find<LocalData>().settings.filters;
    bool show = true;
    bool match = false;
    for (var element in filters.keys) {
      if (groupTitle.startsWith(element)) {
        match = true;
        show = filters[element]!;
        break;
      }
    }
    return match ? show : filters["misc"];
  }

  int getLastVisibleGroup() {
    int index = 0;
    for (int i = 0; i < groups.length; i++) {
      if (showGroup(table.rows[groups[i][0]].course)) {
        index = i;
      }
    }
    return index;
  }

  void lookup(String substitute) {
    final teachers = Get.find<WebData>().teachers;
    String one = "";
    String two = "home/no_information".tr;

    if (substitute.length >= 3) {
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
          onPressed: () => Get.toNamed(AbbreviationsPage.route),
        ),
      ),
    );
  }
}
