import 'package:get/get.dart';

import './local_data.dart';
import './authentication.dart';
import './notifications.dart';
import './web_data.dart';

class AppBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    final localData = Get.put(LocalData());
    final auth = Get.put(Authentication());
    Get.put(WebData());
    Get.put(Notifications());
    await localData.initialize();
    await auth.login();
  }
}
