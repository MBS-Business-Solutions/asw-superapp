import 'dart:ui';

import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/0_test/ui_showcase_screen.dart';
import 'package:AssetWise/src/features/about_assetwise/about_asswise_view.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view_file.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/manage_personal_info/manage_personal_info_view.dart';
import 'package:AssetWise/src/features/my_assets/my_assets_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/features/payments/qr_view.dart';
import 'package:AssetWise/src/features/pin/pin_entry_view.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/profile/profile_view.dart';
import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:AssetWise/src/features/verify_otp/otp_request_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/providers/firebase_provider.dart';
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
  bool _showPinEntry = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _afterResumed();
      }
    });
    // AppLifecycleListener(
    //   onStateChange: (AppLifecycleState state) {
    //     if (state == AppLifecycleState.inactive) {
    //       // ใช้ addPostFrameCallback เพื่อให้ UI มีโอกาสอัปเดตก่อนแอปไป Background
    //       SchedulerBinding.instance.addPostFrameCallback((_) {
    //         if (mounted) {
    //           setState(() => _showShield = true);
    //         }
    //       });
    //     } else if (state == AppLifecycleState.resumed) {
    //       _afterResumed();
    //     }
    //   },
    // );
  }

  Future<void> _afterResumed() async {
    if (!_showPinEntry) {
      if (context.read<UserProvider>().shouldValidatePin) {
        _showPinEntry = true;
        await Navigator.push(
          navigatorKey.currentContext ?? context,
          MaterialPageRoute(
            builder: (context) => const PinEntryView(),
            fullscreenDialog: true,
          ),
        );
        _showPinEntry = false;
      } else if (context.read<UserProvider>().shouldValidateOTP) {
        _showPinEntry = true;
        await Navigator.push(
          navigatorKey.currentContext ?? context,
          MaterialPageRoute(
            builder: (context) => OTPRequestView(
              otpFor: OTPFor.reLogin,
              forAction: AppLocalizations.of(context)!.otpRequestActionReLogin,
              isBackable: false,
              canLoginAsResident: true,
            ),
            fullscreenDialog: true,
          ),
        );
        _showPinEntry = false;
      }
    }
    if (mounted) {
      context.read<NotificationItemProvider>().fetchNotificationItems();
      setState(() => _showShield = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent, statusBarBrightness: Theme.of(context).brightness),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    context.read<FirebaseMessagingProvider>().initialize();

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
                  final routeMap = routeSettings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute<dynamic>(
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
                        case ProfileView.routeName:
                          return const ProfileView();
                        case RegisterView.routeName:
                          return const RegisterView();
                        case RegisterUserDetailView.routeName:
                          return const RegisterUserDetailView();
                        case SetPinView.routeName:
                          return SetPinView(skipable: routeMap?['skipable'] as bool?);
                        case ConsentsView.routeName:
                          return const ConsentsView();
                        case ContractsView.routeName:
                          return ContractsView(
                            linkId: routeMap?['linkId'] as String?,
                          );
                        case DownHistoryView.routeName:
                          return DownHistoryView(contractId: routeMap!['contractId'] as String);
                        case ChangeLanguangeView.routeName:
                          return const ChangeLanguangeView();
                        case ReceiptView.routeName:
                          return ReceiptView(
                            contractNumber: routeMap!['contractNumber'] as String,
                            receiptNumber: routeMap['receiptNumber'] as String,
                          );
                        case ReceiptViewFile.routeName:
                          return ReceiptViewFile(
                            contractNumber: routeMap!['contractNumber'] as String,
                            receiptNumber: routeMap['receiptNumber'] as String,
                          );
                        case OverduesView.routeName:
                          return OverduesView(contract: routeMap!['contract'] as Contract);
                        case NotificationsView.routeName:
                          return NotificationsView(
                            selectedIndex: routeMap?['selectedIndex'] ?? 0,
                          );
                        case PaymentChannelsView.routeName:
                          return PaymentChannelsView(
                            contract: routeMap!['contract'] as Contract,
                            overdueDetail: routeMap['overdueDetail'] as OverdueDetail?,
                            amount: routeMap['amount'] as double?,
                          );
                        case QRView.routeName:
                          return QRView(
                            contract: routeMap!['contract'] as Contract,
                            amount: routeMap['amount'] as double,
                          );
                        case PinEntryView.routeName:
                          return PinEntryView(
                            isBackable: routeMap?['isBackable'] as bool?,
                          );
                        case OTPRequestView.routeName:
                          return OTPRequestView(
                            forAction: routeMap?['forAction'] as String?,
                            otpFor: routeMap?['otpFor'] as OTPFor,
                          );
                        case AboutAsswiseView.routeName:
                          return const AboutAsswiseView();
                        case MyAssetsView.routeName:
                          return const MyAssetsView();
                        case ManagePersonalInfoView.routeName:
                          return const ManagePersonalInfoView();
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
