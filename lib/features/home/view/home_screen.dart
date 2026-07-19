import 'package:flutter/material.dart';

import '../../../core/widgets/app_bar/home_app_bar.dart';
import '../../../core/widgets/bottom_navigation/custom_bottom_navigation.dart';

import '../view/morning_azkar.dart';
import '../view/home_content.dart';
import '../view/evening_screen.dart';
import '../view/progress_screen.dart';
import '../view/setting_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    MorningScreen(),
    EveningScreen(),
    ProgressScreen(),
    SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: HomeAppBar(
          greeting: "Assalamu Alaikum",
        ),
      ),

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}