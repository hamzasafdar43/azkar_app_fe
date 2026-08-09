import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import 'morning_azkar.dart';
class EveningScreen extends StatelessWidget { const EveningScreen({super.key}); @override Widget build(BuildContext context) => AzkarPlaceholder(title: AppStrings.of(context, 'eveningAzkar'), icon: Icons.nights_stay_outlined); }
