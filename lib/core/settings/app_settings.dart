import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final instance = AppSettings._();
  static const _languageKey = 'selected_language';
  static const _themeKey = 'selected_theme_mode';

  String languageCode = 'en';
  ThemeMode themeMode = ThemeMode.system;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    languageCode = preferences.getString(_languageKey) ?? 'en';
    themeMode = ThemeMode.values.byName(
      preferences.getString(_themeKey) ?? ThemeMode.system.name,
    );
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    languageCode = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, value);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeKey, value.name);
  }

  static AppSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppSettingsScope>()!.settings;
}

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({super.key, required this.settings, required super.child})
      : super(notifier: settings);

  final AppSettings settings;
}
