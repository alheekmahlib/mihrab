import '../enums/hadith_collection.dart';

/// Represents a single hadith for display
class HadithEntity {
  final int arabicURN;
  final HadithCollection collection;
  final int bookNumber;
  final String bookName;
  final String? babName;
  final String hadithNumber;
  final String hadithText;
  final String? grade;

  const HadithEntity({
    required this.arabicURN,
    required this.collection,
    required this.bookNumber,
    required this.bookName,
    this.babName,
    required this.hadithNumber,
    required this.hadithText,
    this.grade,
  });

  factory HadithEntity.fromJson(
    Map<String, dynamic> json,
    HadithCollection collection,
  ) {
    final rawText = json['hadithText'] as String? ?? '';
    // Strip HTML tags for clean TV display
    final cleanText = rawText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .trim();

    return HadithEntity(
      arabicURN: json['arabicURN'] as int? ?? 0,
      collection: collection,
      bookNumber: json['bookNumber'] as int? ?? 0,
      bookName: json['bookName'] as String? ?? '',
      babName: json['babName'] as String?,
      hadithNumber: json['hadithNumber']?.toString() ?? '',
      hadithText: cleanText,
      grade: json['grade1'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabicURN': arabicURN,
      'collection': collection.name,
      'bookNumber': bookNumber,
      'bookName': bookName,
      'babName': babName,
      'hadithNumber': hadithNumber,
      'hadithText': hadithText,
      'grade': grade,
    };
  }

  factory HadithEntity.fromStoredJson(Map<String, dynamic> json) {
    return HadithEntity(
      arabicURN: json['arabicURN'] as int? ?? 0,
      collection: HadithCollection.fromName(json['collection'] as String),
      bookNumber: json['bookNumber'] as int? ?? 0,
      bookName: json['bookName'] as String? ?? '',
      babName: json['babName'] as String?,
      hadithNumber: json['hadithNumber']?.toString() ?? '',
      hadithText: json['hadithText'] as String? ?? '',
      grade: json['grade'] as String?,
    );
  }
}
