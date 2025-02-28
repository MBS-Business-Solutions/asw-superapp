import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/features/dashboard/dashboard_view.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  UserProvider? _userProvider;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  String? _apnsToken;
  String? get apnsToken => _apnsToken;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not yet granted permission');
    }

    _apnsToken = await _messaging.getAPNSToken();
    _fcmToken = await _messaging.getToken();
    _updateToken(_fcmToken);

    subscribeToTopic('NEWS');
    subscribeToTopic('ALERTS');
    subscribeToTopic('SYSTEMS');

    // if (kDebugMode) {
    //   print('Token: $_fcmToken');
    // }
    _messaging.onTokenRefresh.listen((token) => _updateToken(token));
    // // Get token
    // String? token = await _messaging.getToken();
    // print('Firebase Messaging Token: $token');

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message: ${message.notification?.title}');
      // Alert the message to the user
      // showDialog(
      //   context: navigatorKey.currentState!.context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('New Notification'),
      //     content: Text(message.notification?.body ?? 'No message body'),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //           // Navigator.of(context).pushNamed(DashboardView.routeName);
      //         },
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
      // Handle the message here
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }

  void _updateToken(String? token) async {
    _fcmToken = token;
    if (_userProvider?.token == null || _fcmToken == null) return;

    //await AwUserService.updateFCMToken(_userProvider!.token!, _fcmToken!);
    // if (kDebugMode) {
    //   print('FCM Token updated');
    // }
  }
}
