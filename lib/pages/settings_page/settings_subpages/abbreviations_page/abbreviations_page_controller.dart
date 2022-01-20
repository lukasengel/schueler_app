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
    if (input.trim() == "Opfer") {
      list = webData.teachers
          .where((element) => element.abbreviation == "fla")
          .toList();
    } else {
      list = webData.teachers.where((element) {
        return element.abbreviation.contains(input) ||
            element.name.contains(input);
      }).toList();
    }
    update();
  }

  void clearInput() {
    searchController.clear();
  }
}
