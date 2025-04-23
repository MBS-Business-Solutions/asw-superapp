import 'package:flutter/material.dart';

class NotificationItemTileTheme extends ThemeExtension<NotificationItemTileTheme> {
  final Color unreadPaymentBackgroundColor;
  final Color unreadPaymentHeaderTextColor;
  final Color unreadOtherBackgroundColor;
  final Color unreadOtherHeaderTextColor;
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
    required this.unreadPaymentBackgroundColor,
    required this.unreadPaymentHeaderTextColor,
    required this.unreadOtherBackgroundColor,
    required this.unreadOtherHeaderTextColor,
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
    Color? unreadPaymentBackgroundColor,
    Color? unreadPaymentHeaderTextColor,
    Color? unreadOtherBackgroundColor,
    Color? unreadOtherHeaderTextColor,
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
        unreadPaymentBackgroundColor: unreadPaymentBackgroundColor ?? this.unreadPaymentBackgroundColor,
        unreadPaymentHeaderTextColor: unreadPaymentHeaderTextColor ?? this.unreadPaymentHeaderTextColor,
        unreadOtherBackgroundColor: unreadOtherBackgroundColor ?? this.unreadOtherBackgroundColor,
        unreadOtherHeaderTextColor: unreadOtherHeaderTextColor ?? this.unreadOtherHeaderTextColor,
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
      unreadPaymentBackgroundColor: Color.lerp(unreadPaymentBackgroundColor, other.unreadPaymentBackgroundColor, t)!,
      unreadPaymentHeaderTextColor: Color.lerp(unreadPaymentHeaderTextColor, other.unreadPaymentHeaderTextColor, t)!,
      unreadOtherBackgroundColor: Color.lerp(unreadOtherBackgroundColor, other.unreadOtherBackgroundColor, t)!,
      unreadOtherHeaderTextColor: Color.lerp(unreadOtherHeaderTextColor, other.unreadOtherHeaderTextColor, t)!,
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
