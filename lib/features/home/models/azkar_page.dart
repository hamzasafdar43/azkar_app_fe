class LocalizedText {
  const LocalizedText({required this.ar, required this.en, required this.ur, required this.fr});

  final String ar;
  final String en;
  final String ur;
  final String fr;

  String value(String languageCode) {
    return switch (languageCode) {
      'ur' => ur,
      'fr' => fr,
      'ar' => ar,
      _ => en,
    };
  }

  factory LocalizedText.fromJson(Map<String, dynamic> json) => LocalizedText(
        ar: json['ar'] as String? ?? '',
        en: json['en'] as String,
        ur: json['ur'] as String,
        fr: json['fr'] as String,
      );
}

class AzkarItem {
  const AzkarItem({
    required this.id,
    required this.title,
    required this.duaArabic,
    required this.translation,
    this.sourceType,
    this.reference,
  });

  final String id;
  final LocalizedText title;
  final String duaArabic;
  final LocalizedText translation;
  final String? sourceType;
  final String? reference;

  factory AzkarItem.fromJson(Map<String, dynamic> json) => AzkarItem(
        id: json['id'] as String,
        title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
        duaArabic: json['dua_arabic'] as String,
        translation: LocalizedText.fromJson(json['translation'] as Map<String, dynamic>),
        sourceType: json['source_type'] as String?,
        reference: json['reference'] as String?,
      );
}

class AzkarPage {
  const AzkarPage({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText? description;
  final List<AzkarItem> items;

  factory AzkarPage.fromJson(Map<String, dynamic> json) => AzkarPage(
        id: json['id'] as String,
        title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
        description: json['description'] == null
            ? null
            : LocalizedText.fromJson(json['description'] as Map<String, dynamic>),
        items: (json['items'] as List<dynamic>)
            .map((item) => AzkarItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
}
