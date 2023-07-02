import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart';

class NotificationHelper {
  static final localNotificationPlugin = FlutterLocalNotificationsPlugin();

  static final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {
    initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_stat_access_alarm');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await localNotificationPlugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onNotificationResponse,
    );
  }

  Future<void> deleteNotification({required DateTime date}) async {}

  Future<void> showSimpleNotification(
      {required String title,
      required String body,
      required dynamic payload}) async {
    NotificationDetails notificationDetails = await _notificationDetails();

    localNotificationPlugin.show(
      1,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  static void onBackgroundNotificationResponse(NotificationResponse details) {
    log("Payload from background : ${details.payload}");
    if (details.payload != null && details.payload!.isNotEmpty) {
      onNotificationClick.add(details.payload);
    }
  }

  void onNotificationResponse(NotificationResponse details) {
    log("Payload from foreground : ${details.payload}");
    if (details.payload != null && details.payload!.isNotEmpty) {
      onNotificationClick.add(details.payload);
    }
  }

  static void listenToNotification() =>
      onNotificationClick.stream.listen(notificationCallback);

  static void notificationCallback(String? payload) {
    if (payload == null) return;

    // TODO: implement on notification received callback
    log("Notification received");
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails;

    androidNotificationDetails = const AndroidNotificationDetails(
      "zomujo_notification", //TODO: channel ID to be changed
      "zomujo_app", //TODO: channel name to be changed
      channelDescription: "zomujo app channel",
      //TODO: channel description to be changed
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }
}
