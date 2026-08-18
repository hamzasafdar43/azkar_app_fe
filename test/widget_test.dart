// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:azkar_app/core/services/favorites_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('favorite service stores azkar and prayer ids', () async {
    SharedPreferences.setMockInitialValues({});
    final service = FavoritesService();

    await service.toggleAzkar('azkar-1');
    await service.togglePrayer('prayer-1');

    expect(service.isAzkarFavorite('azkar-1'), isTrue);
    expect(service.isPrayerFavorite('prayer-1'), isTrue);
    expect((await service.favoriteAzkarIds).contains('azkar-1'), isTrue);
    expect((await service.favoritePrayerIds).contains('prayer-1'), isTrue);
  });

  test('favorite service removes ids when toggled again', () async {
    SharedPreferences.setMockInitialValues({});
    final service = FavoritesService();

    await service.toggleAzkar('azkar-2');
    await service.toggleAzkar('azkar-2');
    await service.togglePrayer('prayer-2');
    await service.togglePrayer('prayer-2');

    expect(service.isAzkarFavorite('azkar-2'), isFalse);
    expect(service.isPrayerFavorite('prayer-2'), isFalse);
  });
}
