/// Settings for a paired TV device
class DeviceSettingsEntity {
  final String? id;
  final String? deviceId;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;
  final String? calculationMethod;
  final int? madhab; // 0=Shafi, 1=Hanafi
  final int? highLatitudeRule;
  final Map<String, int>? adjustments;
  final String? language;
  final bool? isDarkMode;
  final int? hadithInterval;
  final int? hadithFontSize;
  final String? theme;
  final DateTime? updatedAt;

  const DeviceSettingsEntity({
    this.id,
    this.deviceId,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.calculationMethod,
    this.madhab = 0,
    this.highLatitudeRule = 0,
    this.adjustments = const {},
    this.language = 'ar',
    this.isDarkMode = false,
    this.hadithInterval = 15,
    this.hadithFontSize = 3,
    this.theme = 'classic',
    this.updatedAt,
  });

  factory DeviceSettingsEntity.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsEntity(
      id: json['id'] as String?,
      deviceId: json['device_id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      city: json['city'] as String?,
      country: json['country'] as String?,
      calculationMethod: json['calculation_method'] as String?,
      madhab: json['madhab'] as int?,
      highLatitudeRule: json['high_latitude_rule'] as int?,
      adjustments: json['adjustments'] != null
          ? Map<String, int>.from(json['adjustments'])
          : null,
      language: json['language'] as String? ?? 'ar',
      isDarkMode: json['is_dark_mode'] as bool? ?? false,
      hadithInterval: json['hadith_interval'] as int? ?? 15,
      hadithFontSize: json['hadith_font_size'] as int? ?? 3,
      theme: json['theme'] as String? ?? 'classic',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'calculation_method': calculationMethod,
      'madhab': madhab,
      'high_latitude_rule': highLatitudeRule,
      'adjustments': adjustments,
      'language': language,
      'is_dark_mode': isDarkMode,
      'hadith_interval': hadithInterval,
      'hadith_font_size': hadithFontSize,
      'theme': theme,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DeviceSettingsEntity copyWith({
    String? id,
    String? deviceId,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? calculationMethod,
    int? madhab,
    int? highLatitudeRule,
    Map<String, int>? adjustments,
    String? language,
    bool? isDarkMode,
    int? hadithInterval,
    int? hadithFontSize,
    String? theme,
    DateTime? updatedAt,
  }) {
    return DeviceSettingsEntity(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
      adjustments: adjustments ?? this.adjustments,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      hadithInterval: hadithInterval ?? this.hadithInterval,
      hadithFontSize: hadithFontSize ?? this.hadithFontSize,
      theme: theme ?? this.theme,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
