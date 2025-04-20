import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Google fonts มีบั๊กไม่สามรถปรับ fontWeight โดย copyWith ได้
//https://github.com/material-foundation/google-fonts-flutter/issues/141

final TextTheme mTabBarTextTheme = TextTheme(
  titleLarge: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
  titleMedium: GoogleFonts.notoSansThai(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  titleSmall: GoogleFonts.notoSansThai(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  ),
);

final TextTheme mTextTheme = TextTheme(
  titleLarge: GoogleFonts.notoSansThai(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: GoogleFonts.notoSansThai(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
  titleSmall: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  //-------------------------------------
  labelLarge: GoogleFonts.notoSansThai(
    fontSize: 16,
    fontWeight: FontWeight.w600,
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
