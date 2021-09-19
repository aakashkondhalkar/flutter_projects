import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Local Notification")),
        body: Container(
          margin: EdgeInsets.all(60.0),
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: [
              ElevatedButton(
                child: Text("Show Default Notificaion"),
                onPressed: () =>
                    controller.localNotification.showDefaultNotification(),
              ),
              ElevatedButton(
                child: Text("Show schedual Notification"),
                onPressed: () =>
                    controller.localNotification.showSchedualNotification(),
              ),
              ElevatedButton(
                child: Text("show periodic Notification"),
                onPressed: () =>
                    controller.localNotification.showNotificationPeriodicaly(),
              ),
              ElevatedButton(
                child: Text("Cancel notification"),
                onPressed: () => controller.cancelNotificationById(0),
              ),
              ElevatedButton(
                child: Text("Cancel all notification"),
                onPressed: () => controller.cancelAllNotifications(),
              ),
            ],
          ),
        ));
  }
}
