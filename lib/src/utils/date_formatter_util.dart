import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateFormatterUtil {
  static String _getAppLocale(BuildContext context) {
    return context.read<SettingsController>().supportedLocales.locale;
  }

  static String formatShortDate(BuildContext context, DateTime? date, [String nullValue = '']) {
    if (date == null) return nullValue;
    final locale = _getAppLocale(context);
    int year = date.year;
    if (locale == 'th') {
      year += 543;
    }
    return '${DateFormat('dd MMM', locale).format(date)} $year';
  }

  static String formatFullDate(BuildContext context, DateTime date) {
    final locale = _getAppLocale(context);
    int year = date.year;
    if (locale == 'th') {
      year += 543;
    }
    return '${DateFormat('dd MMMM', locale).format(date)} $year';
  }

  static String formatTime(BuildContext context, DateTime date) {
    final locale = _getAppLocale(context);
    return DateFormat.jm(locale).format(date);
  }
}
