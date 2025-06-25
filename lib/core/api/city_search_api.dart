import 'dart:convert';
import 'package:easyweather/app_constants.dart';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class CitySearchResult {
  final String name;
  final double lat;
  final double lon;

  CitySearchResult({required this.name, required this.lat, required this.lon});
}

class CitySearchApi {
  static const String baseUrl = 'https://nominatim.openstreetmap.org/search';
  static Future<List<CitySearchResult>> searchCity(String query) async {
    final url = Uri.parse(
        '$baseUrl?format=json&q=$query&accept-language=zh-CN&limit=10');
    final response = await http.get(url, headers: {
      'User-Agent': '${AppConstants.appName}/${AppConstants.appVersion}'
    });
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map((item) {
            return CitySearchResult(
              name: item['display_name'] ?? '',
              lat: double.tryParse(item['lat'] ?? '') ?? 0,
              lon: double.tryParse(item['lon'] ?? '') ?? 0,
            );
          })
          .where((e) => e.lat != 0 && e.lon != 0)
          .toList();
    }
    return [];
  }
}
