import 'package:mihrab_shared/mihrab_shared.dart';

abstract class PrayerRepository {
  /// Calculate prayer times for a specific date
  PrayerTimeEntity getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    required CalculationMethodType calculationMethod,
    required int madhab,
    int highLatitudeRule = 0,
    Map<String, int>? adjustments,
  });

  /// Get Qibla direction in degrees from North
  double getQiblaDirection({
    required double latitude,
    required double longitude,
  });

  /// Calculate and cache prayer times for multiple months
  Future<void> cacheMonthlyPrayerTimes({
    required double latitude,
    required double longitude,
    required CalculationMethodType calculationMethod,
    required int madhab,
    int highLatitudeRule = 0,
    Map<String, int>? adjustments,
    int monthsAhead = 3,
  });

  /// Get cached prayer times for a date (returns null if not cached)
  DayPrayerTimes? getCachedPrayerTimes(DateTime date);

  /// Check if prayer times are cached for a given date
  bool isCacheValid(DateTime date);

  /// Get calculation method for a country from madhabV2.json
  Future<CalculationMethodType> getCalculationMethodForCountry(String country);
}
