import 'package:asset_wise_super_app/src/consts/colors_const.dart';
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
  ),
  //-------------------------------------
  displayLarge: GoogleFonts.notoSansThai(
    fontSize: 34,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: GoogleFonts.notoSansThai(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: GoogleFonts.notoSansThai(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  ),
  //-------------------------------------
  headlineLarge: GoogleFonts.notoSansThai(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  headlineMedium: GoogleFonts.notoSansThai(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  headlineSmall: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
);

final ThemeData mLightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: mTextTheme,
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
);

final ThemeData mDarkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: mTextTheme,
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
);
