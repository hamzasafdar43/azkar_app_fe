import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/settings/app_settings.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const _languages = [('ar', 'العربية'), ('en', 'English'), ('ur', 'اردو'), ('fr', 'Français')];

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);
    final t = AppStrings.of;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(t(context, 'settings'), style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 24),
      _SectionTitle(icon: Icons.language_outlined, title: t(context, 'language')),
      Card(child: Column(children: _languages.map((language) => RadioListTile<String>(
        value: language.$1, groupValue: settings.languageCode,
        onChanged: (value) { if (value != null) settings.setLanguage(value); },
        title: Text(language.$2),
      )).toList())),
      const SizedBox(height: 24),
      _SectionTitle(icon: Icons.palette_outlined, title: t(context, 'appearance')),
      Card(child: Column(children: [
        RadioListTile<ThemeMode>(value: ThemeMode.system, groupValue: settings.themeMode, onChanged: (value) { if (value != null) settings.setThemeMode(value); }, title: Text(t(context, 'system'))),
        RadioListTile<ThemeMode>(value: ThemeMode.light, groupValue: settings.themeMode, onChanged: (value) { if (value != null) settings.setThemeMode(value); }, title: Text(t(context, 'light'))),
        RadioListTile<ThemeMode>(value: ThemeMode.dark, groupValue: settings.themeMode, onChanged: (value) { if (value != null) settings.setThemeMode(value); }, title: Text(t(context, 'dark'))),
      ])),
    ]);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium)]),
  );
}
