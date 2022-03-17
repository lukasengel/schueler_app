import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './local_data.dart';

class Notifications extends GetxController {
  late FirebaseMessaging _messaging;

  Future<void> initialize() async {
    _messaging = FirebaseMessaging.instance;

    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> manageSubscriptions() async {
    final localData = Get.find<LocalData>();
    final settings = localData.settings;

    if (settings.needToRenew) {
      var success = true;
      success = await _setSubscription("smv", settings.smvNotifications);
      success =
          await _setSubscription("broadcast", settings.broadcastNotifications);

      settings.removalPending.forEach((element) async {
        success = await _setSubscription(element, false);
        if (success) {
          settings.removalPending.remove(element);
        }
      });

      settings.notifications.forEach((element) async {
        success = await _setSubscription(element, settings.dailyNotifications);
      });

      if (success) {
        settings.needToRenew = false;
        await localData.writeSettings();
      }
    }
  }

  Future<bool> _setSubscription(String topic, bool enabled) async {
    try {
      if (enabled) {
        await _messaging.subscribeToTopic(topic);
      } else {
        await _messaging.unsubscribeFromTopic(topic);
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
