import 'dart:convert';
import 'package:zephyr/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../notifiers.dart';
import '../utils/locale_language_map.dart';
import '../languages.dart';

class CitySearchApi {
  static Future<List<City>> searchCity(String query) async {
    // 根据当前语言设置API请求的语言参数
    String acceptLanguage = 'en-US';
    final locale = appLanguages
        .firstWhere((l) => l.code == localeCodeNotifier.value)
        .locale;
    final localeKey =
        appLanguages.firstWhere((l) => l.code == localeCodeNotifier.value).code;
    acceptLanguage = localeToApiLang[localeKey] ?? 'en-US';
    kDebugMode
        ? debugPrint('locale: $locale, acceptLanguage: $acceptLanguage')
        : null;

    final url = Uri.parse(
        '${AppConstants.osmUrl}?format=json&q=$query&accept-language=$acceptLanguage&limit=30&addressdetails=1&featureType=city');
    final response = await http.get(url, headers: {
      'User-Agent': '${AppConstants.appName}/${AppConstants.appVersion}'
    });
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
