import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:roam_the_world_app/pages/chat/chat_room_screen.dart';


class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // for notification request
  void requestNotificationService() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user grant permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user grant provisional permission");
    } else {
      Get.snackbar("Notification permission denied",
          "Please allow notifications to recieve updates",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      Future.delayed(Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  // get token
  Future<String> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true);
    String? token = await messaging.getToken();
    print("Token is $token");
    return token!;
  }

  // init
  void InitLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitSetting =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings = const DarwinInitializationSettings();
    var initiliazeSetting =
    InitializationSettings(android: androidInitSetting, iOS: iosSettings);
    await _flutterLocalNotificationsPlugin.initialize(initiliazeSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
        });
  }

  // FirebaseInit
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (kDebugMode) {
        print('Notification title is ${notification!.title}');
        print('Notification body is ${notification!.body}');
      }
      //ios
      if (Platform.isIOS) {
        iosForegroundMessage();
      }

      //android
      if (Platform.isAndroid) {
        InitLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  // function to show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.high,
        showBadge: true,
        playSound: true
    );

    // androidsetting
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        channel.id.toString(), channel.name.toString(),
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: channel.sound);
    // ios setting
    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    //merge settings
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    // show notification
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: "my_Data");
    });
  }

  // IOS Message
  Future iosForegroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // background and terminated
  Future<void> setupInterractMessage(BuildContext context) async {
    // background messsage
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });

    //terminated message
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });
  }

  //Handler
  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    if(message.data['screen'] == 'cart'){
      Get.to(ChatRoomScreen());

    }else{
      Get.to(ChatRoomScreen());

    }
  }
}
