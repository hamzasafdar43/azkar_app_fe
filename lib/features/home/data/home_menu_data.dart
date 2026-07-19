import 'package:azkar_app/features/home/view/evening_screen.dart';
import 'package:flutter/material.dart';
import '../model/home_menu_model.dart';
import '../view/morning_azkar.dart';


const List<HomeMenuModel> menus = [

  HomeMenuModel(
    title: "Morning Azkar",
    subtitle: "Start with Dhikr",
    icon: Icons.wb_sunny_outlined,
    backgroundColor: Color(0xFF0B5D4B),
    iconColor: Colors.white,
    textColor :Colors.white,
    subtitleColor :Colors.white,
    screen: MorningScreen(),
  ),

  HomeMenuModel(
    title: "Evening Azkar",
    subtitle: "Peaceful Rest",
    icon: Icons.nights_stay_outlined,
    backgroundColor: Colors.white,
    iconColor: Color(0xFF0B5D4B),
    textColor :Colors.black,
    subtitleColor : Colors.black,
    screen: EveningScreen(),
  ),

  HomeMenuModel(
    title: "After Salah",
    subtitle: "Post-prayer dhikr",
    icon: Icons.menu_book_outlined,
    backgroundColor: Colors.white,
    iconColor: Color(0xFFB8860B),
    textColor :Colors.black,
    subtitleColor : Colors.black,
    screen: EveningScreen(),
  ),

  HomeMenuModel(
    title: "Favorites",
    subtitle: "Saved prayers",
    icon: Icons.favorite,
    backgroundColor: Colors.white,
    iconColor: Color(0xFFB8860B),
    textColor :Colors.black,
    subtitleColor : Colors.black,
    screen: EveningScreen(),
  ),
];