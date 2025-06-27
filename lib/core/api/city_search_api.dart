import 'dart:convert';
import 'package:easyweather/app_constants.dart';
import 'package:flutter/foundation.dart';
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
    kDebugMode ? debugPrint('locale: $locale') : null;
    if (locale.languageCode == 'zh_CN') {
      acceptLanguage = 'zh-Hans';
    } else if (locale.languageCode == 'zh_TW') {
      acceptLanguage = 'zh_Hant';
    } else if (locale.languageCode == 'en_US' || locale.languageCode == 'en') {
      acceptLanguage = 'en';
    }

    final url = Uri.parse(
        '$baseUrl?format=json&q=$query&accept-language=$acceptLanguage&limit=30&addressdetails=1');
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
