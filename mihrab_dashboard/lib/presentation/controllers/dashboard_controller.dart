import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mihrab_shared/mihrab_shared.dart';

import '../../domain/repositories/dashboard_device_repository.dart';

class DashboardController extends GetxController {
  final DashboardDeviceRepository _repo;

  DashboardController(this._repo);

  final devices = <DeviceEntity>[].obs;
  final selectedDevice = Rxn<DeviceEntity>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Location
  final currentCity = ''.obs;
  final currentCountry = ''.obs;
  final currentLat = 0.0.obs;
  final currentLng = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLinkedDevices();
  }

  Future<void> _loadLinkedDevices() async {
    final ids = _repo.getLinkedDeviceIds();
    if (ids.isEmpty) return;

    isLoading.value = true;
    try {
      final list = await _repo.getLinkedDevices();
      devices.assignAll(list);
      if (devices.isNotEmpty) {
        selectedDevice.value = devices.first;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Pair with a TV device using the scanned token
  Future<bool> pairDevice(String token) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final device = await _repo.getDeviceByToken(token);
      if (device == null) {
        errorMessage.value = AppStrings.deviceNotFound;
        return false;
      }

      // Add to linked devices
      devices.add(device);
      selectedDevice.value = device;

      // Save locally
      final ids = devices.map((d) => d.id).toList();
      await _repo.saveLinkedDeviceIds(ids);

      // Auto-detect location and push settings
      await _detectAndPushLocation(device.id);

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Whether auto-location detection succeeded during pairing
  final locationDetected = false.obs;

  Future<void> _detectAndPushLocation(String deviceId) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('📱 Location permission denied');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        currentCity.value = placemarks.first.locality ?? '';
        currentCountry.value = placemarks.first.country ?? '';
      }

      final settings = DeviceSettingsEntity(
        id: '',
        deviceId: deviceId,
        latitude: position.latitude,
        longitude: position.longitude,
        city: currentCity.value,
        country: currentCountry.value,
        calculationMethod: _getMethodForCountry(currentCountry.value),
      );

      await _repo.updateSettings(deviceId, settings);
      locationDetected.value = true;
      debugPrint(
        '📱 Settings pushed: lat=${position.latitude}, lng=${position.longitude}',
      );

      // Refresh selectedDevice with new settings
      final old = selectedDevice.value;
      if (old != null) {
        selectedDevice.value = DeviceEntity(
          id: old.id,
          token: old.token,
          name: old.name,
          displayMode: old.displayMode,
          createdAt: old.createdAt,
          lastSeenAt: old.lastSeenAt,
          settings: settings,
        );
        final idx = devices.indexWhere((d) => d.id == old.id);
        if (idx != -1) devices[idx] = selectedDevice.value!;
      }
    } catch (e) {
      debugPrint('📱 _detectAndPushLocation ERROR: $e');
      locationDetected.value = false;
    }
  }

  String _getMethodForCountry(String country) {
    // Simplified mapping — full mapping is in madhabV2.json on TV side
    const mapping = {
      'Saudi Arabia': 'umm_al_qura',
      'المملكة العربية السعودية': 'umm_al_qura',
      'Egypt': 'egyptian',
      'مصر': 'egyptian',
      'United Arab Emirates': 'dubai',
      'الإمارات': 'dubai',
      'Kuwait': 'kuwait',
      'الكويت': 'kuwait',
      'Qatar': 'qatar',
      'قطر': 'qatar',
      'Turkey': 'turkey',
      'تركيا': 'turkey',
      'Pakistan': 'karachi',
      'باكستان': 'karachi',
    };
    return mapping[country] ?? 'umm_al_qura';
  }

  Future<void> updateDeviceSettings(DeviceSettingsEntity settings) async {
    if (selectedDevice.value == null) return;
    isLoading.value = true;
    try {
      await _repo.updateSettings(selectedDevice.value!.id, settings);
      // Refresh the selected device with updated settings
      final old = selectedDevice.value!;
      selectedDevice.value = DeviceEntity(
        id: old.id,
        token: old.token,
        name: old.name,
        displayMode: old.displayMode,
        createdAt: old.createdAt,
        lastSeenAt: old.lastSeenAt,
        settings: settings,
      );
      // Also update in devices list
      final idx = devices.indexWhere((d) => d.id == old.id);
      if (idx != -1) {
        devices[idx] = selectedDevice.value!;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeviceDisplayMode(DisplayMode mode) async {
    if (selectedDevice.value == null) return;
    try {
      await _repo.updateDisplayMode(selectedDevice.value!.id, mode);
      // Refresh the selected device with updated display mode
      final old = selectedDevice.value!;
      selectedDevice.value = DeviceEntity(
        id: old.id,
        token: old.token,
        name: old.name,
        displayMode: mode.value,
        createdAt: old.createdAt,
        lastSeenAt: old.lastSeenAt,
        settings: old.settings,
      );
      final idx = devices.indexWhere((d) => d.id == old.id);
      if (idx != -1) {
        devices[idx] = selectedDevice.value!;
      }
    } catch (_) {}
  }

  void selectDevice(DeviceEntity device) {
    selectedDevice.value = device;
  }

  Future<void> updateDeviceName(String name) async {
    final old = selectedDevice.value;
    if (old == null) return;
    try {
      await _repo.updateDeviceName(old.id, name);
      selectedDevice.value = DeviceEntity(
        id: old.id,
        token: old.token,
        name: name,
        displayMode: old.displayMode,
        createdAt: old.createdAt,
        lastSeenAt: old.lastSeenAt,
        settings: old.settings,
      );
      final idx = devices.indexWhere((d) => d.id == old.id);
      if (idx != -1) {
        devices[idx] = selectedDevice.value!;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> removeDevice(String deviceId) async {
    isLoading.value = true;
    try {
      await _repo.deleteDevice(deviceId);
      devices.removeWhere((d) => d.id == deviceId);
      if (selectedDevice.value?.id == deviceId) {
        selectedDevice.value = devices.isNotEmpty ? devices.first : null;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
