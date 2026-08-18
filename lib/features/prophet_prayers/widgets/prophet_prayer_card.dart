import 'package:azkar_app/core/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/prophet_prayer.dart';

class ProphetPrayerCard extends StatefulWidget {
  const ProphetPrayerCard({
    super.key,
    required this.prayer,
    required this.languageCode,
    required this.onTap,
  });

  final ProphetPrayer prayer;
  final String languageCode;
  final VoidCallback onTap;

  @override
  State<ProphetPrayerCard> createState() => _ProphetPrayerCardState();
}

class _ProphetPrayerCardState extends State<ProphetPrayerCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = FavoritesService().isPrayerFavorite(widget.prayer.id);
  }

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.prayer.prophet.value(widget.languageCode),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              widget.prayer.duaArabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(height: 1.8),
            ),
            const SizedBox(height: 10),
            Text(
              widget.prayer.translation.value(widget.languageCode),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(widget.prayer.reference.display)),
                const Spacer(),
                IconButton(
                  tooltip: 'Copy prayer',
                  icon: const Icon(Icons.copy_outlined),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: widget.prayer.duaArabic),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Prayer copied')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: _isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: () async {
                    await FavoritesService().togglePrayer(widget.prayer.id);
                    if (mounted) {
                      setState(() => _isFavorite = !_isFavorite);
                    }
                  },
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite
                        ? const Color(0xFFC5545D)
                        : const Color(0xFF4E4A52),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
