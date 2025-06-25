import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../notifiers.dart';
import '../../app.dart'; // 确保引入了 supportedLocales

class CitySearchApi {
  static const String baseUrl = 'https://nominatim.openstreetmap.org/search';

  static Future<List<City>> searchCity(String query) async {
    // 根据当前语言设置API请求的语言参数
    String acceptLanguage = 'en-US'; // 默认英语
    final locale = supportedLocales[localeIndexNotifier.value];
    if (locale.languageCode == 'zh') {
      acceptLanguage = 'zh-CN';
    } else if (locale.languageCode == 'en') {
      acceptLanguage = 'en-US';
    }

    final url = Uri.parse(
        '$baseUrl?format=json&q=$query&accept-language=$acceptLanguage&limit=10&addressdetails=1');
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
