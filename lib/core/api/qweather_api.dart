import 'dart:convert';
import 'package:zephyr/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/weather_warning.dart';
import '../notifiers.dart';
import '../utils/locale_language_map.dart';
import '../languages.dart';

class QWeatherApi {
  // 获取天气预警信息
  static Future<List<WeatherWarning>> fetchWarning({
    required double lat,
    required double lon,
  }) async {
    // 获取当前locale并映射为QWeather支持的lang
    String qweatherLang = 'en';
    final localeKey =
        appLanguages.firstWhere((l) => l.code == localeCodeNotifier.value).code;
    qweatherLang = localeToApiLang[localeKey] ?? 'en';
    final url = Uri.parse(
      '${AppConstants.qWeatherWarningUrl}?location=$lon,$lat&lang=$qweatherLang',
    );
    if (kDebugMode) debugPrint('QWeather warning url: $url');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['code'] == '200') {
          final List warnings = data['warning'] ?? [];
          return warnings.map((e) => WeatherWarning.fromJson(e)).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('QWeather warning fetch error: $e');
    }
    return [];
  }
}
