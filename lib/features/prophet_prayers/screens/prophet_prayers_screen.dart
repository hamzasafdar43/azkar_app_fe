import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/settings/app_settings.dart';

import '../models/prophet_prayer.dart';
import '../services/prophet_prayer_service.dart';
import '../widgets/prophet_language_selector.dart';
import '../widgets/prophet_prayer_card.dart';
import 'prophet_prayer_detail_screen.dart';

class ProphetPrayersScreen extends StatefulWidget {
  const ProphetPrayersScreen({super.key});

  @override
  State<ProphetPrayersScreen> createState() => _ProphetPrayersScreenState();
}

class _ProphetPrayersScreenState extends State<ProphetPrayersScreen> {
  final _service = ProphetPrayerService();
  String _query = '';

  bool _matches(ProphetPrayer prayer) {
    final query = _query.toLowerCase().trim();
    if (query.isEmpty) return true;
    return [prayer.prophet.ar, prayer.prophet.en, prayer.prophet.ur, prayer.prophet.fr, prayer.reference.display]
        .any((value) => value.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.of(context, 'prophetPrayers')),
          actions: [
            ProphetLanguageSelector(
              value: AppSettings.of(context).languageCode,
              onChanged: (_) {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: FutureBuilder<List<ProphetPrayer>>(
        future: _service.loadPrayers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Unable to load Prophet Prayers.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final prayers = snapshot.data!.where(_matches).toList();
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(AppStrings.of(context, 'authentic'), style: Theme.of(context).textTheme.bodyLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(onChanged: (value) => setState(() => _query = value), decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: AppStrings.of(context, 'searchPrayers'), border: const OutlineInputBorder())),
            ),
            const SizedBox(height: 8),
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), itemCount: prayers.length,
              itemBuilder: (context, index) => ProphetPrayerCard(
                prayer: prayers[index], languageCode: AppSettings.of(context).languageCode,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProphetPrayerDetailScreen(prayer: prayers[index], initialLanguage: AppSettings.of(context).languageCode))),
              ),
            )),
          ]);
        },
        ),
      );
}
