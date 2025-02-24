import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/firebase_service.dart';
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
  //   HttpOverrides.global = MyHttpOverrides();
  // }
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();
  await initializeFirebase();
  await initIsar();

  final userProvider = UserProvider();
  await userProvider.initApp();
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MultiProvider(providers: [
    Provider(create: (context) => FirebaseMessagingService()),
    Provider(create: (context) => DashboardProvider()),
    ChangeNotifierProvider(
      create: (context) => userProvider,
    ),
    ChangeNotifierProxyProvider<UserProvider, SettingsController>(
      create: (context) => settingsController,
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
  ], child: MyApp(settingsController: settingsController)));
}

bool isPinEntryVisible = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [NotificationItemSchema],
    directory: dir.path,
  );
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
