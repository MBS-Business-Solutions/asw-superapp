import 'package:flutter/material.dart';

class BottomBarTheme extends ThemeExtension<BottomBarTheme> {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? staticTextColor;
  final Color? selectedTextColor;
  final Gradient? highlightGradient;

  const BottomBarTheme({
    this.backgroundColor,
    this.borderColor,
    this.staticTextColor,
    this.selectedTextColor,
    this.highlightGradient,
  });

  @override
  ThemeExtension<BottomBarTheme> copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? staticTextColor,
    Color? selectedTextColor,
    Gradient? highlightGradient,
  }) {
    return BottomBarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      staticTextColor: staticTextColor ?? this.staticTextColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      highlightGradient: highlightGradient ?? this.highlightGradient,
    );
  }

  @override
  ThemeExtension<BottomBarTheme> lerp(covariant ThemeExtension<BottomBarTheme>? other, double t) {
    if (other == null) return this;
    if (other is! BottomBarTheme) return this;
    return BottomBarTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      staticTextColor: Color.lerp(staticTextColor, other.staticTextColor, t),
      selectedTextColor: Color.lerp(selectedTextColor, other.selectedTextColor, t),
      highlightGradient: Gradient.lerp(highlightGradient, other.highlightGradient, t),
    );
  }
}
