import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final SupabaseClient _supabase;
  final GetStorage _storage;

  static const _tokenKey = 'device_token';
  static const _settingsKey = 'device_settings';
  static const _displayModeKey = 'display_mode';
  static const _deviceIdKey = 'device_id';

  DeviceRepositoryImpl(this._supabase, this._storage);

  @override
  Future<DeviceEntity> registerDevice(String token) async {
    // Use the register_device SQL function to create both device + settings rows
    final deviceId = await _supabase.rpc(
      'register_device',
      params: {'p_token': token},
    );

    // Update device name and display mode
    await _supabase
        .from('devices')
        .update({
          'name': 'Mihrab TV',
          'display_mode': DisplayMode.prayerTimes.value,
          'last_seen_at': DateTime.now().toIso8601String(),
        })
        .eq('id', deviceId);

    // Fetch the full device row
    final response = await _supabase
        .from('devices')
        .select()
        .eq('id', deviceId)
        .single();

    final device = DeviceEntity.fromJson(response);
    await _storage.write(_deviceIdKey, device.id);
    return device;
  }

  @override
  Future<DeviceEntity?> getDeviceByToken(String token) async {
    final response = await _supabase
        .from('devices')
        .select()
        .eq('token', token)
        .maybeSingle();

    if (response == null) return null;
    return DeviceEntity.fromJson(response);
  }

  @override
  Future<void> updateSettings(
    String deviceId,
    DeviceSettingsEntity settings,
  ) async {
    final data = {
      'device_id': deviceId,
      'latitude': settings.latitude,
      'longitude': settings.longitude,
      'city': settings.city,
      'country': settings.country,
      'calculation_method': settings.calculationMethod,
      'madhab': settings.madhab,
      'high_latitude_rule': settings.highLatitudeRule,
      'adjustments': settings.adjustments,
      'language': settings.language,
      'is_dark_mode': settings.isDarkMode,
      'hadith_interval': settings.hadithInterval,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase
        .from('device_settings')
        .upsert(data, onConflict: 'device_id');

    await saveLocalSettings(settings);
  }

  @override
  Future<DeviceSettingsEntity?> getSettings(String deviceId) async {
    final response = await _supabase
        .from('device_settings')
        .select()
        .eq('device_id', deviceId)
        .maybeSingle();
    if (response == null) return null;
    return DeviceSettingsEntity(
      id: response['id'] as String?,
      deviceId: response['device_id'] as String?,
      latitude: (response['latitude'] as num?)?.toDouble(),
      longitude: (response['longitude'] as num?)?.toDouble(),
      city: response['city'] as String?,
      country: response['country'] as String?,
      calculationMethod: response['calculation_method'] as String?,
      madhab: response['madhab'] as int?,
      highLatitudeRule: response['high_latitude_rule'] as int?,
      adjustments: response['adjustments'] != null
          ? Map<String, int>.from(response['adjustments'])
          : null,
      language: response['language'] as String? ?? 'ar',
      isDarkMode: response['is_dark_mode'] as bool? ?? false,
      hadithInterval: response['hadith_interval'] as int? ?? 15,
    );
  }

  @override
  Future<void> updateDisplayMode(String deviceId, DisplayMode mode) async {
    await _supabase
        .from('devices')
        .update({'display_mode': mode.value})
        .eq('id', deviceId);
    await saveLocalDisplayMode(mode);
  }

  @override
  Stream<DeviceSettingsEntity> listenToSettingsChanges(String deviceId) {
    return _supabase
        .from('device_settings')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .map((rows) {
          if (rows.isEmpty) {
            return DeviceSettingsEntity();
          }
          final row = rows.first;
          final settings = DeviceSettingsEntity(
            id: row['id'] as String?,
            deviceId: row['device_id'] as String?,
            latitude: (row['latitude'] as num?)?.toDouble(),
            longitude: (row['longitude'] as num?)?.toDouble(),
            city: row['city'] as String?,
            country: row['country'] as String?,
            calculationMethod: row['calculation_method'] as String?,
            madhab: row['madhab'] as int?,
            highLatitudeRule: row['high_latitude_rule'] as int?,
            adjustments: row['adjustments'] != null
                ? Map<String, int>.from(row['adjustments'])
                : null,
            language: row['language'] as String? ?? 'ar',
            isDarkMode: row['is_dark_mode'] as bool? ?? false,
            hadithInterval: row['hadith_interval'] as int? ?? 15,
          );
          // Save locally for offline use
          saveLocalSettings(settings);
          return settings;
        });
  }

  @override
  Stream<DisplayMode> listenToDisplayModeChanges(String deviceId) {
    return _supabase
        .from('devices')
        .stream(primaryKey: ['id'])
        .eq('id', deviceId)
        .map((rows) {
          if (rows.isEmpty) return DisplayMode.prayerTimes;
          final value = rows.first['display_mode'] as String?;
          return DisplayMode.values.firstWhere(
            (e) => e.value == value,
            orElse: () => DisplayMode.prayerTimes,
          );
        });
  }

  @override
  Future<void> heartbeat(String deviceId) async {
    await _supabase
        .from('devices')
        .update({'last_seen_at': DateTime.now().toIso8601String()})
        .eq('id', deviceId);
  }

  @override
  String? getLocalToken() => _storage.read<String>(_tokenKey);

  @override
  Future<void> saveLocalToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  @override
  DeviceSettingsEntity? getLocalSettings() {
    final raw = _storage.read(_settingsKey);
    if (raw == null) return null;
    try {
      return DeviceSettingsEntity.fromJson(
        Map<String, dynamic>.from(raw is String ? jsonDecode(raw) : raw),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLocalSettings(DeviceSettingsEntity settings) async {
    await _storage.write(_settingsKey, settings.toJson());
  }

  @override
  DisplayMode getLocalDisplayMode() {
    final value = _storage.read<String>(_displayModeKey);
    if (value == null) return DisplayMode.prayerTimes;
    return DisplayMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DisplayMode.prayerTimes,
    );
  }

  @override
  Future<void> saveLocalDisplayMode(DisplayMode mode) async {
    await _storage.write(_displayModeKey, mode.value);
  }

  @override
  Future<void> clearAllLocalData() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_settingsKey);
    await _storage.remove(_displayModeKey);
    await _storage.remove(_deviceIdKey);
  }

  @override
  Future<void> clearLocalToken() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_deviceIdKey);
  }
}
