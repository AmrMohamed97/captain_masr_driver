import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app/app.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // streamController.add(notificationResponse);
    final Map<String, dynamic>? map =
        jsonDecode(notificationResponse.payload ?? "{}");
    if ((map?.isEmpty ?? false) && navigatorKey.currentState != null) {
      navigateBasedOnPayload(map ?? {});
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (navigatorKey.currentState != null && (map?.isNotEmpty ?? false)) {
          navigateBasedOnPayload(map ?? {});
        }
      });
    }
  }

  static Future init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    streamController.stream.listen((response) {
      onTap(response);
    });
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@drawable/ic_notification",
    );
    const NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  static void navigateBasedOnPayload(Map<String, dynamic> map) {
    // final String? type = map["type"];
    // if (type == null &&
    //     sl<CacheHelper>().getStringData(AppConstants.userOrVendor) ==
    //         AppConstants.vendor &&
    //     sl<CacheHelper>().getStringData(ApiKey.token) != null) {
    //   debugPrint("No Type In Payload: $map");
    //   navigatorKey.currentState?.push(
    //     MaterialPageRoute(builder: (context) {
    //       return const NotificationsScreen();
    //     }),
    //   );
    //   return;
    // }
  }
}
