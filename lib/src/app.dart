import 'dart:ui';

import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/0_test/ui_showcase_screen.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view_file.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/features/payments/qr_view.dart';
import 'package:AssetWise/src/features/pin/pin_entry_view.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/features/register/otp_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/firebase_service.dart';
import 'package:AssetWise/src/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'features/settings/settings_controller.dart';

import 'features/dashboard/dashboard_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showShield = false;

  @override
  void initState() {
    AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (state == AppLifecycleState.inactive) {
          // ใช้ addPostFrameCallback เพื่อให้ UI มีโอกาสอัปเดตก่อนแอปไป Background
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _showShield = true);
            }
          });
        } else if (state == AppLifecycleState.resumed) {
          _afterResumed();
        }
      },
    );
    super.initState();
  }

  Future<void> _afterResumed() async {
    final isPinSet = context.read<UserProvider>().isPinSet;
    if (isPinSet && !isPinEntryVisible) {
      await Navigator.push(
        navigatorKey.currentContext ?? context,
        MaterialPageRoute(
          builder: (context) => const PinEntryView(),
          fullscreenDialog: true,
        ),
      );
    }
    if (mounted) setState(() => _showShield = false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    context.read<FirebaseMessagingService>().initialize();

    return MaterialApp(
      navigatorKey: navigatorKey,
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
      locale: widget.settingsController.locale, // Set default locale to Thai
      theme: mLightTheme,
      darkTheme: mDarkTheme,
      themeMode: widget.settingsController.themeMode,
      home: Stack(
        children: [
          ListenableBuilder(
            listenable: widget.settingsController,
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                // Providing a restorationScopeId allows the Navigator built by the
                // MaterialApp to restore the navigation stack when a user leaves and
                // returns to the app after it has been killed while running in the
                // background.
                // navigatorKey: navigatorKey,

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
                locale: widget.settingsController.locale, // Set default locale to Thai

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
                themeMode: widget.settingsController.themeMode,

                // Define a function to handle named routes in order to support
                // Flutter web url navigation and deep linking.
                onGenerateRoute: (RouteSettings routeSettings) {
                  return MaterialPageRoute<void>(
                    settings: routeSettings,
                    builder: (BuildContext context) {
                      switch (routeSettings.name) {
                        case UIShowcaseScreen.routeName:
                          return UIShowcaseScreen(
                            onSwitchToDarkMode: () => widget.settingsController.updateThemeMode(ThemeMode.dark),
                            onSwitchToLightMode: () => widget.settingsController.updateThemeMode(ThemeMode.light),
                          );
                        case DashboardView.routeName:
                          return DashboardView(controller: widget.settingsController);
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
                          return ContractsView(
                            openContractId: routeSettings.arguments as String?,
                          );
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
                          return OverduesView(contract: routeSettings.arguments as Contract);
                        case NotificationsView.routeName:
                          return const NotificationsView();
                        case PaymentChannelsView.routeName:
                          return PaymentChannelsView(
                            contract: (routeSettings.arguments as Map<String, dynamic>)['contract'] as Contract,
                            overdueDetail: (routeSettings.arguments as Map<String, dynamic>)['overdueDetail'] as OverdueDetail?,
                            amount: (routeSettings.arguments as Map<String, dynamic>)['amount'] as double?,
                          );
                        case QRView.routeName:
                          return QRView(
                            contract: (routeSettings.arguments as Map<String, dynamic>)['contract'] as Contract,
                            amount: (routeSettings.arguments as Map<String, dynamic>)['amount'] as double,
                          );
                        default:
                          // return DashboardView(controller: settingsController);
                          return const SplashView();
                      }
                    },
                  );
                },
              );
            },
          ),
          if (_showShield) _ShieldGuard(),
        ],
      ),
    );
  }
}

// วิดเจ็ตหน้าป้องกัน
class _ShieldGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: (brightness == Brightness.dark ? mDarkBackgroundBottomBar : mLightBackgroundBottomBar).withOpacity(0.3),
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/ASW_Logo_Rac_dark-bg.svg',
              colorFilter: ColorFilter.mode(brightness == Brightness.dark ? Colors.white : mAssetWiseLogoColor, BlendMode.srcIn),
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
