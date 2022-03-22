import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/web_data.dart';

class SubstutionTabController extends GetxController {
  final webData = Get.find<WebData>();
  late PageController pageController;

  @override
  onInit() {
    pageController = PageController(initialPage: secondPage? 1: 0);
    super.onInit();
  }

  bool get secondPage {
    final now = DateTime.now();
    final then = webData.substitutionTables.first.date;
    return now.isAfter(DateTime(then.year, then.month, then.day, 16));
  }
}
