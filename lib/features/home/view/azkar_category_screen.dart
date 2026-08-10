import 'package:azkar_app/core/constants/app_strings.dart';
import 'package:azkar_app/core/settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/azkar_category.dart';
import '../models/azkar_page.dart';
import '../services/azkar_service.dart';

class AzkarCategoryScreen extends StatefulWidget {
  const AzkarCategoryScreen({super.key, required this.category});

  final AzkarCategory category;

  @override
  State<AzkarCategoryScreen> createState() => _AzkarCategoryScreenState();
}

class _AzkarCategoryScreenState extends State<AzkarCategoryScreen> {
  final _service = AzkarService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final languageCode = AppSettings.of(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(context, widget.category.titleKey))),
      body: FutureBuilder<AzkarPage>(
        future: _service.loadPage(widget.category),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Unable to load ${widget.category.pageId}.\n${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final page = snapshot.data!;
          final items = page.items.where((item) {
            if (_query.isEmpty) return true;
            final text = '${item.title.value(languageCode)} ${item.duaArabic} ${item.translation.value(languageCode)}'.toLowerCase();
            return text.contains(_query.toLowerCase());
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            children: [
              _Header(card: page, languageCode: languageCode),
              const SizedBox(height: 18),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: AppStrings.of(context, 'searchPrayers'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
              const SizedBox(height: 18),
              ...items.map((item) => _AzkarItemCard(item: item, languageCode: languageCode)).toList(),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'No matching prayers found.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.card, required this.languageCode});

  final AzkarPage card;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final title = card.title.value(languageCode);
    final description = card.description?.value(languageCode);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(colors: [Color(0xFF0B5D4B), Color(0xFF2D755F)]),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 10))],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
        if (description != null) ...[
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(color: Color(0xFFD4F1E1), fontSize: 14, height: 1.5)),
        ],
        const SizedBox(height: 16),
        Row(children: [
          _Badge(label: '${card.items.length} Prayers', color: Colors.white70),
          const SizedBox(width: 10),
          _Badge(label: 'Islamic App', color: const Color(0xFFC7FFD9)),
        ]),
      ]),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: color.withOpacity(.18), borderRadius: BorderRadius.circular(16)),
        child: Text(label, style: TextStyle(color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

class _AzkarItemCard extends StatelessWidget {
  const _AzkarItemCard({required this.item, required this.languageCode});

  final AzkarItem item;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final title = item.title.value(languageCode);
    final translation = item.translation.value(languageCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
            if (item.sourceType != null)
              Chip(label: Text(item.sourceType!, style: const TextStyle(fontSize: 11)), backgroundColor: const Color(0xFFEDF7F0)),
          ]),
          const SizedBox(height: 14),
          Text(item.duaArabic, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.7)),
          const SizedBox(height: 14),
          Text(translation, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.grey[800])),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (item.reference != null)
              Text(item.reference!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: item.duaArabic));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.of(context, 'copied'))));
                }
              },
              icon: const Icon(Icons.copy, size: 18),
              label: Text(AppStrings.of(context, 'copy')),
              style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            ),
          ]),
        ]),
      ),
    );
  }
}
