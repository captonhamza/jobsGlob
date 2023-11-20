import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("provisional permission granted");
    } else {
      print("permission denied");
    }
  }

  void initLocalNotification(
    RemoteMessage message,
    BuildContext context,
  ) async {
    var androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      print("////////payload///////////");
      print(payload);
      handleMessage(message, context);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print("OnMessage: ${message.data['phone_number']}");
      print("Title: ${message.notification!.title}");
      print("Body: ${message.notification!.body}");
      showNotification(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("OnMessageOpenedApp: ${message.data['phone_number']}");
      // Handle opening the app from a notification
    });

    // Add additional listeners for different notification conditions if needed.
  }

  Future<void> showNotification(
      RemoteMessage message, BuildContext context) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(Random.secure().nextInt(100000).toString(),
            'High Importance Notification',
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription:
          'This channel is build to send notifications to manage my dsp app',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  void isTokenReferesh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
    print("token refresh");
  }

  Future<void> setupInteractMessage(
    BuildContext context,
  ) async {
    // when app is terminated
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage, context);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event, context);
    });
  }

  void handleMessage(
    RemoteMessage message,
    BuildContext context,
  ) {
    // navigatorKey.currentState!.pop();
    // navigatorKey.currentState!.pop(context);

    if (message.data['phone_number'] != null) {
      print("on click event///////////////////");

      // navigatorKey.currentState!.pushNamed('/chat', arguments: {'phone_number': message.data['phone_number']});
      // navigatorKey.currentState!.pushNamed('/chat', arguments: {'phone_number': message.data['phone_number']});
      // navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => IndividualChat(message.data['phone_number'], userData)));
      // navigatorKey.currentState!.push(
      //     MaterialPageRoute(builder: (_) => Webview("google.com"))
      // );
    }
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
