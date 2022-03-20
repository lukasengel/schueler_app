import 'package:get/get.dart';

import '../../../../controllers/notifications.dart';
import '../../../../controllers/local_data.dart';
import '../../../../widgets/course_picker/course_picker.dart';

import '../../../../models/subscribe_operation.dart';

class NotificationsPageController extends GetxController {
  final localData = Get.find<LocalData>();
  final notifications = Get.find<Notifications>();

  Future<bool> onChangedDailyNotifications() async {
    final settings = localData.settings;
    settings.dailyNotifications = !settings.dailyNotifications;
    await localData.writeSettings();
    notifications.toggleDailyNotifications(settings.dailyNotifications
        ? OperationMode.SUBSCRIBE
        : OperationMode.UNSUBSCRIBE);
    await localData.writeOperations();
    return settings.dailyNotifications;
  }

  Future<bool> onChangedSmvNews() async {
    final settings = localData.settings;
    settings.smvNotifications = !settings.smvNotifications;
    await localData.writeSettings();
    notifications.enqueueSubscription(
        "smv",
        settings.smvNotifications
            ? OperationMode.SUBSCRIBE
            : OperationMode.UNSUBSCRIBE);
    await localData.writeOperations();
    return settings.smvNotifications;
  }

  Future<bool> onChangedBroadcast() async {
    final settings = localData.settings;
    settings.broadcastNotifications = !settings.broadcastNotifications;
    await localData.writeSettings();
    notifications.enqueueSubscription(
        "course",
        settings.broadcastNotifications
            ? OperationMode.SUBSCRIBE
            : OperationMode.UNSUBSCRIBE);
    await localData.writeOperations();

    return settings.broadcastNotifications;
  }

  Future<void> addCourse() async {
    final input = await showCoursePicker(Get.context!);
    if (input != null && !localData.settings.notifications.contains(input)) {
      localData.settings.notifications.add(input);
      await localData.writeSettings();
      if (localData.settings.dailyNotifications) {
        notifications.enqueueSubscription(input, OperationMode.SUBSCRIBE);
        await localData.writeOperations();
      }
      update();
    }
  }

  Future<void> deleteCourse(String course) async {
    final settings = localData.settings;
    settings.notifications.remove(course);
    notifications.enqueueSubscription(course, OperationMode.UNSUBSCRIBE);
    await localData.writeOperations();
    await localData.writeSettings();
    update();
  }
}
