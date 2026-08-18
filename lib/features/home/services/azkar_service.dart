import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/azkar_category.dart';
import '../models/azkar_page.dart';

class AzkarService {
  AzkarService();

  static final Map<AzkarCategory, Future<AzkarPage>> _cache = {};

  Future<AzkarPage> loadPage(AzkarCategory category) {
    return _cache[category] ??= _load(category);
  }

  Future<AzkarPage> _load(AzkarCategory category) async {
    final source = await rootBundle.loadString(
      'assets/data/${category.pageId}.json',
    );
    final json = jsonDecode(source) as Map<String, dynamic>;
    return AzkarPage.fromJson(json);
  }
}
