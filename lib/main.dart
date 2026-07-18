import 'package:flutter/material.dart';

import './home.dart';

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