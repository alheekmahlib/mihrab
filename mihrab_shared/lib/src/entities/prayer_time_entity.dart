import '../enums/prayer_type.dart';

/// Represents the current prayer time state for display
class PrayerTimeEntity {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime? midnight;
  final DateTime? lastThird;
  final PrayerType currentPrayer;
  final PrayerType nextPrayer;
  final Duration timeUntilNext;
  final DateTime date;

  const PrayerTimeEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.midnight,
    this.lastThird,
    required this.currentPrayer,
    required this.nextPrayer,
    required this.timeUntilNext,
    required this.date,
  });

  DateTime timeForPrayer(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return fajr;
      case PrayerType.sunrise:
        return sunrise;
      case PrayerType.dhuhr:
        return dhuhr;
      case PrayerType.asr:
        return asr;
      case PrayerType.maghrib:
        return maghrib;
      case PrayerType.isha:
        return isha;
      case PrayerType.midnight:
        return midnight ?? isha;
      case PrayerType.lastThird:
        return lastThird ?? isha;
    }
  }
}
