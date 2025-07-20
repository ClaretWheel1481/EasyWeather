import 'dart:convert';
import 'package:zephyr/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class OpenMeteoApi {
  // 获取天气数据
  static Future<WeatherData?> fetchWeather({
    required double latitude,
    required double longitude,
    String lang = 'zh',
    String units = 'metric',
  }) async {
    try {
      // 并行获取天气数据和空气质量数据
      final weatherFuture = _fetchWeatherData(latitude, longitude, lang, units);
      final airQualityFuture = _fetchAirQualityData(latitude, longitude);

      final results = await Future.wait([weatherFuture, airQualityFuture]);
      final weatherJson = results[0];
      final airQualityJson = results[1];

      if (weatherJson != null) {
        // 将空气质量数据合并到天气数据中
        if (airQualityJson != null && airQualityJson['current'] != null) {
          weatherJson['current']['pm25'] = airQualityJson['current']['pm2_5'];
          weatherJson['current']['pm10'] = airQualityJson['current']['pm10'];
        }
        return WeatherData.fromJson(weatherJson);
      }
    } catch (e) {
      kDebugMode ? debugPrint('Error fetching weather data: $e') : null;
    }
    return null;
  }

  // 获取天气数据
  static Future<Map<String, dynamic>?> _fetchWeatherData(
    double latitude,
    double longitude,
    String lang,
    String units,
  ) async {
    final url = Uri.parse('${AppConstants.omForecastUrl}'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=apparent_temperature,temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m,winddirection_10m,surface_pressure'
        '&hourly=weather_code,temperature_2m,precipitation,visibility,wind_speed_10m,wind_speed_80m,wind_speed_120m'
        '&daily=temperature_2m_max,temperature_2m_min,weather_code,uv_index_max'
        '&timezone=auto'
        '&lang=$lang'
        '&temperature_unit=${units == 'imperial' ? 'fahrenheit' : 'celsius'}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      kDebugMode ? debugPrint('Weather API response: ${response.body}') : null;
      return json.decode(response.body);
    }
    return null;
  }

  // 获取空气质量数据
  static Future<Map<String, dynamic>?> _fetchAirQualityData(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse('${AppConstants.omAirQualityUrl}'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=pm2_5,pm10');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      kDebugMode
          ? debugPrint('Air Quality API response: ${response.body}')
          : null;
      return json.decode(response.body);
    }
    return null;
  }
}
