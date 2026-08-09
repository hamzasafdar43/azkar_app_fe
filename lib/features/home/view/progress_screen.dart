import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import 'morning_azkar.dart';
class ProgressScreen extends StatelessWidget { const ProgressScreen({super.key}); @override Widget build(BuildContext context) => AzkarPlaceholder(title: AppStrings.of(context, 'progress'), icon: Icons.insights_outlined); }
