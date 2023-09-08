import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class LocalNotifications {

  static Future<void> requestPermissionLocalNotifications() async {

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationAndroidSettings = AndroidInitializationSettings('app_icon');
    //TODO: IOS Configuration

    const initializationSettings = InitializationSettings(
      android: initializationAndroidSettings
      //TODO: IOS Configuration settings
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } 

}