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
  /// Detect location using IP-based geolocation.
  /// Uses ipapi.co (HTTPS, free 1k req/day).
  static Future<IpLocationResult> detect() async {
    final uri = Uri.parse('https://ipapi.co/json/');
    final response = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('IP location request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data.containsKey('error') && data['error'] == true) {
      throw Exception(
        'IP location failed: ${data['reason'] ?? 'unknown error'}',
      );
    }

    return IpLocationResult(
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      city: data['city'] as String? ?? '',
      country: data['country_name'] as String? ?? '',
    );
  }
}
