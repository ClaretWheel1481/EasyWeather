import 'dart:convert';
import 'package:http/http.dart' as http;

class CitySearchResult {
  final String name;
  final double lat;
  final double lon;

  CitySearchResult({required this.name, required this.lat, required this.lon});
}

class CitySearchService {
  static Future<List<CitySearchResult>> searchCity(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query&accept-language=zh-CN&limit=10');
    final response =
        await http.get(url, headers: {'User-Agent': 'EasyWeatherApp/1.0'});
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
