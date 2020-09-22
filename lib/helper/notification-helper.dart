import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  // make this a singleton class
  NotificationHelper._privateConstructor();

  static final NotificationHelper instance =
      NotificationHelper._privateConstructor();
      
  FlutterLocalNotificationsPlugin noti;

  initNotification() {
    if (noti != null) {
      return;
    }
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initIOS = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(
      initAndroid,
      initIOS,
    );
    noti = new FlutterLocalNotificationsPlugin();
    noti.initialize(
      initSetting,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    print('select notification $payload');
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return new AlertDialog(
    //       title: Text("PayLoad"),
    //       content: Text("Payload : $payload"),
    //     );
    //   },
    // );
  }

  Future showNotificationWithDefaultSound() async {
    initNotification();
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await noti.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
