import 'package:get/get.dart';

import '../controllers/web_data.dart';
import '../controllers/authentication.dart';

import '../widgets/snackbar.dart';

class Lifecycle extends SuperController {
  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() async {
    if (Get.find<Authentication>().authState.value == AuthState.LOGGED_IN) {
      try {
        await Get.find<WebData>().fetchData();
      } catch (e) {
        showErrorSnackbar(e);
      }
    }
  }
}
