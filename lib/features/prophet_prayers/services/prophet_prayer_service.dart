import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/prophet_prayer.dart';

class ProphetPrayerService {
  Future<List<ProphetPrayer>> loadPrayers() => _cache ??= _load();

  static Future<List<ProphetPrayer>>? _cache;

  Future<List<ProphetPrayer>> _load() async {
    final source = await rootBundle.loadString('assets/data/prophet_prayers.json');
    final json = jsonDecode(source) as Map<String, dynamic>;
    return (json['prophet_prayers'] as List<dynamic>)
        .map((item) => ProphetPrayer.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
