import 'dart:convert';

import 'package:http/http.dart' as http;

class IpLocationResult {
  final double latitude;
  final double longitude;
  final String city;
  final String country;

  const IpLocationResult({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });
}

class IpLocationService {
  /// Detect location using IP-based geolocation (ip-api.com).
  /// Free tier: HTTP only, 45 req/min.
  static Future<IpLocationResult> detect() async {
    final uri = Uri.parse(
      'http://ip-api.com/json/?fields=status,message,country,city,lat,lon',
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('IP location request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['status'] != 'success') {
      throw Exception(
        'IP location failed: ${data['message'] ?? 'unknown error'}',
      );
    }

    return IpLocationResult(
      latitude: (data['lat'] as num).toDouble(),
      longitude: (data['lon'] as num).toDouble(),
      city: data['city'] as String? ?? '',
      country: data['country'] as String? ?? '',
    );
  }
}
