import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr/core/services/widget_service.dart';
import '../models/city.dart';
import '../api/open_meteo_api.dart';
import 'weather_cache.dart';
import 'package:flutter/foundation.dart';
import '../api/alerts_api.dart';
import 'package:zephyr/core/notifiers.dart';

class WeatherFetchService {
  static DateTime? _lastFetchTime;

  // 获取并缓存天气数据
  // 由原生Android服务调用，每15分钟执行一次
  static Future<void> fetchAndCacheWeather() async {
    try {
      // 检查是否在短时间内重复调用
      final now = DateTime.now();
      if (_lastFetchTime != null &&
          now.difference(_lastFetchTime!) < const Duration(minutes: 13)) {
        if (kDebugMode) debugPrint('天气获取过于频繁，跳过本次获取');
        return;
      }
      _lastFetchTime = now;

      if (kDebugMode) debugPrint('开始获取天气数据...');

      final prefs = await SharedPreferences.getInstance();
      final citiesStr = prefs.getString('cities');
      if (citiesStr == null) {
        if (kDebugMode) debugPrint('没有配置城市信息');
        return;
      }

      final cities = City.listFromJson(citiesStr);
      if (cities.isEmpty) {
        if (kDebugMode) debugPrint('城市列表为空');
        return;
      }

      final mainCity = cities.first;
      if (kDebugMode) debugPrint('获取城市天气: ${mainCity.name}');

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

      // 拉取天气预警
      final warnings = await WeatherAlertApi.fetchWarning(
        lat: mainCity.lat,
        lon: mainCity.lon,
      );
      if (warnings.isNotEmpty) {
        for (final warning in warnings) {
          if (kDebugMode) {
            debugPrint(
                '天气预警: ${warning.title} - ${warning.level}\n${warning.text}');
          }
        }
      } else {
        if (kDebugMode) debugPrint('天气预警获取失败或无预警');
      }

      if (weather != null) {
        await cacheWeather(mainCity, weather, warnings);
        if (kDebugMode) debugPrint('天气数据获取并缓存成功');
        WidgetService.updateWidget(city: mainCity, weatherData: weather);
      } else {
        if (kDebugMode) debugPrint('天气数据获取失败');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('获取天气失败: $e');
    }
  }

  // 强制获取天气数据
  static Future<void> forceFetchWeather() async {
    _lastFetchTime = null; // 重置时间限制
    await fetchAndCacheWeather();
    weatherDataChangedNotifier.value++;
  }
}
