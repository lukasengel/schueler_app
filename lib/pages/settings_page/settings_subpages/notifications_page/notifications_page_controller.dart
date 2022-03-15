import 'package:get/get.dart';

import '../../../../controllers/local_data.dart';
import '../../../../widgets/course_picker/course_picker.dart';

class NotificationsPageController extends GetxController {
  final localData = Get.find<LocalData>();

  Future<bool> onChangedDailyNotifications() async {
    final settings = localData.settings;
    settings.dailyNotifications = !settings.dailyNotifications;
    await localData.writeSettings();
    return settings.dailyNotifications;
  }

  Future<bool> onChangedSmvNews() async {
    final settings = localData.settings;
    settings.smvNotifications = !settings.smvNotifications;
    await localData.writeSettings();
    return settings.smvNotifications;
  }

  Future<void> addCourse() async {
    final notifications = localData.settings.notifications;
    final input = await showCoursePicker(Get.context!);

    if (input != null && !notifications.contains(input)) {
      notifications.add(input);
      await localData.writeSettings();
      update();
    }
  }

  Future<void> deleteCourse(String course) async {
    localData.settings.notifications.remove(course);
    await localData.writeSettings();
    update();
  }

  Future<bool> onChangedBroadcast() async {
    final settings = localData.settings;
    settings.broadcastNotifications = !settings.broadcastNotifications;
    await localData.writeSettings();
    return settings.broadcastNotifications;
  }
}
