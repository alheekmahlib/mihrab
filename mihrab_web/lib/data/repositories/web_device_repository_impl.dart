import 'package:get_storage/get_storage.dart';
import 'package:mihrab_shared/mihrab_shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/web_device_repository.dart';

class WebDeviceRepositoryImpl implements WebDeviceRepository {
  final SupabaseClient _client;
  final _storage = GetStorage();

  static const _linkedDevicesKey = 'LINKED_DEVICE_IDS';

  WebDeviceRepositoryImpl(this._client);

  @override
  Future<DeviceEntity?> getDeviceByToken(String token) async {
    final response = await _client
        .from('devices')
        .select('*, device_settings(*)')
        .eq('token', token)
        .maybeSingle();

    if (response == null) return null;
    return DeviceEntity.fromJson(response);
  }

  @override
  Future<List<DeviceEntity>> getLinkedDevices() async {
    final ids = getLinkedDeviceIds();
    if (ids.isEmpty) return [];

    final response = await _client
        .from('devices')
        .select('*, device_settings(*)')
        .inFilter('id', ids);

    return (response as List)
        .map((e) => DeviceEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateSettings(
    String deviceId,
    DeviceSettingsEntity settings,
  ) async {
    final data = settings.toJson()
      ..remove('id')
      ..remove('updated_at');
    data['device_id'] = deviceId;

    await _client.from('device_settings').upsert(data, onConflict: 'device_id');
  }

  @override
  Future<void> updateDisplayMode(String deviceId, DisplayMode mode) async {
    await _client
        .from('devices')
        .update({'display_mode': mode.value})
        .eq('id', deviceId);
  }

  @override
  Future<void> updateDeviceName(String deviceId, String name) async {
    await _client.from('devices').update({'name': name}).eq('id', deviceId);
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await _client.from('devices').delete().eq('id', deviceId);

    final ids = getLinkedDeviceIds();
    ids.remove(deviceId);
    await saveLinkedDeviceIds(ids);
  }

  @override
  Future<void> saveLinkedDeviceIds(List<String> ids) async {
    await _storage.write(_linkedDevicesKey, ids);
  }

  @override
  List<String> getLinkedDeviceIds() {
    final raw = _storage.read<List>(_linkedDevicesKey);
    return raw?.cast<String>() ?? [];
  }
}
