import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/teacher.dart';
import '../../../../controllers/web_data.dart';

class AbbreviationsPageController extends GetxController {
  final webData = Get.find<WebData>();
  final searchController = TextEditingController();
  List<Teacher> list = [];

  @override
  void onInit() {
    list = [...webData.teachers];
    super.onInit();
  }

  void onTapScaffold() {
    Get.focusScope!.unfocus();
  }

  void onSearchInput(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) {
      list = [...webData.teachers];
    } else if (trimmed == "opfer") {
      list = webData.teachers
          .where((element) => element.abbreviation == "fla")
          .toList();
    } else {
      list = webData.teachers.where((element) {
        return element.abbreviation.toLowerCase().contains(trimmed) ||
            element.name.toLowerCase().contains(trimmed);
      }).toList();
    }
    update();
  }

  void clearInput() {
    searchController.clear();
    Get.focusScope!.unfocus();
    list = [...webData.teachers];
    update();
  }
}
