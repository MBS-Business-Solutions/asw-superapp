import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/features/notifications/notification_item_theme.dart';
import 'package:AssetWise/src/theme_extensions/bottom_bar_theme.dart';
import 'package:AssetWise/src/theme_extensions/hotmenu_theme.dart';
import 'package:flutter/material.dart';

final ThemeData mLightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    titleTextStyle: mTextTheme.titleSmall!.copyWith(
      color: mLightBodyTextColor,
    ),
  ),
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => const Icon(
      Icons.arrow_back_ios,
    ),
  ),
  scaffoldBackgroundColor: mLightBackgroundColor,
  textTheme: mTextTheme.apply(
    bodyColor: mLightBodyTextColor,
    displayColor: mLightDisplayTextColor,
  ),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    primarySwatch: mPrimaryMatColor,
    cardColor: mLightCardBackgroundColor,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: mLightOutlinedButtonColor,
      ),
      backgroundColor: mLightOutlinedBackgroundColor,
      foregroundColor: mLightOutlinedTextColor,
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
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: mPrimaryMatColor,
      disabledBackgroundColor: mLightGreyColor,
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
  checkboxTheme: CheckboxThemeData(
    checkColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return mLightBodyTextColor;
      } else {
        return mLightGreyColor;
      }
    }),
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return mBrightPrimaryColor;
      } else {
        return Colors.white;
      }
    }),
    side: const BorderSide(
      color: mGreyColor,
    ),
  ),
  extensions: const [
    BottomBarTheme(
      backgroundColor: mLightBackgroundBottomBar,
      borderColor: Colors.white24,
      staticTextColor: mLightBottomBarTextColor,
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
      textColor: Color(0xFF444444),
      borderColor: Colors.white10,
      backgroundGradient: LinearGradient(
        colors: [Colors.white, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 0,
          blurRadius: 10.6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    NotificationItemTileTheme(
      unreadBackgroundColor: mTileWarnLightColor,
      unreadHeaderTextColor: mRedColor,
      readHeaderTextColor: mRedColor,
      unreadTextColor: mLightBodyTextColor,
      readTextColor: mLightBodyTextColor,
      timeTextColor: mLightBodyTextColor,
      paymentIconColor: Colors.white,
      paymentIconBackgroundColor: mRedColor,
      promotionIconColor: Colors.white,
      promotionIconBackgroundColor: mRedColor,
      hotDealIconColor: Colors.white,
      hotDealIconBackgroundColor: mRedColor,
      newsIconColor: Colors.white,
      newsIconBackgroundColor: mRedColor,
    ),
  ],
);
