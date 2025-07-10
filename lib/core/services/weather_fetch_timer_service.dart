import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../api/open_meteo_api.dart';
import 'weather_cache.dart';
import 'package:flutter/foundation.dart';

class WeatherFetchTimerService {
  static Timer? _timer;
  static const Duration _interval = Duration(minutes: 5);

  static void start() {
    stop();
    _timer = Timer.periodic(_interval, (timer) {
      fetchAndCacheWeather();
    });
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> fetchAndCacheWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final citiesStr = prefs.getString('cities');
      if (citiesStr == null) return;
      final cities = City.listFromJson(citiesStr);
      if (cities.isEmpty) return;
      final mainCity = cities.first;

      // 获取当前语言和单位
      final localeIndex = prefs.getInt('locale_index') ?? 0;
      final languageCode = localeIndex == 0 ? 'en' : 'zh';
      final tempUnit = prefs.getString('temp_unit') ?? 'C';
      final units = tempUnit == 'F' ? 'imperial' : 'metric';

      // 拉取天气数据
      final weather = await OpenMeteoApi.fetchWeather(
        latitude: mainCity.lat,
        longitude: mainCity.lon,
        lang: languageCode,
        units: units,
      );
      if (weather != null) {
        await cacheWeather(mainCity, weather);
      }
    } catch (e) {
      if (kDebugMode) print('定时获取天气失败: $e');
    }
  }
}
