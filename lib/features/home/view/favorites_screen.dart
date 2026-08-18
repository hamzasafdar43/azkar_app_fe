import 'package:azkar_app/core/services/favorites_service.dart';
import 'package:azkar_app/features/home/models/azkar_category.dart';
import 'package:azkar_app/features/home/services/azkar_service.dart';
import 'package:azkar_app/features/prophet_prayers/services/prophet_prayer_service.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  Future<List<_FavoriteItem>> _loadFavorites() async {
    final favoriteAzkarIds = await _favoritesService.favoriteAzkarIds;
    final favoritePrayerIds = await _favoritesService.favoritePrayerIds;

    final azkarItems = await Future.wait(
      AzkarCategory.values.map((category) => AzkarService().loadPage(category)),
    );

    final favoriteAzkar = azkarItems
        .expand((page) => page.items)
        .where((item) => favoriteAzkarIds.contains(item.id))
        .map(
          (item) => _FavoriteItem(
            id: item.id,
            title: item.title.value('en'),
            arabic: item.duaArabic,
            reference: item.reference ?? '',
            type: 'Azkar',
            isAzkar: true,
          ),
        )
        .toList();

    final prophetPrayers = await ProphetPrayerService().loadPrayers();
    final favoritePrayers = prophetPrayers
        .where((prayer) => favoritePrayerIds.contains(prayer.id))
        .map(
          (prayer) => _FavoriteItem(
            id: prayer.id,
            title: prayer.prophet.value('en'),
            arabic: prayer.duaArabic,
            reference: prayer.reference.display,
            type: 'Prayer',
            isAzkar: false,
          ),
        )
        .toList();

    return [...favoriteAzkar, ...favoritePrayers];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<_FavoriteItem>>(
        future: _loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? const <_FavoriteItem>[];
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No saved azkar or prayers yet.'),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(label: Text(item.type)),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Remove from favorites',
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFFC5545D),
                            ),
                            onPressed: () async {
                              if (item.isAzkar) {
                                await _favoritesService.toggleAzkar(item.id);
                              } else {
                                await _favoritesService.togglePrayer(item.id);
                              }
                              if (context.mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.arabic,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(height: 1.8),
                      ),
                      if (item.reference.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          item.reference,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteItem {
  const _FavoriteItem({
    required this.id,
    required this.title,
    required this.arabic,
    required this.reference,
    required this.type,
    required this.isAzkar,
  });

  final String id;
  final String title;
  final String arabic;
  final String reference;
  final String type;
  final bool isAzkar;
}
