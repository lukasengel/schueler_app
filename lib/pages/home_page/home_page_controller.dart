import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../routes.dart' as routes;
import '../../controllers/local_data.dart';
import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/snackbar.dart';

class HomePageController extends GetxController {
  final refreshController = EasyRefreshController();
  final localData = Get.find<LocalData>();
  final webData = Get.find<WebData>();
  late int selectedTab;

  @override
  void onInit() {
    switch (Get.find<Authentication>().initialPage) {
      case "smv":
        selectedTab = 2;
        break;
      default:
        selectedTab = 0;
    }
    super.onInit();
  }

  void switchTabs(int index) {
    selectedTab = index;
    update();
  }

  void onPressedSettings() {
    Get.toNamed(routes.settings);
  }

  void invertSorting() async {
    if (selectedTab == 1) {
      localData.settings.reversedNews = !localData.settings.reversedNews;
    } else {
      localData.settings.reversedSmv = !localData.settings.reversedSmv;
    }
    await localData.writeSettings();
    webData.update();
  }

  Future<void> onRefresh(BuildContext context) async {
    try {
      await webData.fetchData();
    } on FirebaseException catch (e) {
      showSnackBar(
        context: context,
        snackbar: SnackBar(
          content: Text("general/error".tr.toUpperCase() + ": " + e.message!),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      showSnackBar(
        context: context,
        snackbar: SnackBar(
          content: Text(
            "general/error".tr.toUpperCase() + ": " + e.toString(),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
    refreshController.finishRefresh();
  }
}
