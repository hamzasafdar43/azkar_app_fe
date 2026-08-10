import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insights_outlined, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 18),
              Text(AppStrings.of(context, 'progress'), style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(
                'Track your journey with daily dhikr progress and saved reflections.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
