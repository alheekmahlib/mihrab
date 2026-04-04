import 'package:get/get.dart';

/// Display modes available for the TV app
enum DisplayMode {
  prayerTimes('prayer_times', 'أوقات الصلاة'),
  hadith('hadith', 'حديث'),
  combined('combined', 'أوقات الصلاة + حديث'),
  prayerQibla('prayer_qibla', 'أوقات الصلاة + القبلة'),
  autoRotate('auto_rotate', 'تدوير تلقائي');

  final String value;
  final String label;

  const DisplayMode(this.value, this.label);

  /// Localized label using GetX translations
  String get localizedLabel {
    const keyMap = {
      'prayer_times': 'prayerTimes',
      'hadith': 'hadith',
      'combined': 'combined',
      'prayer_qibla': 'prayerQibla',
      'auto_rotate': 'autoRotate',
    };
    return (keyMap[value] ?? value).tr;
  }

  static DisplayMode fromValue(String value) {
    return DisplayMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DisplayMode.prayerTimes,
    );
  }
}
