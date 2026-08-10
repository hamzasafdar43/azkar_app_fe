enum AzkarCategory { morning, evening, afterNoon, afterSalah }

extension AzkarCategoryExt on AzkarCategory {
  String get pageId {
    return switch (this) {
      AzkarCategory.morning => 'morning_azkar',
      AzkarCategory.evening => 'evening_azkar',
      AzkarCategory.afterNoon => 'after_noon_azkar',
      AzkarCategory.afterSalah => 'after_salah_azkar',
    };
  }

  String get titleKey {
    return switch (this) {
      AzkarCategory.morning => 'morningAzkar',
      AzkarCategory.evening => 'eveningAzkar',
      AzkarCategory.afterNoon => 'afterNoonAzkar',
      AzkarCategory.afterSalah => 'afterSalah',
    };
  }
}
