import 'package:azkar_app/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const NoorAlaNoorApp());
}

class NoorAlaNoorApp extends StatelessWidget {
  const NoorAlaNoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noor Ala Noor – Azkar',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}