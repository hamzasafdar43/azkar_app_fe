import 'package:flutter/material.dart';

import '../model/home_menu_model.dart';

class HomeMenuCard extends StatelessWidget {
  final HomeMenuModel menu;

  const HomeMenuCard({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: menu.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            menu.icon,
            color: menu.iconColor,
            size: 28,
          ),

          const Spacer(),

          Text(
            menu.title,
            style: TextStyle(
              color: menu.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            menu.subtitle,
            style: TextStyle(
              color: menu.subtitleColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}