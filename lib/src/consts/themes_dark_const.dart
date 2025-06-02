import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/features/notifications/widgets/notification_item_theme.dart';
import 'package:AssetWise/src/theme_extensions/bottom_bar_theme.dart';
import 'package:AssetWise/src/theme_extensions/hotmenu_theme.dart';
import 'package:flutter/material.dart';

final ThemeData mDarkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    titleTextStyle: mTextTheme.titleSmall!.copyWith(
      color: mDarkBodyTextColor,
    ),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => const Icon(
      Icons.arrow_back_ios,
    ),
  ),
  scaffoldBackgroundColor: mDarkBackgroundColor,
  textTheme: mTextTheme.apply(
    bodyColor: mDarkBodyTextColor,
    displayColor: mDarkDisplayTextColor,
  ),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: mPrimaryMatColor,
    cardColor: mDarkCardBackgroundColor,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: mDarkOutlinedButtonColor,
      ),
      backgroundColor: mDarkOutlinedBackgroundColor,
      foregroundColor: mDarkOutlinedTextColor,
    ),
  ),
  switchTheme: SwitchThemeData(trackColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return mLightGreyColor;
    } else if (states.contains(WidgetState.selected)) {
      return mPrimaryMatColor;
    }
    return mLightGreyColor;
  })),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: mDarkBackgroundColor,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: mPrimaryMatColor,
      disabledBackgroundColor: mGreyColor,
    ),
  ),
  badgeTheme: const BadgeThemeData(
    textColor: Colors.white,
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.only(left: 24, right: 24),
    subtitleTextStyle: TextStyle(
      color: Color(0xFF787878),
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.withOpacity(0.2),
  ),
  extensions: const [
    BottomBarTheme(
      backgroundColor: mDarkBackgroundBottomBar,
      borderColor: Colors.white24,
      staticTextColor: mDarkBottomBarTextColor,
      selectedTextColor: mPrimaryMatColor,
      highlightGradient: LinearGradient(
        colors: [
          mGoldenGradientStart,
          mGoldenGradientEnd,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    HotMenuTheme(
      iconColor: Color(0xFFDAB269),
      textColor: Colors.white,
      borderColor: Colors.white10,
      backgroundGradient: LinearGradient(
        colors: [Color.fromARGB(255, 56, 56, 56), Color.fromRGBO(39, 39, 39, 1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x40AAAAAA),
          spreadRadius: 0,
          blurRadius: 12.6,
          offset: Offset(0, 0),
        ),
      ],
    ),
    NotificationItemTileTheme(
      unreadPaymentBackgroundColor: mTileWarnDarkColor,
      unreadPaymentHeaderTextColor: mDarkBodyTextColor,
      unreadOtherBackgroundColor: Color(0xFF1B1A1A),
      unreadOtherHeaderTextColor: mDarkBodyTextColor,
      readHeaderTextColor: mDarkBodyTextColor,
      unreadTextColor: mDarkBodyTextColor,
      readTextColor: mDarkBodyTextColor,
      timeTextColor: mDarkBodyTextColor,
      paymentIconColor: Colors.white,
      paymentIconBackgroundColor: mRedColor,
      promotionIconColor: Color(0xFF139F4B),
      promotionIconBackgroundColor: Color(0xFFE5F4F3),
      hotDealIconColor: mRedColor,
      hotDealIconBackgroundColor: Color(0xFFFFF4F1),
      newsIconColor: Colors.white,
      newsIconBackgroundColor: mRedColor,
    ),
  ],
);
