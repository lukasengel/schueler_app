import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './local_data.dart';

import '../models/subscribe_operation.dart';

class Notifications extends GetxController {
  final _messaging = FirebaseMessaging.instance;
  final localData = Get.find<LocalData>();
  bool blocked = false;
  RxString route = "".obs;

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    localData.enqueuedOperations.listen((operations) {
      if (!blocked) {
        manageSubscription();
      }
    });
  }

  void toggleDailyNotifications(OperationMode mode) {
    for (var i = 0; i < localData.settings.notifications.length; i++) {
      final topic = localData.settings.notifications[i];
      enqueueSubscription(topic, mode);
    }
  }

  void enqueueSubscription(String topic, OperationMode mode) {
    final operation = SubscribeOperation(topic, mode);
    final isAlreadyEnqueued = localData.enqueuedOperations
            .where((item) => item.topic == topic)
            .isNotEmpty &&
        !blocked;

    if (isAlreadyEnqueued) {
      localData.enqueuedOperations.removeWhere((item) => item.topic == topic);
    } else {
      localData.enqueuedOperations.add(operation);
    }
  }

  Future<void> manageSubscription() async {
    blocked = true;
    List<SubscribeOperation> list = [];
    for (var i = 0; i < localData.enqueuedOperations.length; i++) {
      final operation = localData.enqueuedOperations[i];
      final success = await _setSubscription(operation);
      if (success) {
        list.add(operation);
      }
    }
    list.reversed.forEach((element) {
      localData.enqueuedOperations.remove(element);
    });
    blocked = false;
  }

  Future<bool> _setSubscription(SubscribeOperation operation) async {
    final inSettings =
        localData.settings.notifications.contains(operation.topic);
    try {
      if (operation.mode == OperationMode.SUBSCRIBE ||
          (inSettings && localData.settings.dailyNotifications)) {
        await _messaging.subscribeToTopic(operation.topic);
      } else {
        if (!inSettings) {
          localData.settings.notifications.remove(operation.topic);
        }
        await _messaging.unsubscribeFromTopic(operation.topic);
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
