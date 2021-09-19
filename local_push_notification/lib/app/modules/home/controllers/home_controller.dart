import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:local_push_notification/app/core/utils/local_notification.dart';

class HomeController extends GetxController {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late LocalNotification localNotification;

  @override
  void onInit() {
    super.onInit();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    localNotification = LocalNotification(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);

    localNotification.initialize();
  }

  void cancelNotificationById(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
