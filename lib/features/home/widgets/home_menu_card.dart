import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../model/home_menu_model.dart';

class HomeMenuCard extends StatelessWidget {
  const HomeMenuCard({super.key, required this.menu});
  final HomeMenuModel menu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _text(context, menu.title);
    final isPrimary = menu.title == 'Morning Azkar';
    final cardColor = isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface;
    final foreground = isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => menu.screen)),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isPrimary ? Colors.white24 : theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
              child: Icon(menu.icon, color: isPrimary ? Colors.white : theme.colorScheme.primary),
            ),
            const Spacer(),
            Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(color: foreground, fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Text(_text(context, menu.subtitle), maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: isPrimary ? Colors.white70 : theme.colorScheme.onSurfaceVariant, height: 1.3)),
          ]),
        ),
      ),
    );
  }

  String _text(BuildContext context, String value) {
    const keys = {'Morning Azkar':'morningAzkar','Evening Azkar':'eveningAzkar','After Salah':'afterSalah','Favorites':'favorites','Prophet Prayers':'prophetPrayers','Start with Dhikr':'morningAzkar','Peaceful Rest':'eveningAzkar','Post-prayer dhikr':'afterSalah','Saved prayers':'favorites','Quranic supplications':'authentic'};
    return AppStrings.of(context, keys[value] ?? value);
  }
}
