import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class CitySearchApi {
  static const String baseUrl = 'https://nominatim.openstreetmap.org/search';
  static Future<List<City>> searchCity(String query) async {
    final url = Uri.parse(
        '$baseUrl?format=json&q=$query&accept-language=zh-CN&limit=10&addressdetails=1');
    final response =
        await http.get(url, headers: {'User-Agent': 'EasyWeatherApp/2.0'});
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map((item) {
            final address = item['address'] ?? {};
            String name = item['display_name'] ?? '';
            String? admin = address['state'];
            String country = address['country'] ?? '';
            return City(
              name: name,
              admin: admin,
              country: country,
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
