import 'package:azkar_app/features/home/models/azkar_category.dart';
import 'package:azkar_app/features/home/view/azkar_category_screen.dart';
import 'package:flutter/material.dart';

class EveningScreen extends StatelessWidget {
  const EveningScreen({super.key});

  @override
  Widget build(BuildContext context) => const AzkarCategoryScreen(category: AzkarCategory.evening);
}
