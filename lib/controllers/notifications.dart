import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './local_data.dart';
import '../pages/home_page/home_page_controller.dart';

import '../models/subscribe_operation.dart';

class Notifications extends GetxController {
  final _messaging = FirebaseMessaging.instance;
  final _localData = Get.find<LocalData>();
  bool _blocked = false;

  Future<String?> initialize() async {
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

    _localData.enqueuedOperations.listen((operations) {
      if (!_blocked) {
        manageSubscription();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final page = message.data["page"];
      if (Get.isRegistered<HomePageController>()) {
        final homePageController = Get.find<HomePageController>();
        homePageController.switchTabs(page == "smv" ? 2 : 0);
        if (page != null && page != "") {
          Get.until((route) => route.settings.name == "/home");
        }
      }
    });

    final initialMessage = await _messaging.getInitialMessage();
    return initialMessage?.data["page"];
  }

  void toggleDailyNotifications(OperationMode mode) {
    for (var i = 0; i < _localData.settings.notifications.length; i++) {
      final topic = _localData.settings.notifications[i];
      enqueueSubscription(topic, mode);
    }
  }

  void enqueueSubscription(String topic, OperationMode mode) {
    final operation = SubscribeOperation(topic, mode);
    final isAlreadyEnqueued = _localData.enqueuedOperations
            .where((item) => item.topic == topic)
            .isNotEmpty &&
        !_blocked;

    if (isAlreadyEnqueued) {
      _localData.enqueuedOperations.removeWhere((item) => item.topic == topic);
    } else {
      _localData.enqueuedOperations.add(operation);
    }
  }

  Future<void> manageSubscription() async {
    _blocked = true;
    List<SubscribeOperation> list = [];
    for (var i = 0; i < _localData.enqueuedOperations.length; i++) {
      final operation = _localData.enqueuedOperations[i];
      final success = await _setSubscription(operation);
      if (success) {
        list.add(operation);
      }
    }
    list.reversed.forEach((element) {
      _localData.enqueuedOperations.remove(element);
    });
    _blocked = false;
  }

  Future<bool> _setSubscription(SubscribeOperation operation) async {
    final inSettings =
        _localData.settings.notifications.contains(operation.topic);
    try {
      if (operation.mode == OperationMode.SUBSCRIBE ||
          (inSettings && _localData.settings.dailyNotifications)) {
        await _messaging.subscribeToTopic(operation.topic);
      } else {
        if (!inSettings) {
          _localData.settings.notifications.remove(operation.topic);
        }
        await _messaging.unsubscribeFromTopic(operation.topic);
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
