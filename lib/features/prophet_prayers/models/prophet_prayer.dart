class LocalizedText {
  const LocalizedText({required this.ar, required this.en, required this.ur, required this.fr});

  final String ar;
  final String en;
  final String ur;
  final String fr;

  factory LocalizedText.fromJson(Map<String, dynamic> json) => LocalizedText(
        ar: json['ar'] as String? ?? '',
        en: json['en'] as String,
        ur: json['ur'] as String,
        fr: json['fr'] as String,
      );

  String value(String language) => switch (language) {
        'ar' => ar.isEmpty ? en : ar,
        'ur' => ur,
        'fr' => fr,
        _ => en,
      };
}

class QuranReference {
  const QuranReference({required this.surahNumber, required this.surahName, required this.ayah});

  final int surahNumber;
  final LocalizedText surahName;
  final String ayah;

  factory QuranReference.fromJson(Map<String, dynamic> json) => QuranReference(
        surahNumber: json['surah_number'] as int,
        surahName: LocalizedText.fromJson(json['surah_name'] as Map<String, dynamic>),
        ayah: json['ayah'] as String,
      );

  String get display => 'Quran $surahNumber:$ayah';
}

class ProphetPrayer {
  const ProphetPrayer({
    required this.id,
    required this.prophet,
    required this.duaArabic,
    required this.translation,
    required this.reference,
    required this.sourceType,
  });

  final String id;
  final LocalizedText prophet;
  final String duaArabic;
  final LocalizedText translation;
  final QuranReference reference;
  final String sourceType;

  factory ProphetPrayer.fromJson(Map<String, dynamic> json) => ProphetPrayer(
        id: json['id'] as String,
        prophet: LocalizedText.fromJson(json['prophet'] as Map<String, dynamic>),
        duaArabic: json['dua_arabic'] as String,
        translation: LocalizedText.fromJson(json['translation'] as Map<String, dynamic>),
        reference: QuranReference.fromJson(json['reference'] as Map<String, dynamic>),
        sourceType: json['source_type'] as String,
      );
}
