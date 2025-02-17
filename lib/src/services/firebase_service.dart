import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/features/dashboard/dashboard_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not yet granted permission');
    }

    // Get APNS token
    String? apnsToken = await _messaging.getAPNSToken();
    print('APNS Token: $apnsToken');

    // Get token
    String? token = await _messaging.getToken();
    print('Firebase Messaging Token: $token');

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message: ${message.notification?.title}');
      // Alert the message to the user
      showDialog(
        context: navigatorKey.currentState!.context,
        builder: (context) => AlertDialog(
          title: const Text('New Notification'),
          content: Text(message.notification?.body ?? 'No message body'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(DashboardView.routeName);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // Handle the message here
    });
  }
}
