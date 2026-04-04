import 'day_prayer_times.dart';

/// Prayer data for a complete month — adapted from almasjid MonthlyPrayerCache
class MonthlyPrayerData {
  final int year;
  final int month;
  final Map<int, DayPrayerTimes> dailyTimes;
  final double latitude;
  final double longitude;
  final DateTime calculatedAt;
  final Map<String, dynamic> params;

  MonthlyPrayerData({
    required this.year,
    required this.month,
    required this.dailyTimes,
    required this.latitude,
    required this.longitude,
    required this.calculatedAt,
    required this.params,
  });

  bool containsDate(DateTime date) {
    return date.year == year &&
        date.month == month &&
        dailyTimes.containsKey(date.day);
  }

  DayPrayerTimes? getPrayerTimesForDay(DateTime date) {
    if (!containsDate(date)) return null;
    return dailyTimes[date.day];
  }

  Map<String, dynamic> toJson() {
    final dailyTimesJson = <String, dynamic>{};
    dailyTimes.forEach((day, times) {
      dailyTimesJson[day.toString()] = times.toJson();
    });

    return {
      'year': year,
      'month': month,
      'dailyTimes': dailyTimesJson,
      'location': {'latitude': latitude, 'longitude': longitude},
      'calculatedAt': calculatedAt.toIso8601String(),
      'params': params,
    };
  }

  factory MonthlyPrayerData.fromJson(Map<String, dynamic> json) {
    final dailyTimesJson = json['dailyTimes'] as Map<String, dynamic>;
    final dailyTimes = <int, DayPrayerTimes>{};

    dailyTimesJson.forEach((dayStr, timesJson) {
      final day = int.parse(dayStr);
      dailyTimes[day] = DayPrayerTimes.fromJson(
        Map<String, dynamic>.from(timesJson),
      );
    });

    final locationJson = json['location'] as Map<String, dynamic>;

    return MonthlyPrayerData(
      year: json['year'],
      month: json['month'],
      dailyTimes: dailyTimes,
      latitude: (locationJson['latitude'] as num).toDouble(),
      longitude: (locationJson['longitude'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculatedAt']),
      params: Map<String, dynamic>.from(json['params'] ?? {}),
    );
  }
}
