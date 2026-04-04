import 'package:mihrab_shared/mihrab_shared.dart';

abstract class WebDeviceRepository {
  Future<DeviceEntity?> getDeviceByToken(String token);
  Future<List<DeviceEntity>> getLinkedDevices();
  Future<void> updateSettings(String deviceId, DeviceSettingsEntity settings);
  Future<void> updateDisplayMode(String deviceId, DisplayMode mode);
  Future<void> updateDeviceName(String deviceId, String name);
  Future<void> deleteDevice(String deviceId);
  Future<void> saveLinkedDeviceIds(List<String> ids);
  List<String> getLinkedDeviceIds();
}
