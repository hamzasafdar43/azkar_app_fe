import 'package:flutter/material.dart';

import '../../../core/settings/app_settings.dart';

class ProphetLanguageSelector extends StatelessWidget {
  const ProphetLanguageSelector({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const _languages = [('ar', 'العربية'), ('en', 'English'), ('ur', 'اردو'), ('fr', 'Français')];

  @override
  Widget build(BuildContext context) => DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.translate),
        onChanged: (language) {
          if (language != null) {
            AppSettings.of(context).setLanguage(language);
            onChanged(language);
          }
        },
        items: _languages.map((language) => DropdownMenuItem(value: language.$1, child: Text(language.$2))).toList(),
      );
}
