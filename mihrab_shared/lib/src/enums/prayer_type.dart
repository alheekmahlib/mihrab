import 'package:get/get.dart';

/// Prayer types enum matching the adhan package
enum PrayerType {
  fajr('الفجر', 'Fajr'),
  sunrise('الشروق', 'Sunrise'),
  dhuhr('الظهر', 'Dhuhr'),
  asr('العصر', 'Asr'),
  maghrib('المغرب', 'Maghrib'),
  isha('العشاء', 'Isha'),
  midnight('منتصف الليل', 'Midnight'),
  lastThird('الثلث الأخير', 'Last Third');

  final String arabicName;
  final String englishName;

  const PrayerType(this.arabicName, this.englishName);

  /// Localized name using GetX translations
  String get localizedName => name.tr;
}
