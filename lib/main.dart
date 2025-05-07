import 'dart:io';

import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/providers/hot_menu_provider.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/providers/promotion_provider.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/providers/verify_otp_provider.dart';
import 'package:AssetWise/src/providers/firebase_provider.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/features/settings/settings_controller.dart';
import 'src/features/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';

late Isar isar;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  // if (kDebugMode) {
  // In case Cert chain is not valid, apply this code below
  // HttpOverrides.global = MyHttpOverrides();
  // }
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();
  await initializeFirebase();
  await initIsar();

  final userProvider = UserProvider();
  // await userProvider.initApp(
  //     testToken:
  //         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZDc2M2M3OC1jMTEzLTRiNjEtYjdiYS05ZThiNGU5MDI5MWUiLCJlbWFpbCI6IiIsImlhdCI6MTc0NjU4ODY4NCwiZXhwIjoxNzQ5MTgwNjg0fQ.IHqSVB8xHGA6ECmaiZMXB1fXLhVONIZmHRNfUmJcDyM');
  await userProvider.initApp();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DashboardProvider()),
    ChangeNotifierProvider(
      create: (context) => userProvider,
    ),
    ProxyProvider<UserProvider, FirebaseMessagingProvider>(
      create: (context) => FirebaseMessagingProvider(),
      update: (context, userProvider, previous) => previous!..updateUserProvider(userProvider),
    ),
    ProxyProvider<UserProvider, RegisterProvider>(
      create: (context) => RegisterProvider(),
      update: (context, userProvider, previous) => previous!..updateUserProvider(userProvider),
    ),
    ProxyProvider<UserProvider, ContractProvider>(
      create: (context) => ContractProvider(),
      update: (context, userProvider, previous) => previous!..updateUserProvider(userProvider),
    ),
    ChangeNotifierProxyProvider<UserProvider, NotificationItemProvider>(
      create: (context) => NotificationItemProvider(),
      update: (context, userProvider, previous) => previous!..updateUserProvider(userProvider),
    ),
    ProxyProvider<UserProvider, VerifyOtpProvider>(
      create: (context) => VerifyOtpProvider(),
      update: (context, userProvider, previous) => previous!..updateUserProvider(userProvider),
    ),
    ChangeNotifierProvider(create: (context) => HotMenuProvider()),
    Provider(create: (context) => PromotionProvider()),
    ChangeNotifierProxyProvider<UserProvider, ProjectProvider>(
      create: (context) => ProjectProvider(),
      update: (context, userProvider, previous) => previous!..updateUserProvider(userProvider),
      lazy: false,
    ),
    ChangeNotifierProxyProvider2<UserProvider, ProjectProvider, SettingsController>(
      create: (context) => settingsController,
      update: (context, userProvider, projectProvider, previous) => previous!..updateProvider(userProvider, projectProvider),
    ),
  ], child: MyApp(settingsController: settingsController)));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// ✅ Top-Level Function ที่อยู่นอก main()
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initIsar();
  final count = await NotificationItemProvider.fetchNotificationItemsForBackground();

  if (await AppBadgePlus.isSupported()) {
    await AppBadgePlus.updateBadge(count);
  }
}

Future<void> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [NotificationItemSchema],
    directory: dir.path,
  );
}

Future<void> reloadIsar([String? userId]) async {
  final dir = await getApplicationDocumentsDirectory();
  await isar.close();
  isar = await Isar.open(
    [NotificationItemSchema],
    directory: dir.path,
    name: userId ?? 'assetwise',
  );

  if (userId == null) {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
