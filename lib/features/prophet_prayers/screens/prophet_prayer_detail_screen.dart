import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/prophet_prayer.dart';
import '../widgets/prophet_language_selector.dart';

class ProphetPrayerDetailScreen extends StatefulWidget {
  const ProphetPrayerDetailScreen({super.key, required this.prayer, required this.initialLanguage});

  final ProphetPrayer prayer;
  final String initialLanguage;

  @override
  State<ProphetPrayerDetailScreen> createState() => _ProphetPrayerDetailScreenState();
}

class _ProphetPrayerDetailScreenState extends State<ProphetPrayerDetailScreen> {
  late String _language;

  @override
  void initState() { super.initState(); _language = widget.initialLanguage; }

  @override
  Widget build(BuildContext context) {
    final prayer = widget.prayer;
    return Scaffold(
      appBar: AppBar(title: Text(prayer.prophet.value(_language)), actions: [ProphetLanguageSelector(value: _language, onChanged: (value) => setState(() => _language = value)), const SizedBox(width: 8)]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(prayer.prophet.value(_language), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        Text(prayer.duaArabic, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 2)),
        const SizedBox(height: 24),
        Text(prayer.translation.value(_language), style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.7)),
        const SizedBox(height: 20),
        Text(prayer.reference.display, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: () async { await Clipboard.setData(ClipboardData(text: prayer.duaArabic)); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prayer copied'))); }, icon: const Icon(Icons.copy), label: const Text('Copy Arabic prayer')),
      ]),
    );
  }
}
