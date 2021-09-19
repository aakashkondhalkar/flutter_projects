import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:local_push_notification/app/modules/promo/views/promo_view.dart';
import 'package:local_push_notification/app/routes/app_pages.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotification({required this.flutterLocalNotificationsPlugin});

  // for android only
  final AndroidNotificationChannel notificationChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  void initialize() {
    Future onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      Get.dialog(Container(
        child: MaterialBanner(
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                // Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SecondScreen(payload: payload),
                //   ),
                // );
              },
            )
          ],
          content: Container(
            child: ListTile(
              title: Text(title.toString()),
              subtitle: Text(body.toString()),
            ),
          ),
        ),
      ));
    }

    // Set notification settings
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("launch_background");
    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) =>
                onDidReceiveLocalNotification(id, title, body, payload));

    // initialize setting for specific platform
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    Future selectNotification(String? payload) async {
      if (payload != null) {
        Get.toNamed(Routes.PROMO, arguments: payload);
        debugPrint('notification payload: $payload');
      }
    }

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) => selectNotification(payload));
  }

  Future<void> showDefaultNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("pinciat_x", "pinciat", "First new channel",
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    NotificationDetails platfromChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    flutterLocalNotificationsPlugin.show(
        0, "Plain title", "Plain body", platfromChannelSpecifics,
        payload: "Item x");
  }

  Future<void> showSchedualNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            "pinciat_y", "pinciat_1", "First new channel",
            importance: Importance.high, priority: Priority.high);

    NotificationDetails platfromChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        "Schedual",
        "Zone schedual",
        tz.TZDateTime.now(tz.UTC).add(const Duration(seconds: 5)),
        platfromChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: "Item Y");
  }

  Future<void> showNotificationPeriodicaly() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('repeating channel id',
            'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(2, 'Periodic',
        'Notification', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: "Item Z");
  }
}
