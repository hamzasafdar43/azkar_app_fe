import 'package:azkar_app/features/home/models/azkar_category.dart';
import 'package:azkar_app/features/home/view/azkar_category_screen.dart';
import 'package:flutter/material.dart';

class MorningScreen extends StatelessWidget {
  const MorningScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const AzkarCategoryScreen(category: AzkarCategory.morning);
}
