import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../model/home_menu_model.dart';

class HomeMenuCard extends StatelessWidget {
  const HomeMenuCard({super.key, required this.menu});
  final HomeMenuModel menu;

  @override
  Widget build(BuildContext context) {
    final style = _style(
      menu.title,
      Theme.of(context).brightness == Brightness.dark,
    );
    return Material(
      color: style.background,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => menu.screen)),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(menu.icon, color: style.icon, size: 29),
              const Spacer(),
              Text(
                _text(context, menu.title),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: style.foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _text(context, menu.subtitle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: style.foreground.withOpacity(.75),
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: style.foreground.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: style.foreground,
                      size: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CardStyle _style(String title, bool dark) {
    if (dark)
      return const _CardStyle(
        Color(0xFF1C2A26),
        Color(0xFFF1F5F1),
        Color(0xFF8ACCB5),
      );
    return switch (title) {
      'Morning Azkar' => const _CardStyle(
        Color(0xFF00634F),
        Colors.white,
        Color(0xFFF5CD62),
      ),
      'Evening Azkar' => const _CardStyle(
        Color(0xFFFFF8E8),
        Color(0xFF334037),
        Color(0xFFC89419),
      ),
      'After Salah' => const _CardStyle(
        Color(0xFFF4F8F0),
        Color(0xFF314837),
        Color(0xFF496B4A),
      ),
      'After Noon Azkar' => const _CardStyle(
        Color(0xFFEDF7F4),
        Color(0xFF26372D),
        Color(0xFF0B5D4B),
      ),
      'Prophet Prayers' => const _CardStyle(
        Color(0xFFFFF7E1),
        Color(0xFF3A412F),
        Color(0xFFA87713),
      ),
      'Favorites' => const _CardStyle(
        Color(0xFFF8F2FA),
        Color(0xFF44404A),
        Color(0xFFC5545D),
      ),
      _ => const _CardStyle(
        Color(0xFFF0F5FB),
        Color(0xFF394957),
        Color(0xFF557AA2),
      ),
    };
  }

  String _text(BuildContext context, String value) {
    const keys = {
      'Morning Azkar': 'morningAzkar',
      'Evening Azkar': 'eveningAzkar',
      'After Noon Azkar': 'afterNoonAzkar',
      'After Salah': 'afterSalah',
      'Favorites': 'favorites',
      'Prophet Prayers': 'prophetPrayers',
      'Progress': 'progress',
      'Start with Dhikr': 'morningAzkar',
      'Peaceful Rest': 'eveningAzkar',
      'Midday remembrance': 'afterNoonAzkar',
      'Post-prayer dhikr': 'afterSalah',
      'Saved prayers': 'favorites',
      'Quranic supplications': 'authentic',
      'Track your journey': 'progress',
    };
    return AppStrings.of(context, keys[value] ?? value);
  }
}

class _CardStyle {
  const _CardStyle(this.background, this.foreground, this.icon);
  final Color background;
  final Color foreground;
  final Color icon;
}
