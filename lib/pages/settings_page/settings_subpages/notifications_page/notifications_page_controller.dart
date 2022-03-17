import 'package:get/get.dart';

import '../../../../controllers/notifications.dart';

import '../../../../controllers/local_data.dart';
import '../../../../widgets/course_picker/course_picker.dart';

class NotificationsPageController extends GetxController {

@override
  void onClose() {
    Get.find<Notifications>().manageSubscriptions();
    super.onClose();
  }

  final localData = Get.find<LocalData>();

  Future<bool> onChangedDailyNotifications() async {
    final settings = localData.settings;
    settings.dailyNotifications = !settings.dailyNotifications;
    settings.needToRenew = true;
    await localData.writeSettings();
    return settings.dailyNotifications;
  }

  Future<bool> onChangedSmvNews() async {
    final settings = localData.settings;
    settings.smvNotifications = !settings.smvNotifications;
    settings.needToRenew = true;
    await localData.writeSettings();
    return settings.smvNotifications;
  }

  Future<void> addCourse() async {
    final notifications = localData.settings.notifications;
    final input = await showCoursePicker(Get.context!);

    if (input != null && !notifications.contains(input)) {
      notifications.add(input);
      localData.settings.needToRenew = true;
      await localData.writeSettings();
      update();
    }
  }

  Future<void> deleteCourse(String course) async {
    final settings = localData.settings;
    settings.notifications.remove(course);
    settings.removalPending.add(course);
    settings.needToRenew = true;
    await localData.writeSettings();
    update();
  }

  Future<bool> onChangedBroadcast() async {
    final settings = localData.settings;
    settings.broadcastNotifications = !settings.broadcastNotifications;
    settings.needToRenew = true;
    await localData.writeSettings();
    return settings.broadcastNotifications;
  }
}
