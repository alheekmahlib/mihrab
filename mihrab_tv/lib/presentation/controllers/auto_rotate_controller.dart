import 'dart:async';

import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import 'hadith_controller.dart';
import 'prayer_controller.dart';

class AutoRotateController extends GetxController {
  final intervalMinutes = 5.obs; // default 5 min per screen
  final currentMode = DisplayMode.prayerTimes.obs;
  final enabledModes = <DisplayMode>[
    DisplayMode.prayerTimes,
    DisplayMode.hadith,
    DisplayMode.combined,
    DisplayMode.prayerQibla,
  ].obs;

  Timer? _rotationTimer;
  int _currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _startRotation();
  }

  @override
  void onClose() {
    _rotationTimer?.cancel();
    super.onClose();
  }

  void _startRotation() {
    _rotationTimer?.cancel();
    if (enabledModes.isEmpty) return;

    _currentIndex = 0;
    currentMode.value = enabledModes[0];

    _rotationTimer = Timer.periodic(
      Duration(minutes: intervalMinutes.value),
      (_) => _nextScreen(),
    );
  }

  void _nextScreen() {
    if (enabledModes.isEmpty) return;

    // Pause during prayer alerts
    if (Get.isRegistered<PrayerController>()) {
      final pc = Get.find<PrayerController>();
      if (pc.showPrayerAlert.value) return;
    }

    _currentIndex = (_currentIndex + 1) % enabledModes.length;
    currentMode.value = enabledModes[_currentIndex];
  }

  void updateInterval(int minutes) {
    intervalMinutes.value = minutes;
    _startRotation();
  }

  void toggleMode(DisplayMode mode, bool enabled) {
    if (enabled && !enabledModes.contains(mode)) {
      enabledModes.add(mode);
    } else if (!enabled) {
      enabledModes.remove(mode);
    }
    _startRotation();
  }

  void pause() {
    _rotationTimer?.cancel();
    if (Get.isRegistered<HadithController>()) {
      Get.find<HadithController>().pauseRotation();
    }
  }

  void resume() {
    _startRotation();
    if (Get.isRegistered<HadithController>()) {
      Get.find<HadithController>().resumeRotation();
    }
  }
}
