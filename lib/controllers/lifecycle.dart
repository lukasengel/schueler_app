import 'package:get/get.dart';

import '../pages/home_page/home_page_controller.dart';

class Lifecycle extends SuperController {
  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    if (Get.isRegistered<HomePageController>()) {
      Future.delayed(Duration.zero).then((_) {
        Get.find<HomePageController>().refreshController.callRefresh();
      });
    }
  }
}
