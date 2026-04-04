import 'package:mihrab_shared/mihrab_shared.dart';

abstract class DeviceRepository {
  /// Register a new TV device with a generated token
  Future<DeviceEntity> registerDevice(String token);

  /// Get device by token
  Future<DeviceEntity?> getDeviceByToken(String token);

  /// Update device settings
  Future<void> updateSettings(String deviceId, DeviceSettingsEntity settings);

  /// Fetch device settings by device ID (one-shot)
  Future<DeviceSettingsEntity?> getSettings(String deviceId);

  /// Update display mode
  Future<void> updateDisplayMode(String deviceId, DisplayMode mode);

  /// Listen to real-time settings changes
  Stream<DeviceSettingsEntity> listenToSettingsChanges(String deviceId);

  /// Listen to real-time display mode changes
  Stream<DisplayMode> listenToDisplayModeChanges(String deviceId);

  /// Update device heartbeat (last_seen_at)
  Future<void> heartbeat(String deviceId);

  /// Get locally stored device token
  String? getLocalToken();

  /// Store device token locally
  Future<void> saveLocalToken(String token);

  /// Get locally stored settings (for offline use)
  DeviceSettingsEntity? getLocalSettings();

  /// Save settings locally
  Future<void> saveLocalSettings(DeviceSettingsEntity settings);

  /// Get locally stored display mode
  DisplayMode getLocalDisplayMode();

  /// Save display mode locally
  Future<void> saveLocalDisplayMode(DisplayMode mode);

  /// Clear all local data (for re-pairing)
  Future<void> clearAllLocalData();

  /// Clear only the local token (for switching to manual mode)
  Future<void> clearLocalToken();
}
