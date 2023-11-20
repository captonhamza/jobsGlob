import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobs_global/NotificationManage/notification_service.dart';
import 'package:jobs_global/Screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    checkPreferences();

    super.initState();
  }

  String? token;

  void checkPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var checkToken = pref.getString("token");

    if (checkToken == null || checkToken.isEmpty || checkToken == "") {
      await notificationServices.getDeviceToken().then((value) {
        print("Device Token");
        print(value);
        token = value;
      });
      notificationServices.foregroundMessage();

      pref.setString("token", token!);
    } else {
      notificationServices.foregroundMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobs Glob',
      home: const SplashScreen(),
    );
  }
}
