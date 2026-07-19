import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0B5D4B);
    const Color inactiveColor = Colors.grey;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEAEAEA),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: "Home",
                selected: currentIndex == 0,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.wb_sunny_outlined,
                label: "Morning",
                selected: currentIndex == 1,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.nights_stay_outlined,
                label: "Evening",
                selected: currentIndex == 2,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.show_chart,
                label: "Progress",
                selected: currentIndex == 3,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: "Settings",
                selected: currentIndex == 4,
                activeColor: primaryColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? activeColor : inactiveColor,
                fontSize: 12,
                fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}