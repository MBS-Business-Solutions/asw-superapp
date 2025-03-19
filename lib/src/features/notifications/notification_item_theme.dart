import 'package:flutter/material.dart';

class NotificationItemTileTheme extends ThemeExtension<NotificationItemTileTheme> {
  final Color unreadBackgroundColor;
  final Color unreadHeaderTextColor;
  final Color readHeaderTextColor;
  final Color unreadTextColor;
  final Color readTextColor;
  final Color timeTextColor;
  final Color paymentIconColor;
  final Color paymentIconBackgroundColor;
  final Color promotionIconColor;
  final Color promotionIconBackgroundColor;
  final Color hotDealIconColor;
  final Color hotDealIconBackgroundColor;
  final Color newsIconColor;
  final Color newsIconBackgroundColor;

  const NotificationItemTileTheme({
    required this.unreadBackgroundColor,
    required this.unreadHeaderTextColor,
    required this.readHeaderTextColor,
    required this.unreadTextColor,
    required this.readTextColor,
    required this.timeTextColor,
    required this.paymentIconColor,
    required this.paymentIconBackgroundColor,
    required this.promotionIconColor,
    required this.promotionIconBackgroundColor,
    required this.hotDealIconColor,
    required this.hotDealIconBackgroundColor,
    required this.newsIconColor,
    required this.newsIconBackgroundColor,
  });

  @override
  NotificationItemTileTheme copyWith({
    Color? unreadBackgroundColor,
    Color? unreadHeaderTextColor,
    Color? readHeaderTextColor,
    Color? unreadTextColor,
    Color? readTextColor,
    Color? timeTextColor,
    Color? paymentIconColor,
    Color? paymentIconBackgroundColor,
    Color? promotionIconColor,
    Color? promotionIconBackgroundColor,
    Color? hotDealIconColor,
    Color? hotDealIconBackgroundColor,
    Color? newsIconColor,
    Color? newsIconBackgroundColor,
  }) {
    return NotificationItemTileTheme(
        unreadBackgroundColor: unreadBackgroundColor ?? this.unreadBackgroundColor,
        unreadHeaderTextColor: unreadHeaderTextColor ?? this.unreadHeaderTextColor,
        readHeaderTextColor: readHeaderTextColor ?? this.readHeaderTextColor,
        unreadTextColor: unreadTextColor ?? this.unreadTextColor,
        readTextColor: readTextColor ?? this.readTextColor,
        timeTextColor: timeTextColor ?? this.timeTextColor,
        paymentIconColor: paymentIconColor ?? this.paymentIconColor,
        paymentIconBackgroundColor: paymentIconBackgroundColor ?? this.paymentIconBackgroundColor,
        promotionIconColor: promotionIconColor ?? this.promotionIconColor,
        promotionIconBackgroundColor: promotionIconBackgroundColor ?? this.promotionIconBackgroundColor,
        hotDealIconColor: hotDealIconColor ?? this.hotDealIconColor,
        hotDealIconBackgroundColor: hotDealIconBackgroundColor ?? this.hotDealIconBackgroundColor,
        newsIconColor: newsIconColor ?? this.newsIconColor,
        newsIconBackgroundColor: newsIconBackgroundColor ?? this.newsIconBackgroundColor);
  }

  @override
  ThemeExtension<NotificationItemTileTheme> lerp(covariant ThemeExtension<NotificationItemTileTheme>? other, double t) {
    if (other == null) return this;
    if (other is! NotificationItemTileTheme) return this;
    return NotificationItemTileTheme(
      unreadBackgroundColor: Color.lerp(unreadBackgroundColor, other.unreadBackgroundColor, t)!,
      unreadHeaderTextColor: Color.lerp(unreadHeaderTextColor, other.unreadHeaderTextColor, t)!,
      readHeaderTextColor: Color.lerp(readHeaderTextColor, other.readHeaderTextColor, t)!,
      unreadTextColor: Color.lerp(unreadTextColor, other.unreadTextColor, t)!,
      readTextColor: Color.lerp(readTextColor, other.readTextColor, t)!,
      timeTextColor: Color.lerp(timeTextColor, other.timeTextColor, t)!,
      paymentIconColor: Color.lerp(paymentIconColor, other.paymentIconColor, t)!,
      paymentIconBackgroundColor: Color.lerp(paymentIconBackgroundColor, other.paymentIconBackgroundColor, t)!,
      promotionIconColor: Color.lerp(promotionIconColor, other.promotionIconColor, t)!,
      promotionIconBackgroundColor: Color.lerp(promotionIconBackgroundColor, other.promotionIconBackgroundColor, t)!,
      hotDealIconColor: Color.lerp(hotDealIconColor, other.hotDealIconColor, t)!,
      hotDealIconBackgroundColor: Color.lerp(hotDealIconBackgroundColor, other.hotDealIconBackgroundColor, t)!,
      newsIconColor: Color.lerp(newsIconColor, other.newsIconColor, t)!,
      newsIconBackgroundColor: Color.lerp(newsIconBackgroundColor, other.newsIconBackgroundColor, t)!,
    );
  }
}
