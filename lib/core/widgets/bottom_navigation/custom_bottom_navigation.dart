import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labels = ['home', 'morning', 'evening', 'progress', 'settings'];
    final icons = [Icons.home_outlined, Icons.wb_sunny_outlined, Icons.nights_stay_outlined, Icons.insights_outlined, Icons.settings_outlined];
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: List.generate(labels.length, (index) => NavigationDestination(
        icon: Icon(icons[index]),
        selectedIcon: Icon(icons[index], color: scheme.onSecondaryContainer),
        label: AppStrings.of(context, labels[index]),
      )),
    );
  }
}
