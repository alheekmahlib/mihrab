import 'dart:convert';

import 'package:http/http.dart' as http;

class NominatimService {
  static Future<Map<String, String>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
      '?lat=$latitude&lon=$longitude&format=json&accept-language=en',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'MihrabApp/1.0'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final address = data['address'] as Map<String, dynamic>? ?? {};
      return {
        'city':
            address['city'] as String? ??
            address['town'] as String? ??
            address['village'] as String? ??
            '',
        'country': address['country'] as String? ?? '',
      };
    }
    return {'city': '', 'country': ''};
  }
}
