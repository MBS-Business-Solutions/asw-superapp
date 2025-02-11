import 'package:asset_wise_super_app/src/0_consts/colors_const.dart';
import 'package:asset_wise_super_app/src/0_theme_extensions/bottom_bar_theme.dart';
import 'package:asset_wise_super_app/src/0_theme_extensions/hotmenu_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextTheme mTextTheme = TextTheme(
  titleLarge: GoogleFonts.notoSansThai(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: GoogleFonts.notoSansThai(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  titleSmall: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  //-------------------------------------
  labelLarge: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  labelMedium: GoogleFonts.notoSansThai(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  ),
  labelSmall: GoogleFonts.notoSansThai(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  ),
  //-------------------------------------
  bodyLarge: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: GoogleFonts.notoSansThai(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
  ),
  bodySmall: GoogleFonts.notoSansThai(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.6,
  ),
  //-------------------------------------
  headlineLarge: GoogleFonts.notoSansThai(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  ),
  headlineMedium: GoogleFonts.notoSansThai(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  ),
  headlineSmall: GoogleFonts.notoSansThai(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  //-------------------------------------
  displayLarge: GoogleFonts.notoSansThai(
    fontSize: 57,
    fontWeight: FontWeight.w600,
  ),
  displayMedium: GoogleFonts.notoSansThai(
    fontSize: 45,
    fontWeight: FontWeight.w600,
  ),
  displaySmall: GoogleFonts.notoSansThai(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  ),
);

final ThemeData mLightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: mTextTheme.apply(
    bodyColor: mLightBodyTextColor,
    displayColor: mLightDisplayTextColor,
  ),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    primarySwatch: mPrimaryMatColor,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: mPrimaryMatColor,
    ),
  ),
  badgeTheme: const BadgeThemeData(
    textColor: Colors.white,
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
      iconColor: Color(0xFF787878),
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
    )
  ],
);

final ThemeData mDarkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: mTextTheme.apply(
    bodyColor: mDarkBodyTextColor,
    displayColor: mDarkDisplayTextColor,
  ),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: mPrimaryMatColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: mDarkBackgroundColor,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: mPrimaryMatColor,
    ),
  ),
  badgeTheme: const BadgeThemeData(
    textColor: Colors.white,
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
    )
  ],
);
