import 'package:get/get.dart';

/// The six canonical hadith collections (الكتب الستة)
enum HadithCollection {
  bukhari(name: 'bukhari', arabicName: 'صحيح البخاري', booksCount: 97),
  muslim(name: 'muslim', arabicName: 'صحيح مسلم', booksCount: 57),
  nasai(name: 'nasai', arabicName: 'سنن النسائي', booksCount: 51),
  abudawud(name: 'abudawud', arabicName: 'سنن أبي داود', booksCount: 43),
  tirmidhi(name: 'tirmidhi', arabicName: 'جامع الترمذي', booksCount: 49),
  ibnmajah(name: 'ibnmajah', arabicName: 'سنن ابن ماجة', booksCount: 38);

  final String name;
  final String arabicName;
  final int booksCount;

  const HadithCollection({
    required this.name,
    required this.arabicName,
    required this.booksCount,
  });

  /// Localized name using GetX translations
  String get localizedName => 'collection_$name'.tr;

  static HadithCollection fromName(String name) {
    return HadithCollection.values.firstWhere(
      (e) => e.name == name,
      orElse: () => HadithCollection.bukhari,
    );
  }
}
