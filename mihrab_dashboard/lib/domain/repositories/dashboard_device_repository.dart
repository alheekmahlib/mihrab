import 'package:mihrab_shared/mihrab_shared.dart';

abstract class DashboardDeviceRepository {
  /// Link phone to TV device by token
  Future<DeviceEntity?> getDeviceByToken(String token);

  /// Get all devices linked to this phone
  Future<List<DeviceEntity>> getLinkedDevices();

  /// Update settings for a device
  Future<void> updateSettings(String deviceId, DeviceSettingsEntity settings);

  /// Update display mode for a device
  Future<void> updateDisplayMode(String deviceId, DisplayMode mode);

  /// Update device name
  Future<void> updateDeviceName(String deviceId, String name);

  /// Delete a device from Supabase and local storage
  Future<void> deleteDevice(String deviceId);

  /// Save linked device IDs locally
  Future<void> saveLinkedDeviceIds(List<String> ids);

  /// Get locally saved device IDs
  List<String> getLinkedDeviceIds();
}
