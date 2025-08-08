import 'dart:ui';

import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/themes_dark_const.dart';
import 'package:AssetWise/src/consts/themes_light_const.dart';
import 'package:AssetWise/src/features/about_assetwise/about_asswise_view.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view_file.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/favourite_projects/favourite_projects_view.dart';
import 'package:AssetWise/src/features/find_projects/map_search_view.dart';
import 'package:AssetWise/src/features/hot_menues/hot_menues_config_view.dart';
import 'package:AssetWise/src/features/manage_personal_info/manage_personal_info_view.dart';
import 'package:AssetWise/src/features/my_assets/my_assets_view.dart';
import 'package:AssetWise/src/features/my_qr/my_qr_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/features/payments/qr_view.dart';
import 'package:AssetWise/src/features/pin/pin_entry_view.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/profile/profile_view.dart';
import 'package:AssetWise/src/features/projects/projects_view.dart';
import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/features/promotions/promotions_view.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_detail_view.dart';
import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/features/register/existing_users_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:AssetWise/src/features/verify_otp/otp_request_view.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/providers/firebase_provider.dart';
import 'package:AssetWise/src/splash/splash_view.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'features/settings/settings_controller.dart';
import 'features/dashboard/dashboard_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showPinEntry = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _appInit();
        await _afterResumed();
      }
    });

    AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (state == AppLifecycleState.resumed) {
          _afterResumed(isResumed: true);
        }
      },
    );
    context.read<FirebaseMessagingProvider>().initialize();
  }

  // เมื่อเปิดแอป ให้เช็ก pin แล้วตามด้วย consent
  Future<void> _appInit() async {
    final navContext = navigatorKey.currentContext ?? context;
    if (!_showPinEntry) {
      if (navContext.read<UserProvider>().shouldValidatePin) {
        _showPinEntry = true;
        await Navigator.push(navContext, MaterialPageRoute(builder: (context) => const PinEntryView(isBackable: false), fullscreenDialog: true));
        _showPinEntry = false;
      }
    }
    if (navContext.mounted) {
      final userProvider = navContext.read<UserProvider>();
      if (userProvider.userInformation != null) {
        final consentGave = userProvider.userInformation?.consent ?? false;
        if (!consentGave) {
          await Navigator.push(navContext, MaterialPageRoute(builder: (context) => const ConsentsView(consentUpdated: true), fullscreenDialog: true));
        }
      }
    }
  }

  // เมื่อแอปถูก resume ให้ดึงข้อมูล notification และ จะเปิด Dashboard เฉพาะเข้ามาครั้งแรก (isResumed = false สั่งต่อ appInit)
  // เมื่อ resume หน้าที่เปิดค้างจะไม่เปลี่ยน
  Future<void> _afterResumed({bool isResumed = false}) async {
    final navContext = navigatorKey.currentContext ?? context;
    await navContext.read<NotificationItemProvider>().fetchNotificationItems();
    if (navContext.mounted && !isResumed) {
      await Future.wait([Future.delayed(const Duration(seconds: 3)), navContext.read<DashboardProvider>().reload()]);
      Navigator.pushReplacementNamed(navContext, DashboardView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      // SystemChrome.setSystemUIOverlayStyle(
      //   SystemUiOverlayStyle(
      //     systemNavigationBarColor: Colors.transparent,
      //     statusBarBrightness: brightness == Brightness.dark ? Brightness.dark : Brightness.light,
      //   ),
      // );
    }
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('th', ''), // Thai, no country code
          ],
          locale: widget.settingsController.locale, // Set default locale to Thai

          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          theme: mLightTheme,
          darkTheme: mDarkTheme,
          themeMode: widget.settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            final brightness = Theme.of(context).brightness;
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
                statusBarBrightness: brightness == Brightness.dark ? Brightness.dark : Brightness.light,
              ),
            );
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            final routeMap = routeSettings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute<dynamic>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  // case UIShowcaseScreen.routeName:
                  //   return UIShowcaseScreen(
                  //     onSwitchToDarkMode: () => widget.settingsController.updateThemeMode(context, ThemeMode.dark),
                  //     onSwitchToLightMode: () => widget.settingsController.updateThemeMode(context, ThemeMode.light),
                  //   );
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
                    return ContractsView(linkId: routeMap?['linkId'] as String?);
                  case DownHistoryView.routeName:
                    return DownHistoryView(contractId: routeMap!['contractId'] as String);
                  case ChangeLanguangeView.routeName:
                    return const ChangeLanguangeView();
                  case ReceiptView.routeName:
                    return ReceiptView(contractNumber: routeMap!['contractNumber'] as String, receiptNumber: routeMap['receiptNumber'] as String);
                  case ReceiptViewFile.routeName:
                    return ReceiptViewFile(contractNumber: routeMap!['contractNumber'] as String, receiptNumber: routeMap['receiptNumber'] as String);
                  case OverduesView.routeName:
                    return OverduesView(contract: routeMap!['contract'] as Contract);
                  case NotificationsView.routeName:
                    return NotificationsView(selectedIndex: routeMap?['selectedIndex'] ?? 0);
                  case PaymentChannelsView.routeName:
                    return PaymentChannelsView(contract: routeMap!['contract'] as Contract, overdueDetail: routeMap['overdueDetail'] as OverdueDetail?, amount: routeMap['amount'] as double?);
                  case QRView.routeName:
                    return QRView(contract: routeMap!['contract'] as Contract, amount: routeMap['amount'] as double);
                  case PinEntryView.routeName:
                    return PinEntryView(isBackable: routeMap?['isBackable'] as bool?);
                  case OTPRequestView.routeName:
                    return OTPRequestView(forAction: routeMap?['forAction'] as String?, otpFor: routeMap?['otpFor'] as OTPFor);
                  case AboutAsswiseView.routeName:
                    return const AboutAsswiseView();
                  case MyAssetsView.routeName:
                    return const MyAssetsView();
                  case ManagePersonalInfoView.routeName:
                    return const ManagePersonalInfoView();
                  case MapSearchView.routeName:
                    return MapSearchView(textController: routeMap!['textcontroller'] as TextEditingController);
                  case HotMenuesConfigView.routeName:
                    return const HotMenuesConfigView();
                  case ProjectsView.routeName:
                    return const ProjectsView();
                  case MyQrView.routeName:
                    return const MyQrView();
                  case PromotionsView.routeName:
                    return const PromotionsView();
                  case PromotionDetailView.routeName:
                    return PromotionDetailView(promotionId: routeMap!['promotionId'] as int);
                  case ProjectDetailView.routeName:
                    return ProjectDetailView(projectId: routeMap!['projectId'] as int);
                  case FavouriteProjectsView.routeName:
                    return const FavouriteProjectsView();
                  case WebViewWithCloseButton.routeName:
                    return WebViewWithCloseButton(link: routeMap!['link'] as String);
                  case ExistingUsersView.routeName:
                    return const ExistingUsersView();
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
