import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:intl/intl.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../domain/repositories/prayer_repository.dart';

class PrayerController extends GetxController {
  final PrayerRepository _repository;

  PrayerController(this._repository);

  // Observables
  final prayerTimes = Rxn<PrayerTimeEntity>();
  final qiblaDirection = 0.0.obs;
  final countdownText = ''.obs;
  final currentDateGregorian = ''.obs;
  final currentDateHijri = ''.obs;
  final showPrayerAlert = false.obs;
  final alertPrayerName = ''.obs;

  // Settings (from device settings)
  double latitude = 0;
  double longitude = 0;
  CalculationMethodType calculationMethod = CalculationMethodType.ummAlQura;
  int madhab = 0;
  int highLatitudeRule = 0;
  Map<String, int>? adjustments;

  Timer? _countdownTimer;
  Timer? _midnightTimer;
  Timer? _alertDismissTimer;

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _midnightTimer?.cancel();
    _alertDismissTimer?.cancel();
    super.onClose();
  }

  /// Initialize with location and calculation settings
  Future<void> initialize({
    required double lat,
    required double lng,
    required CalculationMethodType method,
    required int madhabValue,
    int highLat = 0,
    Map<String, int>? adj,
  }) async {
    latitude = lat;
    longitude = lng;
    calculationMethod = method;
    madhab = madhabValue;
    highLatitudeRule = highLat;
    adjustments = adj;

    debugPrint(
      '🕌 Prayer init: lat=$lat, lng=$lng, method=${method.value}, madhab=$madhabValue',
    );

    // Cache 3 months of prayer times
    await _repository.cacheMonthlyPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );

    // Calculate today's times
    _refreshPrayerTimes();
    _updateDates();
    _startCountdown();
    _scheduleMidnightRefresh();

    // Calculate Qibla
    qiblaDirection.value = _repository.getQiblaDirection(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Re-initialize when settings change
  Future<void> onSettingsChanged(DeviceSettingsEntity settings) async {
    if (settings.latitude == null || settings.longitude == null) return;

    final method = CalculationMethodType.values.firstWhere(
      (e) => e.value == settings.calculationMethod,
      orElse: () => CalculationMethodType.ummAlQura,
    );

    await initialize(
      lat: settings.latitude!,
      lng: settings.longitude!,
      method: method,
      madhabValue: settings.madhab ?? 0,
      highLat: settings.highLatitudeRule ?? 0,
      adj: settings.adjustments,
    );
  }

  void _refreshPrayerTimes() {
    final now = DateTime.now();
    prayerTimes.value = _repository.getPrayerTimesForDate(
      latitude: latitude,
      longitude: longitude,
      date: now,
      calculationMethod: calculationMethod,
      madhab: madhab,
      highLatitudeRule: highLatitudeRule,
      adjustments: adjustments,
    );
    final pt = prayerTimes.value;
    if (pt != null) {
      debugPrint(
        '🕌 Fajr=${pt.fajr}, Dhuhr=${pt.dhuhr}, Asr=${pt.asr}, Maghrib=${pt.maghrib}, Isha=${pt.isha}',
      );
      debugPrint('🕌 Timezone offset: ${now.timeZoneOffset}');
    }
  }

  void _updateDates() {
    final now = DateTime.now();
    currentDateGregorian.value = DateFormat('d MMMM yyyy', 'ar').format(now);
    try {
      HijriDate.language = 'ar';
      final hijri = HijriDate.now();
      currentDateHijri.value =
          '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} هـ';
    } catch (_) {
      currentDateHijri.value = '';
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final pt = prayerTimes.value;
      if (pt == null) return;

      final now = DateTime.now();
      // Recalculate next prayer
      final fresh = _repository.getPrayerTimesForDate(
        latitude: latitude,
        longitude: longitude,
        date: now,
        calculationMethod: calculationMethod,
        madhab: madhab,
        highLatitudeRule: highLatitudeRule,
        adjustments: adjustments,
      );
      prayerTimes.value = fresh;

      final remaining = fresh.timeUntilNext;
      if (remaining.isNegative) {
        countdownText.value = '00:00:00';
        return;
      }

      final hours = remaining.inHours.toString().padLeft(2, '0');
      final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
      countdownText.value = '$hours:$minutes:$seconds';

      // Check if prayer time just arrived (within 2 seconds)
      if (remaining.inSeconds <= 1 && !showPrayerAlert.value) {
        _triggerPrayerAlert(fresh.nextPrayer);
      }
    });
  }

  void _triggerPrayerAlert(PrayerType prayer) {
    showPrayerAlert.value = true;
    alertPrayerName.value = prayer.localizedName;

    // Auto-dismiss after 5 minutes
    _alertDismissTimer?.cancel();
    _alertDismissTimer = Timer(const Duration(minutes: 5), () {
      showPrayerAlert.value = false;
    });
  }

  void dismissAlert() {
    showPrayerAlert.value = false;
    _alertDismissTimer?.cancel();
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final untilMidnight = midnight.difference(now);

    _midnightTimer = Timer(untilMidnight, () {
      _refreshPrayerTimes();
      _updateDates();
      _scheduleMidnightRefresh();
    });
  }

  /// Format a prayer time for display
  String formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('hh:mm').format(time);
  }

  String formatTimePeriod(DateTime? time) {
    if (time == null) return '';
    return DateFormat('a', 'ar').format(time);
  }

  /// Get cardinal direction text for qibla
  String get qiblaCardinalDirection {
    final deg = qiblaDirection.value % 360;
    if (deg >= 337.5 || deg < 22.5) return AppStrings.north;
    if (deg >= 22.5 && deg < 67.5) return AppStrings.northEast;
    if (deg >= 67.5 && deg < 112.5) return AppStrings.east;
    if (deg >= 112.5 && deg < 157.5) return AppStrings.southEast;
    if (deg >= 157.5 && deg < 202.5) return AppStrings.south;
    if (deg >= 202.5 && deg < 247.5) return AppStrings.southWest;
    if (deg >= 247.5 && deg < 292.5) return AppStrings.west;
    return AppStrings.northWest;
  }
}
