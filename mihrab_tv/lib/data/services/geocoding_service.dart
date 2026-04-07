import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingResult {
  final double latitude;
  final double longitude;
  final String displayName;

  const GeocodingResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });
}

class GeocodingService {
  /// Search for places by name using Nominatim (OpenStreetMap).
  /// Free, no API key required. Supports Arabic and other languages.
  static Future<List<GeocodingResult>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('https://nominatim.openstreetmap.org/search').replace(
      queryParameters: {
        'q': query.trim(),
        'format': 'json',
        'limit': '5',
        'accept-language': 'ar,en',
      },
    );

    final response = await http
        .get(
          uri,
          headers: {
            'User-Agent': 'MihrabApp/1.0',
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Geocoding request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as List;

    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return GeocodingResult(
        latitude: double.parse(map['lat'] as String),
        longitude: double.parse(map['lon'] as String),
        displayName: map['display_name'] as String? ?? '',
      );
    }).toList();
  }
}
