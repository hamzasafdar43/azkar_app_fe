import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  FavoritesService._();

  static final FavoritesService _instance = FavoritesService._();

  factory FavoritesService() => _instance;

  static const _azkarKey = 'favorite_azkar_ids';
  static const _prayerKey = 'favorite_prayer_ids';

  final Set<String> _azkarFavorites = <String>{};
  final Set<String> _prayerFavorites = <String>{};

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    _azkarFavorites
      ..clear()
      ..addAll(preferences.getStringList(_azkarKey) ?? const <String>[]);
    _prayerFavorites
      ..clear()
      ..addAll(preferences.getStringList(_prayerKey) ?? const <String>[]);
  }

  Future<List<String>> get favoriteAzkarIds async {
    await load();
    return _azkarFavorites.toList()..sort();
  }

  Future<List<String>> get favoritePrayerIds async {
    await load();
    return _prayerFavorites.toList()..sort();
  }

  bool isAzkarFavorite(String id) => _azkarFavorites.contains(id);

  bool isPrayerFavorite(String id) => _prayerFavorites.contains(id);

  Future<void> toggleAzkar(String id) async {
    await load();
    if (_azkarFavorites.contains(id)) {
      _azkarFavorites.remove(id);
    } else {
      _azkarFavorites.add(id);
    }
    await _persist();
  }

  Future<void> togglePrayer(String id) async {
    await load();
    if (_prayerFavorites.contains(id)) {
      _prayerFavorites.remove(id);
    } else {
      _prayerFavorites.add(id);
    }
    await _persist();
  }

  Future<void> _persist() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _azkarKey,
      _azkarFavorites.toList()..sort(),
    );
    await preferences.setStringList(
      _prayerKey,
      _prayerFavorites.toList()..sort(),
    );
  }
}
