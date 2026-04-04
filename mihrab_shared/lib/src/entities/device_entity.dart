import 'device_settings_entity.dart';

/// Represents a registered TV device
class DeviceEntity {
  final String id;
  final String token;
  final String? name;
  final String displayMode;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final DeviceSettingsEntity? settings;

  const DeviceEntity({
    required this.id,
    required this.token,
    this.name,
    required this.displayMode,
    required this.createdAt,
    this.lastSeenAt,
    this.settings,
  });

  factory DeviceEntity.fromJson(Map<String, dynamic> json) {
    return DeviceEntity(
      id: json['id'] as String,
      token: json['token'] as String,
      name: json['name'] as String?,
      displayMode: json['display_mode'] as String? ?? 'prayer_times',
      createdAt: DateTime.parse(json['created_at']),
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.parse(json['last_seen_at'])
          : null,
      settings: json['device_settings'] != null
          ? DeviceSettingsEntity.fromJson(
              json['device_settings'] is List
                  ? (json['device_settings'] as List).first
                  : json['device_settings'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'name': name,
      'display_mode': displayMode,
      'created_at': createdAt.toIso8601String(),
      'last_seen_at': lastSeenAt?.toIso8601String(),
    };
  }
}
