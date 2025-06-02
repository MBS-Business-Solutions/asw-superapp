import 'package:flutter/material.dart';

class HotMenuTheme extends ThemeExtension<HotMenuTheme> {
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final List<BoxShadow>? boxShadow;

  const HotMenuTheme({
    this.backgroundGradient,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.boxShadow,
  });

  @override
  ThemeExtension<HotMenuTheme> copyWith({
    Gradient? backgroundGradient,
    Color? borderColor,
    Color? textColor,
    Color? iconColor,
    List<BoxShadow>? boxShadow,
  }) {
    return HotMenuTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  ThemeExtension<HotMenuTheme> lerp(covariant ThemeExtension<HotMenuTheme>? other, double t) {
    if (other == null) return this;
    if (other is! HotMenuTheme) return this;
    return HotMenuTheme(
      backgroundGradient: Gradient.lerp(backgroundGradient, other.backgroundGradient, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      boxShadow: BoxShadow.lerpList(boxShadow, other.boxShadow, t),
    );
  }
}
