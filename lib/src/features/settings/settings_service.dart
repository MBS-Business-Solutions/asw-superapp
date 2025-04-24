import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final shared = await SharedPreferences.getInstance();
    return ThemeMode.values[shared.getInt('THEME_MODE') ?? ThemeMode.light.index];
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final shared = await SharedPreferences.getInstance();
    shared.setInt('THEME_MODE', theme.index);
  }

  Future<void> updateLocale(Locale newLocale) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString('APP_LOCALE', newLocale.languageCode);
  }

  Future<Locale> locale() async {
    final shared = await SharedPreferences.getInstance();
    return Locale(shared.getString('APP_LOCALE') ?? 'th');
  }
}
