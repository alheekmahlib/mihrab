import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final GetStorage _storage;

  PrayerRepositoryImpl(this._storage);

  @override
  PrayerTimeEntity getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    required CalculationMethodType calculationMethod,
    required int madhab,
    int highLatitudeRule = 0,
    Map<String, int>? adjustments,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final dateComponents = DateComponents.from(date);
    final params = _buildParams(
      calculationMethod,
      madhab,
      highLatitudeRule,
      adjustments,
    );

    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
    final sunnahTimes = SunnahTimes(prayerTimes);

    return _buildPrayerTimeEntity(prayerTimes, sunnahTimes, date);
  }

  @override
  double getQiblaDirection({
    required double latitude,
    required double longitude,
  }) {
    return Qibla(Coordinates(latitude, longitude)).direction;
  }

  @override
  Future<void> cacheMonthlyPrayerTimes({
    required double latitude,
    required double longitude,
    required CalculationMethodType calculationMethod,
    required int madhab,
    int highLatitudeRule = 0,
    Map<String, int>? adjustments,
    int monthsAhead = 3,
  }) async {
    final coordinates = Coordinates(latitude, longitude);
    final params = _buildParams(
      calculationMethod,
      madhab,
      highLatitudeRule,
      adjustments,
    );
    final now = DateTime.now();

    for (int i = 0; i < monthsAhead; i++) {
      final targetMonth = DateTime(now.year, now.month + i, 1);
      final daysInMonth = DateTime(
        targetMonth.year,
        targetMonth.month + 1,
        0,
      ).day;
      final dailyTimes = <int, DayPrayerTimes>{};

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(targetMonth.year, targetMonth.month, day);
        final dateComponents = DateComponents.from(date);
        final pt = PrayerTimes(coordinates, dateComponents, params);
        final st = SunnahTimes(pt);

        dailyTimes[day] = DayPrayerTimes(
          date: date,
          fajr: pt.fajr,
          sunrise: pt.sunrise,
          dhuhr: pt.dhuhr,
          asr: pt.asr,
          maghrib: pt.maghrib,
          isha: pt.isha,
          midnight: st.middleOfTheNight,
          lastThird: st.lastThirdOfTheNight,
        );
      }

      final monthlyData = MonthlyPrayerData(
        year: targetMonth.year,
        month: targetMonth.month,
        dailyTimes: dailyTimes,
        latitude: latitude,
        longitude: longitude,
        calculatedAt: now,
        params: {
          'calculationMethod': calculationMethod.value,
          'madhab': madhab,
          'highLatitudeRule': highLatitudeRule,
        },
      );

      final key =
          'MONTHLY_PRAYER_DATA_${targetMonth.year}_${targetMonth.month}';
      await _storage.write(key, monthlyData.toJson());
    }
  }

  @override
  DayPrayerTimes? getCachedPrayerTimes(DateTime date) {
    final key = 'MONTHLY_PRAYER_DATA_${date.year}_${date.month}';
    final raw = _storage.read(key);
    if (raw == null) return null;

    try {
      final monthly = MonthlyPrayerData.fromJson(
        Map<String, dynamic>.from(raw),
      );
      return monthly.getPrayerTimesForDay(date);
    } catch (_) {
      return null;
    }
  }

  @override
  bool isCacheValid(DateTime date) {
    return getCachedPrayerTimes(date) != null;
  }

  @override
  Future<CalculationMethodType> getCalculationMethodForCountry(
    String country,
  ) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/madhabV2.json',
      );
      final jsonData = jsonDecode(jsonString) as List;
      final countryData = jsonData.cast<Map<String, dynamic>>().firstWhere(
        (item) => item['country'] == country,
        orElse: () => <String, dynamic>{},
      );

      if (countryData.isEmpty) return CalculationMethodType.other;

      final params = countryData['params'] as String?;
      return CalculationMethodType.values.firstWhere(
        (e) => e.value == params,
        orElse: () => CalculationMethodType.other,
      );
    } catch (_) {
      return CalculationMethodType.other;
    }
  }

  // --- Private helpers ---

  CalculationParameters _buildParams(
    CalculationMethodType method,
    int madhab,
    int highLatitudeRule,
    Map<String, int>? adjustments,
  ) {
    final params = _methodToCalculationMethod(method).getParameters();
    params.madhab = madhab == 1 ? Madhab.hanafi : Madhab.shafi;
    params.highLatitudeRule = _indexToHighLatitudeRule(highLatitudeRule);
    if (adjustments != null) {
      params.adjustments = PrayerAdjustments(
        fajr: adjustments['fajr'] ?? 0,
        sunrise: adjustments['sunrise'] ?? 0,
        dhuhr: adjustments['dhuhr'] ?? 0,
        asr: adjustments['asr'] ?? 0,
        maghrib: adjustments['maghrib'] ?? 0,
        isha: adjustments['isha'] ?? 0,
      );
    }
    return params;
  }

  CalculationMethod _methodToCalculationMethod(CalculationMethodType type) {
    switch (type) {
      case CalculationMethodType.ummAlQura:
        return CalculationMethod.umm_al_qura;
      case CalculationMethodType.muslimWorldLeague:
        return CalculationMethod.muslim_world_league;
      case CalculationMethodType.egyptian:
        return CalculationMethod.egyptian;
      case CalculationMethodType.karachi:
        return CalculationMethod.karachi;
      case CalculationMethodType.dubai:
        return CalculationMethod.dubai;
      case CalculationMethodType.kuwait:
        return CalculationMethod.kuwait;
      case CalculationMethodType.qatar:
        return CalculationMethod.qatar;
      case CalculationMethodType.singapore:
        return CalculationMethod.singapore;
      case CalculationMethodType.turkey:
        return CalculationMethod.turkey;
      case CalculationMethodType.northAmerica:
        return CalculationMethod.north_america;
      case CalculationMethodType.other:
        return CalculationMethod.other;
    }
  }

  HighLatitudeRule _indexToHighLatitudeRule(int index) {
    switch (index) {
      case 1:
        return HighLatitudeRule.seventh_of_the_night;
      case 2:
        return HighLatitudeRule.twilight_angle;
      default:
        return HighLatitudeRule.middle_of_the_night;
    }
  }

  PrayerTimeEntity _buildPrayerTimeEntity(
    PrayerTimes pt,
    SunnahTimes st,
    DateTime date,
  ) {
    final now = DateTime.now();

    // Only actual salah prayers (no sunrise) for current/next calculation
    final prayers = [
      MapEntry(PrayerType.fajr, pt.fajr),
      MapEntry(PrayerType.dhuhr, pt.dhuhr),
      MapEntry(PrayerType.asr, pt.asr),
      MapEntry(PrayerType.maghrib, pt.maghrib),
      MapEntry(PrayerType.isha, pt.isha),
    ];

    PrayerType currentPrayer = PrayerType.isha;
    PrayerType nextPrayer = PrayerType.fajr;
    Duration timeUntilNext = Duration.zero;

    for (int i = 0; i < prayers.length; i++) {
      if (now.isBefore(prayers[i].value)) {
        nextPrayer = prayers[i].key;
        timeUntilNext = prayers[i].value.difference(now);
        currentPrayer = i > 0 ? prayers[i - 1].key : PrayerType.isha;
        break;
      }
      if (i == prayers.length - 1) {
        // After isha, next is fajr of next day
        currentPrayer = PrayerType.isha;
        nextPrayer = PrayerType.fajr;
        final tomorrow = date.add(const Duration(days: 1));
        final tomorrowFajr = PrayerTimes(
          Coordinates(pt.coordinates.latitude, pt.coordinates.longitude),
          DateComponents.from(tomorrow),
          pt.calculationParameters,
        ).fajr;
        timeUntilNext = tomorrowFajr.difference(now);
      }
    }

    return PrayerTimeEntity(
      fajr: pt.fajr,
      sunrise: pt.sunrise,
      dhuhr: pt.dhuhr,
      asr: pt.asr,
      maghrib: pt.maghrib,
      isha: pt.isha,
      midnight: st.middleOfTheNight,
      lastThird: st.lastThirdOfTheNight,
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
      timeUntilNext: timeUntilNext,
      date: date,
    );
  }
}
