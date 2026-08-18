import 'package:azkar_app/features/home/view/azkar_category_screen.dart';
import 'package:azkar_app/features/home/view/evening_screen.dart';
import 'package:azkar_app/features/home/view/favorites_screen.dart';
import 'package:azkar_app/features/home/models/azkar_category.dart';
import 'package:flutter/material.dart';
import '../model/home_menu_model.dart';
import '../view/morning_azkar.dart';
import '../view/progress_screen.dart';
import '../../prophet_prayers/screens/prophet_prayers_screen.dart';

const List<HomeMenuModel> menus = [
  HomeMenuModel(
    title: "Morning Azkar",
    subtitle: "Start with Dhikr",
    icon: Icons.wb_sunny_outlined,
    backgroundColor: Color(0xFF0B5D4B),
    iconColor: Colors.white,
    textColor: Colors.white,
    subtitleColor: Colors.white,
    screen: MorningScreen(),
  ),

  HomeMenuModel(
    title: "Evening Azkar",
    subtitle: "Peaceful Rest",
    icon: Icons.nights_stay_outlined,
    backgroundColor: Colors.white,
    iconColor: Color(0xFF0B5D4B),
    textColor: Colors.black,
    subtitleColor: Colors.black,
    screen: EveningScreen(),
  ),

  HomeMenuModel(
    title: "After Noon Azkar",
    subtitle: "Midday remembrance",
    icon: Icons.wb_twilight,
    backgroundColor: Color(0xFFEDF7F4),
    iconColor: Color(0xFF0B5D4B),
    textColor: Colors.black,
    subtitleColor: Colors.black,
    screen: AzkarCategoryScreen(category: AzkarCategory.afterNoon),
  ),

  HomeMenuModel(
    title: "After Salah",
    subtitle: "Post-prayer dhikr",
    icon: Icons.menu_book_outlined,
    backgroundColor: Colors.white,
    iconColor: Color(0xFFB8860B),
    textColor: Colors.black,
    subtitleColor: Colors.black,
    screen: AzkarCategoryScreen(category: AzkarCategory.afterSalah),
  ),

  HomeMenuModel(
    title: "Favorites",
    subtitle: "Saved prayers",
    icon: Icons.favorite,
    backgroundColor: Colors.white,
    iconColor: Color(0xFFB8860B),
    textColor: Colors.black,
    subtitleColor: Colors.black,
    screen: FavoritesScreen(),
  ),

  HomeMenuModel(
    title: "Prophet Prayers",
    subtitle: "Quranic supplications",
    icon: Icons.volunteer_activism_outlined,
    backgroundColor: Color(0xFFE8F5F0),
    iconColor: Color(0xFF0B5D4B),
    textColor: Colors.black,
    subtitleColor: Colors.black,
    screen: ProphetPrayersScreen(),
  ),

  HomeMenuModel(
    title: "Progress",
    subtitle: "Track your journey",
    icon: Icons.insights_outlined,
    backgroundColor: Color(0xFFEAF1FA),
    iconColor: Color(0xFF3D6795),
    textColor: Colors.black,
    subtitleColor: Colors.black,
    screen: ProgressScreen(),
  ),
];
