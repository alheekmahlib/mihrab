import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/prayer_repository.dart';
import 'hadith_controller.dart';
import 'prayer_controller.dart';

class DeviceController extends GetxController {
  final DeviceRepository _deviceRepo;
  final PrayerRepository _prayerRepo;

  DeviceController(this._deviceRepo, this._prayerRepo);

  final device = Rxn<DeviceEntity>();
  final settings = Rxn<DeviceSettingsEntity>();
  final displayMode = DisplayMode.prayerTimes.obs;
  final isSetupComplete = false.obs;
  final token = ''.obs;
  final isPaired = false.obs;
  final registrationError = ''.obs;

  StreamSubscription? _settingsSubscription;
  StreamSubscription? _displayModeSubscription;
  Timer? _heartbeatTimer;
  Timer? _settingsPollTimer;

  @override
  void onInit() {
    super.onInit();
    _loadLocalState();
    ever(isPaired, (paired) {
      debugPrint('🔧 ever(isPaired) fired: paired=$paired');
      if (paired) {
        debugPrint('🔧 Navigating to /display');
        Get.offAllNamed('/display');
      }
    });
  }

  @override
  void onClose() {
    _settingsSubscription?.cancel();
    _displayModeSubscription?.cancel();
    _heartbeatTimer?.cancel();
    _settingsPollTimer?.cancel();
    super.onClose();
  }

  void _loadLocalState() {
    final localToken = _deviceRepo.getLocalToken();
    debugPrint('🔧 _loadLocalState: token=$localToken');

    // Always load local settings (manual setup may have no token)
    settings.value = _deviceRepo.getLocalSettings();
    displayMode.value = _deviceRepo.getLocalDisplayMode();

    // Apply saved language
    final lang = settings.value?.language ?? 'ar';
    Get.updateLocale(Locale(lang));

    debugPrint(
      '🔧 Local settings: lat=${settings.value?.latitude}, lng=${settings.value?.longitude}',
    );

    // Only mark setup complete if we have real coordinates
    final s = settings.value;
    if (s?.latitude != null &&
        s?.longitude != null &&
        (s!.latitude != 0 || s.longitude != 0)) {
      isSetupComplete.value = true;
    }

    if (localToken != null) {
      token.value = localToken;
      // Reconnect realtime listeners
      _reconnectListeners(localToken);
    }
  }

  Future<void> _reconnectListeners(String localToken) async {
    try {
      final existingDevice = await _deviceRepo.getDeviceByToken(localToken);
      debugPrint('🔧 _reconnectListeners: device=${existingDevice?.id}');
      // Guard: if token changed during the async gap, skip — a new device was registered
      if (token.value != localToken) {
        debugPrint(
          '🔧 _reconnectListeners: token changed ($localToken → ${token.value}), skipping',
        );
        return;
      }
      if (existingDevice != null) {
        device.value = existingDevice;
        _startListeningForPairing(existingDevice.id);
        _startListeningForDisplayMode(existingDevice.id);
        _startHeartbeat(existingDevice.id);
      }
    } catch (e) {
      debugPrint('🔧 _reconnectListeners ERROR: $e');
    }
  }

  /// Generate QR token and register device with Supabase
  Future<String> generateAndRegisterDevice() async {
    final newToken = const Uuid().v4();
    token.value = newToken;
    registrationError.value = '';
    await _deviceRepo.saveLocalToken(newToken);
    debugPrint('🔧 generateAndRegisterDevice: newToken=$newToken');

    try {
      final registeredDevice = await _deviceRepo.registerDevice(newToken);
      device.value = registeredDevice;
      debugPrint('🔧 Device registered: id=${registeredDevice.id}');
      _startListeningForPairing(registeredDevice.id);
      _startListeningForDisplayMode(registeredDevice.id);
      _startHeartbeat(registeredDevice.id);
    } catch (e) {
      debugPrint('🔧 registerDevice ERROR: $e');
      registrationError.value = '${AppStrings.registrationFailed}: $e';
    }

    return newToken;
  }

  void _startListeningForPairing(String deviceId) {
    _settingsSubscription?.cancel();
    _settingsPollTimer?.cancel();
    debugPrint('🔧 Listening for settings on device: $deviceId');
    _settingsSubscription = _deviceRepo.listenToSettingsChanges(deviceId).listen((
      newSettings,
    ) {
      debugPrint(
        '🔧 Settings received: lat=${newSettings.latitude}, lng=${newSettings.longitude}',
      );
      _handleSettingsUpdate(newSettings);
    });

    // Fallback: poll every 5s in case Realtime misses the event
    _settingsPollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (isPaired.value) {
        _settingsPollTimer?.cancel();
        return;
      }
      try {
        final polled = await _deviceRepo.getSettings(deviceId);
        if (polled != null) {
          debugPrint(
            '🔧 Poll received: lat=${polled.latitude}, lng=${polled.longitude}',
          );
          _handleSettingsUpdate(polled);
        }
      } catch (_) {}
    });
  }

  void _handleSettingsUpdate(DeviceSettingsEntity newSettings) {
    settings.value = newSettings;

    // Apply language change
    final lang = newSettings.language ?? 'ar';
    if (Get.locale?.languageCode != lang) {
      Get.updateLocale(Locale(lang));
    }

    // Apply dark mode change
    final isDark = newSettings.isDarkMode ?? false;
    final currentIsDark = Get.isDarkMode;
    if (isDark != currentIsDark) {
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      GetStorage().write('IS_DARK_MODE', isDark);
    }

    // Apply hadith interval change
    if (Get.isRegistered<HadithController>()) {
      final hadithCtrl = Get.find<HadithController>();
      final newInterval = newSettings.hadithInterval ?? 15;
      if (hadithCtrl.rotationInterval.value != newInterval) {
        hadithCtrl.updateRotationInterval(newInterval);
      }
    }

    if (newSettings.latitude != null &&
        newSettings.longitude != null &&
        (newSettings.latitude != 0 || newSettings.longitude != 0)) {
      _settingsPollTimer?.cancel();
      isSetupComplete.value = true;
      _onSettingsUpdated(newSettings);
      // Only set isPaired once to avoid duplicate navigation
      if (!isPaired.value) {
        debugPrint('🔧 Valid settings! Setting isPaired=true');
        isPaired.value = true;
      }
    }
  }

  void _startHeartbeat(String deviceId) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _deviceRepo.heartbeat(deviceId),
    );
  }

  void _startListeningForDisplayMode(String deviceId) {
    _displayModeSubscription?.cancel();
    _displayModeSubscription = _deviceRepo
        .listenToDisplayModeChanges(deviceId)
        .listen((mode) {
          displayMode.value = mode;
          _deviceRepo.saveLocalDisplayMode(mode);
        });
  }

  Future<void> _onSettingsUpdated(DeviceSettingsEntity newSettings) async {
    await _deviceRepo.saveLocalSettings(newSettings);

    // Update prayer controller with new settings
    if (Get.isRegistered<PrayerController>()) {
      Get.find<PrayerController>().onSettingsChanged(newSettings);
    }
  }

  /// Manual setup without Supabase (offline mode)
  Future<void> saveManualSettings({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    required dynamic calculationMethod,
    required int madhab,
    DisplayMode? displayMode,
    String? language,
    Map<String, int>? adjustments,
  }) async {
    // Cancel any active Supabase listeners (e.g. from a previous QR pairing
    // attempt or a previous dashboard pairing) to prevent them from
    // overwriting manual settings.
    _settingsSubscription?.cancel();
    _settingsSubscription = null;
    _displayModeSubscription?.cancel();
    _displayModeSubscription = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _settingsPollTimer?.cancel();
    _settingsPollTimer = null;

    // Clear any stored token/device so listeners won't reconnect on restart
    device.value = null;
    token.value = '';
    isPaired.value = false;
    await _deviceRepo.clearLocalToken();

    final methodValue = calculationMethod is CalculationMethodType
        ? calculationMethod.value
        : calculationMethod?.toString() ?? 'umm_al_qura';
    final newSettings = DeviceSettingsEntity(
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
      calculationMethod: methodValue,
      madhab: madhab,
      adjustments: adjustments ?? settings.value?.adjustments ?? {},
      language: language ?? settings.value?.language ?? 'ar',
    );

    settings.value = newSettings;
    await _deviceRepo.saveLocalSettings(newSettings);
    isSetupComplete.value = true;

    // Apply display mode if provided
    if (displayMode != null) {
      this.displayMode.value = displayMode;
      await _deviceRepo.saveLocalDisplayMode(displayMode);
    }

    // Apply language if provided
    if (language != null) {
      final locale = Locale(language);
      Get.updateLocale(locale);
      GetStorage().write('LOCALE', language);
    }

    // Update prayer times
    if (Get.isRegistered<PrayerController>()) {
      Get.find<PrayerController>().onSettingsChanged(newSettings);
    }
  }

  Future<void> changeDisplayMode(DisplayMode mode) async {
    displayMode.value = mode;
    await _deviceRepo.saveLocalDisplayMode(mode);

    if (device.value != null) {
      try {
        await _deviceRepo.updateDisplayMode(device.value!.id, mode);
      } catch (_) {}
    }
  }

  Future<void> updateAdjustments(Map<String, int> adjustments) async {
    final current = settings.value;
    if (current == null) return;
    final updated = current.copyWith(adjustments: adjustments);
    settings.value = updated;
    await _deviceRepo.saveLocalSettings(updated);

    // Push to Supabase if online
    if (device.value != null) {
      try {
        await _deviceRepo.updateSettings(device.value!.id, updated);
      } catch (_) {}
    }

    // Recalculate prayers
    if (Get.isRegistered<PrayerController>()) {
      Get.find<PrayerController>().onSettingsChanged(updated);
    }
  }

  Future<void> updateHadithInterval(int minutes) async {
    final current = settings.value;
    if (current == null) return;
    final updated = current.copyWith(hadithInterval: minutes);
    settings.value = updated;
    await _deviceRepo.saveLocalSettings(updated);

    // Push to Supabase if online
    if (device.value != null) {
      try {
        await _deviceRepo.updateSettings(device.value!.id, updated);
      } catch (_) {}
    }
  }

  Future<void> resetDevice() async {
    _settingsSubscription?.cancel();
    _displayModeSubscription?.cancel();
    _heartbeatTimer?.cancel();
    _settingsPollTimer?.cancel();
    await _deviceRepo.clearAllLocalData();

    device.value = null;
    settings.value = null;
    displayMode.value = DisplayMode.prayerTimes;
    token.value = '';
    isPaired.value = false;
    isSetupComplete.value = false;

    Get.offAllNamed('/onboarding');
  }

  /// Get calculation method based on country from madhabV2.json
  Future<CalculationMethodType> getMethodForCountry(String country) async {
    return _prayerRepo.getCalculationMethodForCountry(country);
  }
}
