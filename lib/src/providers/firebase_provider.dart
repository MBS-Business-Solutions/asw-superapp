import 'dart:convert';
import 'dart:io';

import 'package:AssetWise/main.dart';
import 'package:AssetWise/plugins.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class FirebaseMessagingProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  UserProvider? _userProvider;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  String? _apnsToken;
  String? get apnsToken => _apnsToken;

  void updateUserProvider(UserProvider userProvider) async {
    _userProvider = userProvider;
    _getFCMTokens();
  }

  Future<NotificationSettings> _requestPermission() async {
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
    await _requestLocalNotiPermissions();
    return settings;
  }

  Future<void> _getFCMTokens() async {
    _apnsToken = await _messaging.getAPNSToken();
    _fcmToken = await _messaging.getToken();
    _updateToken(_fcmToken);
  }

  Future<void> initialize() async {
    // Request permission for notifications
    await _requestPermission();
    await _getFCMTokens();

    subscribeToTopic('NEWS');
    subscribeToTopic('ALERTS');
    subscribeToTopic('SYSTEMS');

    if (kDebugMode) {
      print('FCM Token: $_fcmToken');
    }
    _messaging.onTokenRefresh.listen((token) => _updateToken(token));
    // // Get token
    // String? token = await _messaging.getToken();
    // print('Firebase Messaging Token: $token');

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenedApp);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: _didReceiveNotificationResponse,
      onDidReceiveNotificationResponse: _didReceiveNotificationResponse,
    );
  }

  static void _didReceiveNotificationResponse(NotificationResponse details) async {
    print('Notification clicked: ${details.payload}');

    final data = jsonDecode(details.payload ?? '{}');
    if (data['contract_id'] != null) {
      final contractId = data['contract_id'];
      // find contract
      final context = navigatorKey.currentState!.context;
      final contracts = await context.read<ContractProvider>().fetchContracts(context);
      final contract = contracts.firstWhere((element) => element.contractId == contractId);
      final overdueDetail = await context.read<ContractProvider>().fetchOverdueDetail(contractId);

      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => PaymentChannelsView(
                contract: contract,
                overdueDetail: overdueDetail,
              )));
    }
  }

  void _handleOnMessageOpenedApp(RemoteMessage message) async {
    print('A new onMessageOpenedApp event was published!');
    print(navigatorKey.currentState);
    final data = message.data;
    if (data['contract_id'] != null) {
      final contractId = data['contract_id'];
      // find contract
      final context = navigatorKey.currentState!.context;
      final contracts = await context.read<ContractProvider>().fetchContracts(context);
      final contract = contracts.firstWhere((element) => element.contractId == contractId);
      final overdueDetail = await context.read<ContractProvider>().fetchOverdueDetail(contractId);

      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => PaymentChannelsView(
                contract: contract,
                overdueDetail: overdueDetail,
              )));
    }
    // Handle the message()));
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

    await AwUserService.updateFCMToken(_userProvider!.token!, _fcmToken!);
    if (kDebugMode) {
      print('FCM Token updated');
    }
  }

  Future<void> _requestLocalNotiPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission = await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'com.assetwise.customerportal',
      'ASSETWISE_LOCAL_NOTIFICATIONS',
      channelDescription: 'Show local notification',
      importance: Importance.defaultImportance,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationId++,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}
