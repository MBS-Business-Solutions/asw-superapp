import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  late Locale _locale;

  Locale get locale => _locale;

  late SupportedLocales _selectedLocale;
  SupportedLocales get supportedLocales => _selectedLocale;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // ทำให้โปร่งใส
      statusBarIconBrightness: _themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark, // เปลี่ยนสีไอคอน
    ));

    _locale = await _settingsService.locale();
    _selectedLocale = SupportedLocales.values.firstWhere((element) => element.locale == _locale.languageCode);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // ทำให้โปร่งใส
      statusBarIconBrightness: _themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark, // เปลี่ยนสีไอคอน
    ));
    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLocale(SupportedLocales newLocale) async {
    _selectedLocale = newLocale;
    _locale = Locale(_selectedLocale.locale);
    await _settingsService.updateLocale(_locale);
    notifyListeners();
  }
}

enum SupportedLocales {
  en('en', 'English(US)'),
  th('th', 'ไทย(ไทย)');

  final String locale;
  final String language;

  const SupportedLocales(this.locale, this.language);
}
