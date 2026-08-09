import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/prophet_prayer.dart';

class ProphetPrayerCard extends StatelessWidget {
  const ProphetPrayerCard({super.key, required this.prayer, required this.languageCode, required this.onTap});

  final ProphetPrayer prayer;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(prayer.prophet.value(languageCode), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text(prayer.duaArabic, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.8)),
              const SizedBox(height: 10),
              Text(prayer.translation.value(languageCode), style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
              const SizedBox(height: 8),
              Row(children: [
                Chip(label: Text(prayer.reference.display)),
                const Spacer(),
                IconButton(
                  tooltip: 'Copy prayer',
                  icon: const Icon(Icons.copy_outlined),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: prayer.duaArabic));
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prayer copied')));
                  },
                ),
              ]),
            ]),
          ),
        ),
      );
}
