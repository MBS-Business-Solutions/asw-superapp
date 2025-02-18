import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/0_test/ui_showcase_screen.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view_file.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/features/register/otp_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:AssetWise/src/services/firebase_service.dart';
import 'package:AssetWise/src/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/settings/settings_controller.dart';
import 'features/settings/settings_view.dart';

import 'features/dashboard/dashboard_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.

    // Initialize Firebase Messaging and request permission
    context.read<FirebaseMessagingService>().initialize();

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          navigatorKey: navigatorKey,

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('th', ''), // Thai, no country code
          ],
          locale: settingsController.locale, // Set default locale to Thai

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: mLightTheme,
          darkTheme: mDarkTheme,
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case UIShowcaseScreen.routeName:
                    return UIShowcaseScreen(
                      onSwitchToDarkMode: () => settingsController.updateThemeMode(ThemeMode.dark),
                      onSwitchToLightMode: () => settingsController.updateThemeMode(ThemeMode.light),
                    );
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case DashboardView.routeName:
                    return DashboardView(controller: settingsController);
                  case RegisterView.routeName:
                    return const RegisterView();
                  case OtpView.routeName:
                    return const OtpView();
                  case RegisterUserDetailView.routeName:
                    return const RegisterUserDetailView();
                  case SetPinView.routeName:
                    return const SetPinView();
                  case ConsentsView.routeName:
                    return const ConsentsView();
                  case ContractsView.routeName:
                    return const ContractsView();
                  case DownHistoryView.routeName:
                    return DownHistoryView(contractId: routeSettings.arguments as String);
                  case ChangeLanguangeView.routeName:
                    return const ChangeLanguangeView();
                  case ReceiptView.routeName:
                    return ReceiptView(
                      contractNumber: (routeSettings.arguments as Map<String, dynamic>)['contractNumber'] as String,
                      receiptNumber: (routeSettings.arguments as Map<String, dynamic>)['receiptNumber'] as String,
                    );
                  case ReceiptViewFile.routeName:
                    return ReceiptViewFile(
                      contractNumber: (routeSettings.arguments as Map<String, dynamic>)['contractNumber'] as String,
                      receiptNumber: (routeSettings.arguments as Map<String, dynamic>)['receiptNumber'] as String,
                    );
                  case OverduesView.routeName:
                    return OverduesView(contractId: routeSettings.arguments as String);
                  default:
                    // return DashboardView(controller: settingsController);
                    return const SplashView();
                }
              },
            );
          },
        );
      },
    );
  }
}
